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

# Association types: which column they belong to (#116) ------------------------
two_tv_covariates <- list(
  chol ~ day + age + (day | id),
  albumin ~ day + age + (day | id)
)

# the term of a column in the log-hazard, for the observed or underlying value
obs_term <- function(fit, colname) {
  scaled_obs(col_of(fit, "M_lvlone", colname), isgk = FALSE)
}
underl_term <- function(varname) {
  paste0("(mu_", varname, "[", srow, "] - ")
}

test_that("functions of several baseline variables do not shift association types", {
  terms <- c(
    "I(age * trig)",
    "I(age + trig)",
    "I(age/trig)",
    "log(age * trig)"
  )
  for (term in terms) {
    fml <- as.formula(paste(
      'Surv(futime, status != "censored") ~ albumin +',
      term
    ))
    fit <- jm_setup(fml, longfml = two_tv_covariates[2L])
    expect_identical(
      fit$info_list[[1L]]$assoc_type,
      c(albumin = "underl.value")
    )
  }
})

test_that("a function of several baseline variables does not move assoc_type to another variable", {
  fml1 <- Surv(futime, status != "censored") ~ albumin + I(age * trig)
  fit <- jm_setup(
    fml1,
    assoc_type = c(albumin = "obs.value"),
    longfml = two_tv_covariates[2L]
  )
  expect_identical(fit$info_list[[1L]]$assoc_type, c(albumin = "obs.value"))
  out <- jm_survival_lines(fit)
  expect_match(out$logh, obs_term(fit, "albumin"), fixed = TRUE)
  expect_no_match(out$logh, underl_term("albumin"), fixed = TRUE)

  fml2 <- Surv(futime, status != "censored") ~ chol + albumin + I(age * trig)
  fit <- jm_setup(
    fml2,
    assoc_type = c(chol = "obs.value"),
    longfml = two_tv_covariates
  )
  expect_identical(
    fit$info_list[[1L]]$assoc_type,
    c(chol = "obs.value", albumin = "underl.value")
  )
  out <- jm_survival_lines(fit)
  expect_match(out$logh, obs_term(fit, "chol"), fixed = TRUE)
  expect_match(out$logh, underl_term("albumin"), fixed = TRUE)
  expect_jags_compiles(fit)

  fit <- jm_setup(
    fml2,
    assoc_type = c(albumin = "obs.value"),
    longfml = two_tv_covariates
  )
  expect_identical(
    fit$info_list[[1L]]$assoc_type,
    c(chol = "underl.value", albumin = "obs.value")
  )
  out <- jm_survival_lines(fit)
  expect_match(out$logh, underl_term("chol"), fixed = TRUE)
  expect_match(out$logh, obs_term(fit, "albumin"), fixed = TRUE)
})

test_that("each transformed term of a covariate has its own association type", {
  fml <- Surv(futime, status != "censored") ~ age + log(chol) + I(chol^2)

  fit <- jm_setup(
    fml,
    assoc_type = c("log(chol)" = "obs.value", "I(chol^2)" = "obs.value")
  )
  expect_identical(
    fit$info_list[[1L]]$assoc_type,
    c("log(chol)" = "obs.value", "I(chol^2)" = "obs.value")
  )

  fit <- jm_setup(fml, assoc_type = c("I(chol^2)" = "obs.value"))
  expect_identical(
    fit$info_list[[1L]]$assoc_type,
    c("log(chol)" = "underl.value", "I(chol^2)" = "obs.value")
  )
})

test_that("a name in assoc_type only applies to the term of that name", {
  fit <- jm_setup(
    Surv(futime, status != "censored") ~ age + chol + log(chol),
    assoc_type = c(chol = "obs.value")
  )
  expect_identical(
    fit$info_list[[1L]]$assoc_type,
    c(chol = "obs.value", "log(chol)" = "underl.value")
  )
})

test_that("names in assoc_type that are no term with an association type give an error", {
  jm_error <- function(
    survfml,
    assoc_type,
    longfml = list(chol ~ day + age + (day | id)),
    warn = TRUE
  ) {
    tryCatch(
      {
        suppressWarnings(JM_imp(
          c(list(survfml), longfml),
          timevar = "day",
          data = golden_data()$PBC_small,
          assoc_type = assoc_type,
          n.adapt = 0,
          n.iter = 0,
          seed = 2020,
          mess = FALSE,
          warn = warn
        ))
        NA_character_
      },
      error = function(e) conditionMessage(e)
    )
  }
  fml <- Surv(futime, status != "censored") ~ age + chol

  # a typo: the message names it, and the possible names
  err <- jm_error(fml, c(chl = "obs.value"))
  expect_match(err, "assoc_type", fixed = TRUE)
  expect_match(err, "chl", fixed = TRUE)
  expect_match(err, "chol", fixed = TRUE)

  # also next to a name that is used, and with warn = FALSE
  err <- jm_error(fml, c(chol = "obs.value", chl = "obs.value"))
  expect_match(err, "chl", fixed = TRUE)
  expect_match(
    jm_error(fml, c(chl = "obs.value"), warn = FALSE),
    "assoc_type",
    fixed = TRUE
  )

  # a baseline covariate, and a vector without names
  expect_match(jm_error(fml, c(age = "obs.value")), "assoc_type", fixed = TRUE)
  expect_match(jm_error(fml, "obs.value"), "assoc_type", fixed = TRUE)

  # the variable of a transformed term is not a term
  fml_log <- Surv(futime, status != "censored") ~ age + log(chol)
  err <- jm_error(fml_log, c(chol = "obs.value"))
  expect_match(err, "log(chol)", fixed = TRUE)
  expect_identical(
    jm_error(fml_log, c("log(chol)" = "obs.value")),
    NA_character_
  )

  # a factor is named by the variable, not by its dummy variables
  fml_fct <- Surv(futime, status != "censored") ~ age + stage
  long_fct <- list(stage ~ day + age + (1 | id))
  expect_identical(
    jm_error(fml_fct, c(stage = "obs.value"), longfml = long_fct),
    NA_character_
  )
  err <- jm_error(fml_fct, c(stage2 = "obs.value"), longfml = long_fct)
  expect_match(err, "stage2", fixed = TRUE)
})

test_that("a name in assoc_type may apply to one of several survival outcomes", {
  fit <- JM_imp(
    list(
      Surv(futime, status == "dead") ~ age + chol,
      Surv(futime, status == "transplant") ~ age + albumin,
      chol ~ day + age + (day | id),
      albumin ~ day + age + (day | id)
    ),
    timevar = "day",
    data = golden_data()$PBC_small,
    assoc_type = c(albumin = "obs.value", chol = "obs.value"),
    n.adapt = 0,
    n.iter = 0,
    seed = 2020,
    mess = FALSE,
    warn = FALSE
  )
  expect_identical(
    unname(unlist(lapply(fit$info_list[1:2], "[[", "assoc_type"))),
    c("obs.value", "obs.value")
  )
})

test_that("an interaction has no association type of its own", {
  fit <- jm_setup(
    Surv(futime, status != "censored") ~ age * chol,
    assoc_type = c(chol = "obs.value")
  )
  expect_identical(fit$info_list[[1L]]$assoc_type, c(chol = "obs.value"))

  expect_error(
    jm_setup(
      Surv(futime, status != "censored") ~ age * chol,
      assoc_type = c("age:chol" = "obs.value")
    ),
    "age:chol",
    fixed = TRUE
  )
})

test_that("check_assoc_type_names() takes a term with several columns as one name", {
  # splines of time-varying covariates in the survival part are not implemented
  # (so these objects cannot be created by JM_imp()), but the check is ready
  for (spline in c("ns", "bs")) {
    term <- paste0(spline, "(chol, df = 2)")
    columns <- paste0(term, 1:2)
    info_list <- list(
      surv = list(
        modeltype = "JM",
        lp = list(M_id = c(age = 1L), M_lvlone = setNames(1:2, columns)),
        tv_vars = list(chol = list())
      )
    )
    Mlist <- list(
      interactions = NULL,
      refs = list(),
      fcts_all = data.frame(
        var = "chol",
        colname = columns,
        fct = term,
        type = spline
      )
    )

    expect_no_error(check_assoc_type_names(
      setNames("obs.value", term),
      info_list,
      Mlist
    ))
    expect_error(
      check_assoc_type_names(
        setNames("obs.value", columns[1L]),
        info_list,
        Mlist
      ),
      term,
      fixed = TRUE
    )
    expect_error(
      check_assoc_type_names(c(chol = "obs.value"), info_list, Mlist),
      term,
      fixed = TRUE
    )
  }
})
