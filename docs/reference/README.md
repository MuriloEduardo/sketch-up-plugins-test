# Base de referência

Como achar a resposta certa, na ordem:

1. **Método/classe do SketchUp** → `sketchup-api-index.md` (2.093 métodos,
   versão mínima de cada um). Doc completa com exemplos:
   `_cache/sketchup-api-stubs/<Classe>.rb` (YARD) ou ruby.sketchup.com.
2. **Boas práticas SketchUp / requisitos do EW** → `sketchup-dev-guide.md`.
3. **API Ruby do V-Ray** → `vray-ruby-api.md` (+ `_cache/vray-ruby-api-installed.txt`
   depois de `make vray-docs-import`).
4. **Parâmetro de plugin do core V-Ray** → `grep -A40 '^## NomeDoPlugin' _cache/vray-plugins.md`.
5. **Funcionalidade/UI do V-Ray for SketchUp** →
   `grep -ril 'termo' _cache/chaos/VSKETCHUP/` (294 páginas da doc oficial).
6. **Conceito do core V-Ray** (cena, materiais, luzes, câmera, GI) →
   `_cache/chaos/APPSDK/` (111 páginas; comece por `132780815.md`
   "Working with V-Ray Scenes").
7. **Casos reais / armadilhas** → `_cache/forums/*.md`.
8. **Ainda não achou** → rode no SketchUp real: `make su-eval CODE='...'`
   (ex.: `VRay::Context.active.scene["/SettingsOptions"].dump`,
   `VRay.methods - Object.methods`, `VRay::Scene.instance_methods(false)`).

`_cache/` não é versionado; recrie com `make refdocs` (rede) e
`make vray-docs-import` (V-Ray instalado).

## Fontes (lidas em 2026-09-24)

| Fonte | Conteúdo | Local |
|---|---|---|
| ruby.sketchup.com (via SketchUp/ruby-api-stubs 0.7.11, MIT) | API Ruby + LayOut completas, guias, release notes até 2026.1 | `sketchup-api-index.md`, `_cache/sketchup-api-stubs/`, `_cache/sketchup-api-guides/` |
| developer.sketchup.com | 21 artigos (unidades, travessia, segurança, eval, rescue, UX, parametric…) | `_cache/devcenter/` |
| extensions.sketchup.com/developers/sketchup_c_api | C API / SDK (visão geral, estruturas) | `_cache/sketchup-c-api/` |
| github.com/SketchUp/sketchup-extension-vscode-project | Template oficial: rules, skills, debug bootstrap | `.claude/rules`, `.claude/skills`, `tools/sketchup/debug/` |
| github.com/SketchUp/testup-2, rubocop-sketchup, sketchup-ruby-api-tutorials | Testes, lint, exemplos | `tools/sketchup/testup-ci.sh`, `.rubocop*` |
| documentation.chaos.com/space/VSKETCHUP | 294 páginas V-Ray for SketchUp (inclui "V-Ray Script Access") | `_cache/chaos/VSKETCHUP/` |
| documentation.chaos.com/space/APPSDK | 111 páginas V-Ray App SDK | `_cache/chaos/APPSDK/` |
| docs.chaos.com/vray_app_sdk/doc/python/plugins.html | Todos os plugins e parâmetros do core | `_cache/vray-plugins.md` |
| forums.chaos.com (24 tópicos Ruby/V-Ray SketchUp) | API real, respostas do time da Chaos | `_cache/forums/chaos-vray-sketchup-ruby-threads.md` |
| forums.sketchup.com (Developers, Ruby API, Job Board) | Armadilhas, arquitetura, demanda de mercado | `_cache/forums/` |
