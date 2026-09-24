#!/usr/bin/env bash
# Regenera a base de referência. Roda DENTRO do container: `make refdocs`.
#   docs/reference/sketchup-api-index.md   (versionado; derivado dos stubs MIT)
#   docs/reference/_cache/                 (não versionado; docs de terceiros)
set -euo pipefail
cd /workspace
cache=docs/reference/_cache
mkdir -p "$cache"

stubs="$(bundle exec ruby -e "print Gem::Specification.find_by_name('sketchup-api-stubs').gem_dir")/lib/sketchup-api-stubs/stubs"
python3 tools/docs/gen_sketchup_api_index.py "$stubs" > docs/reference/sketchup-api-index.md
cp -r "$stubs" "$cache/sketchup-api-stubs"
echo "SketchUp API index: $(grep -c '^- `' docs/reference/sketchup-api-index.md) métodos"

curl -fsSL -A "Mozilla/5.0" https://docs.chaos.com/vray_app_sdk/doc/python/plugins.html -o "$cache/appsdk-plugins.html"
python3 tools/docs/gen_vray_plugins_index.py "$cache/appsdk-plugins.html" > "$cache/vray-plugins.md"
echo "V-Ray plugins: $(grep -c '^## ' "$cache/vray-plugins.md") plugins"

python3 tools/docs/fetch_chaos_docs.py "$cache/chaos" VSKETCHUP APPSDK
