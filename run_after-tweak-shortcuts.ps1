Remove-Item $env:OneDrive\Desktop\*.lnk
Remove-Item $env:PUBLIC\Desktop\*.lnk

$startMenuPrograms = 'Microsoft\Windows\Start Menu\Programs'

$shortcutArguments = @{
  "$Env:APPDATA\$startMenuPrograms\Chromium.lnk"    = '--proxy-server=zproxy.lum-superproxy.io:22225'
}

foreach ($shortcutPath in $shortcutArguments.Keys)
{
  $shortcut = (New-Object -ComObject WScript.Shell).CreateShortCut($shortcutPath)
  $shortcut.Arguments = $shortcutArguments[$shortcutPath]
  $shortcut.Save()
}

$shortcut = (New-Object -ComObject WScript.Shell).CreateShortCut("$Env:APPDATA\$startMenuPrograms\Startup\dual-key-remap.lnk")
$shortcut.TargetPath = "$Env:USERPROFILE\.local\bin\dual-key-remap.exe"
$shortcut.Save()
