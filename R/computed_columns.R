# Columns of the design matrices that JAGS computes ----------------------------
#
# Dummy variables, functions and interactions of incomplete variables are set
# to NA in the data and computed in the JAGS model from the (imputed)
# variables. The JAGS expression of each such column is built from the table
# of columns (get_column_table()): from the parts of the column and, for
# functions, from the call tree of the function.

# the functions (and operators) of R that JAGS knows under the same name
jags_functions <- c(
  "(",
  "+",
  "-",
  "*",
  "/",
  "^",
  "==",
  "!=",
  "<",
  ">",
  "<=",
  ">=",
  "&&",
  "||",
  "!",
  "abs",
  "arccos",
  "arccosh",
  "arcsin",
  "arcsinh",
  "arctan",
  "arctanh",
  "cloglog",
  "cos",
  "cosh",
  "equals",
  "exp",
  "icloglog",
  "ifelse",
  "ilogit",
  "log",
  "logfact",
  "loggam",
  "logit",
  "max",
  "min",
  "phi",
  "pow",
  "probit",
  "round",
  "sin",
  "sinh",
  "sqrt",
  "step",
  "tan",
  "tanh",
  "trunc"
)


# used in paste_computed_functions and paste_computed_block (2026-11-27)
#' Write the JAGS line that computes a column of the design matrices
#'
#' @param column the name of the column (a row of `column_table` with
#'        `computed == TRUE`)
#' @param column_table the table of the columns of the design matrices, as
#'        obtained from [get_column_table()]
#' @param group_lvls a named vector with the rank of each grouping level (1 for
#'        the lowest), as obtained from `get_data_structure()`
#'
#' @returns a character string of the form `M_lvlone[i, 7] <- log(M_lvlone[i,
#'   3])`, for the loop over the rows of the level of the column
#' @keywords internal
#'
paste_computed_column <- function(column, column_table, group_lvls) {
  i <- match(column, column_table$column)

  # the column itself, in the loop over the rows of its level
  lhs <- get_data_reference(
    data_level = column_table$level[i],
    col = column_table$index[i],
    level = column_table$level[i],
    group_lvls = group_lvls
  )
  rhs <- get_column_call(i, column_table, group_lvls)

  paste0(deparse_call(lhs), " <- ", deparse_call(rhs))
}


# used in paste_computed_column (2026-11-27)
#' Get the JAGS expression of a computed column
#'
#' A dummy variable or a function is written out from its only part. An
#' interaction is the product of the columns of its parts (the table has a
#' column for each part, see [get_column_table()]), e.g.,
#' `M_lvlone[i, 4] <- M_lvlone[i, 7] * M_lvlone[i, 3]` for `b20:c2`.
#'
#' @param i the row of the column in `column_table`
#' @param column_table the table of the columns of the design matrices, as
#'        obtained from [get_column_table()]
#' @param group_lvls a named vector with the rank of each grouping level
#'
#' @returns a call (language object)
#' @keywords internal
#'
get_column_call <- function(i, column_table, group_lvls) {
  parts <- column_table$parts[[i]]
  setting <- list(
    column = column_table$column[i],
    variables = column_table$variables[[i]],
    level = column_table$level[i],
    column_table = column_table,
    group_lvls = group_lvls
  )

  if (column_table$kind[i] != "interaction") {
    return(write_out_part(parts[[1L]], setting))
  }

  # the product of the columns of the parts, from left to right (each part is
  # a column: get_column_table() adds those that are not)
  part_calls <- list()
  for (part in parts) {
    j <- find_part_column(part, column_table)
    if (is.na(j)) {
      errormsg(
        "I could not find the column of %s, which is needed to compute the
        interaction %s.",
        dQuote(part$name),
        dQuote(setting$column)
      )
    }
    part_calls[[length(part_calls) + 1L]] <- get_data_reference(
      data_level = column_table$level[j],
      col = column_table$index[j],
      level = setting$level,
      group_lvls = group_lvls
    )
  }
  Reduce(function(x, y) call("*", x, y), part_calls)
}


# used in get_column_call (2026-11-27)
#' Write out one part of a column as JAGS expression
#'
#' @param part a part of a column, as obtained from [select_part()]
#' @param setting a list with the elements `column` (the name of the column,
#'        for messages), `variables` (the variables of the column), `level`
#'        (the level of the column), `column_table` and `group_lvls`
#'
#' @returns a call (language object)
#' @keywords internal
#'
write_out_part <- function(part, setting) {
  switch(
    part$type,
    factor = get_factor_call(part, setting),
    value = get_function_call(part$call, setting),
    matrix = errormsg(
      "JAGS has to compute the column %s, because it involves incomplete
      variables, but it needs the column %s of %s, which cannot be computed in
      JAGS.",
      dQuote(setting$column),
      part$column,
      dQuote(part$call)
    )
  )
}


# used in write_out_part (2026-11-27)
#' Write a dummy variable of a factor as JAGS expression
#'
#' The dummy variable is computed from the integer codes of the factor in the
#' data matrices, as `ifelse(<factor> == <code>, 1, 0)` for treatment
#' contrasts and indicators, and with `-1` for the reference category for sum
#' contrasts (as in `paste_dummies()`).
#'
#' @param part a part of type `"factor"`, as obtained from [select_part()]
#' @param setting a list with the elements `column`, `variables`, `level`,
#'        `column_table` and `group_lvls` (see [write_out_part()])
#'
#' @returns a call (language object)
#' @keywords internal
#'
get_factor_call <- function(part, setting) {
  factor_ref <- get_variable_reference(part$call, setting)
  values <- part$values
  codes <- part$codes
  ones <- names(values)[values == 1]
  minus_ones <- names(values)[values == -1]

  # other codings (e.g., polynomial contrasts) are not implemented
  if (
    !all(values %in% c(-1, 0, 1)) ||
      length(ones) != 1L ||
      length(minus_ones) > 1L
  ) {
    errormsg(
      "JAGS has to compute the column %s, but the coding of %s cannot be
      computed in JAGS (only treatment and sum contrasts can).",
      dQuote(setting$column),
      dQuote(part$call)
    )
  }

  otherwise <- if (length(minus_ones) == 1L) {
    call("ifelse", call("==", factor_ref, codes[[minus_ones]]), -1, 0)
  } else {
    0
  }
  call("ifelse", call("==", factor_ref, codes[[ones]]), 1, otherwise)
}


# used in write_out_part (2026-11-27)
#' Write a function of variables as JAGS expression
#'
#' The call is taken from the formula; `I()` is removed, `as.numeric(x)` is
#' replaced by `(x)` (factors are stored as numbers in the data matrices), and
#' each variable is replaced by the reference to its column in the data
#' matrices. Only functions that JAGS knows are allowed.
#'
#' @param call_string the call as written in the formula (e.g., `"log(C1)"`)
#' @param setting a list with the elements `column`, `variables`, `level`,
#'        `column_table` and `group_lvls` (see [write_out_part()])
#'
#' @returns a call (language object)
#' @keywords internal
#'
get_function_call <- function(call_string, setting) {
  expr <- prepare_jags_call(str2lang(call_string), setting$column)

  # replace each variable by its column in the data matrices
  replacements <- list()
  for (variable in intersect(all.vars(expr), setting$variables)) {
    replacements[[variable]] <- get_variable_reference(variable, setting)
  }
  do.call(substitute, list(expr, replacements))
}


# used in get_function_call (2026-11-27)
#' Prepare a call of a formula for JAGS
#'
#' @param expr a call, name or constant
#' @param column the name of the column that is computed (for messages)
#'
#' @returns `expr` without `I()`, with `as.numeric(x)` replaced by `(x)`; an
#'   error for functions that JAGS does not know and for text
#' @keywords internal
#'
prepare_jags_call <- function(expr, column) {
  if (is.character(expr)) {
    errormsg(
      "JAGS has to compute the column %s, but it compares with the text %s,
      which is not possible in JAGS.",
      dQuote(column),
      dQuote(expr)
    )
  }
  if (!is.call(expr)) {
    return(expr)
  }

  fun <- deparse_call(expr[[1L]])
  if (fun == "I") {
    return(prepare_jags_call(expr[[2L]], column))
  }
  if (fun == "as.numeric") {
    return(call("(", prepare_jags_call(expr[[2L]], column)))
  }
  if (!fun %in% jags_functions) {
    errormsg(
      "JAGS has to compute the column %s, because it involves incomplete
      variables, but JAGS does not know the function %s.",
      dQuote(column),
      dQuote(fun)
    )
  }

  for (k in seq_along(expr)[-1L]) {
    expr[[k]] <- prepare_jags_call(expr[[k]], column)
  }
  expr
}


# used in get_factor_call and get_function_call (2026-11-27)
#' Get the reference to the column of a variable in the data matrices
#'
#' @param variable the name of the variable
#' @param setting a list with the elements `column`, `variables`, `level`,
#'        `column_table` and `group_lvls` (see [write_out_part()])
#'
#' @returns a call such as `M_id[group_id[i], 3]`
#' @keywords internal
#'
get_variable_reference <- function(variable, setting) {
  column_table <- setting$column_table
  j <- which(column_table$column == variable & column_table$kind == "variable")
  if (length(j) == 0L) {
    errormsg(
      "JAGS has to compute the column %s, but the variable %s is not a column
      of the data matrices.",
      dQuote(setting$column),
      dQuote(variable)
    )
  }
  get_data_reference(
    data_level = column_table$level[j],
    col = column_table$index[j],
    level = setting$level,
    group_lvls = setting$group_lvls
  )
}


# used in paste_computed_column, get_column_call and get_variable_reference
# (2026-11-27)
#' Get the reference to an element of a data matrix
#'
#' In the loop over the rows of `level`, a column of a higher level is
#' indexed through `group_<higher level>` (and, if `level` is not the lowest
#' level, through `pos_<level>`, the first row of each group of `level`).
#'
#' @param data_level the level of the data matrix (`M_<data_level>`)
#' @param col the number of the column in the data matrix
#' @param level the level of the loop over the rows
#' @param group_lvls a named vector with the rank of each grouping level
#'
#' @returns a call such as `M_lvlone[i, 3]` or `M_id[group_id[i], 1]`
#' @keywords internal
#'
get_data_reference <- function(data_level, col, level, group_lvls) {
  # the index of the loop over each level: "i" for the lowest, then "ii", ...
  sorted <- sort(group_lvls)
  index <- setNames(strrep("i", seq_along(sorted)), names(sorted))
  loop_index <- as.name(index[[level]])

  row_ref <- if (data_level == level) {
    loop_index
  } else if (group_lvls[[level]] == min(group_lvls)) {
    call("[", as.name(paste0("group_", data_level)), loop_index)
  } else {
    call(
      "[",
      as.name(paste0("group_", data_level)),
      call("[", as.name(paste0("pos_", level)), loop_index)
    )
  }
  call("[", as.name(paste0("M_", data_level)), row_ref, as.numeric(col))
}


# used in paste_computed_column and prepare_jags_call (2026-11-27)
#' Deparse a call into one line
#'
#' @param x a call, name or constant
#'
#' @returns a character string
#' @keywords internal
#'
deparse_call <- function(x) {
  # deparse1() would need R >= 4.0.0 (DESCRIPTION has no R version)
  paste(deparse(x, width.cutoff = 500L), collapse = " ") # nolint: paste_linter.
}


# Placement of the lines in the JAGS model -------------------------------------
# The lines are written where they were written before the column table was
# used: the functions in the model of one of their variables (as given in
# `trafos`), the dummy variables of a factor in the model of the factor
# (`paste_dummies()`), and the interactions in a block per level at the end of
# the model. Columns that none of the models writes (e.g., the dummy of the
# reference category of a factor in a model without intercept) are added to
# that block.

# used in get_model1_info (2026-11-27)
#' Write the functions that the model of a variable computes
#'
#' A function of incomplete variables is computed in the model of one of its
#' variables: the variable of the row of `trafos` that is not marked as a
#' duplicate.
#'
#' @param varname the name of the variable whose model is written
#' @param trafos the `data.frame` of the functions of incomplete variables, as
#'        obtained from `extract_fcts()` (`Mlist$trafos`)
#' @param column_table the table of the columns of the design matrices, as
#'        obtained from [get_column_table()]
#' @param group_lvls a named vector with the rank of each grouping level
#'
#' @returns `NULL` if no function involves the variable, otherwise a character
#'   string with the JAGS lines (as `paste_trafos()`)
#' @keywords internal
#'
paste_computed_functions <- function(
  varname,
  trafos,
  column_table,
  group_lvls
) {
  if (!any(trafos$var %in% varname)) {
    return(NULL)
  }

  # Temporary: the placement is taken from trafos (from extract_fcts()), so
  # that the lines stay where they were written before; trafos is kept until
  # the placement is decided from the column table.
  # (only functions that are columns; the parts of interactions are columns
  # only if the interaction is computed)
  columns <- as.character(trafos$colname[trafos$var == varname & !trafos$dupl])
  columns <- intersect(columns, column_table$column)
  jags_lines <- character(0L)
  for (column in columns) {
    jags_lines <- c(
      jags_lines,
      paste0(
        tab(4L),
        paste_computed_column(column, column_table, group_lvls),
        "\n"
      )
    )
  }

  paste0("\n\n", paste(unique(jags_lines), collapse = ""), "\n")
}


# used in write_model (2026-11-27)
#' Write the computed columns that no model writes
#'
#' These are the interactions and the computed columns that are not written in
#' the model of a variable (see [paste_computed_functions()] and
#' `paste_dummies()`). They are written in one loop per level, in the order of
#' the design matrices (as `paste_interactions()`).
#'
#' @param column_table the table of the columns of the design matrices, as
#'        obtained from [get_column_table()]
#' @param trafos the `data.frame` of the functions of incomplete variables, as
#'        obtained from `extract_fcts()` (`Mlist$trafos`)
#' @param refs a list with the reference categories of the factors, as
#'        obtained from `get_refs()` (`Mlist$refs`)
#' @param modelled the names of the variables that have a model (the names of
#'        the model info list)
#' @param group_lvls a named vector with the rank of each grouping level
#' @param n a named vector with the number of units of each level (`Mlist$N`)
#'
#' @returns `NULL` if there are no such columns, otherwise a character vector
#'   with one loop per level
#' @keywords internal
#'
paste_computed_block <- function(
  column_table,
  trafos,
  refs,
  modelled,
  group_lvls,
  n
) {
  # the dummies of factors with a model, and the functions that are written in
  # the model of one of their variables
  model_dummies <- unlist(lapply(
    refs[intersect(names(refs), modelled)],
    attr,
    "dummies"
  ))
  model_functions <- if (!is.null(trafos)) {
    trafos$colname[!trafos$dupl & trafos$var %in% modelled]
  }

  # the interactions, and the dummies and functions that no model writes
  is_interaction <- column_table$kind == "interaction"
  is_other_dummy <- column_table$kind == "dummy" &
    !column_table$column %in% model_dummies
  is_other_function <- column_table$kind == "function" &
    (column_table$column %in% trafos$colname | column_table$added) &
    !column_table$column %in% model_functions
  in_block <- column_table$computed &
    (is_interaction | is_other_dummy | is_other_function)
  if (!any(in_block)) {
    return(NULL)
  }

  sorted <- sort(group_lvls)
  index <- setNames(strrep("i", seq_along(sorted)), names(sorted))

  # one loop per level, in the order in which the levels first occur
  rows <- which(in_block)
  loops <- character(0L)
  for (lvl in unique(column_table$level[rows])) {
    jags_lines <- character(0L)
    for (column in column_table$column[rows][column_table$level[rows] == lvl]) {
      jags_lines <- c(
        jags_lines,
        paste0(tab(4L), paste_computed_column(column, column_table, group_lvls))
      )
    }
    loops <- c(
      loops,
      paste0(
        tab(),
        "for (",
        index[[lvl]],
        " in 1:",
        n[[lvl]],
        ") {\n",
        paste(jags_lines, collapse = "\n"),
        "\n",
        tab(),
        "}\n"
      )
    )
  }
  loops
}
