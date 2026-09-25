# Demanda nos fóruns (setembro de 2026)

O que profissionais de SketchUp + V-Ray + LayOut pedem, para guiar o roadmap.
Coletado em 2026-09-24 com `tools/docs/fetch_forum_demand.py` e resumido
com `tools/docs/analyze_forum_demand.py`. Os dados brutos ficam em
`docs/reference/_cache/forums/demand/` (fora do git).

## Fontes

| Fonte | Tópicos lidos |
|---|---:|
| forums.sketchup.com: Job Board (pedidos pagos de extensões) | 36 (todos) |
| forums.sketchup.com: Extensions (mais vistos de sempre + do último ano) | 431 |
| forums.sketchup.com: Feature Requests do SketchUp | 330 |
| forums.sketchup.com: Feature Requests do LayOut | 239 |
| forums.sketchup.com: V-Ray for SketchUp | 183 |
| forums.sketchup.com: SketchUp AI Render (Diffusion) | 91 |
| forums.sketchup.com: Commercial & Collaborative Work | 187 |
| forums.chaos.com: V-Ray for SketchUp Wishlist | 207 (todos) |
| forums.chaos.com: V-Ray for SketchUp General | 226 |
| Buscas: "AI plugin", ChatGPT, MCP, LLM, "is there a plugin/extension" | 256 |

Limites: visualizações acumulam com o tempo (tópicos antigos pesam mais);
categorias têm tamanhos diferentes, então compare temas **dentro** de cada
fonte. A classificação é por palavras-chave no título.

## Ranking de oportunidades (para o nosso foco)

| # | Tema | Evidência principal | Concorrência | Encaixe |
|---|---|---|---|---|
| 1 | **Documentação no LayOut** | 143 pedidos no LayOut (340 mil visualizações, 1.853 curtidas); índice de pranchas / lista de desenhos (4,6 mil + 2,5 mil + 2,1 mil), nome da cena em auto-text (7,8 mil), escala em auto-text (5,1 mil), conjuntos de pranchas (3,2 mil), recarregar modelo nas pranchas; job board "Auto-Populate My Layout Sheets" (1,35 mil) | 5D+ (35 mil visualizações, 834 curtidas, pago), "Create LayOut File from Scenes" (2016, parado), ConDoc | **alto**: API validada ao vivo; módulo `layout_sheets` em andamento |
| 2 | **Cenas e tags** | Maior tema dos pedidos do SketchUp (45 tópicos, 202 mil visualizações, 884 curtidas): "Managing scenes in SU" (15,6 mil), tag nova entra em todas as cenas (11 mil), renomear abas de cena (10 mil) | Multitag, Liserok Manager (beta 2026), 5D+ Auto Tag | **alto**: base para render e pranchas por cena |
| 3 | **V-Ray por cena + render em lote** | Wishlist da Chaos: configurações por cena (594 + 275), proporção por cena (763), saída salva na cena (577), escolher cenas no lote (633), vários arquivos (1.143), `.vropt` por cena (167), lote com várias proporções; "V-Ray batch rendering always saves the same scene" (11 mil); "Batch Exports of 2D Graphics from Scenes" (26 mil) | nada dedicado (Chaos escreveu script ad hoc no fórum) | **alto**: núcleo do V-Ray Batch Studio |
| 4 | **Materiais / texturas / assets V-Ray** | Maior tema nos dois fóruns de V-Ray: trocar material (5,8 mil), cor aleatória por objeto (1,5 mil), limpar assets sem uso (319), editor de caminhos / relink (305 + 339), material variação (327), buscar materiais; plugins antigos "Remove C-G Materials" (19,8 mil) e "V-Ray Toys" (13,9 mil) | pouca | **alto**: estende `scene_audit` com ações de correção |
| 5 | **Dados / quantitativos** | Tipo de pedido pago mais comum no Job Board (7 de 36): takeoff para web app (1,3 mil + 750), extrator JSON (527, 19 respostas, 2026), relatórios, Power BI | 5D+ Auto Info, Quantifier, OpenCutList | **médio-alto**: barato e vira ferramenta de leitura do MCP |
| 6 | **Exportação 2D por cena** | DWG com camadas (38,8 mil, 164 curtidas), exportar 2D das cenas em lote (26 mil), nome da cena na exportação (6,1 mil) | parcial | **médio**: mesmo motor do lote por cena |
| 7 | **LLM / MCP / agentes** | Ver seção abaixo | Trimble oficial (nuvem), MCPs da comunidade, Supex, MakeIt4Me | **estratégico** |
| — | Paramétricos (escadas, telhados, estruturas) | Maior volume em Extensions (666 mil visualizações) | Medeek domina, muito nichado | baixo por ora |
| — | Marcenaria / CNC | 311 mil visualizações | OpenCutList (grátis, financiado por crowdfunding) | baixo |
| — | Render IA | Diffusion da Trimble + Veras/Arko | nativo da Trimble | evitar |

## LLM, MCP e agentes

- **Trimble + Anthropic (abril de 2026):** "SketchUp Connector", um MCP
  oficial no diretório de conectores do Claude. Cria geometria a partir de
  texto e imagens **numa sessão de SketchUp na nuvem**, guarda o histórico no
  chat e entrega o `.skp` para download (30 modelos grátis, depois pago). O
  foco é "3D for everyone", modelagem a partir do zero.
  ([comunicado](https://www.prnewswire.com/news-releases/trimble-links-sketchup-with-anthropics-claude-bringing-new-conversational-ai-powered-capabilities-to-3d-modeling-302756403.html))
- **Trimble procura parceiros (maio de 2026):** "Shape the future of AI on
  SketchUp: Work with us on our MCP developer projects!" convida extensões com
  "API acessível ou produtizada" a se ligarem aos frameworks de IA da Trimble.
  ([tópico 347037](https://forums.sketchup.com/t/347037))
- **Comunidade:** MCPs abertos (github.com/mhyrr/sketchup-mcp,
  github.com/russell-qca/sketchup-mcp), Supex (Claude Code + MCP executando
  Ruby no SketchUp, [342543](https://forums.sketchup.com/t/342543)),
  MakeIt4Me. "Does SketchUp have plans to launch a corresponding MCP?"
  (1,6 mil visualizações, 35 curtidas, [346416](https://forums.sketchup.com/t/346416)).
  "Claude Fable 5 and the Future of SketchUp Modeling" (3,9 mil
  visualizações, 274 curtidas, 192 posts).
- **Sentimento misto:** parte da comunidade rejeita "IA que modela por mim".
  Recebem melhor a automação de tarefas repetitivas do profissional.
- A própria Trimble já tem "AI Assistant" e "AI Render" nativos no SketchUp 2026.

**Leitura para nós:** a modelagem genérica por prompt já é da Trimble, na
nuvem. O espaço livre é o **desktop do profissional**: agir no modelo aberto,
com V-Ray e LayOut, através de ferramentas de alto nível com conhecimento do
domínio ("renderize as cenas X com materiais Y", "gere o conjunto de
pranchas", "audite e corrija texturas", "extraia quantitativos"), e não com
Ruby arbitrário. Isso também é o tipo de "API produtizada" que a Trimble diz
procurar em parceiros.

## Pedidos pagos do Job Board (36 tópicos, 2022–2026)

Geradores específicos (muro de arrimo, parede de escalada, madeiramento
tradicional com 3,3 mil visualizações, planograma, abraçadeiras de tubo),
exportação de dados e takeoff para web apps, importador de componentes,
numeração de componentes dinâmicos, pranchas automáticas no LayOut, XREF,
cutlist, cálculo de área, plugins de IA, extrair vistas e ativos 2D, análise
de luz e vista. Há pedidos em espanhol e português (suporte pt-BR/es é
vantagem). Referência de preço vista: ~US$100/h.
