# Pilot BI Ubuntu 16.04 base image
FROM ubuntu:16.04

# Maintainer
MAINTAINER Nick McNutt <nickmcnutt2@gmail.com>

ENV APPS /apps
ENV HOME /root
ENV START /startup

# Specify a display
ENV DISPLAY :1

# Specify default terminal color settings
ENV TERM xterm-256color

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
## Install software
###############################################################################

WORKDIR /install

RUN \

# Update existing packages
    ln -s $START/startup.sh /usr/bin/start && \
    echo ">>> Updating existing packages" && \
    apt-get update --fix-missing && \

# Install software
    ./misc.sh && \
    ./anaconda.sh && \
    ./jupyter-themes.sh && \
    ./julia-0.6.sh && \
    ./julia-0.7.sh && \

# Remove temporary files
    echo ">>> Cleaning up" && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/tmp/*

WORKDIR /root

###############################################################################
## Container initialization
###############################################################################

CMD ["/startup/startup.sh"]
