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

~/scoop/apps/krew/current/krew install krew

kubectl krew index add kvaps https://github.com/kvaps/krew-index

$krewPlugins = @(
  'explore'
  'fuzzy'
  'ice'
  'kvaps/node-shell'
  'lineage'
  'tail'
)

kubectl krew install $krewPlugins
