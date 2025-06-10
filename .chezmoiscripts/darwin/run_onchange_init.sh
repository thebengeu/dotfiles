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
  mkdir -p ~/.ssh
  op read 'op://Personal/Ed25519 SSH Key/id_ed25519' | tr -d '\r' >"${SSH_KEY_PATH}"
  chmod 600 "${SSH_KEY_PATH}"
  eval "$(ssh-agent -s)"
  ssh-add "${SSH_KEY_PATH}"
fi

if [ ! -f "${EJSON_KEY_PATH}" ]; then
  mkdir -p "${HOME}"/.config/ejson/keys
  op read op://Personal/ejson/"${EJSON_PUBLIC_KEY}" --out-file "${EJSON_KEY_PATH}"
fi

defaults write -g ApplePressAndHoldEnabled -bool false

# shellcheck disable=SC2154
if [ ! "${CHEZMOI}" = 1 ]; then
  export PNPM_HOME=~/.local/share/pnpm
  export PATH=~/.cargo/bin:~/go/bin:~/Library/Python/3.12/bin:"${PNPM_HOME}":"${PATH}"

  sed s/^#auth/auth/ /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local

  chezmoi init --ssh thebengeu

  if [ "$(uname -m)" = 'x86_64' ]; then
    sudo chown -R "${USER}":admin /usr/local/share/icons /usr/local/share/locale
  fi

  HOMEBREW_GITHUB_API_TOKEN="$(ejson decrypt ~/.local/share/chezmoi/.secrets.ejson | jq -r .github_token_repo)" brew bundle install --file ~/.local/share/chezmoi/ignored/Brewfile --no-lock
  brew link --overwrite moreutils
  brew unlink parallel
  brew link --overwrite parallel

  echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 "$(command -v kanata)" | cut -d " " -f 1) $(command -v kanata)" | sudo tee /private/etc/sudoers.d/kanata

  cargo install --locked cargo-binstall

  uv tool install poetry

  brew_prefix=$(brew --prefix)

  sed -i '' 's/#port = 5432/port = 5434/' "${brew_prefix}/var/postgresql@17/postgresql.conf"
  sudo sh -c "echo ${brew_prefix}/bin/fish >> /etc/shells"
  chsh -s "${brew_prefix}/bin/fish"

  if [ "$(uname -m)" = 'arm64' ]; then
    softwareupdate --install-rosetta
  fi

  chezmoi apply --keep-going --exclude scripts
  chezmoi apply --keep-going --include scripts
fi
