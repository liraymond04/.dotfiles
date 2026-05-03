#!/usr/bin/env bash
# Laptop X11/Wayland environment configuration
# Used by both X11 (i3) and Wayland (Sway) sessions

# IME Setup (fcitx5)
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export GLFW_IM_MODULE=ibus
export XDG_RUNTIME_DIR=/run/user/"$UID"
export DBUS_SESSION_BUS_ADDRESS=unix:path="$XDG_RUNTIME_DIR"/bus

# XDG Base Directories
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# System Information
export NUMCPUS=$(grep -c '^processor' /proc/cpuinfo)

# QT Configuration (works on both X11 and Wayland)
export QT_QPA_PLATFORMTHEME=kde
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_FONT_DPI=96

# GTK Configuration
export GDK_DPI_SCALE=1

# Terminal Configuration
export KITTY_PLATFORM_CONF=default

# Determine if running Wayland or X11
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  # Wayland-specific settings (no Xft.dpi - use native scaling)
  export QT_SCALE_FACTOR=1
else
  # X11-specific settings
  export QT_SCALE_FACTOR=1
  [ -f ~/.Xdefaults ] && xrdb -merge ~/.Xdefaults
fi

# fcitx5 configuration for GUI
CONFIG_FILE="$HOME/.config/fcitx5/conf/classicui.conf"
if [ -f "$CONFIG_FILE" ]; then
  # Set font for laptop
  sed -i 's/^Font=.*/Font="Sans Serif 12"/' "$CONFIG_FILE"
fi
