#!/bin/bash

# [description]
#     This script runs unit tests for a Python
#     package. It uses pytest-cov to run the
#     tests and treats "failure" as either
#     "some of the tests failed" or
#     "test coverage was lower than allowed".
# [usage]
#     ./.ci/run_python_unit_tests.sh $(pwd)/py-pkg argparse $(pwd)/.coveragerc 50
#

# failure is a natural part of life
set -e

PKG_DIR=${1}
PKG_NAME=${2}
COV_CONFIG_FILE=${3}
PYTHON_COVERAGE_THRESHOLD=${4}

pushd ${PKG_DIR}

    pytest \
       --cov=${PKG_NAME} \
       --cov-config ${COV_CONFIG_FILE} \
       $(pwd)/tests/

    coverage report --fail-under=${PYTHON_COVERAGE_THRESHOLD} -m

popd
