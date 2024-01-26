#!/usr/bin/env sh
if ! [ -x "$(command -v brew)" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ "$(uname -m)" = 'arm64' ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

brew tap shopify/shopify
brew install \
  1password \
  1password-cli \
  chezmoi \
  cue \
  ejson \
  jq

export EJSON_KEYDIR="${HOME}/.config/ejson/keys"

EJSON_PUBLIC_KEY="5df4cad7a4c3a2937a863ecf18c56c23274cb048624bc9581ecaac56f2813107"
EJSON_KEY_PATH="${EJSON_KEYDIR}/${EJSON_PUBLIC_KEY}"
SSH_KEY_PATH="${HOME}/.ssh/id_ed25519"

if [ ! -f "${SSH_KEY_PATH}" ]; then
  mkdir ~/.ssh
  op read 'op://Personal/Ed25519 SSH Key/id_ed25519' | tr -d '\r' >"${SSH_KEY_PATH}"
  chmod 600 "${SSH_KEY_PATH}"
  eval "$(ssh-agent -s)"
  ssh-add "${SSH_KEY_PATH}"
fi

if [ ! -f "${EJSON_KEY_PATH}" ]; then
  mkdir -p "${HOME}"/.config/ejson/keys
  op read op://Personal/ejson/"${EJSON_PUBLIC_KEY}" --out-file "${EJSON_KEY_PATH}"
fi

if [ ! "${CHEZMOI}" = 1 ]; then
  export PNPM_HOME=~/.local/share/pnpm
  export PATH=~/.cargo/bin:~/go/bin:~/Library/Python/3.11/bin:"${PNPM_HOME}":"${PATH}"
  chezmoi init --ssh thebengeu

  if [ "$(uname -m)" = 'x86_64' ]; then
    sudo chown -R "${USER}":admin /usr/local/share/icons /usr/local/share/locale
  fi

  HOMEBREW_GITHUB_API_TOKEN="$(ejson decrypt ~/.local/share/chezmoi/.secrets.ejson | jq -r .github_token_repo)" brew bundle install --file ~/.local/share/chezmoi/ignored/Brewfile --no-lock
  brew link --overwrite moreutils
  brew unlink parallel
  brew link --overwrite parallel

  cargo install cargo-binstall

  PIP_REQUIRE_VIRTUALENV=false pip3 install --upgrade --user \
    pipx
  pipx install poetry

  if [ "$(uname -m)" = 'arm64' ]; then
    sudo sh -c 'echo /opt/homebrew/bin/fish >> /etc/shells'
    chsh -s /opt/homebrew/bin/fish
    softwareupdate --install-rosetta
  else
    sudo sh -c 'echo /usr/local/bin/fish >> /etc/shells'
    chsh -s /usr/local/bin/fish
  fi

  chezmoi apply --exclude scripts
  chezmoi apply --include scripts
fi
