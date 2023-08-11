Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })

Import-Module PSFzf

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

New-Alias which Get-Command

$Env:NODE_NO_WARNINGS = 1
$Env:Path += [IO.Path]::PathSeparator + "$env:ProgramFiles\PostgreSQL\15\bin"
