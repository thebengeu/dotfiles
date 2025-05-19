$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

$wingetPackageIds = @(
  '7zip.7zip'
  'Armin2208.WindowsAutoNightMode'
  'Amazon.AWSCLI'
  'Clement.bottom'
  'Amazon.Chime'
  'AutoHotkey.AutoHotkey'
  'schollz.croc'
  'dandavison.delta'
  'Wilfred.difftastic'
  'Discord.Discord'
  'Docker.DockerDesktop'
  'muesli.duf'
  'Element.Element'
  'flux.flux'
  'Flow-Launcher.Flow-Launcher'
  'junegunn.fzf'
  'charmbracelet.glow'
  'Helix.Helix'
  'sharkdp.hyperfine'
  'jftuga.less'
  'gokcehan.lf'
  'LinearOrbit.Linear'
  'DEVCOM.Lua'
  'zyedidia.micro'
  'CloudStack.Msty'
  'Notion.Notion'
  'Nushell.Nushell'
  'Obsidian.Obsidian'
  'o2sh.onefetch'
  'Playnite.Playnite'
  'Microsoft.PowerToys'
  'Microsoft.Sysinternals.ProcessMonitor'
  'JetBrains.PyCharm.Professional'
  'QMK.QMKToolbox'
  'BenBoyter.scc'
  'chmln.sd'
  'SideQuestVR.SideQuest'
  'SlackTechnologies.Slack'
  'Readdle.Spark'
  'Ookla.Speedtest.CLI'
  'Spotify.Spotify'
  'commercialhaskell.stack'
  'Valve.Steam'
  'XAMPPRocky.Tokei'
  'Microsoft.VisualStudioCode'
  'JernejSimoncic.Wget'
  'Microsoft.WingetCreate'
  'Highresolution.X-MouseButtonControl'
  'ducaale.xh'
  'sxyazi.yazi'
  'th-ch.YouTubeMusic'
)

if (!$isMobile)
{
  $wingetPackageIds += @(
    'xanderfrangos.twinkletray'
  )
}

foreach ($wingetPackageId in $wingetPackageIds)
{
  $wingetPackageId
  winget install --exact --no-upgrade --silent $wingetPackageId
}

$ignoreSecurityHashWingetPackageIds = @(
  'Microsoft.Office'
)

if (!$isMobile)
{
  $ignoreSecurityHashWingetPackageIds += @(
    'VirtualDesktop.Streamer'
  )
}

winget install --exact --ignore-security-hash --no-upgrade --silent $ignoreSecurityHashWingetPackageIds
