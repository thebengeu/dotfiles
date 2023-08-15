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
  'GoLang.Go'
  'jftuga.less'
  'ManicTime.ManicTime'
  'MSYS2.MSYS2'
  'Notion.Notion'
  'Obsidian.Obsidian'
  'Microsoft.PowerShell'
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

SetEnvironmentVariable 'GIT_SSH' (Get-Command ssh).Source 'Machine'
SetEnvironmentVariable 'HOME' $Env:USERPROFILE 'User'
SetEnvironmentVariable 'MSYS2_PATH_TYPE' 'inherit' 'Machine'
SetEnvironmentVariable 'NODE_NO_WARNINGS' 1 'Machine'
SetEnvironmentVariable 'PNPM_HOME' $PNPM_HOME 'User'

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

git clone https://github.com/tmux-plugins/tpm "$Env:USERPROFILE\.tmux\plugins\tpm"
C:\msys64\usr\bin\bash --login ~/.tmux/plugins/tpm/bin/install_plugins

pnpm add --global npm-check-updates pino-pretty pm2 https://github.com/thebengeu/ts-node.git

pip install pipx

pipx install neovim-remote

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

go install github.com/nao1215/gup@latest

Remove-Item $env:OneDrive\Desktop\*.lnk
Remove-Item $env:PUBLIC\Desktop\*.lnk

$sshKeyPath = "$Env:USERPROFILE\.ssh\id_ed25519"

if (!(Test-Path $sshKeyPath))
{
  mkdir "$Env:USERPROFILE\.ssh"
  op read 'op://Personal/Ed25519 SSH Key/id_ed25519' > $sshKeyPath
  Get-Service ssh-agent | Set-Service -StartupType Automatic
  Start-Service ssh-agent
  ssh-add $sshKeyPath
}

chezmoi init --ssh thebengeu
chezmoi apply $(chezmoi managed --include files --path-style absolute | Select-String -NotMatch '.aws/credentials|.config/ghorg/conf.yaml')

C:\msys64\usr\bin\fish -c 'curl -Ls https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update'

$localAppDataNvimPath = "$Env:LOCALAPPDATA\nvim"

if (!(Test-Path $localAppDataNvimPath))
{
  New-Item $localAppDataNvimPath -ItemType Junction -Target "$Env:USERPROFILE\.config\nvim"
}

git clone git@github.com:thebengeu/powershell.git "$Env:USERPROFILE\powershell"

gup import

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

foreach ($manifestPath in $manifestPaths)
{
  winget install --manifest "$Env:USERPROFILE\powershell\manifests\$manifestPath" --silent
}
