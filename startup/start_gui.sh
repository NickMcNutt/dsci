#!/bin/bash

(echo $VNC_PASSWORD && echo $VNC_PASSWORD) | vncpasswd > /dev/null

$APPS/tigervnc/start_tigervnc.sh
$APPS/novnc/start_novnc.sh
$APPS/xfce/start_xfce.sh
