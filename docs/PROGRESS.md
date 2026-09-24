# Progresso

Diário curto de estado. Mais recente no topo. Atualize ao fim de cada sessão.

## 2026-09-24 — Desktop é de outra pessoa: chave só-túnel

- O notebook é pessoal do usuário; o desktop com SketchUp/V-Ray é de outra
  pessoa. Chave SSH agora restrita por padrão (só túnel até a ponte), token
  vindo da janela Connection Info, ponte instalada à mão pelo `.rbz`, doc do
  V-Ray baixada pela ponte, `--ssh-port`, confiança no primeiro contato (TOFU).
- Guia reescrito com consentimento, controle pelo dono, cuidado com o
  trabalho dele (su-test troca o modelo), licenças e revogação.
- Validado contra sshd real em container com a mesma linha de
  `authorized_keys`: shell bloqueado, outra porta bloqueada, scp bloqueado,
  ping/eval/sync/test/pull-vray-docs pelo túnel, 401 com token errado.
  Achou e corrigiu: primeira conexão falhava (host key desconhecida).

## 2026-09-24 — SketchUp no desktop da rede + Dev Bridge via SSH

Feito:
- Decisão: SketchUp Pro + V-Ray Pro rodam no desktop Windows 11 da rede local
  (não na máquina de dev; AWS free tier descartado). Ver `docs/decisions.md`.
- Dev Bridge (`tools/devbridge/extension/`): extensão só de dev, HTTP mínimo
  em 127.0.0.1 dentro do SketchUp (timer no thread principal), token, desligada
  por padrão; rotas ping/eval/sync/reload/test. Ponte por arquivos removida.
- Cliente `tools/devbridge/su` (python3 + ssh do WSL): túnel SSH persistente,
  token lido via SSH, sync sem commit, TestUp remoto, install-bridge e
  pull-vray-docs por scp. Alvos `make su-*`.
- `tools/devbridge/windows/setup-openssh.ps1` + guia `docs/remote-desktop-setup.md`.
- 54 testes unitários (inclui servidor com TCP real); cliente validado ponta a
  ponta contra SketchUp simulado em container (ping, eval, sync, reload com
  erro → 500, test com formato real do TestUp, códigos de saída).

NÃO verificado (depende do desktop):
- Script do OpenSSH, túnel, `scp` com espaços no caminho ("SketchUp 2026"),
  comandos `cmd.exe` remotos, Dev Bridge dentro do SketchUp real, TestUp real.

Próximos passos (usuário, no desktop): seguir `docs/remote-desktop-setup.md`
até `make su-ping` responder; depois `make vray-docs-import` e `make su-test`.

## 2026-09-24 — Repositório remoto e CI

- Remoto: git@github.com:MuriloEduardo/sketch-up-plugins-test.git (branch `master`,
  SSH com a chave pessoal `id_ed25519`; a conta do `gh` não tem push).
- GitHub Actions (`.github/workflows/ci.yml`): `make build/lint/test/package` a cada
  push/PR em `master`; `.rbz` fica como artefato por 30 dias.

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
- Ponte de desenvolvimento por spool de arquivos (substituída depois pela Dev Bridge via SSH).
- Base de referência (`docs/reference/`) e roadmap comercial.

NÃO verificado (máquina sem SketchUp/V-Ray instalados):
- Comandos da extensão e `VRayBridge` contra V-Ray real.
