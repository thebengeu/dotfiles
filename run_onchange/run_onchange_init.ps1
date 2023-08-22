if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))
{
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`""
  Start-Process -Wait -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
}
