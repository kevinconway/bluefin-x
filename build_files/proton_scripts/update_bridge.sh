#!/bin/bash

set -euo pipefail

INSTALL_SCRIPT="$(dirname "$0")/install_bridge.sh"
PROTON_URL="https://proton.me/support/install-bridge-linux-rpm-file"
TEMP_HTML="$(mktemp)"

if [ ! -f "$INSTALL_SCRIPT" ]; then
	echo "Error: Installation script not found at $INSTALL_SCRIPT"
	exit 1
fi

if ! command -v wget &>/dev/null; then
	echo "Error: wget is required but not installed. Please install wget and try again."
	rm -f "$TEMP_HTML"
	exit 1
fi

if ! wget -q --tries=3 --timeout=15 -O "$TEMP_HTML" "$PROTON_URL" 2>/dev/null; then
	echo "Error: Failed to download documentation from $PROTON_URL"
	rm -f "$TEMP_HTML"
	exit 1
fi

if [ ! -s "$TEMP_HTML" ]; then
	echo "Error: Downloaded file is empty"
	rm -f "$TEMP_HTML"
	exit 1
fi

CURRENT_VERSION=$(grep -oP 'protonmail-bridge-\K[0-9]+\.[0-9]+\.[0-9]+-[0-9]+(?=\.x86_64\.rpm)' "$INSTALL_SCRIPT" | head -1)
if [ -z "$CURRENT_VERSION" ]; then
	echo "Error: Could not find current version in install script"
	rm -f "$TEMP_HTML"
	exit 1
fi

echo "Current Proton Bridge version in install script: $CURRENT_VERSION"

LATEST_VERSION=$(grep -oP 'protonmail-bridge-\K[0-9]+\.[0-9]+\.[0-9]+-[0-9]+(?=\.x86_64\.rpm)' "$TEMP_HTML" | head -1)
if [ -z "$LATEST_VERSION" ]; then
	echo "Error: Could not find latest version in downloaded HTML"
	rm -f "$TEMP_HTML"
	exit 1
fi

echo "Latest Proton Bridge version in documentation: $LATEST_VERSION"

if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
	echo "Update available: $CURRENT_VERSION -> $LATEST_VERSION"
	sed -i "s/protonmail-bridge-$CURRENT_VERSION/protonmail-bridge-$LATEST_VERSION/g" "$INSTALL_SCRIPT"
else
	echo "No update needed. Current version is up to date."
fi

rm -f "$TEMP_HTML"
