#!/usr/bin/env powershell
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  if (Get-Command sudo)
  {
    sudo pwsh "$($MyInvocation.MyCommand.Path)"
  } else
  {
    $CommandLine = "-NoExit -NoProfile -File `"" + $MyInvocation.MyCommand.Path + "`""
    Start-Process -Wait -FilePath powershell -Verb Runas -ArgumentList $CommandLine
  }
  Exit
}

$connectAddress = $(wsl sh -c "hostname -I | cut --delimiter ' ' --fields 1")
$displayName = 'WSL 2 Firewall Unlock'
$ports = 24,3000

Remove-NetFireWallRule -DisplayName $displayName
New-NetFireWallRule -Action Allow -Direction Inbound -DisplayName $displayName -LocalPort $ports -Protocol TCP

foreach ($port in $ports)
{
  netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=$port
  netsh interface portproxy add v4tov4 connectaddress=$connectAddress connectport=$port listenaddress=0.0.0.0 listenport=$port
}

netsh interface portproxy show v4tov4
