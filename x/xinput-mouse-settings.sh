#!/bin/bash

# echo "test" > /tmp/out.txt
sleep 1
xinput set-prop "Logitech USB Receiver" "libinput Accel Profile Enabled" 0 1
xinput set-prop "Logitech USB Receiver" "libinput Accel Speed" -0.5
