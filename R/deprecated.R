# Deprecated internal functions; kept in here to pass reverse dependency check
# since remiod uses them

get_future_info <- function(mess = TRUE) {
  if (mess) {
    msg(
      "The function %s is deprecated and will be removed in future versions
        of JointAI.",
      dQuote("get_future_info()")
    )
  }

  oplan <- future::plan(future::sequential)
  theplan <- attr(oplan[[1L]], "call")
  future::plan(oplan)
  strategies <- vapply(
    oplan,
    function(o) {
      setdiff(class(o), c("tweaked", "function"))[1L]
    },
    FUN.VALUE = character(1L)
  )
  if (length(strategies) > 1L) {
    warnmsg(
      "There is a list of future strategies.\n            I will use the first element, %s.",
      strategies[1L]
    )
  }
  list(
    strategy = strategies[1L],
    parallel = !strategies[1L] %in%
      c("sequential", "transparent"),
    workers = formals(oplan[[1L]])$workers,
    call = theplan
  )
}


run_seq <- function(
  n_adapt,
  n_iter,
  n_chains,
  inits,
  thin = 1L,
  data_list,
  var_names,
  modelfile,
  quiet = TRUE,
  progress_bar = "text",
  mess = TRUE,
  warn = TRUE,
  ...
) {
  if (mess) {
    msg(
      "The function %s is deprecated and will be removed in future versions
        of JointAI.",
      dQuote("run_seq()")
    )
  }

  adapt <- if (any(n_adapt > 0L, n_iter > 0L)) {
    if (warn == FALSE) {
      suppressWarnings({
        try(rjags::jags.model(
          file = modelfile,
          data = data_list,
          inits = inits,
          quiet = quiet,
          n.chains = n_chains,
          n.adapt = n_adapt
        ))
      })
    } else {
      try(rjags::jags.model(
        file = modelfile,
        data = data_list,
        inits = inits,
        quiet = quiet,
        n.chains = n_chains,
        n.adapt = n_adapt
      ))
    }
  }
  mcmc <- if (n_iter > 0L & !inherits(adapt, "try-error")) {
    if (mess == FALSE) {
      sink(tempfile())
      on.exit(sink())
      force(suppressMessages(
        try(rjags::coda.samples(
          adapt,
          n.iter = n_iter,
          thin = thin,
          variable.names = var_names,
          progress.bar = progress_bar
        ))
      ))
    } else {
      try(rjags::coda.samples(
        adapt,
        n.iter = n_iter,
        thin = thin,
        variable.names = var_names,
        progress.bar = progress_bar
      ))
    }
  }

  list(adapt = adapt, mcmc = mcmc)
}


identify_level_relations <- function(grouping) {
  .Deprecated(
    "get_grouping_levels",
    package = "JointAI",
    old = "identify_level_relations"
  )

  # if grouping is not yet a list, make it a list
  if (!is.list(grouping)) {
    grouping <- list(grouping)
  }

  # turn the list into a matrix, with the different levels as columns
  g <- do.call(cbind, grouping)
  # check if the grouping information varies within each of the clusters
  res <- apply(g, 2L, check_cluster, grouping = grouping, simplify = FALSE)
  res <- do.call(cbind, res)

  if (!is.matrix(res)) {
    res <- t(res)
  }

  # res is a matrix with a row and column per grouping level, containing
  # TRUEs and FALSEs
  res
}

check_cluster <- function(x, grouping) {
  # check if a variable varies within one cluster
  # - x: a vector
  # - grouping: a list of grouping information (obtained from get_groups())
  .Deprecated("get_groups", package = "JointAI", old = "check_cluster")

  attributes(x) <- NULL

  lvapply(grouping, function(k) {
    # for each level of grouping, compare the original vector with a
    # reconstructed vector in which the first element per group is repeated
    # for each group member
    !identical(x[match(unique(k), k)][match(k, unique(k))], x)
  })

  # returns a logical vector with length = length(groups) were TRUE means that
  # the variable varies in the given level
}


extract_id <- function(random, warn = TRUE) {
  .Deprecated("extract_grouping", package = "JointAI", old = "extract_id")

  random <- check_formula_list(random)

  ids <- lapply(random, function(x) {
    # match the vertical bar (...|...)
    rdmatch <- gregexpr(
      pattern = "\\([^|]*\\|[^)]*\\)",
      deparse(x, width.cutoff = 500L)
    )

    if (any(rdmatch[[1L]] > 0L)) {
      # remove "(... | " from the formula
      rd <- unlist(regmatches(
        deparse(x, width.cutoff = 500L),
        rdmatch,
        invert = FALSE
      ))
      rdid <- gregexpr(pattern = "[[:print:]]*\\|[[:space:]]*", rd)

      # extract and remove )
      id <- gsub(")", "", unlist(regmatches(rd, rdid, invert = TRUE)))

      # split by + * : /
      id <- unique(unlist(strsplit(
        id[id != ""],
        split = "[[:space:]]*[+*:/][[:space:]]*"
      )))
    } else {
      rdmatch <- gregexpr(
        pattern = "[[:print:]]*\\|[ ]*",
        deparse(x, width.cutoff = 500L)
      )

      if (any(rdmatch[[1L]] > 0L)) {
        # remove "... | " from the formula
        id <- unlist(regmatches(
          deparse(x, width.cutoff = 500L),
          rdmatch,
          invert = TRUE
        ))
        id <- unique(unlist(strsplit(
          id[id != ""],
          split = "[[:space:]]*[+*:/][[:space:]]*"
        )))
      } else {
        id <- NULL
      }
    }
    id
  })

  if (is.null(unlist(ids)) & !is.null(unlist(random))) {
    if (warn) {
      warnmsg(
        "No %s variable could be identified. I will assume that all
              observations are independent.",
        dQuote("id")
      )
    }
  }

  unique(unlist(ids))
}


check_varlevel <- function(x, groups, group_lvls = NULL) {
  .Deprecated("get_datlvls", package = "JointAI", old = "check_varlevel")
  # identify the level of a variable
  # - x: a vector
  # - groups: a list of grouping information (obtained from get_groups())
  # - group_lvls: the grouping level matrix
  #               (obtained from identify_level_relations())

  # if there are no groups, make a list with group name "no_levels" so that the
  # syntax does not fail for single-level models
  if (!is.list(groups)) {
    groups <- list("no_levels" = groups)
  }

  # check the clustering of the variable
  clus <- check_cluster(x, grouping = groups)

  # clus is a logical vector, which is TRUE if x varies in a given level and
  # FALSE when x is constant in the level

  if (sum(!clus) > 1L) {
    # if the variable is constant in more than one level, the exact level needs
    # to be determined using the level structure of the grouping
    if (is.null(group_lvls)) {
      group_lvls <- identify_level_relations(groups)
    }

    names(which.max(colSums(!group_lvls[!clus, !clus, drop = FALSE])))
  } else if (sum(!clus) == 1L) {
    # if the variable is constant in exactly one level, that level is the
    # level of the variable
    names(clus)[!clus]
  } else {
    # if the variable varies in all levels, it is from level one
    "lvlone"
  }
}


extract_lhs <- function(formula) {
  .Deprecated("extract_lhs_string", package = "JointAI", old = "extract_lhs")

  if (is.null(formula)) {
    return(NULL)
  }

  # check that formula is a formula object
  if (!inherits(formula, "formula")) {
    errormsg("The provided formula is not a %s object.", dQuote("formula"))
  }

  # check that the formula has a LHS
  if (attr(terms(formula), "response") != 1L) {
    errormsg("Unable to extract response from the formula.")
  }

  if (length(formula) == 3L) {
    deparse(formula[[2L]], width.cutoff = 500L)
    # } else if (length(formula) == 2L) {
    # ""
  } else {
    # not sure this is ever needed... Can't come up with an example for a
    # formula that has a response and length 2.
    errormsg(
      "Unable to extract a response from the formula.
             Formula is not of length 3."
    )
  }
}


# used in divide_matrices, get_models, and helpfunctions (2020-06-09)
extract_outcome <- function(fixed) {
  .Deprecated(
    "extract_outcomes_list",
    package = "JointAI",
    old = "extract_outcome"
  )

  # Extract the names(s) of the outcome variable(s) from (a list of) fixed
  # effects formula(s)
  # - fixed: a two-sided formula object or a list of such objects

  # if fixed is not a list, turn into list
  fixed <- check_formula_list(fixed)

  out_nam_list <- lapply(fixed, function(x) {
    # get the LHS of the formula
    lhs <- extract_lhs(x)

    # names of the outcome variables
    outnam <- all.vars(as.formula(paste0(lhs, "~ 1")))

    if (any(length(outnam) == 0L, is.na(outnam), is.null(outnam))) {
      errormsg("Unable to extract the outcome variable.")
    }
    outnam
  })

  names(out_nam_list) <- cvapply(fixed, extract_lhs)

  out_nam_list
}


melt_data.frame <- function(
  data,
  id.vars = NULL,
  varnames = NULL,
  valname = 'value'
) {
  .Deprecated("melt_data_frame", package = "JointAI", old = "melt_data.frame")

  if (!inherits(data, 'data.frame')) {
    errormsg("This function may not work for objects that are not data.frames.")
  }

  data$rowID <- paste0('rowID', seq_len(nrow(data)))
  X <- data[, !names(data) %in% c('rowID', id.vars), drop = FALSE]

  g <- list(rowID = data$rowID, variable = if (ncol(X) > 0) names(X))

  out <- expand.grid(Filter(Negate(is.null), g), stringsAsFactors = FALSE)

  if (length(unique(sapply(X, class))) > 1) {
    out[, valname] <- unlist(lapply(X, as.character))
  } else {
    out[, valname] <- unlist(X)
  }

  mout <- merge(data[, c("rowID", id.vars)], out)

  attr(mout, 'out.attrs') <- NULL

  if (ncol(X) > 0) mout[order(mout$variable), -1] else mout
}


# Internal, but still exported: remiod calls clean_survname() without a namespace
# prefix, via import(JointAI), so it would break without the export. JointAI
# itself uses internal_clean_survname(). Remove this function once remiod no
# longer calls it.

#' Convert a survival outcome to a model name
#'
#' A helper function that converts the "name of a survival model"
#' (the \code{"Surv(time, status)"} specification) into a valid variable name
#' so that it can be used in the JAGS model syntax.
#'
#' @param x a character string or vector of character strings
#'
#' @return A character vector of the same length as \code{x}, in which
#'         survival outcomes (\code{"Surv(...)"}) are replaced by valid
#'         variable names; other values are returned unchanged.
#'
#' @keywords internal
#' @export
clean_survname <- function(x) {
  warning(
    "clean_survname() is retained for backward compatibility only and may be removed in a future release.",
    call. = FALSE
  )
  internal_clean_survname(x)
}


# not used in JointAI (replaced by get_outcome_data()); kept unchanged for
# remiod (2026-11-07)
extract_outcome_data <- function(
  fixed,
  random = NULL,
  data,
  analysis_type = NULL,
  warn = TRUE
) {
  fixed <- check_formula_list(fixed)

  idvar <- extract_grouping(random, warn = warn)
  groups <- get_groups(idvar, data)

  lvls <- get_grouping_levels(groups)

  outcomes <- outnams <- extract_outcomes_list(fixed)

  for (i in seq_along(fixed)) {
    # before the outcome is evaluated: `Surv()` may give an unrelated error
    check_surv_type(names(outnams[i]), data)

    if (
      survival::is.Surv(eval(parse(text = names(outnams[i])), envir = data))
    ) {
      outcomes[[i]] <- varname_to_modelframe(names(outnams[i]), data)

      if (any(is.na(outcomes[[i]]))) {
        errormsg("There are missing values in the survival time or status.")
      }

      names(outcomes[[i]]) <- idSurv(names(outnams[i]))[c("time", "status")]
      outcomes[[i]] <- as.data.frame(
        lapply(outcomes[[i]], factor_to_integer),
        check.names = FALSE
      )

      attr(fixed[[i]], "type") <- if (analysis_type == "coxph") {
        "coxph"
      } else if (analysis_type == "JM") {
        "JM"
      } else {
        "survreg"
      }
      names(fixed)[i] <- names(outnams[i])
    } else {
      outcomes[[i]] <- varname_to_modelframe(
        extract_lhs_string(fixed[[i]]),
        data
      )

      if (ncol(outcomes[[i]]) != 1L) {
        errormsg(
          "I expected a one-column response, but found the response has %s
          columns for outcome %s.",
          ncol(outcomes[[i]]),
          i
        )
      }
      nlev <- ivapply(outcomes[[i]], function(x) length(levels(x)))
      varlvl <- get_datlvls(outcomes[[i]], groups)

      if (i == 1L) {
        attr(fixed[[i]], "type") <- paste_analysis_type(analysis_type)
      } else {
        # the variable, not the one-column data.frame
        attr(fixed[[i]], "type") <- choose_default_model(
          outcomes[[i]][[1L]],
          lvls[varlvl],
          max(lvls)
        )
      }
      outcomes[[i]] <- as.data.frame(
        lapply(outcomes[[i]], factor_to_integer),
        check.names = FALSE
      )
      names(fixed)[i] <- outnams[i]
    }
  }
  list(fixed = fixed, outcomes = outcomes, outnams = outnams)
}


# not used in JointAI (replaced by get_linpred_columns()); kept unchanged for
# remiod (2026-11-07)
get_linpreds <- function(
  fixed,
  random,
  data,
  models,
  auxvars = NULL,
  analysis_type = NULL,
  warn = TRUE,
  refs
) {
  # obtain the linear predictor columns and variable names for all models
  # involved
  # - fixed: list of fixed effects formulas
  # - random: list of random effects formulas
  # - data: a data.frame with the pre-processed data
  # - models: named vector of all model types
  # - auxvars: optional formula of auxiliary variables
  # - analysis_type: type of analysis, including family as attribute if glm(m)
  # - warn: logical; should warning messages be given

  # check if fixed is a list and otherwise convert it to a list
  fixed <- check_formula_list(fixed)

  # extract the id variable and clustering structure from the random effects
  # formula and data
  idvar <- extract_grouping(random, warn = warn)
  groups <- get_groups(idvar, data)

  # identify all variables involved and those variables that are covariates
  allvars <- all_vars(fixed, remove_grouping(random), auxvars)

  # in order to be able to include functions in the auxiliary variables,
  # extract the term labels from auxvars and build the formula used
  # to create the design matrices for the covariate models using these
  # term labels.
  auxterms <- if (!is.null(auxvars)) attr(terms(auxvars), "term.labels")

  covar_terms <- all_vars(remove_lhs(fixed), remove_grouping(random), auxterms)

  # identify the levels of all variables
  lvl <- get_datlvls(data[, allvars, drop = FALSE], groups)

  group_lvls <- get_grouping_levels(groups)

  # make a subset containing only covariates
  subdat <- subset(
    data,
    select = setdiff(allvars, unlist(extract_outcomes_list(fixed)))
  )

  contr_list <- lapply(refs, attr, "contr_matrix")

  # for each fixed effects (main model) formula, get the column names of the
  # design matrix of the fixed effects
  lp <- nlapply(fixed, function(fmla) {
    covars <- cvapply(
      attr(
        terms(remove_lhs(fmla)),
        "variables"
      )[-1L],
      deparse,
      width.cutoff = 500L
    )

    contr_list0 <- contr_list[intersect(covars, names(contr_list))]

    if (attr(fmla, "type") %in% c("clm", "clmm", "coxph", "JM")) {
      # for ordinal and cox models, exclude the intercept
      colnam <- colnames(
        model.matrix(fmla, data, contrasts.arg = contr_list0)
      )[-1L]
      if (length(colnam) > 0L) colnam
    } else {
      colnames(model.matrix(fmla, data, contrasts.arg = contr_list0))
    }
  })

  #  for all models that are not specified in fixed
  #  - identify if an intercept is needed (no intercept for ordinal and cox)
  #  - generate a RHS formula
  for (out in names(models)[!names(models) %in% names(fixed)]) {
    nointercept <- models[out] %in% c("clmm", "clm", "coxph")

    # identify variables that have
    # - level higher than the level of the outcome, or
    # - the same level (note: the same level name, not just the same value in
    #   the hierarchy. This is important in case of crossed random effects
    #   where two levels may have the same value in the hierarchy, but then
    #   the model should only include covariates from the same level, but not
    #   from the crossed level).
    relvars <- group_lvls[lvl[colnames(subdat)]] > group_lvls[lvl[out]] |
      lvl[colnames(subdat)] == lvl[out]

    testdat <- subset(subdat, select = relvars & (colnames(subdat) != out))

    keep_terms <- lvapply(covar_terms, function(k) {
      check_effect <- try(model.frame(paste0("~", k), testdat), silent = TRUE)
      !inherits(check_effect, "try-error") &
        all_vars(formula(paste("~", k))) %in% names(testdat)
    })

    covar_terms <- covar_terms[keep_terms]

    fmla <- as.formula(
      paste0(
        out,
        " ~ ",
        switch(
          as.character(length(covar_terms) == 0L),
          "TRUE" = "1",
          "FALSE" = paste0(covar_terms, collapse = " + ")
        ),
        if (nointercept) "-1"
      )
    )

    # get the names of the columns of the corresponding design matrix
    lp[[out]] <- colnames(
      model.matrix(
        fmla,
        subdat,
        contrasts.arg = contr_list[intersect(
          all_vars(remove_lhs(fmla)),
          names(contr_list)
        )]
      )
    )

    # if the linear predictor is empty, create an empty object, to make the
    # subsequent code work in any case
    if (is.null(lp[[out]])) {
      lp <- c(lp, setNames(list(NULL), out))
    }

    subdat <- subset(subdat, select = -c(get(out)))
  }
  lp
}
