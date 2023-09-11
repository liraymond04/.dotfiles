#!/bin/bash

title="Power:"
widthpercent=10

typeset -A menu
menu=(
    [Reboot]="systemctl reboot"
    [Shutdown]="systemctl poweroff"
    [Logout]="i3-msg exit"
    [Suspend]="systemctl suspend"
)
