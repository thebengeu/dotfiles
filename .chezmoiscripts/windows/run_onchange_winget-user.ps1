$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

$wingetPackageIds = @(
  '7zip.7zip'
  'Armin2208.WindowsAutoNightMode'
  'Amazon.AWSCLI'
  'Clement.bottom'
  'Amazon.Chime'
  'AutoHotkey.AutoHotkey'
  'Google.Chrome'
  'schollz.croc'
  'dandavison.delta'
  'Wilfred.difftastic'
  'Discord.Discord'
  'Docker.DockerDesktop'
  'muesli.duf'
  'Element.Element'
  'flux.flux'
  'Mozilla.Firefox'
  'Flow-Launcher.Flow-Launcher'
  'junegunn.fzf'
  'charmbracelet.glow'
  'Helix.Helix'
  'sharkdp.hyperfine'
  'k6.k6'
  'jftuga.less'
  'gokcehan.lf'
  'LinearOrbit.Linear'
  'DEVCOM.Lua'
  'ManicTime.ManicTime'
  'zyedidia.micro'
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
  'Transmission.Transmission'
  'VirtualDesktop.Streamer'
  'Microsoft.VisualStudioCode'
  'VideoLAN.VLC'
  'JernejSimoncic.Wget'
  'Microsoft.WingetCreate'
  'Highresolution.X-MouseButtonControl'
  'ducaale.xh'
  'sxyazi.yazi'
  'th-ch.YouTubeMusic'
  'OlegShparber.Zeal'
  'Zoom.Zoom'
)

if (!$isMobile)
{
  $wingetPackageIds += @(
    'BinaryFortress.DisplayFusion'
    'Kensington.KensingtonWorks'
    'EclipseFoundation.Mosquitto'
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
    'Logitech.LogiTune'
    'VirtualDesktop.Streamer'
  )
}

winget install --exact --ignore-security-hash --no-upgrade --silent $ignoreSecurityHashWingetPackageIds
