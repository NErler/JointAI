# Metropolis-Hasings Algorithm
#
# @param init starting values
# @param iters number of iterations
# @param logPost function specifying the log posterior density to be sampled from
# @param proposal_r function that samples from the proposal distribution
# @param proposal_d function that calculates density of the proposal distribution

MH_algo <- function(init, iters, logPost, proposal_d, proposal_r, ...) {
  chain <- prp <- array(dim = c(iters + 1, length(init)))

  chain[1, ] <- init
  ar <- numeric(iters)

  for (i in 1:iters) {
    prop_val <- c(proposal_r(mean = chain[i, ])) #MASS::mvrnorm(1, mu = chain[i, ], Sigma = prop_var)
    prp[i, ] <- prop_val

    logPost_current <- logPost(b = chain[i, ], ...)
    logPost_proposed <- logPost(b = prop_val, ...)

    p <- exp(logPost_proposed - logPost_current)
    a <- proposal_d(chain[i, ], prop_val) /
      proposal_d(prop_val, chain[i, ])

    A <- min(1, p * a)

    if (runif(1) <= A) {
      chain[i + 1, ] = prop_val
      ar[i] <- 'accept'
    } else {
      chain[i + 1, ] = chain[i, ]
      ar[i] <- 'reject'
    }
  }
  return(list(chain = chain, ar = ar, prp = prp[, -nrow(prp)]))
}
