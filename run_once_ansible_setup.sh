#!/usr/bin/env bash

PLAYBOOK_DIR="${HOME}/.local/share/chezmoi/dot_bootstrap"
PLAYBOOK="${PLAYBOOK_DIR}/setup.yml"

if ! command -v python &>/dev/null; then
  sudo pacman -S --needed --noconfirm python
fi

if ! command -v ansible-playbook &>/dev/null; then
  sudo pacman -S --needed --noconfirm ansible
fi

if [ -f "${PLAYBOOK_DIR}/requirements.yml" ]; then
  ansible-galaxy collection install -r "${PLAYBOOK_DIR}/requirements.yml"
fi

ansible-playbook "${PLAYBOOK}" --ask-become-pass
