echo ">>> Installing noVNC" 
mkdir -p $NO_VNC_DIR/utils/websockify
wget -qO- https://github.com/novnc/noVNC/archive/v0.6.2.tar.gz | tar xz --strip 1 -C $NO_VNC_DIR
wget -qO- https://github.com/novnc/websockify/archive/v0.8.0.tar.gz | tar xz --strip 1 -C $NO_VNC_DIR/utils/websockify
ln -s $NO_VNC_DIR/vnc_auto.html $NO_VNC_DIR/index.html
