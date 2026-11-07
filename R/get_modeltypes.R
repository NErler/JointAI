# used in divide_matrices (2026-11-07)
#' Get the types and the order of the models
#'
#' Determines which variables get a model, the type of each model and the
#' order of the models, i.e., the factorisation of the joint distribution of
#' the outcomes and the incomplete covariates into a sequence of conditional
#' distributions:
#' * The outcomes of the formulas in `fixed` come first, with the type of
#'   their formula (survival outcomes, the outcome of the first formula) or
#'   the default type.
#' * Then the covariates, level by level, from the lowest level up to the
#'   highest level on which a variable (outcome or covariate) has missing
#'   values. Per level, the incomplete covariates (ordered by decreasing number
#'   of missing values) and, on the levels below the highest level with missing
#'   values, also the complete covariates: incomplete variables of higher
#'   levels can only enter the models of lower-level variables if these have a
#'   model.
#' * The default type of each covariate model is given by
#'   [default_model_types()].
#' * The time variable and the variables in `no_model` get no model.
#' * The types in `models` replace the default types, but not the order.
#'
#' @param fixed a formula or list of formulas for the fixed effects
#' @param random a formula or list of formulas for the random effects
#'        (including the grouping), or `NULL`
#' @param data a `data.frame`
#' @param auxvars a one-sided formula with the auxiliary variables, or `NULL`
#' @param timevar the name of the time variable (survival models with
#'        time-varying covariates), or `NULL`
#' @param no_model a character vector with the names of complete variables
#'        that do not get a model, or `NULL`
#' @param models a named character vector with model types given by the user
#'        (argument `models` of the main functions), or `NULL`
#' @param analysis_type the type of the analysis model (used when the formulas
#'        in `fixed` do not yet have a type)
#' @param warn logical; currently not used
#' @param data_structure the structure of the data, as obtained from
#'        [get_data_structure()], possibly with the table of variables
#'        ([get_variable_table()]); computed here if `NULL`
#'
#' @returns a named character vector with the model type of each variable
#'   that gets a model, in the order of the models; `NULL` if there are no
#'   variables
#' @keywords internal
#'
get_models <- function(
  fixed,
  random = NULL,
  # `data` without a default after arguments with defaults: the order of the
  # arguments is kept
  data, # nolint: function_argument_linter.
  auxvars = NULL,
  timevar = NULL,
  no_model = NULL,
  models = NULL,
  analysis_type = NULL,
  warn = TRUE,
  data_structure = NULL
) {
  if (missing(fixed)) {
    errormsg("No formula specified.")
  }

  if (missing(data)) {
    errormsg("No dataset given.")
  }

  if (!is.null(auxvars) && !inherits(auxvars, "formula")) {
    errormsg("The argument %s should be a formula.", dQuote("auxvars"))
  }

  models_user <- models

  # the structure of the data (groupings, ranks of the levels); computed here
  # only when get_models() is not called from divide_matrices()
  if (is.null(data_structure)) {
    data_structure <- get_data_structure(data, extract_grouping(random))
  }

  if (is.null(attr(fixed[[1]], "type"))) {
    fixed <- get_outcome_data(
      fixed,
      data = data,
      data_structure = data_structure,
      analysis_type = analysis_type
    )$fixed
  }

  # if there is a time variable, add it to no_model
  if (!is.null(timevar)) {
    no_model <- c(no_model, timevar)
  }

  check_models_args(
    models_user = models_user,
    no_model = no_model,
    data = data,
    allvars = all_vars(fixed, random, auxvars, timevar)
  )

  # all variables: the outcomes and the variables in the formulas (all_vars()
  # checks if a string is a valid variable name, which is not the case for all
  # outcome names, e.g., "Surv(time, status)")
  allvars <- unique(c(
    names(fixed),
    all_vars(
      remove_lhs(fixed),
      remove_grouping(random),
      auxvars,
      names(models),
      timevar
    )
  ))

  if (length(allvars) == 0L) {
    return(NULL)
  }

  # create a data.frame with one row per variable, containing the variable's
  # name, level and default model type
  varinfo <- get_model_variables(allvars, fixed, data, data_structure)

  # outcomes of survival models get the type attribute of their formula, and
  # the outcome of the first formula the type of the analysis
  formula_types <- lapply(fixed, attr, "type")
  survmods <- vapply(
    formula_types,
    function(type) isTRUE(type %in% c("coxph", "survreg", "JM")),
    logical(1L)
  )
  if (any(survmods)) {
    varinfo$type[varinfo$name %in% names(fixed)[survmods]] <-
      unlist(formula_types[survmods], use.names = FALSE)
  }

  if (!is.null(formula_types[[1L]])) {
    varinfo$type[varinfo$name %in% names(fixed)[1L]] <- formula_types[[1L]]
  }

  # variables that do not get a model (the time variable and no_model)
  varinfo <- varinfo[!varinfo$name %in% no_model, , drop = FALSE]

  # determine the order of models (in the factorization) based on if the
  # variable is an outcome, its level and the number of missing values
  model_rows <- order_models(varinfo)
  # create the models vector in the determined order
  models <- if (length(model_rows) > 0L) {
    setNames(varinfo$type[model_rows], varinfo$name[model_rows])
  }

  # the model types given by the user for covariates (without a formula of
  # their own) must fit the level of their variable; they replace the default
  # types, but not the order
  check_model_type_level(
    models_user[setdiff(names(models_user), names(fixed))],
    var_ranks = setNames(varinfo$rank, varinfo$name),
    max_rank = max(data_structure$group_lvls)
  )
  models[names(models_user)] <- models_user
  models
}


#' Check the arguments `models` and `no_model`
#'
#' The variables in `models` must be columns of the data and part of the model,
#' the variables in `no_model` (including the time variable) must be complete.
#'
#' used in get_models (2026-11-07)
#'
#' @param models_user a named character vector with the model types given by
#'        the user (argument `models`), or `NULL`
#' @param no_model a character vector with the names of the variables that do
#'        not get a model (including the time variable), or `NULL`
#' @param data a `data.frame`
#' @param allvars a character vector with the names of the variables in the
#'        model formulas
#'
#' @returns nothing; throws an error if one of the checks fails
#' @keywords internal
#'
check_models_args <- function(models_user, no_model, data, allvars) {
  not_in_data <- setdiff(names(models_user), names(data))
  if (length(not_in_data) > 0L) {
    errormsg(
      "Variable(s) %s were not found in the data.",
      paste_and(dQuote(not_in_data))
    )
  }

  if (!is.null(no_model)) {
    incomplete <- colSums(is.na(data[, no_model, drop = FALSE])) > 0
    if (any(incomplete)) {
      errormsg(
        "Variable(s) %s have missing values and imputation models are
        needed for these variables.",
        toString(dQuote(no_model[incomplete]))
      )
    }
  }

  not_in_model <- setdiff(names(models_user), allvars)
  if (length(not_in_model) > 0L) {
    errormsg(
      "You have specified covariate model types for the variable(s) %s
             which are not part of the model.",
      paste_and(dQuote(not_in_model))
    )
  }
}


#' Get the level and the default model type of the variables
#'
#' used in get_models (2026-11-07)
#'
#' @param allvars a character vector with the names of all variables (outcomes
#'        first)
#' @param fixed a named list of formulas for the fixed effects (named by their
#'        outcomes, as obtained from `get_outcome_data()`)
#' @param data a `data.frame`
#' @param data_structure the structure of the data, as obtained from
#'        [get_data_structure()], possibly with the table of variables
#'        ([get_variable_table()])
#'
#' @returns a `data.frame` with one row per variable, in the order of
#'   `allvars`, and the columns `name`, `outcome` (whether the variable is the
#'   outcome of a formula), `rank` (the rank of the variable's level),
#'   `n_missing` (as in [get_variable_table()]) and `type` (the default model
#'   type, from [default_model_types()])
#' @keywords internal
#'
get_model_variables <- function(allvars, fixed, data, data_structure) {
  group_lvls <- data_structure$group_lvls

  # the columns of the data are described in the table of variables (computed
  # here only when get_models() is not called from divide_matrices())
  variables <- data_structure$variables
  if (is.null(variables)) {
    variables <- get_variable_table(
      data,
      data_structure,
      vars = intersect(allvars, names(data))
    )
  }

  # names that are not columns of the data (e.g., the names of survival
  # outcomes, "Surv(time, status)") are evaluated in the data and described in
  # the same way
  other_vars <- setdiff(allvars, rownames(variables))
  if (length(other_vars) > 0L) {
    evaluated <- lapply(setNames(nm = other_vars), function(x) {
      eval(parse(text = x), envir = data)
    })
    variables <- rbind(
      variables,
      get_variable_table(
        as.data.frame(evaluated, check.names = FALSE),
        data_structure,
        vars = other_vars
      )
    )
  }

  var_rank <- unname(group_lvls[variables[allvars, "level"]])

  data.frame(
    name = allvars,
    outcome = allvars %in% names(fixed),
    rank = var_rank,
    n_missing = variables[allvars, "n_missing"],
    type = default_model_types(
      n_categories = variables[allvars, "n_categories"],
      ordered = variables[allvars, "ordered"],
      highest_level = var_rank %in% max(group_lvls)
    )
  )
}


#' Get the order of the models
#'
#' The order of the models is the order of the factorisation of the joint
#' distribution: first the outcomes of the formulas, then the covariates, level
#' by level, from the lowest level up to the highest level on which a variable
#' (outcome or covariate) has missing values. Per level: the incomplete
#' covariates (most missing values first; ties in the order of the rows) and,
#' on the levels below the highest level with missing values, also the
#' complete covariates, so that the incomplete variables of higher levels can
#' enter their linear predictors.
#'
#' used in get_models (2026-11-07)
#'
#' @param varinfo a `data.frame` with one row per variable that can get a model
#'        and (at least) the columns `outcome`, `rank` and `n_missing`, as
#'        obtained from [get_model_variables()]
#'
#' @returns an integer vector with the rows of `varinfo` that get a model, in
#'   the order of the models
#' @keywords internal
#'
order_models <- function(varinfo) {
  model_rows <- which(varinfo$outcome)

  is_covariate <- !varinfo$outcome
  is_incomplete <- varinfo$n_missing > 0L
  na_ranks <- unique(varinfo$rank[is_incomplete])

  if (!any(is_covariate) || length(na_ranks) == 0L) {
    return(model_rows)
  }

  for (k in seq_len(max(na_ranks))) {
    on_level <- is_covariate & varinfo$rank == k

    incomplete <- which(on_level & is_incomplete)
    incomplete <- incomplete[order(-varinfo$n_missing[incomplete])]
    model_rows <- c(model_rows, incomplete)

    if (k < max(na_ranks)) {
      model_rows <- c(model_rows, which(on_level & !is_incomplete))
    }
  }
  model_rows
}


#' Get the default model types of variables
#'
#' The default type of the model of a variable depends on the number of
#' categories, whether the variable is an ordered factor, and whether it is on
#' the highest level of the data: continuous variables get a linear model,
#' binary variables a logistic model, ordered factors with more than two
#' categories a cumulative logit model and unordered factors with more than
#' two categories a multinomial logit model. Variables on the highest level get
#' the model without random effects (`lm`, `glm_binomial_logit`, `clm`,
#' `mlogit`), variables on a lower level the model with random effects (`lmm`,
#' `glmm_binomial_logit`, `clmm`, `mlogitmm`).
#'
#' used in get_models (2026-11-07)
#'
#' @param n_categories an integer vector with the number of categories of each
#'        variable (`0` for variables that are not factors)
#' @param ordered a logical vector, whether each variable is an ordered factor
#' @param highest_level a logical vector, whether each variable is on the
#'        highest level
#'
#' @returns a character vector with the model type of each variable; `NA` for
#'   factors with only one category
#' @keywords internal
#'
default_model_types <- function(n_categories, ordered, highest_level) {
  # the model without random effects
  type <- rep(NA_character_, length(n_categories))
  type[n_categories == 0L] <- "lm"
  type[n_categories == 2L] <- "glm_binomial_logit"
  type[n_categories > 2L & ordered] <- "clm"
  type[n_categories > 2L & !ordered] <- "mlogit"

  # below the highest level: the corresponding model with random effects
  with_ranef <- c(
    lm = "lmm",
    glm_binomial_logit = "glmm_binomial_logit",
    clm = "clmm",
    mlogit = "mlogitmm"
  )
  lower <- !highest_level & !is.na(type)
  type[lower] <- unname(with_ranef[type[lower]])
  type
}
