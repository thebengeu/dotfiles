#!/usr/bin/env sh
cargo install \
  cargo-update \
  hyperfine \
  lsd \
  onefetch \
  sd \
  tere \
  tokei \
  topgrade

go install github.com/nao1215/gup@latest

pip install --user pipx

pipx install beancount
pipx install fava
pipx install khal
pipx install neovim-remote
pipx install qmk
pipx install sqlfluff
pipx install thefuck
pipx install tox
pipx install virtualenv
pipx install visidata

pnpm add --global \
  npm-check-updates \
  pino-pretty \
  pm2
