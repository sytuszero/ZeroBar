# ZeroBar

Beautiful waybar theme with Iraqi flag customization for Omarchy/Hyprland.

## Features
- Iraqi flag (🇮🇶) as menu icon with Tokyo Night blue background
- App launchers: Brave, VSCode, Steam, Telegram, Discord, Spotify, GitHub, OBS, YouTube
- System monitors: CPU usage, battery status, network, bluetooth, audio control
- Clock with calendar integration
- Tray icons support
- Weather display (wttrbar)
- Automatic updates checker (pacman + omarchy)
- Screen recording indicator
- Persistent workspaces with custom icons
- Hover effects and visual feedback
- Custom color scheme with Nerd Font icons

## Requirements
- **JetBrainsMono Nerd Font** (installed on Omarchy)

## Installation

```bash
rm -rf ~/.config/waybar && git clone https://github.com/sytuszero/ZeroBar.git /tmp/repo && cp -rf /tmp/repo/. ~/.config/waybar && rm -rf /tmp/repo && omarchy restart waybar
```

## Customization - Step by Step

### How to Edit the Configuration

**Step 1: Open the config file**

Using **nano** (easier for beginners):
```bash
nano ~/.config/waybar/config.jsonc
```

Using **nvim** (for advanced users):
```bash
nvim ~/.config/waybar/config.jsonc
```

**Step 2: Navigate in the file**

- In **nano**: Use arrow keys to move cursor
- In **nvim**: Press `j` to go down, `k` to go up, then press `i` to enter insert mode

**Step 3: Make your changes**

Edit the JSON values (see examples below), then:

- In **nano**: Press `Ctrl+X`, then `Y`, then `Enter` to save
- In **nvim**: Press `Esc`, type `:wq`, then `Enter` to save and quit

**Step 4: Restart waybar**

```bash
omarchy restart waybar
```

---

### Remove App Icons

**Example: Remove Spotify icon**

1. Open config: `nano ~/.config/waybar/config.jsonc`
2. Find the `modules-left` array (around line 15):
   ```json
   "modules-left": [
     "custom/omarchy",
     "custom/weather",
     "custom/files",
     "custom/brave",
     "custom/vscode",
     "custom/steam",
     "custom/telegram",
     "custom/discord",
     "custom/spotify",  ← DELETE this line
     "custom/github",
     ...
   ]
   ```
3. Delete the line: `"custom/spotify",`
4. Save and exit (Ctrl+X, Y, Enter in nano)
5. Restart waybar: `omarchy restart waybar`

---

### Change the Iraqi Flag Color

**Example: Change to green**

1. Open style file: `nano ~/.config/waybar/style.css`
2. Find line 99 (custom-omarchy section):
   ```css
   #custom-omarchy {
     background-color: #7aa2f7;  ← Change this to any color
     color: @cp-dark;
     font-size: 14px;
   }
   ```
3. Change `#7aa2f7` to your color (e.g., `#00ff00` for green)
4. Save and exit
5. Restart waybar: `omarchy restart waybar`

**Popular colors:**
- Red: `#ff0000`
- Green: `#00ff00`
- Blue: `#0000ff`
- Purple: `#800080`

---

### Change App Icons

**Example: Change Brave icon**

1. Open config: `nano ~/.config/waybar/config.jsonc`
2. Find `custom/brave` section (around line 260):
   ```json
   "custom/brave": {
     "format": "  ",  ← Change this icon
     "on-click": "brave",
     "tooltip": false
   }
   ```
3. Replace `` with any Nerd Font icon
4. Save and exit
5. Restart waybar: `omarchy restart waybar`

**Find icons:** Visit [Nerd Fonts Cheat Sheet](https://www.nerdfonts.com/cheat-sheet)

---

### Add Custom App Launcher

**Example: Add Firefox**

1. Open config: `nano ~/.config/waybar/config.jsonc`
2. Add to `modules-left` array (after a comma):
   ```json
   "custom/firefox",
   ```
3. Add module definition at the end (before the last `}`):
   ```json
   "custom/firefox": {
     "format": "  ",
     "on-click": "firefox",
     "tooltip": false
   }
   ```
4. Save and exit
5. Restart waybar: `omarchy restart waybar`

---

### Troubleshooting

**Waybar won't start?**
Check the log:
```bash
cat /tmp/waybar.log
```

**See the error?**
Edit config to fix, then restart waybar: `omarchy restart waybar`

**Config syntax error?**
- JSON requires **commas** between items
- Last item in array/object should **NOT** have a comma
- Strings must be in **double quotes**
