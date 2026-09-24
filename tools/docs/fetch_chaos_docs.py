#!/usr/bin/env python3
"""Baixa as páginas públicas da Chaos (versão Markdown) de um ou mais espaços.

Espaços usados: VSKETCHUP (V-Ray for SketchUp) e APPSDK (V-Ray App SDK).
Cada página vira <saida>/<ESPACO>/<id>.md. Respeita o servidor com pausas.

Uso: python3 fetch_chaos_docs.py <pasta saida> VSKETCHUP APPSDK
"""
import os
import re
import sys
import time
import urllib.request

BASE = "https://documentation.chaos.com/space"
HEADERS = {"User-Agent": "Mozilla/5.0 (docs refresh; personal project)"}


def fetch(url):
    for attempt in range(4):
        try:
            request = urllib.request.Request(url, headers=HEADERS)
            return urllib.request.urlopen(request, timeout=40).read().decode("utf-8", "ignore")
        except Exception:
            time.sleep(5 * (attempt + 1))
    return None


output = sys.argv[1]
for space in sys.argv[2:]:
    index = fetch(f"{BASE}/{space}.md") or ""
    ids = sorted(set(re.findall(rf"{BASE}/{space}/(\d+)\.md", index)))
    folder = os.path.join(output, space)
    os.makedirs(folder, exist_ok=True)
    with open(os.path.join(folder, "_index.md"), "w") as handle:
        handle.write(index)
    for page_id in ids:
        page = fetch(f"{BASE}/{space}/{page_id}.md")
        if page:
            with open(os.path.join(folder, f"{page_id}.md"), "w") as handle:
                handle.write(page)
        time.sleep(0.3)
    print(f"{space}: {len(ids)} páginas")
