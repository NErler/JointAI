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
  .Deprecated("get_grouping_levels ", package = "JointAI")

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
  .Deprecated("get_groups ", package = "JointAI")

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
  .Deprecated("extract_grouping ", package = "JointAI")

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
  .Deprecated("get_datlvls ", package = "JointAI")
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
  .Deprecated("extract_lhs_string ", package = "JointAI")

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
  .Deprecated("extract_outcomes_list ", package = "JointAI")

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


split_formula <- function(formula) {
  .Deprecated("split_formula_list ", package = "JointAI")

  # get all terms from the formula and identify which contain the vertical bar
  # (= random effects)
  term_labels <- attr(terms(formula), "term.labels")
  which_ranef <- grepl("|", term_labels, fixed = TRUE)

  # build fixed effects formula by combining all non-random effects terms with
  # a "+", and combine with the LHS
  rhs <- paste(
    c(
      term_labels[!which_ranef],
      if (attr(terms(formula), "intercept") == 0L) "0"
    ),
    collapse = " + "
  )

  fixed <- paste0(
    as.character(formula)[2L],
    " ~ ",
    if (rhs == "") {
      1L
    } else {
      rhs
    }
  )

  # build random effects formula by pasting all random effects terms in brackets
  # (to separate different random effects terms from each other), and combine
  # them with "+"
  rhs2 <- paste0("(", term_labels[which_ranef], ")", collapse = " + ")

  # if there are random effect terms at all, combine with "~" and convert to a
  # formula object
  random <- if (rhs2 != "()") as.formula(paste0(" ~ ", rhs2))

  list(fixed = as.formula(fixed), random = random)
}


melt_data.frame <- function(
  data,
  id.vars = NULL,
  varnames = NULL,
  valname = 'value'
) {
  .Deprecated("melt_data_frame ", package = "JointAI")

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


#' Convert a survival outcome to a model name
#'
#' A helper function that converts the "name of a survival model"
#' (the \code{"Surv(time, status)"} specification) into a valid variable name
#' so that it can be used in the JAGS model syntax.
#'
#' @param x a character string or vector of character strings
#'
#' @export
clean_survname <- function(x) {
  warning(
    "clean_survname() is retained for backward compatibility only and may be removed in a future release.",
    call. = FALSE
  )
  internal_clean_survname(x)
}
