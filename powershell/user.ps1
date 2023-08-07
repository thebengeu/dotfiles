$wingetPackageIds = @(
  'Microsoft.Office'
  'Neovim.Neovim.Nightly'
)

foreach ($wingetPackageId in $wingetPackageIds)
{
  winget install --ignore-security-hash --silent --id $wingetPackageId
}

irm get.scoop.sh | iex
scoop bucket add extras

$scoopPackages = @(
)

foreach ($scoopPackage in $scoopPackages)
{
  scoop install $scoopPackage
}
