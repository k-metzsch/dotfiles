#!/usr/bin/env bash
set -euo pipefail

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo not found. Install 'sudo' and add your user to wheel first." >&2
  exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman not found. This script is for Arch Linux (and derivatives)." >&2
  exit 1
fi

echo "[ansible-install] Refreshing package databases..."
sudo pacman -Sy --noconfirm

echo "[ansible-install] Installing/Updating Ansible..."
sudo pacman -S --needed --noconfirm ansible

echo "[ansible-install] Verifying installation..."
if command -v ansible-playbook >/dev/null 2>&1; then
  ansible --version | head -n 1
  echo "[ansible-install] Done."
else
  echo "[ansible-install] ERROR: ansible-playbook not on PATH after install." >&2
  exit 1
fi

ansible-playbook ~/.bootstrap/setup.yml --ask-become-pass
