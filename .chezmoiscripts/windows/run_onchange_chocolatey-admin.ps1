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

$chocoPackages = @(
  'geekbench'
  'hledger'
  'Kindle'
  'ledger'
  'ledger-live'
  'nirlauncher'
  'SQLite'
  'tableplus'
)

choco install $chocoPackages
choco install --install-arguments "'--installation-dir=C:\Docker'" docker-desktop
choco install --params '/Password:postgres /Port:5433' --params-global postgresql
