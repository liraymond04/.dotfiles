# Dotfiles

Forked from [ChristianChiarulli's dotfiles](https://github.com/Mach-OS/Machfiles/)

![2022-04-27_22-47](https://user-images.githubusercontent.com/39678448/165678794-9971b3f0-041c-49ae-bdd3-26d12b329b80.png)

## Structure

This dotfiles repo is organized to support multiple machines and window managers using GNU stow:

```
dotfiles/
├── shared/                    # Common configs across all machines
│   ├── nvim/                 # Neovim configuration
│   ├── tmux/                 # Terminal multiplexer
│   ├── zsh/                  # Shell configuration
│   └── code/                 # VS Code settings
├── laptop/                    # Laptop-specific configuration (stow this on laptop)
│   ├── i3/                   # Original laptop i3 config
│   ├── hyprland/             # Laptop Hyprland config
│   ├── sway/                 # Wayland + nwg-shell setup
│   └── x/                    # X11/Wayland environment (DPI, fcitx5)
├── desktop/                   # Desktop-specific configuration (stow this on desktop)
│   ├── i3/                   # Desktop X11 window manager (polybar, rofi)
│   ├── hyprland/             # Desktop Wayland setup (waybar, tofi)
│   └── x/                    # X11-specific DPI and environment
├── shared/                    # Common configs across all machines
│   ├── fcitx5/               # Chinese IME environment variables
└── stow-wrapper.sh           # Automation script for stow commands
```

## Quick Start

### Prerequisites

You need `git`, GNU `stow`, and your chosen window manager installed:

```bash
# For Arhc Linux
sudo pacman -S git stow

# For laptop (Wayland + Sway)
sudo pacman -S sway swaync waybar wl-clipboard

# For desktop (X11 + i3)
sudo pacman -S i3-wm polybar rofi picom dunst
```

### Installation

Clone into your `$HOME` directory or `~` with submodules:

```bash
git clone --recurse-submodules https://github.com/liraymond04/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

Update submodules for existing repo:

```bash
git submodule update --init --recursive
```

### Setting Up Your Machine

#### Option 1: Automatic (Recommended)

Use the wrapper script to auto-detect your machine and apply the correct configuration:

```bash
./stow-wrapper.sh
```

This will detect your hostname and apply:
- **If hostname contains "laptop"**: `shared` + `laptop` + `terminal-emulators/kitty`
- **If hostname contains "desktop"**: `shared` + `desktop` + `terminal-emulators/kitty`

#### Option 2: Manual with Override

Force a specific configuration:

```bash
# Setup as laptop
./stow-wrapper.sh laptop

# Setup as desktop
./stow-wrapper.sh desktop

# Dry-run to preview changes
./stow-wrapper.sh --dry-run
```

## Machine Configuration Guide

### Laptop (Wayland + Sway)

**Setup:**
```bash
./stow-wrapper.sh laptop
```

**Features:**
- Wayland-native (Sway window manager)
- nwg-shell ecosystem (displays, panel, lock, screenshot)
- fcitx5 for Chinese input
- Lightweight, battery-aware configuration

**What gets symlinked:**
- `shared/` - nvim, tmux, zsh, code
- `laptop/i3/` - Original laptop i3 config
- `laptop/hyprland/` - Laptop Hyprland config
- `laptop/sway/` - Sway window manager config
- `laptop/x/` - Wayland environment (no Xft scaling)
- `terminal-emulators/kitty/` - Fast GPU terminal

**First boot:**
```bash
# fcitx5 is auto-started by Sway config
fcitx5 &

# Load your sway config
sway
```

### Desktop (X11 + i3)

**Setup:**
```bash
./stow-wrapper.sh desktop
```

**Features:**
- X11 + i3 window manager
- Polybar for statusbar
- Rofi for application launcher
- Multi-monitor support (xrandr-based)
- fcitx5 for Chinese input

**What gets symlinked:**
- `shared/` - nvim, tmux, zsh, code
- `desktop/i3/` - i3 window manager config
- `desktop/hyprland/` - Hyprland config
- `desktop/x/` - X11-specific DPI (192 dpi for high-res monitors)
- `terminal-emulators/kitty/` - Fast GPU terminal

**First boot:**
```bash
# fcitx5 is auto-started by i3 config
fcitx5 &

# Start i3
i3
```

## Configuration Details

### Shared Configs (All Machines)

| Directory | Purpose |
|-----------|---------|
| `shared/nvim` | Neovim with lazy.nvim plugin manager |
| `shared/tmux` | Terminal multiplexer with plugins |
| `shared/zsh` | Zsh with zinit, oh-my-posh, aliases |
| `shared/code` | VS Code settings and extensions |

### Platform-Specific Environment (laptop/x and desktop/x)

The `x/` directories in `laptop/` and `desktop/` contain platform-specific environment setup:

**desktop/x/.xprofile:**
- DPI scaling optimized for high-res monitors (QT_SCALE_FACTOR=2, Xft.dpi=192)
- i3 window manager environment
- Polybar and i3-specific settings

**laptop/x/.xprofile:**
- DPI scaling for laptop displays (QT_SCALE_FACTOR=1, Xft.dpi=96)
- Support for both X11 (i3) and Wayland (Sway)
- Conditional environment based on session type

### fcitx5 Chinese Input

fcitx5 is configured for both X11 and Wayland. Environment variables are set in:
- `laptop/x/.xprofile` or `desktop/x/.xprofile`
- `wayland-base/fcitx5/` (shared Wayland setup)

To use:
```bash
# fcitx5 is auto-started by i3 and Sway configs
# Manually start if needed:
fcitx5 -d

# Configure fcitx5
fcitx5-configtool
```

## Switching Window Managers

If you want to try different WMs on the same machine:

```bash
# Currently using laptop configs? Try desktop i3 + hyprland:
stow -D laptop
stow desktop

# Switch back to laptop configs:
stow -D desktop
stow laptop
```

## Troubleshooting

### DPI/Scaling Issues

**Problem:** Text is too small or too large on Sway/Wayland

**Solution:**
1. Check your monitor's native resolution and DPI
2. Edit `laptop/x/.xprofile` and adjust `QT_SCALE_FACTOR` (1 for normal, 1.5 for 150%, etc.)
3. For Wayland-native scaling, use Sway's output configuration:
   ```
   output DP-1 scale 1.5
   ```

**Problem:** Dolphin or GTK apps have wrong scaling/theming on Sway

**Solution:**
1. Wayland doesn't use Xft.dpi from `.Xdefaults`
2. Set `GDK_DPI_SCALE` and `QT_QPA_PLATFORMTHEME` in `.xprofile`
3. For per-app overrides, create `~/.config/gtk-3.0/settings.ini`

### fcitx5 Not Working

**Problem:** Chinese input not appearing in Sway/i3

**Solution:**
1. Verify fcitx5 is installed: `which fcitx5`
2. Check environment variables are set: `echo $GTK_IM_MODULE`
3. Restart fcitx5:
   ```bash
   pkill fcitx5
   fcitx5 -d
   ```
4. In Sway, verify your config includes:
   ```
   input * xkb_layout us
   exec fcitx5 -d
   ```

### Stow Conflicts

If `stow` reports conflicts when applying configs:

```bash
# Preview what would be done
./stow-wrapper.sh --dry-run

# If you're sure, have stow adopt existing files
stow --adopt <package>
```

## Installation of Dependencies

### Laptop (Sway + Wayland)

```bash
# Essential packages
sudo apt install sway swaync xwayland wl-clipboard

# Optional but recommended for nwg-shell integration
sudo apt install nwg-displays nwg-shell nwg-lock

# For extended functionality
sudo apt install waybar rofi fcitx5 cliphist
```

### Desktop (i3 + X11)

```bash
# Essential packages
sudo apt install i3 i3-wm i3status polybar rofi picom dunst parcellite feh

# Display management
sudo apt install xrandr arandr

# Input methods
sudo apt install fcitx5 fcitx5-chinese-addons

# Additional tools
sudo apt install nm-applet pavucontrol
```

## Updating Submodules

Some directories (like `nvim/`) may be git submodules. Update them with:

```bash
git submodule update --init --recursive --remote
```

## Additional Resources

- [GNU stow documentation](https://www.gnu.org/software/stow/manual/)
- [i3 configuration](https://i3wm.org/docs/userguide.html)
- [Sway configuration](https://github.com/swaywm/sway/wiki)
- [nwg-shell](https://github.com/nwg-piotr/nwg-shell)
- [fcitx5 setup](https://fcitx-im.org/wiki/Setup_Fcitx_5)

## License

These are my personal dotfiles. Feel free to fork and customize!

