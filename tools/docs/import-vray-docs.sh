#!/usr/bin/env bash
# Importa a documentação OFICIAL da API Ruby do V-Ray for SketchUp, que só é
# distribuída junto com a instalação do V-Ray (não existe online).
# Roda no WSL (host). Saída: docs/reference/_cache/vray-ruby-api-installed/
#   + docs/reference/_cache/vray-ruby-api-installed.txt (texto para grep)
source "$(dirname "$0")/../sketchup/lib.sh"
require_wsl

candidates=(
  "/mnt/c/Program Files/Chaos/V-Ray/V-Ray for SketchUp/extension/documentation"
  "/mnt/c/Program Files/Chaos Group/V-Ray/V-Ray for SketchUp/extension/documentation"
)
source_dir=""
for candidate in "${candidates[@]}"; do
  [[ -f "$candidate/_index.html" ]] && { source_dir="$candidate"; break; }
done
[[ -n "$source_dir" ]] || die "documentação do V-Ray não encontrada. O V-Ray for SketchUp está instalado?"

target="$REPO_ROOT/docs/reference/_cache/vray-ruby-api-installed"
rm -rf "$target"; mkdir -p "$target"
cp -r "$source_dir/." "$target/"
python3 - "$target" > "$target.txt" <<'PY'
import html, os, re, sys
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
PY
echo "Importado de: $source_dir"
echo "Texto para busca: docs/reference/_cache/vray-ruby-api-installed.txt ($(wc -c < "$target.txt") bytes)"
echo "Próximo passo: atualizar docs/reference/vray-ruby-api.md com o que for novo/divergente."
