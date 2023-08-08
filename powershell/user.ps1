$wingetPackageIds = @(
  'Microsoft.Office'
  'Neovim.Neovim.Nightly'
)

foreach ($wingetPackageId in $wingetPackageIds)
{
  winget install --ignore-security-hash --silent --id $wingetPackageId
}

if ($nul -eq (Get-Command -ErrorAction SilentlyContinue scoop)) {
  Invoke-RestMethod get.scoop.sh | Invoke-Expression
}

scoop bucket add extras

$scoopPackages = @(
  'goneovim'
)

foreach ($scoopPackage in $scoopPackages)
{
  scoop install $scoopPackage
}

chezmoi init --apply --ssh thebengeu

New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target "$env:USERPROFILE\.config\nvim"

$powershellPath = "$env:USERPROFILE\powershell"

git clone git@github.com:thebengeu/powershell.git "$powershellPath"

$manifestPaths = @(
  'a\AudioBand\AudioBand\1.2.1'
  'r\Rabby\RabbyDesktop\0.31.0'
  't\Todoist\Todoist\8.5.0'
)

foreach ($manifestPath in $manifestPaths)
{
  winget install --silent --manifest "$powershellPath\manifests\$manifestPath"
}
