# SketchUp + V-Ray — extensões

Monorepo de extensões Ruby para SketchUp focadas em automação do V-Ray for
SketchUp, com toolchain em Docker e integração WSL → SketchUp (Windows).

## Requisitos

- WSL2 (Ubuntu) com Docker + Docker Compose v2, `make`, `python3` e `ssh`.
- Para rodar de verdade: um PC Windows na rede com SketchUp 2024+ (alvo: 2026) e V-Ray 7.

## Início rápido

```sh
make build     # imagem da toolchain (Ruby 3.2, igual ao SketchUp)
make check     # RuboCop + RuboCop-SketchUp + testes unitários
make package   # dist/me_vray_toolkit-<versão>.rbz
make help      # todos os comandos
```

## Instalação no computador que roda o SketchUp

O desenvolvimento acontece numa máquina (WSL) e o SketchUp + V-Ray rodam em
outro computador Windows da mesma rede local, que pode ser de outra pessoa.
A ligação entre os dois é a **Dev Bridge**, uma extensão *só de
desenvolvimento* acessada por túnel SSH. Guia completo, com segurança e
revogação: [docs/remote-desktop-setup.md](docs/remote-desktop-setup.md).

> Se o computador não é seu: combine antes com o dono. A Dev Bridge executa
> código dentro do SketchUp dele, fica desligada até ele ligar e os testes
> trocam o modelo aberto. Confirmem também os termos das licenças do
> SketchUp e do V-Ray.

**1. Máquina de desenvolvimento: gerar uma chave SSH**
```sh
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_sketchup -C sketchup-dev
cat ~/.ssh/id_ed25519_sketchup.pub     # copie a linha inteira
```

**2. Computador do SketchUp: habilitar o SSH** (PowerShell como
Administrador, na conta que usa o SketchUp, com a rede em perfil Privado)
```powershell
cd $env:TEMP
irm https://raw.githubusercontent.com/MuriloEduardo/sketch-up-plugins-test/master/tools/devbridge/windows/setup-openssh.ps1 -OutFile setup-openssh.ps1
Set-ExecutionPolicy -Scope Process Bypass
.\setup-openssh.ps1 -PublicKey "COLE-AQUI-A-LINHA-DO-.pub"
```
O script liga o OpenSSH, libera a porta 22 só em rede Privada, desliga o
login por senha e autoriza a chave **apenas para o túnel até a Dev Bridge**
(sem shell nem cópia de arquivos).

**3. Computador do SketchUp: instalar a Dev Bridge**

Só um arquivo é instalado lá: `me_dev_bridge-<versão>.rbz`. As extensões em
desenvolvimento não precisam de `.rbz`; chegam pela ponte com `make su-reload`.

- Obter o arquivo: `make dev-bridge-package` na máquina de desenvolvimento
  (gera em `dist/`; pelo Explorer do Windows fica em
  `\\wsl.localhost\<distro>\<caminho do repositório>\dist`) ou baixar em
  *GitHub › Actions › última execução › Artifacts* (um `.zip` com os `.rbz`).
- No SketchUp: *Extensions › Extension Manager › Install Extension* e escolher
  o `.rbz`. Se avisar que a extensão não é assinada, permitir.
- *Extensions › Dev Bridge (DEV ONLY) › Start* e depois *Connection Info*,
  que mostra e copia o comando de conexão (usuário, IP e token).

**4. Máquina de desenvolvimento: conectar**
```sh
make su-connect SSH=usuario@ip TOKEN=... KEY=~/.ssh/id_ed25519_sketchup   # comando copiado
make su-ping                  # versões do SketchUp, Ruby e V-Ray
make su-reload                # envia src/ e carrega as extensões no SketchUp
make su-eval CODE='Sketchup.active_model.title'
make su-test                  # TestUp (troca o modelo aberto)
```

Para cortar o acesso a qualquer momento: *Dev Bridge › Stop* ou
*Regenerate Token* no SketchUp; em definitivo, desinstalar a extensão e
remover a chave de `authorized_keys` (ver o guia).

## Documentação

| Documento | Conteúdo |
|---|---|
| [docs/workflow.md](docs/workflow.md) | Configuração, ciclo diário, depuração, release |
| [docs/remote-desktop-setup.md](docs/remote-desktop-setup.md) | Desktop Windows: OpenSSH, Dev Bridge, segurança |
| [docs/architecture.md](docs/architecture.md) | Topologia WSL/Windows/Docker e camadas do código |
| [docs/roadmap.md](docs/roadmap.md) | Produtos, backlog comercial e técnico |
| [docs/PROGRESS.md](docs/PROGRESS.md) | Estado atual e próximos passos |
| [docs/decisions.md](docs/decisions.md) | Decisões de arquitetura |
| [docs/reference/](docs/reference/README.md) | Base de conhecimento SketchUp e V-Ray |
| [CLAUDE.md](CLAUDE.md) | Instruções para o Claude Code |

## Licenças de terceiros

Ver [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
