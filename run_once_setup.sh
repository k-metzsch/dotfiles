#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${0}}")" && pwd)/dot_bootstrap"

OS_NAME="$(uname -s)"

echo "$SCRIPT_DIR/macos/setup.sh"

if [ "$OS_NAME" = "Darwin" ]; then
	if [ -x "$SCRIPT_DIR/macos/setup.sh" ]; then
		exec "$SCRIPT_DIR/macos/setup.sh"
	else
		exit 1
	fi
elif [ "$OS_NAME" = "Linux" ]; then
	if [ -x "$SCRIPT_DIR/linux/setup.sh" ]; then
		exec "$SCRIPT_DIR/linux/setup.sh"
	else
		exit 1
	fi
else
	echo "Unsupported OS: $OS_NAME"
	exit 2
fi
