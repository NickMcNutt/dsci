echo ">>> Installing DBeaver"
apt-get install -y \
    default-jre

wget --quiet http://dbeaver.jkiss.org/files/4.1.3/dbeaver-ce_4.1.3_amd64.deb -O /tmp/dbeaver.deb
dpkg -i /tmp/dbeaver.deb

