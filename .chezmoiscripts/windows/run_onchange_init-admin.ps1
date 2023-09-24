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
  'twpayne.chezmoi'
  'Kitware.CMake'
  'Git.Git'
  'GoLang.Go'
  'gerardog.gsudo'
  'MSYS2.MSYS2'
  'OpenJS.NodeJS'
  'Microsoft.PowerShell'
  'Rustlang.Rustup'
)

Winget install --exact --no-upgrade --silent --id $wingetPackageIds

$buildToolsOverride = '--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --quiet --wait'

if ($Env:PROCESSOR_ARCHITECTURE -eq 'ARM64')
{
  $buildToolsOverride += ' --add Microsoft.VisualStudio.Component.VC.Tools.ARM64'
}

winget install --exact --no-upgrade --override $buildToolsOverride --silent --id Microsoft.VisualStudio.2022.BuildTools

if (!(Get-Command choco))
{
  Set-ExecutionPolicy Unrestricted
  Invoke-RestMethod community.chocolatey.org/install.ps1 | Invoke-Expression
  choco feature enable -n allowGlobalConfirmation
}

Install-PackageProvider NuGet -Force
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

$PNPM_HOME = "$env:LOCALAPPDATA\pnpm"

function SetEnvironmentVariable($variable, $value, $target)
{
  [Environment]::SetEnvironmentVariable($variable, $value, $target)
  Set-Item "Env:$variable" $value
}

SetEnvironmentVariable 'EJSON_KEYDIR' "$Env:USERPROFILE\.config\ejson\keys" 'User'
SetEnvironmentVariable 'GIT_SSH' (Get-Command ssh).Source 'Machine'
SetEnvironmentVariable 'GH_USERNAME' "thebengeu" 'User'
SetEnvironmentVariable 'HOME' $Env:USERPROFILE 'User'
SetEnvironmentVariable 'MSYS2_PATH_TYPE' 'inherit' 'Machine'
SetEnvironmentVariable 'NODE_NO_WARNINGS' 1 'Machine'
SetEnvironmentVariable 'PNPM_HOME' $PNPM_HOME 'User'

$pathsForTargets = @{
  [EnvironmentVariableTarget]::Machine = @(
    'C:\msys64\usr\bin'
    "$Env:ProgramFiles\PostgreSQL\15\bin"
    "${Env:ProgramFiles(x86)}\nvim\bin"
  )
  [EnvironmentVariableTarget]::User    = @(
    "$Env:USERPROFILE\.cargo\bin"
    "$Env:USERPROFILE\.local\bin"
    $Env:PNPM_HOME
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

$Env:PATH = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + [IO.Path]::PathSeparator + [System.Environment]::GetEnvironmentVariable("Path", "User")

$pacmanPackages = @(
  'fish'
  'make'
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
$ejsonKeyPath = "$HOME/.config/ejson/keys/$ejsonPublicKey"
$sshKeyPath = "$Env:USERPROFILE\.ssh\id_ed25519"

if (!(Test-Path $ejsonKeyPath) -or !(Test-Path $sshKeyPath))
{
  Read-Host "Connect with 1Password CLI"
}

if (!(Test-Path $ejsonKeyPath))
{
  mkdir -p "$Env:USERPROFILE\.local\bin"
  sh -c "curl -Ls https://github.com/Shopify/ejson/releases/download/v1.4.1/ejson_1.4.1_windows_$($Env:PROCESSOR_ARCHITECTURE.ToLower()).tar.gz | tar xz --directory ~/.local/bin ejson.exe"
  mkdir -p $HOME/.config/ejson/keys
  op read op://Personal/ejson/$ejsonPublicKey --out-file $ejsonKeyPath
}

if (!(Test-Path $sshKeyPath))
{
  mkdir "$Env:USERPROFILE\.ssh"
  op read 'op://Personal/Ed25519 SSH Key/id_ed25519' --out-file $sshKeyPath
  Get-Service ssh-agent | Set-Service -StartupType Automatic
  Start-Service ssh-agent
  ssh-add $sshKeyPath
}

go install cuelang.org/go/cmd/cue@latest

$cargoPackages = @(
  'broot'
  'just'
  'starship'
  'vivid'
  'zoxide'
)

cargo install $cargoPackages

if (!(Test-Path "$Env:USERPROFILE\.local\share\chezmoi"))
{
  chezmoi init --ssh thebengeu
  chezmoi apply --init
}

if (!$isMobile)
{
  Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
  Start-Service sshd
  Set-Service sshd -StartupType 'Automatic'
  New-ItemProperty HKLM:\SOFTWARE\OpenSSH DefaultShell -Force -PropertyType String -Value "C:\msys64\usr\bin\fish.exe"

  $authorizedKeysPath = "$Env:ProgramData\ssh\administrators_authorized_keys"
  Copy-Item $Env:USERPROFILE\.ssh\authorized_keys $authorizedKeysPath
  icacls $authorizedKeysPath /inheritance:r /grant Administrators:F /grant SYSTEM:F
}
