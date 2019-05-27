#!/bin/bash

# [description]
#     Given a conda env.yml file, create a conda env
#     from it if the named env in it does not exist,
#     otherwise try to update it.
# [usage]
#     ./.ci/make_conda_env.sh env.yml

# failure is a natural part of life
set -e

CONDA_ENV_FILE=${1}
CONDA_ENV_NAME=$(grep -A3 'name:' ${CONDA_ENV_FILE} | head -n1 | cut -c 7-)


if ! (conda env list | grep -q ${CONDA_ENV_NAME}); then
    echo "Building environment '${CONDA_ENV_NAME}' from file '${CONDA_ENV_FILE}."
    conda env create \
        --name ${CONDA_ENV_NAME} \
        -f ${CONDA_ENV_FILE}
else
    echo "conda env '${CONDA_ENV_NAME}' already exists. Checking if it needs to be updated."
    conda env update \
        --name ${CONDA_ENV_NAME} \
        -f ${CONDA_ENV_FILE}
fi

echo "Done"
