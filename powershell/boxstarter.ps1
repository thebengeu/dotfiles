# https://boxstarter.org/package/nr/url?

Set-WindowsExplorerOptions -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles

winget settings --enable LocalManifestFiles

$wingetPackages = @(
  'twpayne.chezmoi'
  'Git.Git'
  'komac'
  'Microsoft.Powershell'
  'Starship.Starship'
  'startallback'
  'wingetcreate'
)

foreach ($wingetPackage in $wingetPackages)
{
  winget install --silent $wingetPackage
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