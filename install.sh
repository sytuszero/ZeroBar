#!/bin/bash

# ZeroBar Install Script - Smart app detection

set -e

TMP_DIR=$(mktemp -d /tmp/zerobar.XXXXXX)
REPO_URL="https://github.com/sytuszero/ZeroBar.git"
WATCHER_SCRIPT="$HOME/.config/waybar/watch-apps.sh"

echo "Installing ZeroBar..."

# Clone repo
git clone "$REPO_URL" "$TMP_DIR"

# Check which apps are installed
MODULES="custom/omarchy custom/weather"
command -v nautilus &>/dev/null && MODULES="$MODULES custom/files"
command -v brave &>/dev/null && MODULES="$MODULES custom/brave"
command -v code &>/dev/null && MODULES="$MODULES custom/vscode"
command -v steam &>/dev/null && MODULES="$MODULES custom/steam"
command -v Telegram &>/dev/null && MODULES="$MODULES custom/telegram"
command -v discord &>/dev/null && MODULES="$MODULES custom/discord"
command -v spotify &>/dev/null && MODULES="$MODULES custom/spotify"
command -v obs &>/dev/null && MODULES="$MODULES custom/obs"
MODULES="$MODULES custom/youtube"
MODULES="$MODULES hyprland/workspaces"
MODULES="$MODULES custom/screenrecording-indicator"
MODULES="$MODULES custom/updatespacman"
MODULES="$MODULES custom/update"
MODULES="$MODULES hyprland/window"

# Use Python to update config
python3 << ENDPYTHON
import re

with open('$TMP_DIR/config.jsonc', 'r') as f:
    lines = f.readlines()

output = []
in_modules = False
for line in lines:
    if '"modules-left"' in line:
        output.append(line)
        in_modules = True
        # Write the new modules
        for m in '$MODULES'.split():
            output.append(f'    "{m}",\n')
        # Skip old modules
        while True:
            line = next(iter([lines.pop(0)]), None)
            if line and ('],' in line or ']' in line):
                output.append(line)
                break
    elif not in_modules:
        output.append(line)

with open('$TMP_DIR/config.jsonc', 'w') as f:
    f.writelines(output)
ENDPYTHON

# Copy to waybar config
mkdir -p ~/.config/waybar
cp -rf "$TMP_DIR"/. ~/.config/waybar

# Install watcher
cp "$TMP_DIR/watch-apps.sh" "$WATCHER_SCRIPT"
chmod +x "$WATCHER_SCRIPT"

# Start watcher
pkill -f "watch-apps.sh" 2>/dev/null || true
nohup "$WATCHER_SCRIPT" > /dev/null 2>&1 &

# Cleanup
rm -rf "$TMP_DIR"

# Restart waybar
omarchy restart waybar 2>/dev/null || killall -SIGUSR2 waybar 2>/dev/null || true

echo "✓ ZeroBar installed successfully!"
echo "✓ Smart mode enabled: Icons auto-update when you install/remove apps."
