#!/bin/bash

# ZeroBar App Watcher - Simple version

CONFIG_FILE="$HOME/.config/waybar/config.jsonc"
STYLE_FILE="$HOME/.config/waybar/style.css"
REPO_URL="https://github.com/sytuszero/ZeroBar.git"

restart_waybar() {
    if pgrep -x waybar > /dev/null; then
        killall waybar 2>/dev/null || true
        sleep 2
    fi
    waybar > /tmp/waybar.log 2>&1 &
}

# Initial restart
restart_waybar

# Watch for changes every 5 minutes
while true; do
    sleep 300
    restart_waybar
done
