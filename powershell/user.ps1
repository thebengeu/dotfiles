$ignoreSecurityHashWingetPackageIds = @(
  'Microsoft.Office'
  'Neovim.Neovim.Nightly'
)

if (!$isMobile) {
  $ignoreSecurityHashWingetPackageIds += @(
    'Logitech.LogiTune'
  )
}

foreach ($ignoreSecurityHashWingetPackageId in $ignoreSecurityHashWingetPackageIds) {
  winget install --ignore-security-hash --silent --id $ignoreSecurityHashWingetPackageId
}

if ($nul -eq (Get-Command -ErrorAction SilentlyContinue scoop)) {
  Invoke-RestMethod get.scoop.sh | Invoke-Expression
}

scoop bucket add extras

$scoopPackages = @(
  'goneovim'
  'lazygit'
  'topgrade'
)

foreach ($scoopPackage in $scoopPackages) {
  scoop install $scoopPackage
}

chezmoi init --apply --ssh thebengeu

$localAppDataNvimPath = "$env:LOCALAPPDATA\nvim"

if (!(Test-Path $localAppDataNvimPath)) {
  New-Item -ItemType Junction -Path $localAppDataNvimPath -Target "$env:USERPROFILE\.config\nvim"
}

git clone git@github.com:thebengeu/powershell.git "$env:USERPROFILE\powershell"
