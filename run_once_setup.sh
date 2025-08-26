#!/bin/bash

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script must run on macOS."
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
  echo "Requesting sudo privileges..."
  sudo -v
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &
fi

echo "Disabling Spotlight indexing"
mdutil -i off -a || true

if /usr/sbin/nvram boot-args >/dev/null 2>&1; then
  CURRENT="$(/usr/sbin/nvram boot-args 2>/dev/null | sed -e $'s/boot-args\t//')"
  CLEANED="$(echo "$CURRENT" | sed 's/serverperfmode=1//g' | tr -s ' ' | sed 's/^ *//;s/ *$//')"

  if [[ "$CURRENT" != "$CLEANED" ]]; then
    if [[ -z "$CLEANED" ]]; then
      /usr/sbin/nvram -d boot-args
    else
      /usr/sbin/nvram boot-args="$CLEANED"
    fi
  fi
fi

defaults write com.apple.dock persistent-apps -array ""
defaults write com.apple.dock autohide-delay -float 1000
killall Dock

defaults write /Library/Preferences/com.apple.loginwindow DesktopPicture -string ""

defaults write com.apple.Accessibility DifferentiateWithoutColor -int 1
defaults write com.apple.Accessibility ReduceMotionEnabled -int 1
defaults write com.apple.universalaccess reduceMotion -int 1
defaults write com.apple.universalaccess reduceTransparency -int 1

defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool false
defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false
defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -int 0
defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -int 0
defaults write /Library/Preferences/com.apple.SoftwareUpdate ScheduleFrequency -int 0
defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -int 0
defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool false
defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool false

defaults write com.apple.universalaccessAuthWarning /System/Applications/Utilities/Terminal.app -bool true
defaults write com.apple.universalaccessAuthWarning /usr/libexec -bool true
defaults write com.apple.universalaccessAuthWarning /usr/libexec/sshd-keygen-wrapper -bool true
defaults write com.apple.universalaccessAuthWarning com.apple.Messages -bool true
defaults write com.apple.universalaccessAuthWarning com.apple.Terminal -bool true

defaults write com.apple.loginwindow DisableScreenLock -bool true

defaults write com.apple.loginwindow AllowList -string '*'

defaults write com.apple.loginwindow TALLogoutSavesState -bool false

if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -d "/opt/homebrew/bin" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -d "/usr/local/bin" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

if ! command -v ansible &>/dev/null; then
  echo "Installing Ansible..."
  brew install ansible
fi

ansible-playbook ~/.bootstrap/initial-setup.yml --ask-become-pass
ansible-playbook ~/.bootstrap/flutter-setup.yml --ask-become-pass
