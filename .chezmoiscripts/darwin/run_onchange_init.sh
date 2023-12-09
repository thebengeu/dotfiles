#!/usr/bin/env sh
if ! [ -x "$(command -v brew)" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew tap shopify/shopify
brew install \
  1password \
  1password-cli \
  chezmoi \
  cue \
  ejson

export EJSON_KEYDIR="$HOME/.config/ejson/keys"

EJSON_PUBLIC_KEY="5df4cad7a4c3a2937a863ecf18c56c23274cb048624bc9581ecaac56f2813107"
EJSON_KEY_PATH="$EJSON_KEYDIR/$EJSON_PUBLIC_KEY"
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"

if [ ! -f "$SSH_KEY_PATH" ]; then
  mkdir ~/.ssh
  op read 'op://Personal/Ed25519 SSH Key/id_ed25519' | tr -d '\r' >"$SSH_KEY_PATH"
  chmod 600 "$SSH_KEY_PATH"
  eval "$(ssh-agent -s)"
  ssh-add "$SSH_KEY_PATH"
fi

if [ ! -f "$EJSON_KEY_PATH" ]; then
  mkdir -p "$HOME"/.config/ejson/keys
  op read op://Personal/ejson/"$EJSON_PUBLIC_KEY" --out-file "$EJSON_KEY_PATH"
fi

if [ ! "$CHEZMOI" = 1 ]; then
  export PNPM_HOME=~/.local/share/pnpm
  export PATH=~/.cargo/bin:~/go/bin:~/Library/Python/3.11/bin:"$PNPM_HOME":"$PATH"
  chezmoi init --ssh thebengeu
  sudo chown -R "$USER":admin /usr/local/share/icons /usr/local/share/locale
  brew bundle install --file ~/.local/share/chezmoi/Brewfile --no-lock
  cargo install cargo-binstall
  sudo sh -c 'echo /usr/local/bin/fish >> /etc/shells'
  chsh -s /usr/local/bin/fish
  chezmoi apply --exclude scripts
  chezmoi apply --include scripts
fi
