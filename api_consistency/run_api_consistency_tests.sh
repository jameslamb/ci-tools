#!/bin/bash

# [description]
#     Run API consistency tests using doppel-cli. These
#     tests assume you have one R package and one Python
#     package with the same package name.
#
# [usage]
#     ./.ci/run_api_consistency_tests.sh $(pwd)/test_data 0 argparse

# failure is a natural part of life
set -e

TEST_DATA_DIR=${1}
ALLOWED_ERRORS=${2}
PACKAGE_NAME=${3}

mkdir -p ${TEST_DATA_DIR}

doppel-describe \
   -p ${PACKAGE_NAME} \
   --language R \
   --data-dir ${TEST_DATA_DIR}

doppel-describe \
   -p ${PACKAGE_NAME} \
   --language python \
   --data-dir ${TEST_DATA_DIR}

doppel-test \
   --files ${TEST_DATA_DIR}/python_${PACKAGE_NAME}.json,${TEST_DATA_DIR}/r_${PACKAGE_NAME}.json \
   --errors-allowed ${ALLOWED_ERRORS}

rm -rf ${TEST_DATA_DIR}
