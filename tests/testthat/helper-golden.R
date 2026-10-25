# Golden master of the deterministic stages of model fitting.
#
# For each case below, the model is set up with n.adapt = 0 and n.iter = 0:
# all pre-processing (data checks, design matrices, model types, model info,
# data list, JAGS model text, parameters to monitor, initial values) is done,
# but JAGS is not run. The results are stored in tests/testthat/golden/ and
# compared in test-golden_master.R. The stored files are (re-)created with
# tests/testthat/golden/make_golden.R; this must only be done with the
# maintainer's approval (like accepting snapshots).
#
# The cases are edge cases from the other test files (file:model in the
# comments): minimal models, transformations and functions of covariates,
# interactions, special arguments, and several (nested / crossed) levels.

# Data used by the cases --------------------------------------------------------
# The extra variables are generated as in the other test files, but the golden
# master does not depend on these data being identical to those used there.
golden_data <- function() {
  set.seed(1234)
  wideDF <- JointAI::wideDF
  wideDF$P1 <- rpois(nrow(wideDF), 3)
  wideDF$P2 <- rpois(nrow(wideDF), 2)
  wideDF$P2[sample.int(nrow(wideDF), 20)] <- NA
  wideDF$L1mis <- wideDF$L1
  wideDF$L1mis[sample.int(nrow(wideDF), 20)] <- NA
  wideDF$Be1 <- plogis(rnorm(nrow(wideDF)))
  wideDF$Be2 <- plogis(rnorm(nrow(wideDF)))
  wideDF$Be2[sample.int(nrow(wideDF), size = 20)] <- NA

  longDF <- JointAI::longDF
  longDF$L1 <- rgamma(nrow(longDF), 2, 4)
  longDF$L1mis <- rgamma(nrow(longDF), 2, 4)
  longDF$L1mis[sample.int(nrow(longDF), 20)] <- NA
  longDF$Be1 <- plogis(longDF$time - longDF$C1)
  longDF$Be2 <- plogis(longDF$y + longDF$c1)
  longDF$Be2[c(1:20) * 5] <- NA
  longDF$m1 <- factor(sample(c("A", "B", "C"), nrow(longDF), replace = TRUE))
  longDF$m2 <- factor(sample(c("A", "B", "C"), nrow(longDF), replace = TRUE))
  longDF$m2[sample.int(nrow(longDF), 50)] <- NA
  longDF$x <- factor(longDF$o1, ordered = FALSE)
  # subjects nested in centers
  longDF$center <- cut(
    as.numeric(longDF$id),
    breaks = quantile(as.numeric(longDF$id), seq(0, 1, length.out = 6)),
    include.lowest = TRUE
  )

  PBC <- JointAI::PBC
  PBC$center <- cut(as.numeric(PBC$id), c(-Inf, seq(30, 270, 30), Inf))
  PBC2 <- PBC[match(unique(PBC$id), PBC$id), ]
  # smaller data for the joint model (its data list is large)
  PBC_jm <- droplevels(PBC[PBC$id %in% unique(PBC$id)[1:60], ])

  list(
    wideDF = wideDF,
    longDF = longDF,
    NHANES = JointAI::NHANES,
    PBC = PBC,
    PBC2 = PBC2,
    PBC_jm = PBC_jm
  )
}


# Cases ------------------------------------------------------------------------
golden_cases <- function() {
  list(
    # minimal models
    lm_intercept = quote(lm_imp(y ~ 1, data = wideDF)), # glm.R:m0a1
    glm_cloglog_intercept = quote(glm_imp(
      B1 ~ 1,
      family = binomial(link = "cloglog"),
      data = wideDF
    )), # glm.R:m0b4
    mlogit_intercept = quote(mlogit_imp(M1 ~ 1, data = wideDF)), # mlogit.R:m0a
    clm_intercept = quote(clm_imp(O1 ~ 1, data = wideDF)), # clm.R:m0a
    coxph_intercept = quote(coxph_imp(
      Surv(futime, status != "censored") ~ 1,
      data = PBC2
    )), # coxph.R:m0a

    # transformations and functions of covariates
    lm_spline_powers = quote(lm_imp(
      SBP ~ ns(age, df = 2) + gender + I(bili^2) + I(bili^3),
      data = NHANES
    )), # glm.R:mod7a
    lm_spline_ratio = quote(lm_imp(
      SBP ~ ns(age, df = 2) + gender + I(bili^2) + I(bili / age),
      data = NHANES
    )), # auxvars.R
    lm_log_exp_models = quote(lm_imp(
      SBP ~ age + gender + log(bili) + exp(creat),
      models = c(bili = "glm_gamma_inverse", creat = "lm"),
      data = NHANES
    )), # glm.R:m6f
    clm_ifelse_abs = quote(clm_imp(
      O1 ~ ifelse(as.numeric(O2) > as.numeric(M1), 1, 0) *
        abs(C1 - C2) +
        log(C1),
      data = wideDF
    )), # clm.R:m4b
    glm_abs_log_models = quote(glm_imp(
      B1 ~ L1mis + abs(C1 - C2) + log(Be2),
      models = c(
        C2 = "glm_gaussian_log",
        L1mis = "glm_gamma_inverse",
        Be2 = "beta"
      ),
      family = binomial(),
      data = wideDF
    )), # glm.R:m4b
    lm_trafo_auxvars = quote(lm_imp(
      y ~ C1 + I(time / C2),
      auxvars = ~ I(C1^2),
      data = wideDF
    )), # auxvars.R

    # interactions and special arguments
    clm_nonprop_interaction = quote(clm_imp(
      O1 ~ C1 + M2 * C2 + O2,
      nonprop = ~ C1 + M2 * C2 + O2,
      data = wideDF
    )), # clm.R:m5e
    lm_covariate_models_trunc = quote(lm_imp(
      C1 ~ C2 + B2 + P2 + L1mis + Be2,
      trunc = list(Be2 = c(0, 1)),
      models = c(
        C2 = "glm_gaussian_log",
        P2 = "glm_poisson_identity",
        L1mis = "glm_gamma_log",
        B2 = "glm_binomial_log"
      ),
      data = wideDF
    )), # glm.R:m3d
    mlogitmm_refcats_models = quote(mlogitmm_imp(
      x ~ C1 + p1 + B2 + O2 + c2 + y * time + (time | id),
      models = c(p1 = "glmm_poisson_log"),
      refcats = c(O2 = 3),
      data = longDF
    )), # printfcts.R

    # multi-level models
    glme_complex = quote(glme_imp(
      b1 ~ L1mis + abs(c1 - C2) + log(Be2) + time + (time + I(time^2) | id),
      models = c(
        C2 = "glm_gaussian_log",
        L1mis = "glmm_gamma_inverse",
        Be2 = "glmm_beta"
      ),
      shrinkage = "ridge",
      family = binomial(),
      data = longDF
    )), # glmm.R:m5b
    lme_spline_random = quote(lme_imp(
      y ~ C1 + C2 + c1 + ns(time, df = 3),
      random = ~ ns(time, df = 3) | id,
      no_model = "time",
      data = longDF
    )), # glmm.R:m7e
    lme_interaction_random = quote(lme_imp(
      y ~ c1 + C1 * time + b1 + B2,
      random = ~ C1 * time | id,
      data = longDF
    )), # glmm.R:m8n
    clmm_ifelse_abs = quote(clmm_imp(
      o1 ~ ifelse(as.numeric(o2) > as.numeric(M1), 1, 0) *
        abs(C1 - C2) +
        log(C1) +
        (1 | id),
      data = longDF
    )), # clmm.R:m4b
    mlogitmm_random_interaction = quote(mlogitmm_imp(
      m1 ~ time + c1 + C1 + B2 + (c1 * time | id),
      data = longDF
    )), # mlogitmm.R:m4c
    lme_many_covariate_types = quote(lme_imp(
      c1 ~ c2 + b2 + p2 + L1mis + Be2 + (1 | id),
      trunc = list(Be2 = c(0, 1)),
      shrinkage = "ridge",
      models = c(
        c2 = "glmm_gaussian_log",
        p2 = "glmm_poisson_identity",
        L1mis = "glmm_gamma_log",
        b2 = "glmm_binomial_log"
      ),
      data = longDF
    )), # glmm.R:m4d
    lme_multiple_outcomes = quote(lme_imp(
      list(
        y ~ C1 + B1 + c2 + (1 | id),
        c1 ~ B1 + B2 + c2 + (1 | id),
        B2 ~ C1
      ),
      data = longDF
    )), # modeltypes.R
    lme_crossed = quote(lme_imp(
      y ~ c1 + b1 + time + (1 | id) + (1 | o1),
      data = longDF
    )), # glmm.R:m9a
    lme_nested = quote(lme_imp(
      y ~ C1 + c1 + time + (time | id) + (1 | center),
      data = longDF
    )), # new
    clmm_nested_trafo = quote(clmm_imp(
      o1 ~ C1 + abs(c1 - C1) + b2 + time + (1 | id) + (1 | center),
      data = longDF
    )), # new

    # survival models
    coxph_timevarying_spline_nested = quote(coxph_imp(
      Surv(futime, status != "censored") ~ age +
        sex +
        albumin +
        ns(platelet, df = 2) +
        (1 | id) +
        (1 | center),
      timevar = "day",
      data = PBC
    )), # coxph.R:m4d
    jm_three_longitudinal = quote(JM_imp(
      list(
        Surv(futime, status != "censored") ~ age +
          sex +
          chol +
          stage +
          hepato +
          (1 | id),
        hepato ~ day + (1 | id),
        chol ~ day + (1 | id),
        stage ~ age + (1 | id)
      ),
      timevar = "day",
      data = PBC_jm
    )) # survival.R, on a subset of PBC
  )
}


# Fitting and preparing the results ----------------------------------------------
# parts of a JointAI object that are compared
golden_parts <- c(
  "analysis_type",
  "formula",
  "data",
  "models",
  "fixed",
  "random",
  "Mlist",
  "par_index_main",
  "par_index_other",
  "jagsmodel",
  "mcmc_settings",
  "monitor_params",
  "data_list",
  "hyperpars",
  "info_list",
  "coef_list"
)

# Set the environment of formulas and terms objects to the global environment.
# Otherwise each run has a different environment (and saving them would store
# the whole environment, including data).
golden_strip_env <- function(x) {
  if (!is.null(attr(x, ".Environment"))) {
    attr(x, ".Environment") <- globalenv()
  }
  if (is.list(x) && !is.data.frame(x) && !is.function(x)) {
    att <- attributes(x)
    x <- lapply(x, golden_strip_env)
    attributes(x) <- att
  }
  x
}

golden_fit <- function(case, data = golden_data()) {
  call <- as.call(c(
    as.list(case),
    list(n.adapt = 0, n.iter = 0, seed = 2020, mess = FALSE, warn = FALSE)
  ))
  # evaluate with the data sets as variables; JointAI functions are found via
  # the environment this function was defined in
  env <- list2env(data, parent = environment())
  fit <- suppressWarnings(eval(call, envir = env))

  out <- unclass(fit)[golden_parts]
  # the name of the temporary model file differs between runs
  out$mcmc_settings$modelfile <- NULL
  golden_strip_env(out)
}
