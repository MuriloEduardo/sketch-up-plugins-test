# Progresso

Diário curto de estado. Mais recente no topo. Atualize ao fim de cada sessão.

## 2026-09-24 — Bootstrap do harness

Feito:
- Leitura integral das fontes (API Ruby SketchUp via stubs 0.7.11 / SU 2026.1,
  guias, release notes, Developer Center, C API, template oficial VSCode,
  TestUp, RuboCop-SketchUp; V-Ray Script Access, 294 páginas V-Ray for
  SketchUp, 111 páginas AppSDK, referência de 535 plugins do core; 24 tópicos
  Ruby do fórum Chaos; tópicos Developers e todo o Job Board do fórum SketchUp).
- Toolchain Docker/Compose + Makefile; `make check` verde (lint sem ofensas,
  14 testes); `make package` gera `dist/me_vray_toolkit-0.1.0.rbz`.
- Extensão mínima `V-Ray Toolkit` (Status, Render Quality) + `VRayBridge`.
- Ponte de desenvolvimento por spool de arquivos, validada com SketchUp
  simulado (resultado, stdout, exceções, bindings isolados).
- Base de referência (`docs/reference/`) e roadmap comercial.

NÃO verificado (máquina sem SketchUp/V-Ray instalados):
- Loader de dev, launcher, TestUp CI e debugger contra um SketchUp real.
- Comandos da extensão e `VRayBridge` contra V-Ray real.
- Acesso do Ruby do Windows ao repositório via `\\wsl.localhost\...`.

Próximos passos (roadmap Fase 1):
1. Instalar SketchUp 2026 + V-Ray 7 no Windows (usuário).
2. `make su-loader`, `make su-launch`, `make su-ping`.
3. `make vray-docs-import` e revisar `docs/reference/vray-ruby-api.md`.
4. TestUp 2 + `make su-testup`.
5. Escolher o primeiro produto (sugestão: V-Ray Batch Studio, P1.1 variações de material).
