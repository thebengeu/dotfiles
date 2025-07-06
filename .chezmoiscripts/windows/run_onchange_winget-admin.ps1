if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  if (Get-Command sudo)
  {
    sudo pwsh "$($MyInvocation.MyCommand.Path)"
  } else
  {
    $CommandLine = "-NoExit -NoProfile -File `"" + $MyInvocation.MyCommand.Path + "`""
    Start-Process -Wait -FilePath powershell -Verb Runas -ArgumentList $CommandLine
  }
  Exit
}

$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

$wingetPackageIds = @(
  'Clement.bottom'
  'Google.Chrome'
  'Microsoft.Edge.Beta'
  'Microsoft.Edge.Dev'
  'EpicGames.EpicGamesLauncher'
  'ExpressVPN.ExpressVPN'
  'Mozilla.Firefox'
  'k6.k6'
  'LLVM.LLVM'
  'ManicTime.ManicTime'
  'Microsoft.Office'
  'o2sh.onefetch'
  'QMK.QMKToolbox'
  'Amazon.SessionManagerPlugin'
  'Transmission.Transmission'
  'VideoLAN.VLC'
  'equalsraf.win32yank'
  'Highresolution.X-MouseButtonControl'
  'OlegShparber.Zeal'
  'Zoom.Zoom'
)

if (!$isMobile)
{
  $wingetPackageIds += @(
    'BinaryFortress.DisplayFusion'
    'Kensington.KensingtonWorks'
    'Logitech.OptionsPlus'
    'EclipseFoundation.Mosquitto'
    'VirtualDesktop.Streamer'
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
