# MCP: SketchUp, LayOut e V-Ray para agentes

Proposta de 2026-09-25 (pedido do usuário: expandir ao máximo as ferramentas
que um agente pode usar, das simples às complexas, sem ignorar nenhuma parte
da API). Estado: **Modo 1 implementado e verificado ao vivo** (11 ferramentas);
catálogo completo e Modo 2 pendentes.

## Arquitetura de comunicação (portas e adaptadores)

Pedido do usuário: base modular, reutilizável, pouco verbosa, que escale em
eventos e abrangência. Dois eixos, e só eles:

```
                 ┌──────────── Ações (core/actions.rb) ────────────┐
 adaptadores     │ nome · descrição · esquema (Params) · handler   │
 de entrada ───► │ anotações (read_only, destructive, idempotent)  │
 menu, MCP HTTP, └──────────────────────┬──────────────────────────┘
 proxy dev,                             │ publica
 relay (futuro)                         ▼
                 ┌──────────── Eventos (core/events.rb) ───────────┐
                 │ "action.completed" · "action.failed" · "mcp.*"  │ ──► assinantes:
                 │ (depois: "model.*", "render.*", "selection.*")  │     janela do agente,
                 └─────────────────────────────────────────────────┘     notificações MCP,
                                                                         relay, painel, log
```

- **Ação** = tudo o que o sistema *faz*. Registrada uma vez; qualquer
  transporte a chama (`Actions.call(nome, entrada, source:)`). Nenhuma lógica
  por transporte.
- **Evento** = tudo o que *acontece*. Publicado uma vez; quem quiser assina
  por prefixo. Assinante com erro não derruba os outros; histórico curto em
  memória (`Events.recent`).
- **Transporte** = adaptador fino: `Mcp::Endpoint` (HTTP local),
  `Mcp::Service.handle_json` (entrada genérica usada pelo proxy de dev e, no
  futuro, pelo relay), comandos de menu.
- **Grupos de ferramentas** = um arquivo por grupo em `mcp/tools/`
  (`extend Support` para os utilitários comuns). Crescer = arquivo novo.

## Implementado (2026-09-25)

| Peça | Arquivo | Verificação |
|---|---|---|
| Esquema + JSON Schema (tipos string/boolean/integer/number/enum/array, obrigatório, descrição) | `core/params.rb` | unit |
| Registro de ações + eventos por chamada | `core/actions.rb`, `core/events.rb` | unit + ao vivo |
| JSON-RPC do MCP (initialize com negociação de versão, ping, tools/list, tools/call, lotes, notificações) | `mcp/protocol.rb`, `tool_listing.rb`, `tool_result.rb` | unit + ao vivo |
| Streamable HTTP local: POST `/mcp`, token Bearer, `Origin` local, 202/401/403/404/405, `Mcp-Session-Id` | `mcp/http.rb`, `endpoint.rb`, `server.rb` | unit (TCP real) + ao vivo no Windows (200/401/403) |
| Serviço: token (`Random.urandom`), portas 7878–7887, início automático | `mcp/service.rb` | ao vivo |
| Janela "Conectar Agente de IA (MCP)" com comandos para Claude Code, Cursor, VS Code, Claude Desktop | `features/agent_connection/` | unit |
| Ferramentas: `model_info`, `list_scenes`, `create_scene`, `activate_scene`, `list_materials`, `list_tags`, `list_components`, `get_selection`, `capture_view`, `audit_scene`, `generate_layout_sheets` | `mcp/tools/*.rb`, features | ao vivo pelo proxy |
| Proxy stdio de desenvolvimento (cliente MCP → Dev Bridge → SketchUp do desktop) | `tools/devbridge/mcp_proxy.py` | ao vivo |

Para usar o proxy no Claude Code (desenvolvimento):
`claude mcp add sketchup-dev -- python3 tools/devbridge/mcp_proxy.py`.

## Como o usuário conecta

Fluxo desejado: baixa a extensão → faz login → abre o cliente MCP dele →
encontra o nosso servidor → conecta ao SketchUp que está aberto. Dá para
fazer, em dois modos que usam a **mesma** base (registro de ferramentas +
protocolo MCP dentro da extensão):

### Modo 1: local (primeiro a construir)

```
cliente MCP (Claude Code, Cursor, VS Code, Claude Desktop…)
   │  HTTP em 127.0.0.1:<porta>/mcp  (Streamable HTTP, token)
   ▼
extensão no SketchUp  →  API Ruby do SketchUp / LayOut / V-Ray
```

- A extensão abre o servidor só em `127.0.0.1`, com token gerado na
  instalação e mostrado numa janela "Conectar agente" (com o JSON pronto para
  colar na configuração do cliente).
- Sem conta, sem servidor nosso, sem custo de infraestrutura; nada sai da
  máquina.
- Clientes que falam só stdio (ex.: configuração local do Claude Desktop)
  usam um adaptador stdio→HTTP. Opções: pacote `.mcpb` (Desktop Extension)
  ou `npx mcp-remote`. **[a verificar]** qual cada cliente aceita hoje e se
  conectores do claude.ai (que rodam na nuvem) alcançam `localhost` (esperado: não).

### Modo 2: login + túnel na nuvem (o fluxo descrito pelo usuário)

```
cliente MCP (claude.ai, ChatGPT, qualquer cliente remoto)
   │  HTTPS + OAuth (login da nossa conta)
   ▼
relay nosso (mcp.<domínio>/u/<conta>)
   ▲  WebSocket de saída, autenticado (a extensão liga para fora)
   │
extensão no SketchUp do usuário
```

- A extensão, após login, abre uma conexão **de saída** para o relay (não
  abre porta na máquina, atravessa firewall/NAT). O relay expõe um endpoint
  MCP remoto por conta, com autorização OAuth conforme a spec do MCP.
- Funciona com clientes web e móveis; casa com licenciamento (a conta é a
  licença) e com o painel ao vivo.
- Custos e riscos: servidor sempre ligado (conexões persistentes: Cloudflare
  Durable Objects, Fly.io ou similar; funções serverless comuns não servem
  para WebSocket longo **[a verificar]**), segurança de conta, LGPD.
- **[a verificar]** política do Extension Warehouse para extensão que
  conversa com servidor próprio e EULA da Trimble/Chaos para controle remoto
  por agente.

Recomendação: construir o Modo 1 primeiro (valida as ferramentas com agentes
de verdade em semanas), desenhando o código para o Modo 2 ser só outro
transporte.

## Segurança (vale para os dois modos)

- **Lista fechada de ferramentas**, cada uma com esquema de entrada; nada de
  `eval` por padrão. A Dev Bridge nunca entra no produto.
- Anotações MCP em toda ferramenta: `readOnlyHint`, `destructiveHint`,
  `idempotentHint`. Destrutivas (apagar, salvar por cima, exportar por cima)
  pedem confirmação no cliente e respeitam uma opção "pedir confirmação no
  SketchUp".
- Toda alteração dentro de `start_operation`/`commit_operation`: um Ctrl+Z
  desfaz cada chamada do agente.
- Validação de `Origin` e token no servidor local (proteção contra DNS
  rebinding, exigida pela spec para servidores locais).
- Indicador visível no SketchUp ("agente conectado"), botão de pausar e log
  das chamadas.
- `execute_ruby` (código livre): só como **modo avançado** desligado por
  padrão, ligado pelo usuário, com confirmação por chamada. Decisão pendente.

## Arquitetura dentro da extensão

```
core/params.rb         esquema + validação (já existe)
core/actions.rb        registro: nome, título, descrição, esquema de entrada
                       e saída, anotações, handler (novo)
core/mcp/protocol.rb   JSON-RPC 2.0 do MCP: initialize, tools/list,
                       tools/call, resources/*, prompts/*, ping (puro, testável)
core/mcp/http.rb       Streamable HTTP em 127.0.0.1, atendido no thread
                       principal por timer (a API do SketchUp não é thread-safe)
features/<x>/          cada feature registra suas ações (P8)
tools/<grupo>/         ferramentas "de API" (modelo, entidades, materiais…)
```

- As ferramentas ficam separadas por **grupo**; o usuário liga/desliga grupos
  (clientes pioram com centenas de ferramentas soltas).
- Além de ferramentas: **resources** (resumo do modelo, cenas, seleção,
  imagem da vista atual) e **prompts** (fluxos prontos, ex.: "apresentação de
  interiores").

## Cobertura máxima sem centenas de ferramentas soltas

A API tem 156 classes e 2.093 métodos (SketchUp + Geom + UI + LayOut) mais o
V-Ray. Estratégia em 4 camadas:

1. **Fluxos completos** (compostos): pranchas do LayOut por cena, pacote de
   apresentação (cenas → renders V-Ray → pranchas), variações de material,
   turntable, auditoria + correção, quantitativos.
2. **Ferramentas de domínio** tipadas (criar cena, aplicar material, criar
   parede, colocar componente, renderizar cena…).
3. **Ferramentas genéricas seguras**: `inspect_entity` (lê todas as
   propriedades de uma entidade) e `set_entity_properties` (só setters de uma
   lista permitida **gerada do índice da API**), `query_entities` (filtros por
   tipo, tag, material, nome, caixa, definição). Cobrem centenas de métodos
   com poucas ferramentas.
4. **Visão**: capturar a vista (`View#write_image`) e o modelo 3D
   (`MeshExport`) para o agente ver o que fez.

Garantia de "nenhuma ignorada": um catálogo (`tools/mcp/catalog.yml`) liga
cada classe do `sketchup-api-index.md` e do V-Ray a um grupo de ferramentas,
ou a `interno` com motivo (ex.: observers, `Sketchup::Tool`, menus). Um teste
unitário falha se aparecer classe sem destino.

## Grupos de ferramentas (rascunho)

| Grupo | Classes da API | Exemplos de ferramentas |
|---|---|---|
| modelo | Model, OptionsManager/Provider, RegionalSettings, Axes, Georeferência, Environment(s), Classifications | informações e estatísticas, unidades, opções, salvar/salvar cópia, georreferência, classificar (IFC) |
| consulta e inspeção | Entity, Drawingelement, Entities, InstancePath, AttributeDictionary(ies), Set | `query_entities`, `inspect_entity`, atributos (ler/gravar), ID persistente |
| geometria | EntitiesBuilder, Face, Edge, Vertex, Loop, EdgeUse, Curve, ArcCurve, Geom::* | caixa, face, linhas, círculo/arco/polígono, push/pull, follow-me, offset, interseção, suavizar, espelhar, matriz de cópias, booleanas (Pro) |
| transformações | Geom::Transformation, Group, ComponentInstance | mover, girar, escalar, alinhar, copiar, explodir |
| componentes | ComponentDefinition, ComponentInstance, Group, DefinitionList, Behavior | listar, inserir, carregar `.skp`, tornar único, trocar definição, salvar como, componentes dinâmicos, purgar |
| materiais | Material(s), Texture, TextureWriter, UVHelper, Color, ImageRep | listar, criar, editar, aplicar, trocar A→B, textura (tamanho, posição), exportar texturas, purgar |
| tags | Layer(s), LayerFolder, LineStyle(s) | criar, renomear, pastas, cor, tracejado, visibilidade, mover entidades |
| cenas e vistas | Page(s), Camera, View, Style(s), RenderingOptions, ShadowInfo, Animation | criar/atualizar/reordenar cenas, visibilidade por cena, câmera e vistas padrão, sombras, estilos, **captura de imagem** |
| anotação | Text, Dimension(Linear/Radial), ConstructionLine/Point, SectionPlane | textos, cotas, guias, cortes (criar, ativar, preenchimento) |
| seleção | Selection | ler, definir, limpar, selecionar por consulta |
| importar/exportar | Model#import/export, Importer, Image, Skp | importar DWG/imagens/3D, exportar 2D/3D/PDF, retrato 3D (`MeshExport`) |
| LayOut | Layout::* (32 classes) | criar/abrir documento, páginas, camadas, viewports (cena, escala, render), textos, rótulos, cotas, tabelas, formas, imagens, auto-texto, exportar PDF/PNG; pranchas por cena |
| V-Ray | VRay::* (19 classes documentadas) | configurações e presets, materiais VRayMtl, luzes (retângulo, esfera, domo/HDRI, IES, sol), câmera física, render de cena/lote, salvar imagem, render elements, `.vrscene`, arquivos faltando |
| relatórios | features | auditoria de cena, quantitativos (áreas/volumes por material), lista de componentes |
| aplicativo | Sketchup (módulo), UI | versão, idioma, notificações ao usuário, confirmação no SketchUp |
| interno (sem ferramenta) | *Observer, Tool/Tools, Menu, Console, SketchupExtension, LanguageHandler, Licensing, Http, InputPoint, PickHelper, Overlay | usados pela própria extensão (eventos, licença, UI), não fazem sentido como ação de agente |

## Fases

1. Base: `actions.rb` + `protocol.rb` + servidor local + janela "Conectar
   agente"; ferramentas das features existentes; teste com Claude Code.
2. Catálogo com teste de cobertura; grupos modelo, consulta, geometria,
   materiais, tags, cenas, seleção, visão.
3. LayOut e V-Ray completos; fluxos compostos; resources e prompts.
4. Modo 2 (login + relay) e licenciamento.
