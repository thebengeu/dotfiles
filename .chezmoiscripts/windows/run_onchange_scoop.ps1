scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add versions

$scoopPackages = @(
  'btop'
  'dos2unix'
  'gcc'
  'gcloud'
  'ghorg'
  'git-filter-repo'
  'goneovim'
  'krew'
  'make'
  'miller'
  'nasm'
  'neovide'
  'nerd-fonts/JetBrainsMono-NF'
  'nmap'
  'poppler'
  'sed'
  'unar'
)

scoop install $scoopPackages
scoop install neovim-nightly
