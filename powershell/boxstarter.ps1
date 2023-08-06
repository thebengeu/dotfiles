# https://boxstarter.org/package/nr/url?

Set-WindowsExplorerOptions -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles

winget settings --enable LocalManifestFiles

$wingetPackageIds = @(
  'twpayne.chezmoi'
  'dandavison.delta'
  'Git.Git'
  'RussellBanks.Komac'
  'Microsoft.Powershell'
  'Starship.Starship'
  'StartIsBack.StartAllBack'
  'Microsoft.WingetCreate'
)

foreach ($wingetPackageId in $wingetPackageIds)
{
  winget install --silent --id $wingetPackageId
}

$storeApps = @(
  'Apple Music Preview'
  '9NRX63209R7B' # Outlook for Windows
  'Raindrop.io'
  'WhatsApp'
)

foreach ($storeApps in $storeApps)
{
  winget install --source msstore $storeApps
}

choco feature enable -n allowGlobalConfirmation

choco install op

refreshenv

Import-Module "${env:ChocolateyInstall}\helpers\chocolateyInstaller.psm1"

Install-ChocolateyShortcut -ShortcutFilePath "${env:APPDATA}\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Obsidian.lnk" -TargetPath "${env:LOCALAPPDATA}\Obsidian\Obsidian.exe"

chezmoi init --apply --exclude templates --ssh thebengeu

git clone git@github.com:thebengeu/boxstarter.git "${env:USERPROFILE}\boxstarter"

winget install --silent --manifest "${env:USERPROFILE}\boxstarter\manifests\a\AudioBand\AudioBand\1.2.1"