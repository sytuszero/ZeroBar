#!/bin/bash

# ZeroBar Install Script - Only shows icons for installed apps

set -e

TMP_DIR="/tmp/zerobar"
REPO_URL="https://github.com/sytuszero/ZeroBar.git"

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
cp -rf "$TMP_DIR"/. ~/.config/waybar

# Cleanup
rm -rf "$TMP_DIR"

# Restart waybar
omarchy restart waybar

echo "ZeroBar installed successfully!"
