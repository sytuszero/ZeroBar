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
curl -fsSL https://raw.githubusercontent.com/sytuszero/ZeroBar/main/install.sh | bash
```

## Customization

### Remove App Icons

Edit `~/.config/waybar/config.jsonc` and remove the modules you don't want:

1. **Remove from modules-left array** (around line 15-33):
   ```json
   "modules-left": [
     "custom/omarchy",
     "custom/weather",
     "custom/files",
     "custom/brave",        <-- Remove this line to remove Brave icon
     "custom/vscode",       <-- Remove this line to remove VSCode icon
     ...
   ]
   ```

2. **Remove the module definition** (search for the module name, e.g., "custom/brave"):
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
