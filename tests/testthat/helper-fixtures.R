# Fixtures: small fitted models for testing the post-processing functions
# (summary, predict, imputed data, convergence, plots, ...) without running
# JAGS. The fitted models are stored in tests/testthat/fixtures/, together with
# the expected results of the post-processing functions (fixtures/expected/).
# Both are created by tests/testthat/fixtures/make_fixtures.R; this must only be
# done with the maintainer's approval. When the structure of fitted objects is
# changed on purpose, the fixtures are re-created (with approval).
#
# The data are the same as for the golden master (golden_data() in
# helper-golden.R).

fixture_cases <- function() {
  list(
    # incomplete covariates of all types, an interaction, a transformation
    lm = quote(lm_imp(
      y ~ C1 + C2 + B2 + M2 + O2 + B2:C2 + I(C2^2),
      monitor_params = c(
        analysis_main = TRUE,
        other_models = TRUE,
        imps = TRUE
      ),
      data = wideDF
    )),
    glm_binomial = quote(glm_imp(
      B1 ~ C1 + C2 + B2 + M2,
      family = binomial(),
      data = wideDF
    )),
    clm_nonprop = quote(clm_imp(
      O1 ~ C1 + C2 + B2,
      nonprop = ~C1,
      data = wideDF
    )),
    mlogit = quote(mlogit_imp(M1 ~ C1 + C2 + B2, data = wideDF)),
    # random slope, incomplete time-varying covariates
    lme = quote(lme_imp(
      y ~ C1 + c1 + c2 + b2 + time,
      random = ~ time | id,
      rd_vcov = "full",
      monitor_params = c(
        analysis_main = TRUE,
        other_models = TRUE,
        imps = TRUE
      ),
      data = longDF
    )),
    clmm = quote(clmm_imp(o1 ~ C1 + c2 + time + (1 | id), data = longDF)),
    # time-varying covariate
    coxph = quote(coxph_imp(
      Surv(futime, status != "censored") ~ age + sex + platelet + (1 | id),
      timevar = "day",
      data = PBC_small
    )),
    survreg = quote(survreg_imp(
      Surv(futime, status != "censored") ~ age + sex + copper,
      data = PBC2_small
    )),
    # imputed values not monitored (they would make the file large)
    jm = quote(JM_imp(
      list(
        Surv(futime, status != "censored") ~ age + sex + chol + (1 | id),
        chol ~ day + age + (day | id)
      ),
      timevar = "day",
      data = PBC_small
    ))
  )
}

# Fit a fixture: short chains, fixed seed. The JAGS model itself is not kept
# (it cannot be saved).
fixture_fit <- function(case, data = golden_data()) {
  call <- as.call(c(
    as.list(case),
    list(
      n.adapt = 100,
      n.iter = 50,
      n.chains = 2,
      seed = 2020,
      mess = FALSE,
      warn = FALSE
    )
  ))
  env <- list2env(data, parent = environment())
  fit <- suppressWarnings(eval(call, envir = env))
  fit$model <- NULL
  fixture_formula_env(fit)
}

# The formulas in a fitted model refer to the environment they were created
# in; here that is the environment with all test data sets, which would be
# saved with each fixture. As for a model fitted by a user in the global
# environment, set the environment of formulas and terms objects to the global
# environment. Functions are not changed: the fixture must remain a working
# model.
fixture_formula_env <- function(x) {
  if (is.function(x)) {
    return(x)
  }
  if (!is.null(attr(x, ".Environment"))) {
    attr(x, ".Environment") <- globalenv()
  }
  if (is.list(x) && !is.data.frame(x)) {
    att <- attributes(x)
    # unclass(): avoid methods of `[[` (e.g., for package_version, x[[1]] is
    # again a package_version, which would never end)
    x <- lapply(unclass(x), fixture_formula_env)
    attributes(x) <- att
  }
  for (a in setdiff(names(attributes(x)), c("names", "dim", "dimnames"))) {
    attr(x, a) <- fixture_formula_env(attr(x, a))
  }
  x
}

fixture_path <- function(...) {
  testthat::test_path("fixtures", ...)
}

fixture_load <- function(name) {
  readRDS(fixture_path(paste0(name, ".rds")))
}

# Results of the post-processing functions that are stored and compared, by
# type ("summary", ...). Each element is a function of a fitted model.
fixture_results <- function() {
  list(
    summary = function(object) {
      unclass(suppressWarnings(summary(object, missinfo = TRUE, warn = FALSE)))
    },
    coef = function(object) suppressWarnings(coef(object, warn = FALSE)),
    confint = function(object) suppressWarnings(confint(object, warn = FALSE)),
    # random effects covariance matrices; they are not part of the summary
    # object, only of the printed summary. For models without random effects
    # the result (or error message) is stored as well.
    rd_vcov = function(object) {
      tryCatch(
        suppressWarnings(rd_vcov(object, mess = FALSE, warn = FALSE)),
        error = function(e) paste("Error:", conditionMessage(e))
      )
    },
    # fitted values and quantiles for each prediction type (only `fitted`:
    # `newdata` is the data with `fitted` added, see test-fixtures_predict.R)
    predict = function(object) {
      lapply(fixture_predict_types(object), function(type) {
        tryCatch(
          suppressWarnings(
            predict(object, type = type, mess = FALSE, warn = FALSE)$fitted
          ),
          error = function(e) paste("Error:", conditionMessage(e))
        )
      })
    },
    residuals = function(object) {
      types <- c("working", "pearson", "response")
      lapply(setNames(types, types), function(type) {
        tryCatch(
          suppressWarnings(residuals(object, type = type, warn = FALSE)),
          error = function(e) paste("Error:", conditionMessage(e))
        )
      })
    },
    parameters = function(object) parameters(object, mess = FALSE),
    # list_models() only prints; the printed lines are stored. The width
    # (line breaks of strwrap()) and straight quotes (dQuote()) are fixed, as
    # in testthat, so that the text does not depend on the session.
    list_models = function(object) {
      op <- options(width = 80, useFancyQuotes = FALSE)
      on.exit(options(op))
      capture.output(list_models(object))
    }
  )
}

# The prediction types (argument `type` of predict()) for the model type of the
# (first) analysis model of a fitted model.
fixture_predict_types <- function(object) {
  types <- switch(
    object$info_list[[1L]]$modeltype,
    glm = c("lp", "response"),
    glmm = c("lp", "response"),
    survreg = c("lp", "response"),
    clm = c("lp", "prob", "class"),
    clmm = c("lp", "prob", "class"),
    mlogit = c("lp", "prob", "class"),
    mlogitmm = c("lp", "prob", "class"),
    coxph = c("lp", "risk", "survival", "expected"),
    JM = "lp",
    stop(
      "No prediction types for model type ",
      object$info_list[[1L]]$modeltype
    )
  )
  setNames(types, types)
}

fixture_expected <- function(name, type) {
  readRDS(fixture_path("expected", paste0(name, "_", type, ".rds")))
}
