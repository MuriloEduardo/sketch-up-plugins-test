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

### 2026-09-24 — (SUBSTITUÍDA) Ponte de desenvolvimento por spool de arquivos (não HTTP)
Motivo: no WSL2 com NAT, `127.0.0.1` do WSL não é o do Windows. Arquivos em
`C:\Users\<u>\.me_devbridge` funcionam em qualquer modo de rede e não abrem
porta. Execução arbitrária de código: apenas via loader de dev, nunca no `.rbz`.

### 2026-09-24 — SketchUp num desktop separado; Dev Bridge via túnel SSH
Substitui a ponte por spool. O usuário não quer SketchUp/V-Ray na máquina de
desenvolvimento; usa um desktop Windows 11 da rede local. O free tier da AWS
foi descartado (sem GPU, RAM insuficiente). A Dev Bridge (extensão só de
desenvolvimento) é um servidor HTTP mínimo dentro do SketchUp que executa
Ruby: por ser execução remota de código, foi escolhido (pelo usuário, entre
HTTP na LAN com token, túnel SSH e nenhuma execução remota) o modelo:
bind fixo em 127.0.0.1, rejeição de conexões não locais, token de 48 hex,
desligada por padrão, acesso remoto só por OpenSSH com chave (senha
desligada, firewall só em rede Privada). O token é lido pelo cliente via SSH
(quem tem SSH já tem controle da máquina, então a ponte não amplia o risco).
Código vai por `/sync` (sem commit) para `%APPDATA%\MuriloEduardoDev\workspace`.

### 2026-09-24 — Desktop de outra pessoa: chave SSH só-túnel por padrão
O desktop com SketchUp pertence a outra pessoa. Para que o dono controle o
acesso, a chave do notebook é gravada com
`command="echo tunnel-only",restrict,port-forwarding,permitopen="127.0.0.1:7860"`:
sem shell/scp, só túnel até a ponte. Com a ponte desligada, não há acesso
algum. Consequências: token vem da janela Connection Info (não por SSH),
a ponte é instalada à mão pelo `.rbz`, e a doc do V-Ray é baixada pela
própria ponte. Modo completo (`-AllowShell`) só com anuência do dono.
Verificado contra sshd real (OpenSSH Linux) em container; falta confirmar no
Win32-OpenSSH do desktop.

### 2026-09-24 — Docs de terceiros fora do git
Páginas da Chaos, fóruns e artigos ficam em `docs/reference/_cache/`
(ignorado), regeneráveis por `make refdocs`. Versionamos apenas texto próprio
e o índice derivado dos stubs MIT da SketchUp.
