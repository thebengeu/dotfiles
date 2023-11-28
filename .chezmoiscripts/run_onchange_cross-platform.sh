#!/usr/bin/env sh
cargo binstall cargo-update

go install github.com/nao1215/gup@latest

pip3 install --upgrade --user \
  pipx \
  setuptools

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
