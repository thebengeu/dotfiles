$shortcutArguments = @{
  "Chromium" = '--proxy-server=zproxy.lum-superproxy.io:22225'
  "Neovide" = '--multigrid --wsl'
}

foreach ($appName in $shortcutArguments.Keys)
{
  $shortcut = (New-Object -ComObject WScript.Shell).CreateShortCut("$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\$appName.lnk")
  $shortcut.Arguments = $shortcutArguments[$appName]
  $shortcut.Save()
}

$wingetPackageIds = @(
  'Microsoft.Office'
  'Neovim.Neovim.Nightly'
)

foreach ($wingetPackageId in $wingetPackageIds)
{
  winget install --ignore-security-hash --silent --id $wingetPackageId
}

if ($nul -eq (Get-Command -ErrorAction SilentlyContinue scoop)) {
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

chezmoi init --apply --exclude templates --ssh thebengeu

New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target "$env:USERPROFILE\.config\nvim"

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
