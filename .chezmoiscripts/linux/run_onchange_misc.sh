#!/usr/bin/env sh
cargo binstall --locked --no-confirm \
  television

uv tool install qmk

if [ "$(uname -m)" = 'x86_64' ]; then
  kubectl krew install browse-pvc
fi
