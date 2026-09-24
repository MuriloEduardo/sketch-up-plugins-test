# Decisões (ADR resumido)

Registre aqui decisões que não são óbvias pelo código. Formato: data, decisão,
motivo, consequência. Não apague; marque como substituída.

### 2026-09-24 — Toolchain inteira em Docker
Ruby 3.2 (mesmo do SketchUp 2024–2026) num contêiner via Compose; `make` como
fachada. Motivo: pedido do usuário; host WSL sem Ruby; reprodutibilidade.
Consequência: SketchUp/V-Ray continuam no Windows; integração via scripts de
interop em `tools/sketchup/`.

### 2026-09-24 — Versão mínima SketchUp 2024
`TargetSketchUpVersion: 2024`. Motivo: Ruby 3.2, `debug` gem embarcado,
V-Ray 7 cobre 2021–2026 mas APIs modernas (EntitiesBuilder, PBR, Environments)
e depuração moderna começam em 2022–2025. Revisitar se um cliente exigir versão antiga.

### 2026-09-24 — Namespace `MuriloEduardo::VRayToolkit`, prefixo `me_`
Nome completo reduz risco de colisão (iniciais são desaconselhadas pela
SketchUp). Trocar de namespace depois exige renomear arquivos e módulos:
fazer só se o usuário pedir (ex.: nome de empresa).

### 2026-09-24 — Todo acesso a `::VRay` passa por `VRayBridge`
A API do V-Ray mudou entre V3→V4→V5 (redesenho) →V6 (remoção do LiveScene).
Centralizar isola mudanças futuras e facilita testes.

### 2026-09-24 — Ponte de desenvolvimento por spool de arquivos (não HTTP)
Motivo: no WSL2 com NAT, `127.0.0.1` do WSL não é o do Windows. Arquivos em
`C:\Users\<u>\.me_devbridge` funcionam em qualquer modo de rede e não abrem
porta. Execução arbitrária de código: apenas via loader de dev, nunca no `.rbz`.

### 2026-09-24 — Docs de terceiros fora do git
Páginas da Chaos, fóruns e artigos ficam em `docs/reference/_cache/`
(ignorado), regeneráveis por `make refdocs`. Versionamos apenas texto próprio
e o índice derivado dos stubs MIT da SketchUp.
