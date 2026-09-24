#!/usr/bin/env bash
# Abre o SketchUp do Windows a partir do WSL.
# Uso: tools/sketchup/launch.sh <ano> [--debug [porta]]
#
# --debug passa tools/sketchup/debug/su_debug_bootstrap.rb via -RubyStartup e
# abre o servidor DAP do gem `debug` (SketchUp 2024+). Depois use o launch
# "Attach to SketchUp" no VS Code. Porta padrão 7150 (não 7000: AirPlay/AFS).
source "$(dirname "$0")/lib.sh"
require_wsl

year="${1:?uso: $0 <ano> [--debug [porta]]}"
exe="$(sketchup_exe "$year")"
args=()
if [[ "${2:-}" == "--debug" ]]; then
  port="${3:-7150}"
  args+=(-RubyStartup "$(win_path "$REPO_ROOT/tools/sketchup/debug/su_debug_bootstrap.rb")")
  args+=(-RubyStartupArg "su_debug:port=${port}")
  echo "Debugger escutando na porta ${port} (log: %TEMP%\\sketchup_debug_bootstrap.log)."
fi

# setsid + nohup: o SketchUp continua vivo quando o terminal fecha.
setsid nohup "$exe" "${args[@]}" >/dev/null 2>&1 &
echo "SketchUp ${year} iniciado."
