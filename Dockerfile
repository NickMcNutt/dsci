# Pilot BI Ubuntu 16.04 base image
FROM ubuntu:16.04

# Maintainer
MAINTAINER Nick McNutt <nickmcnutt2@gmail.com>

ENV APPS /apps
ENV HOME /root
ENV STARTUP /startup

# Disable user prompts during window manager install
ENV DEBIAN_FRONTEND noninteractive

# Specify a display
ENV DISPLAY :1

COPY install/ /install/

###############################################################################
## Anaconda 
###############################################################################

# Specify to Python path
ENV PYTHON /opt/conda/bin/python

# Add Conda to path
ENV PATH /opt/conda/bin:$PATH

# Specify to matplotlib to not use a GUI backend
ENV MPLBACKEND Agg

###############################################################################
## DBeaver
###############################################################################

COPY ["apps/dbeaver/DBeaver CE.desktop", "$HOME/Desktop/DBeaver CE.desktop"]

###############################################################################
## Firefox
###############################################################################

COPY apps/firefox/init_firefox.sh $APPS/firefox/init_firefox.sh
COPY apps/firefox/firefox-prefs.js $HOME/.mozilla/firefox/default/prefs.js
COPY apps/firefox/Firefox.desktop $HOME/Desktop/Firefox.desktop

###############################################################################
## Julia
###############################################################################

# Specify default package directory (instead of ~/.julia)
ENV JULIA_PKGDIR /opt/julia-pkgs/

# Specify to Julia which Conda environment to use
ENV CONDA_JL_HOME /opt/conda/

# Copy Julia package requirements
COPY apps/julia/REQUIRE $APPS/julia/REQUIRE

# Copy Julia script to prepare packages
COPY apps/julia/prepare_packages.jl $APPS/julia/prepare_packages.jl

###############################################################################
## Jupyter
###############################################################################

# Expose port for Jupyter notebook
EXPOSE 3000

# Default Jupyter notebook configuration file
COPY apps/jupyter/jupyter_notebook_config.py $HOME/.jupyter/jupyter_notebook_config.py

###############################################################################
## noVNC
###############################################################################

# noVNC server port
ENV NO_VNC_PORT 6901

EXPOSE $NO_VNC_PORT

ENV NO_VNC_DIR /opt/novnc

COPY apps/novnc/start_novnc.sh $APPS/novnc/start_novnc.sh

###############################################################################
## TigerVNC
###############################################################################

# VNC server port
ENV VNC_PORT 5901

EXPOSE $VNC_PORT

ENV VNC_DIR /opt/tigervnc

# VNC color depth
ENV VNC_COLOR_DEPTH 32

# VNC screen resolution
ENV VNC_RESOLUTION 1280x1024

# VNC password
ENV VNC_PASSWORD vncpassword

COPY apps/tigervnc/start_tigervnc.sh $APPS/tigervnc/start_tigervnc.sh

###############################################################################
## Xfce
###############################################################################

COPY apps/xfce/start_xfce.sh $APPS/xfce/start_xfce.sh
COPY apps/xfce/xfce4 $HOME/.config/xfce4

###############################################################################
## Startup
###############################################################################

COPY startup/startup.sh $STARTUP/startup.sh
COPY startup/start_gui.sh $STARTUP/start_gui.sh

###############################################################################
## Install software
###############################################################################

WORKDIR /install

RUN \

# Update existing packages
    echo ">>> Updating existing packages" && \
    apt-get update --fix-missing && \

# Install software
    ./misc.sh && \
    ./novnc.sh && \
    ./tigervnc.sh && \
    ./xfce.sh && \
    ./dbeaver.sh && \
    ./firefox.sh && \
    ./anaconda.sh && \
    ./jupyter-notebook-extensions.sh && \
    ./jupyter-themes.sh && \
    ./julia-0.6.sh && \

# Remove temporary files
    echo ">>> Cleaning up" && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/tmp/*

###############################################################################
## Container initialization
###############################################################################

CMD ["/startup/startup.sh"]
