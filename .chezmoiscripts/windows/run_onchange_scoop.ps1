$scoopPackages = @(
  'btop'
  'chromium'
  'chromium-dev'
  'dos2unix'
  'gcc'
  'git-filter-repo'
  'goneovim'
  'make'
  'miller'
  'nerd-fonts/JetBrainsMono-NF'
  'nmap'
  'sed'
)

scoop install $scoopPackages
scoop install --skip neovim-nightly
