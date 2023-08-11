Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })

Import-Module PSFzf
Import-Module PSWindowsUpdate

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

New-Alias which Get-Command

$Env:NODE_NO_WARNINGS = 1
$Env:PNPM_HOME = "$env:LOCALAPPDATA\pnpm"
$Env:Path += @(
    "$Env:ProgramFiles\PostgreSQL\15\bin"
    $Env:PNPM_HOME
    "$Env:USERPROFILE\go\bin"
) -join [IO.Path]::PathSeparator
