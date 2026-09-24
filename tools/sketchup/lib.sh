# shellcheck shell=bash
# Funções comuns para falar com o SketchUp do Windows a partir do WSL.
# Uso: source "$(dirname "$0")/lib.sh"
#
# Variáveis que podem ser sobrescritas no ambiente:
#   SU_WIN_USER       usuário do Windows (padrão: detectado via cmd.exe)
#   SU_EXE            caminho WSL do SketchUp.exe (padrão: detectado pelo ano)
#   ME_DEVBRIDGE_DIR  pasta de spool da ponte de dev (padrão: C:\Users\<u>\.me_devbridge)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

die() { echo "erro: $*" >&2; exit 1; }

require_wsl() {
  [[ -n "${WSL_DISTRO_NAME:-}" ]] || die "estes scripts rodam no WSL e controlam o SketchUp do Windows."
  command -v wslpath >/dev/null || die "wslpath não encontrado."
}

win_user() {
  if [[ -z "${SU_WIN_USER:-}" ]]; then
    SU_WIN_USER="$(cd /mnt/c && cmd.exe /c 'echo %USERNAME%' 2>/dev/null | tr -d '\r\n ')"
  fi
  [[ -n "$SU_WIN_USER" ]] || die "não foi possível detectar o usuário do Windows (defina SU_WIN_USER)."
  echo "$SU_WIN_USER"
}

# Caminho WSL do executável do SketchUp para o ano dado.
# SketchUp 2025+ usa a estrutura aninhada ...\SketchUp 2025\SketchUp\SketchUp.exe.
sketchup_exe() {
  local year="$1"
  if [[ -n "${SU_EXE:-}" ]]; then echo "$SU_EXE"; return; fi
  local base="/mnt/c/Program Files/SketchUp/SketchUp ${year}"
  local candidates=("$base/SketchUp/SketchUp.exe" "$base/SketchUp.exe")
  local candidate
  for candidate in "${candidates[@]}"; do
    [[ -f "$candidate" ]] && { echo "$candidate"; return; }
  done
  die "SketchUp ${year} não encontrado em '$base' (defina SU_EXE)."
}

# Pasta Plugins do usuário para o ano dado (caminho WSL).
plugins_dir() {
  local year="$1"
  echo "/mnt/c/Users/$(win_user)/AppData/Roaming/SketchUp/SketchUp ${year}/SketchUp/Plugins"
}

devbridge_dir() {
  echo "${ME_DEVBRIDGE_DIR:-/mnt/c/Users/$(win_user)/.me_devbridge}"
}

# Converte caminho WSL para caminho Windows com barras normais (Ruby aceita).
win_path() {
  wslpath -m "$1"
}
