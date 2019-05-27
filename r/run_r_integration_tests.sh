#!/bin/bash

# [description]
#     This script runs R integration tests
#     and measures the degree to which those tests cover
#     some library's code.
# [usage]
#     ./.ci/run_r_integration_tests.sh argparse 50 $(pwd)/integration_tests
# 

# failure is a natural part of life
set -e

LIBRARY_TO_COVER=${1}
COVERAGE_MIN=${2}
INTEGRATION_TEST_DIR=${3}

LIBRARY_LOC=$(pwd)/${LIBRARY_TO_COVER}/R

Rscript ./ci/run_r_integration_tests.R \
    --source-dir ${LIBRARY_LOC} \
    --test-dir ${INTEGRATION_TEST_DIR} \
    --fail-under ${COVERAGE_MIN}
