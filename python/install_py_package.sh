#!/bin/bash

# [description]
#     Install a Python package from source
# [usage]
#     ./.ci/install_py_package.sh $(pwd)/py-pkg
# 

# failure is a natural part of life
set -e

SOURCE_DIR=${1}

pushd ${SOURCE_DIR}
    python3 setup.py develop --user
popd
