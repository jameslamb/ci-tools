#!/bin/bash

# [description]
#     Install an R package from source
# [usage]
#     ./.ci/install_r_package.sh $(pwd)/r-pkg
# 

# failure is a natural part of life
set -e

SOURCE_DIR=${1}

pushd ${SOURCE_DIR}
    
    Rscript -e "devtools::document()"
    R CMD INSTALL \
        --no-docs \
        .

popd
