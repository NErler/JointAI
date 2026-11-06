# Arguments of *_imp() that are not arguments of model_imp() end up in the
# `...` of model_imp(), where they are not used. A misspelled argument (e.g.,
# `n.itre`) was silently ignored (#114); it now gives a warning that names it.
# The models are set up but not sampled.

skip_on_cran()

# all warnings from evaluating `expr`
collect_warnings <- function(expr) {
  warnings <- character(0)
  withCallingHandlers(
    expr,
    warning = function(w) {
      warnings <<- c(warnings, conditionMessage(w))
      invokeRestart("muffleWarning")
    }
  )
  warnings
}

# the warnings about unknown arguments
unknown_arg_warnings <- function(warnings) {
  grep("(is|are) unknown and", warnings, value = TRUE)
}

test_that("a misspelled argument gives a warning that names it (#114)", {
  warnings <- collect_warnings(
    mod <- lm_imp(
      y ~ C1,
      data = wideDF,
      n.adapt = 0,
      n.itre = 500,
      mess = FALSE
    )
  )
  expect_length(unknown_arg_warnings(warnings), 1L)
  # only the misspelled argument is named
  expect_match(
    unknown_arg_warnings(warnings),
    "The argument \"n.itre\" is unknown"
  )
  # the model is still set up, with the default number of iterations
  expect_s3_class(mod, "JointAI")
  expect_identical(mod$mcmc_settings$n.iter, 0)

  expect_warning(
    lme_imp(
      y ~ C1 + time + (1 | id),
      data = longDF,
      n.adapt = 0,
      monitor_parms = c(other_models = TRUE),
      mess = FALSE
    ),
    "\"monitor_parms\""
  )
})

test_that("several unknown arguments are named in one warning", {
  warnings <- collect_warnings(
    lm_imp(
      y ~ C1,
      data = wideDF,
      n.adapt = 0,
      n.itre = 500,
      monitor_parms = c(imps = TRUE),
      mess = FALSE
    )
  )
  w <- unknown_arg_warnings(warnings)
  expect_length(w, 1L)
  expect_match(w, "\"n.itre\" and \"monitor_parms\"")
})

test_that("unknown arguments passed on via `...` are named", {
  run <- function(fun, ...) fun(...)
  expect_warning(
    run(lm_imp, y ~ C1, data = wideDF, n.adapt = 0, n.itre = 5, mess = FALSE),
    "The argument \"n.itre\" is unknown"
  )
})

test_that("no warning about unknown arguments with warn = FALSE", {
  expect_no_warning(
    lm_imp(
      y ~ C1,
      data = wideDF,
      n.adapt = 0,
      n.itre = 5,
      mess = FALSE,
      warn = FALSE
    )
  )
})

test_that("the deprecated arguments keep their error", {
  for (arg in list(
    list(meth = c(C2 = "lm")),
    list(parallel = TRUE),
    list(n.cores = 2)
  )) {
    warnings <- collect_warnings(
      expect_error(
        do.call(
          lm_imp,
          c(list(y ~ C1 + C2, data = wideDF, n.adapt = 0, mess = FALSE), arg)
        ),
        "replaced|no longer used"
      )
    )
    expect_length(unknown_arg_warnings(warnings), 0L)
  }
})

test_that("no warning about unknown arguments for correct specifications", {
  # all models of the golden master (all *_imp() functions, and arguments that
  # are passed via `...`, e.g., trunc, rd_vcov, assoc_type, hyperpars)
  cases <- golden_cases()
  data <- golden_data()
  env <- list2env(data, parent = environment())

  for (k in names(cases)) {
    call <- as.call(c(
      as.list(cases[[k]]),
      list(n.adapt = 0, n.iter = 0, seed = 2020, mess = FALSE, warn = TRUE)
    ))
    warnings <- collect_warnings(eval(call, envir = env))
    expect_identical(unknown_arg_warnings(warnings), character(0), info = k)
  }

  # arguments that are only arguments of model_imp(), given with the default
  # value of model_imp()
  only_model_imp <- c(
    "scale_vars",
    "hyperpars",
    "custom",
    "append_data_list",
    "trunc",
    "keep_model",
    "overwrite",
    "quiet",
    "progress.bar",
    "keep_scaled_mcmc"
  )
  expect_true(all(only_model_imp %in% names(formals(model_imp))))
  expect_false(any(only_model_imp %in% names(formals(lm_imp))))
  warnings <- collect_warnings(
    do.call(
      lm_imp,
      c(
        list(y ~ C1, data = wideDF, n.adapt = 0, mess = FALSE),
        formals(model_imp)[only_model_imp]
      )
    )
  )
  expect_length(unknown_arg_warnings(warnings), 0L)
})
