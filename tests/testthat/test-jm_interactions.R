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
