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

$manifestPaths = @{
  'a\AudioBand\AudioBand' = @{
    id = '466BAF12-E5C7-4FAC-A837-5195A0697AC6'
    version = '1.2.3'
  }
  'r\Rabby\RabbyDesktop' = @{
    id = '2cd4acdc-36c3-5e85-b6bd-84403600b4d8'
    version = '0.35.3'
  }
}

if (!$isMobile)
{
  $manifestPaths['f\Finkitd\o\o\ManicTimeServer']= @{
    id = '110013C5-52EF-40E2-9A0E-279B85062D15'
    version = '23.3.4.0'
  }
}

if (Get-Module -ListAvailable Microsoft.WinGet.Client)
{
  Import-Module Microsoft.WinGet.Client
}

foreach ($manifestPath in $manifestPaths.Keys)
{
  $idAndVersion = $manifestPaths[$manifestPath]
  $manifestVersion = $idAndVersion.version
  $installedVersion = $null

  if (Get-Command -ErrorAction SilentlyContinue Get-WinGetPackage)
  {
    $installedVersion = (Get-WinGetPackage -Id $idAndVersion.id).InstalledVersion
  }

  if ($null -eq $installedVersion)
  {
    winget install --manifest "$Env:USERPROFILE\.local\share\chezmoi\ignored\manifests\$manifestPath\$manifestVersion" --silent
  } elseif ([System.Version]$installedVersion -gt [System.Version]$manifestVersion)
  {
    throw "${manifestPath} installed version ${installedVersion} > $($manifestVersion)"
  } else
  {
    "${manifestPath} installed version ${installedVersion} = $($manifestVersion)"
  }
}
