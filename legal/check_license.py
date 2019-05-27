import argparse
import glob
import re
import sys

# Get input args
parser = argparse.ArgumentParser(
    description='Check that files have the appropriate copyright header.'
)
parser.add_argument(
    '--source-dir',
    type=str,
    help='Path to a directory to check'
)
args = parser.parse_args()
SOURCE_DIR = args.source_dir

COPYRIGHT_TEXT = 'FILL ME IN'

PATTERNS_TO_CHECK = [
    f"{SOURCE_DIR}/**/*py",
    f"{SOURCE_DIR}/**/LICENSE"
]

files_to_check = []
for pattern in PATTERNS_TO_CHECK:
    files_to_check += [
        f for f in glob.glob(
            pattern,
            recursive=True
        )
    ]

print(f"found {len(files_to_check)} files")

error_count = 0
errors = []
for filename in files_to_check:

    with open(filename, 'r') as f:
        f_text = f.read()

    copyright_notice_missing = not bool(re.search(COPYRIGHT_TEXT, f_text))
    error_count += int(copyright_notice_missing)

    if copyright_notice_missing:
        msg = "[FATAL] File '{}' does not have the appropriate copyright notice. Add '{}' to a comment near the top of this file"
        msg = msg.format(filename, COPYRIGHT_TEXT)
        errors.append(msg)
    else:
        msg = "[INFO] File '{}' has the correct legal information."
        print(msg.format(filename))

if error_count > 0:
    sys.stdout.write(
        f"\n\nSome files do not have copyright header ({error_count})\n"
    )
    for i in range(len(errors)):
        msg = f"{i + 1}. {errors[i]}\n"
        sys.stdout.write(msg)

# Exit with non-zero code if ANY of the searched files didn't
# have the copyright header
sys.exit(error_count)
