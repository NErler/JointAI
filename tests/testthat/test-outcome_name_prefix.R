# Outcomes whose names start in the same way: the parameters of one outcome must
# not be mistaken for those of the other.

prefix_data <- function() {
  set.seed(2026L)
  n <- nrow(wideDF)
  ordinal <- function(k) factor(sample(seq_len(k), n, TRUE), ordered = TRUE)

  data <- wideDF
  data$O1 <- ordinal(4L)
  data$O11 <- ordinal(3L)
  data$O12 <- ordinal(3L)
  data$Ord <- ordinal(3L)
  data$OrdA <- ordinal(3L)
  data$Ord.1 <- ordinal(3L)
  data$y <- rnorm(n)
  data$y.1 <- rnorm(n, 5)
  data
}

fit_two_outcomes <- function(first, second, fun = clm_imp) {
  formulas <- list(
    as.formula(paste(first, "~ C1")),
    as.formula(paste(second, "~ C1"))
  )
  suppressWarnings(fun(
    formulas,
    data = prefix_data(),
    n.adapt = 10L,
    n.iter = 10L,
    n.chains = 2L,
    seed = 2026L,
    progress.bar = "none",
    mess = FALSE,
    warn = FALSE
  ))
}

threshold_names <- function(outcome, n) {
  paste(outcome, ">", seq_len(n))
}

ordinal_cases <- list(
  c("O1", "O11"),
  c("O1", "O12"),
  c("Ord", "OrdA"),
  c("Ord", "Ord.1")
)

for (case in ordinal_cases) {
  first <- case[1L]
  second <- case[2L]
  n_first <- if (first == "O1") 3L else 2L

  test_that(paste("outcomes", first, "and", second), {
    fit <- fit_two_outcomes(first, second)

    gammas <- c(
      paste0("gamma_", first, "[", seq_len(n_first), "]"),
      paste0("gamma_", second, "[", 1:2, "]")
    )
    expect_setequal(
      grep("^gamma_", parameters(fit, mess = FALSE)$coef, value = TRUE),
      gammas
    )

    expected <- list(
      c("C1", threshold_names(first, n_first)),
      c("C1", threshold_names(second, 2L))
    )
    names(expected) <- case

    coefs <- suppressWarnings(coef(fit))
    intervals <- suppressWarnings(confint(fit))
    for (k in case) {
      expect_named(coefs[[k]], expected[[k]])
      expect_equal(rownames(intervals[[k]]), expected[[k]])
    }

    # summary() and print() run; each outcome has its own thresholds
    res <- suppressWarnings(summary(fit))
    expect_equal(nrow(res$res[[first]]$intercepts), n_first)
    expect_equal(nrow(res$res[[second]]$intercepts), 2L)
    expect_no_error(capture.output(print(fit)))
    expect_no_error(capture.output(print(res)))
  })
}

test_that("an element of a node does not select other parameters", {
  fit <- fit_two_outcomes("O1", "O11")
  selected <- get_subset(
    fit,
    subset = list(other = "gamma_O1[1]", analysis_main = FALSE),
    warn = FALSE,
    mess = FALSE
  )

  expect_equal(coda::varnames(selected), "gamma_O1[1]")
})

test_that("a dot in a name is not treated as a word boundary or any character", {
  fit <- fit_two_outcomes("y", "y.1", fun = lm_imp)
  res <- suppressWarnings(summary(fit))

  expect_equal(rownames(res$res$y$sigma), "sigma_y")
  expect_equal(rownames(res$res$y.1$sigma), "sigma_y.1")
})

test_that("get_intercepts() only uses the thresholds of the given outcome", {
  stats <- matrix(
    1:5,
    ncol = 1L,
    dimnames = list(
      c(
        "gamma_O1[1]",
        "gamma_O1[2]",
        "gamma_O11[1]",
        "gamma_O11[2]",
        "beta[1]"
      ),
      "Mean"
    )
  )

  expect_equal(
    rownames(get_intercepts(stats, "O1", lvls = 1:3)),
    c("O1 > 1", "O1 > 2")
  )
  expect_equal(
    rownames(get_intercepts(stats, "O11", lvls = 1:3)),
    c("O11 > 1", "O11 > 2")
  )
})
