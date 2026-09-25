# Produtos derivados

`src/me_vray_toolkit/` é o produto completo (todos os módulos). Cada arquivo
`<id>.json` aqui descreve um produto menor que `make package` monta a partir
dele (`tools/build/product_builder.rb`) e empacota em `dist/<id>-<versão>.rbz`.

```json
{
  "id": "me_scene_audit",
  "namespace": "SceneAudit",
  "name": "Scene Audit",
  "version": "1.0.0",
  "description": "Finds missing files and heavy textures in V-Ray scenes.",
  "features": ["scene_audit"]
}
```

- `id`: nome do arquivo de registro e da pasta (`me_<nome>`).
- `namespace`: vira `MuriloEduardo::<Namespace>`; cada produto carrega sua
  própria cópia dos pilares, sem conflito com os outros.
- `features`: pastas de `src/me_vray_toolkit/features/`. Uma feature nunca
  depende de outra (verificado no build e em `tests/unit/features/isolation_test.rb`).

Arquitetura completa: `docs/platform.md`.
