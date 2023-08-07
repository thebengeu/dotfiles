irm get.scoop.sh | iex
scoop bucket add extras

$scoopPackages = @(
  'tableplus'
)

foreach ($scoopPackage in $scoopPackages)
{
  scoop install $scoopPackage
}
