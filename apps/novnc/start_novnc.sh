#!/bin/bash

VNC_IP=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')

$NO_VNC_DIR/utils/launch.sh --vnc $VNC_IP:$VNC_PORT --listen $NO_VNC_PORT > /dev/null 2>&1 &
