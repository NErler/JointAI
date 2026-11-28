# used in divide_matrices (2026-11-27)
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
#' JAGS computes an interaction as the product of the columns of its parts.
#' Parts that are not a column of any design matrix (e.g., `b20` and `log(C1)`
#' in `b2:c2` and `log(C1):c2` without the main effects) are added at the end
#' of the table (`added`): as data if their variables are complete (computed
#' once in R, see [get_added_column_values()]), otherwise computed in JAGS.
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
#'   * `added`: whether the column was added as part of a computed
#'     interaction (it is not a column of `model.matrix()` of any formula),
#'   * `scalable`: whether the column can be scaled,
#'   * `parts`: a list with, per row, one element per call of the term, which
#'     describes which column of the coding of that call the column uses (see
#'     [get_column_parts()]).
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

  # describe, for each call of the term of a column, which of the columns of
  # that call's own coding the column uses (needed to write the column in
  # JAGS)
  columns$parts <- get_column_parts(
    columns,
    terms_list,
    refs,
    data,
    modelled = names(models)
  )

  # mark the dummy variables, functions and interactions of incomplete
  # variables: JAGS computes them from the (imputed) variables
  columns$computed <- is_computed_column(columns, variables)

  # add the parts of computed interactions that are not yet a column (e.g.,
  # b20 or log(C1) in b2:c2 or log(C1):c2 without the main effects), so that
  # JAGS computes each interaction as the product of columns
  columns$added <- FALSE
  part_rows <- get_part_rows(columns, data)
  if (nrow(part_rows) > 0L) {
    part_rows$computed <- is_computed_column(part_rows, variables)
    part_rows$added <- TRUE
    columns <- rbind(columns, part_rows)
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


# used in get_column_table (2026-11-27)
#' Check which columns are computed in JAGS
#'
#' @param columns a table of columns with the columns `kind` and `variables`
#'        (see [get_column_table()])
#' @param variables the table of variables, as obtained from
#'        [get_variable_table()], with the column `n_missing`
#'
#' @returns a logical vector: `TRUE` for dummy variables, functions and
#'   interactions of which at least one variable has missing values
#' @keywords internal
#'
is_computed_column <- function(columns, variables) {
  has_incomplete_variable <- vapply(
    columns$variables,
    function(vars) any(variables[vars, "n_missing"] > 0L),
    logical(1L)
  )
  columns$kind %in%
    c("dummy", "function", "interaction") &
    has_incomplete_variable
}


# used in get_column_table (2026-11-27)
#' Get the parts of computed interactions that are not yet a column
#'
#' JAGS computes an interaction as the product of the columns of its parts. A
#' part that is not a column with the same meaning (see [find_part_column()])
#' gets a new column: a dummy variable for a category of a factor (e.g., `b20`
#' in `b2:c2` without `b2`), otherwise a function (e.g., `log(C1)` or a column
#' of a spline). Each part is added once, also when several interactions use
#' it.
#'
#' @param columns the table of columns, with the columns `column`, `kind`,
#'        `parts` and `computed` (see [get_column_table()])
#' @param data a `data.frame`
#'
#' @returns a `data.frame` with the columns `column`, `term`, `kind`, `calls`,
#'   `variables` and `parts`, one row per added column (no rows if none is
#'   needed)
#' @keywords internal
#'
get_part_rows <- function(columns, data) {
  # collect the parts that are needed, by name
  needed <- list()
  for (i in which(columns$kind == "interaction" & columns$computed)) {
    for (part in columns$parts[[i]]) {
      if (!is.na(find_part_column(part, columns))) {
        next
      }
      # a column with this name but another meaning (e.g., coded by sum
      # contrasts instead of indicators) cannot be added
      if (part$name %in% columns$column) {
        errormsg(
          "JAGS has to compute the column %s, but the column %s of the
          design matrix is coded differently than in this interaction.",
          dQuote(columns$column[i]),
          dQuote(part$name)
        )
      }
      needed[[part$name]] <- part
    }
  }

  # describe each part as a column; its only part is the part itself
  rows <- new_column_row(data)
  for (part in needed) {
    kind <- get_column_kind(part$name, part$call, data)
    rows <- rbind(
      rows,
      new_column_row(data, part$name, part$call, kind, part$call)
    )
  }
  rows$parts <- lapply(unname(needed), list)
  rows
}


# used in get_part_rows and get_column_call (2026-11-27)
#' Find the column of the design matrices that equals a part of an interaction
#'
#' @param part a part of a column, as obtained from [select_part()]
#' @param column_table the table of the columns of the design matrices
#'
#' @returns the row of the column in `column_table` that has the name of the
#'   part and the same meaning (the same call and, for a factor, the same
#'   values per category), or `NA`
#' @keywords internal
#'
find_part_column <- function(part, column_table) {
  j <- match(part$name, column_table$column)
  if (is.na(j) || length(column_table$parts[[j]]) != 1L) {
    return(NA_integer_)
  }

  # a dummy variable with this name may be coded differently (e.g., by sum
  # contrasts instead of indicators)
  other <- column_table$parts[[j]][[1L]]
  same <- identical(other$call, part$call) &&
    identical(other$type, part$type) &&
    isTRUE(all.equal(other$values, part$values)) &&
    identical(other$column, part$column)
  if (same) j else NA_integer_
}


# used in divide_matrices (2026-11-27)
#' Get the values of the columns added as parts of interactions
#'
#' Computes, in R, the values of the columns that [get_column_table()] adds for
#' the parts of computed interactions: the dummy variable of a category, the
#' column of a matrix (e.g., a spline), or the value of a function. Values of
#' incomplete variables are missing; these columns are set to `NA` later and
#' computed in JAGS.
#'
#' @param column_table the table of columns, as obtained from
#'        [get_column_table()]
#' @param data a `data.frame` (the data from which the design matrices are
#'        created)
#' @param envir the environment in which functions in the calls are looked up
#'        (the environment of the formulas)
#'
#' @returns a matrix with one row per row of `data` and one column per added
#'   column (no columns if there are none)
#' @keywords internal
#'
get_added_column_values <- function(column_table, data, envir) {
  rows <- which(column_table$added)
  values <- matrix(
    NA_real_,
    nrow = nrow(data),
    ncol = length(rows),
    dimnames = list(NULL, column_table$column[rows])
  )

  for (k in seq_along(rows)) {
    part <- column_table$parts[[rows[k]]][[1L]]
    x <- if (part$call %in% names(data)) {
      data[[part$call]]
    } else {
      eval(str2lang(part$call), envir = data, enclos = envir)
    }
    values[, k] <- switch(
      part$type,
      factor = unname(part$values[as.character(x)]),
      matrix = x[, part$column],
      value = as.numeric(x)
    )
  }
  values
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


# used in get_column_table (2026-11-27)
#' Get the parts of the columns of the design matrices
#'
#' A column of a design matrix is the product of one column of the coding of
#' each call of its term (e.g., the column `log(x):z1` of the term `log(x):z`
#' is the value of `log(x)` times the dummy variable of the category `1` of
#' `z`). For each column, this function describes these parts:
#' * a factor (also a logical or character variable) is coded by contrasts or
#'   by indicators (one column per category); the part gives the value of the
#'   column for each category,
#' * a call with a matrix value (e.g., a spline) has several columns; the part
#'   gives the number of the column,
#' * any other call (a numeric variable or a function) is used as it is.
#'
#' The parts are derived from the terms of the formulas and the coding of their
#' factors (contrasts from `refs`), in the way `model.matrix()` creates the
#' columns; the name that the parts give each column is checked against the
#' columns of the table. Columns that are not the column of a term of a formula
#' (the outcomes, and the variables of the model frames) have one part, the
#' column itself; the intercept has none.
#'
#' @param columns the table of the columns, as created in
#'        [get_column_table()] (at least the columns `column` and `kind`)
#' @param terms_list a list of `terms` objects, one per formula, as obtained
#'        from `get_terms_list()`
#' @param refs a list with the reference categories of the factors, as
#'        obtained from `get_refs()`
#' @param data a `data.frame`
#' @param modelled the names of the variables that have a model (their factors
#'        are coded differently in the data matrices)
#'
#' @returns a list with one element per row of `columns`; each element is a
#'   list of parts, one per call of the term, as created by
#'   [get_call_codings()] and [select_part()]
#' @keywords internal
#'
get_column_parts <- function(columns, terms_list, refs, data, modelled) {
  contr_matrices <- if (length(refs) > 0L) lapply(refs, attr, "contr_matrix")

  # start with the column itself as its only part (the intercept has none)
  parts <- vector("list", nrow(columns))
  for (i in seq_len(nrow(columns))) {
    parts[[i]] <- if (columns$kind[i] == "intercept") {
      list()
    } else {
      column <- columns$column[i]
      list(list(call = column, type = "value", name = column))
    }
  }

  # take the parts of the columns of the terms of the formulas; a column is
  # described where it occurs first, as in the table
  from_term <- logical(nrow(columns))
  for (tt in terms_list) {
    model_frame <- model.frame(tt, data = data, na.action = na.pass)
    term_parts <- get_term_parts(tt, model_frame, contr_matrices, modelled)
    rows <- match(names(term_parts), columns$column)
    for (k in which(!is.na(rows) & !from_term[rows])) {
      parts[[rows[k]]] <- term_parts[[k]]
      from_term[rows[k]] <- TRUE
    }
  }

  # dummy variables and interactions are always columns of a term; if one is
  # not found, the coding of its term was not derived as model.matrix() does
  not_found <- columns$kind %in% c("dummy", "interaction") & !from_term
  if (any(not_found)) {
    errormsg(
      "I could not determine how the column(s) %s of the design matrix are
      computed from the variables.",
      paste_and(dQuote(columns$column[not_found]))
    )
  }
  parts
}


# used in get_column_parts (2026-11-27)
#' Get the parts of the columns of the terms of one formula
#'
#' The columns of a term are the combinations of the columns of the coding of
#' its calls, with the first call varying fastest, as in `model.matrix()`.
#'
#' @param tt the `terms` object of the formula
#' @param model_frame the model frame of the formula (`model.frame()` of `tt`)
#' @param contr_matrices a named list with the contrast matrices of the factors
#'        (from `refs`), or `NULL`
#' @param modelled the names of the variables that have a model
#'
#' @returns a list with one element per column of the terms (named by the
#'   column, as `model.matrix()` names it), each a list of the parts of the
#'   column, one per call of the term
#' @keywords internal
#'
get_term_parts <- function(tt, model_frame, contr_matrices, modelled) {
  codes <- get_coding_codes(tt, model_frame)

  out <- list()
  for (term in colnames(codes)) {
    # the coding of each call of the term, and its number of columns
    calls <- rownames(codes)[codes[, term] > 0L]
    codings <- lapply(calls, function(call) {
      get_call_codings(
        call,
        codes[call, term],
        model_frame,
        contr_matrices,
        modelled
      )
    })
    n_columns <- vapply(codings, function(x) length(x$names), integer(1L))

    # each column of the term takes one column of the coding of each call; the
    # first call varies fastest
    for (position in seq_len(prod(n_columns)) - 1L) {
      digits <- (position %/% cumprod(c(1L, n_columns[-length(n_columns)]))) %%
        n_columns
      parts <- list()
      for (k in seq_along(calls)) {
        parts[[k]] <- select_part(codings[[k]], digits[k] + 1L)
      }
      column <- paste(
        vapply(parts, "[[", character(1L), "name"),
        collapse = ":"
      )
      out[[column]] <- parts
    }
  }
  out
}


# used in get_term_parts (2026-11-27)
#' Get how model.matrix() codes each variable in each term of a formula
#'
#' Returns, for each variable in each term, whether `model.matrix()` codes it
#' by contrasts (1) or by indicators (2, one column per category).
#' [get_term_parts()] needs this to know how many columns a factor contributes
#' to a term and what they are (e.g., `B20` and `B21` instead of only `B21` in
#' `~ 0 + C1 + B2`). The coding depends on the formula, not on the variable,
#' so it is not in `refs`.
#'
#' The result is the `factors` attribute of `tt`, which already has a 2 where
#' R codes a factor by indicators because the term without it is not in the
#' formula (e.g., `b2` in `~ b2:c2`). One case is not recorded there:
#' without an intercept (`attr(tt, "intercept")`), `model.matrix()` codes the
#' first factor (also a logical or character variable) in the first term that
#' has one by indicators. Which variables are factors is only known from the
#' data, so this entry is set here from the model frame.
#'
#' @param tt the `terms` object of the formula
#' @param model_frame the model frame of the formula
#'
#' @returns a matrix with one row per variable and one column per term (as the
#'   `factors` attribute of `tt`): 0 if the variable is not in the term, 1 if
#'   it is coded by contrasts (or is not a factor), 2 if it is coded by
#'   indicators
#' @keywords internal
#'
get_coding_codes <- function(tt, model_frame) {
  codes <- attr(tt, "factors")
  if (length(codes) == 0L || attr(tt, "intercept") == 1L) {
    return(codes)
  }

  # without intercept: the first factor in the first term that has one is
  # coded by indicators
  for (term in colnames(codes)) {
    for (call in rownames(codes)[codes[, term] > 0L]) {
      if (is_factor_like(model_frame[[call]])) {
        codes[call, term] <- 2L
        return(codes)
      }
    }
  }
  codes
}


# used in get_coding_codes and get_call_codings (2026-11-27)
#' Check whether a variable is coded as a factor by model.matrix()
#'
#' @param x a variable of a model frame
#'
#' @returns `TRUE` for factors and logical or character vectors
#' @keywords internal
#'
is_factor_like <- function(x) {
  is.factor(x) || is.logical(x) || is.character(x)
}


# used in get_term_parts (2026-11-27)
#' Get the coding of one call of a term
#'
#' @param call the call as written in the formula (a row name of the `factors`
#'        attribute of the terms)
#' @param code the entry of the `factors` attribute (after
#'        [get_coding_codes()]) for this call and term: 1 for contrasts, 2 for
#'        indicators
#' @param model_frame the model frame of the formula
#' @param contr_matrices a named list with the contrast matrices of the factors
#'        (from `refs`), or `NULL`
#' @param modelled the names of the variables that have a model
#'
#' @returns a list with the elements `call`, `type` (`"factor"`, `"matrix"`
#'   or `"value"`), `names` (the suffixes that `model.matrix()` adds to the
#'   call to name each column; `""` for a value) and, for a factor, `matrix`
#'   (the coding matrix, with one row per category) and `codes` (the number
#'   that stands for each category in the data matrices)
#' @keywords internal
#'
get_call_codings <- function(
  call,
  code,
  model_frame,
  contr_matrices,
  modelled
) {
  x <- model_frame[[call]]

  if (is_factor_like(x)) {
    # the numbers of the categories in the data matrices: logical variables
    # are 0/1; factors with a model are coded as JAGS needs them (binary: 0/1,
    # otherwise 1, 2, ...; prep_covoutcomes()), other factors by data.matrix()
    # (1, 2, ...)
    codes <- if (is.logical(x)) {
      c(0, 1)
    } else if (call %in% modelled && nlevels(as.factor(x)) == 2L) {
      c(0, 1)
    } else {
      seq_len(nlevels(as.factor(x)))
    }

    # the categories: model.matrix() codes a logical variable always with the
    # categories FALSE and TRUE (also when one of them does not occur)
    x <- if (is.logical(x)) {
      factor(x, levels = c(FALSE, TRUE))
    } else {
      as.factor(x)
    }

    # a factor: indicators, the contrasts given in refs, or the contrasts of
    # the factor (as model.matrix() uses them)
    coding <- if (code == 2L) {
      diag(nlevels(x))
    } else if (call %in% names(contr_matrices)) {
      contr_matrices[[call]]
    } else {
      contrasts(x)
    }
    rownames(coding) <- levels(x)
    if (code == 2L) {
      colnames(coding) <- levels(x)
    } else if (is.null(colnames(coding))) {
      colnames(coding) <- seq_len(ncol(coding))
    }
    list(
      call = call,
      type = "factor",
      names = colnames(coding),
      matrix = coding,
      codes = setNames(as.numeric(codes), levels(x))
    )
  } else if (is.matrix(x)) {
    # a matrix (e.g., a spline): its columns
    suffixes <- colnames(x)
    if (is.null(suffixes)) {
      suffixes <- seq_len(ncol(x))
    }
    list(call = call, type = "matrix", names = as.character(suffixes))
  } else {
    list(call = call, type = "value", names = "")
  }
}


# used in get_term_parts (2026-11-27)
#' Select one column of the coding of a call
#'
#' @param coding the coding of the call, as obtained from [get_call_codings()]
#' @param k the number of the column of the coding
#'
#' @returns a list with the elements `call`, `type`, `name` (the name that
#'   `model.matrix()` gives this column of the call alone) and, for a factor,
#'   `values` (the value of the column for each category, named by the
#'   categories) and `codes` (the number of each category in the data
#'   matrices), or, for a matrix, `column` (the number of the column)
#' @keywords internal
#'
select_part <- function(coding, k) {
  part <- list(
    call = coding$call,
    type = coding$type,
    name = paste0(coding$call, coding$names[k])
  )
  if (coding$type == "factor") {
    part$values <- coding$matrix[, k]
    part$codes <- coding$codes
  } else if (coding$type == "matrix") {
    part$column <- k
  }
  part
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
