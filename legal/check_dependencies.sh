#!/bin/bash

# [description]
#     Given a path to the source code of a Python package
#     that is installable with setup.py, this script will
#     install it into a clean conda environment and then
#     use pip-licenses to check if it has introduced any
#     problematic licenses anywhere in the dependency tree.
#
#     To configure which licenses are considered "problematic"
#     and which libraries you want to explicitly allow, change
#     check_dependency_licenses.py
#
# [usage]
#     ./.ci/check_dependencies.sh $(pwd)/py-pkg $(pwd)/licenses.json
# 

# failure is a natural part of life
set -e

PY_PKG_PATH=${1}
OUT_FILE=${2:-tmp.json}
CONDA_ENV_NAME="license_check"

echo '[INFO] Checking for dependencies with scary licenses'

# Create env only if it doesn't exist
if ! (conda env list | grep -q "${CONDA_ENV_NAME}"); then \
    echo "${CONDA_ENV_NAME} conda environment doesn't exist. Creating..." && \
    conda create \
        -y \
        --name ${CONDA_ENV_NAME} \
        python=3.6; \
else
    echo "Conda env ${CONDA_ENV_NAME} already exists, not updating."
fi

source activate ${CONDA_ENV_NAME}

pushd ${PY_PKG_PATH}

    python -m pip install pip-licenses
    python setup.py install

popd

echo "Writing license info to ${OUT_FILE}"
pip-licenses \
    --with-urls \
    --format=json > ${OUT_FILE}
echo "Done writing license information"

source deactivate

echo "Tearing down conda env"
conda-env remove \
    -y \
    --name ${CONDA_ENV_NAME}
echo "Done"

python $(pwd)/legal/check_dependency_licenses.py \
    --file ${OUT_FILE}

echo "Removing data file ${OUT_FILE}"
rm ${OUT_FILE}

echo '[INFO] Done checking for dependencies with scary licenses'
