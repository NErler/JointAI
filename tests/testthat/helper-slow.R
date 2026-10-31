# Slow tests: the test files that fit many JAGS models (one per model type,
# and test-survival.R) only run when the environment variable
# JOINTAI_SLOW_TESTS is "true", e.g.
#   Sys.setenv(JOINTAI_SLOW_TESTS = "true"); devtools::test()
# CRAN never sets it, so these tests are also skipped on CRAN.

run_slow_tests <- function() {
  identical(Sys.getenv("JOINTAI_SLOW_TESTS"), "true")
}

# The skip has to be inside each test_that(): testthat keeps the snapshots of
# a test only if the test is entered and then skipped.
skip_if_not_slow <- function() {
  testthat::skip_if_not(
    run_slow_tests(),
    "slow test (set JOINTAI_SLOW_TESTS=true to run it)"
  )
}
