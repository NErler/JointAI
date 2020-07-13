
get_rng <- function(seed, n.chains) {
  # get starting values for the random number generator
  # - seed: an optional seed value
  # - n.chains: the number of MCMC chains for which starting values need to be
  #             generated

  if (!is.null(seed)) set.seed(seed)
  seeds <- sample.int(1e5, size = n.chains)

  # available random number generators
  rng <- c("base::Mersenne-Twister",
           "base::Super-Duper",
           "base::Wichmann-Hill",
           "base::Marsaglia-Multicarry")

  RNGs <- sample(rng, size = n.chains, replace = TRUE)

  lapply(seq_along(RNGs), function(k) {
    list(.RNG.name = RNGs[k],
         .RNG.seed = seeds[k]
    )
  })
}



# functions for parallel computation -------------------------------------------
run_jags <- function(i, data_list, modelfile, n.adapt, n.iter, var.names,
                     thin) {
  adapt <- rjags::jags.model(
    file = modelfile, n.adapt = n.adapt,
    n.chains = 1, inits = i, data = data_list,
    quiet = TRUE
  )

  mcmc <- rjags::coda.samples(adapt,
    n.iter = n.iter,
    variable.names = var.names,
    thin = thin, progress.bar = "none"
  )

  return(list(adapt = adapt, mcmc = mcmc))
}



run_samples <- function(adapt, n.iter, var.names, thin) {
  adapt$recompile()
  mcmc <- rjags::coda.samples(adapt,
    n.iter = n.iter,
    variable.names = var.names,
    progress.bar = "none", thin = thin
  )

  return(list(adapt = adapt, mcmc = mcmc))
}




run_parallel <- function(n.adapt, n.iter, n.cores, n.chains, inits, thin = 1,
                         data_list, var.names, modelfile, mess = TRUE, ...) {
  if (!requireNamespace("foreach", quietly = TRUE))
    errormsg("Parallel sampling requires the %s package to
               be installed.", sQuote("foreach"))

  if (!requireNamespace("doParallel", quietly = TRUE))
    errormsg("Parallel sampling requires the %s package
               to be installed.", sQuote("doParallel"))

  if (any(n.adapt > 0, n.iter > 0)) {
    if (is.null(n.cores))
      n.cores <- min(parallel::detectCores() - 2, n.chains)


    doParallel::registerDoParallel(cores = n.cores)
    if (mess)
      msg("Parallel sampling on %s cores started (%s).", n.cores, Sys.time())

    res <- foreach(i = seq_along(inits)) %dopar% {
      run_jags(inits[[i]], data_list = data_list,
               modelfile = modelfile,
               n.adapt = n.adapt, n.iter = n.iter, thin = thin,
               var.names = var.names)
      }
    doParallel::stopImplicitCluster()


    mcmc <- coda::as.mcmc.list(lapply(res, function(x) x$mcmc[[1]]))
    adapt <- lapply(res, function(x) x$adapt)

    list(adapt = adapt, mcmc = mcmc)
  }
}



run_seq <- function(n.adapt, n.iter, n.cores, n.chains, inits, thin = 1,
                    data_list, var.names, modelfile, quiet = TRUE,
                    progress.bar = "text", mess = TRUE, ...) {

  adapt <- if (any(n.adapt > 0, n.iter > 0)) {
    try(rjags::jags.model(file = modelfile, data = data_list,
                          inits = inits, quiet = quiet,
                          n.chains = n.chains, n.adapt = n.adapt))
  }
  mcmc <- if (n.iter > 0 & !inherits(adapt, "try-error")) {
    try(rjags::coda.samples(adapt, n.iter = n.iter, thin = thin,
                            variable.names = var.names,
                            progress.bar = progress.bar))
  }

  list(adapt = adapt, mcmc = mcmc)
}
