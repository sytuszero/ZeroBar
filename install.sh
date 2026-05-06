#!/bin/bash

# ZeroBar Install Script - Simple and reliable

set -e

REPO_URL="https://github.com/sytuszero/ZeroBar.git"
WATCHER_SCRIPT="$HOME/.config/waybar/watch-apps.sh"

echo "Installing ZeroBar..."

# Create temp dir
TMP_DIR=$(mktemp -d /tmp/zerobar.XXXXXX)

# Clone repo
git clone "$REPO_URL" "$TMP_DIR"

# Copy files to waybar config
mkdir -p ~/.config/waybar
cp -rf "$TMP_DIR"/. ~/.config/waybar

# Install watcher
cp "$TMP_DIR/watch-apps.sh" "$WATCHER_SCRIPT"
chmod +x "$WATCHER_SCRIPT"

# Kill existing watcher and start new one
pkill -f "watch-apps.sh" 2>/dev/null || true
nohup "$WATCHER_SCRIPT" > /dev/null 2>&1 &

# Cleanup
rm -rf "$TMP_DIR"

# Kill existing waybar
if pgrep -x waybar > /dev/null; then
    killall waybar 2>/dev/null || true
    sleep 2
fi

# Start waybar in background
waybar > /tmp/waybar.log 2>&1 &

# Wait and check
sleep 3
if pgrep -x waybar > /dev/null; then
    echo "✓ ZeroBar installed successfully!"
    echo "✓ Waybar is running with ZeroBar theme!"
else
    echo "✗ Waybar failed to start. Check log: /tmp/waybar.log"
    cat /tmp/waybar.log
fi
