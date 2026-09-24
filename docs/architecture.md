# Arquitetura

## Topologia de desenvolvimento

```
Este PC — WSL (Ubuntu)                    Desktop Windows 11 (rede local)
────────────────────────────────          ──────────────────────────────────────
repositório (git) + Claude Code           SketchUp Pro + V-Ray Pro
tools/devbridge/su ──SSH (chave, :22)───► OpenSSH Server
  túnel 127.0.0.1:17860 ────────────────► 127.0.0.1:7860  Dev Bridge (extensão dev)
    /sync   src/, tests/sketchup/  ─────►   %APPDATA%\MuriloEduardoDev\workspace
    /reload /eval /test /ping               ($LOAD_PATH → extensões em desenvolvimento)
  scp (install-bridge, pull-vray-docs) ─►   Plugins\, doc da API V-Ray

Docker (compose.yaml) — Ruby 3.2 = SketchUp 2024–2026
  make lint | test | package | docs | refdocs     (também no GitHub Actions)
```

- O SketchUp não roda em Linux/contêiner: toda execução real acontece no
  desktop. O código vai para lá por `sync` (sem precisar de commit).
- A Dev Bridge executa Ruby num timer do thread principal do SketchUp (o
  único lugar seguro para a API), uma requisição por vez. Escuta só em
  loopback; o acesso remoto é o SSH com chave. Ver
  `docs/remote-desktop-setup.md` (segurança) e `docs/decisions.md`.
- A toolchain (RuboCop, Minitest, YARD, empacotamento) roda em Docker para
  ser reprodutível sem Ruby no host.

## Camadas do código (`src/me_vray_toolkit/`)

| Camada | Depende de | Testado por |
|---|---|---|
| **Lógica pura** (ex.: `vray/quality_preset.rb`, `vray/plugin_path.rb`) | nada além de Ruby | Minitest no Docker (`make test`) |
| **Bridges** (ex.: `vray/bridge.rb`) — único ponto que toca `::VRay` | SketchUp + V-Ray | TestUp no SketchUp (`make su-test`) |
| **Comandos/UI** (`main.rb`, futuros `ui/`, `tools/`) | SketchUp | TestUp + teste manual |

Regras:
- Tudo que puder ser puro, é puro (mais testável sem SketchUp).
- `::VRay` só é referenciado dentro de `VRayBridge` — mudanças de API do V-Ray
  entre versões são corrigidas em um lugar.
- Arquivos puros não chamam `Sketchup.require`; os testes carregam por caminho.
- Um arquivo por classe/módulo; namespace `MuriloEduardo::VRayToolkit`.

## Dev Bridge (`tools/devbridge/extension/`)

Extensão separada, só de desenvolvimento, com o mesmo layout (lógica pura em
`security`, `http`, `evaluator`, `config`, `workspace`, `routes`, `server`,
testada no Docker, inclusive com TCP real; `main.rb` liga ao SketchUp).
Empacotada à parte por `make dev-bridge-package`; `make package` só empacota `src/`.

## Novas extensões

Cada produto do roadmap pode virar uma extensão separada em `src/`
(`src/me_<produto>.rb` + `src/me_<produto>/`). `make package` gera um `.rbz`
por arquivo de registro em `src/*.rb`. Código compartilhado deve ser
duplicado por extensão (recomendação do EW: evitar dependência entre
extensões) — ou extraído para um gerador/vendor script quando crescer.
