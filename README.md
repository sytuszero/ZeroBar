# ZeroBar

Beautiful waybar theme with Iraqi flag customization for Omarchy/Hyprland.

## Features
- Iraqi flag (🇮🇶) as menu icon
- Tokyo Night blue accent color
- Spotify, Steam, Discord, Telegram, and more app launchers

## Requirements
- **JetBrainsMono Nerd Font** (installed on Omarchy)

## Installation

```bash
rm -rf /tmp/zerobar && git clone https://github.com/sytuszero/ZeroBar.git /tmp/zerobar && cp -rf /tmp/zerobar/. ~/.config/waybar && rm -rf /tmp/zerobar && killall waybar 2>/dev/null; waybar &
```

## Customization

### Remove App Icons

Edit `~/.config/waybar/config.jsonc` and remove the modules you don't want:

1. **Remove from modules-left array** (around line 15-33):
   ```json
   "modules-left": [
     "custom/omarchy",
     "custom/weather",
     "custom/brave",        <-- Remove this line to remove Brave icon
     ...
   ]
   ```

2. **Remove the module definition** (search for the module name):
   ```json
   "custom/brave": {
     "format": "  ",
     "on-click": "brave",
     "tooltip": false
   }
   ```

3. **Restart waybar**:
   ```bash
   omarchy restart waybar
   ```

### Change Colors

Edit `~/.config/waybar/style.css` to customize colors. The Iraqi flag icon background is set to Tokyo Night blue (`#7aa2f7`) on line 99.
