# Interactions with a time-varying covariate in a longitudinal sub-model of a
# joint model (JM_imp()). In the survival part, the longitudinal sub-models are
# evaluated at the quadrature points, with the design matrix M_lvlonegk. The
# time-varying covariates are modelled there, and an interaction column of
# M_lvlonegk has to be the product of its elements.

skip_on_cran()

pbc <- droplevels(PBC[PBC$id %in% unique(PBC$id)[1:60], ])
pbc$Blong <- factor(ifelse(pbc$albumin > 3.5, "high", "low"))

# set up the joint model (without sampling) with the given longitudinal model
# for chol and further longitudinal models
jm_long_setup <- function(longfml) {
  JM_imp(
    c(
      list(Surv(futime, status != "censored") ~ age + chol + (1 | id)),
      longfml
    ),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    seed = 2020,
    mess = FALSE,
    warn = FALSE
  )
}

# compile the JAGS model and draw one value of the design matrix at the
# quadrature points; returns an array [subject, column, quadrature point]
draw_matgk <- function(fit) {
  jm <- rjags::jags.model(
    textConnection(fit$jagsmodel),
    data = fit$data_list,
    inits = fit$mcmc_settings$inits[1L],
    n.chains = 1L,
    n.adapt = 0L,
    quiet = TRUE
  )
  draw <- rjags::jags.samples(
    jm,
    "M_lvlonegk",
    n.iter = 1L,
    progress.bar = "none"
  )
  matgk <- array(
    draw$M_lvlonegk,
    dim = dim(fit$data_list$M_lvlonegk)
  )
  dimnames(matgk) <- list(NULL, colnames(fit$data_list$M_lvlone), NULL)
  matgk
}

# a subject-level column of M_id, repeated for all quadrature points
subject_col <- function(fit, colname) {
  matrix(fit$data_list$M_id[, colname], nrow = 60L, ncol = 15L)
}


test_that("interaction of a time-varying and a continuous baseline covariate", {
  fit <- jm_long_setup(list(chol ~ day + albumin * age + (1 | id)))
  matgk <- draw_matgk(fit)

  inter <- matgk[, "albumin:age", ]
  expect_false(anyNA(inter))
  expect_equal(inter, matgk[, "albumin", ] * subject_col(fit, "age"))
})

test_that("interaction of a time-varying covariate and a baseline factor", {
  fit <- jm_long_setup(list(chol ~ day + albumin * sex + (1 | id)))
  matgk <- draw_matgk(fit)

  inter <- matgk[, "albumin:sexfemale", ]
  expect_false(anyNA(inter))
  expect_equal(inter, matgk[, "albumin", ] * subject_col(fit, "sexfemale"))
})

test_that("interaction of a time-varying factor and a baseline covariate", {
  fit <- jm_long_setup(list(chol ~ day + Blong * age + (1 | id)))
  matgk <- draw_matgk(fit)

  inter <- matgk[, "Blonglow:age", ]
  expect_false(anyNA(inter))
  expect_equal(inter, matgk[, "Blonglow", ] * subject_col(fit, "age"))
})

test_that("interaction of two time-varying covariates", {
  fit <- jm_long_setup(list(chol ~ day + albumin * platelet + (1 | id)))
  matgk <- draw_matgk(fit)

  inter <- matgk[, "albumin:platelet", ]
  expect_false(anyNA(inter))
  expect_equal(inter, matgk[, "albumin", ] * matgk[, "platelet", ])
})

test_that("the sub-model at the quadrature points uses the interaction column", {
  fit <- jm_long_setup(list(chol ~ day + albumin * age + (1 | id)))
  column <- match("albumin:age", colnames(fit$data_list$M_lvlone))

  lines <- strsplit(fit$jagsmodel, "\n", fixed = TRUE)[[1L]]
  start <- grep("mugk_chol[ii, k] <-", lines, fixed = TRUE)
  end <- start + grep("}", lines[start:length(lines)], fixed = TRUE)[1L] - 1L
  expect_match(
    paste(lines[start:end], collapse = "\n"),
    paste0("M_lvlonegk[ii, ", column, ", k]"),
    fixed = TRUE
  )
})
