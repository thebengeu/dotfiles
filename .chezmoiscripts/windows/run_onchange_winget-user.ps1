$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

$wingetPackageIds = @(
  '7zip.7zip'
  'AutoHotkey.AutoHotkey'
  'Armin2208.WindowsAutoNightMode'
  'Amazon.AWSCLI'
  'Clement.bottom'
  'Amazon.Chime'
  'schollz.croc'
  'Anysphere.Cursor'
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
  'Playnite.Playnite'
  'Microsoft.PowerToys'
  'Microsoft.Sysinternals.ProcessMonitor'
  'JetBrains.PyCharm.Professional'
  'BenBoyter.scc'
  'chmln.sd'
  'Amazon.SessionManagerPlugin'
  'SideQuestVR.SideQuest'
  'SlackTechnologies.Slack'
  'Spicetify.Spicetify'
  'Readdle.Spark'
  'Ookla.Speedtest.CLI'
  'Spotify.Spotify'
  'commercialhaskell.stack'
  'Valve.Steam'
  'XAMPPRocky.Tokei'
  'Microsoft.VisualStudioCode'
  'JernejSimoncic.Wget'
  'Microsoft.WingetCreate'
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
