#!/usr/bin/env bash
tic -x <(curl https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo)

cargo binstall --locked --no-confirm \
  cargo-bundle \
  cargo-update

gh extension install github/gh-copilot
gh extension install dlvhdr/gh-dash
gh extension install seachicken/gh-poi

gup import

PIP_REQUIRE_VIRTUALENV=false pip3 install --break-system-packages --upgrade --user \
  pynvim

pipx install beancount
pipx install fava
pipx install git-revise
pipx install gitlint-core
pipx install http-prompt
pipx install httpie
pipx install --preinstall rich ipython
pipx install keymap-drawer
pipx install khal
pipx install kube-shell
pipx install neovim-remote
pipx install pip-upgrader
pipx install sqlfluff
pipx install thefuck
pipx install tmuxp
pipx install tox
pipx install virtualenv
pipx install visidata

COREPACK_ENABLE_DOWNLOAD_PROMPT=0 pnpm add --global \
  npm-check-updates \
  pino-pretty \
  pm2 \
  prettier \
  sql-formatter \
  trash-cli \
  tsx

if hash ya 2>/dev/null; then
  ya pack --add yazi-rs/flavors:catppuccin-mocha 2>/dev/null || true
fi

rustup component add rust-analyzer
