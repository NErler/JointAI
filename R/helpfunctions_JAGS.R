
get_rng <- function(seed, n_chains) {
  # get starting values for the random number generator
  # - seed: an optional seed value
  # - n_chains: the number of MCMC chains for which starting values need to be
  #             generated

  oldseed <- .Random.seed
  on.exit({
    .Random.seed <<- oldseed
  })

  if (!is.null(seed)) {
    set_seed(seed)
  }
  seeds <- sample.int(1.0e5L, size = n_chains)

  # available random number generators
  rng <- c("base::Mersenne-Twister",
           "base::Super-Duper",
           "base::Wichmann-Hill",
           "base::Marsaglia-Multicarry")

  rngs <- sample(rng, size = n_chains, replace = TRUE)

  lapply(seq_along(rngs), function(k) {
    list(.RNG.name = rngs[k],
         .RNG.seed = seeds[k]
    )
  })
}



# functions for parallel computation -------------------------------------------
run_jags <- function(inits, data_list, modelfile, n_chains, n_adapt, n_iter,
                     var_names, thin, quiet, warn, mess, progress_bar,
                     add_samples = FALSE, adapt = NULL) {


  t0 <- Sys.time()
  if (isTRUE(add_samples)) {
    sink(tempfile())
    adapt$recompile()
    sink()
  } else {
    adapt <- if (isFALSE(warn)) {
      suppressWarnings({
        try(rjags::jags.model(file = modelfile, data = data_list,
                              inits = inits, quiet = quiet,
                              n.chains = n_chains, n.adapt = n_adapt))
      })
    } else {
      try(rjags::jags.model(file = modelfile, data = data_list,
                            inits = inits, quiet = quiet,
                            n.chains = n_chains, n.adapt = n_adapt))
    }
  }

  t1 <- Sys.time()

  mcmc <- if (n_iter > 0L & !inherits(adapt, "try-error")) {
    if (isFALSE(mess)) {
      sink(tempfile())
      on.exit(sink())

      force(suppressMessages(
        try(rjags::coda.samples(adapt, n.iter = n_iter, thin = thin,
                                variable.names = var_names,
                                progress.bar = progress_bar))
      ))
    } else {
      try(rjags::coda.samples(adapt, n.iter = n_iter, thin = thin,
                              variable.names = var_names,
                              progress.bar = progress_bar))

    }
  }
  t2 <- Sys.time()

  list(adapt = adapt, mcmc = mcmc,
       time_adapt = t1 - t0,
       time_sample = t2 - t1)
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




run_parallel <- function(n_adapt, n_iter, n_chains, inits, thin = 1L,
                         data_list, var_names, modelfile, progress_bar,
                         quiet = TRUE, mess = TRUE, warn = TRUE,
                         add_samples = FALSE, models = NULL, ...) {

  if (any(n_adapt > 0L, n_iter > 0L)) {

    f <- future::future({})
    parallel <- f$asynchronous

    fit <- if (isTRUE(parallel) |
               (isTRUE(add_samples) & inherits(models, "list"))) {

      if (isTRUE(mess) & isTRUE(parallel))
        msg("Parallel sampling with %s workers started (%s).",
            length(f$workers), Sys.time())

      if (isTRUE(mess) & !isTRUE(parallel))
        msg("Note: the original model was run in parallel.")

      if (isTRUE(parallel) & isTRUE(add_samples) & inherits(models, "jags"))
        errormsg("It is not possible to run %s in parallel when the input
                 %s object was run squentially.", dQuote("add_samples()"),
                 dQuote("JointAI"))

      out <- lapply(seq_len(n_chains), function(i) {
        future::future({
          run_jags(inits = inits[[i]], data_list = data_list,
                   modelfile = modelfile,
                   n_chains = 1L,
                   n_adapt = n_adapt, n_iter = n_iter,
                   thin = thin,
                   var_names = var_names, quiet = quiet, warn = warn,
                   mess = mess, progress_bar = progress_bar,
                   add_samples = add_samples, adapt = models[[i]])
        })
      })

      res <- lapply(out, future::value)

      mcmc <- try(coda::as.mcmc.list(lapply(res, function(x) x$mcmc[[1L]])))
      time_adapt <- do.call(c, lapply(res, "[[", "time_adapt"))
      time_sample <- do.call(c, lapply(res, "[[", "time_sample"))

      list(adapt = lapply(res, "[[", "adapt"),
           mcmc = mcmc,
           time_adapt = difftime_df(reformat_difftime(time_adapt)),
           time_sample = difftime_df(reformat_difftime(time_sample))
      )

    } else {

      run_jags(inits = inits, data_list = data_list,
               modelfile = modelfile,
               n_chains = n_chains,
               n_adapt = n_adapt, n_iter = n_iter,
               thin = thin,
               var_names = var_names, quiet = quiet, warn = warn,
               mess = mess, progress_bar = progress_bar,
               add_samples = add_samples, adapt = models)
    }

    fit$parallel <- parallel
    fit$workers <- length(f$workers)

    if (!isTRUE(parallel)) {
      fit$time_adapt <- difftime_df(fit$time_adapt)
      fit$time_sample <- difftime_df(fit$time_sample)
    }
    fit
  }
}


#' Set all elements of a `difftime` object to the same, largest meaningful unit
#' @param dt a `difftime` object (potentially a vector of `difftime`s)
#' @keywords internal
reformat_difftime <- function(dt) {
  units(dt) <- "secs"
  w <- which(min(dt)/c(secs = 1, mins = 60, hours = 3600, days = 86400) > 1L)
  if (any(w))
    units(dt) <- names(w)[length(w)]
  dt
}


#' Converts a `difftime` object to a `data.frame`
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
  Map(function(dur_old, dur_new) {
    rownames(dur_new) <- paste0("run ", nrow(dur_old) + 1)
    rbind(dur_old, dur_new)
  }, dur_old = dur, dur_new = dur_new)
}


#' Create a duration object
#'
#' Add row names to the object
#'
#' @param dur list of `difftime` objects
#' @keywords internal
duration_obj <- function(dur) {
    lapply(dur, function(x)  {
      rownames(x) <- paste0("run ", 1:nrow(x))
      x
    })
}


#' Calculate the sum of the computational duration of a JointAI object
#'
#' @param object object of class `JointAI`
#' @param by optional grouping information; options are `NULL` (default) to
#'           calculate the sum over all chains and runs and both the adaptive
#'           and sampling phase, `"run"` to get the duration per run,
#'           `"phase"` to get the sum over all chains and runs per phase,
#'           `"chain"` to get the sum per chain over both phases and all runs,
#'           `"phase and run"` to get the sum over all chains, separately per
#'           phase and run.
#'
#' @export
#'
sum_duration <- function(object, by = NULL) {
  obj <- object$comp_info$duration

  if (is.null(by) || by %in% c("phase", "phase and run", "run and phase")) {

    s <- lapply(obj, function(p) {

      r <- Map(function(vec, parallel) {
        if (parallel) {
          max(do.call(c, vec))
        } else {
          sum(do.call(c, vec))
        }
      }, vec = split(p, rownames(p)), parallel = object$comp_info$parallel)

      do.call(c, r)
    })


    if (is.null(by)) {
      sum(do.call(c, s))
    } else if (by %in% c("phase and run", "run and phase")) {
      s
    } else if (by == "phase") {
      lapply(s, sum)
    }

  } else if (by == "run") {

    r <- do.call(cbind, obj)

    s <- Map(function(vec, parallel) {
      if (parallel) {
        max(do.call(c, vec))
      } else {
        sum(do.call(c, vec))
      }
    }, vec = split(r, rownames(r)),
    parallel = object$comp_info$parallel)

    do.call(c, s)

  } else if (by == "chain") {
    do.call(c, lapply(c(do.call(rbind, obj)), sum))
  }
}


