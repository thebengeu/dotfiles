#!/usr/bin/env bash
set -eox pipefail

if [[ ! -x "$(command -v dpkg)" ]]; then
  exit
fi

ARCHITECTURE=$(dpkg --print-architecture)

if [[ ! -f /usr/bin/op ]]; then
  sudo apt install -y gpg
  curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  echo "deb [arch=${ARCHITECTURE} signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
    sudo tee /etc/apt/sources.list.d/1password.list
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
    sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
  sudo apt update && sudo apt install 1password-cli
fi

export EJSON_KEYDIR="${HOME}/.config/ejson/keys"

EJSON_PUBLIC_KEY="5df4cad7a4c3a2937a863ecf18c56c23274cb048624bc9581ecaac56f2813107"
EJSON_KEY_PATH="${EJSON_KEYDIR}/${EJSON_PUBLIC_KEY}"
SSH_KEY_PATH="${HOME}/.ssh/id_ed25519"

if [[ ! -f ~/.ssh/id_ed25519 ]] || [[ ! -f "${EJSON_KEY_PATH}" ]]; then
  eval "$(op signin)"
fi

if [[ ! -f ~/.ssh/id_ed25519 ]]; then
  mkdir -p ~/.ssh
  op read 'op://Personal/Ed25519 SSH Key/id_ed25519' | tr -d '\r' >"${SSH_KEY_PATH}"
  chmod 600 "${SSH_KEY_PATH}"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
fi

if [[ ! -f "${EJSON_KEY_PATH}" ]]; then
  mkdir -p ~/.local/bin
  curl -Ls https://github.com/Shopify/ejson/releases/download/v1.4.1/ejson_1.4.1_linux_"${ARCHITECTURE}".tar.gz | tar xz --directory ~/.local/bin ejson
  mkdir -p ~/.config/ejson/keys
  op read op://Personal/ejson/"${EJSON_PUBLIC_KEY}" --out-file "${EJSON_KEY_PATH}"
fi

if [[ ! "${CHEZMOI}" = 1 ]]; then
  CHEZMOI_SOURCE_DIR="${HOME}/.local/share/chezmoi"

  if [[ ! -d "${CHEZMOI_SOURCE_DIR}" ]]; then
    sudo apt install -y git
    git clone git@github.com:thebengeu/dotfiles.git "${CHEZMOI_SOURCE_DIR}"
  fi

  sudo apt install -y software-properties-common
  sudo add-apt-repository -y ppa:ansible/ansible
  sudo apt install -y \
    ansible \
    file \
    pipx
  ansible-playbook "${CHEZMOI_SOURCE_DIR}"/ignored/ansible/site.yml --ask-become-pass

  sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"

  export PNPM_HOME=~/.local/share/pnpm
  export PATH="~/.nix-profile/bin:~/.cargo/bin:~/.local/bin:~/go/bin:${PNPM_HOME}:${PATH}"

  pipx install uv
  uv tool install poetry

  chezmoi init
  chezmoi apply --keep-going --exclude scripts
  chezmoi apply --keep-going --include scripts
fi
