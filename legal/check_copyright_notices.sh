#!/bin/bash

# [description]
#     Check all source code in a directory
#     for the appropriate copyright headers.
#
#     Customize legal/check_license.py to change
#     the file extensions matched and the
#     content searched for.
#
# [usage]
#     ./.ci/check_copyright_notices.sh $(pwd)
#

# failure is a natural part of life
set -e

DIRS_TO_CHECK=${1}

CHECK_SCRIPT=$(pwd)/ci/check_license.py

for DIR in ${DIRS_TO_CHECK}; do

    echo ""
    echo "[INFO] Checking for copyright notice in source code in ${DIR}"
    echo ""

    python ${CHECK_SCRIPT} \
        --source-dir ${DIR}
    
    echo ""
    echo '[INFO] Done checking for copyright notice in source code'
    echo ""

done
