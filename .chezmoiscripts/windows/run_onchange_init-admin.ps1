if (!(Test-Path "$Env:USERPROFILE\scoop"))
{
  Invoke-RestMethod get.scoop.sh | Invoke-Expression
}

$scoopPackages = @(
  'cue'
)

scoop install $scoopPackages

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  if (Get-Command gsudo)
  {
    gsudo "& '$($MyInvocation.MyCommand.Path)'"
  } else
  {
    $CommandLine = "-NoExit -NoProfile -File `"" + $MyInvocation.MyCommand.Path + "`""
    Start-Process -Wait -FilePath powershell -Verb Runas -ArgumentList $CommandLine
  }
  Exit
}

$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

winget settings --enable InstallerHashOverride
winget settings --enable LocalManifestFiles

$wingetPackageIds = @(
  'AgileBits.1Password'
  'AgileBits.1Password.CLI'
  'FiloSottile.age'
  'sharkdp.bat'
  'Dystroy.broot'
  'rsteube.Carapace'
  'twpayne.chezmoi'
  'Kitware.CMake'
  'direnv.direnv'
  'Ditto.Ditto'
  'sharkdp.fd'
  'Schniz.fnm'
  'Git.Git'
  'GitHub.cli'
  'GoLang.Go'
  'gerardog.gsudo'
  'nao1215.gup'
  'jqlang.jq'
  'Casey.Just'
  'MSYS2.MSYS2'
  'OpenJS.NodeJS'
  'Microsoft.OpenSSH.Beta'
  'Microsoft.PowerShell'
  'Pulumi.Pulumi'
  'Python.Python.3.12'
  'BurntSushi.ripgrep.MSVC'
  'Rustlang.Rustup'
  'Starship.Starship'
  'wez.wezterm'
  'ajeetdsouza.zoxide'
)

winget install --exact --no-upgrade --silent $wingetPackageIds

$override = '--add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended --quiet --wait'
winget install --exact --no-upgrade --override $override --silent Microsoft.VisualStudio.2022.Community

$Env:PIP_REQUIRE_VIRTUALENV = false
pip3 install --upgrade --user pipx

pipx install poetry

if (!(Get-Command choco))
{
  Set-ExecutionPolicy Unrestricted
  Invoke-RestMethod community.chocolatey.org/install.ps1 | Invoke-Expression
  choco feature enable -n allowGlobalConfirmation
}

if (!(Get-PackageProvider NuGet))
{
  Install-PackageProvider NuGet -Force
}

Set-PSRepository PSGallery -InstallationPolicy Trusted

Install-Module PSFzf
Install-Module PSWindowsUpdate

if ($Env:PROCESSOR_ARCHITECTURE -ne 'ARM64')
{
  Install-Module Microsoft.WinGet.Client
}

$unnecessaryApps = @(
  'Clipchamp.Clipchamp'
  'Microsoft.549981C3F5F10' # Cortana
  'Microsoft.BingNews'
  'Microsoft.BingWeather'
  'Microsoft.GetHelp'
  'Microsoft.Getstarted'
  'Microsoft.MicrosoftOfficeHub'
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
  'SpotifyAB.SpotifyMusic'
)

foreach ($unnecessaryApp in $unnecessaryApps)
{
  Get-AppxPackage $unnecessaryApp | Remove-AppxPackage
}

if (!$isMobile)
{
  Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -NoRestart -Online
}

$PNPM_HOME = "$Env:LOCALAPPDATA\pnpm"

Set-Item 'Env:HOME' "$Env:USERPROFILE"
Set-Item 'Env:PNPM_HOME' "$PNPM_HOME"

[Environment]::SetEnvironmentVariable('HOME', "$Env:USERPROFILE", 'User')
[Environment]::SetEnvironmentVariable('MSYS_PATH_TYPE', 'inherit', 'User')

$pathsForTargets = @{
  [EnvironmentVariableTarget]::Machine = @(
    'C:\msys64\usr\bin'
    'C:\Program Files (x86)\nvim\bin'
  )
  [EnvironmentVariableTarget]::User    = @(
    "$Env:USERPROFILE\.local\bin"
  )
}

foreach ($environmentVariableTarget in $pathsForTargets.Keys)
{
  foreach ($pathForTarget in $pathsForTargets[$environmentVariableTarget])
  {
    $Path = [Environment]::GetEnvironmentVariable('Path', $environmentVariableTarget)
    if (($Path -split [IO.Path]::PathSeparator) -notcontains $pathForTarget)
    {
      [Environment]::SetEnvironmentVariable('Path', $Path + [IO.Path]::PathSeparator + $pathForTarget, $environmentVariableTarget)
    }
  }
}

$paths = @(
  [System.Environment]::GetEnvironmentVariable("Path", "Machine")
  [System.Environment]::GetEnvironmentVariable("Path", "User")
  "$Env:USERPROFILE\.cargo\bin"
  "$PNPM_HOME"
  "$Env:APPDATA\Python\Python312\Scripts"
)

$Env:PATH = $paths -join [IO.Path]::PathSeparator

$pacmanPackages = @(
  'fish'
  'nnn'
  'parallel'
  'vifm'
  'zsh'
)

foreach ($pacmanPackage in $pacmanPackages)
{
  if (!(Get-Command $pacmanPackage))
  {
    sh --login -c "pacman -Suy --noconfirm; pacman -Suy --noconfirm; pacman -S --needed --noconfirm $pacmanPackages"
    break
  }
}

corepack enable

$ejsonPublicKey = "5df4cad7a4c3a2937a863ecf18c56c23274cb048624bc9581ecaac56f2813107"
$ejsonKeyPath = "$Env:USERPROFILE\.config\ejson\keys\$ejsonPublicKey"
$sshKeyPath = "$Env:USERPROFILE\.ssh\id_ed25519"

if (!(Test-Path $ejsonKeyPath) -or !(Test-Path $sshKeyPath))
{
  Read-Host "Connect with 1Password CLI"
}

if (!(Test-Path $ejsonKeyPath))
{
  mkdir -p "$Env:USERPROFILE\.local\bin"
  sh -c "curl -Ls https://github.com/Shopify/ejson/releases/download/v1.4.1/ejson_1.4.1_windows_$($Env:PROCESSOR_ARCHITECTURE.ToLower()).tar.gz | tar xz --directory ~/.local/bin ejson.exe"
  mkdir -p "$Env:USERPROFILE\.config\ejson\keys"
  op read op://Personal/ejson/$ejsonPublicKey --out-file $ejsonKeyPath
}

if (!(Test-Path $sshKeyPath))
{
  mkdir "$Env:USERPROFILE\.ssh"
  op read 'op://Personal/Ed25519 SSH Key/id_ed25519' --out-file $sshKeyPath
  ((Get-Content $sshKeyPath) -join "`n") + "`n" | Set-Content -NoNewline $sshKeyPath
  Get-Service ssh-agent | Set-Service -StartupType Automatic
  Start-Service ssh-agent
  ssh-add $sshKeyPath
}

Invoke-RestMethod 'https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.ps1' | Invoke-Expression

$cargoPackages = @(
  'vivid'
)

cargo binstall --locked --no-confirm $cargoPackages

rustup target add x86_64-pc-windows-msvc
cargo install --locked --target x86_64-pc-windows-msvc atuin

Set-Item 'Env:EJSON_KEYDIR' "$Env:USERPROFILE\.config\ejson\keys"

if ($Env:CHEZMOI -ne '1')
{
  chezmoi init --ssh thebengeu
  chezmoi apply --keep-going --exclude scripts
  chezmoi apply --keep-going --include scripts
}

$installSshdPath = "$Env:ProgramFiles\OpenSSH\install-sshd.ps1"

if (!(Test-Path $installSshdPath))
{
  Invoke-WebRequest https://raw.githubusercontent.com/PowerShell/openssh-portable/latestw_all/contrib/win32/openssh/install-sshd.ps1 -OutFile $installSshdPath
  & $installSshdPath

  New-ItemProperty HKLM:\SOFTWARE\OpenSSH DefaultShell -Force -PropertyType String -Value "C:\msys64\usr\bin\fish.exe"

  $authorizedKeysPath = "$Env:ProgramData\ssh\administrators_authorized_keys"
  Copy-Item $Env:USERPROFILE\.ssh\authorized_keys $authorizedKeysPath
  icacls $authorizedKeysPath /inheritance:r /grant Administrators:F /grant SYSTEM:F

  Start-Service sshd
  Set-Service sshd -StartupType 'Automatic'
}
