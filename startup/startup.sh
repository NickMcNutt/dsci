#!/bin/bash

# Trust Jupyter notebooks
find /notebooks -name '*.ipynb' -exec jupyter trust {} +

if [[ $# -eq 0 ]] ; then
    exec /bin/bash -l
else
    exec "$@"
fi
