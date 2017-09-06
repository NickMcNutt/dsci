#!/bin/bash

# Start GUI - noVNC, TigerVNC, Xfce4
source $START/start_gui.sh

# Create default Firefox profile

source $APPS/firefox/init_firefox.sh

# Trust Jupyter notebooks
find /notebooks -name '*.ipynb' -exec jupyter trust {} +

exec /bin/bash -l
