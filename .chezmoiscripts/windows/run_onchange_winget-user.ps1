$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

$wingetPackageIds = @(
  'Spotify.Spotify'
)

foreach ($wingetPackageId in $wingetPackageIds)
{
  $wingetPackageId
  winget install --exact --no-upgrade --silent $wingetPackageId
}

$ignoreSecurityHashWingetPackageIds = @(
  'Microsoft.Office'
)

if (!$isMobile)
{
  $ignoreSecurityHashWingetPackageIds += @(
    'Logitech.LogiTune'
    'VirtualDesktop.Streamer'
  )
}

winget install --exact --ignore-security-hash --no-upgrade --silent $ignoreSecurityHashWingetPackageIds
