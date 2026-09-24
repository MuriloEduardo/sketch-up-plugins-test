#!/usr/bin/env bash
# Instala o loader de desenvolvimento na pasta Plugins do SketchUp (Windows).
# Uso: tools/sketchup/install-dev-loader.sh <ano>     (ex.: 2026)
#
# O loader carrega as extensões direto de src/ neste repositório (via
# \\wsl.localhost) e liga a ponte de desenvolvimento. Rode de novo se mover o
# repositório. Para remover: apague me_dev_loader.rb da pasta Plugins.
source "$(dirname "$0")/lib.sh"
require_wsl

year="${1:?uso: $0 <ano do SketchUp>}"
plugins="$(plugins_dir "$year")"
[[ -d "$plugins" ]] || die "pasta Plugins não encontrada: $plugins (abra o SketchUp $year uma vez antes)."

bridge="$(devbridge_dir)"
mkdir -p "$bridge/inbox" "$bridge/outbox"

target="$plugins/me_dev_loader.rb"
sed -e "s|__REPO__|$(win_path "$REPO_ROOT")|" \
    -e "s|__DEVBRIDGE__|$(win_path "$bridge")|" \
    "$REPO_ROOT/tools/sketchup/dev_loader.rb.template" > "$target"

echo "Loader instalado: $(win_path "$target")"
echo "Repositório:      $(win_path "$REPO_ROOT")"
echo "Ponte (spool):    $(win_path "$bridge")"
echo "Reinicie o SketchUp $year. Teste com: make su-ping"
