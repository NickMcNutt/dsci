#!/bin/bash

VNC_IP=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')

#vncserver -kill :1 || rm -rfv /tmp/.X*-lock /tmp/.X11-unix || echo "Remove old vnc locks to be a reattachable container"
vncserver $DISPLAY -depth $VNC_COLOR_DEPTH -geometry $VNC_RESOLUTION > /dev/null 2>&1
