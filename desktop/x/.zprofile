#!/usr/bin/env bash
# Desktop X11/Wayland environment configuration
# Optimized for multi-monitor X11 (i3) desktop setup

xrdb -merge ~/.Xresources

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

# DPI & Scaling (Desktop with high-res monitors)
export GDK_SCALE=1
export GDK_DPI_SCALE=1
export QT_ENABLE_HIGHDPI_SCALING=1

# QT Configuration
export QT_QPA_PLATFORMTHEME=kde
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=2
export QT_FONT_DPI=96
export KITTY_PLATFORM_CONF=i3

# fcitx5 configuration for GUI
CONFIG_FILE="$HOME/.config/fcitx5/conf/classicui.conf"
if [ -f "$CONFIG_FILE" ]; then
  # Set font for desktop
  sed -i 's/^Font=.*/Font="Sans Serif 12"/' "$CONFIG_FILE"
fi
