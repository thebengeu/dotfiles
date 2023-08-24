if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))
{
  $CommandLine = "-NoExit -File `"" + $MyInvocation.MyCommand.Path + "`""
  Start-Process -Wait -FilePath pwsh -Verb Runas -ArgumentList $CommandLine
  Exit
}

$isMobile = (Get-CimInstance -Class Win32_ComputerSystem -Property PCSystemType).PCSystemType -eq 2

$manifestPaths = @{
  'a\AudioBand\AudioBand' = @{
    id = '0BD4E347-1EE9-4F74-BB18-067B8736E44D'
    version = '1.2.1'
  }
  'r\Rabby\RabbyDesktop' = @{
    id = '2cd4acdc-36c3-5e85-b6bd-84403600b4d8'
    version = '0.31.0'
  }
  't\Todoist\Todoist' = @{
    id = 'Doist.Todoist'
    version = '8.5.0'
  }
}

if (!$isMobile)
{
  $manifestPaths['f\Finkitd\o\o\ManicTimeServer']= @{
    id = '3D16BC61-F4C6-441D-A345-3A1E0F250A6D'
    version = '23.2.4.1'
  }
}

foreach ($manifestPath in $manifestPaths.Keys)
{
  $idAndVersion = $manifestPaths[$manifestPath]
  $manifestVersion = $idAndVersion.version
  $installedVersion = (Get-WinGetPackage -Id $idAndVersion.id).InstalledVersion

  if ($null -eq $installedVersion)
  {
    winget install --manifest "$Env:USERPROFILE\powershell\manifests\$manifestPath\$manifestVersion" --silent
  } elseif ([System.Version]$installedVersion -gt [System.Version]$manifestVersion)
  {
    throw "${manifestPath} installed version ${installedVersion} > $($manifestVersion)"
  } else
  {
    "${manifestPath} installed version ${installedVersion} = $($manifestVersion)"
  }
}
