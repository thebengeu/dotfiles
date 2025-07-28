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
  miller
  miniserve
  mise
  navi
  nethogs
  nnn
  nushell
  onefetch
  peco
  pspg
  pulumi
  scc
  sd
  speedtest-cli
  shfmt
  sq
  ssm-session-manager-plugin
  steampipe
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
  nix profile add "nixpkgs#${package}"
done

nix profile add nixpkgs#hledger-ui --priority 4
nix profile add nixpkgs#hledger-web --priority 4

krew install krew
steampipe plugin install --progress=false aws
