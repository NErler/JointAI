# Golden master: the deterministic stages of model fitting (data checks,
# design matrices, model types, model info, data list, JAGS model text,
# parameters to monitor, initial values) must give the same results as stored
# in tests/testthat/golden/. JAGS is not run (n.adapt = 0, n.iter = 0).
# Cases, data and helpers: helper-golden.R.
# If a difference is intended, the files are re-created with
# golden/make_golden.R, but only with the maintainer's approval.

skip_on_cran()

golden_cases_list <- golden_cases()
golden_data_list <- golden_data()

test_that("there is a golden master file for every case", {
  files <- list.files(test_path("golden"), pattern = "\\.rds$")
  expect_setequal(
    setdiff(sub("\\.rds$", "", files), "info"),
    names(golden_cases_list)
  )
})

for (k in names(golden_cases_list)) {
  test_that(paste("golden master:", k), {
    expected <- readRDS(test_path("golden", paste0(k, ".rds")))
    expect_equal(golden_fit(golden_cases_list[[k]], golden_data_list), expected)
  })
}
