#!/bin/bash

# [description]
#     Given a path to the source code of a Python package
#     that is installable with setup.py, this script will
#     build source distributions to be published to an
#     artifact repository or package manager.
# [usage]
#     ./.ci/build_python_package_dist.sh $(pwd)/py-pkg
# 

# failure is a natural part of life
set -e

PY_PKG_PATH=${1}

# Printing diagnostic information on the environment.
# See CONTRIBUTING.md
echo "Checking versions of publishing libraries"

# Print some information about the packaging environment.
echo "setuptools: $(python3 -c 'import setuptools; print(setuptools.__version__)')"
echo "wheel: $(python3 -c 'import wheel; print(wheel.__version__)')"
twine --version
pip freeze | grep pkginfo

echo "Building package tarball"
pushd ${PY_PKG_PATH}
    rm -f dist/*
    python3 setup.py sdist bdist_wheel
popd
echo "done"
