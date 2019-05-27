import argparse
import subprocess
import sys

# Get input args
parser = argparse.ArgumentParser(
    description='Catch internal jargon in external-facing code and docs'
)
parser.add_argument(
    '--errors-allowed',
    type=int,
    default=0,
    help='Number of errors allowed before this test throws a non-zero exit code'
)
args = parser.parse_args()

reserved_words = [
    # example internal hostname
    '--ignore-case "qa\\."',
    # case-sensitive so we don't catch "autodoc"
    'TODO'
]

total_issues = 0
for keyword in reserved_words:
    cmd = "git grep {} | wc -l".format(keyword)
    issues_found = int(subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE).stdout.read())
    total_issues += issues_found
    print("{} instances of '{}' found".format(issues_found, keyword))

# Allow people to configure how sensitive this test is
exit_code = max(total_issues - args.errors_allowed, 0)
sys.exit(exit_code)
