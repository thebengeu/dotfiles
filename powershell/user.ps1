$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

$ignoreSecurityHashWingetPackageIds = @(
  'Microsoft.Office'
  'Neovim.Neovim.Nightly'
)

if (!$isMobile)
{
  $ignoreSecurityHashWingetPackageIds += @(
    'Logitech.LogiTune'
  )
}

foreach ($ignoreSecurityHashWingetPackageId in $ignoreSecurityHashWingetPackageIds)
{
  winget install --exact --ignore-security-hash --silent --id $ignoreSecurityHashWingetPackageId
}

if ($nul -eq (Get-Command -ErrorAction SilentlyContinue scoop))
{
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
