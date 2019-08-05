#!/bin/bash

# [description]
#     Set up miniconda3 on a Mac
# [usage]
#     ./.ci/set_up_conda.sh ${HOME}/miniconda3

CONDA_DIR=${1}

# failure is a natural part of life
set -e

MINICONDA_INSTALLER="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"

# Install conda
wget ${MINICONDA_INSTALLER} -O miniconda.sh;
bash miniconda.sh -b -p ${CONDA_DIR}

# Make sure everything is up to latest
# (this will require you to answer a prompt)
${CONDA_DIR}/bin/conda update conda

# check how the setup went
${CONDA_DIR}/bin/conda info -a
