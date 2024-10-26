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
  'Armin2208.WindowsAutoNightMode'
  'Amazon.AWSCLI'
  'Clement.bottom'
  'Amazon.Chime'
  'AutoHotkey.AutoHotkey'
  'Google.Chrome'
  'schollz.croc'
  'dandavison.delta'
  'Discord.Discord'
  'Docker.DockerDesktop'
  'muesli.duf'
  'Element.Element'
  'ExpressVPN.ExpressVPN'
  'flux.flux'
  'Mozilla.Firefox'
  'Flow-Launcher.Flow-Launcher'
  'junegunn.fzf'
  'charmbracelet.glow'
  'Helix.Helix'
  'sharkdp.hyperfine'
  'ProjectJupyter.JupyterLab'
  'k6.k6'
  'DEVCOM.Lua'
  'jftuga.less'
  'gokcehan.lf'
  'LLVM.LLVM'
  'ManicTime.ManicTime'
  'zyedidia.micro'
  'Notion.Notion'
  'Nushell.Nushell'
  'Obsidian.Obsidian'
  'o2sh.onefetch'
  'Playnite.Playnite'
  'Microsoft.Edge.Beta'
  'Microsoft.Edge.Dev'
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
  'commercialhaskell.stack'
  'StartIsBack.StartAllBack'
  'Valve.Steam'
  'XAMPPRocky.Tokei'
  'Transmission.Transmission'
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
    'Nvidia.GeForceExperience'
    'EclipseFoundation.Mosquitto'
    'xanderfrangos.twinkletray'
  )
}

winget install --exact --no-upgrade --silent $wingetPackageIds

$idProxyServerArgument = '--proxy-server=id.he.sg:8888'
$inProxyServerArgument = '--proxy-server=in.he.sg:8888'

$startMenuProgramsPath = "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs"
$pinnedShortcutsPath = "$Env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"

$shortcutArguments = @{
  "$startMenuProgramsPath\Microsoft Edge Beta.lnk" = $inProxyServerArgument
  "$pinnedShortcutsPath\Microsoft Edge Beta.lnk" = $inProxyServerArgument
  "$startMenuProgramsPath\Microsoft Edge Dev.lnk" = $idProxyServerArgument
  "$pinnedShortcutsPath\Microsoft Edge Dev.lnk" = $idProxyServerArgument
}

foreach ($shortcutPath in $shortcutArguments.Keys)
{
  if ((Test-Path $shortcutPath))
  {
    $shortcut = (New-Object -ComObject WScript.Shell).CreateShortCut($shortcutPath)
    $shortcut.Arguments = $shortcutArguments[$shortcutPath]
    $shortcut.Save()
  }
}
