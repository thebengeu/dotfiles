#!/usr/bin/env sh
uv tool install qmk

if [ "$(uname -m)" = 'x86_64' ]; then
  kubectl krew install browse-pvc
fi
