#!/usr/bin/env sh
cargo install \
  atuin \
  cargo-update \
  du-dust \
  eza \
  hyperfine \
  onefetch \
  sd \
  tere \
  tokei \
  topgrade

go install github.com/nao1215/gup@latest

pip install --user pipx

pipx install beancount
pipx install fava
pipx install git-revise
pipx install http-prompt
pipx install httpie
pipx install khal
pipx install neovim-remote
pipx install sqlfluff
pipx install thefuck
pipx install tox
pipx install virtualenv
pipx install visidata

pnpm add --global \
  npm-check-updates \
  pino-pretty \
  pm2 \
  trash-cli \
  tsx
