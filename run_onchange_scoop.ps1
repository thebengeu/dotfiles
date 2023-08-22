$scoopPackages = @(
  'gcc'
  'git-filter-repo'
  'goneovim'
  'nerd-fonts/JetBrainsMono-NF'
  'nmap'
  'python'
  'sed'
)

foreach ($scoopPackage in $scoopPackages)
{
  scoop install $scoopPackage
}
