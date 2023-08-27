if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))
{
  $CommandLine = "-NoExit -File `"" + $MyInvocation.MyCommand.Path + "`""
  Start-Process -Wait -FilePath pwsh -Verb Runas -ArgumentList $CommandLine
  Exit
}

$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

$wingetPackageIds = @(
  '7zip.7zip'
  'Twilio.Authy'
  'Armin2208.WindowsAutoNightMode'
  'Amazon.AWSCLI'
  'rsteube.Carapace'
  'Hibbiki.Chromium'
  'dandavison.delta'
  'Discord.Discord'
  'ExpressVPN.ExpressVPN'
  'flux.flux'
  'Mozilla.Firefox'
  'Flow-Launcher.Flow-Launcher'
  'junegunn.fzf'
  'gerardog.gsudo'
  'DEVCOM.Lua'
  'jftuga.less'
  'ManicTime.ManicTime'
  'Notion.Notion'
  'Nushell.Nushell'
  'Obsidian.Obsidian'
  'Microsoft.OpenSSH.Beta'
  'Microsoft.PowerToys'
  'Microsoft.Sysinternals.ProcessMonitor'
  'Neovide.Neovide'
  'PostgreSQL.PostgreSQL'
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
