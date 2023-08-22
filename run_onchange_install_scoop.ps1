if ($nul -eq (Get-Command -ErrorAction SilentlyContinue scoop))
{
  Invoke-RestMethod get.scoop.sh | Invoke-Expression
}

scoop bucket add extras
scoop bucket add nerd-fonts
