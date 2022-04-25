#!/bin/bash
engine=$(ibus engine)

# Set your engine here
ENGLISH="xkb:us::eng"
CHINESE="pinyin"

if [[ "$engine" == "$ENGLISH" ]]; then
    ibus engine $CHINESE
    polybar-msg hook ibus 1 &>/dev/null || true
    #  Comment line below if you dont want to recive notification
    # dunstify -h string:x-dunst-stack-tag:ibus -A 'ibus,default' -a "IBUS" -i "~/.config/polybar/scripts/flags/vietnam.svg" "VI"
else
    ibus engine $ENGLISH
    polybar-msg hook ibus 1 &>/dev/null || true
    #  Comment line below if you dont want to recive notification
    # dunstify -h string:x-dunst-stack-tag:ibus -A 'ibus,default' -a "IBUS" -i "~/.config/polybar/flags/226-united-states.svg" "US"
fi