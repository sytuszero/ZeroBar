#!/bin/bash

# ZeroBar Install Script - Simple copy-based installation

set -e

REPO_URL="https://github.com/sytuszero/ZeroBar.git"
TMP_DIR=$(mktemp -d /tmp/zerobar.XXXXXX)

echo "Installing ZeroBar..."

# Clone repo
git clone "$REPO_URL" "$TMP_DIR"

# Copy files to waybar config
mkdir -p ~/.config/waybar
cp -rf "$TMP_DIR"/. ~/.config/waybar

# Cleanup
rm -rf "$TMP_DIR"

# Restart waybar
if pgrep -x waybar > /dev/null; then
    killall waybar 2>/dev/null || true
    sleep 1
fi

waybar &

echo "✓ ZeroBar installed successfully!"
echo "✓ Waybar restarted with ZeroBar theme."
echo ""
echo "To customize (remove apps): Edit ~/.config/waybar/config.jsonc"
