# SketchUp + V-Ray — extensões

Monorepo de extensões Ruby para SketchUp focadas em automação do V-Ray for
SketchUp, com toolchain em Docker e integração WSL → SketchUp (Windows).

## Requisitos

- WSL2 (Ubuntu) com Docker + Docker Compose v2 e `make`.
- Para rodar de verdade: Windows com SketchUp 2024+ (alvo: 2026) e V-Ray 7.

## Início rápido

```sh
make build     # imagem da toolchain (Ruby 3.2, igual ao SketchUp)
make check     # RuboCop + RuboCop-SketchUp + testes unitários
make package   # dist/me_vray_toolkit-<versão>.rbz
make help      # todos os comandos
```

Com o SketchUp instalado no Windows:

```sh
make su-loader SU_YEAR=2026   # carrega as extensões direto deste repositório
make su-launch                # abre o SketchUp
make su-ping                  # testa a ponte de desenvolvimento
tools/sketchup/su-eval 'Sketchup.active_model.title'
```

## Documentação

| Documento | Conteúdo |
|---|---|
| [docs/workflow.md](docs/workflow.md) | Configuração, ciclo diário, depuração, release |
| [docs/architecture.md](docs/architecture.md) | Topologia WSL/Windows/Docker e camadas do código |
| [docs/roadmap.md](docs/roadmap.md) | Produtos, backlog comercial e técnico |
| [docs/PROGRESS.md](docs/PROGRESS.md) | Estado atual e próximos passos |
| [docs/decisions.md](docs/decisions.md) | Decisões de arquitetura |
| [docs/reference/](docs/reference/README.md) | Base de conhecimento SketchUp e V-Ray |
| [CLAUDE.md](CLAUDE.md) | Instruções para o Claude Code |

## Licenças de terceiros

Ver [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
