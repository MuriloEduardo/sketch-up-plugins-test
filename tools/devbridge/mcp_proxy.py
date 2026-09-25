#!/usr/bin/env python3
"""MCP stdio server for DEVELOPMENT that forwards every message to the V-Ray
Toolkit MCP tools running in SketchUp on the remote desktop, through the Dev
Bridge SSH tunnel (the same one `tools/devbridge/su` uses).

It lets any MCP client (Claude Code, MCP Inspector…) use the real tools
without opening another port on the desktop:

    claude mcp add sketchup-dev -- python3 tools/devbridge/mcp_proxy.py

Uses only the Python standard library. Logs go to stderr; stdout carries
MCP messages only (one JSON object per line).
"""

import base64
import importlib.machinery
import importlib.util
import json
import pathlib
import sys

HERE = pathlib.Path(__file__).resolve().parent
RUBY = (
    'require "json"; require "base64"; '
    'Sketchup.require("me_vray_toolkit/mcp/service"); '
    'r = MuriloEduardo::VRayToolkit::Mcp::Service.handle_json(Base64.strict_decode64("{payload}")'
    '.force_encoding("UTF-8")); r.nil? ? "" : JSON.generate(r)'
)


def load_su():
    loader = importlib.machinery.SourceFileLoader("su_client", str(HERE / "su"))
    spec = importlib.util.spec_from_loader("su_client", loader)
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


def log(message):
    print(f"[mcp_proxy] {message}", file=sys.stderr, flush=True)


def forward(su, env, line):
    payload = base64.b64encode(line.encode("utf-8")).decode("ascii")
    reply = su.request(env, "POST", "/eval", RUBY.replace("{payload}", payload).encode("utf-8"),
                       {"X-Result-Format": "json"}, timeout=600)
    if not reply.get("ok"):
        raise RuntimeError(f"{reply.get('error')}: {reply.get('message')}")
    return reply.get("result") or ""


def error_reply(line, message):
    try:
        request_id = json.loads(line).get("id")
    except (ValueError, AttributeError):
        request_id = None
    if request_id is None:
        return None
    return json.dumps({"jsonrpc": "2.0", "id": request_id, "error": {"code": -32603, "message": message}})


def main():
    su = load_su()
    env = su.load_env()
    log("forwarding MCP stdio to SketchUp through the Dev Bridge")
    for raw in sys.stdin:
        line = raw.strip()
        if not line:
            continue
        try:
            answer = forward(su, env, line)
        except (RuntimeError, SystemExit) as error:
            log(f"bridge error: {error}")
            answer = error_reply(line, f"SketchUp bridge error: {error}")
        if answer:
            sys.stdout.write(answer + "\n")
            sys.stdout.flush()


if __name__ == "__main__":
    main()
