Invoke-Expression (&starship init powershell)
Invoke-Expression (& {
 (zoxide init --cmd cd powershell | Out-String) }
)

Import-Module gsudoModule
Import-Module PSFzf
Import-Module PSWindowsUpdate

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

. .\aliases.ps1

Set-Alias touch New-Item
Set-Alias which Get-Command

function ca
{
  chezmoi apply --exclude templates; chezmoi apply $(sh -c "chezmoi managed --include files --path-style absolute | rg --invert-match '.aws/credentials|.config/ghorg/conf.yaml|.msmtprc'")
}

function cu
{
  chezmoi update --exclude templates; chezmoi apply $(sh -c "chezmoi managed --include files --path-style absolute | rg --invert-match '.aws/credentials|.config/ghorg/conf.yaml|.msmtprc'")
}
