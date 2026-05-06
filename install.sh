#!/bin/bash

# ZeroBar Install Script - Only shows icons for installed apps + auto-updates

set -e

TMP_DIR="/tmp/zerobar"
REPO_URL="https://github.com/sytuszero/ZeroBar.git"
WATCHER_SCRIPT="$HOME/.config/waybar/watch-apps.sh"

# Apps to check (binary: module_name)
declare -A apps=(
    ["nautilus"]="custom/files"
    ["brave"]="custom/brave"
    ["code"]="custom/vscode"
    ["steam"]="custom/steam"
    ["Telegram"]="custom/telegram"
    ["discord"]="custom/discord"
    ["spotify"]="custom/spotify"
    ["obs"]="custom/obs"
    ["youtube"]="custom/youtube"
)

# Clone repo
echo "Cloning ZeroBar..."
git clone "$REPO_URL" "$TMP_DIR"

# Build modules-left array based on installed apps
modules_left="    \"custom/omarchy\",\n    \"custom/weather\""

for binary in "${!apps[@]}"; do
    if command -v "$binary" &>/dev/null || [ "$binary" = "youtube" ]; then
        modules_left="$modules_left,\n    \"${apps[$binary]}\""
    fi
done

modules_left="$modules_left,\n    \"hyprland/workspaces\",\n    \"custom/screenrecording-indicator\",\n    \"custom/updatespacman\",\n    \"custom/update\",\n    \"hyprland/window\""

# Generate config.jsonc with only installed apps
sed -i "s/\"modules-left\": \[.*\]/\"modules-left\": [\n$modules_left\n  ]/" "$TMP_DIR/config.jsonc"

# Copy to waybar config
echo "Installing ZeroBar..."
mkdir -p ~/.config/waybar
cp -rf "$TMP_DIR"/. ~/.config/waybar

# Install watcher for auto-updates
echo "Installing app watcher..."
cp "$TMP_DIR/watch-apps.sh" "$WATCHER_SCRIPT"
chmod +x "$WATCHER_SCRIPT"

# Kill existing watcher and start new one
pkill -f "watch-apps.sh" 2>/dev/null || true
nohup "$WATCHER_SCRIPT" > /dev/null 2>&1 &

# Cleanup
rm -rf "$TMP_DIR"

# Restart waybar
omarchy restart waybar 2>/dev/null || pkill -SIGUSR2 waybar

echo "ZeroBar installed successfully!"
echo "Smart mode enabled: Icons will automatically appear/disappear when you install/remove apps."
