Remove-Item $env:OneDrive\Desktop\*.lnk
Remove-Item $env:PUBLIC\Desktop\*.lnk

$idProxyServerArgument = '--proxy-server=id.he.sg:8888'
$inProxyServerArgument = '--proxy-server=in.he.sg:8888'
$startMenuPrograms = 'Microsoft\Windows\Start Menu\Programs'

$startMenuShortcutArguments = @{
  "$Env:APPDATA\$startMenuPrograms\Scoop Apps\Chromium.lnk"    = $inProxyServerArgument
  "$Env:APPDATA\$startMenuPrograms\Scoop Apps\Chromium (Dev).lnk"    = $idProxyServerArgument
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
  "Chromium" = $inProxyServerArgument
  "Chromium (Dev)" = $idProxyServerArgument
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
