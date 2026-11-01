# Factors with contrasts other than contr.treatment, set via
# options("contrasts"). The contrast matrices of contr.sum() and contr.helmert()
# have no column names, and for incomplete factors the contrast variables are
# calculated from the category number within the JAGS model.

skip_on_cran()

# evaluate `code` with the given contrast for unordered factors
with_contrasts <- function(contrast, code) {
  old <- options(contrasts = c(contrast, "contr.poly"))
  on.exit(options(old))
  code
}

n <- 30L
dat <- data.frame(
  y = seq(-1, 1, length.out = n),
  f = factor(rep(c("a", "b", "c"), length.out = n)),
  g = factor(rep(c("10", "20", "30"), length.out = n)),
  u = factor(rep(c("no", "yes"), length.out = n))
)

# all lines of the JAGS model that calculate contrast variables
ifelse_lines <- function(object) {
  lines <- strsplit(object$jagsmodel, "\n")[[1L]]
  trimws(grep("ifelse", lines, value = TRUE))
}


# contrast matrices and names of the contrast variables ------------------------
test_that("contr.sum: the reference category is -1 in all contrast variables", {
  for (refcat in c("first", "last", "b")) {
    ref <- with_contrasts(
      "contr.sum",
      get_refs(y ~ f, dat, refcats = list(f = refcat))$f
    )
    cmat <- attr(ref, "contr_matrix")
    other <- setdiff(levels(ref), as.character(ref))

    expect_identical(dim(cmat), c(3L, 2L))
    expect_identical(rownames(cmat), levels(ref))
    expect_identical(colnames(cmat), other)
    expect_identical(attr(ref, "dummies"), paste0("f", other))

    # the reference is -1 everywhere, each other category is 1 in its own column
    expect_equal(cmat[as.character(ref), ], c(-1, -1), ignore_attr = TRUE)
    expect_equal(cmat[other, other], diag(2L), ignore_attr = TRUE)
  }
})

test_that("contr.sum: a factor with two categories has one contrast variable", {
  ref <- with_contrasts("contr.sum", get_refs(y ~ u, dat)$u)
  cmat <- attr(ref, "contr_matrix")

  expect_identical(dim(cmat), c(2L, 1L))
  expect_equal(cmat[, 1L], c(no = -1, yes = 1))
  expect_identical(attr(ref, "dummies"), "uyes")
})

test_that("contr.helmert: the contrast variables are numbered", {
  ref <- with_contrasts("contr.helmert", get_refs(y ~ f, dat)$f)

  expect_equal(
    attr(ref, "contr_matrix"),
    contr.helmert(levels(dat$f)),
    ignore_attr = TRUE
  )
  expect_identical(attr(ref, "dummies"), c("f1", "f2"))
})

test_that("existing column names of contrast matrices are not changed", {
  ref <- get_refs(y ~ f, dat)$f
  expect_identical(attr(ref, "dummies"), c("fb", "fc"))

  ref <- with_contrasts("contr.SAS", get_refs(y ~ f, dat)$f)
  expect_identical(attr(ref, "dummies"), c("fa", "fb"))
})


# complete factors -------------------------------------------------------------
test_that("complete factors with contr.sum have the intended design matrix", {
  mod <- with_contrasts(
    "contr.sum",
    lm_imp(y ~ f, data = dat, n.adapt = 0L, n.iter = 0L, mess = FALSE)
  )
  M <- mod$data_list$M_lvlone

  expect_identical(colnames(M), c("y", "(Intercept)", "fb", "fc"))
  expect_equal(
    unique(M[, c("fb", "fc")]),
    rbind(c(-1, -1), c(1, 0), c(0, 1)),
    ignore_attr = TRUE
  )
})

test_that("complete factors with contr.helmert have the intended design matrix", {
  mod <- with_contrasts(
    "contr.helmert",
    lm_imp(y ~ f, data = dat, n.adapt = 0L, n.iter = 0L, mess = FALSE)
  )
  M <- mod$data_list$M_lvlone

  expect_identical(colnames(M), c("y", "(Intercept)", "f1", "f2"))
  expect_equal(
    unique(M[, c("f1", "f2")]),
    contr.helmert(3L),
    ignore_attr = TRUE
  )
})

test_that("contrast variables can still clash with a variable name", {
  dat$f1 <- dat$y + 1
  expect_error(
    with_contrasts(
      "contr.helmert",
      lm_imp(y ~ f + f1, data = dat, n.adapt = 0L, n.iter = 0L, mess = FALSE)
    ),
    "f1"
  )
})


# syntax for incomplete factors ------------------------------------------------
test_that("paste_dummies() compares with the category number, not the label", {
  # default reference: the first category
  ref <- with_contrasts("contr.sum", get_refs(y ~ g, dat)$g)
  expect_identical(
    trimws(paste_dummies("M", 2L, c(5L, 6L), "i", ref)),
    c(
      "M[i, 5] <- ifelse(M[i, 2] == 2, 1, ifelse(M[i, 2] == 1, -1, 0))",
      "M[i, 6] <- ifelse(M[i, 2] == 3, 1, ifelse(M[i, 2] == 1, -1, 0))"
    )
  )

  # the reference is the category with the label "20", i.e., category number 2
  ref <- with_contrasts(
    "contr.sum",
    get_refs(y ~ g, dat, refcats = list(g = "20"))$g
  )
  expect_identical(
    trimws(paste_dummies("M", 2L, c(5L, 6L), "i", ref)),
    c(
      "M[i, 5] <- ifelse(M[i, 2] == 1, 1, ifelse(M[i, 2] == 2, -1, 0))",
      "M[i, 6] <- ifelse(M[i, 2] == 3, 1, ifelse(M[i, 2] == 2, -1, 0))"
    )
  )
})

test_that("paste_dummies() uses the 0/1 coding of factors with two categories", {
  ref <- with_contrasts("contr.sum", get_refs(y ~ u, dat)$u)
  expect_identical(
    trimws(paste_dummies("M", 2L, 5L, "i", ref)),
    "M[i, 5] <- ifelse(M[i, 2] == 1, 1, ifelse(M[i, 2] == 0, -1, 0))"
  )

  ref <- with_contrasts(
    "contr.sum",
    get_refs(y ~ u, dat, refcats = list(u = "last"))$u
  )
  expect_identical(
    trimws(paste_dummies("M", 2L, 5L, "i", ref)),
    "M[i, 5] <- ifelse(M[i, 2] == 0, 1, ifelse(M[i, 2] == 1, -1, 0))"
  )
})


# incomplete factors -----------------------------------------------------------
dat_mis <- dat
dat_mis$f[1L:3L] <- NA
dat_mis$g[4L:6L] <- NA
dat_mis$u[7L:9L] <- NA

test_that("incomplete factors with contr.sum: JAGS model and design matrix", {
  mod <- with_contrasts(
    "contr.sum",
    lm_imp(
      y ~ f + g + u,
      data = dat_mis,
      n.adapt = 0L,
      n.iter = 0L,
      mess = FALSE
    )
  )
  M <- mod$data_list$M_lvlone
  column <- function(name) match(name, colnames(M))

  # the contrast variables are missing for the cases with a missing value
  expect_true(all(is.na(M[1L:3L, c("fb", "fc")])))
  expect_true(all(is.na(M[4L:6L, c("g20", "g30")])))
  expect_true(all(is.na(M[7L:9L, "uyes"])))

  dummy <- function(name, var, category, reference) {
    sprintf(
      "M_lvlone[i, %i] <- ifelse(M_lvlone[i, %i] == %i, 1, ifelse(M_lvlone[i, %i] == %i, -1, 0))",
      column(name),
      column(var),
      category,
      column(var),
      reference
    )
  }

  expect_setequal(
    ifelse_lines(mod),
    c(
      dummy("fb", "f", 2L, 1L),
      dummy("fc", "f", 3L, 1L),
      dummy("g20", "g", 2L, 1L),
      dummy("g30", "g", 3L, 1L),
      dummy("uyes", "u", 1L, 0L)
    )
  )
})

test_that("incomplete factors with contr.helmert use contr.treatment", {
  expect_warning(
    ref <- with_contrasts("contr.helmert", get_refs(y ~ f, dat_mis)$f),
    "contr.treatment"
  )
  expect_identical(attr(ref, "contrasts"), "contr.treatment")
  expect_identical(attr(ref, "dummies"), c("fb", "fc"))
})
