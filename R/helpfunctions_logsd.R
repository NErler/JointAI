# Sub-models for the log of the residual standard deviation of a longitudinal
# outcome `y`, specified as `logsd(y) ~ ...` in the list of model formulas.
#
# The log standard deviation is treated as another longitudinal outcome `logsd.y`
# that has a linear predictor, but is never observed. All parts that depend on the
# linear predictor (coefficients, random effects, scaling, monitoring, summary)
# are therefore those of any other sub-model.

#' Replace calls to `logsd()` in an expression
#'
#' @param expr a formula, or part of a formula
#'
#' @returns The expression, in which `logsd(y)` is replaced by the name `logsd.y`.
#' @keywords internal
replace_logsd_calls <- function(expr) {
  if (!is.call(expr)) {
    return(expr)
  }

  if (identical(expr[[1L]], quote(logsd))) {
    if (length(expr) != 2L || !is.name(expr[[2L]])) {
      errormsg(
        "%s needs the name of one variable as its argument.",
        dQuote("logsd()")
      )
    }
    return(as.name(paste0("logsd.", as.character(expr[[2L]]))))
  }

  for (i in seq_along(expr)) {
    if (is.call(expr[[i]])) {
      expr[[i]] <- replace_logsd_calls(expr[[i]])
    }
  }
  expr
}


#' Prepare sub-models for the log of a residual standard deviation
#'
#' Replaces `logsd(y)` by the variable `logsd.y` in all model formulas, and adds
#' this variable to the data, with values that vary within each subject, so that
#' it is treated as a variable on the level of the measurements.
#' `set_logsd_columns()` later sets its values in the design matrix to `NA`.
#' Does nothing if there is no model formula with `logsd()`.
#'
#' @param formula list of model formulas
#' @param data the data
#' @param analysis_type character string, the type of analysis
#'
#' @returns A list with the elements `formula` and `data`, and `logsd_of`, a
#'   vector with the names of the outcomes, named by their log standard
#'   deviations (`NULL` if there are none).
#' @keywords internal
prepare_logsd_models <- function(formula, data, analysis_type) {
  new_formula <- formula
  for (i in seq_along(new_formula)) {
    new_formula[[i]] <- replace_logsd_calls(new_formula[[i]])
  }

  old_lhs <- lapply(formula, extract_lhs_string)
  new_lhs <- lapply(new_formula, extract_lhs_string)
  uses_logsd <- !identical(formula, new_formula)
  is_logsd_model <- grepl("^logsd\\(", unlist(old_lhs))

  if (!uses_logsd) {
    return(list(formula = formula, data = data, logsd_of = NULL))
  }

  if (!identical(analysis_type, "JM")) {
    errormsg(
      "Models for the residual standard deviation (%s) are only available in
      joint models (%s).",
      dQuote("logsd()"),
      dQuote("JM_imp()")
    )
  }

  logsd_vars <- unlist(new_lhs)[is_logsd_model]
  outcomes <- gsub("^logsd\\(|\\)$", "", unlist(old_lhs)[is_logsd_model])
  logsd_of <- setNames(outcomes, logsd_vars)

  used <- setdiff(
    grep(
      "^logsd\\.",
      unique(unlist(lapply(new_formula, all.vars))),
      value = TRUE
    ),
    setdiff(names(data), logsd_vars)
  )
  no_model <- setdiff(used, logsd_vars)
  if (length(no_model) > 0L) {
    errormsg(
      "%s is used, but there is no model for it in the list of model formulas.",
      paste_and(gsub("^logsd\\.(.*)$", "logsd(\\1)", no_model), dQ = TRUE)
    )
  }

  no_outcome_model <- setdiff(outcomes, unlist(new_lhs))
  if (length(no_outcome_model) > 0L) {
    errormsg(
      "A model for %s needs a model for %s in the list of model formulas.",
      dQuote(paste0("logsd(", no_outcome_model[1L], ")")),
      dQuote(no_outcome_model[1L])
    )
  }

  taken <- intersect(logsd_vars, names(data))
  if (length(taken) > 0L) {
    errormsg(
      "%s is needed for a model for the residual standard deviation, but there
      is a column of this name in the data.",
      paste_and(taken, dQ = TRUE)
    )
  }

  for (logsd_var in logsd_vars) {
    data[[logsd_var]] <- seq_len(nrow(data)) / nrow(data)
  }

  list(formula = new_formula, data = data, logsd_of = logsd_of)
}


#' Check sub-models for the log of a residual standard deviation
#'
#' An outcome with a model for its residual standard deviation, and this
#' standard deviation, need linear mixed models on the level of the measurements.
#'
#' @param logsd_of vector with the names of the outcomes, named by their log
#'   standard deviations
#' @param Mlist list of model information, as created by `divide_matrices()`
#'
#' @returns `NULL`, invisibly; called for its errors.
#' @keywords internal
check_logsd_models <- function(logsd_of, Mlist) {
  for (logsd_var in names(logsd_of)) {
    for (k in c(logsd_of[[logsd_var]], logsd_var)) {
      is_lmm <- get_modeltype(Mlist$models[k]) %in%
        "glmm" &&
        get_family(Mlist$models[k]) %in% "gaussian" &&
        get_link(Mlist$models[k]) %in% "identity" &&
        !is.null(Mlist$random[[k]])

      if (!is_lmm || !Mlist$Mlvls[k] %in% "M_lvlone") {
        errormsg(
          "A model for %s needs linear mixed models for %s and %s, with random
          effects, on the level of the repeated measurements.",
          dQuote(paste0("logsd(", logsd_of[[logsd_var]], ")")),
          dQuote(logsd_of[[logsd_var]]),
          dQuote(paste0("logsd(", logsd_of[[logsd_var]], ")"))
        )
      }
    }
  }

  invisible(NULL)
}


#' Remove the placeholder values of a log standard deviation
#'
#' Sets the columns that involve a log standard deviation (the variable itself,
#' functions of it and interactions with it) to `NA` in the design matrices, and
#' does not scale them, because they are calculated in JAGS.
#'
#' @param Mlist list of model information, as created by `divide_matrices()`
#' @param logsd_of vector with the names of the outcomes, named by their log
#'   standard deviations
#'
#' @returns `Mlist`, with changed `M` and `scale_pars`, and the new element
#'   `logsd_of`.
#' @keywords internal
set_logsd_columns <- function(Mlist, logsd_of) {
  patterns <- paste0(
    "(^|[^[:alnum:]._])",
    escape_regex(names(logsd_of)),
    "($|[^[:alnum:]._])"
  )

  for (mat in names(Mlist$M)) {
    for (pattern in patterns) {
      columns <- grep(pattern, colnames(Mlist$M[[mat]]), value = TRUE)
      Mlist$M[[mat]][, columns] <- NA

      if (!is.null(Mlist$scale_pars[[mat]])) {
        Mlist$scale_pars[[mat]][columns, ] <- NA
      }
    }
  }

  Mlist$logsd_of <- logsd_of
  Mlist
}


#' The log standard deviations of a set of variables
#'
#' @param vars character vector with variable names
#' @param logsd_of vector with the names of the outcomes, named by their log
#'   standard deviations, or `NULL`
#'
#' @returns A character vector with the names of the log standard deviations of
#'   these variables.
#' @keywords internal
get_logsd_vars <- function(vars, logsd_of) {
  names(logsd_of)[logsd_of %in% vars]
}


#' JAGS syntax of the distribution in a model with a residual standard deviation
#'
#' The model for an outcome `y` uses a precision that is calculated from the
#' linear predictor of `logsd.y`. The value of `logsd.y` itself equals its linear
#' predictor; it has no distribution.
#'
#' @param info element of `info_list`
#' @param index the index to be used, e.g., `"i"` or `"ii"`
#' @param isgk logical: is the output for within the quadrature part?
#'
#' @returns `NULL` for any other model, otherwise a list with the elements
#'   `relation` (`" ~ "` or `" <- "`), `distr` (its right hand side) and `repar`
#'   (additional lines of syntax, or `NULL`).
#' @keywords internal
get_logsd_parts <- function(info, index, isgk) {
  if (is.null(info$logsd_var) && !isTRUE(info$is_logsd)) {
    return(NULL)
  }

  gk <- if (isgk) "gk" else ""
  idx <- if (isgk) paste0(index, ", k") else index
  mu <- paste0("mu", gk, "_", info$varname, "[", idx, "]")

  if (isTRUE(info$is_logsd)) {
    return(list(relation = " <- ", distr = mu, repar = NULL))
  }

  tau <- paste0("tau", gk, "_", info$varname, "[", idx, "]")
  logsd <- paste0("mu", gk, "_", info$logsd_var, "[", idx, "]")

  list(
    relation = " ~ ",
    distr = paste0("dnorm(", mu, ", ", tau, ")"),
    repar = paste0(
      tab(if (isgk) 6L else 4L),
      tau,
      " <- 1/(exp(",
      logsd,
      ")^2)\n"
    )
  )
}
