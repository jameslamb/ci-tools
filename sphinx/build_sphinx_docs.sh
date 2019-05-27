#!/bin/bash

# [description]
#     Given a path to a dictory of documentation
#     to be created with sphinx, create the static
#     HTML for those docs and return a non-zero
#     exit code if any errors or warnings are raised.
#
#     NOTE: add "SPHINXOPTS    = -w warnings.txt" to 
#           docs/Makefile in your sphinx project to get
#           warnings dumped to a file
# [usage]
#     ./.ci/build_sphinx_docs.sh $(pwd)/docs
# 

# failure is a natural part of life
set -e

DOCS_DIR=${1}

pushd ${DOCS_DIR}
    make html
    exit $(cat warnings.txt | wc -l)
popd
