$scoopPackages = @(
  'btop'
  'dos2unix'
  'gcc'
  'git-filter-repo'
  'goneovim'
  'make'
  'nerd-fonts/JetBrainsMono-NF'
  'nmap'
  'sed'
  'win32yank'
)

scoop install $scoopPackages
scoop install --skip neovim-nightly
