#!/bin/bash

# ZeroBar App Watcher - Automatically updates waybar when apps are installed/removed

CONFIG_FILE="$HOME/.config/waybar/config.jsonc"
REPO_URL="https://github.com/sytuszero/ZeroBar.git"

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
    local modules="custom/omarchy custom/weather"
    
    for binary in "${!apps[@]}"; do
        if command -v "$binary" &>/dev/null; then
            modules="$modules ${apps[$binary]}"
        fi
    done
    
    modules="$modules custom/youtube"
    modules="$modules hyprland/workspaces"
    modules="$modules custom/screenrecording-indicator"
    modules="$modules custom/updatespacman"
    modules="$modules custom/update"
    modules="$modules hyprland/window"
    
    echo "$modules"
}

restart_waybar() {
    # Kill existing waybar
    if pgrep -x waybar > /dev/null; then
        killall waybar 2>/dev/null || true
        sleep 1
    fi
    
    # Restart waybar
    if command -v omarchy &>/dev/null; then
        omarchy restart waybar 2>/dev/null || waybar &
    else
        waybar &
    fi
}

update_config() {
    local TMP_DIR=$(mktemp -d /tmp/zerobar-check.XXXXXX)
    
    # Clone fresh copy
    git clone "$REPO_URL" "$TMP_DIR" 2>/dev/null || return 1
    
    if [ ! -f "$TMP_DIR/config.jsonc" ]; then
        rm -rf "$TMP_DIR"
        return 1
    fi
    
    # Get installed modules
    local new_modules
    new_modules=$(get_installed_modules)
    
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
        for m in '$new_modules'.split():
            output.append(f'    "{m}",\n')
        # Skip old modules
        bracket_count = 0
        for i, l in enumerate(lines):
            if '[' in l:
                bracket_count += 1
            if ']' in l:
                bracket_count -= 1
                if bracket_count == 0:
                    output.append(l)
                    break
    elif not in_modules:
        output.append(line)

with open('$TMP_DIR/config.jsonc', 'w') as f:
    f.writelines(output)
ENDPYTHON
    
    # Copy updated config
    cp "$TMP_DIR/config.jsonc" "$CONFIG_FILE"
    cp "$TMP_DIR/style.css" "$HOME/.config/waybar/style.css" 2>/dev/null || true
    
    rm -rf "$TMP_DIR"
    
    # Restart waybar
    restart_waybar
}

# Initial check
update_config

# Watch for changes every 5 minutes
while true; do
    sleep 300
    update_config
done
