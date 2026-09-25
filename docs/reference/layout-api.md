# LayOut — mapa da API e das fontes

LayOut é o app de pranchas 2D do SketchUp Pro (plantas, cortes, folhas de
apresentação, PDF). Mapeado em 2026-09-24.

## Onde a automação é possível

| Via | Onde roda | Uso | Estado no projeto |
|---|---|---|---|
| **Ruby `Layout::*`** | **dentro do SketchUp** (não do app LayOut) | criar/abrir/editar `.layout`, exportar PDF/imagens | disponível ao vivo **[7.20/SU 26.1]**: `Layout` com 32 constantes |
| C API do LayOut | executável próprio (SDK Windows/macOS) | ler/escrever `.layout` fora do SketchUp (servidor, lote) | SDK sob pedido em developer.sketchup.com; não baixado |
| App LayOut | `C:/Program Files/SketchUp/SketchUp 2026/LayOut/LayOut.exe` no desktop | usuário abre o resultado | instalado |

**O LayOut não tem API "ao vivo"**: não dá para mexer no documento aberto na
janela do LayOut. O fluxo é SketchUp → gera/atualiza o arquivo `.layout` →
usuário abre (ou exportamos PDF direto). [fórum 236504, DanRathbun]

## Fontes

- Índice de métodos com versão mínima: `docs/reference/sketchup-api-index.md`,
  seções `## Layout*` (33 classes; gerado dos stubs oficiais).
- Stubs: `docs/reference/_cache/sketchup-api-stubs/Layout/*.rb`.
- Notas de versão (mudanças da API LayOut): `_cache/sketchup-api-guides/ReleaseNotes.md`.
- Limitações e pedidos reais: `_cache/forums/sketchup-forum-job-board.md` (tópico 236504).
- C API: `_cache/sketchup-c-api/` (resumo; a doc da parte LayOut vem com o SDK).

## Peças principais (versão mínima)

- `Layout::Document` [2018]: `new`, `.open(path)`, `#save(path)`, `#pages`,
  `#layers`, `#add_entity(entity, layer, page)`, `#remove_entity`,
  `#page_info` (tamanho do papel, margens), `#units=`, `#auto_text_definitions`;
  `#export(file_path, options)` [2020.1] (PDF/imagens; `:page_range` depois);
  `#render_mode_override=` [2023.1].
- `Layout::SketchUpModel` [2018] (viewport): `new(path, bounds)`, `#scenes`,
  `#current_scene=`, `#view=`, `#perspective=`, `#scale=`, `#render_mode=`,
  `#render`, `#model_to_paper_point`; `#reset_camera/#reset_style/#reset_layers` [2020.1];
  `#output_entities` [2023.1].
- Anotação: `LinearDimension`, `AngularDimension`, `Label`, `FormattedText`,
  `Table`/`TableCell`/`TableRow`/`TableColumn`, `Rectangle`, `Ellipse`, `Path`,
  `Image`, `Group`, `AutoTextDefinition` (carimbo: nº de página, data, campos).
- Estrutura: `Pages`/`Page`, `Layers`/`Layer`/`LayerInstance`, `Grid`, `Style`.
- **Atributos** (`set_attribute`/`get_attribute` em `Document`, `Page` e
  `Entity`) só a partir de **LayOut 2026.0**. Com `TargetSketchUpVersion: 2024`,
  use atrás de `respond_to?` ou exija 2026 no produto que depender disso.

## Limitações conhecidas (fórum 236504 e issue tracker)

- `Layout::SketchUpModel` não tem `#path` nem `#path=`: ao abrir um `.layout`
  existente não dá para saber/trocar o `.skp` de uma viewport.
- Sem `#bounds=` (issue #325); mover/redimensionar via `Entity#transform!`.
- Sem "Update Model Reference" pela API: se o `.skp` mudou, é mais confiável
  **recriar** as viewports (ou o documento) do que atualizar um template.
- Remover e recriar `SketchUpModel` num documento já relatou comportamento
  indefinido/crash (várias correções nas release notes).
- Antes do 2026.0 não havia como "marcar" entidades (sem atributos): a
  estratégia era regenerar o documento inteiro por código.

## Demanda observada

- "Popular o template do LayOut com todas as cenas do modelo" (236504,
  1.350 visualizações): uma página por cena, viewport na escala, carimbo.
- Cutlists/pranchas de marcenaria geradas do modelo (job board).
- Liga com o V-Ray: prancha de apresentação com renders + vistas técnicas.

## Próximas verificações ao vivo

- [x] `Layout::Document.new` + `FormattedText` + `Rectangle` → `save` (.layout
      4,9 KB) e `export` (PDF 12 KB) em `Sketchup.temp_dir`: 0,16 s, papel padrão
      11×8,5", 1 página, 1 camada, atributos 2026 presentes **[SU 26.1, 2026-09-24]**.
- [x] Viewport `SketchUpModel` de um `.skp` copiado para `temp_dir`: `#render`
      0,6 s (modelo quase vazio), `export` PDF 0,3 s; `.layout` de 2 páginas
      (índice + viewport + carimbo) gravado em 0,5 s **[SU 26.1, 2026-09-25]**.
- [ ] Abrir um template `.layout` e listar páginas/camadas/auto-text.
- [ ] Medir tempo de `SketchUpModel#render` com modelo médio (bloqueia a UI?).

## Fatos verificados ao vivo (SU 26.1, 2026-09-25)

- `SketchUpModel#scenes` começa por `"Last saved SketchUp View"`: a cena N do
  modelo é o índice N+1. Mapeie por **nome** (`scenes.index(nome)`), não por posição.
  Só aparecem cenas do arquivo **salvo**; cena criada depois do último save não existe ali.
- Viewport em perspectiva: `#view` = `CUSTOM_VIEW` (-1), `#scale` = 0.0 (escala só
  vale para vista ortogonal). Constantes: `TOP_VIEW`=0, `FRONT_VIEW`=4, `ISO_VIEW`=8;
  `RASTER_RENDER`=0, `HYBRID_RENDER`=1, `VECTOR_RENDER`=2.
- `Layout::Document.new` usa o **template padrão do LayOut do usuário**: papel
  11×8,5", margens 0,5", 1 página vazia, 1 camada (nome localizado, ex.:
  "Predeterminado"; não compartilhada, não travada) e as definições de auto-texto
  do template (inclusive campos personalizados e nomes localizados). Não
  dependa de nomes de camada nem de auto-texto.
- Espaço do papel: origem no canto **superior esquerdo**, y cresce para baixo
  (retângulo em (1,1) com altura 0,5 tem `lower_right` = (3, 1,5)).
- `Layout::Rectangle` novo vem com preenchimento branco (`solid_filled` = true):
  desligue para moldura que não cobre nada. Texto novo: Arial 10 pt.
- `FormattedText` resolve auto-texto de página: `"<PageNumber> / <PageCount>"` → `"1 / 1"`.
- `Document#save` sobre um `.layout` existente deixa um `Backup of <nome>.layout`
  ao lado. Nunca salve por cima do arquivo do usuário.
- `Document#export("…/page.png", dpi: 40)` gera `page_<n>_<nome da página>.png`.
