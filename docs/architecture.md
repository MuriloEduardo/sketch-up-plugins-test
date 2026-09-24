# Arquitetura

## Topologia de desenvolvimento

```
WSL (Ubuntu)                                   Windows
───────────────────────────────                ─────────────────────────────────
repositório (git)                              SketchUp 20xx + V-Ray 7
  src/  ◄────── \\wsl.localhost\... ────────── Plugins/me_dev_loader.rb (make su-loader)
  tools/sketchup/su-eval ── spool de arquivos ─► dev_bridge.rb (UI.start_timer)
        (C:\Users\<u>\.me_devbridge\inbox|outbox)
  tools/sketchup/launch.sh ── interop WSL ─────► SketchUp.exe [-RubyStartup debug]
  tools/sketchup/testup-ci.sh ─────────────────► SketchUp.exe -RubyStartupArg TestUp:CI

Docker (compose.yaml)
  Ruby 3.2 = mesmo do SketchUp 2024–2026
  make lint | test | package | docs | refdocs
```

- O SketchUp não roda em Linux/contêiner: toda execução real acontece no
  Windows. O WSL controla o Windows via interop (`*.exe`, `/mnt/c`).
- A toolchain (RuboCop, Minitest, YARD, empacotamento) roda em Docker para
  ser reprodutível sem Ruby no host.

## Camadas do código (`src/me_vray_toolkit/`)

| Camada | Depende de | Testado por |
|---|---|---|
| **Lógica pura** (ex.: `vray/quality_preset.rb`, `vray/plugin_path.rb`) | nada além de Ruby | Minitest no Docker (`make test`) |
| **Bridges** (ex.: `vray/bridge.rb`) — único ponto que toca `::VRay` | SketchUp + V-Ray | TestUp no SketchUp (`make su-testup`) |
| **Comandos/UI** (`main.rb`, futuros `ui/`, `tools/`) | SketchUp | TestUp + teste manual |

Regras:
- Tudo que puder ser puro, é puro (mais testável sem SketchUp).
- `::VRay` só é referenciado dentro de `VRayBridge` — mudanças de API do V-Ray
  entre versões são corrigidas em um lugar.
- Arquivos puros não chamam `Sketchup.require`; os testes carregam por caminho.
- Um arquivo por classe/módulo; namespace `MuriloEduardo::VRayToolkit`.

## Novas extensões

Cada produto do roadmap pode virar uma extensão separada em `src/`
(`src/me_<produto>.rb` + `src/me_<produto>/`). `make package` gera um `.rbz`
por arquivo de registro em `src/*.rb`. Código compartilhado deve ser
duplicado por extensão (recomendação do EW: evitar dependência entre
extensões) — ou extraído para um gerador/vendor script quando crescer.
