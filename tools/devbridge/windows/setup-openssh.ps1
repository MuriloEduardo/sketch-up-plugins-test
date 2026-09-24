#Requires -RunAsAdministrator
<#
.SYNOPSIS
  Prepara o desktop Windows para receber a Dev Bridge via túnel SSH.

.DESCRIPTION
  1. Instala e liga o OpenSSH Server (recurso opcional do Windows).
  2. Restringe a regra de firewall da porta 22 ao perfil de rede Privado.
  3. Autoriza a chave pública da máquina de desenvolvimento (WSL).
  4. Desliga o login SSH por senha (somente chave).

  Rode no PowerShell COMO ADMINISTRADOR, logado com o usuário que usa o SketchUp:
    Set-ExecutionPolicy -Scope Process Bypass
    .\setup-openssh.ps1 -PublicKey "ssh-ed25519 AAAA... sketchup-dev"

.PARAMETER PublicKey
  Conteúdo de ~/.ssh/id_ed25519_sketchup.pub gerado no WSL.
#>
param(
  [Parameter(Mandatory = $true)]
  [string]$PublicKey
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
$existing = if (Test-Path $keysFile) { Get-Content $keysFile } else { @() }
if ($existing -notcontains $PublicKey.Trim()) {
  Add-Content -Path $keysFile -Value $PublicKey.Trim() -Encoding ascii
}
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
Write-Host 'Pronto. No WSL, rode:' -ForegroundColor Green
foreach ($address in $addresses) {
  Write-Host "  make su-connect SSH=$($env:USERNAME)@$address KEY=~/.ssh/id_ed25519_sketchup"
}
