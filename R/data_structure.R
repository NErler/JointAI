# used in divide_matrices and get_models (2026-11-07)
#' Get the structure of the data
#'
#' Determines, once per model, how the rows of the data are grouped: the group
#' of each row for every grouping level, the rank of each grouping level, and
#' which grouping levels are nested in which other ones. The steps of the model
#' set-up use this object instead of computing these again. The levels and
#' other properties of the variables are added with [get_variable_table()].
#'
#' @param data a `data.frame` (in survival models with time-varying covariates
#'        after the event times were added by `reformat_longsurvdata()`)
#' @param idvar a character vector with the names of the grouping variables
#'        (as obtained from `extract_grouping()`), or `NULL` if there are none
#'
#' @returns a list of class `JointAI_data_structure` with elements
#'   * `groups`: a `data.frame` with one column per grouping level, including
#'     `lvlone` (the rows), containing the integer group index of each row (as
#'     obtained from `get_groups()`); the columns are sorted from the highest
#'     to the lowest level,
#'   * `group_lvls`: the rank of each grouping level (as obtained from
#'     `get_grouping_levels()`), sorted decreasingly: the number of grouping
#'     levels that are nested in it, including itself. Crossed levels have the
#'     same rank.
#'   * `nested_in`: a logical matrix with one row and one column per grouping
#'     level; `nested_in[a, b]` is `TRUE` if every group of `a` lies within a
#'     single group of `b` (every level is nested in itself).
#' @keywords internal
#'
get_data_structure <- function(data, idvar) {
  groups <- get_groups(idvar, data)

  # rank of each grouping level; sorted so that the highest level (which
  # contains the intercept) comes first
  group_lvls <- sort(get_grouping_levels(groups), decreasing = TRUE)
  groups <- groups[names(group_lvls)]

  # nesting relation: for each level `a` (rows), whether each level `b`
  # (columns) is constant within the groups of `a`, i.e., `a` is nested in `b`
  nested_in <- do.call(
    rbind,
    lapply(groups, function(lvl) !check_groups_vary_within_lvl(lvl, groups))
  )
  rownames(nested_in) <- names(groups)

  data_structure <- list(
    groups = groups,
    group_lvls = group_lvls,
    nested_in = nested_in
  )
  class(data_structure) <- "JointAI_data_structure"
  data_structure
}


# used in divide_matrices and get_models (2026-11-07)
#' Get the level and other properties of variables
#'
#' Creates a table with one row per variable, describing the variable for the
#' choice of its model and its place in the model: its grouping level, the
#' number of missing values, the number of categories and whether it is
#' ordered.
#'
#' @param data a `data.frame`
#' @param data_structure the structure of the data, as obtained from
#'        [get_data_structure()]
#' @param vars a character vector with the names of the variables (columns of
#'        `data`) to describe
#'
#' @returns a `data.frame` with one row per variable (row names: the names of
#'   the variables) and the columns
#'   * `level`: the name of the highest grouping level within which the
#'     variable is constant (missing values count as values),
#'   * `n_missing`: the number of missing values, counted on one row per group
#'     of the variable's level (the first row of each group),
#'   * `n_categories`: the number of categories (`0` if the variable is not a
#'     factor),
#'   * `ordered`: whether the variable is an ordered factor.
#' @keywords internal
#'
get_variable_table <- function(data, data_structure, vars) {
  groups <- data_structure$groups

  var_levels <- get_datlvls(
    data[, vars, drop = FALSE],
    groups,
    group_lvls = data_structure$group_lvls
  )

  # count the missing values on the first row of each group of the variable's
  # level
  n_missing <- vapply(
    vars,
    function(v) {
      group <- groups[[var_levels[[v]]]]
      sum(is.na(data[[v]][match(unique(group), group)]))
    },
    integer(1L)
  )

  data.frame(
    level = unname(var_levels[vars]),
    n_missing = unname(n_missing),
    n_categories = vapply(
      vars,
      function(v) nlevels(data[[v]]),
      integer(1L),
      USE.NAMES = FALSE
    ),
    ordered = vapply(
      vars,
      function(v) is.ordered(data[[v]]),
      logical(1L),
      USE.NAMES = FALSE
    ),
    row.names = vars
  )
}


# used in divide_matrices (2026-11-07)
#' Find variables that seem to belong to a higher level
#'
#' A variable whose observed values are constant within the groups of a
#' grouping level, but where some groups have both observed and missing
#' values, is treated as a variable of a lower level (missing values count as
#' values when the level of a variable is determined). This can be an
#' oversight in the data (a variable of that grouping level with missing
#' values that should have been filled in) or a lower-level variable that
#' happens to be constant within groups (e.g., because groups have only one
#' observed value). This function finds such variables, so that the user can
#' be told about them.
#'
#' @param data a `data.frame`
#' @param data_structure the structure of the data, as obtained from
#'        [get_data_structure()], with the table of variables
#'        ([get_variable_table()])
#'
#' @returns a named list with, for each such variable, the names of the
#'   grouping levels within which its observed values are constant and some
#'   groups have both observed and missing values; of levels that are nested in
#'   each other only the highest one. An empty list if there are no such
#'   variables.
#' @keywords internal
#'
find_apparent_levels <- function(data, data_structure) {
  groups <- data_structure$groups
  nested_in <- data_structure$nested_in
  grouping_levels <- setdiff(names(groups), "lvlone")

  apparent <- list()
  for (v in rownames(data_structure$variables)) {
    x <- data[[v]]
    observed <- !is.na(x)
    if (all(observed) || !any(observed)) {
      next
    }

    # the grouping levels within which the observed values are constant, but
    # some groups have both observed and missing values
    candidates <- Filter(
      function(lvl) is_partly_observed_constant(x, groups[[lvl]]),
      grouping_levels
    )

    # of levels that are nested in each other, keep only the highest
    highest <- vapply(
      candidates,
      function(lvl) !any(nested_in[lvl, setdiff(candidates, lvl)]),
      logical(1L)
    )
    if (any(highest)) {
      apparent[[v]] <- candidates[highest]
    }
  }
  apparent
}


#' Check if a variable is constant within groups but some groups partly missing
#'
#' used in find_apparent_levels (2026-11-07)
#'
#' @param x a vector, the values of a variable
#' @param group an integer vector of the same length, the group of each value
#'
#' @returns `TRUE` if the observed values of `x` are constant within each group
#'   and at least one group has both observed and missing values, `FALSE`
#'   otherwise
#' @keywords internal
#'
is_partly_observed_constant <- function(x, group) {
  observed <- !is.na(x)

  # number of different observed values per group
  n_values <- tapply(
    x[observed],
    group[observed],
    function(values) length(unique(values))
  )

  # whether a group has both observed and missing values
  partly_missing <- tapply(observed, group, function(o) any(o) && !all(o))

  all(n_values <= 1L) && any(partly_missing)
}


# used in divide_matrices (2026-11-07)
#' Warn about variables that seem to belong to a higher level
#'
#' Gives, for each variable found by [find_apparent_levels()], a warning with
#' an expression that fills in the missing values within the groups.
#'
#' @param apparent a named list, as obtained from [find_apparent_levels()]
#'
#' @returns nothing; called for the warnings
#' @keywords internal
#'
warn_apparent_levels <- function(apparent) {
  for (v in names(apparent)) {
    lvls <- apparent[[v]]

    # an expression per grouping level that fills in the missing values with
    # the observed value of the group
    fill_in <- vapply(
      lvls,
      function(lvl) {
        sprintf(
          paste0(
            "data[[\"%s\"]] <- ave(data[[\"%s\"]], data[[\"%s\"]], ",
            "FUN = function(v) v[!is.na(v)][1])"
          ),
          v,
          v,
          lvl
        )
      },
      character(1L)
    )

    msg_text <- gettextf(
      "The observed values of %s are constant within %s, but some groups have
      both observed and missing values, so %s is treated as a lower-level
      variable. If it is a variable of %s, fill in its missing values, e.g.:",
      dQuote(v),
      paste_and(dQuote(lvls)),
      dQuote(v),
      paste(dQuote(lvls), collapse = " or ")
    )

    warning(
      paste0(
        paste(strwrap(msg_text), collapse = "\n"),
        paste0("\n  ", fill_in, collapse = "")
      ),
      call. = FALSE,
      immediate. = TRUE
    )
  }
}
