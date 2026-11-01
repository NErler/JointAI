# Interactions involving a time-varying covariate in the survival part of a
# joint model (JM_imp()). The JAGS model is set up (n.adapt = 0, n.iter = 0)
# and compiled, but not run.

skip_on_cran()

jm_setup <- function(
  survfml,
  ...,
  longfml = list(chol ~ day + age + (day | id))
) {
  case <- as.call(c(
    quote(JM_imp),
    list(
      formula = c(list(survfml), longfml),
      timevar = "day",
      data = quote(PBC_small)
    ),
    list(...)
  ))
  golden_fit(case, golden_data())
}

# the lines of the JAGS model that define the log-hazard and the survival
# function inside the Gauss-Kronrod quadrature
jm_survival_lines <- function(fit) {
  lines <- strsplit(fit$jagsmodel, "\n", fixed = TRUE)[[1L]]
  logh <- grep("^ +logh_Srv_ftm_stts_cn\\[ii\\] <-", lines)
  surv <- grep("^ +Surv_Srv_ftm_stts_cn\\[ii, 1:15\\] <-", lines)
  next_lines <- function(start) {
    end <- start
    while (end < length(lines) && grepl("^ +[(+]", lines[end + 1L])) {
      end <- end + 1L
    }
    paste(lines[start:end], collapse = "\n")
  }
  list(logh = next_lines(logh), surv = next_lines(surv))
}

expect_jags_compiles <- function(fit) {
  expect_s3_class(
    rjags::jags.model(
      textConnection(fit$jagsmodel),
      data = fit$data_list,
      inits = fit$mcmc_settings$inits[1L],
      n.chains = 1L,
      n.adapt = 0L,
      quiet = TRUE
    ),
    "jags"
  )
}

col_of <- function(fit, mat, colname) {
  match(colname, colnames(fit$data_list[[mat]]))
}

srow <- "srow_Srv_ftm_stts_cn[ii]"


test_that("interaction of a time-varying and a baseline covariate (underlying value)", {
  fit <- jm_setup(Surv(futime, status != "censored") ~ age * chol)
  out <- jm_survival_lines(fit)
  age <- col_of(fit, "M_id", "age")

  expect_false(grepl("mu_age:chol", fit$jagsmodel, fixed = TRUE))
  expect_match(
    out$logh,
    paste0("M_id[ii, ", age, "] * mu_chol[", srow, "]"),
    fixed = TRUE
  )
  expect_match(
    out$surv,
    paste0("M_id[ii, ", age, "] * mugk_chol[ii, 1:15]"),
    fixed = TRUE
  )
  expect_jags_compiles(fit)
})

test_that("interaction of a time-varying covariate and a baseline factor", {
  fit <- jm_setup(Surv(futime, status != "censored") ~ sex * chol)
  out <- jm_survival_lines(fit)
  sex <- col_of(fit, "M_id", "sexfemale")

  expect_match(
    out$logh,
    paste0("M_id[ii, ", sex, "] * mu_chol[", srow, "]"),
    fixed = TRUE
  )
  expect_match(
    out$surv,
    paste0("M_id[ii, ", sex, "] * mugk_chol[ii, 1:15]"),
    fixed = TRUE
  )
  expect_jags_compiles(fit)
})

test_that("interaction of a time-varying and a baseline covariate (observed value)", {
  fit <- jm_setup(
    Surv(futime, status != "censored") ~ age * chol,
    assoc_type = c(chol = "obs.value")
  )
  out <- jm_survival_lines(fit)
  age <- col_of(fit, "M_id", "age")
  chol <- col_of(fit, "M_lvlone", "chol")

  expect_match(
    out$logh,
    paste0("M_id[ii, ", age, "] * M_lvlone[", srow, ", ", chol, "]"),
    fixed = TRUE
  )
  expect_match(
    out$surv,
    paste0("M_id[ii, ", age, "] * M_lvlonegk[ii, ", chol, ", 1:15]"),
    fixed = TRUE
  )
  expect_jags_compiles(fit)
})

test_that("interaction of a time-varying covariate with the time variable", {
  fit <- jm_setup(Surv(futime, status != "censored") ~ chol + chol:day)
  out <- jm_survival_lines(fit)
  day <- col_of(fit, "M_lvlone", "day")

  expect_match(
    out$logh,
    paste0("mu_chol[", srow, "] * M_lvlone[", srow, ", ", day, "]"),
    fixed = TRUE
  )
  expect_match(
    out$surv,
    paste0("mugk_chol[ii, 1:15] * M_lvlonegk[ii, ", day, ", 1:15]"),
    fixed = TRUE
  )
  expect_jags_compiles(fit)
})

test_that("interaction with a transformed time-varying covariate", {
  fit <- jm_setup(Surv(futime, status != "censored") ~ age * log(chol))
  out <- jm_survival_lines(fit)
  age <- col_of(fit, "M_id", "age")

  expect_match(
    out$logh,
    paste0("M_id[ii, ", age, "] * log(mu_chol[", srow, "])"),
    fixed = TRUE
  )
  expect_match(
    out$surv,
    paste0("M_id[ii, ", age, "] * log(mugk_chol[ii, 1:15])"),
    fixed = TRUE
  )
})

test_that("interactions with two time-varying covariates", {
  fit <- jm_setup(
    Surv(futime, status != "censored") ~ chol + albumin + age:chol,
    longfml = list(chol ~ day + age + (day | id), albumin ~ day + (day | id))
  )
  out <- jm_survival_lines(fit)
  age <- col_of(fit, "M_id", "age")

  expect_match(out$logh, paste0("mu_albumin[", srow, "]"), fixed = TRUE)
  expect_match(
    out$logh,
    paste0("mu_chol[", srow, "] * M_id[ii, ", age, "]"),
    fixed = TRUE
  )
  expect_jags_compiles(fit)
})

test_that("a covariate that is only part of an interaction has an association type", {
  fit <- jm_setup(Surv(futime, status != "censored") ~ age + age:chol)
  expect_identical(fit$info_list[[1L]]$assoc_type, c(chol = "underl.value"))
  expect_jags_compiles(fit)
})

test_that("get_jm_interactions() refuses elements above the survival level", {
  inter <- list(
    "chol:x" = structure(
      list(
        interterm = c(M_lvlone = 3L),
        elmts = c(M_lvlone = 1L, M_center = 2L)
      ),
      interaction = "chol:x",
      elements = c("chol", "x"),
      has_NAs = FALSE
    )
  )
  expect_error(
    get_jm_interactions(c(chol = 1L, "chol:x" = 3L), inter, "M_id"),
    "from a level above"
  )
  expect_length(get_jm_interactions(c(chol = 1L), inter, "M_id"), 0L)
  expect_length(get_jm_interactions(c(chol = 1L), NULL, "M_id"), 0L)
})

test_that("interaction of a time-varying covariate with a function of time", {
  # without the main effect of ns(day), its columns are not in the data
  expect_error(
    jm_setup(Surv(futime, status != "censored") ~ chol + chol:ns(day, df = 2)),
    "argument .*auxvars"
  )

  fit <- jm_setup(
    Surv(futime, status != "censored") ~ chol + chol:ns(day, df = 2),
    auxvars = ~ ns(day, df = 2)
  )
  out <- jm_survival_lines(fit)
  ns1 <- col_of(fit, "M_lvlone", "ns(day, df = 2)1")

  expect_match(
    out$logh,
    paste0("mu_chol[", srow, "] * M_lvlone[", srow, ", ", ns1, "]"),
    fixed = TRUE
  )
  expect_match(
    out$surv,
    paste0("mugk_chol[ii, 1:15] * M_lvlonegk[ii, ", ns1, ", 1:15]"),
    fixed = TRUE
  )
  expect_jags_compiles(fit)
})

test_that("interaction of a baseline covariate with a function of time", {
  # was placed on the level of the subjects (constant over time)
  expect_error(
    jm_setup(Surv(futime, status != "censored") ~ age + age:ns(day, df = 2)),
    "argument .*auxvars"
  )

  fit <- jm_setup(
    Surv(futime, status != "censored") ~ chol + age + age:ns(day, df = 2),
    auxvars = ~ ns(day, df = 2)
  )
  out <- jm_survival_lines(fit)
  age <- col_of(fit, "M_id", "age")
  ns1 <- col_of(fit, "M_lvlone", "ns(day, df = 2)1")

  expect_match(
    out$surv,
    paste0("M_id[ii, ", age, "] * M_lvlonegk[ii, ", ns1, ", 1:15]"),
    fixed = TRUE
  )
  expect_jags_compiles(fit)
})

test_that("interaction of a factor with time without the main effect of time", {
  expect_error(
    jm_setup(Surv(futime, status != "censored") ~ chol + sex + sex:day),
    "category .*sexmale"
  )
  expect_error(
    jm_setup(
      Surv(futime, status != "censored") ~ chol + sex + sex:ns(day, df = 2)
    ),
    "category .*sexmale"
  )
})

test_that("interaction of a factor with a covariate without its main effect", {
  expect_error(
    jm_setup(Surv(futime, status != "censored") ~ age + sex:chol),
    "add the main\\s+effect of\\s+.*chol"
  )
})

test_that("interaction with a function of a covariate without its main effect", {
  expect_error(
    jm_setup(Surv(futime, status != "censored") ~ chol + log(chol):day),
    "add the main\\s+effect of\\s+.*log\\(chol\\)"
  )
})

# Transformed time-varying covariates in the survival part: the observed value
# is the column that already holds the transformed value (only the underlying
# value has to be transformed in the linear predictor)

# the scaled value of a column in the linear predictor, as it is written for
# the observed value (i.e., without a further transformation)
scaled_obs <- function(column, isgk) {
  value <- if (isgk) {
    paste0("M_lvlonegk[ii, ", column, ", 1:15]")
  } else {
    paste0("M_lvlone[", srow, ", ", column, "]")
  }
  paste0("(", value, " - spM_lvlone[", column, ", 1])")
}

test_that("observed value of a log-transformed time-varying covariate", {
  fit <- jm_setup(
    Surv(futime, status != "censored") ~ age + log(chol),
    assoc_type = c("log(chol)" = "obs.value")
  )
  out <- jm_survival_lines(fit)
  column <- col_of(fit, "M_lvlone", "log(chol)")

  expect_match(out$logh, scaled_obs(column, isgk = FALSE), fixed = TRUE)
  expect_match(out$surv, scaled_obs(column, isgk = TRUE), fixed = TRUE)
  expect_jags_compiles(fit)
})

test_that("observed value of a transformation written with I()", {
  fit <- jm_setup(
    Surv(futime, status != "censored") ~ age + I(chol^2),
    assoc_type = c("I(chol^2)" = "obs.value")
  )
  out <- jm_survival_lines(fit)
  column <- col_of(fit, "M_lvlone", "I(chol^2)")

  expect_match(out$logh, scaled_obs(column, isgk = FALSE), fixed = TRUE)
  expect_match(out$surv, scaled_obs(column, isgk = TRUE), fixed = TRUE)
  expect_jags_compiles(fit)
})

test_that("observed value of a transformed covariate in an interaction", {
  fit <- jm_setup(
    Surv(futime, status != "censored") ~ age + log(chol) + log(chol):age,
    assoc_type = c("log(chol)" = "obs.value")
  )
  out <- jm_survival_lines(fit)
  age <- col_of(fit, "M_id", "age")
  column <- col_of(fit, "M_lvlone", "log(chol)")

  expect_match(
    out$logh,
    paste0("M_id[ii, ", age, "] * M_lvlone[", srow, ", ", column, "] - "),
    fixed = TRUE
  )
  expect_match(
    out$surv,
    paste0("M_id[ii, ", age, "] * M_lvlonegk[ii, ", column, ", 1:15] - "),
    fixed = TRUE
  )
  # the main effect, which goes through the same function
  expect_match(out$logh, scaled_obs(column, isgk = FALSE), fixed = TRUE)
  expect_match(out$surv, scaled_obs(column, isgk = TRUE), fixed = TRUE)
  expect_jags_compiles(fit)
})

test_that("observed value by default for a transformed covariate (Poisson)", {
  # not specified by the user: the default for a Poisson model is "obs.value"
  fit <- jm_setup(
    Surv(futime, status != "censored") ~ age + log(platelet),
    models = c(platelet = "glmm_poisson_log"),
    longfml = list(
      chol ~ day + age + (day | id),
      platelet ~ day + age + (day | id)
    )
  )
  out <- jm_survival_lines(fit)
  column <- col_of(fit, "M_lvlone", "log(platelet)")

  expect_identical(
    fit$info_list[[1L]]$assoc_type,
    c("log(platelet)" = "obs.value")
  )
  expect_match(out$logh, scaled_obs(column, isgk = FALSE), fixed = TRUE)
  expect_match(out$surv, scaled_obs(column, isgk = TRUE), fixed = TRUE)
  expect_jags_compiles(fit)
})

test_that("underlying value of a transformed covariate is transformed", {
  fit <- jm_setup(Surv(futime, status != "censored") ~ age + log(chol))
  out <- jm_survival_lines(fit)

  expect_match(out$logh, paste0("(log(mu_chol[", srow, "]) - "), fixed = TRUE)
  expect_match(out$surv, "(log(mugk_chol[ii, 1:15]) - ", fixed = TRUE)
  expect_jags_compiles(fit)
})

test_that("the association type of each column of the same covariate is used", {
  fml <- Surv(futime, status != "censored") ~ age + chol + log(chol)

  fit <- jm_setup(fml, assoc_type = c("log(chol)" = "obs.value"))
  out <- jm_survival_lines(fit)
  column <- col_of(fit, "M_lvlone", "log(chol)")
  expect_match(out$logh, paste0("(mu_chol[", srow, "] - "), fixed = TRUE)
  expect_match(out$logh, scaled_obs(column, isgk = FALSE), fixed = TRUE)
  expect_match(out$surv, "(mugk_chol[ii, 1:15] - ", fixed = TRUE)
  expect_match(out$surv, scaled_obs(column, isgk = TRUE), fixed = TRUE)
  expect_jags_compiles(fit)

  fit <- jm_setup(fml, assoc_type = c(chol = "obs.value"))
  out <- jm_survival_lines(fit)
  column <- col_of(fit, "M_lvlone", "chol")
  expect_match(out$logh, scaled_obs(column, isgk = FALSE), fixed = TRUE)
  expect_match(out$logh, paste0("(log(mu_chol[", srow, "]) - "), fixed = TRUE)
  expect_match(out$surv, scaled_obs(column, isgk = TRUE), fixed = TRUE)
  expect_match(out$surv, "(log(mugk_chol[ii, 1:15]) - ", fixed = TRUE)
  expect_jags_compiles(fit)
})
