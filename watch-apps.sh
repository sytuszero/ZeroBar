#!/bin/bash

# ZeroBar App Watcher - Automatically updates waybar when apps are installed/removed

CONFIG_FILE="$HOME/.config/waybar/config.jsonc"
REPO_URL="https://github.com/sytuszero/ZeroBar.git"
TMP_DIR="/tmp/zerobar-check"

# Apps to monitor (binary: module_name)
declare -A apps=(
    ["nautilus"]="custom/files"
    ["brave"]="custom/brave"
    ["code"]="custom/vscode"
    ["steam"]="custom/steam"
    ["Telegram"]="custom/telegram"
    ["discord"]="custom/discord"
    ["spotify"]="custom/spotify"
    ["obs"]="custom/obs"
)

get_installed_modules() {
    local modules="    \"custom/omarchy\",\n    \"custom/weather\""
    
    for binary in "${!apps[@]}"; do
        if command -v "$binary" &>/dev/null || [ "$binary" = "youtube" ]; then
            modules="$modules,\n    \"${apps[$binary]}\""
        fi
    done
    
    modules="$modules,\n    \"hyprland/workspaces\",\n    \"custom/screenrecording-indicator\",\n    \"custom/updatespacman\",\n    \"custom/update\",\n    \"hyprland/window\""
    echo "$modules"
}

update_config() {
    # Clone fresh copy to get current modules
    if [ -d "$TMP_DIR" ]; then
        rm -rf "$TMP_DIR"
    fi
    
    git clone "$REPO_URL" "$TMP_DIR" 2>/dev/null
    
    if [ ! -f "$TMP_DIR/config.jsonc" ]; then
        return 1
    fi
    
    # Get installed modules
    local new_modules
    new_modules=$(get_installed_modules)
    
    # Update config with new modules
    sed -i "/\"modules-left\": \[/,/\]/c\\
  \"modules-left\": [\\
$new_modules\\
  ]" "$TMP_DIR/config.jsonc"
    
    # Copy updated config
    cp "$TMP_DIR/config.jsonc" "$CONFIG_FILE"
    cp "$TMP_DIR/style.css" "$HOME/.config/waybar/style.css"
    
    rm -rf "$TMP_DIR"
    
    # Restart waybar
    omarchy restart waybar 2>/dev/null || pkill -SIGUSR2 waybar
}

# Initial check
update_config

# Watch for changes every 5 minutes
while true; do
    sleep 300
    update_config
done
