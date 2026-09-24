#!/usr/bin/env python3
"""Converte uma documentação YARD/HTML (ex.: API Ruby do V-Ray instalada) em
um único texto pesquisável com grep.

Uso: python3 html_to_text.py <pasta> > saida.txt
"""
import html
import os
import re
import sys

root = sys.argv[1]
for folder, _, files in sorted(os.walk(root)):
    for name in sorted(files):
        if not name.endswith(".html") or name.endswith("_list.html"):
            continue
        text = open(os.path.join(folder, name), encoding="utf-8", errors="ignore").read()
        text = re.sub(r"<script.*?</script>|<style.*?</style>", "", text, flags=re.S)
        text = re.sub(r"<(br|/p|/h\d|/li|/pre|/tr|/dt|/dd)[^>]*>", "\n", text)
        text = html.unescape(re.sub(r"<[^>]+>", "", text))
        text = re.sub(r"\n\s*\n+", "\n", text)
        print(f"\n######## {os.path.relpath(os.path.join(folder, name), root)}\n{text.strip()}")
