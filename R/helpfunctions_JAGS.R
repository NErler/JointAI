get_RNG <- function(seed, n.chains) {
  if (!is.null(seed)) set.seed(seed)
  seeds <- sample.int(1e5, size = n.chains)

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




run_jags <- function(i, data_list, modelfile, n.adapt, n.iter, var.names) {

  adapt <- rjags::jags.model(file = modelfile, n.adapt = n.adapt,
                             n.chains = 1, inits = i, data = data_list,
                             quiet = TRUE)

  mcmc <- rjags::coda.samples(adapt, n.iter = n.iter, variable.names = var.names,
                              thin = thin,
                              progress.bar = 'none')

  return(list(adapt = adapt, mcmc = mcmc))
}



run_samples <- function(adapt, n.iter, var.names) {
  adapt$recompile()
  mcmc <- rjags::coda.samples(adapt, n.iter = n.iter, variable.names = var.names,
                              progress.bar = 'none')
  return(list(adapt = adapt, mcmc = mcmc))
}
