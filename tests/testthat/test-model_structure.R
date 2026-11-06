# The structure of the joint model, stated independently of how JointAI builds
# it (planned re-design of the model set-up, dev notes), on a grid of model
# features: levels (one, two, three nested, crossed), incomplete variables on
# each level, functions, interactions across levels, model types.
#
# The joint distribution is a sequence of models; the covariate models follow
# the order of `fit$models`. The rule for their predictors: a variable `v` can
# be a predictor in the model of `x` if `v` is constant within every grouping
# within which `x` is constant (this excludes variables of a lower level and,
# for crossed levels, of the other crossed level) and `v` has no model before
# the one of `x`. The predictors of a covariate model are all variables of the
# model formulas that satisfy this rule.
#
# Each model is set up and compiled, not sampled (n.adapt = 1, n.iter = 0).

skip_on_cran()

# data --------------------------------------------------------------------------
# three nested levels: id in center, with an incomplete variable of center
dat3 <- longDF
dat3$center <- as.integer(dat3$id) %% 5L
set.seed(1)
dat3$Z <- rnorm(5)[dat3$center + 1L]
dat3$Z[dat3$center == 2L] <- NA

# crossed levels a and b, with incomplete variables of b and of the
# observations
set.seed(2)
datx <- expand.grid(a = 1:10, b = 1:8, rep = 1:3)
datx$A1 <- rnorm(10)[datx$a]
datx$B1 <- rnorm(8)[datx$b]
datx$B2 <- rnorm(8)[datx$b]
datx$x <- rnorm(nrow(datx))
datx$y <- datx$A1 + datx$B1 + datx$x + rnorm(nrow(datx))
datx$B1[datx$b == 3L] <- NA
datx$B2[datx$b == 6L] <- NA
datx$x[c(4L, 50L)] <- NA

# survival data, with an incomplete variable on the level of the subjects (W)
pbc <- PBC[PBC$id %in% unique(PBC$id)[1:60], ]
set.seed(3)
pbc$W <- rnorm(60)[match(pbc$id, unique(pbc$id))]
pbc$W[pbc$id %in% unique(pbc$id)[c(2, 9, 30)]] <- NA
pbc1 <- pbc[!duplicated(pbc$id), ]

# grid: model call and its grouping variables -----------------------------------
grid <- list(
  one_level = list(
    quote(lm_imp(y ~ C1 + C2 + B2 + M2 + O2, data = wideDF)),
    character(0)
  ),
  two_levels = list(
    quote(lme_imp(
      y ~ C1 + C2 + B2 + M2 + O2 + c2 + b2 + time + (time | id),
      data = longDF
    )),
    "id"
  ),
  functions_interactions = list(
    quote(lme_imp(
      y ~ C1 * time + I(C2^2) + b2:c1 + c1 + (1 | id),
      data = longDF
    )),
    "id"
  ),
  glmm = list(
    quote(glme_imp(
      b1 ~ C2 + c2 + time + (1 | id),
      family = binomial(),
      data = longDF
    )),
    "id"
  ),
  clmm = list(
    quote(clmm_imp(o1 ~ C2 + B2 + c2 + time + (1 | id), data = longDF)),
    "id"
  ),
  three_levels = list(
    quote(lme_imp(
      y ~ C1 + C2 + Z + c2 + time + (time | id) + (1 | center),
      data = dat3
    )),
    c("id", "center")
  ),
  crossed = list(
    quote(lme_imp(y ~ x + A1 + B1 + B2 + (1 | a) + (1 | b), data = datx)),
    c("a", "b")
  ),
  survreg = list(
    quote(survreg_imp(
      Surv(futime, status != "censored") ~ age + sex + trig + platelet,
      data = pbc1
    )),
    character(0)
  ),
  jm = list(
    quote(JM_imp(
      list(
        Surv(futime, status != "censored") ~ age + W + chol,
        chol ~ age + W + hepato + day + (day | id)
      ),
      timevar = "day",
      data = pbc
    )),
    "id"
  )
)

setup_grid_case <- function(case) {
  call <- as.call(c(
    as.list(case),
    list(n.adapt = 1, n.iter = 0, seed = 2020, mess = FALSE, warn = FALSE)
  ))
  # in the environment of the caller, so that a modified copy of the data
  # (in a test) is used
  eval(call, parent.frame())
}

# helpers -----------------------------------------------------------------------
# the groupings (and "lvlone", the rows) within which a variable is constant;
# missing values are ignored
constant_within <- function(x, data, groupings) {
  ok <- vapply(
    groupings,
    function(g) {
      obs <- !is.na(x)
      all(tapply(x[obs], data[[g]][obs], function(v) length(unique(v)) <= 1L))
    },
    logical(1L)
  )
  c("lvlone", groupings[ok])
}

# the variables of a design-matrix column (dummy columns of factors, functions
# and interactions)
column_vars <- function(colname, refs) {
  dummies <- unlist(lapply(refs, attr, "dummies"))
  factor_of <- rep(names(refs), lengths(lapply(refs, attr, "dummies")))
  unique(unlist(lapply(strsplit(colname, ":", fixed = TRUE)[[1L]], function(p) {
    if (p %in% dummies) factor_of[match(p, dummies)] else all.vars(str2lang(p))
  })))
}

# the predictor variables of each covariate model, as used by JointAI, and as
# expected from the rule above
covariate_model_predictors <- function(fit, groupings) {
  covmodels <- setdiff(names(fit$models), names(fit$fixed))
  candidates <- setdiff(
    unique(unlist(lapply(fit$fixed, function(f) all.vars(f[[3L]])))),
    unlist(lapply(fit$fixed, function(f) all.vars(f[[2L]])))
  )
  lvls <- lapply(
    setNames(nm = c(candidates, covmodels)),
    function(v) constant_within(fit$data[[v]], fit$data, groupings)
  )

  lapply(setNames(nm = covmodels), function(x) {
    cols <- setdiff(fit$coef_list[[x]]$varname, "(Intercept)")
    used <- unique(unlist(lapply(cols, column_vars, refs = fit$Mlist$refs)))
    modelled_before <- names(fit$models)[seq_len(match(x, names(fit$models)))]
    allowed <- Filter(
      function(v) all(lvls[[x]] %in% lvls[[v]]),
      setdiff(candidates, modelled_before)
    )
    list(
      used = sort(as.character(used)),
      expected = sort(as.character(allowed))
    )
  })
}

# tests -------------------------------------------------------------------------
for (k in names(grid)) {
  test_that(paste("model structure:", k), {
    fit <- setup_grid_case(grid[[k]][[1L]])
    expect_s3_class(fit$model, "jags")

    # every incomplete variable of the formulas has a model
    covars <- unique(unlist(lapply(fit$fixed, function(f) all.vars(f[[3L]]))))
    incomplete <- covars[vapply(
      covars,
      function(v) anyNA(fit$data[[v]]),
      logical(1L)
    )]
    expect_true(all(incomplete %in% names(fit$models)), label = k)

    # the predictors of each covariate model follow the rule
    preds <- covariate_model_predictors(fit, grid[[k]][[2L]])
    for (x in names(preds)) {
      expect_identical(
        preds[[x]]$used,
        preds[[x]]$expected,
        label = paste(x, k)
      )
    }
  })
}

# known bugs (to be solved by the re-design of the model set-up) -----------------
test_that("crossed levels with incomplete variables on both crossed levels", {
  skip("known bug (scan bug 4): no intercept on level a, B1 loses B2")
  datx$A1[datx$a == 2L] <- NA
  fit <- setup_grid_case(grid$crossed[[1L]])
  expect_s3_class(fit$model, "jags")
  preds <- covariate_model_predictors(fit, c("a", "b"))
  for (x in names(preds)) {
    expect_identical(preds[[x]]$used, preds[[x]]$expected, label = x)
  }
})

test_that("a covariate named out", {
  skip("known bug (scan bug 5): get(out) in get_linpreds()")
  dat <- wideDF
  dat$out <- dat$C2
  fit <- lm_imp(
    y ~ C1 + out + B2,
    data = dat,
    n.adapt = 1,
    n.iter = 0,
    mess = FALSE
  )
  expect_s3_class(fit$model, "jags")
})

test_that("a function of a categorical variable (#36)", {
  skip("known bug (#36): the dummy of B1 is not found for the function")
  fit <- lm_imp(
    y ~ C1 + B1 + I(ifelse(as.numeric(B1) == 1, C2, 2 * C2)),
    data = wideDF,
    n.adapt = 1,
    n.iter = 0,
    mess = FALSE
  )
  expect_s3_class(fit$model, "jags")
})
