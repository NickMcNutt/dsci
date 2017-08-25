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
## Chrome
###############################################################################

COPY apps/chrome/init_chrome.sh $APPS/chrome/init_chrome.sh
COPY apps/chrome/Chromium.desktop $HOME/Desktop/Chromium.desktop

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

RUN \

# Update existing packages
    echo ">>> Updating existing packages" && \
    apt-get update --fix-missing && \

# Install misc. software
    apt-get install -y \
        build-essential \
        file \
        gosu \
        net-tools \
        sudo \
        tree \
        unzip \
        vim \
        wget && \

# Install Anaconda 3
    echo ">>> Installing Anaconda" && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh -O /tmp/anaconda.sh && \
    /bin/bash /tmp/anaconda.sh -b -p /opt/conda && \
    rm /tmp/anaconda.sh && \

    echo ">>> Updating Anaconda" && \
    conda update -y conda && \

    echo ">>> Installing Anaconda" && \
    conda install -y -c conda-forge \
        jupyter \
        matplotlib \
        notebook \
        pip \
        pdfminer.six \
        pyodbc \
        seaborn && \

    echo ">>> Cleaning up Anaconda" && \
    conda clean -tpy && \

    # Make directory for Jupyter notebooks
    mkdir /notebooks && \

# Install Chromium
    echo ">>> Installing Chrome" && \

    apt-get install -y \
        chromium-browser \
        chromium-browser-l10n \
        chromium-codecs-ffmpeg && \

    ln -s /usr/bin/chromium-browser /usr/bin/google-chrome && \

    # Fix Chrome to run in Docker
    echo "CHROMIUM_FLAGS='--start-maximized --user-data-dir'" > $HOME/.chromium-browser.init && \

# Install DBeaver
    echo ">>> Installing DBeaver" && \
    apt-get install -y \
        default-jre && \

    wget --quiet http://dbeaver.jkiss.org/files/4.1.3/dbeaver-ce_4.1.3_amd64.deb -O /tmp/dbeaver.deb && \
    dpkg -i /tmp/dbeaver.deb && \

# Install Firefox
    echo ">>> Installing Firefox" && \

    apt-get install -y \
        firefox=45* \
        libnss3-tools && \

# Install Julia v0.6
    echo ">>> Installing Julia v0.6" && \
    wget --quiet https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6-latest-linux-x86_64.tar.gz -O /tmp/julia-0.6.tar.gz && \
    mkdir -p /opt/julia-0.6/ && \
    tar -xzf /tmp/julia-0.6.tar.gz --strip-components 1 -C /opt/julia-0.6/ && \
    rm /tmp/julia-0.6.tar.gz && \
    ln -sf /opt/julia-0.6/bin/julia /usr/bin/j6 && \
    ln -sf /opt/julia-0.6/bin/julia /usr/bin/julia && \

    echo ">>> Installing Julia v0.6 packages" && \
    j6 -e "Pkg.init()" && \
    cp $APPS/julia/REQUIRE /opt/julia-pkgs/v0.6/ && \
    j6 -e "Pkg.resolve()" && \
    j6 $APPS/julia/prepare_packages.jl && \

# Install Julia v0.7
#    echo ">>> Installing Julia v0.7" && \
#    wget --quiet https://status.julialang.org/download/linux-x86_64 -O /tmp/julia-0.7.tar.gz && \
#    mkdir -p /opt/julia-0.7/ && \
#    tar -xzf /tmp/julia-0.7.tar.gz --strip-components 1 -C /opt/julia-0.7/ && \
#    rm /tmp/julia-0.7.tar.gz && \
#    ln -sf /opt/julia-0.7/bin/julia /usr/bin/j7 && \

# Add relevant Julia v0.7 packages
#    echo ">>> Installing Julia v0.7 packages" && \
#    j7 -e "Pkg.init()" && \
#    cp $APPS/julia/REQUIRE /opt/julia-pkgs/v0.7/ && \
#    j7 -e "Pkg.resolve()" && \
#    j7 $APPS/julia/prepare_packages.jl && \

# Install Jupyter notebook extensions
    echo ">>> Installing Jupyter notebook extensions" && \
    conda install -c conda-forge jupyter_contrib_nbextensions && \

# Install Jupyter Themes
    echo ">>> Installing Jupyter Themes" && \
    pip install jupyterthemes && \
    jt --theme grade3 -fs 9 -nfs 11 -tfs 11 -cellw 1000 && \

# Install noVNC
    echo ">>> Installing noVNC" && \
    mkdir -p $NO_VNC_DIR/utils/websockify && \
    wget -qO- https://github.com/novnc/noVNC/archive/v0.6.2.tar.gz | tar xz --strip 1 -C $NO_VNC_DIR && \
    wget -qO- https://github.com/novnc/websockify/archive/v0.8.0.tar.gz | tar xz --strip 1 -C $NO_VNC_DIR/utils/websockify && \
    ln -s $NO_VNC_DIR/vnc_auto.html $NO_VNC_DIR/index.html && \

# Install TigerVNC
    echo ">>> Installing TigerVNC" && \
    wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C / && \
    (echo $VNC_PASSWORD && echo $VNC_PASSWORD) | vncpasswd && \

# Install Xfce4 window manager
    echo ">>> Installing Xfce4" && \

    apt-get install -y \
        supervisor \
        xfce4 \
        xterm && \

    apt-get purge -y \
        pm-utils \
        xscreensaver* && \

# Remove temporary files
    echo ">>> Cleaning up" && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/tmp/*

###############################################################################
## Container initialization
###############################################################################

CMD ["/startup/startup.sh"]
