$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

$storeApps = @(
  'Apple Music'
  'Apple TV'
  '9PL8WPH0QK9M' # Cider (Preview)
  'Fantastical'
  'iCloud'
  'Netflix'
  '9NRX63209R7B' # Outlook for Windows
  'Sysinternals Suite'
  'Unigram—Telegram for Windows'
  'WhatsApp'
  'Windows Terminal Preview'
)

if ($isMobile)
{
  $storeApps += @(
    'Pure Battery Analytics'
  )
}

if (!$isMobile -Or $Env:USERDOMAIN -eq 'GPD')
{
  $storeApps += @(
    'Dolby Access'
    'DTS Sound Unbound'
  )
}

winget install --accept-package-agreements --source msstore $storeApps
