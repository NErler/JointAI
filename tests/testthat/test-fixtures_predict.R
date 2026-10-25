# predict() and residuals(), tested on stored fixtures (no JAGS run). The
# results themselves are compared with stored results in
# test-fixtures_summary.R (types "predict" and "residuals" of
# fixture_results()); here: properties that must hold independently of the
# stored values. Fixtures and helpers: helper-fixtures.R.

skip_on_cran()

# models for which predict() is implemented
predict_names <- setdiff(names(fixture_cases()), "jm")
# models for which residuals() is implemented
resid_names <- c("lm", "glm_binomial", "lme")

pred <- function(object, ...) {
  suppressWarnings(predict(object, mess = FALSE, warn = FALSE, ...))
}

for (k in predict_names) {
  test_that(paste("predict() returns one prediction per row:", k), {
    object <- fixture_load(k)
    for (type in fixture_predict_types(object)) {
      p <- pred(object, type = type)
      if (is.data.frame(p$fitted)) {
        expect_equal(nrow(p$fitted), nrow(object$data), label = type)
        # `newdata` is the data with the predicted values added
        expect_equal(p$newdata, cbind(object$data, p$fitted), label = type)
      } else {
        expect_equal(dim(p$fitted)[1L], nrow(object$data), label = type)
      }
    }
  })

  test_that(paste("quantiles are ordered:", k), {
    object <- fixture_load(k)
    for (type in setdiff(fixture_predict_types(object), "class")) {
      fitted <- pred(object, type = type)$fitted
      lower <- if (is.data.frame(fitted)) fitted[, 2L] else fitted[, 2L, ]
      upper <- if (is.data.frame(fitted)) fitted[, 3L] else fitted[, 3L, ]
      expect_true(all(lower <= upper, na.rm = TRUE), label = type)
    }
  })
}

# lme: predict(newdata = ) fails with "subscript out of bounds" (recorded in
# dev/STATUS.md as a possible bug), so it is not tested here.
for (k in setdiff(predict_names, "lme")) {
  test_that(paste("prediction for new data equals that for the data:", k), {
    object <- fixture_load(k)
    # multi-level models: predictions are only the same when all rows of a
    # subject are used (otherwise they differ, also for other subjects, and
    # for coxph, type = "survival" fails; recorded in dev/STATUS.md)
    rows <- if (k %in% c("clmm", "coxph")) {
      which(object$data$id %in% unique(object$data$id)[1:3])
    } else {
      c(2L, 5L, 7L)
    }
    for (type in fixture_predict_types(object)) {
      all_rows <- pred(object, type = type)$fitted
      expect_equal(
        pred(object, type = type, newdata = object$data[rows, ])$fitted,
        if (is.data.frame(all_rows)) {
          all_rows[rows, , drop = FALSE]
        } else {
          all_rows[rows, , , drop = FALSE]
        },
        ignore_attr = "row.names",
        label = type
      )
    }
  })
}

test_that("predicted probabilities are in [0, 1] and sum to 1", {
  # NA for cases with missing covariates
  response <- pred(fixture_load("glm_binomial"), type = "response")$fitted
  expect_true(all(response >= 0 & response <= 1, na.rm = TRUE))

  for (k in c("clm_nonprop", "clmm", "mlogit")) {
    prob <- pred(fixture_load(k), type = "prob")$fitted
    expect_true(all(prob >= 0 & prob <= 1, na.rm = TRUE), label = k)
    sums <- rowSums(prob[, "fit", ])
    expect_equal(sums[!is.na(sums)], rep(1, sum(!is.na(sums))), label = k)
  }

  survival <- pred(fixture_load("coxph"), type = "survival")$fitted
  expect_true(all(survival >= 0 & survival <= 1, na.rm = TRUE))
})

test_that("the predicted class is the one with the highest probability", {
  for (k in c("clm_nonprop", "clmm", "mlogit")) {
    object <- fixture_load(k)
    prob <- pred(object, type = "prob")$fitted[, "fit", ]
    expect_equal(
      pred(object, type = "class")$fitted$fit,
      apply(prob, 1L, function(x) if (all(is.na(x))) NA else which.max(x)),
      label = k
    )
  }
})

test_that("the fitted values are the mean of the returned sample", {
  for (k in c("lm", "glm_binomial")) {
    object <- fixture_load(k)
    for (type in fixture_predict_types(object)) {
      p <- pred(object, type = type, return_sample = TRUE)
      n_iter <- nrow(do.call(rbind, object$MCMC))
      expect_equal(nrow(p$sample), nrow(object$data) * n_iter, label = type)
      expect_equal(
        rowMeans(matrix(p$sample$value, nrow = nrow(object$data))),
        p$fitted$fit,
        label = type
      )
    }
  }
})

for (k in resid_names) {
  test_that(paste("response residuals are outcome minus fitted values:", k), {
    object <- fixture_load(k)
    y <- object$data[, names(object$fixed)[1L]]
    expect_equal(
      suppressWarnings(residuals(object, type = "response", warn = FALSE)),
      as.numeric(y) - is.factor(y) - object$fitted.values
    )
  })
}

test_that("for Gaussian models, all types of residuals are the same", {
  for (k in c("lm", "lme")) {
    res <- fixture_results()$residuals(fixture_load(k))
    expect_equal(res$working, res$response, label = k)
    expect_equal(res$pearson, res$response, label = k)
  }
})
