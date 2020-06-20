
get_RNG <- function(seed, n.chains) {
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
