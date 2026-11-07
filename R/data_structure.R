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
