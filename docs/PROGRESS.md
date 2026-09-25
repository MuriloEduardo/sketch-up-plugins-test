# Progresso

Diário curto de estado. Mais recente no topo. Atualize ao fim de cada sessão.

## 2026-09-24 — Pilares P0/P1 + módulo Auditoria de Cena (0.2.0)

- P0: `products/<id>.json` → `tools/build/product_builder.rb` (produto
  derivado com pilares + features escolhidas, namespace próprio). Testado:
  produto de teste `me_scene_audit` empacotado com lint do EW limpo.
- P1: `core/` com `Commands` (registro + erro amigável), `Menu`, `I18n`
  (en/pt-BR/es), `Html`, `ReportDialog`. `sketchup/model_data.rb` (P2 mínimo).
  `VRayBridge`: `with_context`, `file_references`, `plugin_counts`.
- Features: `scene_audit` (nova) e `render_quality` (migrada do main.rb).
  Menu "Status..." removido (o resumo está na auditoria).
- Testes: 89 unitários; 14 TestUp ao vivo (SU 26.1 + V-Ray 7.20), Success.
- Validado ao vivo: auditoria detecta bitmap V-Ray faltando (Erro), material
  sem uso (Info); janela abre em pt-BR. Descobertas na referência V-Ray
  (`_HostMaterial`, só user data persiste, `each_child` sem argumentos).

- Autostart da Dev Bridge ligado no `config.json` do desktop (pedido do
  usuário). Dev Bridge 0.1.2 (`dist/`): item *Start Automatically* com
  marcação; o desktop ainda roda 0.1.0 até reinstalar o `.rbz`.

Pendente: a Lilian precisa **reiniciar o SketchUp** para ver o menu novo
(o antigo tem itens que apontam para métodos removidos). Com o autostart,
a ponte já volta ligada.
Próximo: `layout_sheets` (página do LayOut por cena) ou `material_variations`.

## 2026-09-24 — Referência V-Ray confrontada, LayOut mapeado, plataforma proposta

- `vray-ruby-api.md` confrontado com a doc oficial do V-Ray 7.20 (19 classes)
  e introspecção ao vivo: `Command`/`BatchExporter` são internos,
  `VRay.refresh_ui` não existe, `Plugin#each` rende 5 valores (receita de
  caminhos corrigida), versão via `VRay::VERSION`/`API_VERSION`,
  `renderer.export` exporta só o que está no renderer (usar `ModelExporter`).
- `VRayBridge.api_version` + teste TestUp: 4 testes, 7 asserções ao vivo, Success.
- `docs/reference/layout-api.md`: API Ruby do LayOut roda dentro do SketchUp;
  validado ao vivo criar `.layout` e exportar PDF (0,16 s).
- `docs/platform.md`: pilares (P0–P7), módulos mínimos (scene_audit,
  layout_sheets, material_variations, texture_relink), produto = manifesto;
  atualização de clientes pelo EW. Decisões registradas.

Próximo: P0 (build por manifesto) + P1 (kernel) puxados pelo módulo
`scene_audit`, entregue à Lilian como beta.

## 2026-09-24 — Desktop conectado de verdade

Verificado ao vivo (desktop 192.168.15.26, usuário Windows `Lilian Rosa`):
- `setup-openssh.ps1` funcionou; a porta 22 só abriu depois de pôr a rede do
  desktop em Privada. Chave só-túnel confirmada: login responde `tunnel-only`.
- Dev Bridge 0.1.0 instalada pelo `.rbz` (aviso de não assinada é esperado;
  Start não mostra mensagem).
- `make su-ping`: SketchUp 26.1.252, Ruby 3.2.2, V-Ray 7.20.00 (Oct 01 2025),
  API V-Ray disponível, TestUp ausente.
- `make su-reload`: 6 arquivos enviados, `me_vray_toolkit.rb` registrado.
- `make vray-docs-import`: 35 arquivos de `C:/Program Files/Chaos/V-Ray/V-Ray
  for SketchUp/extension/documentation` → `docs/reference/_cache/`.

Problemas vistos:
- Um `su sync` falhou com "Remote end closed connection" logo após o ping;
  voltou a funcionar depois que a ponte foi religada no desktop. Causa não
  confirmada (SketchUp fechado/Stop ou falha na ponte) — observar.
- `Connection Info` gerava `SSH=Lilian Rosa@...` sem aspas (corrigido na 0.1.1).

- TestUp 2.5.4 instalado. `make su-test` falhava com ENOENT no relatório: o
  TestUp só procura `TC_*.rb` direto na pasta da suíte (sem subpastas) e a
  ponte passa `tests/sketchup`; o teste estava em `tests/sketchup/VRay Bridge/`.
  Movido para `tests/sketchup/TC_VRayBridge.rb` → 3 testes, 4 asserções, Success.
- Dev Bridge 0.1.1: erro claro quando o TestUp não roda testes (antes
  ENOENT) e `Connection Info` com aspas em `SSH="usuario@ip"`. Validado só
  com lint/unit; o desktop ainda roda 0.1.0 até reinstalar o `.rbz`.

Próximos passos: verificar os itens "[a verificar]" de
`docs/reference/vray-ruby-api.md` contra a doc importada e ao vivo.

## 2026-09-24 — Desktop é de outra pessoa: chave só-túnel

- O notebook é pessoal do usuário; o desktop com SketchUp/V-Ray é de outra
  pessoa. Chave SSH agora restrita por padrão (só túnel até a ponte), token
  vindo da janela Connection Info, ponte instalada à mão pelo `.rbz`, doc do
  V-Ray baixada pela ponte, `--ssh-port`, confiança no primeiro contato (TOFU).
- Guia reescrito com consentimento, controle pelo dono, cuidado com o
  trabalho dele (su-test troca o modelo), licenças e revogação.
- Validado contra sshd real em container com a mesma linha de
  `authorized_keys`: shell bloqueado, outra porta bloqueada, scp bloqueado,
  ping/eval/sync/test/pull-vray-docs pelo túnel, 401 com token errado.
  Achou e corrigiu: primeira conexão falhava (host key desconhecida).

## 2026-09-24 — SketchUp no desktop da rede + Dev Bridge via SSH

Feito:
- Decisão: SketchUp Pro + V-Ray Pro rodam no desktop Windows 11 da rede local
  (não na máquina de dev; AWS free tier descartado). Ver `docs/decisions.md`.
- Dev Bridge (`tools/devbridge/extension/`): extensão só de dev, HTTP mínimo
  em 127.0.0.1 dentro do SketchUp (timer no thread principal), token, desligada
  por padrão; rotas ping/eval/sync/reload/test. Ponte por arquivos removida.
- Cliente `tools/devbridge/su` (python3 + ssh do WSL): túnel SSH persistente,
  token lido via SSH, sync sem commit, TestUp remoto, install-bridge e
  pull-vray-docs por scp. Alvos `make su-*`.
- `tools/devbridge/windows/setup-openssh.ps1` + guia `docs/remote-desktop-setup.md`.
- 54 testes unitários (inclui servidor com TCP real); cliente validado ponta a
  ponta contra SketchUp simulado em container (ping, eval, sync, reload com
  erro → 500, test com formato real do TestUp, códigos de saída).

NÃO verificado (depende do desktop):
- Script do OpenSSH, túnel, `scp` com espaços no caminho ("SketchUp 2026"),
  comandos `cmd.exe` remotos, Dev Bridge dentro do SketchUp real, TestUp real.

Próximos passos (usuário, no desktop): seguir `docs/remote-desktop-setup.md`
até `make su-ping` responder; depois `make vray-docs-import` e `make su-test`.

## 2026-09-24 — Repositório remoto e CI

- Remoto: git@github.com:MuriloEduardo/sketch-up-plugins-test.git (branch `master`,
  SSH com a chave pessoal `id_ed25519`; a conta do `gh` não tem push).
- GitHub Actions (`.github/workflows/ci.yml`): `make build/lint/test/package` a cada
  push/PR em `master`; `.rbz` fica como artefato por 30 dias.

## 2026-09-24 — Bootstrap do harness

Feito:
- Leitura integral das fontes (API Ruby SketchUp via stubs 0.7.11 / SU 2026.1,
  guias, release notes, Developer Center, C API, template oficial VSCode,
  TestUp, RuboCop-SketchUp; V-Ray Script Access, 294 páginas V-Ray for
  SketchUp, 111 páginas AppSDK, referência de 535 plugins do core; 24 tópicos
  Ruby do fórum Chaos; tópicos Developers e todo o Job Board do fórum SketchUp).
- Toolchain Docker/Compose + Makefile; `make check` verde (lint sem ofensas,
  14 testes); `make package` gera `dist/me_vray_toolkit-0.1.0.rbz`.
- Extensão mínima `V-Ray Toolkit` (Status, Render Quality) + `VRayBridge`.
- Ponte de desenvolvimento por spool de arquivos (substituída depois pela Dev Bridge via SSH).
- Base de referência (`docs/reference/`) e roadmap comercial.

NÃO verificado (máquina sem SketchUp/V-Ray instalados):
- Comandos da extensão e `VRayBridge` contra V-Ray real.
