#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

KEEPALIVE_PID=""
cleanup() {
	if [[ -n "${KEEPALIVE_PID}" ]] && ps -p "${KEEPALIVE_PID}" >/dev/null 2>&1; then
		kill "${KEEPALIVE_PID}" || true
	fi
}
trap cleanup EXIT

if [[ "$(uname -s)" != "Linux" ]]; then
	echo "This script must run on Linux."
	exit 1
fi

if [[ $EUID -ne 0 ]]; then
	echo "Requesting sudo privileges..."
	sudo -v
	(while true; do
		sudo -n true
		sleep 60
	done) 2>/dev/null &
	KEEPALIVE_PID=$!
fi

echo "This has been run"

################################################################################
# KDE / Plasma UI Tweaks
################################################################################

# # Reduce/disable animations
# kwriteconfig5 --file kwinrc --group EffectSettings --key AccessibilityEnabled false
# kwriteconfig5 --file kwinrc --group EffectSettings --key FadeEnabled false
# kwriteconfig5 --file kwinrc --group EffectSettings --key SlideEnabled false
#
# # Always show scrollbars in Qt apps
# kwriteconfig5 --file kdeglobals --group General --key ScrollBarPolicy "Always"
#
# # Set fast keyboard repeat rate (this is usually done in Input Device settings, but can be set through xset)
# xset r rate 200 30
#
# echo "Changing default shell to zsh for user: $USER"
# chsh -s "$(command -v zsh)" "$USER"
#
# # Disable "natural" scrolling in KDE (touchpad config)
# kwriteconfig5 --file kcmodule_touchpad --group Touchpad --key NaturalScrolling false
#
# # Set Qt/GTK themes for light/dark
# kwriteconfig5 --file kdeglobals --group General --key ColorScheme "BreezeDark"
#
# # Set up workspace behavior (disable desktop effect, etc.)
# kwriteconfig5 --file kwinrc --group Plugins --key minimizeanimation "false"
# kwriteconfig5 --file kwinrc --group Plugins --key fade "false"
#
# # Enable hidden files in Dolphin
# kwriteconfig5 --file dolphinrc --group General --key ShowHiddenFiles true
#
# ################################################################################
# # Restart KDE related services (for settings to take effect)
# ################################################################################
#
# # Restart plasma shell to reload configs
# echo "Restarting KDE Plasma shell to apply UI changes..."
# killall plasmashell || true
# kstart5 plasmashell || true
#
# ################################################################################
# # Ansible playbooks
# ################################################################################
#
# if [[ -f "${HOME}/.bootstrap/initial-setup.yml" ]]; then
# 	ansible-playbook "${HOME}/.bootstrap/packages.yml" --ask-become-pass
# fi
# if [[ -f "${HOME}/.bootstrap/dev-setup.yml" ]]; then
# 	ansible-playbook "${HOME}/.bootstrap/development.yml" --ask-become-pass
# fi
