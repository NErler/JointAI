# The table of the columns of the design matrices (get_column_table()) and its
# helpers. The table describes each column once: its term, variables, level,
# data matrix and position, and whether JAGS computes it and it can be scaled.
# It decides which columns JAGS computes; the last part of this file checks
# that it agrees with the other structures that divide_matrices() creates
# (Mlvls, the design matrices, fcts_all, interactions, lp_cols, scale_pars),
# using the stored results of the golden master cases.

# get_column_kind() ------------------------------------------------------------

test_that("get_column_kind() distinguishes the kinds of columns", {
  # a variable of the data, as it is
  expect_equal(get_column_kind("C1", "C1", wideDF), "variable")
  # a dummy variable of the factor B2
  expect_equal(get_column_kind("B21", "B2", wideDF), "dummy")
  # a function of a variable, with one or more columns
  expect_equal(get_column_kind("log(C1)", "log(C1)", wideDF), "function")
  expect_equal(
    get_column_kind("ns(C1, df = 2)1", "ns(C1, df = 2)", wideDF),
    "function"
  )
  # a term with more than one variable
  expect_equal(get_column_kind("C1:B21", c("C1", "B2"), wideDF), "interaction")
})


# is_numeric_call() ------------------------------------------------------------

test_that("is_numeric_call() checks the value of variables and expressions", {
  # variables: numeric, and a factor
  expect_true(is_numeric_call("C1", wideDF, envir = globalenv()))
  expect_false(is_numeric_call("B2", wideDF, envir = globalenv()))
  # expressions: a numeric function, a spline (a numeric matrix), and a
  # comparison (logical)
  expect_true(is_numeric_call("abs(C1 - C2)", wideDF, envir = globalenv()))
  expect_true(is_numeric_call("ns(C1, df = 2)", wideDF, envir = globalenv()))
  expect_false(is_numeric_call("C1 > 0", wideDF, envir = globalenv()))
})


# new_column_row() -------------------------------------------------------------

test_that("new_column_row() describes one column", {
  # a function of two variables: the variables are found in the call
  new_row <- new_column_row(
    wideDF,
    "abs(C1 - C2)",
    "abs(C1 - C2)",
    "function",
    "abs(C1 - C2)"
  )
  expect_equal(nrow(new_row), 1L)
  expect_equal(new_row$calls, list("abs(C1 - C2)"))
  expect_equal(new_row$variables, list(c("C1", "C2")))

  # the intercept has no calls and no variables
  intercept <- new_column_row(wideDF, "(Intercept)", "(Intercept)", "intercept")
  expect_equal(intercept$variables, list(character(0L)))
})

test_that("new_column_row() creates a table without rows", {
  rows <- new_column_row(wideDF)
  # the table has the descriptive columns, but no rows
  expect_equal(names(rows), c("column", "term", "kind", "calls", "variables"))
  expect_equal(nrow(rows), 0L)

  # rows can be added to it
  new_row <- new_column_row(wideDF, "C1", "C1", "variable", "C1")
  expect_equal(rbind(rows, new_row), new_row)
})


# get_column_level() -----------------------------------------------------------

test_that("get_column_level() takes the lowest level of nested variables", {
  # set-up: three nested levels, id in center (longDF with a center variable)
  dat <- longDF
  dat$center <- as.integer(dat$id) %% 5L
  data_structure <- get_data_structure(dat, c("id", "center"))
  variable_levels <- c(Z = "center", C1 = "id", c1 = "lvlone")

  # a variable of one level
  expect_equal(
    get_column_level("Z", variable_levels, data_structure),
    "center"
  )
  # variables of center and id: the column is on level id
  expect_equal(
    get_column_level(c("Z", "C1"), variable_levels, data_structure),
    "id"
  )
  # variables of all three levels: the column is on the lowest level
  expect_equal(
    get_column_level(c("Z", "C1", "c1"), variable_levels, data_structure),
    "lvlone"
  )
  # no variables (the intercept): the highest level
  expect_equal(
    get_column_level(character(0L), variable_levels, data_structure),
    "center"
  )
})

test_that("get_column_level() puts columns of crossed levels below both", {
  # set-up: the crossed levels id and o1 in longDF (both have rank 2)
  data_structure <- get_data_structure(longDF, c("id", "o1"))
  variable_levels <- c(C1 = "id", Z = "o1")

  # variables of the two crossed levels: neither level is nested in the other,
  # so the column is on the lowest level
  expect_equal(
    get_column_level(c("C1", "Z"), variable_levels, data_structure),
    "lvlone"
  )
  # no variables: of the two highest levels, the one that comes last by name
  expect_equal(
    get_column_level(character(0L), variable_levels, data_structure),
    "o1"
  )
})


# get_outcome_column_rows() ----------------------------------------------------

test_that("get_outcome_column_rows() describes the outcome columns", {
  # set-up: a survival model, with the outcome Surv(futime, status == "dead")
  # and a covariate model for copper
  fixed <- list(Surv(futime, status == "dead") ~ age + copper)
  data_structure <- get_data_structure(PBC, NULL)
  outcomes <- get_outcome_data(
    fixed,
    data = PBC,
    data_structure = data_structure,
    analysis_type = "survreg"
  )
  models <- c(`Surv(futime, status == "dead")` = "survreg", copper = "lm")

  rows <- get_outcome_column_rows(outcomes, models, PBC)

  # the survival time and the event indicator, then the covariate
  expect_equal(rows$column, c("futime", 'status == "dead"', "copper"))
  # the event indicator is an expression of the variable status
  expect_equal(rows$kind, c("variable", "function", "variable"))
  expect_equal(rows$variables, list("futime", "status", "copper"))
})


# get_formula_column_rows() ----------------------------------------------------

test_that("get_formula_column_rows() describes the columns of one formula", {
  # set-up: a formula with a spline (two columns of one term) and an
  # interaction of a function with a factor
  tt <- terms(y ~ ns(C1, df = 2) + exp(C2):B2)
  model_frame <- model.frame(tt, data = wideDF, na.action = na.pass)

  rows <- get_formula_column_rows(tt, model_frame, NULL, wideDF)

  # one row per column of model.matrix(), with the term of each column
  expect_equal(
    rows$column,
    c(
      "(Intercept)",
      "ns(C1, df = 2)1",
      "ns(C1, df = 2)2",
      "exp(C2):B20",
      "exp(C2):B21"
    )
  )
  expect_equal(
    rows$term,
    c(
      "(Intercept)",
      "ns(C1, df = 2)",
      "ns(C1, df = 2)",
      "exp(C2):B2",
      "exp(C2):B2"
    )
  )
  expect_equal(
    rows$kind,
    c("intercept", "function", "function", "interaction", "interaction")
  )
  expect_equal(rows$calls[[4L]], c("exp(C2)", "B2"))
  expect_equal(rows$variables[[4L]], c("C2", "B2"))
})


# get_design_column_rows() -----------------------------------------------------

test_that("get_design_column_rows() describes the design matrix columns", {
  # set-up: an analysis model with a function and an interaction, and the
  # factor M2 as auxiliary variable
  fixed <- list(y = y ~ C1 + exp(C2) + B2 * C1)
  auxvars <- ~M2
  terms_list <- get_terms_list(c(fixed, auxvars), data = wideDF)
  refs <- get_refs(c(fixed, auxvars), wideDF)

  rows <- get_design_column_rows(terms_list, refs, wideDF)

  # the columns of model.matrix() of the analysis model, then those of the
  # auxiliary variables (the dummies of M2), then the variable M2 itself from
  # the model frame of the auxiliary variables, which is not a column yet
  expect_equal(
    rows$column,
    c(
      "(Intercept)",
      "C1",
      "exp(C2)",
      "B21",
      "C1:B21",
      "M22",
      "M23",
      "M24",
      "M2"
    )
  )
  expect_equal(
    rows$kind,
    c(
      "intercept",
      "variable",
      "function",
      "dummy",
      "interaction",
      "dummy",
      "dummy",
      "dummy",
      "variable"
    )
  )
  # the term and its variables as written in the formula, and the variables of
  # the data
  expect_equal(rows$term[rows$column == "C1:B21"], "C1:B2")
  expect_equal(rows$calls[[which(rows$column == "C1:B21")]], c("C1", "B2"))
  expect_equal(rows$variables[[which(rows$column == "exp(C2)")]], "C2")
})

test_that("get_design_column_rows() adds the intercept if there is none", {
  # set-up: an analysis model without intercept
  fixed <- list(y = y ~ 0 + C1 + C2)
  terms_list <- get_terms_list(fixed, data = wideDF)

  rows <- get_design_column_rows(terms_list, refs = NULL, wideDF)

  # the intercept is added as first column
  expect_equal(rows$column, c("(Intercept)", "C1", "C2"))
  expect_equal(rows$kind[1L], "intercept")
})


# get_column_table() -----------------------------------------------------------

test_that("get_column_table() describes the columns of a two-level model", {
  # set-up: the steps of divide_matrices() that give the input: structure of
  # the data, outcomes, model types, reference categories and terms. C2 (level
  # id) and b2 and c1 (level one) are incomplete.
  fixed <- list(y ~ C1 + I(C2^2) + b2 * c1)
  random <- list(~ 1 | id)
  data_structure <- get_data_structure(longDF, extract_grouping(random))
  outcomes <- get_outcome_data(
    fixed,
    data = longDF,
    data_structure = data_structure,
    analysis_type = "lmm"
  )
  fixed <- outcomes$fixed
  models <- get_models(
    fixed = fixed,
    random = random,
    data = longDF,
    data_structure = data_structure
  )
  refs <- get_refs(fixed, longDF)
  terms_list <- get_terms_list(
    c(fixed, remove_grouping(random)),
    data = longDF
  )

  tab <- get_column_table(
    terms_list,
    outcomes,
    models,
    refs,
    longDF,
    data_structure
  )

  # first the outcome and the covariates with a model, in the order of the
  # models, then the other columns of the design matrix
  expect_equal(
    tab$column,
    c(
      names(models),
      "(Intercept)",
      "C1",
      "I(C2^2)",
      "b21",
      "b21:c1"
    )
  )

  # the level of each column follows from its variables; the intercept is on
  # the highest level
  expect_equal(
    setNames(tab$level, tab$column)[c("C1", "I(C2^2)", "b21:c1")],
    c(C1 = "id", `I(C2^2)` = "id", `b21:c1` = "lvlone")
  )
  expect_equal(tab$level[tab$column == "(Intercept)"], "id")
  expect_equal(tab$matrix, paste0("M_", tab$level))

  # the columns are numbered within each data matrix, in the order of the table
  for (mat in unique(tab$matrix)) {
    expect_equal(tab$index[tab$matrix == mat], seq_len(sum(tab$matrix == mat)))
  }

  # the function of C2, the dummy of b2 and the interaction are computed in
  # JAGS (all have an incomplete variable); variables and the intercept are
  # not
  expect_equal(
    tab$column[tab$computed],
    c("I(C2^2)", "b21", "b21:c1")
  )

  # numeric variables, numeric functions and interactions with a numeric
  # element can be scaled; the intercept, factors and dummies not
  expect_equal(
    setNames(tab$scalable, tab$column)[c(
      "(Intercept)",
      "b2",
      "b21",
      "C1",
      "I(C2^2)",
      "b21:c1"
    )],
    c(
      `(Intercept)` = FALSE,
      b2 = FALSE,
      b21 = FALSE,
      C1 = TRUE,
      `I(C2^2)` = TRUE,
      `b21:c1` = TRUE
    )
  )
})


# agreement with the current structures --------------------------------------
# For each case, the table is created from the results of the model set-up and
# compared with the structures that divide_matrices() creates now. The cases
# are the golden master cases (stored results in tests/testthat/golden/) and
# joint models with factors on each level, functions and interactions, set up
# here without running JAGS (n.adapt = 0, n.iter = 0). The table describes the
# data matrices M_<level>, not the matrix of the quadrature points of joint
# models (M_lvlonegk).
#
# In joint models, the data get one row per subject at the event time, with
# missing values in the time-varying variables (reformat_longsurvdata()). So
# complete longitudinal variables are incomplete in the model, and their
# dummies are computed in JAGS, as for any incomplete factor.

# data for the joint models: 60 subjects of PBC, with a complete binary
# variable of the observations (Blong), and subjects in two centers (with a
# complete binary variable of the centers)
pbc <- droplevels(PBC[PBC$id %in% unique(PBC$id)[1:60], ])
pbc$Blong <- factor(ifelse(pbc$albumin > 3.5, "high", "low"))
pbc$center <- factor(ifelse(as.numeric(pbc$id) %% 2L == 0L, "a", "b"))
# ordered factor of the observations with three categories (Olong); unordered
# factors of the subjects with three categories, complete (Msub) and
# incomplete (Msubmis)
pbc$Olong <- cut(
  pbc$albumin,
  c(-Inf, 3.2, 3.7, Inf),
  labels = c("a", "b", "c"),
  ordered_result = TRUE
)
pbc$Msub <- factor(c("a", "b", "c")[as.numeric(pbc$id) %% 3L + 1L])
pbc$Msubmis <- pbc$Msub
pbc$Msubmis[pbc$id %in% unique(pbc$id)[c(3L, 8L, 20L)]] <- NA

cases <- list(
  # binary longitudinal covariate of the survival model, complete in the data
  jm_complete_long_factor = quote(JM_imp(
    list(
      Surv(futime, status != "censored") ~ age + Blong + (1 | id),
      Blong ~ day + (1 | id)
    ),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )),
  # the same variable only as covariate of the longitudinal model
  jm_complete_long_covariate = quote(JM_imp(
    list(
      Surv(futime, status != "censored") ~ age + chol + (1 | id),
      chol ~ day + Blong + (1 | id)
    ),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )),
  # binary covariate of the subjects (the level of the survival outcome)
  jm_subject_factor = quote(JM_imp(
    list(
      Surv(futime, status != "censored") ~ sex + chol + (1 | id),
      chol ~ day + sex + (1 | id)
    ),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )),
  # ordered factor of the observations with three categories, complete in
  # the data (unordered factors of the observations are not possible in joint
  # models)
  jm_ordered_long_factor = quote(JM_imp(
    list(
      Surv(futime, status != "censored") ~ age + Olong + (1 | id),
      Olong ~ day + (1 | id)
    ),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )),
  # unordered factors of the subjects with three categories, complete and
  # incomplete
  jm_subject_multinomial = quote(JM_imp(
    list(
      Surv(futime, status != "censored") ~ Msub + Msubmis + chol + (1 | id),
      chol ~ day + Msubmis + (1 | id)
    ),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )),
  # functions of time-varying variables in the survival model and in a
  # longitudinal model
  jm_functions = quote(JM_imp(
    list(
      Surv(futime, status != "censored") ~ age + log(albumin) + (1 | id),
      albumin ~ day + I(platelet / 100) + (1 | id)
    ),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )),
  # interactions of time-varying variables (binary and continuous) with
  # variables of the subjects (continuous and unordered factor) in the
  # survival model
  jm_interactions_survival = quote(JM_imp(
    list(
      Surv(futime, status != "censored") ~ Blong *
        age +
        Msubmis * albumin +
        (1 | id),
      Blong ~ day + (1 | id),
      albumin ~ day + (1 | id)
    ),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )),
  # the same kind of interactions in a longitudinal model
  jm_interactions_long_model = quote(JM_imp(
    list(
      Surv(futime, status != "censored") ~ age + chol + (1 | id),
      chol ~ day + Blong * age + albumin * sex + (1 | id)
    ),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )),
  # binary covariate of the centers (above the level of the survival outcome)
  jm_center_factor = quote(JM_imp(
    list(
      Surv(futime, status != "censored") ~ center + chol + (1 | id),
      chol ~ day + center + (1 | id) + (1 | center)
    ),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  ))
)

test_that("joint models: only dummies of time-varying factors are computed", {
  # set-up: a joint model with a complete binary variable on each level: of
  # the observations (Blong), the subjects (sex) and the centers (center)
  fit <- suppressWarnings(JM_imp(
    list(
      Surv(futime, status != "censored") ~ center + sex + Blong + (1 | id),
      Blong ~ day + center + (1 | id) + (1 | center)
    ),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  ))
  data_structure <- get_data_structure(fit$data, fit$Mlist$idvar)

  tab <- get_column_table(
    fit$Mlist$terms_list,
    fit$Mlist$outcomes,
    fit$models,
    fit$Mlist$refs,
    fit$data,
    data_structure
  )

  # Blong is missing in the rows added at the event times, so its dummy is
  # computed; sex and center are constant within subjects and complete
  expect_true(anyNA(fit$data$Blong))
  expect_equal(
    setNames(tab$computed, tab$column)[c("Blonglow", "sexfemale", "centerb")],
    c(Blonglow = TRUE, sexfemale = FALSE, centerb = FALSE)
  )
})

test_that("joint models: functions and interactions of time-varying data", {
  # set-up: a joint model with a function of a variable of the subjects
  # (log(age)) and an interaction of a binary time-varying variable with a
  # variable of the subjects (Blong:age)
  fit <- suppressWarnings(JM_imp(
    list(
      Surv(futime, status != "censored") ~ log(age) + Blong * age + (1 | id),
      Blong ~ day + (1 | id)
    ),
    timevar = "day",
    data = pbc,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  ))
  data_structure <- get_data_structure(fit$data, fit$Mlist$idvar)

  tab <- get_column_table(
    fit$Mlist$terms_list,
    fit$Mlist$outcomes,
    fit$models,
    fit$Mlist$refs,
    fit$data,
    data_structure
  )

  # the function of age is data on the level of the subjects; the dummy of
  # Blong and the interaction are computed on the level of the observations
  expect_equal(
    tab[
      match(c("log(age)", "Blonglow", "Blonglow:age"), tab$column),
      c(
        "kind",
        "level",
        "computed"
      )
    ],
    data.frame(
      kind = c("function", "dummy", "interaction"),
      level = c("id", "lvlone", "lvlone"),
      computed = c(FALSE, TRUE, TRUE),
      stringsAsFactors = FALSE
    ),
    ignore_attr = TRUE
  )
})

# add the golden master cases, which read the stored results
golden_files <- list.files(test_path("golden"), pattern = "\\.rds$")
for (file in setdiff(golden_files, "info.rds")) {
  cases[[sub("\\.rds$", "", file)]] <- bquote(
    readRDS(test_path("golden", .(file)))
  )
}

for (case in names(cases)) {
  test_that(paste("the column table agrees with divide_matrices():", case), {
    # set-up: the results of the model set-up and the structure of its data
    stored <- suppressWarnings(eval(cases[[case]]))
    mlist <- stored$Mlist
    data_structure <- get_data_structure(stored$data, mlist$idvar)

    tab <- get_column_table(
      mlist$terms_list,
      mlist$outcomes,
      stored$models,
      mlist$refs,
      stored$data,
      data_structure
    )

    # the columns, their order and their data matrices are those of Mlvls
    expect_equal(tab$column, names(mlist$Mlvls))
    expect_equal(tab$matrix, unname(mlist$Mlvls))

    # each column is in the given position of its data matrix (from the
    # data_list)
    for (mat in unique(tab$matrix)) {
      in_matrix <- tab$matrix == mat
      data_matrix <- stored$data_list[[mat]]
      expect_equal(ncol(data_matrix), sum(in_matrix))
      expect_equal(
        colnames(data_matrix)[tab$index[in_matrix]],
        tab$column[in_matrix]
      )
    }

    # the columns of the linear predictors (lp_cols: matrix and position of
    # each column) are found in the same matrix and position
    for (model in names(mlist$lp_cols)) {
      for (mat in names(mlist$lp_cols[[model]])) {
        lp <- mlist$lp_cols[[model]][[mat]]
        rows <- match(names(lp), tab$column)
        expect_equal(tab$matrix[rows], rep(mat, length(lp)))
        expect_equal(tab$index[rows], unname(lp))
      }
    }

    # the computed columns are those that are completely missing in the data
    # matrices (they are set to NA, to be computed in JAGS)
    all_missing <- character(0L)
    for (mat in unique(tab$matrix)) {
      data_matrix <- stored$data_list[[mat]]
      all_missing <- c(
        all_missing,
        colnames(data_matrix)[colSums(!is.na(data_matrix)) == 0L]
      )
    }
    expect_setequal(tab$column[tab$computed], all_missing)

    # the functions of covariates (fcts_all) are the function columns, with
    # the same variables; the event indicators of survival outcomes are
    # functions of the outcome, not of covariates
    outcome_columns <- unlist(lapply(mlist$outcomes$outcomes, names))
    is_covariate_function <- tab$kind == "function" &
      !tab$column %in% outcome_columns
    expect_setequal(
      as.character(unique(mlist$fcts_all$colname)),
      tab$column[is_covariate_function]
    )
    for (fct in unique(mlist$fcts_all$colname)) {
      expect_setequal(
        tab$variables[[which(tab$column == fct)]],
        mlist$fcts_all$var[mlist$fcts_all$colname == fct]
      )
    }

    # the interactions are the columns of interaction terms ("interactions"
    # has those whose elements are all columns)
    expect_true(all(
      names(mlist$interactions) %in% tab$column[tab$kind == "interaction"]
    ))
    expect_setequal(
      tab$column[tab$kind == "interaction"],
      grep(":", names(mlist$Mlvls), fixed = TRUE, value = TRUE)
    )

    # the scalable columns are those with scaling parameters
    scale_pars <- do.call(rbind, unname(mlist$scale_pars))
    expect_setequal(
      tab$column[tab$scalable],
      rownames(scale_pars)[!is.na(scale_pars$center)]
    )
  })
}
