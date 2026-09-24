# CLAUDE.md

Projeto de longo prazo: extensões comerciais para **SketchUp** com foco em
automação do **V-Ray for SketchUp**. Idioma de trabalho com o usuário:
**português (pt-BR)**. Código, identificadores e comentários de código em inglês.

## Antes de qualquer tarefa

1. Leia `docs/PROGRESS.md` (estado atual e próximos passos) e o item
   correspondente em `docs/roadmap.md`.
2. Para código SketchUp: `docs/reference/sketchup-dev-guide.md` + regras em
   `.claude/rules/` (carregam sozinhas por caminho).
3. Para código V-Ray: `docs/reference/vray-ruby-api.md` e a skill `vray-api-lookup`.
4. Método do SketchUp: `docs/reference/sketchup-api-index.md` (tem a versão
   mínima de cada método — respeite `TargetSketchUpVersion: 2024`).
5. Ordem de consulta completa das fontes: `docs/reference/README.md`.

Não invente APIs do V-Ray: a doc oficial só existe na instalação. Se algo não
está documentado aqui, verifique ao vivo (skill `sketchup-live`) ou diga que
não sabe.

## Comandos (toda a toolchain roda em Docker)

```sh
make help          # lista tudo
make check         # RuboCop(-SketchUp) + testes unitários — rode antes de commitar
make test          # só testes unitários (tests/unit, fora do SketchUp)
make lint-fix      # autocorreção segura
make package       # dist/<ext>-<versão>.rbz
make refdocs       # regenera docs/reference (rede)
make dev-bridge-package # dist/me_dev_bridge-*.rbz (extensão SÓ de desenvolvimento)
# SketchUp + V-Ray no DESKTOP Windows da rede, via Dev Bridge + túnel SSH
# (docs/remote-desktop-setup.md; pedem confirmação do usuário):
make su-ping                      # conexão ok?
make su-reload                    # envia src/ + tests/sketchup/ e recarrega
tools/devbridge/su eval '<ruby>'  # executa no SketchUp do desktop, retorna JSON
make su-test [FILTER=TC_X#]       # TestUp no desktop
make vray-docs-import             # baixa a doc oficial da API V-Ray instalada no desktop
```

Sem Ruby no host: nunca rode `ruby`/`bundle` direto no WSL; use
`docker compose run --rm dev <cmd>`. O cliente `tools/devbridge/su` usa só o
`python3` e o `ssh` do WSL.

## Estrutura

```
src/me_vray_toolkit.rb          registro da extensão (SÓ registro — regra do EW)
src/me_vray_toolkit/main.rb     menus/comandos
src/me_vray_toolkit/vray/       VRayBridge (único ponto que toca ::VRay) + lógica pura
tests/unit/                     Minitest puro (Docker)
tests/sketchup/                 TestUp (dentro do SketchUp), convenção TC_*.rb
tools/build/                    empacotamento e runner de testes
tools/devbridge/                Dev Bridge (extensão dev no desktop), cliente `su`, script OpenSSH
tools/debug/                    bootstrap do debugger (template oficial; ainda não usado remotamente)
tools/docs/                     geradores/atualizadores da base de referência
docs/                           roadmap, progresso, decisões, arquitetura, workflow, referência
```

Arquitetura e topologia WSL ↔ desktop Windows ↔ Docker: `docs/architecture.md`.

## Regras do projeto

- Namespace `MuriloEduardo::VRayToolkit`; novos produtos = novas extensões em
  `src/me_<produto>.rb` + pasta. Não renomear namespace sem pedido explícito.
- Lógica pura separada do código que usa a API (testável no Docker).
  Todo código novo de lógica pura vem com teste em `tests/unit/`.
- Requisitos do Extension Warehouse são inegociáveis (lint os verifica). Antes
  de release: skill `sketchup-review-extension`.
- A Dev Bridge executa código arbitrário: nunca entra num `.rbz` de produto nem
  no Extension Warehouse; só escuta em 127.0.0.1 e é acessada por SSH. Não
  altere essas garantias de segurança sem pedido explícito do usuário.
- Não salvar/fechar/alterar o modelo do usuário via ponte sem pedido explícito.
- Git: commits pequenos em pt-BR, só quando o usuário pedir; rodar `make check` antes.

## Memória do projeto

- `docs/PROGRESS.md`: atualize ao fim de cada sessão de trabalho (o que foi
  feito, o que foi verificado ao vivo, próximos passos, bloqueios).
- `docs/decisions.md`: toda decisão não óbvia.
- `docs/roadmap.md`: status dos itens.
- `docs/reference/vray-ruby-api.md`: tudo que for verificado sobre a API V-Ray
  (trocar "[a verificar]" por fato + versão do V-Ray).
