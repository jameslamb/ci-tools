#!/bin/bash

# [description]
#     Given a conda env.yml file, create or update a
#     conda environment and make a Jupyter kernel
#     from it
# [usage]
#     ./.ci/make_conda_env_and_jupyter_kernel.sh env.yml

# failure is a natural part of life
set -e

CONDA_ENV_FILE=${1}
CONDA_ENV_NAME=$(grep -A3 'name:' ${CONDA_ENV_FILE} | head -n1 | cut -c 7-)

./bin/make_conda_env.sh ${CONDA_ENV_FILE}
./bin/make_jupyter_kernel_from_conda_env.sh ${CONDA_ENV_NAME}

echo "Done. Have a great day."
