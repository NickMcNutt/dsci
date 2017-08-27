#!/bin/bash

# Disable screensaver and power management
xset -dpms &
xset s noblank &
xset s off &

# Start Xfce window manager
/usr/bin/startxfce4 --replace > $HOME/xfce.log
#sleep 1
#cat $HOME/xfce.log
