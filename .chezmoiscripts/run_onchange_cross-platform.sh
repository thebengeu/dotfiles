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

uv tool install beancount
uv tool install fava
uv tool install git-revise
uv tool install gitlint-core
uv tool install http-prompt
uv tool install httpie
uv tool install --with rich ipython
uv tool install keymap-drawer
uv tool install khal
uv tool install kube-shell
uv tool install neovim-remote
uv tool install \
  --upgrade \
  --with 'bigquery-magics,git+https://github.com/thebengeu/colabtools.git,httplib2,jupysql,pgspecial<2,pillow,plotly,psycopg2-binary,rich' \
  notebook
uv tool install pip-upgrader
uv tool install shell-gpt
uv tool install sqlfluff
uv tool install thefuck
uv tool install tmuxp
uv tool install tox
uv tool install virtualenv
uv tool install visidata

npm install --global pnpm
pnpm add --global \
  @anthropic-ai/claude-code \
  codebuff \
  npm-check-updates \
  pino-pretty \
  pm2 \
  prettier \
  sql-formatter \
  trash-cli

if hash ya 2>/dev/null; then
  ya pack --add yazi-rs/flavors:catppuccin-mocha 2>/dev/null || true
fi

rustup component add rust-analyzer
