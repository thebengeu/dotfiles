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

$wingetPackageIds = @(
  '7zip.7zip'
  'Twilio.Authy'
  'Armin2208.WindowsAutoNightMode'
  'Amazon.AWSCLI'
  'AutoHotkey.AutoHotkey'
  'rsteube.Carapace'
  'Google.Chrome'
  'Hibbiki.Chromium'
  'dandavison.delta'
  'direnv.direnv'
  'Discord.Discord'
  'Element.Element'
  'ExpressVPN.ExpressVPN'
  'flux.flux'
  'Mozilla.Firefox'
  'Flow-Launcher.Flow-Launcher'
  'junegunn.fzf'
  'GitHub.cli'
  'Helix.Helix'
  'jqlang.jq'
  'DEVCOM.Lua'
  'jftuga.less'
  'gokcehan.lf'
  'ManicTime.ManicTime'
  'zyedidia.micro'
  'Notion.Notion'
  'Nushell.Nushell'
  'Obsidian.Obsidian'
  'Microsoft.OpenSSH.Beta'
  'Microsoft.PowerToys'
  'Microsoft.Sysinternals.ProcessMonitor'
  'Pulumi.Pulumi'
  'QMK.QMKToolbox'
  'BurntSushi.ripgrep.MSVC'
  'SlackTechnologies.Slack'
  'Ookla.Speedtest.CLI'
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
    'BinaryFortress.DisplayFusion'
    'Kensington.KensingtonWorks'
    'PlayStation.DualSenseFWUpdater'
    'Nvidia.GeForceExperience'
    'EclipseFoundation.Mosquitto'
    'Valve.Steam'
    'xanderfrangos.twinkletray'
  )
}

winget install --exact --no-upgrade --silent --id $wingetPackageIds

$override = '--add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended --quiet --wait'
winget install --exact --no-upgrade --override $override --silent --id Microsoft.VisualStudio.2022.Community

winget pin add --exact --id JetBrains.WebStorm
winget pin add --exact --id PostgreSQL.PostgreSQL
