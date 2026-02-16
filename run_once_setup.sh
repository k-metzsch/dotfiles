#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${0}}")" && pwd)"

OS_NAME="$(uname -s)"

pwd

ls

if [ "$OS_NAME" = "Darwin" ]; then
	if [ -x "$SCRIPT_DIR/.bootstrap/macos/setup.sh" ]; then
		exec "$SCRIPT_DIR/.bootstrap/macos/setup.sh"
	else
		exit 1
	fi
elif [ "$OS_NAME" = "Linux" ]; then
	if [ -x "$SCRIPT_DIR/.bootstrap/linux/setup.sh" ]; then
		exec "$SCRIPT_DIR/.bootstrap/linux/setup.sh"
	else
		exit 1
	fi
else
	echo "Unsupported OS: $OS_NAME"
	exit 2
fi
