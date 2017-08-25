echo ">>> Installing TigerVNC"
wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C /
(echo $VNC_PASSWORD && echo $VNC_PASSWORD) | vncpasswd
