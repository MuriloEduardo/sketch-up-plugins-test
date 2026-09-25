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

### 2026-09-24 — Plataforma modular: pilares + módulos + produtos por manifesto
Proposta em `docs/platform.md`. Produto = manifesto que escolhe módulos; o
empacotador copia o core para dentro do namespace de cada produto. Motivo:
começar pequeno em vários produtos sem retrabalho; o EW recomenda duplicar
lógica compartilhada em vez de extensão-biblioteca (versões diferentes do
mesmo core colidiriam). Consequência: um pacote grátis "ME Toolkit" (beta)
com todos os módulos; produtos pagos depois são novos manifestos. Atualização
de clientes pelo Extension Warehouse; nada de baixar código em runtime.

### 2026-09-24 — API V-Ray: documentada vs interna
Doc oficial do 7.20 cobre 19 classes (sem `Command`, `BatchExporter`,
`refresh_ui`). Tudo que é interno só entra atrás do `VRayBridge`, com
`respond_to?`/`defined?` e teste TestUp, marcado **[interno]** em
`vray-ruby-api.md`. Motivo: interno muda sem aviso entre versões.

### 2026-09-24 — `src/me_vray_toolkit/` é o produto completo; derivados por manifesto
Substitui a estrutura "platform/ neutra → src/ gerado" da proposta. O
`rubocop-sketchup` exige `src/` com registro + pasta e a Dev Bridge sincroniza
`src/`; manter o produto completo ali não muda o fluxo de desenvolvimento.
Produtos menores: `products/<id>.json` → `tools/build/product_builder.rb`
copia pilares + features escolhidas trocando id/namespace. Isolamento entre
features verificado no build e em teste.

### 2026-09-24 — Autostart da Dev Bridge ligado no desktop da Lilian
Pedido do usuário. Continua só em 127.0.0.1 + token + túnel SSH; muda apenas
a janela de tempo (a ponte fica ativa sempre que o SketchUp está aberto).
Controle do dono: item de menu *Start Automatically* (0.1.2) com marcação.
Padrão do `config.json` continua `false` para qualquer instalação nova.

### 2026-09-24 — Direção LLM/MCP: desktop profissional, ações de alto nível
Pedido do usuário: profissionais criarem tudo por LLM. A Trimble lançou (abr/2026)
um MCP oficial que modela do zero numa sessão na nuvem. Decisão: não competir
em "gerar geometria por prompt"; expor as **nossas features** como ações
tipadas (pilar P8) num servidor MCP local que age no modelo aberto com V-Ray e
LayOut. Segurança: só loopback, token e lista fechada de ações; a Dev Bridge
(que executa código arbitrário) nunca é reaproveitada no produto.
Consequência: toda feature nova separa a lógica (entrada explícita, sem UI)
do comando de menu. Evidências em `docs/research/forum-demand-2026-09.md`.

