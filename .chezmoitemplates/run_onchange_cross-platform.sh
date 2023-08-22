#!/usr/bin/env sh
cargo install atuin
cargo install broot
cargo install cargo-update
cargo install just
cargo install lsd
cargo install sd
cargo install starship
cargo install tealdeer
cargo install tokei
cargo install topgrade
cargo install vivid
cargo install xh
cargo install zoxide
go install github.com/nao1215/gup@latest
pip install --user pipx
pipx install howdoi
pipx install khal
pipx install neovim-remote
pipx install qmk
pipx install sqlfluff
pipx install virtualenv
pnpm add --global npm-check-updates
pnpm add --global pino-pretty
pnpm add --global pm2
pnpm add --global https://github.com/thebengeu/ts-node.git
curl cht.sh/:cht.sh >~/.local/bin/cht.sh
mkdir -p ~/.local/share/atuin
atuin init nu >~/.local/share/atuin/init.nu
mkdir -p ~/.cache/starship
starship init nu >~/.cache/starship/init.nu
zoxide init --no-cmd nushell | sd __zoxide_z z >~/.zoxide.nu
