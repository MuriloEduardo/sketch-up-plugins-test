#!/usr/bin/env python3
"""Gera um índice compacto de TODOS os plugins do core V-Ray e seus parâmetros.

Fonte: referência Python do V-Ray AppSDK (docs.chaos.com/vray_app_sdk/doc/python/plugins.html).
Os nomes de plugin e parâmetro são os mesmos usados pela API Ruby do V-Ray for
SketchUp: scene["/Plugin"][:parametro]. Parâmetros "userdata" da UI do
SketchUp NÃO aparecem aqui (veja docs/reference/vray-ruby-api.md).

Uso: python3 gen_vray_plugins_index.py <plugins.html> > vray-plugins.md
"""
import html
import re
import sys

source = open(sys.argv[1], encoding="utf-8", errors="ignore").read()
source = re.sub(r"<script.*?</script>|<style.*?</style>", "", source, flags=re.S)

out = ["# V-Ray core plugins — parameter index", "",
       "Generated from the V-Ray AppSDK Python plugin reference. Format: `param` (type) — description.", ""]
for block in re.split(r'<dl class="py class">', source)[1:]:
    name = re.search(r'id="plugins\.([A-Za-z0-9_]+)"', block)
    if not name:
        continue
    text = lambda s: re.sub(r"\s+", " ", html.unescape(re.sub(r"<[^>]+>", "", s))).strip()
    header = re.split(r'<dl class="py property">', block)[0]
    paragraphs = [text(p) for p in re.findall(r"<p>(.*?)</p>", header, re.S)]
    desc = [p for p in paragraphs if p and not p.startswith("Bases:")]
    out.append(f"## {name.group(1)}")
    if desc:
        out.append(desc[0])
    for prop in re.split(r'<dl class="py property">', block)[1:]:
        pname = re.search(r'id="plugins\.[A-Za-z0-9_]+\.([A-Za-z0-9_]+)"', prop)
        if not pname:
            continue
        body = text(re.split(r"</dl>", prop)[0])
        body = re.sub(r"^.*?¶", "", body).strip()
        ptype = re.search(r"type:\s*(\S+)", body)
        pdesc = re.sub(r"^type:\s*\S+\s*", "", body)
        out.append(f"- `{pname.group(1)}` ({ptype.group(1) if ptype else '?'}) — {pdesc[:220]}")
    out.append("")
print("\n".join(out))
