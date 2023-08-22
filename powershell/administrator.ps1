function Set-Registry-Values($path, $values)
{
  foreach ($name in $values.Keys)
  {
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
  'AgileBits.1Password.CLI'
  'twpayne.chezmoi'
  'Microsoft.PowerShell'
)

foreach ($wingetPackageId in $wingetPackageIds)
{
  $wingetPackageId
  winget install --exact --no-upgrade --silent --id $wingetPackageId
}

winget install --exact --id --no-upgrade --override '--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --quiet --wait' --silent Microsoft.VisualStudio.2022.BuildTools

winget pin add --exact --id JetBrains.WebStorm

Set-ExecutionPolicy Unrestricted
Invoke-RestMethod community.chocolatey.org/install.ps1 | Invoke-Expression

Install-PackageProvider NuGet -Force
Set-PSRepository PSGallery -InstallationPolicy Trusted

Install-Module Microsoft.WinGet.Client
Install-Module PSFzf
Install-Module PSWindowsUpdate

$startMenuPrograms = 'Microsoft\Windows\Start Menu\Programs'

$shortcutArguments = @{
  "$Env:APPDATA\$startMenuPrograms\Chromium.lnk"    = '--proxy-server=zproxy.lum-superproxy.io:22225'
}

foreach ($shortcutPath in $shortcutArguments.Keys)
{
  $shortcut = (New-Object -ComObject WScript.Shell).CreateShortCut($shortcutPath)
  $shortcut.Arguments = $shortcutArguments[$shortcutPath]
  $shortcut.Save()
}

Set-ItemProperty 'HKCU:\Control Panel\Mouse' 'MouseSensitivity' 20
Set-ItemProperty 'HKCU:\Software\Microsoft\Accessibility' 'CursorSize' 2

if ($isMobile)
{
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

SetEnvironmentVariable 'EJSON_KEYDIR' "$Env:USERPROFILE/.config/ejson/keys" 'User'
SetEnvironmentVariable 'GIT_SSH' (Get-Command ssh).Source 'Machine'
SetEnvironmentVariable 'HOME' $Env:USERPROFILE 'User'
SetEnvironmentVariable 'MSYS2_PATH_TYPE' 'inherit' 'Machine'
SetEnvironmentVariable 'NODE_NO_WARNINGS' 1 'Machine'
SetEnvironmentVariable 'PNPM_HOME' $PNPM_HOME 'User'

$pathsForTargets = @{
  [EnvironmentVariableTarget]::Machine = @(
    "$Env:ProgramFiles\Git\bin"
    "$Env:ProgramFiles\PostgreSQL\15\bin"
  )
  [EnvironmentVariableTarget]::User    = @(
    "$Env:APPDATA\Python\Python311\Scripts"
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

C:\msys64\usr\bin\sh --login -c 'pacman -Suy --noconfirm'
C:\msys64\usr\bin\sh --login -c 'pacman -Suy --noconfirm'
C:\msys64\usr\bin\sh --login -c 'pacman -S --needed --noconfirm fish tmux zsh'

$Env:PATH = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + [IO.Path]::PathSeparator + [System.Environment]::GetEnvironmentVariable("Path", "User")

corepack enable

choco feature enable -n allowGlobalConfirmation

pip install --user pipx

sh -c 'curl -Ls https://github.com/Shopify/ejson/releases/download/v1.4.1/ejson_1.4.1_windows_amd64.tar.gz | tar xz --directory ~/.local/bin ejson.exe'
$ejsonPublicKey = "5df4cad7a4c3a2937a863ecf18c56c23274cb048624bc9581ecaac56f2813107"
mkdir -p $HOME/.config/ejson/keys
op read op://Personal/ejson/$ejsonPublicKey --out-file $HOME/.config/ejson/keys/$ejsonPublicKey

$sshKeyPath = "$Env:USERPROFILE\.ssh\id_ed25519"

if (!(Test-Path $sshKeyPath))
{
  mkdir "$Env:USERPROFILE\.ssh"
  op read 'op://Personal/Ed25519 SSH Key/id_ed25519' > $sshKeyPath
  Get-Service ssh-agent | Set-Service -StartupType Automatic
  Start-Service ssh-agent
  ssh-add $sshKeyPath
}

chezmoi init --apply --ssh thebengeu

$localAppDataNvimPath = "$Env:LOCALAPPDATA\nvim"

if (!(Test-Path $localAppDataNvimPath))
{
  New-Item $localAppDataNvimPath -ItemType Junction -Target "$Env:USERPROFILE\.config\nvim"
}

$fontFolder = "$Env:USERPROFILE\.local\share\chezmoi\private_dot_local\private_share\fonts"
$shellFolder = (New-Object -COMObject Shell.Application).Namespace($fontFolder)

foreach ($fontFile in Get-ChildItem $fontFolder)
{
  $registryKeyName = $shellFolder.GetDetailsOf($shellFolder.ParseName($fontFile.Name), 21 <# Title #>) + ' (TrueType)'
  New-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' $registryKeyName -Force -PropertyType string -Value $fontFile.Name > $null
  Copy-Item $fontFile.FullName $env:windir\Fonts
}

if (!$isMobile)
{
  Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
  Start-Service sshd
  Set-Service sshd -StartupType 'Automatic'
  New-ItemProperty HKLM:\SOFTWARE\OpenSSH DefaultShell -Force -PropertyType String -Value "C:\msys64\usr\bin\zsh"

  $authorizedKeysPath = "$Env:ProgramData\ssh\administrators_authorized_keys"
  Copy-Item $Env:USERPROFILE\.ssh\id_ed25519.pub $authorizedKeysPath
  icacls $authorizedKeysPath /inheritance:r /grant Administrators:F /grant SYSTEM:F
}
