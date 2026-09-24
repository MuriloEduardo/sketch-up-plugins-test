#Requires -RunAsAdministrator
<#
.SYNOPSIS
  Prepara o desktop Windows para receber a Dev Bridge via túnel SSH.

.DESCRIPTION
  1. Instala e liga o OpenSSH Server (recurso opcional do Windows).
  2. Restringe a regra de firewall da porta 22 ao perfil de rede Privado.
  3. Autoriza a chave pública da máquina de desenvolvimento (WSL).
     Por padrão a chave é RESTRITA: só permite o túnel até a Dev Bridge
     (127.0.0.1:<BridgePort>). Sem shell, sem cópia de arquivos, sem acesso a
     mais nada. Com a Dev Bridge desligada, a chave não dá acesso algum.
  4. Desliga o login SSH por senha (somente chave).

  Rode no PowerShell COMO ADMINISTRADOR, logado com o usuário que usa o SketchUp:
    Set-ExecutionPolicy -Scope Process Bypass
    .\setup-openssh.ps1 -PublicKey "ssh-ed25519 AAAA... sketchup-dev"

.PARAMETER PublicKey
  Conteúdo de ~/.ssh/id_ed25519_sketchup.pub gerado no WSL.

.PARAMETER BridgePort
  Porta da Dev Bridge no desktop (padrão 7860).

.PARAMETER AllowShell
  Autoriza a chave SEM restrições (shell e scp). Use só se o dono do
  computador quiser; habilita make su-install-bridge e leitura automática do token.
#>
param(
  [Parameter(Mandatory = $true)]
  [string]$PublicKey,
  [int]$BridgePort = 7860,
  [switch]$AllowShell
)

$ErrorActionPreference = 'Stop'

if ($PublicKey -notmatch '^(ssh-ed25519|ssh-rsa|ecdsa-sha2-\S+) \S+') {
  throw 'PublicKey não parece uma chave pública OpenSSH (ssh-ed25519 AAAA...).'
}

Write-Host '1/4 OpenSSH Server'
$capability = Get-WindowsCapability -Online -Name 'OpenSSH.Server*' | Select-Object -First 1
if ($capability.State -ne 'Installed') {
  Add-WindowsCapability -Online -Name $capability.Name | Out-Null
}
Set-Service -Name sshd -StartupType Automatic
Start-Service sshd

Write-Host '2/4 Firewall (porta 22 somente em rede Privada)'
$ruleName = 'OpenSSH-Server-In-TCP'
if (Get-NetFirewallRule -Name $ruleName -ErrorAction SilentlyContinue) {
  Set-NetFirewallRule -Name $ruleName -Profile Private -Enabled True
} else {
  New-NetFirewallRule -Name $ruleName -DisplayName 'OpenSSH Server (sshd)' -Enabled True `
    -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 -Profile Private | Out-Null
}
$public = Get-NetConnectionProfile | Where-Object { $_.NetworkCategory -eq 'Public' }
if ($public) {
  Write-Warning ("Rede(s) em perfil Público: " + ($public.Name -join ', ') +
    ". O SSH só aceita conexões em rede Privada. Mude em Configurações > Rede > Propriedades.")
}

Write-Host '3/4 Chave autorizada'
$currentSid = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$adminSid = 'S-1-5-32-544'
$isAdmin = @(Get-LocalGroupMember -SID $adminSid | Where-Object { $_.SID.Value -eq $currentSid }).Count -gt 0
if ($isAdmin) {
  # Contas administradoras usam um arquivo global com ACL restrita (exigência do OpenSSH no Windows).
  $keysFile = Join-Path $env:ProgramData 'ssh\administrators_authorized_keys'
} else {
  $keysFile = Join-Path $env:USERPROFILE '.ssh\authorized_keys'
  New-Item -ItemType Directory -Force -Path (Split-Path $keysFile) | Out-Null
}
$key = $PublicKey.Trim()
if ($AllowShell) {
  $entry = $key
} else {
  # Comando forçado + restrict: nenhuma sessão de shell; só o encaminhamento
  # de porta para a Dev Bridge em loopback.
  $entry = "command=`"echo tunnel-only`",restrict,port-forwarding,permitopen=`"127.0.0.1:$BridgePort`" $key"
}
$keyBody = ($key -split ' ')[1]
$existing = if (Test-Path $keysFile) { @(Get-Content $keysFile) } else { @() }
# Substitui entradas anteriores da mesma chave (ex.: trocar de modo).
$kept = $existing | Where-Object { $_ -notmatch [regex]::Escape($keyBody) }
@($kept) + $entry | Where-Object { $_ } | Set-Content -Path $keysFile -Encoding ascii
if ($isAdmin) {
  icacls $keysFile /inheritance:r /grant '*S-1-5-32-544:F' /grant '*S-1-5-18:F' | Out-Null
} else {
  icacls $keysFile /inheritance:r /grant "*$($currentSid):F" /grant '*S-1-5-18:F' | Out-Null
}

Write-Host '4/4 Somente login por chave'
$config = Join-Path $env:ProgramData 'ssh\sshd_config'
$lines = Get-Content $config | Where-Object { $_ -notmatch '^\s*#?\s*PasswordAuthentication\s' }
@('PasswordAuthentication no') + $lines | Set-Content -Path $config -Encoding ascii
Restart-Service sshd

$addresses = Get-NetIPAddress -AddressFamily IPv4 |
  Where-Object { $_.IPAddress -match '^(10\.|192\.168\.|172\.(1[6-9]|2\d|3[01])\.)' } |
  Select-Object -ExpandProperty IPAddress
Write-Host ''
if ($AllowShell) {
  Write-Host 'Chave autorizada SEM restrições (shell/scp).' -ForegroundColor Yellow
} else {
  Write-Host "Chave autorizada SOMENTE para túnel até 127.0.0.1:$BridgePort." -ForegroundColor Green
}
Write-Host 'Pronto. Abra o SketchUp, instale a Dev Bridge (.rbz) e use'
Write-Host 'Extensions > Dev Bridge (DEV ONLY) > Connection Info: o comando para o WSL'
Write-Host '(com usuário, IP e token) é copiado para a área de transferência.'
Write-Host ("Usuário: $($env:USERNAME)   IPs: " + ($addresses -join ', '))
