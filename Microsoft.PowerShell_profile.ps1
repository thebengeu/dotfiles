Import-Module gsudoModule
Import-Module PSFzf
Import-Module PSWindowsUpdate

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

. $Env:USERPROFILE\generated.ps1

Set-Alias touch New-Item
Set-Alias which Get-Command
