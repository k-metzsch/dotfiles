#!/usr/bin/env bash

OS_NAME="$(uname -s)"

if [ "$OS_NAME" = "Darwin" ]; then
	if [ -x "~/.bootstrap/macos/setup.sh" ]; then
		exec "~/.bootstrap/macos/setup.sh"
	else
		exit 1
	fi
elif [ "$OS_NAME" = "Linux" ]; then
	if [ -x "~/.bootstrap/linux/setup.sh" ]; then
		exec "~/.bootstrap/linux/setup.sh"
	else
		exit 1
	fi
else
	echo "Unsupported OS: $OS_NAME"
	exit 2
fi
