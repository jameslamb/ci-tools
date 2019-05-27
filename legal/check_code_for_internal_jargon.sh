#!/bin/bash

# [description]
#     Check any customer-facing code or documentaiton
#     in the project for internal jargon or
#     other details like host names.
# [usage]
#     ./.ci/check_code_for_internal_jargon.sh "$(pwd)/py-pkg"
#

# failure is a natural part of life
set -e

DIRS_TO_CHECK=${1}

CHECK_SCRIPT=$(pwd)/ci/check_keywords.py

for DIR in ${DIRS_TO_CHECK}; do

    pushd ${DIR}
        python ${CHECK_SCRIPT} \
            --errors-allowed 0
    popd

done
