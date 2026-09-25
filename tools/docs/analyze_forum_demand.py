#!/usr/bin/env python3
"""Agrupa por tema os tópicos coletados por fetch_forum_demand.py.

Classificação por palavras-chave no título (um tópico pode cair em mais de um
tema). Imprime, por fonte e tema: número de tópicos, soma de visualizações e
de curtidas, e quantos são dos últimos 2 anos. É um termômetro, não uma
pesquisa de mercado: leia os títulos antes de decidir.

Uso: python3 tools/docs/analyze_forum_demand.py [--examples N]
"""

import argparse
import json
import pathlib
import re

DEMAND = pathlib.Path(__file__).resolve().parents[2] / "docs" / "reference" / "_cache" / "forums" / "demand"
RECENT_FROM = "2024-09"

THEMES = {
    "render em lote / por cena": r"batch|multiple (file|scene)|all scenes|per scene|different scenes|aspect ratio|render queue|scene selecting|render output settings|settings per scene",
    "render IA": r"diffusion|ai[- ]?render|ai generated|veras|arko|ai imag|photoreal.*ai|\bai\b.*render",
    "LLM / MCP / agentes": r"\bmcp\b|\bllm\b|chatgpt|claude|agent|\bgpt\b|ai assist|ai generator|\bai\b.*(script|plugin|model)",
    "documentação / LayOut": r"layout|sheet|dimension|annotat|label|title block|drawing set|drawing register|index|auto-?text|construction doc|condoc|5d\+|documentation|revision cloud|hatch",
    "exportação 2D / CAD": r"\bdwg\b|\bdxf\b|\bpdf\b|export 2d|2d graphics|\bsvg\b|corel|2d export|make2d",
    "interoperabilidade / BIM": r"revit|\bifc\b|\bbim\b|unreal|datasmith|twinmotion|fusion 360|archicad|gltf|\bobj\b|citygml",
    "quantitativos / dados": r"take ?off|quantit|\bbom\b|cost|estimat|report|area calc|schedule|\bdata\b|power bi|attribute|extract|web app|json",
    "marcenaria / CNC": r"cut ?list|\bcnc\b|cabinet|furniture|laser|g-?code|\babf\b|woodwork|kitchen",
    "geradores paramétricos": r"stair|retaining wall|truss|roof|framing|timber|railing|\bdoor\b|window|column|foundation|medeek|building creator|profile builder|parametric|dynamic component|planogram|climbing",
    "materiais / texturas": r"material|texture|\buv\b|vrmat|hdri|decal|vrscan|bitmap",
    "cenas / tags": r"\bscene|\btags?\b|\blayers?\b|multitag|outliner",
    "biblioteca de assets": r"librar|component browser|\bassets?\b|importer|3d warehouse|scrapbook",
    "terreno / paisagismo": r"terrain|landscap|\btopo|placemaker|contour|grass|plants|trees",
    "MEP / estrutural": r"\bmep\b|electrical|hvac|plumbing|structur|reinforcement|rebar|engineering",
    "versões / referências externas": r"older version|save to older|xref|reference manager|bulk convert|backwards compatible|reload",
    "limpeza / desempenho": r"purge|clean ?up|slow|unused|solid inspector|faster render|remove .*materials|performance",
}

SOURCES = [
    "sketchup-job-board", "sketchup-extensions", "sketchup-feature-requests", "layout-feature-requests",
    "sketchup-vray", "sketchup-ai-render", "sketchup-commercial-work",
    "chaos-vray-sketchup-wishlist", "chaos-vray-sketchup-general",
]


def load(source):
    return json.loads((DEMAND / f"{source}.json").read_text())


def themes_of(title):
    return [theme for theme, pattern in THEMES.items() if re.search(pattern, title, re.I)]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--examples", type=int, default=0, help="títulos de exemplo por tema")
    args = parser.parse_args()

    for source in SOURCES:
        topics = load(source)
        print(f"\n## {source} ({len(topics)} tópicos)\n")
        print("| tema | tópicos | recentes | visualizações | curtidas |")
        print("|---|---:|---:|---:|---:|")
        rows = []
        for theme in THEMES:
            matched = [topic for topic in topics if theme in themes_of(topic["title"])]
            if not matched:
                continue
            views = sum(topic["views"] or 0 for topic in matched)
            likes = sum(topic["like_count"] or 0 for topic in matched)
            recent = sum(1 for topic in matched if (topic["created_at"] or "") >= RECENT_FROM)
            rows.append((views, theme, len(matched), recent, likes, matched))
        for views, theme, count, recent, likes, matched in sorted(rows, reverse=True):
            print(f"| {theme} | {count} | {recent} | {views:,} | {likes:,} |".replace(",", "."))
            for topic in sorted(matched, key=lambda t: -(t["views"] or 0))[: args.examples]:
                print(f"|  ↳ {topic['title'][:70]} | | | {topic['views']:,} | |".replace(",", "."))


if __name__ == "__main__":
    main()
