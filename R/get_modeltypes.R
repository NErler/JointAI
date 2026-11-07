# Specify the default (imputation) model types
get_models <- function(
  fixed,
  random = NULL,
  data,
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

  # check that all variables are found in the data
  allvars <- all_vars(fixed, random, auxvars, timevar)

  if (any(!names(models) %in% names(data))) {
    errormsg(
      "Variable(s) %s were not found in the data.",
      paste_and(dQuote(names(models)[!names(models) %in% names(data)]))
    )
  }

  if (
    !is.null(no_model) &&
      any(colSums(is.na(data[, no_model, drop = FALSE])) > 0)
  ) {
    errormsg(
      "Variable(s) %s have missing values and imputation models are
      needed for these variables.",
      paste(
        dQuote(
          no_model[colSums(is.na(data[, no_model, drop = FALSE])) > 0]
        ),
        collapse = ", "
      )
    )
  }

  if (any(!names(models_user) %in% allvars)) {
    errormsg(
      "You have specified covariate model types for the variable(s) %s
             which are not part of the model.",
      paste_and(dQuote(names(models_user)[
        !names(models_user) %in% allvars
      ]))
    )
  }

  groups <- data_structure$groups

  random2 <- remove_grouping(random)

  # NOTE: all_vars() checks if a string is a valid variable name but that is
  # not the case for all names of fixed (e.g., Surv(time, status))
  allvars <- unique(c(
    names(fixed),
    all_vars(
      remove_lhs(fixed),
      random2,
      auxvars,
      names(models),
      timevar
    )
  ))

  group_lvls <- data_structure$group_lvls
  max_lvl <- max(group_lvls)

  # the levels and other properties of the variables (the table is computed
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
  # outcomes, "Surv(time, status)") are evaluated in the data and their level
  # is determined from the evaluated values
  other_vars <- setdiff(allvars, rownames(variables))
  other_lvls <- if (length(other_vars) > 0L) {
    evaluated <- lapply(setNames(nm = other_vars), function(x) {
      eval(parse(text = x), envir = data)
    })
    get_datlvls(
      as.data.frame(evaluated, check.names = FALSE),
      groups,
      group_lvls = group_lvls
    )
  }

  if (length(allvars) > 0) {
    varinfo <- sapply(
      allvars,
      function(k) {
        out <- k %in% names(fixed)
        if (k %in% rownames(variables)) {
          lvl <- group_lvls[variables[k, "level"]]
          nmis <- variables[k, "n_missing"]
          nlev <- variables[k, "n_categories"]
          is_ordered <- variables[k, "ordered"]
        } else {
          x <- eval(parse(text = k), envir = data)
          lvl <- group_lvls[other_lvls[k]]
          nmis <- sum(is.na(x[match(
            unique(groups[[names(lvl)]]),
            groups[[names(lvl)]]
          )]))
          nlev <- nlevels(x)
          is_ordered <- is.ordered(x)
        }
        data.frame(
          out = out,
          lvl = lvl,
          nmis = nmis,
          nlev = nlev,
          ordered = is_ordered,
          type = NA
        )
      },
      simplify = FALSE
    )

    varinfo <- melt_data_frame_list(varinfo, id_vars = colnames(varinfo[[1]]))

    varinfo$type[
      !varinfo$lvl %in% max_lvl & varinfo$nlev > 2 & varinfo$ordered
    ] <- "clmm"
    varinfo$type[
      varinfo$lvl %in% max_lvl & varinfo$nlev > 2 & varinfo$ordered
    ] <- "clm"
    varinfo$type[
      !varinfo$lvl %in% max_lvl & varinfo$nlev > 2 & !varinfo$ordered
    ] <- "mlogitmm"
    varinfo$type[
      varinfo$lvl %in% max_lvl & varinfo$nlev > 2 & !varinfo$ordered
    ] <- "mlogit"
    varinfo$type[!varinfo$lvl %in% max_lvl & varinfo$nlev == 2] <-
      "glmm_binomial_logit"
    varinfo$type[varinfo$lvl %in% max_lvl & varinfo$nlev == 2] <-
      "glm_binomial_logit"
    varinfo$type[!varinfo$lvl %in% max_lvl & varinfo$nlev == 0] <- "lmm"
    varinfo$type[varinfo$lvl %in% max_lvl & varinfo$nlev == 0] <- "lm"

    survmods <- sapply(fixed, "attr", "type") %in% c("coxph", "survreg", "JM")
    if (any(survmods)) {
      varinfo$type[varinfo$L1 %in% names(fixed[survmods])] <-
        sapply(fixed[survmods], "attr", "type")
    }

    if (!is.null(attr(fixed[[1]], "type"))) {
      varinfo$type[varinfo$L1 %in% names(fixed)[1]] <- attr(fixed[[1]], "type")
    }

    varinfo <- varinfo[which(!varinfo$L1 %in% no_model), , drop = FALSE]

    types <- split(
      varinfo,
      ifelse(
        varinfo$out,
        "outcome",
        ifelse(
          varinfo$nmis > 0,
          paste0("incomplete_lvl", varinfo$lvl),
          paste0("complete_lvl", varinfo$lvl)
        )
      )
    )

    types[which(names(types) != "outcome")] <-
      lapply(types[which(names(types) != "outcome")], function(x) {
        x[order(-x$lvl, x$nmis, decreasing = TRUE), , drop = FALSE]
      })

    na_lvls <- unique(varinfo$lvl[varinfo$nmis > 0])

    models <- do.call(
      rbind,
      c(
        types["outcome"],
        if (any(!varinfo$out) & length(na_lvls) > 0) {
          lapply(1:max(na_lvls), function(k) {
            set <- if (k == max(na_lvls)) {
              c("incomplete_lvl")
            } else {
              c("incomplete_lvl", "complete_lvl")
            }
            do.call(rbind, types[paste0(set, k)])
          })
        }
      )
    )

    models <- unlist(setNames(models$type, models$L1))

    # the model types given by the user for covariates (without a formula of
    # their own) must fit the level of their variable
    check_model_type_level(
      models_user[setdiff(names(models_user), names(fixed))],
      var_ranks = setNames(varinfo$lvl, varinfo$L1),
      max_rank = max_lvl
    )
    models[names(models_user)] <- models_user
  } else {
    models <- NULL
  }
  models
}
