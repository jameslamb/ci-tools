
library(argparse)
library(covr)
library(futile.logger)

parser <- argparse::ArgumentParser(
    description = "Run tests, compute code coverage, and fail on low coverage"
)
parser$add_argument(
    "--source-dir"
    , help = "Directory with .R files in the package to be tested."
    , dest = "SOURCE_DIR"
)
parser$add_argument(
    "--test-dir"
    , help = "Directory with .R files in the package to be tested."
    , dest = "TEST_DIR"
)
parser$add_argument(
    "--fail-under"
    , help = "Code coverage threshold, from 0-100. If total coverage is below this, the build will fail."
    , dest = "FAIL_UNDER"
)
args <- parser$parse_args()

SOURCE_DIR <- args[["SOURCE_DIR"]]
TEST_DIR <- args[["TEST_DIR"]]
FAIL_UNDER <- as.numeric(args[["FAIL_UNDER"]])

# Use covr to run the tests
futile.logger::flog.info("Running integration tests...")

coverage <- covr::file_coverage(
    source_files = list.files(
        path = SOURCE_DIR
        , pattern = ".R"
        , full.names = TRUE
    )
    , test_files = list.files(
        path = TEST_DIR
        , pattern = "test-"
        , full.names = TRUE
    )
)
print(coverage)

total_coverage <- covr::percent_coverage(coverage)
futile.logger::flog.info(paste0("Total coverage: ", round(total_coverage, 2), "%"))

if (total_coverage < FAIL_UNDER){
    futile.logger::flog.fatal("Coverage below threshold. Failing.")
    quit(save = "no", status = 1)
}

futile.logger::flog.info("Done running integration tests")
