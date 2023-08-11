$shortcutArguments = @{
  "Chromium" = '--proxy-server=zproxy.lum-superproxy.io:22225'
  "Neovide"  = '--multigrid'
}

foreach ($appName in $shortcutArguments.Keys)
{
  $shortcut = (New-Object -ComObject WScript.Shell).CreateShortCut("$Env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\$appName.lnk")
  $shortcut.Arguments = $shortcutArguments[$appName]
  $shortcut.Save()
}
