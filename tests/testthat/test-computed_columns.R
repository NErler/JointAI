# The columns of the design matrices that JAGS computes: the parts of each
# column (get_column_parts() and its helpers in R/column_table.R) and the JAGS
# expressions built from them (R/computed_columns.R). Whether the computed
# values are right is checked in JAGS in test-linear_predictors.R.

# get the table of columns of a model that was set up (the table itself is not
# stored in the fitted object)
column_table_of <- function(fit) {
  get_column_table(
    fit$Mlist$terms_list,
    fit$Mlist$outcomes,
    fit$models,
    fit$Mlist$refs,
    fit$data,
    get_data_structure(fit$data, fit$Mlist$idvar)
  )
}


# get_coding_codes() -----------------------------------------------------------

test_that("get_coding_codes(): without intercept, indicators", {
  # set-up: no intercept; the first term (C1) has no factor, so the first
  # factor of the next term (B2) is coded by indicators, M2 by contrasts
  tt <- terms(~ 0 + C1 + B2 + M2)
  model_frame <- model.frame(tt, data = wideDF, na.action = na.pass)

  codes <- get_coding_codes(tt, model_frame)

  expect_equal(codes["B2", "B2"], 2L)
  expect_equal(codes["M2", "M2"], 1L)

  # with intercept, the factors attribute is not changed
  tt <- terms(~ C1 + B2 + M2)
  expect_equal(get_coding_codes(tt, model_frame), attr(tt, "factors"))
})


# get_term_parts() -------------------------------------------------------------

# a factor whose contrasts have no column names (Helmert contrasts, set in the
# data instead of in refs)
wide_helmert <- wideDF
contrasts(wide_helmert$M2) <- contr.helmert(4L)

# formulas with factors coded by contrasts and by indicators, functions, a
# spline, a logical variable, and interactions of these; the contrasts are
# taken from refs (as in JointAI), unless `refs = FALSE`
cases <- list(
  factor_interactions = list(formula = ~ C1 + M2 * B2 + log(C1):M2),
  without_main_effects = list(formula = ~ B2:C2 + log(C1):M2),
  without_intercept = list(formula = ~ 0 + C1 + B2 + M2 + C1:M2),
  spline = list(formula = ~ ns(C1, df = 2) * B2),
  logical = list(formula = ~ I(C1 > 1.44) + I(C1 > 1.44):C2),
  # a logical variable in which TRUE does not occur
  logical_one_value = list(formula = ~ I(C1 > 2) + C2),
  # contrasts and a matrix without column names: model.matrix() numbers the
  # columns
  without_column_names = list(
    formula = ~ C1 + M2 + I(unname(cbind(C1, C2))),
    data = wide_helmert,
    refs = FALSE
  )
)

for (case in names(cases)) {
  test_that(
    paste("get_term_parts() gives the columns of model.matrix():", case),
    {
      # set-up: the terms, model frame and design matrix of the formula, with
      # the contrasts of the factors as in JointAI (from refs)
      spec <- cases[[case]]
      data <- if (is.null(spec$data)) wideDF else spec$data
      tt <- terms(spec$formula)
      model_frame <- model.frame(tt, data = data, na.action = na.pass)
      contr_matrices <- if (!isFALSE(spec$refs)) {
        lapply(get_refs(list(spec$formula), data), attr, "contr_matrix")
      }
      design_matrix <- model.matrix(
        tt,
        model_frame,
        contrasts.arg = contr_matrices
      )

      parts <- get_term_parts(tt, model_frame, contr_matrices, modelled = NULL)

      # the parts name the same columns as model.matrix() (apart from the
      # intercept, which is not the column of a term)
      expect_equal(
        names(parts),
        setdiff(colnames(design_matrix), "(Intercept)")
      )

      # the value of each column, computed in R from its parts (the product of
      # the values of the parts), is the column of model.matrix()
      for (column in names(parts)) {
        value <- rep(1, nrow(model_frame))
        for (part in parts[[column]]) {
          x <- model_frame[[part$call]]
          value <- value *
            switch(
              part$type,
              factor = unname(part$values[as.character(x)]),
              matrix = x[, part$column],
              value = x
            )
        }
        expect_equal(value, unname(design_matrix[, column]), info = column)
      }
    }
  )
}

test_that("get_call_codings() gives the codes of the categories", {
  # set-up: a binary factor and a factor with four categories
  model_frame <- model.frame(~ B2 + M2, data = wideDF, na.action = na.pass)

  # factors with a model: binary 0/1, others 1, 2, ...
  expect_equal(
    get_call_codings("B2", 1L, model_frame, NULL, modelled = "B2")$codes,
    c(`0` = 0, `1` = 1)
  )
  expect_equal(
    get_call_codings("M2", 1L, model_frame, NULL, modelled = "M2")$codes,
    c(`1` = 1, `2` = 2, `3` = 3, `4` = 4)
  )
  # factors without a model (data.matrix()): 1, 2, ... also when binary
  expect_equal(
    get_call_codings("B2", 1L, model_frame, NULL, modelled = NULL)$codes,
    c(`0` = 1, `1` = 2)
  )
})


# get_column_parts() -----------------------------------------------------------

test_that("get_column_table() has the parts of each column", {
  # set-up: a model with a factor in an interaction without its main effect
  fit <- lme_imp(
    y ~ b2:c2 + (1 | id),
    data = longDF,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )

  tab <- column_table_of(fit)
  parts <- setNames(tab$parts, tab$column)

  # the intercept has no part, the variables are their own part
  expect_equal(parts[["(Intercept)"]], list())
  expect_equal(
    parts[["c2"]],
    list(list(call = "c2", type = "value", name = "c2"))
  )

  # b20:c2 is the indicator of the category 0 of b2 (b2 has a model, so the
  # category is coded 0 in the data matrix) times c2
  expect_equal(
    parts[["b20:c2"]],
    list(
      list(
        call = "b2",
        type = "factor",
        name = "b20",
        values = c(`0` = 1, `1` = 0),
        codes = c(`0` = 0, `1` = 1)
      ),
      list(call = "c2", type = "value", name = "c2")
    )
  )
})


test_that("get_column_parts() stops if a column is not a column of a term", {
  # set-up: a dummy variable that no term of the formula has
  columns <- data.frame(
    column = "B2x",
    kind = "dummy",
    stringsAsFactors = FALSE
  )
  terms_list <- list(terms(~ C1 + B2))

  expect_error(
    get_column_parts(columns, terms_list, refs = NULL, wideDF, modelled = NULL),
    "could not determine[[:space:]]+how[[:space:]]+the[[:space:]]+column"
  )
})


test_that("get_column_table() adds the parts of computed interactions", {
  # set-up: a factor and a function of a variable of a higher level in
  # interactions without their main effects
  fit <- lme_imp(
    y ~ b2:c2 + log(C1):c2 + (1 | id),
    data = longDF,
    n.adapt = 0,
    n.iter = 0,
    mess = FALSE,
    warn = FALSE
  )
  tab <- column_table_of(fit)

  # the parts that are not columns of a formula are added at the end: b20 (b2
  # is incomplete, so it is computed in JAGS) and log(C1) (C1 is complete, so
  # it is data, on the level of the subjects); b21 is a column already
  expect_equal(
    tab[tab$added, c("column", "kind", "level", "computed")],
    data.frame(
      column = c("b20", "log(C1)"),
      kind = c("dummy", "function"),
      level = c("lvlone", "id"),
      computed = c(TRUE, FALSE),
      stringsAsFactors = FALSE
    ),
    ignore_attr = TRUE
  )

  # their values, computed in R: the indicator of the category 0 of b2
  # (missing where b2 is missing) and log(C1)
  values <- get_added_column_values(tab, fit$data, envir = globalenv())
  expect_equal(
    values[, "b20"],
    as.numeric(fit$data$b2 == "0")
  )
  expect_equal(values[, "log(C1)"], log(fit$data$C1))
})
