if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))
{
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000)
  {
    $CommandLine = "-NoExit -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -Wait -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
  }
}

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
  '7zip.7zip'
  'Twilio.Authy'
  'Armin2208.WindowsAutoNightMode'
  'Amazon.AWSCLI'
  'rsteube.Carapace'
  'twpayne.chezmoi'
  'Hibbiki.Chromium'
  'Kitware.CMake'
  'dandavison.delta'
  'Discord.Discord'
  'ExpressVPN.ExpressVPN'
  'flux.flux'
  'Mozilla.Firefox'
  'Flow-Launcher.Flow-Launcher'
  'junegunn.fz'
  'Git.Git'
  'GoLang.Go'
  'gerardog.gsudo'
  'DEVCOM.Lua'
  'jftuga.less'
  'ManicTime.ManicTime'
  'MSYS2.MSYS2'
  'Notion.Notion'
  'Nushell.Nushell'
  'Obsidian.Obsidian'
  'Microsoft.OpenSSH.Beta'
  'Microsoft.PowerShell'
  'Microsoft.PowerToys'
  'Microsoft.Sysinternals.ProcessMonitor'
  'Neovide.Neovide'
  'OpenJS.NodeJS'
  'PostgreSQL.PostgreSQL'
  'Pulumi.Pulumi'
  'QMK.QMKToolbox'
  'BurntSushi.ripgrep.MSVC'
  'Rustlang.Rustup'
  'SlackTechnologies.Slack'
  'StartIsBack.StartAllBack'
  'Microsoft.VisualStudioCode'
  'JetBrains.WebStorm'
  'wez.wezterm'
  'JernejSimoncic.Wget'
  'Microsoft.WingetCreate'
  'Highresolution.X-MouseButtonControl'
  'th-ch.YouTubeMusic'
  'Zoom.Zoom'
)

if (!$isMobile)
{
  $wingetPackageIds += @(
    'Asus.ArmouryCrate'
    'BinaryFortress.DisplayFusion'
    'PlayStation.DualSenseFWUpdater'
    'Nvidia.GeForceExperience'
    'Valve.Steam'
    'xanderfrangos.twinkletray'
  )
}

foreach ($wingetPackageId in $wingetPackageIds)
{
  $wingetPackageId
  winget install --exact --no-upgrade --silent --id $wingetPackageId
}

winget install --exact --id --no-upgrade --override '--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --quiet --wait' --silent Microsoft.VisualStudio.2022.BuildTools

winget pin add --exact --id JetBrains.WebStorm

if (!$isMobile)
{
  winget pin add --exact --id Asus.ArmouryCrate
}

$storeApps = @(
  'Apple Music Preview'
  '9PL8WPH0QK9M' # Cider (Preview)
  'iCloud'
  '9NRX63209R7B' # Outlook for Windows
  'Python 3.11'
  'Raindrop.io'
  'Unigram—Telegram for Windows'
  'WhatsApp'
  'Windows Terminal Preview'
)

if ($isMobile)
{
  $storeApps += @(
    'Pure Battery Analytics'
  )
} else
{
  $storeApps += @(
    'Dolby Access'
    'DTS Sound Unbound'
  )
}

foreach ($storeApps in $storeApps)
{
  winget install --accept-package-agreements --source msstore $storeApps
}

Set-ExecutionPolicy Unrestricted
Invoke-RestMethod community.chocolatey.org/install.ps1 | Invoke-Expression

Install-PackageProvider NuGet -Force
Set-PSRepository PSGallery -InstallationPolicy Trusted

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
C:\msys64\usr\bin\sh --login -c 'pacman -S --needed --noconfirm fish tmux'

$Env:PATH = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + [IO.Path]::PathSeparator + [System.Environment]::GetEnvironmentVariable("Path", "User")

corepack enable

choco feature enable -n allowGlobalConfirmation

$chocoPackages = @(
  'Kindle'
  'ledger-live'
  'SQLite'
  'tableplus'
)

foreach ($chocoPackage in $chocoPackages)
{
  choco install $chocoPackage
}

pip install --user pipx

Remove-Item $env:OneDrive\Desktop\*.lnk
Remove-Item $env:PUBLIC\Desktop\*.lnk

$ejsonPublicKey = "5df4cad7a4c3a2937a863ecf18c56c23274cb048624bc9581ecaac56f2813107"
op read op://Personal/ejson/$ejsonPublicKey --out-file $HOME\.config\ejson\keys\$ejsonPublicKey

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

git clone git@github.com:thebengeu/powershell.git "$Env:USERPROFILE\powershell"

$fontFolder = "$Env:USERPROFILE\.local\share\chezmoi\private_dot_local\private_share\fonts"
$shellFolder = (New-Object -COMObject Shell.Application).Namespace($fontFolder)

foreach ($fontFile in Get-ChildItem $fontFolder)
{
  $registryKeyName = $shellFolder.GetDetailsOf($shellFolder.ParseName($fontFile.Name), 21 <# Title #>) + ' (TrueType)'
  New-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' $registryKeyName -Force -PropertyType string -Value $fontFile.Name > $null
  Copy-Item $fontFile.FullName $env:windir\Fonts
}

New-Item -ItemType SymbolicLink -Path "$Env:USERPROFILE\.config\chezmoi\chezmoi.toml" -Target "$Env:USERPROFILE\.local\share\chezmoi\chezmoi.toml"

$manifestPaths = @(
  'a\AudioBand\AudioBand\1.2.1'
  'r\Rabby\RabbyDesktop\0.31.0'
  't\Todoist\Todoist\8.5.0'
)

if (!$isMobile)
{
  $manifestPaths += @(
    'f\Finkitd\o\o\ManicTimeServer\23.2.4.1'
  )
}

foreach ($manifestPath in $manifestPaths)
{
  winget install --manifest "$Env:USERPROFILE\powershell\manifests\$manifestPath" --silent
}

if (!$isMobile)
{
  Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
  Start-Service sshd
  Set-Service sshd -StartupType 'Automatic'
  New-ItemProperty HKLM:\SOFTWARE\OpenSSH DefaultShell -Force -PropertyType String -Value "$Env:ProgramFiles\nu\bin\nu.exe"

  $authorizedKeysPath = "$Env:ProgramData\ssh\administrators_authorized_keys"
  Copy-Item $Env:USERPROFILE\.ssh\id_ed25519.pub $authorizedKeysPath
  icacls $authorizedKeysPath /inheritance:r /grant Administrators:F /grant SYSTEM:F
}
