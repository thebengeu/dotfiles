$scoopPackages = @(
  'btop'
  'gcc'
  'git-filter-repo'
  'goneovim'
  'make'
  'nerd-fonts/JetBrainsMono-NF'
  'nmap'
  'python'
  'sed'
)

scoop install $scoopPackages
scoop install --skip neovim-nightly
