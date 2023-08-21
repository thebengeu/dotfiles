Invoke-Expression (&starship init powershell)
Invoke-Expression (& {
 (zoxide init --cmd cd powershell | Out-String) }
)

Import-Module gsudoModule
Import-Module Microsoft.WinGet.Client
Import-Module PSFzf
Import-Module PSWindowsUpdate

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

. $Env:USERPROFILE\aliases.ps1

Set-Alias touch New-Item
Set-Alias which Get-Command
