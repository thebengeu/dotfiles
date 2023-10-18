Remove-Item $Env:OneDrive\Desktop\*.lnk
Remove-Item $Env:PUBLIC\Desktop\*.lnk

$startMenuPrograms = 'Microsoft\Windows\Start Menu\Programs'

$shortcut = (New-Object -ComObject WScript.Shell).CreateShortCut("$Env:APPDATA\$startMenuPrograms\Startup\dual-key-remap.lnk")
$shortcut.TargetPath = "$Env:USERPROFILE\.local\bin\dual-key-remap.exe"
$shortcut.Save()
