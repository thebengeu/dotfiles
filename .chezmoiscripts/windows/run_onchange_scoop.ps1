scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add versions

$scoopPackages = @(
  'btop'
  'dos2unix'
  'dust'
  'eza'
  'gcc'
  'gcloud'
  'ghorg'
  'git-filter-repo'
  'goneovim'
  'jwt-cli'
  'lazydocker'
  'lazygit'
  'krew'
  'make'
  'mdcat'
  'miller'
  'miniserve'
  'nasm'
  'navi'
  'neovide'
  'nerd-fonts/JetBrainsMono-NF'
  'nmap'
  'poppler'
  'sed'
  'shfmt'
  'tealdeer'
  'tere'
  'topgrade'
  'unar'
  'usql'
  'walk'
)

scoop install $scoopPackages
scoop install neovim-nightly
