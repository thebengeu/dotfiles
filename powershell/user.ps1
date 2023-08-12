$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

$ignoreSecurityHashWingetPackageIds = @(
  'Microsoft.Office'
  'Neovim.Neovim.Nightly'
)

if (!$isMobile)
{
  $ignoreSecurityHashWingetPackageIds += @(
    'Logitech.LogiTune'
  )
}

foreach ($ignoreSecurityHashWingetPackageId in $ignoreSecurityHashWingetPackageIds)
{
  winget install --exact --ignore-security-hash --silent --id $ignoreSecurityHashWingetPackageId
}

if ($nul -eq (Get-Command -ErrorAction SilentlyContinue scoop))
{
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

chezmoi init --apply --ssh thebengeu

. $PROFILE

$localAppDataNvimPath = "$Env:LOCALAPPDATA\nvim"

if (!(Test-Path $localAppDataNvimPath))
{
  New-Item -ItemType Junction -Path $localAppDataNvimPath -Target "$Env:USERPROFILE\.config\nvim"
}

git clone git@github.com:thebengeu/powershell.git "$Env:USERPROFILE\powershell"

pnpm add --global pino-pretty npm-check-updates https://github.com/thebengeu/ts-node.git

pip install pipx

pipx install neovim-remote

go install github.com/nao1215/gup@latest
gup import

$crates = @(
  'atuin'
  'bat'
  'broot'
  'cargo-update'
  'fd-find'
  'just'
  'starship'
  'tealdeer'
  'tokei'
  'topgrade'
  'xh'
  'zoxide'
)

foreach ($crate in $crates)
{
  cargo install $crate
}

$Env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + [IO.Path]::PathSeparator + [System.Environment]::GetEnvironmentVariable("PATH", "User")
