Remove-Item $env:OneDrive\Desktop\*.lnk
Remove-Item $env:PUBLIC\Desktop\*.lnk

$startMenuPrograms = 'Microsoft\Windows\Start Menu\Programs'

$startMenuShortcutArguments = @{
  "$Env:APPDATA\$startMenuPrograms\Chromium.lnk"    = '--proxy-server=zproxy.lum-superproxy.io:22225'
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
  "Chromium" = '--proxy-server=zproxy.lum-superproxy.io:22225'
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
