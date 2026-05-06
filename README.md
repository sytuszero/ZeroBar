# ZeroBar

Beautiful waybar theme with Iraqi flag customization for Omarchy/Hyprland.

## Features
- Iraqi flag (🇮🇶) as menu icon
- Tokyo Night blue accent color
- Spotify, Steam, Discord, Telegram, and more app launchers
- Arabic keyboard layout support (US/Arabic toggle with CapsLock)

## Requirements
- **JetBrainsMono Nerd Font** (automatically installed with the command below)

## Installation

```bash
git clone https://github.com/sytuszero/ZeroBar.git /tmp/zerobar && paru -S ttf-jetbrains-mono-nerd --noconfirm 2>/dev/null || yay -S ttf-jetbrains-mono-nerd --noconfirm 2>/dev/null || echo "Please install ttf-jetbrains-mono-nerd manually" && cp -rf /tmp/zerobar/. ~/.config/waybar && rm -rf /tmp/zerobar && omarchy restart waybar
```
