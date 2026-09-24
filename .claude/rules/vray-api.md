---
paths:
  - "src/**/*.rb"
  - "tests/**/*.rb"
---

# V-Ray for SketchUp Ruby API

Knowledge base: `docs/reference/vray-ruby-api.md` (read it before writing V-Ray code).

- Only `src/*/vray/bridge.rb` (`VRayBridge`) may reference `::VRay`. Other code calls the bridge.
  Inside our namespace, always write `::VRay` (leading `::`) to avoid constant lookup surprises.
- Every write to scene plugins goes inside `scene.change { }` (use `VRayBridge.change`).
  Call `VRayBridge.refresh_ui` afterwards when the Asset Editor must reflect the change.
- Two parameter layers: V-Ray for SketchUp "user data" params (what the UI uses) vs V-Ray core
  params. Changing only the core param may not show in the UI or survive. Confirm the right
  name with `plugin.dump` or an exported `.vropt`/`.vrmat` before relying on it.
- Plugin names are absolute paths; child plugins must be namespaced under their parent
  (`/Material/VRay Mtl`). Use `VRayBridge::PluginPath`.
- `VRay::LiveScene`, `VRay.get_render_param`, `VRayForSketchUp.*` are legacy/removed. Never use them.
- Never wait for renders with `sleep` or busy loops; subscribe to renderer/context events
  (`on_state_changed`, `on_model_exported`) or use `UI.start_timer`.
- Activating the V-Ray context slows heavy model edits (observers). For bulk geometry work,
  consider `VRayBridge.deactivate` first (not while the Asset Editor is open).
- Wrap user-triggered V-Ray changes that also serialize to the model in
  `model.start_operation`/`commit_operation`.
- Anything marked "[a verificar]" in the knowledge base must be verified live
  (`make su-eval`) before shipping. Update the knowledge base with what you learn.
