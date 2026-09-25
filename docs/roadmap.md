# Roadmap e backlog de produtos

Fonte: todos os 37 tópicos do Job Board do fórum SketchUp
(forums.sketchup.com/c/developers/job-board/92, lidos em 2026-09-24), dores
recorrentes no fórum da Chaos (V-Ray for SketchUp) e fórum Developers.
Transcrições em `docs/reference/_cache/forums/`. Números entre colchetes são
IDs de tópicos (`forums.sketchup.com/t/<id>`, ou `forums.chaos.com/t/<id>`
quando marcados "Chaos").

Tese: **automação de V-Ray dentro do SketchUp** é o diferencial — quase
ninguém atende, os pedidos aparecem repetidamente e a própria Chaos responde
"dá para fazer com script" sem oferecer produto. Dados/relatórios têm demanda
grande, mas concorrência forte (OpenCutList, 5D+, Speckle).

Status: `ideia` → `validando` → `em andamento` → `beta` → `publicado`.

---

## Mercado e distribuição

- Extension Warehouse: listagem grátis, revisão de código (selo de
  confiança), atualização automática, loja integrada com comissão da Trimble
  só sobre vendas. Revisões podem atrasar semanas [346795].
- Alternativas: SketchUcation, venda direta (newsletter própria).
- Referência de preço de contrato vista no fórum: ~US$100/h; "35 h ≈ US$3.500" [279699].
- Pedidos chegam em espanhol/português [309721, 349802, 214605] — suporte
  pt-BR/es é vantagem competitiva (usar `LanguageHandler`).
- Armadilha de mercado: extensões triviais são mal vistas pela comunidade
  [224657]; foque em problemas com valor real e profundidade.

---

## Prioridades (atualizado 2026-09-24)

Base: `docs/research/forum-demand-2026-09.md` (cerca de 1,9 mil tópicos dos fóruns do
SketchUp e da Chaos). Ordem dos próximos módulos (cada um só usa pilares; ver
`docs/platform.md`):

1. `layout_sheets`: pranchas por cena + índice + auto-text de cena/escala + PDF (Fase 5).
2. `scene_manager`: matriz cenas × tags, renomear em lote, propriedades por cena.
3. `scene_render`: configurações V-Ray por cena (proporção, saída, `.vropt`) + fila de render (Fase 2).
4. `material_tools`: trocar e limpar materiais sem uso, relink de texturas, cor aleatória (Fase 3).
5. `data_export`: JSON/CSV de componentes, materiais e áreas (Fase 4).
6. Desde já, cada módulo expõe **ações tipadas** (pilar P8) que viram
   ferramentas do MCP (Fase 6).

Evitar por ora: paramétricos (Medeek), marcenaria/CNC (OpenCutList), render
IA (Diffusion nativo da Trimble).

## Fases

### Fase 0 — Bootstrap do harness ✅
Toolchain Docker, lint EW, testes, `.rbz`, ponte WSL↔SketchUp, base de
referência, extensão mínima `V-Ray Toolkit`.

### Fase 1 — Fundação técnica (pré-requisito de todo produto)
Validar tudo que hoje está "a verificar" com SketchUp + V-Ray reais e construir
os pilares da plataforma (`docs/platform.md`), cada um puxado por um módulo real.

| # | Item | Status |
|---|---|---|
| F1.1 | Desktop: OpenSSH + Dev Bridge (`docs/remote-desktop-setup.md`); `make su-ping` ok | ✅ |
| F1.2 | `make vray-docs-import` e revisar `docs/reference/vray-ruby-api.md` contra a doc oficial | ✅ (V-Ray 7.20) |
| F1.3 | Instalar TestUp 2 no desktop e rodar `make su-test` (VRayBridge) | ✅ |
| F1.4 | Mapear *user data* ↔ core (exportar `.vropt`/`.vrmat`) para settings e VRayMtl | ideia |
| F1.5 | Núcleo de travessia do modelo (transformação, visibilidade, herança de material, PID) testado | ideia |
| F1.6 | Motor de eventos de render (subscriber, fila, estados, timeouts) sem bloquear a UI | ideia |
| F1.7 | Framework de UI `HtmlDialog` (Modus ou Vue), ponte Ruby↔JS com `to_json`, i18n pt-BR/en/es | ideia |
| F1.8 | Licenciamento EW (`Sketchup::Licensing`) + modo trial | ideia |
| F1.9 | Build multi-produto (manifestos, core copiado por namespace) — pilar P0 | ✅ |
| F1.10 | Kernel (comandos, menu, i18n, erros) — pilar P1 | ✅ mínimo (falta toolbar, preferências) |
| F1.13 | Ações tipadas (entrada com esquema, sem UI) por feature — pilar P8, base do MCP | em andamento (`Params` + `InputForm`; 1ª ação: `LayoutSheets.generate`) |
| F1.12 | Módulo `scene_audit` (arquivos V-Ray faltando, texturas pesadas, materiais sem uso) | ✅ beta, validado ao vivo |
| F1.11 | Mapa da API do LayOut (`docs/reference/layout-api.md`) + validação ao vivo | em andamento |

### Fase 2 — Produto 1: **V-Ray Batch Studio** (automação de render)
O pedido mais recorrente e sem produto dedicado.

| # | Funcionalidade | Evidência | Status |
|---|---|---|---|
| P1.1 | **Variações de material**: renderizar o mesmo enquadramento com N materiais (ex.: 37 tecidos de cadeira), nome de arquivo por variação | Chaos 118077 (Chaos escreveu script ad hoc) | ideia |
| P1.2 | **Turntable / ângulos**: girar objeto ou câmera em passos (8 vistas por produto × cores) | Chaos 110768 | ideia |
| P1.3 | **Fila multi-arquivo**: renderizar cenas de vários `.skp` em sequência (noite toda) | Chaos 112672 (script "usa classes internas") | ideia |
| P1.4 | **Pacote de passes/vistas**: exportar imagens de todas as cenas com variações de estilo (arestas on/off, materiais, máscaras) | 315200 | ideia |
| P1.5 | **Renderizar só o objeto selecionado** (demais com Wrapper matte/alpha −1) para catálogos/sprites | SketchUp 131551 | ideia |
| P1.6 | Presets por job (qualidade, resolução, câmera, saída), relatório de tempo por imagem | Chaos 116721, 104132 | ideia |
| P1.7 | Integração com Chaos Cloud / render farm (avaliar API) | Chaos 115622 | ideia |

### Fase 3 — Produto 2: **V-Ray Asset Tools** (manutenção de cena)
| # | Funcionalidade | Evidência | Status |
|---|---|---|---|
| P2.1 | **Edição em lote de materiais** (seleção/tag/filtro → reflexão, glossiness, bump…) | Chaos 112546 (feature request aberto na Chaos) | ideia |
| P2.2 | **Relink inteligente de texturas** entre máquinas/Dropbox/Google Drive: raízes de busca persistentes, relativo ao projeto | Chaos 117780, 119587 | ideia |
| P2.3 | **Auditoria de cena**: texturas faltando/pesadas, materiais não usados, proxies, luzes; relatório e correções | Chaos 115335 + dor comum | ideia |
| P2.4 | Câmeras avançadas via UI (fisheye, esférica, cilíndrica, clipping) | Chaos 104139 | ideia |
| P2.5 | Gerenciador de luzes (lister) para V-Ray no SketchUp | Chaos 117276 (pedido em Max) | ideia |

### Fase 4 — Produto 3: **Dados e quantitativos**
Concorrência forte; diferenciar por personalização e integração.

| # | Funcionalidade | Evidência | Status |
|---|---|---|---|
| P3.1 | **Relatórios configuráveis** (colunas, ordenação, agrupamento, filtros por atributo/DC) → CSV/XLSX/JSON | 214605 (fábrica de móveis BR), 228036, 218785, 222692 | ideia |
| P3.2 | **Quantitativo de materiais** (m, m², m³ por material/espessura) | 222149, 228036, 218785 | ideia |
| P3.3 | **Conector HTTPS/JSON** com identidade persistente (PID), envio pós-save assíncrono, fila offline, writeback manual | 346636 (arquitetura discutida em detalhe), 317011, 222149 | ideia |
| P3.4 | Numeração sequencial de componentes/DCs para relatórios | 222692 | ideia |
| P3.5 | Caixa de atributos globais para Dynamic Components | 239206 | ideia |

### Fase 5 — Produto 4: **LayOut automático** (prioridade 1)
| # | Funcionalidade | Evidência | Status |
|---|---|---|---|
| P4.1 | Gerar pranchas LayOut a partir das cenas (por prefixo, ex.: `E.Front`, `P.Kitchen1`) com template | 236504; LayOut FR: 143 pedidos de documentação | beta: módulo `layout_sheets` (papel/orientação, carimbo, índice, PDF, escala, template do usuário), TestUp ao vivo |
| P4.2 | Pranchas de renders V-Ray + legendas | combina P1 + P4.1 | ideia |
| P4.3 | Índice de pranchas / lista de desenhos automática (1ª versão em `layout_sheets`) | LayOut FR: 4,6 mil + 2,5 mil + 2,1 mil visualizações | ideia |
| P4.4 | Carimbo com nome da cena, escala, nº/total, data (texto gerado; auto-text quando a API permitir) — feito: carimbo próprio com escala automática, ou **template do usuário** com legenda por viewport | 7,8 mil + 5,1 mil visualizações | beta |
| P4.5 | Regenerar pranchas quando o modelo muda (a API não tem "Update Model Reference") | "Reloading new models…", "Shortcut to update Layout reference" | ideia |
| P4.6 | Exportar um PDF por prancha | "Layout export to separate files per page" | ideia |

### Fase 6 — **Profissional por LLM** (ferramentas + servidor MCP)
Pedido do usuário (2026-09-24): profissionais criarem **tudo** (projeto,
render, detalhamento, LayOut) conversando com um LLM.
Ampliado em 2026-09-25: transformar SketchUp, LayOut e V-Ray no **máximo de
ferramentas/skills MCP** para agentes do mundo todo. Arquitetura proposta: o
MCP roda **local** na extensão (licença do usuário), cada agente se conecta ao
SketchUp do próprio profissional; tools geradas do registro de ações (P8);
nunca `eval` no produto. Ordem: seguir o roadmap; esta fase começa depois dos
módulos prioritários. A Trimble já tem um
MCP oficial, mas ele modela do zero **na nuvem**. O nosso espaço é o SketchUp
do desktop com V-Ray e LayOut, através de ferramentas de alto nível
(`docs/research/forum-demand-2026-09.md`).

| # | Funcionalidade | Status |
|---|---|---|
| L1 | Pilar P8: cada feature expõe ações tipadas (nome, descrição, esquema de entrada/saída), chamadas pela UI e pelo MCP | feito (`core/actions.rb` + eventos) |
| L2 | (feito: Modo 1, 11 ferramentas, verificado ao vivo) Servidor MCP local do produto: só 127.0.0.1, token, **lista fechada de ações** (sem `eval`; a Dev Bridge nunca é reaproveitada no produto). Transporte a decidir: HTTP dentro do SketchUp ou processo stdio separado. Confirmar a política do EW para servidor local **[a verificar]** | ideia |
| L3 | Ferramentas de leitura: modelo, cenas, tags, materiais, V-Ray, auditoria, quantitativos, captura do viewport | ideia |
| L4 | Ferramentas de projeto/modelagem: geometria básica, componentes, tags, cenas, câmeras (com desfazer por operação) | ideia |
| L5 | Ferramentas de render: materiais V-Ray, luzes, configurações por cena, render/lote, salvar imagens | ideia |
| L6 | Ferramentas de detalhamento/LayOut: pranchas, viewports, cotas, textos, PDF | ideia |
| L7 | Skills/prompts de fluxo (ex.: "apresentação de interiores": cenas → materiais → render → pranchas) | ideia |
| L0 | Arquitetura em `docs/mcp.md` (2026-09-25): Modo 1 local (127.0.0.1 + token) e Modo 2 login + relay na nuvem; 4 camadas de ferramentas; catálogo com teste de cobertura | em andamento |
| L9 | **Catálogo máximo de ferramentas** (pedido 2026-09-25): inventário das APIs SketchUp + LayOut + V-Ray → lista de ferramentas por grupo (modelo, cenas, tags, materiais, V-Ray, render, LayOut), ligáveis por grupo; ferramentas genéricas-seguras (consulta de entidades, parâmetro V-Ray de lista permitida) para cobrir muita API com poucas tools | ideia |
| L10 | Registro de ações → JSON Schema → servidor MCP gerado automaticamente (cada feature nova vira tool) | ideia |
| L11 | Skills públicas (pacotes de fluxo que usam as tools) para agentes de qualquer fornecedor | ideia |
| L12 | A verificar: política do EW para servidor local, EULA Trimble/Chaos para automação por agente, posicionamento frente ao MCP oficial da Trimble | ideia |
| L8 | Parceria com a Trimble ("MCP developer projects", tópico 347037) quando houver API produtizada | ideia |

### Backlog aberto (sob demanda / contrato / nichos)
| Item | Evidência |
|---|---|
| Biblioteca/importador de componentes com thumbnails grandes e pastas restritas | 239207 |
| XREF (referências externas, recarregar definições — `DefinitionList#load` ok desde 2023) | 244099 |
| Análise de vista/luz natural: % de materiais vistos por uma abertura (ray casting) + imagem fisheye com materiais em cor sólida + CSV | 343422 (casa bem com V-Ray fisheye + material override) |
| Render por IA/servidor a partir do viewport | 244154, 295162 |
| Gerador paramétrico de muro de contenção segmental com contagem de blocos | 229151 |
| Painéis para muros de escalada (espessura com ângulos) + exportação CAD | 274989 |
| Sistemas modulares com SKU por posição/tamanho → lista de corte + vista explodida | 331750 |
| Estruturas de tubo com conectores (key clamps) | 295779 |
| Planograma (prateleiras e produtos) | 274955 |
| Estiramento com zonas fixas (painéis de porta) | 214352 |
| Distribuir formas sobre face conforme matriz CSV 0/1 | 293364 |
| Timber framing com auto-design e custo | 274491, 274069 |
| Porte de extensões antigas para versões novas do SketchUp (serviço) | 285997 |

---

## Backlog técnico (harness)

| Item | Status |
|---|---|
| CI remoto (GitHub Actions: lint, testes, `.rbz` como artefato) — `.github/workflows/ci.yml` | publicado |
| Hook de pre-commit com `make check` | ideia |
| Anotações via Text tool como "ponteiro" para o agente (ideia do Claude Bridge) na Dev Bridge | ideia |
| Depuração com breakpoints remota (DAP 7150 por túnel SSH + mapeamento de caminhos) | ideia |
| Script de assinatura/criptografia (Extension Signing Portal) para distribuição fora do EW | ideia |
| Perfilamento (SpeedUp da SketchUp) para operações pesadas | ideia |
