$scoopPackages = @(
  'btop'
  'dos2unix'
  'gcc'
  'git-filter-repo'
  'goneovim'
  'make'
  'miller'
  'nasm'
  'nerd-fonts/JetBrainsMono-NF'
  'nmap'
  'sed'
)

scoop install $scoopPackages
scoop install --skip neovim-nightly
