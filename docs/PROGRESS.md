# Progresso

Diário curto de estado. Mais recente no topo. Atualize ao fim de cada sessão.

## 2026-09-25 — Módulo `layout_sheets` (pranchas do LayOut por cena)

- Novo módulo `features/layout_sheets/`: uma prancha por cena do modelo salvo
  (viewport + carimbo com projeto, descrição, nome, "Prancha 02 / 12" e data),
  índice de pranchas opcional e PDF. Filtro por prefixo (`P., E.`), papel
  A4–A1/Letter/Tabloid, orientação e modo de render da viewport. Grava
  `<modelo>.layout`/`.pdf` ao lado do `.skp` sem nunca sobrescrever.
- Pilar P8 começou: `core/params.rb` (esquema + validação) e
  `core/input_form.rb` (esquema → `UI.inputbox`). A ação tipada é
  `LayoutSheets.generate(model, input)`; o menu só coleta a entrada.
- `ModelData.scenes`. 112 testes unitários (eram 89), lint limpo.
- Verificado ao vivo (só em `temp_dir`, modelo aberto intocado): viewport de
  `.skp`, render, `.layout` de 2 páginas + PDF em 0,5 s; PNG das páginas
  conferido visualmente. Fatos novos em `docs/reference/layout-api.md`
  (cena N = índice N+1, `Document.new` usa o template do usuário, eixo y para
  baixo, `Backup of` ao salvar por cima).

- TestUp ao vivo (autorizado pelo usuário): 22 testes, 0 falhas. Achados:
  `model.path` vem com `\` no Windows (normalizado para `/`); o
  `start_with_empty_model` do TestUp **não** cria modelo novo (limpa o atual),
  então quem salva o modelo ativo deve chamar `open_new_model` no teardown.
  `su-test` só sincroniza: rode `make su-reload` antes, senão testa código velho.
  `FILTER=TC_X#` rodou 0 testes (classes com namespace); investigar.
- O modelo sem nome que estava aberto no desktop foi descartado pelo TestUp
  (com autorização). O item novo do menu só aparece após reiniciar o SketchUp.
- Versão 0.3.0 (`dist/me_vray_toolkit-0.3.0.rbz`), já sincronizada no workspace
  do desktop: basta reiniciar o SketchUp para testar (não instalar o `.rbz` junto).
- Roadmap: Fase 6 ampliada (L9–L12, catálogo máximo de tools MCP); decisão do
  usuário: seguir a ordem do roadmap, MCP depois dos módulos prioritários.

- Bug no menu corrigido (`ready_to_use?` usava variável inexistente; só o
  caminho do menu passava ali) + teste TestUp novo (ainda não rodado ao vivo).
- Teste real no desktop: modelo de teste com 2 caixas e 3 cenas → 4 pranchas
  + PDF em 4,6 s. **Problema:** planta e fachada (ortogonais) saem cortadas: a
  viewport herda a câmera da cena com outra proporção, e o LayOut não tem
  "zoom extents". Próximo item: calcular escala técnica que caiba (1:20…1:500)
  para cenas ortogonais e mostrá-la no carimbo.

- Escala automática das vistas ortogonais (feita, sem commit): `Scale.fit`
  escolhe a maior escala padrão (1:1…1:5000) em que a extensão do modelo,
  vista pela câmera da cena e centrada no alvo, cabe em 90% da viewport;
  parâmetro `scale` (auto ou fixa); carimbo mostra "Escala 1:N". Ao vivo:
  planta e fachada inteiras em 1:25. Verificado: `SketchUpModel#scale` é a
  razão papel/modelo (1:100 = 0.01) e a viewport centra no alvo da câmera.
- Painel de acompanhamento (artifact "Painel SketchUp", privado):
  https://claude.ai/artifact/GqdpVJhwLbcVzWxSVp3WUw — status, progresso, log
  e imagens (viewport + pranchas), atualizado pelo Claude durante o trabalho.

- TestUp ao vivo: 26/26 (novos: escala na viewport ortogonal, extensão da
  cena em `ModelData.scenes`). `TC_ModelData` deixou de depender do modelo aberto.

- Template `.layout` do usuário (opção "Carimbo: Meu template do LayOut…",
  lembrado entre sessões): capa removida, carimbo/moldura do template em toda
  prancha, viewport no maior espaço livre + legenda (cena · descrição ·
  escala). Ao vivo com Contemporary e Simple A3: 4 pranchas em 5 s.
  UI separada em `dialog.rb`; `OutputPath` e `SceneFilter` extraídos.
  127 unitários; TestUp 28/28.

- `sketchup/mesh_export.rb`: retrato 3D leve do modelo visível (triângulos
  por cor de material + arestas duras, metros, Z para cima), só leitura.
  Modelo de teste: 122 faces em 32 ms, 147 KB de JSON. Usado pelo visualizador
  3D do painel; vira ferramenta MCP. TestUp 33/33.
- Painel: versão mobile first, imagens em tela cheia (setas, Esc, arrastar
  com o dedo) e visualizador 3D (three.js r128) do `board/model3d`.

- **MCP Modo 1 (servidor local) implementado**: `core/actions.rb` +
  `core/events.rb` (portas e adaptadores), `mcp/` (protocolo, HTTP, serviço,
  11 ferramentas em grupos), feature `agent_connection` (menu + janela com
  comandos para Claude Code/Cursor/VS Code/Claude Desktop), proxy de dev
  `tools/devbridge/mcp_proxy.py`. 161 testes unitários.
- Ao vivo: pelo proxy, initialize → tools/list (11) → chamadas ok, imagem da
  vista, erro legível; servidor HTTP no Windows respondeu 200 (token certo),
  401 (errado), 403 (Origin de outro site). Servidor deixado desligado.
- Achado: threads Ruby dentro do SketchUp só avançam nos ticks do timer
  (sonda HTTP interna levou ~15 s); clientes externos não sofrem isso.

- Catálogo MCP (`tools/mcp/catalog.yml` + teste): 176 classes em 17 grupos.
- **V-Ray na prática** (pedido do usuário): 1º render por script (640×360,
  27 s); grupo V-Ray no MCP (status, configurações, `render_scene` como job,
  status com imagem, cancelar), testado ao vivo pelo proxy; `core/jobs.rb`.
  Achados: progresso do V-Ray é por etapa; configurações só persistem ao
  salvar o modelo. TestUp 36/36; 175 unitários. Renders no painel.

- Prompts MCP (skills): `render_setup`, `presentation_package`,
  `scene_review`, verificados ao vivo. O protocolo agora é recriado a cada
  mensagem (recarregar código vale mesmo com o servidor ligado).

- Luzes V-Ray via MCP: `list_lights`, `create_light` (retângulo, esfera,
  spot, omni, IES, domo com HDRI; posição + alvo em metros), `update_light`
  (inclui o sol). Verificado ao vivo com render: luz vermelha mirada na
  fachada, domo com HDRI. Achados na referência (definição sem instância,
  emissão em −Z, tamanhos em meia-medida/polegadas).

- Materiais V-Ray via MCP: `list_vray_materials`, `create_vray_material`
  (metal, vidro… por parâmetros amigáveis), `update_vray_material`,
  `convert_material_to_vray` e `apply_material` (por id ou seleção).
  Verificado ao vivo com render (caixa dourada + vidro). Achado: a conversão
  exige "/Nome" e cria o filho "/Nome/BRDFVRayMtl". TestUp 40/40; 188 unit.

- `render_all_scenes`: lote de cenas como job `render_batch` encadeado por
  eventos; ao vivo 3 cenas em 44 s. Cenas passam a ser mostradas com a câmera
  aplicada na hora (a seleção de página anima a transição).
- Recarga de dev: métodos removidos de um arquivo continuam no módulo até
  reiniciar o SketchUp (achado ao mover `render_job` para o `Support`).

- **Dor da Lilian (parâmetros por iluminação)**: `get/set_render_parameters`
  (35 parâmetros com nomes amigáveis: câmera física, auto exposição e
  balanço de branco, Reinhard/burn, GI e AO, sol/céu, ambiente; esquema do
  MCP gerado da tabela), `set_time_of_day`, `list/apply_lighting_preset`
  (exterior_day, exterior_golden_hour, overcast, interior_daylight,
  interior_artificial, studio). Cômodo de teste (temp): padrão = escuro,
  `interior_daylight` = bem exposto, noturno com luminária = cor quente
  natural; com `background_sky` (desliga a textura de céu `/Environment Sky`
  no fundo, `bg_tex_tex_on`) a janela à noite fica azul-escura.
- Render não respeitou `progressive_maxTime` num interior escuro: o job agora
  para o V-Ray no limite e **salva a imagem** ("time limit reached").
- **Início/fim de render sempre visíveis** (pedido do usuário): feature
  `render_notifications` (notificação no SketchUp ao começar e terminar, com
  botão "Abrir pasta"; barra de status nas etapas) e `started_at`/`finished_at`
  em todo job. `Jobs` publica `job.<estado>` só na transição e `job.progress`
  no resto.

Próximo: denoiser, depois
animações (transições de cena do SketchUp, turntable com V-Ray). + auto-texto de cena/escala (P4.4),
escala por cena ortogonal, depois `scene_manager`.

## 2026-09-24 — Pesquisa de demanda nos fóruns + fase LLM/MCP no roadmap

- `tools/docs/fetch_forum_demand.py` + `analyze_forum_demand.py`: cerca de 1,9 mil
  tópicos (SketchUp: job board, extensions, feature requests SU/LayOut, V-Ray,
  AI render, trabalho comercial; Chaos: wishlist e general do V-Ray for SketchUp).
- Relatório: `docs/research/forum-demand-2026-09.md`. Prioridades no roadmap:
  `layout_sheets` → `scene_manager` → `scene_render` → `material_tools` → `data_export`.
- Trimble + Anthropic lançaram em abril de 2026 um MCP oficial (modela na nuvem). Nova Fase 6 do
  roadmap (profissional por LLM: ferramentas + MCP local) e pilar P8 (ações tipadas).
- LayOut, verificado ao vivo: `Model#save_copy` exige um modelo já salvo; as pranchas vão
  exigir `.skp` salvo. As cenas de teste foram removidas do modelo aberto.

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
