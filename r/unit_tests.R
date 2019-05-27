
library(argparse)
library(covr)
library(futile.logger)

parser <- argparse::ArgumentParser(
    description = "Run tests, compute code coverage, and fail on low coverage"
)
parser$add_argument(
    "--fail-under"
    , help = "Code coverage threshold, from 0-100. If total coverage is below this, the build will fail."
    , dest = "FAIL_UNDER"
)
parser$add_argument(
    "--source-dir"
    , help = "Path to an R package"
    , dest = "SOURCE_DIR"
)
args <- parser$parse_args()

FAIL_UNDER <- args[["FAIL_UNDER"]]


# Use covr to run the tests
futile.logger::flog.info("Running unit tests...")
Sys.setenv('TRAVIS' = 'true')

coverage <- covr::package_coverage(
    path = args[["SOURCE_DIR"]]
    , quiet = FALSE
    , errorsAreFatal = TRUE
)
print(coverage)

total_coverage <- covr::percent_coverage(coverage)
futile.logger::flog.info(paste0("Total coverage: ", round(total_coverage, 2), "%"))

if (total_coverage < FAIL_UNDER){
    futile.logger::flog.fatal("Coverage below threshold. Failing.")
    quit(save = "no", status = 1)
}

futile.logger::flog.info("Done running tests")
