#!/usr/bin/env sh
pipx install qmk

if [ "$(uname -m)" = 'x86_64' ]; then
  kubectl krew install browse-pvc
fi
