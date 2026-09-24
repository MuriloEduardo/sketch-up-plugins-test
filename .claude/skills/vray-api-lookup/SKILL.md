---
name: vray-api-lookup
description: Find the correct V-Ray for SketchUp Ruby API call, plugin name or parameter (settings, materials, lights, camera, render output) before writing V-Ray code.
---

# V-Ray API lookup

Work through these sources in order and stop when you have a verified answer.

1. `docs/reference/vray-ruby-api.md` — object model, recipes, pitfalls, confidence tags.
2. Official installed API docs (if imported): `grep -n -i '<term>' docs/reference/_cache/vray-ruby-api-installed.txt`.
   If missing and V-Ray is installed, run `make vray-docs-import`.
3. Core plugin parameters: `grep -n -A60 '^## <PluginName>$' docs/reference/_cache/vray-plugins.md`
   (e.g. SettingsOutput, SettingsCamera, RenderView, BRDFVRayMtl, LightRectangle, TexBitmap).
   Remember these are CORE params; the SketchUp UI may use a "user data" param instead.
4. Feature docs: `grep -ril '<term>' docs/reference/_cache/chaos/VSKETCHUP/` then read the page.
5. Real-world usage: `grep -n -i '<term>' docs/reference/_cache/forums/*.md`.
6. Ground truth: use the `sketchup-live` skill (`plugin.dump`, method listings).

Report which source answered the question and its confidence ([doc], [chaos-dev],
[comunidade], verified live). Update the knowledge base if you verified something new.
If `docs/reference/_cache/` is missing, run `make refdocs`.
