$scoopPackages = @(
  'gcc'
  'git-filter-repo'
  'goneovim'
  'nerd-fonts/JetBrainsMono-NF'
  'nmap'
  'python'
  'sed'
  'wezterm-nightly'
)

foreach ($scoopPackage in $scoopPackages)
{
  scoop install $scoopPackage
}

scoop install --skip neovim-nightly
