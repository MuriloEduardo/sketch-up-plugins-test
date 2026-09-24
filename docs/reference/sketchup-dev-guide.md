# SketchUp — guia de engenharia de extensões

Destilado de: ruby.sketchup.com (API + guias + release notes até 2026.1),
developer.sketchup.com (artigos), template oficial VSCode (regras
`.claude/rules`), RuboCop-SketchUp, TestUp, e tópicos do fórum Developers.
Referência de métodos: `docs/reference/sketchup-api-index.md`.

## Plataforma

- SketchUp atual: **2026.1**. Ruby embarcado **3.2.2** desde 2024 (debug gem
  embarcado desde 2024). CEF 128 no `UI::HtmlDialog` (2025).
- Toda chamada de API deve rodar no **thread principal**. Não há threads úteis:
  o SketchUp segura o GVL quando ocioso. Para "esperar" algo, use
  `UI.start_timer`, observers ou callbacks — **nunca `sleep`/loop ocupado**.
- Unidade interna: **polegadas**; ângulos em **radianos**; tolerância 0.001".
  Z para cima, sistema destro.
- Windows: um processo por modelo. macOS: vários modelos por processo.

## Estrutura de extensão (requisitos do Extension Warehouse)

- `.rbz` = zip com exatamente `<nome>.rb` + pasta `<nome>/` (`make package`).
- Arquivo raiz **só registra** (`SketchupExtension` + `Sketchup.register_extension`).
  Pode definir constantes/versão e dar `require 'sketchup'`/`'extensions'`.
- Um único módulo de topo, com nome único (empresa/nome completo; iniciais são desaconselhadas).
- `Sketchup.require('pasta/arquivo')` **sem extensão** (EW criptografa `.rb` → `.rbe`).
  Nada de `require_relative`/`__dir__` para arquivos da extensão.
- Proibido: variáveis globais, monkey-patch da API/Ruby core (use *refinements*),
  alterar `$LOAD_PATH` ou `ENV`, `Gem.install`, `exit`, `eval` de strings
  externas, mecanismo próprio de atualização, `puts` incondicional,
  `WebDialog` (use `HtmlDialog`), salvar modelo ou `purge_unused` sem ação do
  usuário, mudar o modelo sem ação do usuário (ex.: ao abrir/carregar).
- Nome não pode começar com "SketchUp" nem arquivos com `su_`/`sketchup_`.
- Não escreva na pasta da extensão (é apagada no update): use
  `Sketchup.temp_dir`, `ENV['APPDATA']`/`Dir.home`.
- Gems: copie o código para dentro do seu namespace (vendor).
- Licença paga: checagem dentro do método de negócio, ID hardcoded local
  (`Sketchup::Licensing.get_extension_license`).
- Revisão do EW: `make lint` (RuboCop-SketchUp é o mesmo usado pelos revisores)
  + skill `sketchup-review-extension`.

## Undo

- Uma ação do usuário = um passo de undo:
  `model.start_operation('Nome Em Title Case', true)` … `commit_operation`
  (2º arg desliga redraw; 3º é obsoleto; 4º = transparente, para mudanças
  em observers).
- `set_attribute`/`delete_attribute` também precisam de operação.
- Desde 2026.0 mudar Axes/Camera/RenderingOptions/ShadowInfo de uma `Page` é
  undoable → precisa de operação (senão rejeição no EW).
- `abort_operation` em caso de erro que deixe o modelo inconsistente.

## Observers

- Mudanças no modelo dentro de callbacks: operação transparente
  (`start_operation(nome, true, false, true)`).
- Não altere o modelo em callbacks de salvar (`onPreSaveModel` etc.) — risco
  de loops/crash. Colete dados em `onPostSaveModel` e envie assíncrono depois.
- Não dá para impedir que observers de outras extensões disparem com suas
  mudanças; torne operações idempotentes.
- `AppObserver#onQuit` historicamente instável; 2026.1 melhorou.
- Observers custam desempenho (ex.: V-Ray ativo deixa edição ~5× mais lenta).
- Anexe observers por modelo em `onNewModel`/`onOpenModel` (remova antes de
  adicionar para não duplicar).

## Identidade e dados persistentes

- `entityID` **não** persiste entre sessões. Use `persistent_id` (2017+) e
  `Model#find_entity_by_persistent_id`; `InstancePath#persistent_id_path`.
- Booleanas e outras operações destrutivas recriam entidades (novo PID, perdem
  atributos). `ModelObserver#onPidChanged` ajuda a ressincronizar.
- Copiar/colar instância copia os attribute dictionaries da instância;
  `DefinitionObserver#onComponentInstanceAdded` pode ajustar a cópia.
- Grupos compartilham definição ao copiar; a UI torna único ao editar, a API
  **não** — chame `make_unique` antes de editar por código.
- Serialize dados como JSON em atributos (nunca `Marshal`). Comprimentos:
  guarde `Float`, não `Length#to_s`.

## Unidades e entrada do usuário

- Use `Length`: `10.mm`, `2.m`, `"50".to_l` (respeita unidade do modelo e
  separador decimal), `Length#to_s`/`Sketchup.format_length|area|volume|angle`.
- Operações aritméticas devolvem `Float`: reconverta com `.to_l`.
- `String#to_l` levanta `ArgumentError` em entrada inválida → é o caso legítimo
  de `rescue`.
- `~` (til) no inputbox: se o texto voltou com `~` e igual ao default
  formatado, use o default original.
- Defaults redondos por sistema: `metric? ? 50.mm : 2.inch`.

## Geometria

- Poucas entidades: `Entities#add_face` (funde/divide como as ferramentas).
- Em massa: `Entities#build { |builder| ... }` (**EntitiesBuilder**, 2022+);
  `fill_from_mesh` como alternativa (materiais só para a malha inteira).
- Faces em Z=0 nascem viradas para baixo; confira `face.normal` antes de `pushpull`.
- Arestas e faces "grudam": isole em grupos/componentes.
- `entities.to_a.each` ao apagar; melhor `erase_entities(array)`.
- Use `grep(Sketchup::Face)`/`is_a?`, nunca `typename` (lento).
- Métodos C++ da API (`vector_to`, `offset`, `Geom.linear_combination`) são
  mais rápidos que aritmética manual.
- Transformações não inversíveis levantam `ArgumentError` desde 2026.0.

## Travessia do modelo (exportadores, relatórios, renderizadores)

Recursão por `entity.definition.entities` acumulando
`transformation * entity.transformation`; pular ocultos
(`visible?`, `layer.visible?`, pastas de tag via `layer.folder`); herança de
material: `entity.material || material_do_pai`. Para listar componentes como
o painel: pular `definition.group?`, `definition.image?` e `definition.hidden?`.

## UI

- Menu: submenu próprio em Extensions; nada de separadores no menu Extensions;
  todo comando da toolbar também no menu (atalhos só funcionam em menus).
- `UI::Command` compartilhado entre menu e toolbar; ícones vetoriais (SVG
  Windows, PDF macOS; 24/32 px com 4 px de margem).
- Title Case em comandos; frase com ponto no status bar.
- Ferramentas (`Sketchup::Tool`): Esc reseta, continua ativa após concluir,
  VCB, inferência, status bar, `view.invalidate` (não `refresh`),
  `getExtents` ao desenhar, `onCancel(reason)`.
- `HtmlDialog`: passe dados para JS com `to_json` (nunca interpolar strings),
  `textContent` em vez de `innerHTML`, não misture conteúdo local e remoto.
  Considere Trimble Modus para visual nativo. 2026.1: `HtmlDialog#hide`.
- Não mostre erro de licença na inicialização; mantenha menus visíveis.
- Respeite `locked?` e tratamento de unidades.

## Erros (`rescue`)

O SketchUp já captura exceções não tratadas e mostra no Ruby Console. Não
faça `rescue` silencioso nem mensagens enganosas; só resgate falhas esperadas
(I/O, parsing de entrada) e da classe específica.

## Segurança

`to_json` para JS, `CGI.escape_html` para HTML, sem `eval`/`Marshal.load`,
`system("cmd", arg)` em forma de array (ou `Open3`), validar paths
(path traversal) e extensões de arquivos baixados, HTTPS, nunca logar tokens.
Geração por IA: gere geometria/arquivos (ex.: `.skp` via C API, OBJ/STL) e
importe — nunca execute Ruby vindo de servidor.

## Carregamento rápido

`require 'sketchup.rb'` desnecessário em runtime (Tools carrega antes);
prefira carregar arquivos pesados sob demanda (dentro dos comandos).

## Rede

`Sketchup::Http::Request` (assíncrono; guarde referência ao request até o
callback). Bugsplat relatado com mTLS em 2026.

## LayOut API (roda dentro do SketchUp)

Cria/edita `.layout` e exporta PDF. Limitações conhecidas: não há
`SketchUpModel#path=`/`bounds=`, "Update Model Reference" ausente; mais fácil
recriar viewports do que atualizar os de um template. 2026.0 trouxe atributos
em `Layout::Entity/Document/Page`.

## C API / SDK

SDK desktop (acesso sob solicitação em developer.sketchup.com) lê/escreve
`.skp` fora do SketchUp (Windows VS2022 x64; macOS universal) e permite
importadores/exportadores nativos. "Live C API" = leitura do modelo aberto
via extensão Ruby C. Útil para gerar `.skp` em servidor. Resumo em
`docs/reference/_cache/sketchup-c-api/`.

## Ferramentas oficiais

- TestUp 2 (Minitest dentro do SketchUp; modo CI por linha de comando).
- ruby/debug via DAP (SketchUp 2024+), bootstrap do template oficial em
  `tools/sketchup/debug/`.
- sketchup-api-stubs (IntelliSense/Solargraph), RuboCop-SketchUp.
- Issue tracker oficial: github.com/SketchUp/api-issue-tracker.
