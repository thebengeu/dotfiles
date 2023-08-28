$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

$wingetPackageIds = @(
  'Spotify.Spotify'
)

foreach ($wingetPackageId in $wingetPackageIds)
{
  $wingetPackageId
  winget install --exact --no-upgrade --silent --id $wingetPackageId
}

$ignoreSecurityHashWingetPackageIds = @(
  'Microsoft.Office'
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
