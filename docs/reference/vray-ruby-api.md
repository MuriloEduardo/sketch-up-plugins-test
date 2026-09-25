# V-Ray for SketchUp — API Ruby ("Script Access")

Base de conhecimento consolidada de todas as fontes públicas disponíveis em
2026-09. **A documentação oficial completa da API só vem com a instalação do
V-Ray** (`Extensions > V-Ray > Help > API Documentation`, arquivo
`...\V-Ray for SketchUp\extension\documentation\_index.html`). Cópia local:
`make vray-docs-import` → `docs/reference/_cache/vray-ruby-api-installed.txt`
(busca em texto) e `_cache/vray-ruby-api-installed/` (HTML YARD).

**Confrontado em 2026-09-24 com V-Ray 7.20.00 (core 7.20.05, `VRay::API_VERSION`
"5.04.02") no SketchUp 26.1.** Ver seção 0.

Legenda de confiabilidade:
- **[doc]** página oficial da Chaos.
- **[chaos-dev]** resposta de desenvolvedor/suporte da Chaos no fórum (noel.warren = líder do time V-Ray for SketchUp; konstantin_chaos, Peter.Chaushev, iva_mancheva, natalia.gruzdova = suporte).
- **[comunidade]** código de usuários que relataram funcionar.
- **[a verificar]** inferência; confirmar com `make su-eval` antes de depender.
- **[7.20]** verificado ao vivo no V-Ray 7.20 (introspecção ou execução pela Dev Bridge).
- **[interno]** existe no V-Ray, mas **fora da doc oficial**: pode mudar sem aviso;
  só use atrás do `VRayBridge`, com checagem `respond_to?`/`defined?`.

---

## 0. O que a documentação oficial cobre (V-Ray 7.20)

Classes documentadas (19): `AColor`, `Color`, `Matrix`, `Vector`, `Transform`,
`ModelExporter`, `Proxy`, `Scene`, `Scene::ChangeSet`, `Scene::Plugin`,
`ScenePreview`, `UVTextureSampler`, `VRayImage`, `VRayInit`, `VRayRenderer`,
`VRayRenderer::Plugin`, `GeomUtils::*PreviewData`. `VRay::Context` só aparece
no guia "Getting started" (`active`, `model`, `scene`, `renderer`, `subscribe`),
sem página própria.

Existem ao vivo mas **não estão na doc** **[interno][7.20]**:
- `VRay::Command` — `render_production`, `render_interactive`, `render_batch`,
  `export_vrscene`, `stop_current_render`, `create_*_light`, `create_mesh_proxy`,
  `create_scatter`, `create_decal`, `convert_material_to_vray/_host`…
- `VRay::BatchExporter` — `export`, `export_vrscene`, `animation_pages_pages`.
- `VRay::Context` (métodos): `active`, `fetch`, `instances`, `subscribe`;
  instância: `activate`, `deactivate`, `delete`, `model`, `scene`, `renderer`,
  `session`, `start_session`, `end_session`, `overlays`.
- Singletons de `VRay`: `pump_message`, `start_render`, `import_material`,
  `get_installation_info`, `get_texture_dimensions`, `get_compute_devices`…
- **`VRay.refresh_ui` NÃO existe no 7.20** (era citado pela comunidade). O
  `VRayBridge.refresh_ui` vira no-op. Mesmo assim, o teste
  `test_quality_preset_round_trip` (escrita em `/SettingsOptions`) passou.

Versão via API **[7.20]**: `VRay::VERSION` → `72000`, `VRay::API_VERSION` →
`"5.04.02"`, `VRay::CORE_VERSION` → `"7.20.05"`, `VRay::PRODUCT_NAME`.

Comportamentos verificados ao vivo **[7.20]** (2026-09-24, auditoria de cena):
- `Plugin#category` devolve símbolos: `:settings`, `:file_type`, `:material`,
  `:BRDF` (maiúsculo), `:texture`, `:light`, `:volumetric`, `:render_channel`,
  `:image_filter`.
- Material nativo do SketchUp aparece na cena como `"/<nome>"` do tipo
  **`:_HostMaterial`**; a textura fica embutida no `.skp` e **não** gera
  parâmetro de arquivo. Arquivos externos só vêm de assets V-Ray (bitmaps de
  VRayMtl, proxies, IES, HDRI).
- **Só a camada user data persiste**: um `TexBitmap` ligado pelo parâmetro do
  core `BRDFVRayMtl[:diffuse]` sumiu ao desativar/reativar o contexto; ligado
  por `[:diffuse_tex]` (+ `[:diffuse_tex_on] = true`) persistiu. Parâmetros
  user data do difuso: `diffuse_tex`, `diffuse_tex_on`, `diffuse_color`,
  `diffuse_tex_mult`, `diffuse_res_mult`.
- `Plugin#each_child` **não aceita argumentos** no 7.20 (a doc diz `(options)`;
  com `{}` dá "wrong number of arguments").
- Um VRayMtl criado por script (`MtlSingleBRDF` + `BRDFVRayMtl` filho) é
  sincronizado para um material do SketchUp com o mesmo nome.

Render por script, verificado ao vivo **[7.20, 2026-09-25]**:
- `VRay::VRayRenderer.new` + `VRay::ModelExporter.new(model:, scene:, renderer:).export_model(view:)`
  + `renderer.start` renderiza **sem** mexer no frame buffer da interface nem nas
  configurações salvas; 90 plugins exportados no modelo de teste.
- Ajustes só deste render, no renderer (core): `renderer.grep(:SettingsOutput).first[:img_width]`,
  `[:img_height]`; `grep(:SettingsImageSampler).first[:progressive_maxTime]` (minutos).
- `renderer.subscribe(obj)` entrega `on_state_changed` (`:idleInitialized` →
  `:preparing` → `:rendering` → `:idleDone`) e `on_progress(renderer, msg, n, total, instant)`
  no thread principal. O progresso é **por etapa** ("Compiling adaptive
  lights…"), não do render inteiro.
- Imagem: `renderer.image(do_color_correct: true, strip_alpha: true).save(path, format: :png)`.
  800×450 com limite de 0,3 min: 44 s no desktop de teste.
- **Configurações vão para o .skp ao salvar o modelo.** Mudanças na cena
  (`scene.change`), inclusive `/SettingsOutput.img_width/img_height` e
  `/SettingsOptions.progressive_noise_limit`, somem se o contexto for
  desativado (`Context#delete`) antes de `model.save`; depois de salvar,
  sobrevivem. Envolver em `start_operation` não muda isso. Consequência:
  nunca `VRayBridge.deactivate` depois de alterar a cena sem salvar.
  (O flag `user_data` de `Plugin#each` não marca `img_width`, mas ele
  persiste mesmo assim.)

Luzes por script, verificado ao vivo **[7.20, 2026-09-25]**:
- `VRay::Command.create_rectangle_light(context:, width:, height:)`, `create_sphere_light(context:, radius:)`,
  `create_spot_light(context:, cone:, penumbra:)`, `create_omni_light(context:)`,
  `create_ies_light(context:, path:)`, `create_dome_light(context:, path:)` **[interno]**:
  criam o plugin (`/Rectangle Light`, depois `/Rectangle Light#1`…) e uma
  **definição de componente** de mesmo nome **sem instância**; não abrem
  ferramenta. A luz só vale no render depois de `entities.add_instance`
  (inclusive o domo, que vai na origem).
- Emissão no **−Z local** da instância (sem rotação, aponta para baixo).
- Parâmetros do core `LightRectangle`: `intensity` (30 padrão), `color`
  (`VRay::AColor`, `to_a` = rgba 0–1), `u_size`/`v_size` = **meia** largura/altura
  em **polegadas** (os `width:`/`height:` do comando não chegaram a eles),
  `invisible`, `enabled`, `doubleSided`. Sol: `/SunLight` com `enabled`,
  `intensity_multiplier`, `size_multiplier`, `turbidity`, `ozone`.
- HDRI de teste no próprio V-Ray: `extension/ruby/resources/Default Dome Light Texture.exr`.

Materiais por script, verificado ao vivo **[7.20, 2026-09-25]**:
- Criar VRayMtl: `MtlSingleBRDF "/Nome"` + `BRDFVRayMtl "/Nome/VRay Mtl"` em
  `mtl[:brdf]`; o material do SketchUp de mesmo nome aparece **na hora**.
- Parâmetros user data do BRDF: `diffuse_color`, `reflect_color`,
  `reflect_glossiness_float`, `metalness_float`, `roughness_float`,
  `refract_color`, `refract_ior_float`, `refract_glossiness_float`,
  `opacity_float`, `coat_amount_float`, `self_illumination_color`,
  `fresnel_ior_float`, `bump_amount_float` (+ `*_tex`/`*_tex_on` de texturas).
- `VRay::Command.convert_material_to_vray(name: "/Nome", context:)` **[interno]**
  exige o nome **com barra** (sem ela não faz nada) e cria o filho
  `/Nome/BRDFVRayMtl` (outro nome!): ache o BRDF por `material[:brdf]`, não
  pelo nome.

Estados do renderer (doc): `:idleInitialized`, `:idleStopped`, `:idleError`,
`:idleFrameDone`, `:idleDone`, `:preparing`, `:rendering`, `:renderingPaused`,
`:renderingAwaitingChanges`.
---

## 1. Duas camadas de parâmetros (o conceito mais importante)

O V-Ray for SketchUp mantém uma **cena V-Ray** (plugins do core, os mesmos do
V-Ray Standalone/AppSDK) mais uma camada de **user data** usada pela UI do
SketchUp (Asset Editor). **[doc]**

- Parâmetros *user data* são a ponte UI ↔ V-Ray for SketchUp; os parâmetros
  reais do core são derivados deles **no momento do render**.
- Para uma mudança via script aparecer na UI, altere o parâmetro *user data*
  correspondente. Se alterar só o do core, a mudança afeta apenas a cena V-Ray
  e pode ser sobrescrita. **[doc]**
- Como descobrir os nomes *user data*: exporte um `.vropt` (settings) ou um
  `.vrmat` (asset) e procure `isUserData="1"`. **[doc]**
- Alternativa prática: ajuste o valor na UI e rode `plugin.dump` para ver o que
  mudou. **[chaos-dev]**
- Evidência: `quality_preset` é escrito em `/SettingsOptions`, mas **não existe**
  no plugin `SettingsOptions` do core (índice AppSDK) → é *user data*.
- Evidência: em material, `opacity_tex` não tinha efeito; o correto era o
  *user data* `opacity_tex_float`. **[chaos-dev]** Padrão observado nos nomes
  *user data*: sufixos `_float`, `_tex_on`, `_tex` (ex.: `reflect_glossiness_float`,
  `opacity_tex_tex_on`). **[comunidade]**

Referência dos parâmetros do **core**: `docs/reference/_cache/vray-plugins.md`
(535 plugins, 9.714 parâmetros, gerado por `make refdocs`). Útil para
entender tipos/semântica, mas lembre da camada *user data*.

## 2. Modelo de objetos

| Objeto | Como obter | Notas |
|---|---|---|
| `VRay::Context` | `VRay::Context.active` | Contexto ligado ao modelo ativo. `context.scene`, `context.renderer`, `context.model`. **[doc][chaos-dev]** |
| `VRay::Scene` | `VRay::Context.active.scene` | Coleção de plugins. `scene["/Nome"]` → plugin. **[doc]** |
| `VRay::Scene::Plugin` | `scene["/SettingsOptions"]` | `plugin[:param]` lê, `plugin[:param] = v` escreve (dentro de `scene.change`). **[doc]** |
| `VRay::VRayRenderer` | `context.renderer` ou `VRay::VRayRenderer.new` | Renderer; eventos via `subscribe`. **[chaos-dev]** |
| `VRay::BatchExporter` | `VRay::BatchExporter.new(context: ctx)` | Exporta cenas (páginas) para `.vrscene`. **[chaos-dev][interno]** |
| `VRay::Command` | `VRay::Command.render_production(context: ctx)` | Dispara render de produção. **[chaos-dev][interno]** |
| `VRay::ModelExporter` | `VRay::ModelExporter.new(model:, scene:, renderer:)` | Exporta modelo/grupo/componente para um renderer (`export_model`, `export_group`…). **[doc]** |
| `VRay::Color` | `VRay::Color.new(r, g, b)` | Floats 0..1. **[doc]** |
| `VRay::Transform` | `VRay::Transform.new(matrix, vector)` ou 12 floats | Operadores `*`, `+`, `-`; `matrix`, `offset`. **[doc]** |

**Legado (não usar):** `VRay::LiveScene` foi **removido no V-Ray 6** e a
funcionalidade migrou para `VRay::Context` **[doc: release notes V-Ray 6]**.
`VRay.get_render_param`, `LiveScene#get_plugin_json`, `VRayForSketchUp.*`
(V3/V4) nunca foram API oficial **[chaos-dev]**. A API atual foi redesenhada no
V-Ray 5 "para suporte de longo prazo" **[doc: release notes]**.

## 3. Transações: `scene.change`

Toda escrita em plugins deve acontecer dentro de `scene.change { ... }`.
**[doc][chaos-dev]**

```ruby
scene = VRay::Context.active.scene
scene.change do
  scene["/SettingsOptions"][:quality_preset] = 4   # 0 Low … 5 High+, 6 Custom
end
```

Operações estruturais também: `scene.change { scene.import(path) }`,
`scene.change { plugin.duplicate(...) }`, `scene.change { scene.relink_files(depth: 9) }`.

Após mudanças feitas por script que precisam aparecer na UI:
`VRay.refresh_ui` (ou `VRay::refresh_ui`). **[chaos-dev]**

No projeto: use `VRayBridge.change { |scene| ... }` e `VRayBridge.refresh_ui`
(`src/me_vray_toolkit/vray/bridge.rb`). Assinaturas oficiais: `change { }` ou
`change(token) { }`; `create(type)`/`create(type, name) { |plugin| }`;
`import(container, options)`; `grep(filter) { |plugin| }`;
`delete(name, options)`; `rename_plugin(old, new, options)`; `unique_name(name)`. **[doc]**

## 4. Nomes de plugins (hierarquia)

- Nomes são caminhos absolutos: `/SettingsOptions`, `/SettingsCamera`,
  `/SettingsOutput`, `/RenderView`, `/<nome do material>`. **[doc][chaos-dev]**
- O material V-Ray de um material SketchUp chamado `blue wood` é `/blue wood`
  (o `/` é obrigatório). **[comunidade]**
- **Filhos devem ficar sob o pai**: `/Material/VRay Mtl`,
  `/Material/VRay Mtl/Bitmap/Bitmap`. Criar `scene.create(:BRDFVRayMtl, '/vray')`
  fora do namespace gera um material "quebrado" no Asset Editor; o certo é
  `'/MyMaterialPlugin/vray'`. **[chaos-dev]**
- Helper puro e testado: `VRayBridge::PluginPath` (`join`, `child`, `parent`, `for_material`).

## 5. Receitas comprovadas

### Configurações
```ruby
s = VRay::Context.active.scene
s["/SettingsOptions"][:mtl_override_color]            # ler parâmetro [chaos-dev]
s.change { s["/SettingsOptions"][:quality_preset] = 4 } # [doc]

# Tipos de câmera fora da UI (esférica, cilíndrica, fisheye…) [chaos-dev]
cam = s["/SettingsCamera"]
s.change { cam[:type] = 3; cam[:fov] = 360.degrees; cam[:height] = 180 }
VRay.refresh_ui

# Clipping de câmera (distâncias em POLEGADAS) [chaos-dev; sintaxe LiveScene antiga → usar scene]
s.change do
  s["/RenderView"][:clipping] = true
  s["/RenderView"][:clipping_near] = 1.m.to_f
  s["/RenderView"][:clipping_far]  = 5.m.to_f
end
VRay.refresh_ui

# Restaurar opções de "binding" de materiais [chaos-dev]
s.change { s["/SettingsOptions"][:binding_support] = %w[bind_all_on bind_color_on bind_texture_on bind_texture_mode bind_opacity_on] }
```

### Iterar plugins e parâmetros
```ruby
scene.each { |plugin| puts "#{plugin.name} #{plugin.category}" }          # [comunidade]
scene.grep(:MtlWrapper)                                                     # por tipo [chaos-dev, via renderer.grep]
plugin.each { |name, value, user_data, file_path, default| ... }           # 5 valores [doc 7.20]
puts plugin.dump                                                            # depuração [doc]

# Todos os caminhos de arquivo usados pela cena. A receita antiga
# `select { |*, file| file }` pegava o ÚLTIMO valor (default) no 7.20. [doc]
paths = scene.each.map { |p| p.each.select { |_n, _v, _ud, file, _d| file }.map { |_, v, *| v } }
             .flatten.uniq.reject(&:empty?)
```

### Materiais
```ruby
# Criar material (note o filho sob o pai) [chaos-dev]
scene.change do
  mtl = scene.create(:MtlSingleBRDF, '/MyMaterial')
  mtl[:brdf] = scene.create(:BRDFVRayMtl, '/MyMaterial/VRay Mtl')
end

# Duplicar [chaos-dev — o exemplo da doc oficial estava errado]
scene.change { scene["/Heather_Band"].duplicate(name: '/Foo', include_refs: true, family_only: true) }

# Importar .vrmat (forma recomendada) [chaos-dev]
scene.change { scene.import('C:/libs/brick.vrmat') }

# Alterar em lote materiais com uma Tag do Asset Editor (V-Ray 6+) [chaos-dev]
tagged = scene.each.select { |p| p[:ui_tags].include?('Tag1') }
scene.change do
  tagged.each do |t|
    brdf = scene["#{t.name}/VRay Mtl"]
    brdf[:reflect_glossiness_float] = 0.85
    brdf[:reflect_color] = VRay::Color.new(0.95, 0.95, 0.95)
  end
end
```
Armadilha: após `duplicate`, o novo material **não aparece imediatamente** em
`Sketchup.active_model.materials` (só "na segunda execução" no console). A
sincronização V-Ray → SketchUp é assíncrona; devolva o controle ao loop do
SketchUp (ex.: `UI.start_timer(0) { ... }`) antes de procurar o material.
**[comunidade; a verificar]**

UVW: `mtl[:brdf][:diffuse_tex][:uvwgen][:uvw_transform]` é leitura; mudar
`Repeat U/V`/rotação por script não teve efeito relatado. Tamanho de textura
é melhor controlado pelo tamanho do material SketchUp (V-Ray aplica por cima).
**[chaos-dev; a verificar]**

### Arquivos / caminhos
```ruby
s = VRay::Context.active.scene
s.add_search_path('D:/Projetos/Biblioteca')   # só na sessão atual [chaos-dev]
s.change { s.relink_files(depth: 9) }          # resolve texturas faltando
```
V-Ray guarda caminhos absolutos; se inválidos, tenta relativo ao `.skp` com
busca em profundidade a partir da pasta do modelo. **[chaos-dev]**

### Render e automação (batch)
Não use `sleep`/loop ocupado esperando o render: o Ruby embarcado bloqueia o
SketchUp inteiro, e o estado nunca muda enquanto seu código segura o thread
principal. **[comunidade: DanRathbun, slbaumgartner]** Use eventos:

```ruby
# Assinante de eventos do contexto e do renderer [chaos-dev]
class RenderListener
  def on_model_exporter_created(exporter) = exporter.subscribe(self)
  def on_model_exported(exporter)
    renderer = exporter.renderer
    # ajustar a cena exportada antes do render, ex.: trocar material do MtlWrapper,
    # renderer.grep(:SettingsOutput).first[:img_file] = "C:/out/x.png"
  end
  def on_state_changed(renderer, old_state, new_state, instant)
    # estados vistos: :idleStopped, :idleError, :idleFrameDone, :idleDone
  end
end
ctx = VRay::Context.active
listener = RenderListener.new
ctx.subscribe(listener)
ctx.renderer.subscribe(listener)
VRay::Command.render_production(context: ctx)
# ao final: ctx.unsubscribe(listener); ctx.renderer.unsubscribe(listener)
```

Renderizar vários `.skp` [chaos-dev, "usa classes internas"]:
`VRay::BatchExporter.new(context:).export(dir)` → lista de `.vrscene`;
depois `renderer = VRay::VRayRenderer.new; renderer.subscribe(self);
renderer.clear!; renderer.load(vrscene); renderer.start` e, no estado final,
`renderer.save_vfb_image(path, apply_color_corrections: true, single_channel: true)`.
Entre modelos: `Sketchup.active_model&.close(true); VRay.pump_message;
Sketchup.open_file(path, with_status: true)`.

Exportar `.vrscene` do modelo atual: `VRayRenderer#export(path, options)`
(`compressed:`, `hex_arrays:`, `hex_transforms:`, `strip_paths:`) **[doc]**
grava o que já está *dentro do renderer*. O resultado de 11 KB relatado pela
comunidade é coerente com um renderer vazio. Caminho documentado: preencher um
renderer com `VRay::ModelExporter.new(model:, scene:, renderer:).export_model(...)`
e então `renderer.export(path)` **[doc; a verificar ao vivo]**. Atalho interno:
`VRay::Command.export_vrscene` **[interno]**.

Batch Render nativo: renderiza cada Página (Scene) do SketchUp; páginas com
"Include in animation" desmarcado são puladas; saída em
Asset Editor > Settings > Render Output > File Path. Só parâmetros de câmera
variam por página. **[doc]**

### Contexto e desempenho
- Ativar o contexto (qualquer interação com V-Ray, inclusive renderizar)
  instala *observers* do V-Ray no SketchUp; operações pesadas de modelagem
  podem ficar ~5× mais lentas. Desative com
  `VRay::Context.active(false)&.delete` antes de processamento pesado.
  **[chaos-dev]** (`VRayBridge.deactivate`)
- Não faça isso com o Asset Editor aberto (pode deixá-lo inconsistente). **[chaos-dev]**
- Pilha de undo: o V-Ray serializa assets no modelo a cada mudança, gerando
  entradas extras ("Undo V-Ray properties") e quebrando *redo*. Melhorou no
  V-Ray Next update 2, mas não é perfeito. Envolva mudanças disparadas pelo
  usuário em `model.start_operation`/`commit_operation`. **[chaos-dev]**
- Erros Ruby do SketchUp aparecem também no V-Ray Log Window (V-Ray 5+). **[doc]**

## 6. Versões e compatibilidade **[doc]**

| SketchUp | V-Ray suportado |
|---|---|
| 2026 | V-Ray 7 update 2+ |
| 2025 | V-Ray 7, 7.1, 7.2 |
| 2024 | V-Ray 6.2.3, 7.x |
| 2021–2023 | V-Ray 6.x, 7.x |

- V-Ray 7: aba GPU única (CUDA/RTX), portal light legado, materiais PBR viram
  VRayMtl, bump e coat embutidos no VRayMtl, "Binding" renomeado "Viewport
  Display", modificador de Displacement por objeto.
- V-Ray **não é forward-compatible**: abrir projeto em versão mais antiga oferece apagar os dados V-Ray.
- Instalação V-Ray 7: `C:\Program Files\Chaos\V-Ray\V-Ray for SketchUp`
  (antes do 7: `C:\Program Files\Chaos Group\...`); `.rb` do V-Ray são
  criptografados (`require_crypt`); loader em `%ProgramData%\SketchUp\SketchUp <ano>\SketchUp\Plugins\vfs.rb`.

## 7. Formatos de arquivo

| Extensão | O que é |
|---|---|
| `.vrscene` | Cena V-Ray em texto (similar a JSON, `#include`, referências `nome::saida`). Formato do core. |
| `.vropt` | Preset de settings (contém *user data*). Só settings desde V-Ray 5. |
| `.vrmat` | Asset (material/proxy etc.) com arquivos referenciados; XML. |
| `.vrmesh` | Proxy de geometria (carregado sob demanda). |
| `.vrimg` | Saída do VFB com todos os render elements em float. |

## 8. Conceitos do core úteis (AppSDK "Working with V-Ray Scenes")

- Plugins top-level (luzes, `Node`), plugins de entrada (texturas, BRDFs,
  UVWGens) e singletons de settings (`Settings*`, `RenderView`).
- Material final sempre `MtlSingleBRDF` → `Node::material`; `BRDFVRayMtl` é o
  BRDF principal (camadas reflexão → refração → difuso, energia conservada;
  Fresnel desligado por padrão no core).
- Texturas aceitam valor simples (polimorfismo); saídas alternativas via
  `nome::saida` (ex.: `TexBitmap::out_alpha` → `opacity`).
- `subdivs`: raios ∝ quadrado; recomenda-se deixar padrão.
- Câmera padrão do core: +Y para cima, −Z direção de visão (SketchUp é Z-up; o
  V-Ray for SketchUp converte).
- Categorias de plugin: Bitmap, BSDF, GeometricObject, GeometrySource, Light,
  Material, RenderChannel, RenderView, Settings, Texture*, UVWGen, Volumetric.

## 9. Pendências para confirmar com o V-Ray instalado

- [x] Rodar `make vray-docs-import` (2026-09-24, V-Ray 7.20; seção 0).
- [x] Assinaturas: `Scene#create/#import/#each/#grep`, `Plugin#duplicate/#dump/#each`,
      estados do `VRayRenderer` (seções 0, 3 e 5). `BatchExporter` é interno.
- [x] Versão via API: `VRay::VERSION`, `VRay::API_VERSION` (seção 0).
- [ ] Substituto de `VRay.refresh_ui` (inexistente no 7.20) para a UI refletir mudanças.
- [ ] Exportar `.vrscene` via `ModelExporter#export_model` + `VRayRenderer#export` ao vivo.
- [ ] Como aplicar um material V-Ray recém-criado a entidades SketchUp.
- [ ] Mapa completo *user data* ↔ core para settings e VRayMtl (exportar `.vropt` / `.vrmat`).
- [ ] Exportação `.vrscene` do modelo ativo sem BatchExporter.
