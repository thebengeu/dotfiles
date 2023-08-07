# https://boxstarter.org/package/nr/url?

Set-WindowsExplorerOptions -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles

winget settings --enable InstallerHashOverride
winget settings --enable LocalManifestFiles

$wingetPackageIds = @(
  'AgileBits.1Password'
  'AgileBits.1Password.CLI'
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
  'Git.Git'
  'RussellBanks.Komac'
  'ManicTime.ManicTime'
  'Obsidian.Obsidian'
  'Microsoft.Office'
  'Microsoft.Powershell'
  'Microsoft.PowerToys'
  'Neovide.Neovide'
  'Spotify.Spotify'
  'Starship.Starship'
  'StartIsBack.StartAllBack'
  'xanderfrangos.twinkletray'
  'Microsoft.VisualStudioCode'
  'JetBrains.WebStorm'
  'wez.wezterm'
  'Microsoft.WingetCreate'
  'Highresolution.X-MouseButtonControl'
)

foreach ($wingetPackageId in $wingetPackageIds)
{
  winget install --no-upgrade --silent --id $wingetPackageId
}

$storeApps = @(
  'Apple Music Preview'
  '9NRX63209R7B' # Outlook for Windows
  'Pure Battery Analytics'
  'Raindrop.io'
  'Unigram—Telegram for Windows'
  'WhatsApp'
)

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

New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target "$env:USERPROFILE\.config\nvim"

refreshenv

chezmoi init --apply --exclude templates --ssh thebengeu

$boxstarterPath = "$env:USERPROFILE\boxstarter"

git clone git@github.com:thebengeu/boxstarter.git "$boxstarterPath"

$manifestPaths = @(
  'a\AudioBand\AudioBand\1.2.1'
  'r\Rabby\RabbyDesktop\0.31.0'
  't\Todoist\Todoist\8.5.0'
)

foreach ($manifestPath in $manifestPaths)
{
  winget install --silent --manifest "$boxstarterPath\manifests\$manifestPath"
}
