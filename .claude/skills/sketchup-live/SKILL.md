---
name: sketchup-live
description: Run Ruby inside the user's SketchUp on the Windows desktop (over the Dev Bridge SSH tunnel) to inspect the model, probe the V-Ray API, sync and reload code, or run TestUp tests. Use when you need ground truth from the real SketchUp/V-Ray instead of guessing.
---

# Inspect and drive the live SketchUp

SketchUp + V-Ray run on a separate Windows 11 desktop on the LAN that belongs to ANOTHER PERSON
(not the user). Their consent and their ongoing work come first. The Dev Bridge extension
(`tools/devbridge/extension/`) listens on 127.0.0.1 there; `tools/devbridge/su` reaches it through
an SSH tunnel. Setup: `docs/remote-desktop-setup.md`.

## Preconditions

1. `make su-ping` returns JSON with `sketchup_version`. If not:
   - exit 2 "sem configuração" → the user must run the command copied from *Dev Bridge › Connection Info* (`make su-connect SSH=... TOKEN=... KEY=...`).
   - SSH failure → desktop off, network Public, IP changed (tell the user; do not retry blindly).
   - "a ponte não respondeu" → ask the user to open SketchUp and click
     *Extensions › Dev Bridge (DEV ONLY) › Start*.

## Usage

```sh
make su-reload                                     # sync src/ + tests/sketchup/ and reload
tools/devbridge/su eval 'Sketchup.active_model.entities.size'
tools/devbridge/su eval -f /tmp/probe.rb           # multi-line scripts
tools/devbridge/su eval --json 'Sketchup.active_model.materials.map(&:name)'
make su-test FILTER='TC_VRayBridge#'               # TestUp, prints statistics and failures
make vray-docs-import                              # official V-Ray Ruby API docs → docs/reference/_cache
```

Result: `{"ok":true,"result":"<inspect>","stdout":"...","seconds":...}` or
`{"ok":false,"error":"...","message":"...","backtrace":[...]}`. Exit 1 on exception, 2 on no connection.

## Rules

- Before `make su-test` (TestUp replaces the open model with an empty one), heavy scripts or
  anything touching the model, ask the user to confirm the desktop owner is not using SketchUp.
- Never browse or read the owner's personal files; only touch the workspace, the V-Ray docs
  folder and what the task needs.
- Read-only by default. Anything that modifies the model must be wrapped in
  `model.start_operation(...)`/`commit_operation` and must be something the user asked for.
- Never save, close, purge or open models without explicit user approval.
- Keep scripts short: they run on SketchUp's main thread and freeze its UI while running.
- No `sleep`, no modal dialogs (`UI.messagebox`, `UI.inputbox`) — they block the bridge.
- Never change Dev Bridge security settings (bind address, token, autostart) on the user's behalf.
- Useful probes:
  - `VRay::Context.active.scene["/SettingsOptions"].dump`
  - `VRay.singleton_methods.sort`, `VRay::Scene.instance_methods(false).sort`
  - `VRay::Context.active.scene.each.map { |p| [p.name, p.category] }.first(50)`
  - `Sketchup.active_model.selection.map { |e| [e.typename, e.persistent_id] }`
- Record anything learned about the V-Ray API in `docs/reference/vray-ruby-api.md`
  (replace "[a verificar]" with the verified behavior and the V-Ray version).
