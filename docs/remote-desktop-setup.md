# Configurar o desktop Windows (SketchUp + V-Ray) para desenvolvimento

O SketchUp roda num **desktop Windows 11 da rede local que pertence a outra
pessoa** (o "dono do computador"). O desenvolvimento acontece num notebook
separado (WSL). Daqui sincronizamos código, recarregamos extensões,
executamos Ruby e rodamos testes no SketchUp dele pela **Dev Bridge**, uma
extensão *só de desenvolvimento*, através de um **túnel SSH**.

```
Notebook (WSL)                         Desktop Windows 11 (do dono)
make su-*  ──SSH (chave só-túnel)──►  OpenSSH Server
   túnel 127.0.0.1:17860 ──────────►  127.0.0.1:7860  Dev Bridge (dentro do SketchUp)
```

## Combinado com o dono do computador (antes de tudo)

- **Consentimento:** a Dev Bridge executa código dentro do SketchUp dele, com
  acesso aos arquivos da conta dele. Ele precisa concordar com isso.
- **Ele controla o acesso:** a ponte vem desligada e só funciona enquanto ele
  deixar ligada (*Extensions › Dev Bridge (DEV ONLY) › Start/Stop*). Com a
  ponte desligada, a chave SSH não dá acesso a nada no computador.
  *Start Automatically* (0.1.2+, marcado = ligado; ou `"autostart": true` em
  `%APPDATA%\MuriloEduardoDev\config.json`) liga a ponte sempre que o SketchUp
  abre; combine isso com ele, que pode desmarcar a qualquer momento.
- **Não atrapalhar o trabalho dele:** eval, reload e principalmente
  `make su-test` rodam no SketchUp aberto, travam a janela enquanto executam
  e os testes **trocam o modelo aberto por um vazio**. Só rode quando ele não
  estiver usando o SketchUp e com o trabalho dele salvo.
- **Licenças:** SketchUp Pro e V-Ray Pro são assinaturas nominais. Confirmem
  que usar a licença dele para o seu desenvolvimento está dentro dos termos
  da Trimble/Chaos, ou usem uma licença sua (trials de 30 dias existem para os dois).
- **Revogar a qualquer momento:** *Regenerate Token* no menu da ponte,
  remover a linha da chave em `authorized_keys` (ver abaixo) ou desinstalar
  a extensão.

## Segurança

- A Dev Bridge **só escuta em 127.0.0.1** e recusa conexões não locais. Não
  abre porta na rede.
- A chave SSH do notebook é gravada **restrita**:
  `command="echo tunnel-only",restrict,port-forwarding,permitopen="127.0.0.1:7860"`.
  Ela não abre shell, não copia arquivos e só encaminha para a porta da ponte
  (testado: shell → `tunnel-only`; outra porta → `administratively prohibited`;
  `scp` → falha).
- Login SSH por senha desligado; firewall da porta 22 só em rede **Privada**.
- Toda requisição exige o token de 48 caracteres, que fica em
  `%APPDATA%\MuriloEduardoDev\config.json` na conta do dono.
- A Dev Bridge **nunca** vai para o Extension Warehouse nem para a máquina de clientes.

## Passo a passo (uma vez)

### 1. Notebook (WSL): gerar uma chave SSH dedicada
```sh
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_sketchup -C sketchup-dev
cat ~/.ssh/id_ed25519_sketchup.pub     # copie a linha inteira
```

### 2. Desktop: ligar o OpenSSH (com o dono)
1. Rede do desktop como **Privada** (Configurações › Rede e Internet ›
   propriedades da conexão).
2. **Logado na conta do dono** (a que usa o SketchUp), abrir o PowerShell
   **como Administrador**:
   ```powershell
   cd $env:TEMP
   irm https://raw.githubusercontent.com/MuriloEduardo/sketch-up-plugins-test/master/tools/devbridge/windows/setup-openssh.ps1 -OutFile setup-openssh.ps1
   Set-ExecutionPolicy -Scope Process Bypass
   .\setup-openssh.ps1 -PublicKey "COLE-AQUI-A-LINHA-DO-.pub"
   ```
   Se a conta dele não for administradora, o Windows pede a senha de um
   administrador; a chave continua sendo da conta dele.
3. O script mostra o usuário e o IP. Se o IP mudar com frequência, reserve-o
   no roteador (DHCP fixo).

### 3. Desktop: instalar a Dev Bridge no SketchUp
1. Levar o arquivo `me_dev_bridge-*.rbz` até o desktop: gerado aqui com
   `make dev-bridge-package` (fica em `dist/`) ou baixado em
   GitHub › Actions › última execução › Artifacts.
2. SketchUp › *Extensions › Extension Manager › Install Extension* › escolher o `.rbz`.
   Se avisar que não é assinada, permitir (ou *Loading Policy › Unrestricted*).
3. *Extensions › Dev Bridge (DEV ONLY) › Start* e depois *Connection Info*.
   A janela mostra e **copia** o comando completo (usuário, IP e token).

### 4. Notebook (WSL): conectar e testar
Cole o comando copiado (mande por um canal privado, não por grupo):
```sh
make su-connect SSH=<usuario>@<ip> TOKEN=<token> KEY=~/.ssh/id_ed25519_sketchup
make su-ping            # versões do SketchUp, Ruby, V-Ray
make su-reload          # envia src/ e carrega a V-Ray Toolkit no SketchUp dele
make vray-docs-import   # baixa pela ponte a doc oficial da API Ruby do V-Ray
```
Para testes dentro do SketchUp: TestUp 2 instalado no desktop
(github.com/SketchUp/testup-2/releases) e `make su-test`, lembrando que
o modelo aberto é trocado.

## Uso diário

| Comando | O que faz |
|---|---|
| `make su-reload` | envia `src/` + `tests/sketchup/` e recarrega |
| `make su-eval CODE='...'` | executa Ruby no SketchUp e mostra o resultado |
| `tools/devbridge/su eval -f script.rb` | executa um script |
| `tools/devbridge/su eval --json '...'` | resultado como JSON |
| `make su-test [FILTER=TC_Nome#]` | TestUp com relatório (troca o modelo aberto!) |
| `make su-tunnel-stop` | fecha o túnel (fecha sozinho após 2 h) |

O código enviado fica em `%APPDATA%\MuriloEduardoDev\workspace` na conta do
dono e só é carregado pela Dev Bridge.

## Modo completo (opcional, só se o dono quiser)

`.\setup-openssh.ps1 -PublicKey "..." -AllowShell` autoriza a chave sem
restrições: habilita `make su-install-bridge` (copia a ponte por `scp`) e a
leitura automática do token. Isso dá ao notebook acesso de shell à conta dele.
Rode o script de novo sem `-AllowShell` para voltar ao modo restrito.

## Revogar acesso

- Rápido: *Dev Bridge › Stop* ou *Regenerate Token*.
- Definitivo: apagar a linha `... sketchup-dev` em
  `C:\ProgramData\ssh\administrators_authorized_keys` (conta administradora)
  ou `%USERPROFILE%\.ssh\authorized_keys`; desinstalar a Dev Bridge; opcional
  `Stop-Service sshd; Set-Service sshd -StartupType Disabled`.

## Problemas comuns

| Sintoma | Causa provável |
|---|---|
| `SSH ... falhou` / timeout | rede Pública, firewall, IP mudou ou sshd parado (`Get-Service sshd`) |
| `Permission denied (publickey)` | chave no arquivo errado; rode o script de novo |
| `Host key verification failed` | a chave do desktop mudou (reinstalação?): `ssh-keygen -R <ip>` e conecte de novo |
| `falta o token` | copie o comando da janela *Connection Info* |
| `a ponte não respondeu` | SketchUp fechado ou Dev Bridge parada |
| `HTTP 401` | token regenerado no desktop: pegue o novo em *Connection Info* |
| Diagnóstico SSH | `ssh -v -i ~/.ssh/id_ed25519_sketchup usuario@ip` (deve responder `tunnel-only`) |
