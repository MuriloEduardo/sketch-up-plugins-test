# Configurar o desktop Windows (SketchUp + V-Ray) para desenvolvimento

O SketchUp roda no **desktop Windows 11** da rede local. Daqui do WSL nós
sincronizamos código, recarregamos extensões, executamos Ruby e rodamos
testes nele pela **Dev Bridge**, uma extensão *só de desenvolvimento*,
através de um **túnel SSH**.

```
WSL (este PC)                          Desktop Windows 11
make su-*  ──SSH (chave, porta 22)──►  OpenSSH Server
   túnel 127.0.0.1:17860 ────────────►  127.0.0.1:7860  Dev Bridge (dentro do SketchUp)
```

## Segurança (por que é seguro o suficiente)

- A Dev Bridge **só escuta em 127.0.0.1** e recusa conexões que não sejam
  locais. Não há porta nova aberta na rede.
- O único acesso remoto é o SSH, **somente com chave** (senha desligada) e
  com firewall liberado **só em rede Privada**. Quem tem esse acesso já
  poderia executar qualquer coisa no desktop; a ponte não aumenta o risco.
- Toda requisição exige um token de 48 caracteres (`%APPDATA%\MuriloEduardoDev\config.json`).
- A ponte vem **desligada** por padrão: ligue em *Extensions › Dev Bridge › Start*
  quando formos trabalhar. Para ligar sozinha ao abrir o SketchUp, mude
  `"autostart": true` no `config.json`.
- A Dev Bridge executa código recebido. **Nunca** a instale na máquina de um
  cliente nem publique no Extension Warehouse.

## Passo a passo (uma vez)

### 1. WSL: gerar uma chave SSH dedicada
```sh
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_sketchup -C sketchup-dev
cat ~/.ssh/id_ed25519_sketchup.pub     # copie a linha inteira
```

### 2. Desktop: ligar o OpenSSH
1. Confirme que a rede do desktop está como **Privada**
   (Configurações › Rede e Internet › propriedades da conexão).
2. Abra o **PowerShell como Administrador** (logado com o usuário que usa o SketchUp) e rode:
   ```powershell
   cd $env:TEMP
   irm https://raw.githubusercontent.com/MuriloEduardo/sketch-up-plugins-test/master/tools/devbridge/windows/setup-openssh.ps1 -OutFile setup-openssh.ps1
   Set-ExecutionPolicy -Scope Process Bypass
   .\setup-openssh.ps1 -PublicKey "COLE-AQUI-A-LINHA-DO-.pub"
   ```
3. O script imprime o comando para o próximo passo, com o seu usuário e IP.
   Se o IP do desktop mudar com frequência, reserve-o no roteador (DHCP fixo).

### 3. WSL: conectar
```sh
make su-connect SSH=<usuario>@<ip-do-desktop> KEY=~/.ssh/id_ed25519_sketchup
```

### 4. Instalar a Dev Bridge no SketchUp do desktop
Com o SketchUp **fechado**:
```sh
make su-install-bridge SU_YEAR=2026
```
Alternativa manual: baixe `me_dev_bridge-*.rbz` dos artefatos do CI
(GitHub › Actions › execução › Artifacts) ou gere com `make dev-bridge-package`
e instale em *Extensions › Extension Manager › Install Extension*.

### 5. Desktop: abrir o SketchUp
1. Se aparecer aviso de extensão não assinada, permita (ou *Extension Manager ›
   Loading Policy › Unrestricted*, só nesta máquina de desenvolvimento).
2. *Extensions › Dev Bridge (DEV ONLY) › Start*.
3. Se a V-Ray Toolkit já estiver instalada por `.rbz`, desinstale: a versão de
   desenvolvimento vem do workspace sincronizado.

### 6. WSL: testar
```sh
make su-ping            # versões do SketchUp, Ruby, V-Ray
make su-reload          # envia src/ e carrega a V-Ray Toolkit no SketchUp
make vray-docs-import   # baixa a doc oficial da API Ruby do V-Ray
```
Para testes dentro do SketchUp, instale o TestUp 2 no desktop
(github.com/SketchUp/testup-2/releases) e rode `make su-test`.

## Uso diário

| Comando | O que faz |
|---|---|
| `make su-reload` | envia `src/` + `tests/sketchup/` e recarrega |
| `make su-eval CODE='...'` | executa Ruby no SketchUp e mostra o resultado |
| `tools/devbridge/su eval -f script.rb` | executa um script |
| `tools/devbridge/su eval --json '...'` | resultado como JSON |
| `make su-test [FILTER=TC_Nome#]` | TestUp com relatório |
| `make su-tunnel-stop` | fecha o túnel (fecha sozinho após 2 h) |

Arquivos de registro/menus novos: o `reload` registra extensões novas, mas
alterações em menus já criados só aparecem ao reiniciar o SketchUp.

## Problemas comuns

| Sintoma | Causa provável |
|---|---|
| `SSH ... falhou` / timeout | rede do desktop como Pública; firewall; IP mudou; sshd parado (`Get-Service sshd`) |
| `Permission denied (publickey)` | chave no arquivo errado (conta admin usa `C:\ProgramData\ssh\administrators_authorized_keys`); rode o script de novo |
| `a ponte não respondeu` | SketchUp fechado ou Dev Bridge parada (*Extensions › Dev Bridge › Start*) |
| `HTTP 401` | token trocado no desktop: apague a linha `SU_TOKEN` de `.devbridge.env` |
| `pasta Plugins não encontrada` | abra o SketchUp daquele ano uma vez antes |
| Diagnóstico SSH | `ssh -v -i ~/.ssh/id_ed25519_sketchup usuario@ip` |
