import argparse
import sys
from sys import stdout
import json

# Get input args
parser = argparse.ArgumentParser(
    description='Check that a Python package not taken on any recursive dependencies with troublesome licenses'
)
parser.add_argument(
    '--file',
    type=str,
    help='Full path to the JSON file with the results of pip-licenses'
)
args = parser.parse_args()
FILE_TO_CHECK = args.file

stdout.write("\nChecking for license violations\n")


class LicenseViolation:

    def __init__(self, pkg_name: str, msg: str):
        """
        Custom error class used to catch cases where
        we took on a dependency with an unknown or
        not-allowed license.
        """
        self.pkg_name = pkg_name
        self.msg = msg

    def __str__(self):
        return("{}: {}".format(self.pkg_name, self.msg))


# There is a lot of customization in these licenses.
# Using this to catch all the ones you've seen
# and approved for use
LICENSE_WHITELIST = [
    "3-clause BSD",
    "Apache 2.0",
    "BSD",
    "BSD 3-clause",
    "BSD License",
    "BSD license",
    "BSD or Apache License, Version 2.0",
    "http://www.apache.org/licenses/LICENSE-2.0",
    "MIT",
    "MIT License",
    "MIT license",
    "new BSD License"
]

# What pip-licenses can do is limited. Some
# packages will have license "UNKOWN". Here we
# record the results of manual review and links
# to those manually-reviewed licenses
PACKAGE_WHITELIST = [

    # MPL (Mozilla Public License)
    # We want to selectively whitelist individual MPL projects
    # based on the way they are used.
    "certifi",

    # LGPL
    # LGPL is like GPL but "softer" because it doesn't
    # require you to open-source derivative works
    # https://opensource.org/licenses/LGPL-3.0
    # However, we want to still selectively whitelist LGPL
    # dependencies based on our use of them.
    "chardet",

    # Custom license requiring attribution
    # https://github.com/dateutil/dateutil/blob/master/LICENSE
    "python-dateutil",

    # idna has a 'BSD-like' license but they also require attribution
    # https://github.com/kjd/idna/blob/master/LICENSE.rst
    "idna",

    # numpy uses BSD but requires attribution
    # https://github.com/numpy/numpy/blob/master/LICENSE.txt
    "numpy",

    # uuid is part of the Python standard lib, and is distributed
    # under the Python Software Foundation (PSF) license
    # https://github.com/python/cpython/blob/master/LICENSE
    "uuid"
]


with open(FILE_TO_CHECK, 'r') as f:
    deps = json.loads(f.read())

violations = []

for dep in deps:
    pkg_name = dep["Name"]
    license = dep["License"]

    approved_package = pkg_name in PACKAGE_WHITELIST
    approved_license = license in LICENSE_WHITELIST

    if approved_package or approved_license:
        stdout.write("{}: OK\n".format(pkg_name))
    else:
        stdout.write("{}: FAILED\n".format(pkg_name))
        msg = "license '{}'".format(license)
        violations.append(LicenseViolation(pkg_name, msg))

stdout.write("\nLicense violations ({})\n".format(len(violations)))
stdout.write("=======================\n")

i = 1
for violation in violations:
    msg = "{}. {}\n".format(i, str(violation))
    stdout.write(msg)
    i += 1

sys.exit(len(violations))
