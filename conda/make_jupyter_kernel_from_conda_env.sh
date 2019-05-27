#!/bin/bash

# [description]
#     Given the name of a conda environment, make a
#     jupyter kernel out of it.
# [usage]
#     ./.ci/make_jupyter_kernel_from_conda_env.sh $(pwd)
# [references]
#     http://ipython.readthedocs.io/en/stable/install/kernel_install.html#kernels-for-different-environments

CONDA_ENV_NAME=${1}

# failure is a natural part of life
set -e

echo ""
echo "creating Jupyter notebook kernel from conda env '${CONDA_ENV_NAME}'"
echo ""

conda install \
    -y \
    nb_conda_kernels

source activate ${CONDA_ENV_NAME}

python -m ipykernel install \
    --user \
    --name ${CONDA_ENV_NAME} \
    --display-name "Python (${CONDA_ENV_NAME})"

echo ""
echo "Done. Try running 'jupyter notebook' and then choosing 'Python (${CONDA_ENV_NAME})' from the list of environments"
echo ""
