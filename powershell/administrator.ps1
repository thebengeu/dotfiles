function Set-Registry-Values($path, $values) {
  foreach ($name in $values.Keys) {
    Set-ItemProperty $path $name $values[$name]
  }
}

$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

Set-Registry-Values 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' @{
  Hidden          = 1
  HideFileExt     = 0
  ShowSuperHidden = 1
}

Stop-Process -processname explorer

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
  'ExpressVPN.ExpressVPN'
  'flux.flux'
  'Mozilla.Firefox'
  'Flow-Launcher.Flow-Launcher'
  'junegunn.fzf'
  'Git.Git'
  'ManicTime.ManicTime'
  'Notion.Notion'
  'Obsidian.Obsidian'
  'Microsoft.Powershell'
  'Microsoft.PowerToys'
  'Microsoft.Sysinternals.ProcessMonitor'
  'Neovide.Neovide'
  'QMK.QMKToolbox'
  'Spotify.Spotify'
  'Starship.Starship'
  'StartIsBack.StartAllBack'
  'Microsoft.VisualStudioCode'
  'JetBrains.WebStorm'
  'wez.wezterm'
  'Microsoft.WingetCreate'
  'Highresolution.X-MouseButtonControl'
  'th-ch.YouTubeMusic'
  'Zoom.Zoom'
  'ajeetdsouza.zoxide'
)

if (!$isMobile) {
  $wingetPackageIds += @(
    'Asus.ArmouryCrate'
    'BinaryFortress.DisplayFusion'
    'PlayStation.DualSenseFWUpdater'
    'Nvidia.GeForceExperience'
    'Valve.Steam'
    'xanderfrangos.twinkletray'
  )
}

foreach ($wingetPackageId in $wingetPackageIds) {
  $wingetPackageId
  winget install --no-upgrade --silent --id $wingetPackageId
}

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

if ($isMobile) {
  $storeApps += @(
    'Pure Battery Analytics'
  )
}
else {
  $storeApps += @(
    'Dolby Access'
    'DTS Sound Unbound'
  )
}

foreach ($storeApps in $storeApps) {
  winget install --accept-package-agreements --source msstore $storeApps
}

Set-ExecutionPolicy Unrestricted
Invoke-RestMethod community.chocolatey.org/install.ps1 | Invoke-Expression

choco feature enable -n allowGlobalConfirmation

$chocoPackages = @(
  'Kindle'
  'ledger-live'
  'spotify'
  'tableplus'
)

foreach ($chocoPackage in $chocoPackages) {
  choco install $chocoPackage
}

Install-PackageProvider NuGet -Force
Set-PSRepository PSGallery -InstallationPolicy Trusted

Install-Module PSFzf

$startMenuPrograms = 'Microsoft\Windows\Start Menu\Programs'

$shortcutArguments = @{
  "$env:APPDATA\$startMenuPrograms\Chromium.lnk"    = '--proxy-server=zproxy.lum-superproxy.io:22225'
  "$env:ProgramData\$startMenuPrograms\Neovide.lnk" = '--multigrid --wsl'
}

foreach ($shortcutPath in $shortcutArguments.Keys) {
  $shortcut = (New-Object -ComObject WScript.Shell).CreateShortCut($shortcutPath)
  $shortcut.Arguments = $shortcutArguments[$shortcutPath]
  $shortcut.Save()
}

Set-ItemProperty 'HKCU:\Control Panel\Mouse' 'MouseSensitivity' 20
Set-ItemProperty 'HKCU:\Software\Microsoft\Accessibility' 'CursorSize' 2

if ($isMobile) {
  Set-Registry-Values "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" @{
    FourFingerSlideEnabled = 3
    FourFingerTapEnabled   = 3
    RightClickZoneEnabled  = 0
    ThreeFingerTapEnabled  = 4
  }
}

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

foreach ($unnecessaryApp in $unnecessaryApps) {
  Get-AppxPackage $unnecessaryApp | Remove-AppxPackage
}

Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -NoRestart -Online