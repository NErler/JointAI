make_filename <- function(modeldir, modelname, keep_model, overwrite, mess) {
  # create the model file name, either using a temporary name or values
  # provided by the user
  # - modeldir: optional path
  # - modelname: optional name of the file
  # - keep_model: logical; should the model be kept after MCMC sampling?
  #   otherwise the file will be deleted
  # - overwrite: logical: if a file with the name and path exists, should it
  #   be overwritten?

  # generate default name for model file if not specified
  if (is.null(modeldir)) {
    modeldir <- tempdir()
  }
  if (is.null(modelname)) {
    modelname <- paste0(
      "JointAI_jagsmodel_",
      format(Sys.time(), "%Y-%m-%d_%H-%M"),
      "_",
      sample.int(1.0e6, 1L),
      ".R"
    )
  } else {
    keep_model <- TRUE
  }
  modelfile <- file.path(modeldir, modelname)

  if (file.exists(modelfile) & is.null(overwrite)) {
    # This warning can not be switched off by warn = FALSE, because an input
    # is required.
    warnmsg(
      "The file %s already exists in %s.",
      dQuote(modelname),
      dQuote(modeldir)
    )

    reply <- menu(
      c("yes", "no"),
      title = "\nDo you want me to overwrite this file?"
    )

    if (reply == 1L) {
      if (mess) {
        msg("The modelfile was overwritten.")
      }
      overwrite <- TRUE
    } else {
      overwrite <- FALSE
      if (mess) msg("The old model will be used.")
    }

    if (mess) {
      msg(
        "To skip this question in the future, set %s or %s.",
        dQuote("overwrite = TRUE"),
        dQuote("overwrite = FALSE")
      )
    }
  }

  attr(modelfile, "overwrite") <- overwrite
  attr(modelfile, "keep_model") <- keep_model

  modelfile
}


get_initial_values <- function(inits, seed, n_chains, warn) {
  # check if initial values are supplied or should be generated
  if (is.null(inits)) {
    inits <- get_rng(seed, n_chains)
  } else {
    # if initial values are supplied, but they are not a function nor a list,
    # give a warning and do not use them
    if (!(is.null(inits) | inherits(inits, c("function", "list")))) {
      if (warn) {
        warnmsg(
          "The object supplied to %s could not be recognized.
              Initial values are set by JAGS.",
          sQuote("inits")
        )
      }
      inits <- get_rng(seed, n_chains)
    } else {
      if (inherits(inits, "function")) {
        # if the initial values are supplied as a function, evaluate the
        # function

        oldseed <- get_seed()
        on.exit(reset_seed(oldseed))

        if (!is.null(seed)) {
          set_seed(seed)
        }
        inits <- replicate(n_chains, inits(), simplify = FALSE)
      }

      # if initial values are supplied as a list, or were evaluated from a
      # function to a list, check if there are random number generator values
      # specified
      if (inherits(inits, "list")) {
        if (
          !any(c(".RNG.name", ".RNG.seed") %in% unlist(lapply(inits, names)))
        ) {
          inits <- Map(
            function(inits, rng) c(inits, rng),
            inits = inits,
            rng = get_rng(seed, n_chains)
          )
        }
      }
    }
  }
  inits
}


#' Get the precisions of random effects that have a truncated gamma prior
#'
#' The precision of a single random effect, and the precisions of independent
#' random effects (`rd_vcov = "indep"`), have a truncated gamma prior
#' (`dgamma(...)T(1e-16, 1e16)`, see `rd_vcov_univ()` and `rd_vcov_indep()`).
#' Correlated random effects (`"blockdiag"`, `"full"`) have a Wishart prior;
#' a `"full"` structure always has more than one random effect (with a single
#' outcome it is `"blockdiag"`).
#'
#' @param info_list a list with the information on the sub-models, as obtained
#'        from `get_model_info()`
#'
#' @returns a named integer vector: the number of random effects (the dimension
#'   of the precision matrix), named by the node of the precision matrix (e.g.,
#'   `c(invD_y_id = 1L)`); of length zero if there are no such nodes
#' @keywords internal
get_ranef_precision_nodes <- function(info_list) {
  nodes <- integer(0L)

  for (info in info_list) {
    # the levels on which the sub-model has random effects
    for (lvl in names(info$hc_list$hcvars)) {
      nranef <- as.integer(info$nranef[[lvl]])
      rd_vcov <- info$rd_vcov[[lvl]]

      # a truncated gamma prior: one random effect (not in a "full" structure)
      # or independent random effects
      is_truncated <- isTRUE(nranef == 1L && !identical(c(rd_vcov), "full")) ||
        isTRUE(nranef > 1L && rd_vcov == "indep")
      if (is_truncated) {
        node <- paste("invD", info$varname, lvl, sep = "_")
        nodes[node] <- nranef
      }
    }
  }
  nodes
}


#' Add initial values for the precisions of random effects (JAGS >= 5)
#'
#' JAGS >= 5 sets initial values that are not given from the prior: for a
#' bounded parameter, it takes the value with the highest prior density
#' (see `rjags::jags.model()`, argument `initrep`). For the truncated gamma
#' prior of the precision of random effects (see
#' [get_ranef_precision_nodes()]), this is close to the lower bound 1e-16. The
#' random effects then start at extreme values, and models with, e.g., a
#' proportional hazards or a gamma model cannot be initialised ("Node
#' inconsistent with parents"). JAGS 4 started the random effects at zero, so
#' nothing is changed for JAGS < 5.
#'
#' The initial values are drawn per chain from a log-uniform distribution
#' between 0.5 and 2 (so that the chains start at different values; the
#' variances then lie in the same range). Values the user supplied for a node
#' are kept.
#'
#' @param inits a list with one list of initial values per chain, as obtained
#'        from `get_initial_values()`
#' @param nodes a named integer vector with the nodes of the precisions and
#'        their dimension, as obtained from [get_ranef_precision_nodes()]
#' @param seed an optional seed value, to draw the same values again
#' @param jags5 logical; whether the initial values are added (by default with
#'        JAGS >= 5)
#'
#' @returns `inits`, with a matrix for each node that is not in the initial
#'   values of a chain; the drawn values are on the diagonal, the other elements
#'   are `NA` (they are data or not used)
#' @keywords internal
add_ranef_inits <- function(
  inits,
  nodes,
  seed,
  jags5 = rjags::jags.version() >= "5.0.0"
) {
  if (!isTRUE(jags5) || length(nodes) == 0L) {
    return(inits)
  }

  # draw the values reproducibly, without changing the user's random seed
  oldseed <- get_seed()
  on.exit(reset_seed(oldseed))
  if (!is.null(seed)) {
    set_seed(seed)
  }

  for (chain in seq_along(inits)) {
    for (node in names(nodes)) {
      # draw values also for a node the user supplied, so that the values of
      # the other nodes do not depend on it
      values <- exp(stats::runif(nodes[[node]], log(0.5), log(2)))
      if (is.null(inits[[chain]][[node]])) {
        precision <- matrix(NA_real_, nodes[[node]], nodes[[node]])
        diag(precision) <- values
        inits[[chain]][[node]] <- precision
      }
    }
  }
  inits
}
