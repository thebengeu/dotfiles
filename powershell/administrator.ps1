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
  '7zip.7zip'
  'Twilio.Authy'
  'Armin2208.WindowsAutoNightMode'
  'Amazon.AWSCLI'
  'twpayne.chezmoi'
  'Hibbiki.Chromium'
  'Kitware.CMake'
  'dandavison.delta'
  'Discord.Discord'
  'ExpressVPN.ExpressVPN'
  'flux.flux'
  'Mozilla.Firefox'
  'Flow-Launcher.Flow-Launcher'
  'junegunn.fzf'
  'Git.Git'
  'jftuga.less'
  'ManicTime.ManicTime'
  'MSYS2.MSYS2'
  'Notion.Notion'
  'Obsidian.Obsidian'
  'Microsoft.Powershell'
  'Microsoft.PowerToys'
  'Microsoft.Sysinternals.ProcessMonitor'
  'Neovide.Neovide'
  'OpenJS.NodeJS'
  'PostgreSQL.PostgreSQL'
  'Pulumi.Pulumi'
  'Python.Python.3.11'
  'QMK.QMKToolbox'
  'BurntSushi.ripgrep.MSVC'
  'Rustlang.Rustup'
  'Spotify.Spotify'
  'StartIsBack.StartAllBack'
  'Microsoft.VisualStudioCode'
  'JetBrains.WebStorm'
  'wez.wezterm'
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

winget install --exact --override '--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --quiet --wait' --silent Microsoft.VisualStudio.2022.BuildTools

winget pin add --exact --id JetBrains.WebStorm

corepack enable

$storeApps = @(
  'Apple Music Preview'
  '9PL8WPH0QK9M' # Cider (Preview)
  'iCloud'
  '9NRX63209R7B' # Outlook for Windows
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
  winget install --accept-package-agreements --exact --source msstore $storeApps
}

Set-ExecutionPolicy Unrestricted
Invoke-RestMethod community.chocolatey.org/install.ps1 | Invoke-Expression

choco feature enable -n allowGlobalConfirmation

$chocoPackages = @(
  'golang'
  'Kindle'
  'ledger-live'
  'spotify'
  'SQLite'
  'tableplus'
)

foreach ($chocoPackage in $chocoPackages)
{
  choco install $chocoPackage
}

Install-PackageProvider NuGet -Force
Set-PSRepository PSGallery -InstallationPolicy Trusted

Install-Module PSFzf
Install-Module PSWindowsUpdate

$startMenuPrograms = 'Microsoft\Windows\Start Menu\Programs'

$shortcutArguments = @{
  "$Env:APPDATA\$startMenuPrograms\Chromium.lnk"    = '--proxy-server=zproxy.lum-superproxy.io:22225'
  "$Env:ProgramData\$startMenuPrograms\Neovide.lnk" = '--multigrid'
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

[Environment]::SetEnvironmentVariable('HOME', $Env:USERPROFILE, 'User')
[Environment]::SetEnvironmentVariable('NODE_NO_WARNINGS', 1, 'Machine')
[Environment]::SetEnvironmentVariable('PNPM_HOME', $PNPM_HOME, 'User')

$pathsForTargets = @{
  [EnvironmentVariableTarget]::Machine = @(
    "$Env:ProgramFiles\PostgreSQL\15\bin"
  )
  [EnvironmentVariableTarget]::User    = @(
    "$Env:USERPROFILE\.cargo\bin"
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

$Env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + [IO.Path]::PathSeparator + [System.Environment]::GetEnvironmentVariable("PATH", "User")
