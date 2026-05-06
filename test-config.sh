#!/bin/bash
echo "Checking waybar config..."
waybar -c config.jsonc -s style.css &
sleep 2
pkill waybar
