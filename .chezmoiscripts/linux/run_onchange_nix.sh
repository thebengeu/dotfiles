#!/usr/bin/env bash
packages=(
  aws-vault
  awscli2
  bandwhich
  bottom
  btop
  cointop
  croc
  dbmate
  delta
  difftastic
  dsq
  dua
  duf
  dust
  eksctl
  eza
  fennel
  fzf
  gdu
  ghorg
  gitui
  glow
  hledger
  hledger-ui
  hledger-web
  hyperfine
  jless
  jwt-cli
  k6
  k9s
  kind
  krew
  kubecolor
  kubeswitch
  lazydocker
  lazygit
  ledger
  less
  lf
  mdcat
  miller
  miniserve
  navi
  nethogs
  nnn
  nushell
  onefetch
  peco
  pspg
  scc
  sd
  speedtest-cli
  shfmt
  sq
  tealdeer
  tere
  tokei
  todoist
  topgrade
  usql
  vifm
  walk
  xdg-ninja
  xh
  yazi
  yj
)

nix profile upgrade --all

for package in "${packages[@]}"; do
  nix profile install "nixpkgs#${package}"
done

krew install krew
