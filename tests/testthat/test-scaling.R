# Scaling of continuous covariates (R/scaling.R and where the scaling
# parameters are used). The models are set up but not sampled (golden_fit()
# from helper-golden.R). Overview: dev/SCALING.md (local notes).

skip_on_cran()

# names of the columns that are scaled
scaled_columns <- function(fit) {
  sp <- do.call(rbind, unname(fit$Mlist$scale_pars))
  if (is.null(sp)) {
    return(character(0))
  }
  sort(rownames(sp)[!is.na(sp$center)])
}

scale_case <- function(scale_vars) {
  golden_fit(
    substitute(
      lm_imp(y ~ C1 * C2 + B2, scale_vars = SV, data = wideDF),
      list(SV = scale_vars)
    ),
    golden_data()
  )
}

test_that("scale_vars selects the columns that are scaled", {
  all_cols <- scaled_columns(scale_case(NULL))
  expect_true(all(c("C1", "C2", "C1:C2") %in% all_cols))

  # only the named columns
  expect_identical(scaled_columns(scale_case("C1")), "C1")
  expect_identical(
    scaled_columns(scale_case(c("C1", "C1:C2"))),
    sort(c("C1", "C1:C2"))
  )
  # TRUE is the same as the default, FALSE means no scaling
  expect_identical(scaled_columns(scale_case(TRUE)), all_cols)
  expect_identical(scaled_columns(scale_case(FALSE)), character(0))
})
