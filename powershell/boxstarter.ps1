# https://boxstarter.org/package/nr/url?

Set-WindowsExplorerOptions -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles

winget settings --enable InstallerHashOverride
winget settings --enable LocalManifestFiles

$wingetPackageIds = @(
  'AgileBits.1Password'
  '7zip.7zip'
  'Twilio.Authy'
  'Armin2208.WindowsAutoNightMode'
  'twpayne.chezmoi'
  'Hibbiki.Chromium'
  'dandavison.delta'
  'Discord.Discord'
  'flux.flux'
  'Mozilla.Firefox'
  'Flow-Launcher.Flow-Launcher'
  'junegunn.fzf'
  'Git.Git'
  'ManicTime.ManicTime'
  'Obsidian.Obsidian'
  'Microsoft.Powershell'
  'Microsoft.PowerToys'
  'Microsoft.Sysinternals.ProcessMonitor'
  'Neovide.Neovide'
  'Spotify.Spotify'
  'Starship.Starship'
  'StartIsBack.StartAllBack'
  'Microsoft.VisualStudioCode'
  'JetBrains.WebStorm'
  'wez.wezterm'
  'Microsoft.WingetCreate'
  'Highresolution.X-MouseButtonControl'
  'ajeetdsouza.zoxide'
)

$isDesktop = $env:COMPUTERNAME -eq 'DEV'

if ($isDesktop)
{
  $wingetPackageIds += 'xanderfrangos.twinkletray'
}

foreach ($wingetPackageId in $wingetPackageIds)
{
  winget install --no-upgrade --silent --id $wingetPackageId
}

$storeApps = @(
  'Apple Music Preview'
  '9NRX63209R7B' # Outlook for Windows
  'Raindrop.io'
  'Unigram—Telegram for Windows'
  'WhatsApp'
)

if (!$isDesktop)
{
  $storeApps += 'Pure Battery Analytics'
}

foreach ($storeApps in $storeApps)
{
  winget install --source msstore $storeApps
}

choco feature enable -n allowGlobalConfirmation

$chocoPackages = @(
  'Kindle'
  'tableplus'
)

foreach ($chocoPackage in $chocoPackages)
{
  choco install $chocoPackage
}

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

Install-Module PSFzf

$startMenuPrograms = 'Microsoft\Windows\Start Menu\Programs'

$shortcutArguments = @{
  "$env:APPDATA\$startMenuPrograms\Chromium.lnk" = '--proxy-server=zproxy.lum-superproxy.io:22225'
  "$env:ProgramData\$startMenuPrograms\Neovide.lnk" = '--multigrid --wsl'
}

foreach ($shortcutPath in $shortcutArguments.Keys)
{
  $shortcut = (New-Object -ComObject WScript.Shell).CreateShortCut($shortcutPath)
  $shortcut.Arguments = $shortcutArguments[$shortcutPath]
  $shortcut.Save()
}

Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSensitivity" -Value 20
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" -Name "ThreeFingerTapEnabled" -Value 4
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" -Name "FourFingerSlideEnabled" -Value 3
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" -Name "FourFingerTapEnabled" -Value 3
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" -Name "RightClickZoneEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Accessibility" -Name "CursorSize" -Value 2

$unnecessaryApps = @(
  'Clipchamp.Clipchamp'
  'Microsoft.549981C3F5F10' # Cortana
  'Microsoft.BingNews'
  'Microsoft.BingWeather'
  'Microsoft.GetHelp'
  'Microsoft.Getstarted'
  'Microsoft.MicrosoftSolitaireCollection'
  'Microsoft.MicrosoftStickyNotes'
  'Microsoft.Paint'
  'Microsoft.PowerAutomateDesktop'
  'Microsoft.Todos'
  'Microsoft.WindowsAlarms'
  'Microsoft.WindowsCalculator'
  'Microsoft.WindowsFeedbackHub'
  'Microsoft.WindowsMaps'
  'Microsoft.WindowsSoundRecorder'
  'Microsoft.ZuneMusic'
  'Microsoft.ZuneVideo'
  'MicrosoftCorporationII.QuickAssist'
)

foreach ($unnecessaryApp in $unnecessaryApps)
{
  Get-AppxPackage $unnecessaryApp | Remove-AppxPackage
}