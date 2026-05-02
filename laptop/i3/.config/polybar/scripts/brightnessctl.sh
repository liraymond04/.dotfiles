#!/bin/bash
BRIGHTNESS_VALUE=`brightnessctl | grep -o "(.*" | tr -d "()"`

printf "%4s" $BRIGHTNESS_VALUE

