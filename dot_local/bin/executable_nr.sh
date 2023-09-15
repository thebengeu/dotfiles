#!/usr/bin/env sh
"$PROGRAMFILES\AutoHotkey\v2\AutoHotkey64.exe" "$APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\AutoHotkey.ahk" n 0
sh ~/.local/bin/nvr-latest-focused-nvim.sh "$@"
