#!/bin/bash

# [description]
#     This script will look for the user-specific
#     site-packages directory (the place that pip puts
#     python packages when you do 'pip install --user') and
#     delete everything it finds there.
#
#     In the some projects, this can be used to ensure that
#     left over on the agents in CI clusters from previous builds
#     are eliminated so they don't conflict with our environment.
#
#     Yes that is a real thing.
# [usage]
#     ./ci/clean_user_site_packages.sh
#

# failure is a natural part of life
set -e

USER_SITE_PACKAGES_DIR=$(python -m site --user-site)

echo "pip install --user installs to \${local_dir}"

ALL_PKGS=$(ls ${USER_SITE_PACKAGES_DIR})

for pkg in ${ALL_PKGS}; do
    path_to_delete=${USER_SITE_PACKAGES_DIR}/${pkg}
    echo "Deleting '${path_to_delete}'"
    rm -r ${path_to_delete}
done;
