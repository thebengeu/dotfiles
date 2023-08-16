Invoke-Expression (&starship init powershell)
Invoke-Expression (& {
 (zoxide init --cmd cd powershell | Out-String) }
)

Import-Module gsudoModule
Import-Module PSFzf
Import-Module PSWindowsUpdate

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

. .\aliases.ps1
Set-Alias which Get-Command
