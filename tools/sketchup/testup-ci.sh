#!/usr/bin/env bash
# Roda os testes de tests/sketchup/ dentro do SketchUp via TestUp em modo CI.
# O SketchUp abre, executa, grava o JSON e fecha.
# Uso: tools/sketchup/testup-ci.sh <ano> [filtro TestUp, ex.: TC_VRayBridge#]
#
# Pré-requisitos no Windows: TestUp 2 instalado (github.com/SketchUp/testup-2
# releases) e o loader de dev (`make su-loader`) para as extensões estarem no
# $LOAD_PATH.
source "$(dirname "$0")/lib.sh"
require_wsl

year="${1:?uso: $0 <ano> [filtro]}"
filter="${2:-}"
exe="$(sketchup_exe "$year")"
results_dir="$REPO_ROOT/tests/sketchup/results"
mkdir -p "$results_dir"
stamp="$(date +%Y%m%d-%H%M%S)"
config="$results_dir/testup-ci-$stamp.yml"
output="$results_dir/results-$stamp.json"

{
  echo "Path: \"$(win_path "$REPO_ROOT/tests/sketchup")\""
  echo "Output: \"$(win_path "$output")\""
  echo "LogPath: \"$(win_path "$results_dir")\""
  echo "KeepOpen: false"
  if [[ -n "$filter" ]]; then
    echo "Tests:"
    echo "- $filter"
  fi
} > "$config"

echo "Rodando TestUp CI no SketchUp $year (aguarde o SketchUp fechar)..."
"$exe" -RubyStartupArg "TestUp:CI:Config: $(win_path "$config")" || true

[[ -f "$output" ]] || die "sem resultados em $output (TestUp instalado? veja o log em $results_dir)."
python3 - "$output" <<'PY'
import json, sys
data = json.load(open(sys.argv[1], encoding="utf-8-sig"))
summary = {k: data.get(k) for k in ("tests", "passes", "failures", "errors", "skips", "assertions")}
print(json.dumps(summary, indent=2))
for result in data.get("results", []):
    if result.get("failures") or result.get("errors"):
        print("FALHOU:", result.get("test_case_name"), result.get("test_name"))
        for item in result.get("failures", []):
            print("   ", item.get("message", item))
sys.exit(1 if (data.get("failures") or data.get("errors")) else 0)
PY
