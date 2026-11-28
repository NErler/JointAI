get_rng <- function(seed, n_chains) {
  # get starting values for the random number generator
  # - seed: an optional seed value
  # - n_chains: the number of MCMC chains for which starting values need to be
  #             generated

  oldseed <- get_seed()
  on.exit(reset_seed(oldseed))

  if (!is.null(seed)) {
    set_seed(seed)
  }
  seeds <- sample.int(1.0e5L, size = n_chains)

  # available random number generators
  rng <- c(
    "base::Mersenne-Twister",
    "base::Super-Duper",
    "base::Wichmann-Hill",
    "base::Marsaglia-Multicarry"
  )

  rngs <- sample(rng, size = n_chains, replace = TRUE)

  lapply(seq_along(rngs), function(k) {
    list(.RNG.name = rngs[k], .RNG.seed = seeds[k])
  })
}


# functions for parallel computation -------------------------------------------
run_jags <- function(
  inits,
  data_list,
  modelfile,
  n_chains,
  n_adapt,
  n_iter,
  var_names,
  thin,
  quiet,
  warn,
  mess,
  progress_bar,
  add_samples = FALSE,
  adapt = NULL
) {
  t0 <- Sys.time()
  if (isTRUE(add_samples)) {
    # hide the output of recompile(); close the sink also when it fails, so
    # that the error and all later console output are shown
    sink(tempfile())
    tryCatch(adapt$recompile(), finally = sink())
  } else {
    adapt <- if (isFALSE(warn)) {
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

  t1 <- Sys.time()

  # the nodes to monitor: whole nodes for elements that rjags >= 5 cannot
  # monitor, see get_monitor_nodes()
  monitor_nodes <- get_monitor_nodes(var_names)

  mcmc <- if (n_iter > 0L & !inherits(adapt, "try-error")) {
    if (isFALSE(mess)) {
      sink(tempfile())
      on.exit(sink())

      force(suppressMessages(
        try(rjags::coda.samples(
          adapt,
          n.iter = n_iter,
          thin = thin,
          variable.names = monitor_nodes,
          progress.bar = progress_bar
        ))
      ))
    } else {
      try(rjags::coda.samples(
        adapt,
        n.iter = n_iter,
        thin = thin,
        variable.names = monitor_nodes,
        progress.bar = progress_bar
      ))
    }
  }
  t2 <- Sys.time()

  # keep only the requested elements of the nodes monitored as a whole
  if (inherits(mcmc, "mcmc.list")) {
    mcmc <- select_monitored_columns(mcmc, var_names, monitor_nodes)
  }

  list(adapt = adapt, mcmc = mcmc, time_adapt = t1 - t0, time_sample = t2 - t1)
}


# used in run_jags (2026-11-27)
#' Get the nodes that JAGS monitors
#'
#' Temporary, until rjags is fixed: rjags >= 5 (checked with rjags 5-5 and
#' 5-6) cannot set a monitor on an element of a node whose name contains an
#' underscore, letters and another underscore (e.g., `D_y_id[1,2]`, the
#' covariance matrix of the random effects of `y` on the level `id`); it warns
#' "Failed to set value trace monitor". The cause is in `parse.varnames()` of
#' rjags, which takes such names for reserved names (like `"_observed_"`) and
#' does not split them into node and index. The whole node can be monitored.
#' With rjags >= 5, such elements are therefore replaced by their node, and
#' [select_monitored_columns()] keeps the requested elements. Other names
#' (e.g., `beta`, `M_lvlone[3,2]`) are monitored as they are. Monitoring whole
#' nodes costs time for large nodes (e.g., the random effects of all
#' subjects), so it is only done with rjags >= 5.
#'
#' @param var_names a character vector with the names of the nodes and
#'        elements to monitor (e.g., `"beta"`, `"D_y_id[1,2]"`)
#' @param whole_nodes logical; whether the affected elements are replaced by
#'        their node (by default with rjags >= 5)
#'
#' @returns a character vector with the names to give to JAGS: `var_names`,
#'   with the affected elements replaced by the name of their node (each node
#'   once) if `whole_nodes` is `TRUE`, otherwise `var_names`
#' @keywords internal
#'
get_monitor_nodes <- function(
  var_names,
  whole_nodes = numeric_version(getNamespaceVersion("rjags")) >= "5.0"
) {
  if (!isTRUE(whole_nodes)) {
    return(var_names)
  }

  node_names <- get_node_name(var_names)
  is_element <- grepl("[", var_names, fixed = TRUE)
  has_two_underscores <- grepl("[^_]_[^_]+_[^_]", node_names)

  monitor <- ifelse(is_element & has_two_underscores, node_names, var_names)
  unique(monitor)
}


# used in run_jags (2026-11-27)
#' Keep the requested elements of nodes that were monitored as a whole
#'
#' The samples of a node that was monitored as a whole instead of some of its
#' elements (see [get_monitor_nodes()]) are reduced to the requested elements,
#' in the requested order, at the position of the node. All other columns stay
#' as they are. The result is the same as if the elements had been monitored.
#'
#' @param mcmc an `mcmc.list` with the samples (one column per element)
#' @param var_names a character vector with the requested names of nodes and
#'        elements (as given to [get_monitor_nodes()])
#' @param monitor_nodes a character vector with the names that were given to
#'        JAGS, as obtained from [get_monitor_nodes()]
#'
#' @returns an `mcmc.list`
#' @keywords internal
#'
select_monitored_columns <- function(mcmc, var_names, monitor_nodes) {
  # the nodes monitored as a whole although only elements were requested
  expanded <- setdiff(monitor_nodes, var_names)
  if (length(expanded) == 0L) {
    return(mcmc)
  }

  # the requested elements of these nodes, named like the columns (ranges
  # such as b_y_id[5,1:2] written out)
  requested <- var_names[get_node_name(var_names) %in% expanded]
  elements <- unlist(lapply(requested, expand_element_names))

  # a node with a single element (e.g., the 1 x 1 matrix D_y_center) has the
  # name of the node as column name; give it the name of the element
  columns <- colnames(mcmc[[1L]])
  for (node in intersect(columns, expanded)) {
    columns[columns == node] <- elements[get_node_name(elements) == node]
  }

  # the columns per node, in the order of the samples; for the expanded nodes
  # only the requested elements
  column_nodes <- get_node_name(columns)
  blocks <- split(columns, factor(column_nodes, levels = unique(column_nodes)))
  for (node in intersect(names(blocks), expanded)) {
    blocks[[node]] <- elements[get_node_name(elements) == node]
  }
  keep <- unlist(blocks, use.names = FALSE)

  coda::as.mcmc.list(lapply(mcmc, function(chain) {
    colnames(chain) <- columns
    chain[, keep, drop = FALSE]
  }))
}


# used in select_monitored_columns (2026-11-27)
#' Get the node names of names of nodes and elements
#'
#' @param x a character vector with names of nodes or elements (e.g.,
#'        `"beta"`, `"D_y_id[1,2]"`)
#'
#' @returns a character vector with the names without the index (e.g.,
#'   `"beta"`, `"D_y_id"`)
#' @keywords internal
#'
get_node_name <- function(x) {
  sub("\\[.*$", "", x)
}


# used in select_monitored_columns (2026-11-27)
#' Write out the elements of a range of elements
#'
#' @param element a requested element or range of elements of a node, as
#'        given to JAGS (e.g., `"b_y_id[5,1:2]"`)
#'
#' @returns a character vector with one name per element, as JAGS names the
#'   columns of the samples, with the first index varying fastest (e.g.,
#'   `c("b_y_id[5,1]", "b_y_id[5,2]")`)
#' @keywords internal
#'
expand_element_names <- function(element) {
  element <- gsub(" ", "", element, fixed = TRUE)
  index <- sub("^[^[]*\\[(.*)\\]$", "\\1", element)

  # the values of each index: a number or a range a:b
  values <- lapply(strsplit(index, ",", fixed = TRUE)[[1L]], function(i) {
    bounds <- as.integer(strsplit(i, ":", fixed = TRUE)[[1L]])
    seq(bounds[1L], bounds[length(bounds)])
  })

  combinations <- expand.grid(values)
  paste0(
    get_node_name(element),
    "[",
    do.call(paste, c(combinations, sep = ",")),
    "]"
  )
}


#
# run_samples <- function(adapt, n_iter, var_names, thin) {
#   sink(tempfile())
#   adapt$recompile()
#   sink()
#
#   mcmc <- rjags::coda.samples(adapt,
#     n.iter = n_iter,
#     variable.names = var_names,
#     progress.bar = "none", thin = thin
#   )
#
#  list(adapt = adapt, mcmc = mcmc)
# }

run_parallel <- function(
  n_adapt,
  n_iter,
  n_chains,
  inits,
  thin = 1L,
  data_list,
  var_names,
  modelfile,
  progress_bar,
  quiet = TRUE,
  mess = TRUE,
  warn = TRUE,
  add_samples = FALSE,
  models = NULL,
  ...
) {
  if (any(n_adapt > 0L, n_iter > 0L)) {
    f <- future::future({})
    parallel <- !inherits(f, "UniprocessFuture") #f$asynchronous

    fit <- if (
      isTRUE(parallel) |
        (isTRUE(add_samples) & inherits(models, "list"))
    ) {
      if (isTRUE(mess) & isTRUE(parallel)) {
        msg(
          "Parallel sampling with %s workers started (%s).",
          future::nbrOfWorkers(),
          Sys.time()
        )
      }

      if (isTRUE(mess) & !isTRUE(parallel)) {
        msg("Note: the original model was run in parallel.")
      }

      if (isTRUE(parallel) & isTRUE(add_samples) & inherits(models, "jags")) {
        errormsg(
          "It is not possible to run %s in parallel when the input
                 %s object was run squentially.",
          dQuote("add_samples()"),
          dQuote("JointAI")
        )
      }

      out <- lapply(seq_len(n_chains), function(i) {
        future::future({
          run_jags(
            inits = inits[[i]],
            data_list = data_list,
            modelfile = modelfile,
            n_chains = 1L,
            n_adapt = n_adapt,
            n_iter = n_iter,
            thin = thin,
            var_names = var_names,
            quiet = quiet,
            warn = warn,
            mess = mess,
            progress_bar = progress_bar,
            add_samples = add_samples,
            adapt = models[[i]]
          )
        })
      })

      res <- future::value(out)

      mcmc <- try(coda::as.mcmc.list(lapply(res, function(x) x$mcmc[[1L]])))
      time_adapt <- do.call(c, lapply(res, "[[", "time_adapt"))
      time_sample <- do.call(c, lapply(res, "[[", "time_sample"))

      list(
        adapt = lapply(res, "[[", "adapt"),
        mcmc = mcmc,
        time_adapt = difftime_df(reformat_difftime(time_adapt)),
        time_sample = difftime_df(reformat_difftime(time_sample))
      )
    } else {
      run_jags(
        inits = inits,
        data_list = data_list,
        modelfile = modelfile,
        n_chains = n_chains,
        n_adapt = n_adapt,
        n_iter = n_iter,
        thin = thin,
        var_names = var_names,
        quiet = quiet,
        warn = warn,
        mess = mess,
        progress_bar = progress_bar,
        add_samples = add_samples,
        adapt = models
      )
    }

    fit$parallel <- parallel
    fit$workers <- future::nbrOfWorkers()

    if (!isTRUE(parallel)) {
      fit$time_adapt <- difftime_df(fit$time_adapt)
      fit$time_sample <- difftime_df(fit$time_sample)
    }
    fit
  }
}


#' Set all elements of a `difftime` object to the same, largest meaningful unit
#'
#' @param dt a `difftime` object (potentially a vector of `difftime`s)
#' @keywords internal
reformat_difftime <- function(dt) {
  units(dt) <- "secs"
  w <- which(min(dt) / c(secs = 1, mins = 60, hours = 3600, days = 86400) > 1L)
  if (any(w)) {
    units(dt) <- names(w)[length(w)]
  }
  dt
}


#' Converts a `difftime` object to a `data.frame`
#'
#' @param dt `difftime` object (vector of `difftime` objects)
#' @keywords internal
difftime_df <- function(dt) {
  if (length(dt) > 1L) {
    dt <- setNames(dt, paste0("chain", seq_along(dt)))
  } else {
    dt <- setNames(dt, "total")
  }
  as.data.frame(as.list(dt))
}


rbind_duration <- function(dur, dur_new) {
  Map(
    function(dur_old, dur_new) {
      rownames(dur_new) <- paste0("run ", nrow(dur_old) + 1)
      rbind(dur_old, dur_new)
    },
    dur_old = dur,
    dur_new = dur_new
  )
}


#' Create a duration object
#'
#' Add row names to the object
#'
#' @param dur list of `difftime` objects
#' @keywords internal
duration_obj <- function(dur) {
  lapply(dur, function(x) {
    rownames(x) <- paste0("run ", 1:nrow(x))
    x
  })
}


#' Calculate the sum of the computational duration of a JointAI object
#'
#' @param object object of class `JointAI`
#' @param by grouping; one of `"all"` (default) to calculate the sum over
#'           all chains and runs and both the adaptive and sampling phase,
#'           `"phase"` to get the sum over all chains and runs per phase,
#'           `"run"` to get the duration per run (over both phases),
#'           `"chain"` to get the sum per chain over both phases and all runs,
#'           `"phase and run"` (or `"run and phase"`) to get the sum over all
#'           chains, separately per phase and run. `NULL` (the default in
#'           earlier versions) is the same as `"all"`.
#'
#' @return The duration(s), as \code{difftime}: for \code{by = "all"} a single
#'         value; for \code{"phase"} a list with elements \code{adapt} and
#'         \code{sample}; for \code{"run"} a named vector with one value per
#'         run; for \code{"chain"} a named vector with one value per chain
#'         (a single value \code{total} when the chains were not run in
#'         parallel); for \code{"phase and run"} a list with elements
#'         \code{adapt} and \code{sample}, each a named vector with one value
#'         per run.
#'
#' @examples
#' \donttest{
#' mod <- lm_imp(y ~ C1 + C2, data = wideDF, n.iter = 100, mess = FALSE)
#'
#' sum_duration(mod)
#' sum_duration(mod, by = "phase")
#' }
#'
#' @export
#'
sum_duration <- function(
  object,
  by = c("all", "phase", "run", "chain", "phase and run", "run and phase")
) {
  by_options <- eval(formals(sum_duration)$by)

  # by = NULL was the default in earlier versions
  if (missing(by) || is.null(by)) {
    by <- "all"
  }

  if (length(by) != 1L || !by %in% by_options) {
    errormsg(
      "The argument %s must be one of %s.",
      dQuote("by"),
      paste(dQuote(by_options), collapse = ", ")
    )
  }

  obj <- object$comp_info$duration

  if (by != "chain") {
    # per phase: the duration of each run (sum over the chains, or for
    # parallel chains the longest chain)
    s <- lapply(obj, function(p) {
      # split by run, keeping the runs in their order (split() would sort
      # the run names as text: "run 10" before "run 2")
      runs <- factor(rownames(p), levels = rownames(p))
      r <- Map(
        function(vec, parallel) {
          if (parallel) {
            max(do.call(c, vec))
          } else {
            sum(do.call(c, vec))
          }
        },
        vec = split(p, runs),
        parallel = object$comp_info$parallel
      )

      do.call(c, r)
    })

    if (by == "all") {
      sum(do.call(c, s))
    } else if (by %in% c("phase and run", "run and phase")) {
      s
    } else if (by == "phase") {
      lapply(s, sum)
    } else if (by == "run") {
      # per run: the sum over the phases
      Reduce(`+`, s)
    }
  } else if (by == "chain") {
    do.call(c, lapply(c(do.call(rbind, obj)), sum))
  }
}
