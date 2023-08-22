$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

$storeApps = @(
  'Apple Music Preview'
  '9PL8WPH0QK9M' # Cider (Preview)
  'iCloud'
  '9NRX63209R7B' # Outlook for Windows
  'Raindrop.io'
  'Unigram—Telegram for Windows'
  'WhatsApp'
  'Windows Terminal Preview'
)

if ($isMobile)
{
  $storeApps += @(
    'Pure Battery Analytics'
  )
} else
{
  $storeApps += @(
    'Dolby Access'
    'DTS Sound Unbound'
  )
}

foreach ($storeApps in $storeApps)
{
  winget install --accept-package-agreements --source msstore $storeApps
}
