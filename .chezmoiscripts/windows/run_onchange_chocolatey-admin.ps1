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

$chocoPackages = @(
  'amazon-chime'
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
choco install --ignore-dependencies neovide.install
choco install --params '/Password:postgres /Port:5433' --params-global postgresql
