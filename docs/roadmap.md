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

## Fases

### Fase 0 — Bootstrap do harness ✅
Toolchain Docker, lint EW, testes, `.rbz`, ponte WSL↔SketchUp, base de
referência, extensão mínima `V-Ray Toolkit`.

### Fase 1 — Fundação técnica (pré-requisito de todo produto)
Validar tudo que hoje está "a verificar" com SketchUp + V-Ray reais.

| # | Item | Status |
|---|---|---|
| F1.1 | Desktop: OpenSSH + Dev Bridge (`docs/remote-desktop-setup.md`); `make su-ping` ok | ✅ |
| F1.2 | `make vray-docs-import` e revisar `docs/reference/vray-ruby-api.md` contra a doc oficial | em andamento (doc importada) |
| F1.3 | Instalar TestUp 2 no desktop e rodar `make su-test` (VRayBridge) | ✅ |
| F1.4 | Mapear *user data* ↔ core (exportar `.vropt`/`.vrmat`) para settings e VRayMtl | ideia |
| F1.5 | Núcleo de travessia do modelo (transformação, visibilidade, herança de material, PID) testado | ideia |
| F1.6 | Motor de eventos de render (subscriber, fila, estados, timeouts) sem bloquear a UI | ideia |
| F1.7 | Framework de UI `HtmlDialog` (Modus ou Vue), ponte Ruby↔JS com `to_json`, i18n pt-BR/en/es | ideia |
| F1.8 | Licenciamento EW (`Sketchup::Licensing`) + modo trial | ideia |

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

### Fase 5 — Produto 4: **LayOut automático**
| # | Funcionalidade | Evidência | Status |
|---|---|---|---|
| P4.1 | Gerar pranchas LayOut a partir das cenas (por prefixo, ex.: `E.Front`, `P.Kitchen1`) com template | 236504 | ideia |
| P4.2 | Pranchas de renders V-Ray + legendas | combina P1 + P4.1 | ideia |

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
