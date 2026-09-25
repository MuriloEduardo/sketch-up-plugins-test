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
  chave SSH só-túnel (padrão): sem shell/scp; doc do V-Ray vem pela ponte

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

`src/` é o produto completo; produtos menores são derivados no build
(`docs/platform.md`, `products/README.md`).

| Pasta | Conteúdo | Depende de | Testado por |
|---|---|---|---|
| `core/` | pilares genéricos: `Commands` (registro), `I18n`, `Html`, `Params`, `InputForm` (puros); `Menu`, `ReportDialog` (UI) | Ruby / SketchUp | Minitest + TestUp |
| `sketchup/` | `ModelData`: fatos do modelo como Hashes | SketchUp | TestUp |
| `vray/` | `VRayBridge` (único ponto que toca `::VRay`) + `QualityPreset`, `PluginPath` (puros) | SketchUp + V-Ray | Minitest + TestUp |
| `features/<nome>/` | `feature.rb` (registra comandos, coleta dados) + lógica pura (analisadores, relatórios, textos) | pilares | Minitest + TestUp |
| `main.rb`, `product.rb` | carrega as features de `Product::FEATURES` e monta o menu | tudo | TestUp |

Regras:
- Tudo que puder ser puro, é puro (mais testável sem SketchUp). Padrão de
  feature: coletar fatos (SketchUp/V-Ray) → analisar (puro) → mostrar.
- `::VRay` só é referenciado dentro de `VRayBridge`.
- Uma feature nunca depende de outra (verificado no build e em
  `tests/unit/features/isolation_test.rb`).
- Textos visíveis: tabelas `STRINGS` por feature (en, pt-BR, es) via `I18n.t`.
- Arquivos puros não chamam `Sketchup.require`; os testes carregam por caminho.
- Um arquivo por classe/módulo; namespace `MuriloEduardo::VRayToolkit`.

## Dev Bridge (`tools/devbridge/extension/`)

Extensão separada, só de desenvolvimento, com o mesmo layout (lógica pura em
`security`, `http`, `evaluator`, `config`, `workspace`, `routes`, `server`,
testada no Docker, inclusive com TCP real; `main.rb` liga ao SketchUp).
Empacotada à parte por `make dev-bridge-package`; `make package` só empacota `src/`.

## Novos produtos

`products/<id>.json` → `make package` gera `dist/<id>-<versão>.rbz` com os
pilares + as features escolhidas, renomeando `me_vray_toolkit` → `<id>` e
`VRayToolkit` → `<namespace>` (`tools/build/product_builder.rb`). Cada produto
tem a própria cópia dos pilares (recomendação do EW: sem extensão-biblioteca).
