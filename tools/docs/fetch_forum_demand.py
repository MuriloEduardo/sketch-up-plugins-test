#!/usr/bin/env python3
"""Coleta sinais de demanda nos fóruns (Discourse) do SketchUp e da Chaos.

Para cada categoria relevante baixa os tópicos mais vistos (de sempre e do
último ano) com visualizações, respostas e curtidas; também roda buscas por
temas (IA, MCP…). Saída: docs/reference/_cache/forums/demand/*.json, lida por
tools/docs/analyze_forum_demand.py.

Uso: python3 tools/docs/fetch_forum_demand.py   (rede; ~1 requisição/s)
"""

import json
import pathlib
import time
import urllib.parse
import urllib.request

REPO = pathlib.Path(__file__).resolve().parents[2]
OUT = REPO / "docs" / "reference" / "_cache" / "forums" / "demand"
SKETCHUP = "https://forums.sketchup.com"
CHAOS = "https://forums.chaos.com"

# (nome, fórum, id da categoria, páginas de "top de sempre", páginas de "top do ano")
CATEGORIES = [
    ("sketchup-job-board", SKETCHUP, 92, 2, 1),
    ("sketchup-extensions", SKETCHUP, 27, 6, 3),
    ("sketchup-feature-requests", SKETCHUP, 25, 5, 2),
    ("layout-feature-requests", SKETCHUP, 23, 4, 2),
    ("sketchup-vray", SKETCHUP, 75, 3, 1),
    ("sketchup-commercial-work", SKETCHUP, 33, 3, 1),
    ("sketchup-ai-render", SKETCHUP, 96, 2, 1),
    ("chaos-vray-sketchup-wishlist", CHAOS, 99, 7, 2),
    ("chaos-vray-sketchup-general", CHAOS, 97, 4, 2),
]

# Buscas no fórum do SketchUp (títulos e datas; a busca não traz visualizações).
SEARCHES = {
    "ai-plugins": "AI plugin",
    "chatgpt": "ChatGPT",
    "mcp": "MCP",
    "llm": "LLM",
    "is-there-a-plugin": "\"is there a plugin\"",
    "is-there-an-extension": "\"is there an extension\"",
}

FIELDS = ("id", "title", "views", "reply_count", "like_count", "posts_count", "created_at", "last_posted_at", "tags")


def get_json(url):
    request = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (demand research)"})
    with urllib.request.urlopen(request, timeout=60) as response:
        payload = json.load(response)
    time.sleep(1.0)
    return payload


def topic_record(topic, base):
    record = {field: topic.get(field) for field in FIELDS}
    record["tags"] = [tag["name"] if isinstance(tag, dict) else tag for tag in (record["tags"] or [])]
    record["url"] = f"{base}/t/{topic['id']}"
    return record


def fetch_category(base, category_id, all_pages, year_pages):
    topics = {}
    for period, pages in (("all", all_pages), ("yearly", year_pages)):
        for page in range(pages):
            query = urllib.parse.urlencode({"category": category_id, "period": period, "page": page})
            listing = get_json(f"{base}/top.json?{query}")["topic_list"]["topics"]
            if not listing:
                break
            for topic in listing:
                if topic.get("category_id") == category_id and not topic.get("pinned"):
                    topics[topic["id"]] = topic_record(topic, base)
    return sorted(topics.values(), key=lambda record: -(record["views"] or 0))


def fetch_search(query):
    payload = get_json(f"{SKETCHUP}/search.json?{urllib.parse.urlencode({'q': query})}")
    return [topic_record(topic, SKETCHUP) for topic in payload.get("topics", [])]


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for name, base, category_id, all_pages, year_pages in CATEGORIES:
        topics = fetch_category(base, category_id, all_pages, year_pages)
        (OUT / f"{name}.json").write_text(json.dumps(topics, indent=1, ensure_ascii=False))
        print(f"{name}: {len(topics)} tópicos")
    for name, query in SEARCHES.items():
        topics = fetch_search(query)
        (OUT / f"search-{name}.json").write_text(json.dumps(topics, indent=1, ensure_ascii=False))
        print(f"search {name}: {len(topics)} tópicos")


if __name__ == "__main__":
    main()
