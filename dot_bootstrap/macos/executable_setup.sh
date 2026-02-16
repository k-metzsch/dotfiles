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

if [[ "$(uname -s)" != "Darwin" ]]; then
	echo "This script must run on macOS."
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

################################################################################
# UI/UX and Accessibility
################################################################################

# Reduce animations and transparency (you had these already; keeping and consolidating)
defaults write com.apple.Accessibility DifferentiateWithoutColor -int 1
defaults write com.apple.Accessibility ReduceMotionEnabled -int 1
defaults write com.apple.universalaccess reduceMotion -int 1
defaults write com.apple.universalaccess reduceTransparency -int 1

# Disable "shake mouse pointer to locate"
defaults write -g CGDisableCursorLocationMagnification -bool true

# Always show scrollbars
defaults write -g AppleShowScrollBars -string "Always"

# Keyboard: faster repeat, disable press-and-hold
defaults write -g ApplePressAndHoldEnabled -bool false
# Lower numbers = faster. Try 2 and 15; adjust if too fast.
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15

# Disable auto-correct and "smart" substitutions (commonly disabled for devs)
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g WebAutomaticSpellingCorrectionEnabled -bool false

# Full keyboard access (Tab moves between all controls)
defaults write -g AppleKeyboardUIMode -int 3

################################################################################
# Disable Spotlight completely & remove keybind (for Raycast users)
################################################################################

# Disable Spotlight indexing for all volumes (permanent way)
echo "Disabling Spotlight indexing (may require admin)..."
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist 2>/dev/null || true

# Prevent re-enabling:
sudo chmod 600 /System/Library/LaunchDaemons/com.apple.metadata.mds.plist || true

# Remove all indexed metadata
sudo mdutil -a -i off
sudo mdutil -a -E

# Remove Spotlight from menu bar (for new macOS versions, this disables the icon):
defaults write com.apple.Spotlight MenuItemHidden -int 1 || true
killall SystemUIServer || true

# Remove Spotlight command-space keybinding (replace with Raycast recommended)
echo "Disabling Spotlight shortcuts and removing Cmd+Space binding..."

# macOS Monterey and later use Apple Symbolic HotKeys (double-check after new macOS upgrades)
# Disable Spotlight search HotKey (default 64/65 for search/show finder search window)
# 64: Spotlight main window (CMD+SPACE), 65: Finder search window (CMD+OPT+SPACE)

for index in 64 65; do
	defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$index" '{
      enabled = 0;
      value = {
          parameters = (32, 49, 1048576);
          type = "standard";
      };
  }'
done

# Note: Raycast will prompt to register for Command+Space on first launch; or assign manually.

################################################################################
# Trackpad / Mouse
################################################################################

# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# For the current host and for login screen
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write -g com.apple.mouse.tapBehavior -int 1

# Disable "natural" scrolling (set to true if you prefer natural)
defaults write -g com.apple.swipescrolldirection -bool false

# Slightly increase tracking speed (range roughly 0..3)
defaults write -g com.apple.trackpad.scaling -float 1.5

################################################################################
# Finder
################################################################################

# Show all filename extensions
defaults write -g AppleShowAllExtensions -bool true

# Show status and path bars
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# New Finder windows show the user's home directory
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show hidden files (optional: set to false if you prefer hiding dotfiles)
defaults write com.apple.finder AppleShowAllFiles -bool true

# Allow quitting Finder (Cmd+Q) which also hides desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

################################################################################
# Dock
################################################################################

# Clear Dock apps & others (your persistent-apps had a dummy element; make it truly empty)
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array

# Autohide the Dock and effectively disable accidental reveal
defaults write com.apple.dock autohide -bool true
# Long delay before showing (set to 0 for instant; you had 1000, which "disables" reveal practically)
defaults write com.apple.dock autohide-delay -float 1000
# Faster hide/show animation
defaults write com.apple.dock autohide-time-modifier -float 0.25

# Disable recent applications in the Dock
defaults write com.apple.dock show-recents -bool false

# Other Dock niceties
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock mru-spaces -bool false

################################################################################
# Screenshots
################################################################################

mkdir -p "${HOME}/screenshots"
defaults write com.apple.screencapture location -string "${HOME}/screenshots"
defaults write com.apple.screencapture type -string "png"

################################################################################
# Save/Print panels expanded by default
################################################################################

defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g PMPrintingExpandedStateForPrint2 -bool true

################################################################################
# Developer conveniences
################################################################################

# Enable WebKit developer extras globally (affects WebView-based apps)
defaults write -g WebKitDeveloperExtras -bool true

# Terminal: enable Secure Keyboard Entry (protects against key sniffing)
defaults write com.apple.Terminal SecureKeyboardEntry -bool true

# Safari Develop menu
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write -g WebKitDeveloperExtras -bool true

################################################################################
# Software Update (system-level)
################################################################################

# Strongly prefer using sudo for /Library/Preferences
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -int 0
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -int 0
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ScheduleFrequency -int 0
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool false
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool false

# Ensure macOS doesn't auto-schedule updates
sudo softwareupdate --schedule off || true

################################################################################
# Homebrew and Ansible
################################################################################

if ! command -v brew >/dev/null 2>&1; then
	echo "Homebrew not found. Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	if [ -x "/opt/homebrew/bin/brew" ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [ -x "/usr/local/bin/brew" ]; then
		eval "$(/usr/local/bin/brew shellenv)"
	fi
fi

# Brew niceties
brew analytics off || true
brew update

if ! command -v ansible >/dev/null 2>&1; then
	echo "Installing Ansible..."
	brew install ansible
fi

################################################################################
# Apply defaults (restart affected services once)
################################################################################

# Restart UI services to apply settings
killall Dock || true
killall Finder || true
killall SystemUIServer || true

################################################################################
# Ansible playbooks
################################################################################

if [[ -f "${HOME}/.bootstrap/initial-setup.yml" ]]; then
	ansible-playbook "${HOME}/.bootstrap/packages.yml" --ask-become-pass
fi
if [[ -f "${HOME}/.bootstrap/dev-setup.yml" ]]; then
	ansible-playbook "${HOME}/.bootstrap/development.yml" --ask-become-pass
fi
