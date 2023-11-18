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
  'Google.Chrome'
  'dandavison.delta'
  'Discord.Discord'
  'Element.Element'
  'ExpressVPN.ExpressVPN'
  'flux.flux'
  'Mozilla.Firefox'
  'Flow-Launcher.Flow-Launcher'
  'junegunn.fzf'
  'GitHub.cli'
  'Helix.Helix'
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
  'Microsoft.Edge.Beta'
  'Microsoft.Edge.Dev'
  'Microsoft.PowerToys'
  'Microsoft.Sysinternals.ProcessMonitor'
  'QMK.QMKToolbox'
  'BurntSushi.ripgrep.MSVC'
  'SlackTechnologies.Slack'
  'Readdle.Spark'
  'Ookla.Speedtest.CLI'
  'StartIsBack.StartAllBack'
  'Microsoft.VisualStudioCode'
  'JetBrains.WebStorm'
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

winget pin add --exact --id JetBrains.WebStorm
winget pin add --exact --id PostgreSQL.PostgreSQL

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
