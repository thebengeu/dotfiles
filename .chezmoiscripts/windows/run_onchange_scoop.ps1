$scoopPackages = @(
  'gcc'
  'git-filter-repo'
  'goneovim'
  'nerd-fonts/JetBrainsMono-NF'
  'nmap'
  'python'
  'sed'
)

scoop install $scoopPackages
scoop install --skip neovim-nightly
