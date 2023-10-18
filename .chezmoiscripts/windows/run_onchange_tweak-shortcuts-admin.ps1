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

$idProxyServerArgument = '--proxy-server=id.he.sg:8888'
$inProxyServerArgument = '--proxy-server=in.he.sg:8888'
$startMenuPrograms = 'Microsoft\Windows\Start Menu\Programs'

$startMenuShortcutArguments = @{
  "$Env:ProgramData\$startMenuPrograms\Microsoft Edge Beta.lnk" = $inProxyServerArgument
  "$Env:ProgramData\$startMenuPrograms\Microsoft Edge Dev.lnk" = $idProxyServerArgument
}

foreach ($shortcutPath in $startMenuShortcutArguments.Keys)
{
  $shortcut = (New-Object -ComObject WScript.Shell).CreateShortCut($shortcutPath)
  $shortcut.Arguments = $startMenuShortcutArguments[$shortcutPath]
  $shortcut.Save()
}

$shortcut = (New-Object -ComObject WScript.Shell).CreateShortCut("$Env:APPDATA\$startMenuPrograms\Startup\dual-key-remap.lnk")
$shortcut.TargetPath = "$Env:USERPROFILE\.local\bin\dual-key-remap.exe"
$shortcut.Save()

$pinnedShortcutArguments = @{
  "Microsoft Edge Beta" = $inProxyServerArgument
  "Microsoft Edge Dev" = $idProxyServerArgument
}

foreach ($appName in $pinnedShortcutArguments.Keys)
{
  $shortcutPath = "$Env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\$appName.lnk"

  if ((Test-Path $shortcutPath))
  {
    $shortcut = (New-Object -ComObject WScript.Shell).CreateShortCut($shortcutPath)
    $shortcut.Arguments = $pinnedShortcutArguments[$appName]
    $shortcut.Save()
  }
}
