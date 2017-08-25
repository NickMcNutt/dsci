echo ">>> Installing Anaconda"
echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh
wget --quiet https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh -O /tmp/anaconda.sh
/bin/bash /tmp/anaconda.sh -b -p /opt/conda
rm /tmp/anaconda.sh

echo ">>> Updating Anaconda"
conda update -y conda

echo ">>> Installing Anaconda"
conda install -y -c conda-forge \
    jupyter \
    matplotlib \
    notebook \
    pip \
    pdfminer.six \
    pyodbc \
    seaborn

echo ">>> Cleaning up Anaconda"
conda clean -tpy

# Make directory for Jupyter notebooks
mkdir /notebooks
