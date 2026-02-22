#!/bin/bash

xrandr \
  --output eDP-1 --mode 2560x1600 --pos 0x0 \
  --output DP-2 --mode 2560x1440 --pos 2560x0 --primary --scale 1x1 --panning 2560x1440+2560+0

feh --bg-scale /usr/share/wallpapers/MilkyWay/contents/images/5120x2880.png
