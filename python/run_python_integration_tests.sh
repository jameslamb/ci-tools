#!/bin/bash

# [description]
#     This script runs Python integration tests
#     and measures the degree to which those tests cover
#     some library's code.
# [usage]
#     ./.ci/run_python_integration_tests.sh argparse 50 $(pwd)/integration_tests
# 

# failure is a natural part of life
set -e

LIBRARY_TO_COVER=${1}
COVERAGE_MIN=${2}
INTEGRATION_TEST_DIR=${3}

LIBRARY_LOC=$(
  dirname $(
      python3 -c "import ${LIBRARY_TO_COVER}; print(${LIBRARY_TO_COVER}.__file__)" \
  )
)

pushd ${INTEGRATION_TEST_DIR}
    pytest --cov=${LIBRARY_LOC}
    coverage report \
        -m \
        --fail-under=${COVERAGE_MIN}
popd
