if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))
{
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`""
  Start-Process -Wait -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
}

$localAppDataNvimPath = "$Env:LOCALAPPDATA\nvim"

if (!(Test-Path $localAppDataNvimPath))
{
  New-Item $localAppDataNvimPath -ItemType Junction -Target "$Env:USERPROFILE\.config\nvim"
}

$fontFolder = "$Env:USERPROFILE\.local\share\chezmoi\private_dot_local\private_share\fonts"
$shellFolder = (New-Object -COMObject Shell.Application).Namespace($fontFolder)

foreach ($fontFile in Get-ChildItem $fontFolder)
{
  $registryKeyName = $shellFolder.GetDetailsOf($shellFolder.ParseName($fontFile.Name), 21 <# Title #>) + ' (TrueType)'
  New-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' $registryKeyName -Force -PropertyType string -Value $fontFile.Name > $null
  Copy-Item $fontFile.FullName $env:windir\Fonts
}
