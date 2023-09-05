if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))
{
  $CommandLine = "-NoExit -NoProfile -File `"" + $MyInvocation.MyCommand.Path + "`""
  Start-Process -Wait -FilePath powershell -Verb Runas -ArgumentList $CommandLine
  Exit
}

$chocoPackages = @(
  'hledger'
  'Kindle'
  'ledger'
  'ledger-live'
  'nirlauncher'
  'SQLite'
  'tableplus'
)

foreach ($chocoPackage in $chocoPackages)
{
  choco install $chocoPackage
}

choco install --ignore-dependencies neovide.install
choco install --params '/Password:postgres /Port:5433' --params-global postgresql
