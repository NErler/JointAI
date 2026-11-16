# not used in the model set-up yet; built for the tests that compare it with
# Mlvls, fcts_all, interactions and lp_cols (2026-11-09)
#' Get the table of the columns of the design matrices
#'
#' Describes each column of the design matrices (`Mlist$M`) in one table: where
#' it comes from (the term of a model formula, its variables and the calls
#' that compute it from these variables), on which level it is, in which data
#' matrix and column it is stored, whether JAGS has to compute it and whether
#' it can be scaled. The columns and their order are those of the design
#' matrix that `divide_matrices()` creates: first the outcomes and the
#' covariates that have a model, then the columns of `model.matrix()` of each
#' formula in `terms_list` (columns that already exist are skipped), then the
#' variables of the model frames of the later formulas that are not yet a
#' column (e.g., a factor that is only used in an auxiliary variable), and the
#' intercept if no formula has one.
#'
#' The level of a column is derived from the levels of its variables and the
#' nesting relation of the grouping levels: it is the highest grouping level
#' that is nested in the levels of all its variables (a column of variables of
#' crossed levels is on a level below both of them). Columns without variables
#' (the intercept) are on the highest level. Of crossed levels with the same
#' rank, the level that comes last by name is used, as in [get_datlvls()].
#'
#' A column is computed in JAGS when it is a dummy variable, a function or an
#' interaction and at least one of its variables has missing values.
#'
#' A column can be scaled when it is a numeric variable, a function with a
#' numeric value, or an interaction of which at least one element has a
#' numeric value.
#'
#' @param terms_list a list of `terms` objects, one per formula (fixed effects,
#'        random effects without the grouping, auxiliary variables), as
#'        obtained from `get_terms_list()` (`Mlist$terms_list`)
#' @param outcomes the outcomes of the formulas, as obtained from
#'        `get_outcome_data()` (`Mlist$outcomes`)
#' @param models a named character vector with the model types, in the order
#'        of the models, as obtained from [get_models()]
#' @param refs a list with the reference categories of the factors, as
#'        obtained from `get_refs()` (`Mlist$refs`)
#' @param data a `data.frame` (after the reshaping for survival models with
#'        time-varying covariates and after last observation carried forward,
#'        as `Mlist$data`)
#' @param data_structure the structure of the data, as obtained from
#'        [get_data_structure()], possibly with the table of variables
#'        ([get_variable_table()]; computed here for variables that are not in
#'        it)
#'
#' @returns a `data.frame` with one row per column of the design matrices, in
#'   the order of the design matrix, and the columns
#'   * `column`: the name of the column,
#'   * `term`: the label of the term of the formula that the column belongs to
#'     (for the outcomes, the variables from the model frames and the
#'     intercept: the name of the column),
#'   * `kind`: `"intercept"`, `"variable"` (a variable of the data, possibly
#'     coded as integers), `"dummy"` (a dummy variable of a factor),
#'     `"function"` (a function of one or more variables, e.g., `log(x)`, one
#'     column of a spline, or the event indicator `status == 1`) or
#'     `"interaction"`,
#'   * `calls`: a list with, per row, the variables of the term as written in
#'     the formula (e.g., `"log(x)"` and `"z"` for the term `log(x):z`),
#'   * `variables`: a list with, per row, the names of the variables of the
#'     data that the column is computed from,
#'   * `level`: the name of the grouping level of the column,
#'   * `matrix`: the name of the data matrix (`"M_<level>"`),
#'   * `index`: the number of the column in its data matrix,
#'   * `computed`: whether JAGS has to compute the column,
#'   * `scalable`: whether the column can be scaled.
#' @keywords internal
#'
get_column_table <- function(
  terms_list,
  outcomes,
  models,
  refs,
  data,
  data_structure
) {
  # collect the columns of the outcomes and of the covariates that have a
  # model; they come first in the design matrix
  outcome_rows <- get_outcome_column_rows(outcomes, models, data)

  # collect the columns of the design matrices of all formulas and add those
  # that are not already outcome columns
  design_rows <- get_design_column_rows(terms_list, refs, data)
  design_rows <- design_rows[
    !design_rows$column %in% outcome_rows$column,
    ,
    drop = FALSE
  ]
  columns <- rbind(outcome_rows, design_rows)

  # describe all variables of the columns: the table of variables from
  # data_structure, completed for variables that are not in it
  variables <- data_structure$variables
  all_variables <- unique(unlist(columns$variables))
  new_variables <- setdiff(all_variables, rownames(variables))
  if (length(new_variables) > 0L) {
    variables <- rbind(
      variables,
      get_variable_table(data, data_structure, vars = new_variables)
    )
  }

  # determine the level of each column from the levels of its variables
  columns$level <- vapply(
    columns$variables,
    get_column_level,
    character(1L),
    variable_levels = setNames(variables$level, rownames(variables)),
    data_structure = data_structure
  )
  columns$matrix <- paste0("M_", columns$level)

  # number the columns within each data matrix, in the order of the table
  columns$index <- integer(nrow(columns))
  for (mat in unique(columns$matrix)) {
    in_matrix <- columns$matrix == mat
    columns$index[in_matrix] <- seq_len(sum(in_matrix))
  }

  # mark the dummy variables, functions and interactions of incomplete
  # variables: JAGS computes them from the (imputed) variables
  has_incomplete_variable <- vapply(
    columns$variables,
    function(vars) any(variables[vars, "n_missing"] > 0L),
    logical(1L)
  )
  columns$computed <- columns$kind %in%
    c("dummy", "function", "interaction") &
    has_incomplete_variable

  # mark the columns that can be scaled: the value of the column (variables,
  # functions) or of one of its elements (interactions) is numeric
  envir <- environment(terms_list[[1L]])
  columns$scalable <- FALSE
  for (i in seq_len(nrow(columns))) {
    calls <- columns$calls[[i]]
    columns$scalable[i] <- switch(
      columns$kind[i],
      intercept = FALSE,
      dummy = FALSE,
      variable = is.numeric(data[[calls]]) && !all(is.na(data[[calls]])),
      any(vapply(
        calls,
        is_numeric_call,
        logical(1L),
        data = data,
        envir = envir
      ))
    )
  }

  rownames(columns) <- NULL
  columns
}


# used in get_column_table (2026-11-09)
#' Get the columns of the outcomes and of the covariates that have a model
#'
#' @param outcomes the outcomes of the formulas, as obtained from
#'        `get_outcome_data()`
#' @param models a named character vector with the model types, in the order
#'        of the models, as obtained from [get_models()]
#' @param data a `data.frame`
#'
#' @returns a `data.frame` with the columns `column`, `term`, `kind`, `calls`
#'   and `variables` as described in [get_column_table()], one row per column
#' @keywords internal
#'
get_outcome_column_rows <- function(outcomes, models, data) {
  # take the columns of the outcomes of the formulas (for survival outcomes:
  # the time and the event indicator) and then the covariates that have a
  # model, as in the outcome matrix of divide_matrices()
  outcome_columns <- unlist(
    lapply(outcomes$outcomes, names),
    use.names = FALSE
  )
  covariate_columns <- setdiff(
    names(models),
    c(unlist(outcomes$outnams, use.names = FALSE), names(outcomes$outnams))
  )
  column_names <- unique(c(outcome_columns, covariate_columns))

  # describe each column: a variable of the data, or an expression of
  # variables (e.g., the event indicator `status != "censored"`)
  rows <- new_column_row(data)
  for (column in column_names) {
    kind <- if (column %in% names(data)) "variable" else "function"
    rows <- rbind(rows, new_column_row(data, column, column, kind, column))
  }
  rows
}


# used in get_column_table (2026-11-09)
#' Get the columns of the design matrices of the formulas
#'
#' Goes through the formulas in the order of `terms_list` and describes the
#' columns of their design matrices (`model.matrix()`, with the contrasts of
#' the factors from `refs`) and, from the second formula on, the variables of
#' their model frames that are not yet a column (as in `model_matrix_combi()`).
#' Each column is described once, where it occurs first. If no formula has an
#' intercept, the intercept is added as the first column.
#'
#' @param terms_list a list of `terms` objects, one per formula, as obtained
#'        from `get_terms_list()`
#' @param refs a list with the reference categories of the factors, as
#'        obtained from `get_refs()`
#' @param data a `data.frame`
#'
#' @returns a `data.frame` with the columns `column`, `term`, `kind`, `calls`
#'   and `variables` as described in [get_column_table()], one row per column
#' @keywords internal
#'
get_design_column_rows <- function(terms_list, refs, data) {
  # take the contrast matrices of the factors from refs (NULL without factors:
  # model.matrix() does not accept an unnamed empty list)
  contr_matrices <- if (length(refs) > 0L) lapply(refs, attr, "contr_matrix")

  rows <- new_column_row(data)
  for (i in seq_along(terms_list)) {
    tt <- terms_list[[i]]
    model_frame <- model.frame(tt, data = data, na.action = na.pass)

    # describe the columns of the design matrix of the formula and add those
    # that are not yet in the table
    formula_rows <- get_formula_column_rows(
      tt,
      model_frame,
      contr_matrices,
      data
    )
    rows <- rbind(
      rows,
      formula_rows[!formula_rows$column %in% rows$column, , drop = FALSE]
    )

    # from the second formula on, add the variables of the model frame that
    # are not yet a column (matrices, e.g., splines, and survival objects are
    # not added)
    if (i > 1L) {
      for (column in setdiff(names(model_frame), rows$column)) {
        if (inherits(model_frame[[column]], c("matrix", "Surv"))) {
          next
        }
        kind <- if (column %in% names(data)) "variable" else "function"
        rows <- rbind(rows, new_column_row(data, column, column, kind, column))
      }
    }
  }

  # add the intercept as first column if no formula has one (the covariate
  # models need it)
  if (!"(Intercept)" %in% rows$column) {
    intercept <- new_column_row(data, "(Intercept)", "(Intercept)", "intercept")
    rows <- rbind(intercept, rows)
  }
  rows
}


# used in get_design_column_rows (2026-11-09)
#' Describe the columns of the design matrix of one formula
#'
#' @param tt the `terms` object of the formula
#' @param model_frame the model frame of the formula (`model.frame()` of `tt`)
#' @param contr_matrices a named list with the contrast matrices of the factors
#'        (from `refs`), or `NULL`
#' @param data a `data.frame`
#'
#' @returns a `data.frame` with the columns `column`, `term`, `kind`, `calls`
#'   and `variables` as described in [get_column_table()], one row per column
#'   of the design matrix of the formula
#' @keywords internal
#'
get_formula_column_rows <- function(tt, model_frame, contr_matrices, data) {
  # create the design matrix of the formula, with the contrasts of the
  # factors that are covariates of this formula
  covariates <- vapply(
    as.list(attr(delete.response(tt), "variables"))[-1L],
    deparse,
    character(1L),
    width.cutoff = 500L
  )
  design_matrix <- model.matrix(
    tt,
    model_frame,
    contrasts.arg = contr_matrices[intersect(covariates, names(contr_matrices))]
  )

  # describe each column: "assign" gives the term of each column (0 for the
  # intercept), the "factors" attribute of the terms the variables of each
  # term as written in the formula (e.g., "log(x)" and "z" for the term
  # "log(x):z")
  term_index <- attr(design_matrix, "assign")
  term_labels <- attr(tt, "term.labels")
  factors <- attr(tt, "factors")
  rows <- new_column_row(data)
  for (j in seq_len(ncol(design_matrix))) {
    column <- colnames(design_matrix)[j]
    if (term_index[j] == 0L) {
      new_row <- new_column_row(data, column, column, "intercept")
    } else {
      term <- term_labels[term_index[j]]
      calls <- rownames(factors)[factors[, term] > 0L]
      kind <- get_column_kind(column, calls, data)
      new_row <- new_column_row(data, column, term, kind, calls)
    }
    rows <- rbind(rows, new_row)
  }
  rows
}


# used in get_outcome_column_rows, get_design_column_rows and
# get_formula_column_rows (2026-11-09)
#' Describe one column of the design matrix
#'
#' Creates one row of the table of columns ([get_column_table()]) with the
#' descriptive columns; the variables of the column are the variables of the
#' data that occur in the calls. Without arguments, a table without rows is
#' created.
#'
#' @param data a `data.frame`
#' @param column the name of the column, or `NULL` for a table without rows
#' @param term the label of the term that the column belongs to
#' @param kind the kind of the column (`"intercept"`, `"variable"`, `"dummy"`,
#'        `"function"` or `"interaction"`)
#' @param calls a character vector with the variables of the term as written in
#'        the formula (e.g., `"log(x)"` and `"z"` for the term `log(x):z`);
#'        empty for the intercept
#'
#' @returns a `data.frame` with one row (no rows if `column` is `NULL`) and the
#'   columns `column`, `term`, `kind`, `calls` and `variables` (the last two
#'   are lists)
#' @keywords internal
#'
new_column_row <- function(
  data,
  column = NULL,
  term = NULL,
  kind = NULL,
  calls = character(0L)
) {
  # create a table without rows if no column is given
  if (is.null(column)) {
    rows <- data.frame(
      column = character(0L),
      term = character(0L),
      kind = character(0L),
      stringsAsFactors = FALSE
    )
    rows$calls <- list()
    rows$variables <- list()
    return(rows)
  }

  # find the variables of the data in the calls: a call is a variable of the
  # data itself, or an expression of variables (e.g., "x" in "log(x)")
  variables <- character(0L)
  for (call in calls) {
    if (call %in% names(data)) {
      variables <- c(variables, call)
    } else {
      variables <- c(variables, all.vars(str2lang(call)))
    }
  }
  variables <- intersect(variables, names(data))

  new_row <- data.frame(
    column = column,
    term = term,
    kind = kind,
    stringsAsFactors = FALSE
  )
  new_row$calls <- list(calls)
  new_row$variables <- list(variables)
  new_row
}


# used in get_formula_column_rows (2026-11-09)
#' Get the kind of a column of a design matrix
#'
#' @param column the name of the column
#' @param calls the variables of the term of the column as written in the
#'        formula (e.g., `"log(x)"` and `"z"` for the term `log(x):z`)
#' @param data a `data.frame`
#'
#' @returns `"interaction"` for a term with more than one variable,
#'   `"variable"` for a variable of the data, `"dummy"` for a dummy variable of
#'   a variable of the data (a column with another name than the variable),
#'   and `"function"` otherwise
#' @keywords internal
#'
get_column_kind <- function(column, calls, data) {
  if (length(calls) > 1L) {
    "interaction"
  } else if (calls %in% names(data) && column == calls) {
    "variable"
  } else if (calls %in% names(data)) {
    "dummy"
  } else {
    "function"
  }
}


# used in get_column_table (2026-11-09)
#' Get the level of a column from the levels of its variables
#'
#' The level of a column is the highest grouping level that is nested in the
#' levels of all its variables, i.e., the highest level within which all its
#' variables are constant. Without variables (the intercept), this is the
#' highest level. Of crossed levels with the same rank, the level that comes
#' last by name is used, as in [get_datlvls()].
#'
#' @param vars a character vector with the names of the variables of the
#'        column
#' @param variable_levels a named character vector with the level of each
#'        variable (from the table of variables, [get_variable_table()])
#' @param data_structure the structure of the data, as obtained from
#'        [get_data_structure()]
#'
#' @returns the name of the grouping level
#' @keywords internal
#'
get_column_level <- function(vars, variable_levels, data_structure) {
  group_lvls <- data_structure$group_lvls
  nested_in <- data_structure$nested_in

  # sort the grouping levels from the lowest to the highest (ties by name)
  lvl_order <- names(group_lvls)[order(group_lvls, names(group_lvls))]

  # find the levels that are nested in the levels of all variables; the lowest
  # level is nested in all levels, so there is at least one
  var_lvls <- unique(variable_levels[vars])
  candidates <- lvl_order[
    rowSums(!nested_in[lvl_order, var_lvls, drop = FALSE]) == 0L
  ]

  # take the highest of them
  candidates[length(candidates)]
}


# used in get_column_table (2026-11-09)
#' Check whether a call has a numeric value
#'
#' @param call a character string with a variable of the data or an expression
#'        of variables of the data (e.g., `"log(x)"`)
#' @param data a `data.frame`
#' @param envir the environment in which functions in the call are looked up
#'        (the environment of the formula)
#'
#' @returns `TRUE` if the value of the call, evaluated in the data, is numeric
#'   (a numeric vector or matrix, not a factor and not logical)
#' @keywords internal
#'
is_numeric_call <- function(call, data, envir) {
  if (call %in% names(data)) {
    return(is.numeric(data[[call]]))
  }
  is.numeric(eval(str2lang(call), envir = data, enclos = envir))
}
