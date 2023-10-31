#!/usr/bin/env bash
tic -x <(curl https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo)

cargo install gitui

pipx install qmk
