---
name: sketchup-live
description: Run Ruby inside the user's open SketchUp (Windows) from WSL to inspect the model, probe the V-Ray API, reload code or reproduce a bug. Use when you need ground truth from the real SketchUp/V-Ray instead of guessing.
---

# Inspect and drive the live SketchUp

The dev bridge (`tools/sketchup/dev_bridge.rb`, loaded by the dev loader) executes Ruby files
dropped into a spool folder and returns JSON.

## Preconditions

1. `make su-ping` prints the SketchUp version. If it times out (exit 2): SketchUp is closed or
   the loader is not installed → ask the user to run `make su-launch` / `make su-loader`
   (installing the loader writes to their Windows Plugins folder; confirm first).

## Usage

```sh
tools/sketchup/su-eval 'Sketchup.active_model.entities.size'
tools/sketchup/su-eval -f /tmp/probe.rb          # multi-line scripts
make su-eval CODE='MuriloEduardoDev.reload'       # reload src/ after edits
```

Output: `{"ok":true,"result":"<inspect>","stdout":"...","seconds":...}` or
`{"ok":false,"error":"...","message":"...","backtrace":[...]}`. Exit code 1 on exception.

## Rules

- Read-only by default. Anything that modifies the model must be wrapped in
  `model.start_operation(...)`/`commit_operation` and must be something the user asked for.
- Never save, close, purge or open models without explicit user approval.
- Keep scripts short: they run on SketchUp's main thread and freeze the UI while running.
- No `sleep`, no modal dialogs (`UI.messagebox`) — they block the bridge.
- Useful probes:
  - `VRay::Context.active.scene["/SettingsOptions"].dump`
  - `VRay.singleton_methods.sort`, `VRay::Scene.instance_methods(false).sort`
  - `VRay::Context.active.scene.each.map { |p| [p.name, p.category] }.first(50)`
  - `Sketchup.active_model.selection.map { |e| [e.typename, e.persistent_id] }`
- Record anything learned about the V-Ray API in `docs/reference/vray-ruby-api.md`
  (replace "[a verificar]" with the verified behavior and the V-Ray version).
