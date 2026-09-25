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
src/me_vray_toolkit/            produto COMPLETO (todas as features); ver docs/platform.md
  main.rb, product.rb           carregador + lista de features (FEATURES)
  core/                         pilares genéricos: Commands, Menu, I18n, Html, ReportDialog,
                                Params, InputForm, Actions (ações tipadas), Events (barramento)
  mcp/                          servidor MCP local (protocolo, HTTP, serviço) + tools/<grupo>.rb
  sketchup/                     ModelData (fatos do modelo como Hashes)
  vray/                         VRayBridge (único ponto que toca ::VRay) + lógica pura
  features/<nome>/              uma funcionalidade; só usa pilares, nunca outra feature
products/<id>.json              produtos derivados (subconjunto de features), gerados no package
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

- Namespace `MuriloEduardo::VRayToolkit`. Funcionalidade nova = pasta em
  `src/me_vray_toolkit/features/` registrando comandos em `Commands` + entrada
  em `product.rb`. Produto novo = `products/<id>.json` (o build copia pilares +
  features escolhidas com outro namespace). Não renomear namespace sem pedido explícito.
- Lógica pura separada do código que usa a API (testável no Docker).
  Todo código novo de lógica pura vem com teste em `tests/unit/`.
- Requisitos do Extension Warehouse são inegociáveis (lint os verifica). Antes
  de release: skill `sketchup-review-extension`.
- A Dev Bridge executa código arbitrário: nunca entra num `.rbz` de produto nem
  no Extension Warehouse; só escuta em 127.0.0.1 e é acessada por SSH. Não
  altere essas garantias de segurança sem pedido explícito do usuário.
- O desktop e o SketchUp pertencem a outra pessoa. Via ponte: não salvar,
  fechar, abrir nem alterar modelos sem pedido explícito; antes de
  `make su-test` (troca o modelo aberto) ou de scripts longos, confirme com o
  usuário que o dono do desktop não está usando o SketchUp. Nunca ler arquivos
  pessoais da conta dele além do necessário para a tarefa.
- Git: commits pequenos em pt-BR, só quando o usuário pedir; rodar `make check` antes.

## Memória do projeto

- `docs/PROGRESS.md`: atualize ao fim de cada sessão de trabalho (o que foi
  feito, o que foi verificado ao vivo, próximos passos, bloqueios).
- `docs/decisions.md`: toda decisão não óbvia.
- `docs/roadmap.md`: status dos itens.
- `docs/reference/vray-ruby-api.md`: tudo que for verificado sobre a API V-Ray
  (trocar "[a verificar]" por fato + versão do V-Ray).
