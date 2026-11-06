# When `subset` selects only some of the regression coefficients, the output
# must still show each value under the name of its own coefficient.
# - summary(): all labels of the model were assigned to the selected columns
#   ("beta[3]" was shown as "(Intercept)", with a warning).
# - get_plotmain() (titles in traceplot(), densplot(), and the row names in
#   GR_crit(), MC_error()): for a single outcome, the labels were in the order
#   of the coefficients, the columns in the order of `subset`.
# Tested on the stored fixtures (no JAGS run). The reference is the output for
# all coefficients, in which every value has its correct label.

skip_on_cran()

object <- fixture_load("lm")
coefs <- object$coef_list$y # beta[1] = (Intercept), beta[2] = C1, ...

# selections of coefficients of the analysis model: a few, in reversed and
# in random order, and a single one
selections <- list(
  c("beta[3]", "beta[4]"),
  c("beta[4]", "beta[2]"),
  "beta[12]",
  rev(coefs$coef),
  local({
    set.seed(114)
    sample(coefs$coef, 6)
  })
)

test_that("summary() labels a subset of the coefficients correctly", {
  full <- summary(object)$res$y$regcoef
  for (sel in selections) {
    expect_no_warning(
      res <- summary(object, subset = list(analysis_main = FALSE, other = sel))
    )
    regcoef <- res$res$y$regcoef
    labels <- coefs$varnam_print[match(sel, coefs$coef)]
    expect_setequal(rownames(regcoef), labels)
    expect_identical(regcoef, full[rownames(regcoef), , drop = FALSE])
  }
})

test_that("summary() labels a subset of a covariate model correctly", {
  # B2 is a covariate (logistic model); alpha[k] are its coefficients
  full <- summary(object, subset = list(other_models = TRUE))$res$B2$regcoef
  b2 <- object$coef_list$B2
  sel <- b2$coef[c(3, 1)]
  expect_no_warning(
    res <- summary(object, subset = list(analysis_main = TRUE, other = sel))
  )
  regcoef <- res$res$B2$regcoef
  expect_setequal(rownames(regcoef), b2$varnam_print[c(3, 1)])
  expect_identical(regcoef, full[rownames(regcoef), , drop = FALSE])
})

test_that("get_plotmain() labels follow the order of the columns", {
  # property: permuting the columns permutes the labels in the same way, for
  # one and for several outcomes, with and without "outcome: " prefix, and
  # for names that are not coefficients (they stay as they are)
  set.seed(2026)
  for (k in names(fixture_cases())) {
    obj <- fixture_load(k)
    nams <- colnames(obj$MCMC[[1L]])
    main <- intersect(nams, obj$coef_list[[1L]]$coef)
    for (n in list(nams, main, c(main, "not_a_coef"))) {
      p <- sample(length(n))
      for (ylab in c(TRUE, FALSE)) {
        expect_identical(
          get_plotmain(obj, n[p], ylab = ylab),
          get_plotmain(obj, n, ylab = ylab)[p],
          info = paste(k, "ylab =", ylab)
        )
      }
    }
  }
  # the labels themselves
  expect_identical(
    get_plotmain(object, c("beta[4]", "beta[2]", "sigma_y")),
    c("B21", "C1", "sigma_y")
  )
})

test_that("GR_crit() and MC_error() label a subset of coefficients correctly", {
  full_gr <- GR_crit(object)$psrf
  capture.output(full_mce <- MC_error(object, mess = FALSE)$data_scale)
  for (sel in selections) {
    sub <- list(analysis_main = FALSE, other = sel)
    labels <- coefs$varnam_print[match(sel, coefs$coef)]

    gr <- GR_crit(object, subset = sub)$psrf
    expect_setequal(rownames(gr), labels)
    expect_identical(gr, full_gr[rownames(gr), , drop = FALSE])

    capture.output(mce <- MC_error(object, subset = sub, mess = FALSE))
    mce <- mce$data_scale
    expect_setequal(rownames(mce), labels)
    expect_identical(mce, full_mce[rownames(mce), , drop = FALSE])
  }
})

test_that("plot labels are correct by default in ordinal models with nonprop", {
  # mixed model with non-proportional effects and an interaction: the
  # coefficient table is not in the order of the coefficients (c1:C2 is
  # beta[8], but listed before beta[6] and beta[7]); model m5b in test-clmm.R
  mod <- clmm_imp(
    o1 ~ c1 * C2 + M2 + O2 + (1 | id),
    nonprop = list(o1 = ~ c1 + C2),
    data = longDF,
    n.adapt = 0,
    mess = FALSE,
    warn = FALSE
  )
  coefs <- mod$coef_list$o1
  # the MCMC columns are in the order of the index
  nams <- paste0("beta[", seq_len(nrow(coefs)), "]")
  # precondition: the case where the order differs
  expect_false(identical(coefs$coef, nams))

  expected <- coefs$varnam_print[match(nams, coefs$coef)]
  expect_identical(get_plotmain(mod, nams), expected)
  expect_identical(
    get_plotmain(mod, nams)[6:8],
    c("o12: C2", "o13: C2", "c1:C2")
  )
})
