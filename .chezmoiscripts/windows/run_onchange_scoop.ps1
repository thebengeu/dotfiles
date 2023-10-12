$scoopPackages = @(
  'btop'
  'dos2unix'
  'gcc'
  'git-filter-repo'
  'goneovim'
  'make'
  'miller'
  'nerd-fonts/JetBrainsMono-NF'
  'nmap'
  'sed'
  'win32yank'
)

scoop install $scoopPackages
scoop install --skip neovim-nightly
