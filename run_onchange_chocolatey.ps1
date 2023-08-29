if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))
{
  $CommandLine = "-NoExit -File `"" + $MyInvocation.MyCommand.Path + "`""
  Start-Process -Wait -FilePath pwsh -Verb Runas -ArgumentList $CommandLine
  Exit
}

$chocoPackages = @(
  'Kindle'
  'ledger-live'
  'neovide'
  'nirlauncher'
  'SQLite'
  'tableplus'
)

foreach ($chocoPackage in $chocoPackages)
{
  choco install $chocoPackage
}

choco install postgresql --params '/Password:postgres'
