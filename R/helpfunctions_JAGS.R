
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
run_jags <- function(i, data_list, modelfile, n_adapt, n_iter, var_names,
                     thin) {
  adapt <- rjags::jags.model(
    file = modelfile,
    n.adapt = n_adapt,
    n.chains = 1L,
    inits = i,
    data = data_list,
    quiet = TRUE
  )

  mcmc <- rjags::coda.samples(adapt,
    n.iter = n_iter,
    variable.names = var_names,
    thin = thin, progress.bar = "none"
  )

  list(adapt = adapt, mcmc = mcmc)
}



run_samples <- function(adapt, n_iter, var_names, thin) {
  adapt$recompile()
  mcmc <- rjags::coda.samples(adapt,
    n.iter = n_iter,
    variable.names = var_names,
    progress.bar = "none", thin = thin
  )

 list(adapt = adapt, mcmc = mcmc)
}




run_parallel <- function(n_adapt, n_iter, n_chains, inits, thin = 1L,
                         data_list, var_names, modelfile, mess = TRUE,
                         n_workers, ...) {

  if (any(n_adapt > 0L, n_iter > 0L)) {

    if (mess)
      msg("Parallel sampling with %s workers started (%s).",
          eval(n_workers), Sys.time())

    res <- foreach::`%dopar%`(foreach::foreach(i = seq_along(inits)),
                              run_jags(inits[[i]], data_list = data_list,
                                       modelfile = modelfile,
                                       n_adapt = n_adapt, n_iter = n_iter,
                                       thin = thin,
                                       var_names = var_names)
    )

    mcmc <- coda::as.mcmc.list(lapply(res, function(x) x$mcmc[[1L]]))
    adapt <- lapply(res, function(x) x$adapt)

    list(adapt = adapt, mcmc = mcmc)
  }
}



run_seq <- function(n_adapt, n_iter, n_chains, inits, thin = 1L,
                    data_list, var_names, modelfile, quiet = TRUE,
                    progress_bar = "text", mess = TRUE, warn = TRUE, ...) {

  adapt <- if (any(n_adapt > 0L, n_iter > 0L)) {
    if (warn == FALSE) {
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
  mcmc <- if (n_iter > 0L & !inherits(adapt, "try-error")) {
    if (mess == FALSE) {
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

  list(adapt = adapt, mcmc = mcmc)
}


get_future_info <- function() {
  oplan <- future::plan(future::sequential)
  theplan <- attr(oplan[[1L]], "call")
  future::plan(oplan)

  strategies <- vapply(oplan, function(o) {
    setdiff(class(o), c("tweaked", "function"))[1L]
  }, FUN.VALUE = character(1L))

  if (length(strategies) > 1L) {
    warnmsg("There is a list of future strategies.
            I will use the first element, %s.",
            strategies[1L])
  }

  list(strategy = strategies[1L],
       parallel = !strategies[1L] %in% c("sequential", "transparent"),
       workers = formals(oplan[[1L]])$workers,
       call = theplan
  )
}
