# Regression tests for GitHub issue #15: model fitting failed when the package
# logistf was loaded. logistf imports formula.tools, which registers an
# `as.character()` method for formulas that returns the whole formula as one
# string (instead of c("~", lhs, rhs)). The tests below register such a method
# temporarily, so formula.tools itself is not needed.

# Evaluate `code` while a stand-in `as.character.formula()` is registered, and
# restore the previous state afterwards (formula.tools may already be loaded).
with_as_character_formula <- function(code) {
  tbl <- get(".__S3MethodsTable__.", envir = baseenv())
  had_method <- exists("as.character.formula", envir = tbl, inherits = FALSE)
  old_method <- if (had_method) get("as.character.formula", envir = tbl)

  on.exit({
    if (had_method) {
      assign("as.character.formula", old_method, envir = tbl)
    } else if (exists("as.character.formula", envir = tbl, inherits = FALSE)) {
      rm("as.character.formula", envir = tbl)
    }
  })

  assign(
    "as.character.formula",
    function(x, ...) paste(deparse(x), collapse = " "),
    envir = tbl
  )

  force(code)
}

test_that("the stand-in reproduces the formula.tools behaviour", {
  before <- as.character(y ~ x)
  with_as_character_formula(
    expect_length(as.character(y ~ x), 1L)
  )
  # and the previous state is restored afterwards
  expect_identical(as.character(y ~ x), before)
})

test_that("extract_fixef_formula() works with an as.character.formula method", {
  with_as_character_formula({
    expect_identical(deparse(extract_fixef_formula(B1 ~ B2 + C1 + C2)),
                     "B1 ~ B2 + C1 + C2")
    expect_identical(deparse(extract_fixef_formula(y ~ x + (1 | id))),
                     "y ~ x")
    expect_identical(
      deparse(extract_fixef_formula(Surv(time, status) ~ age + sex)),
      "Surv(time, status) ~ age + sex"
    )
  })
})

test_that("split_formula_list() works with an as.character.formula method", {
  with_as_character_formula({
    res <- split_formula_list(list(y ~ x + (1 | id), B1 ~ C1))

    expect_named(res$fixed, c("y", "B1"))
    expect_identical(vapply(res$fixed, deparse, ""),
                     c(y = "y ~ x", B1 = "B1 ~ C1"))
  })
})
