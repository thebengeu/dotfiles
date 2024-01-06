#!/usr/bin/env bash
tic -x <(curl https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo)

cargo binstall --no-confirm cargo-update

gh extension install github/gh-copilot
gh extension install dlvhdr/gh-dash
gh extension install seachicken/gh-poi

go install github.com/nao1215/gup@latest

pip3 install --upgrade --user \
  pipx \
  pynvim \
  setuptools

pipx install beancount
pipx install fava
pipx install git-revise
pipx install gitlint-core
pipx install http-prompt
pipx install httpie
pipx install --preinstall rich ipython
pipx install khal
pipx install neovim-remote
pipx install poetry
pipx install sqlfluff
pipx install thefuck
pipx install tox
pipx install virtualenv
pipx install visidata

pnpm add --global \
  npm-check-updates \
  pino-pretty \
  pm2 \
  sql-formatter \
  trash-cli \
  tsx
