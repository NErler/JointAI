# Metropolis-Hasings Algorithm
#
# @param init starting values
# @param iters number of iterations
# @param logPost function specifying the log posterior density to be sampled from
# @param proposal_r function that samples from the proposal distribution
# @param proposal_d function that calculates density of the proposal distribution

MH_algo <- function(init, iters, logPost, proposal_d, proposal_r, ...) {
  sample <- prp <- array(dim = c(iters + 1, length(init)))

  sample[1, ] <- init
  ar <- numeric(iters)

  for (i in 1:iters) {
    prop_val <- c(proposal_r(mean = sample[i, ])) #MASS::mvrnorm(1, mu = sample[i, ], Sigma = prop_var)
    prp[i, ] <- prop_val

    logPost_current <- logPost(b = sample[i, ], ...)
    logPost_proposed <- logPost(b = prop_val, ...)

    p <- exp(logPost_proposed - logPost_current)
    a <- proposal_d(sample[i, ], prop_val) /
      proposal_d(prop_val, sample[i, ])

    A <- min(1, p * a)

    if (runif(1) <= A) {
      sample[i + 1, ] = prop_val
      ar[i] <- 'accept'
    } else {
      sample[i + 1, ] = sample[i, ]
      ar[i] <- 'reject'
    }
  }
  return(list(sample = sample, acceptance = ar,
              proposed = prp[-nrow(prp), , drop = FALSE]))
}




# log density for random effects in LMM
logPost_b <- function(y, Xc, Xic, Xl, Xil, Z, beta, sig_y, b, D, hc_beta, ...) {
  part1 <- sum(-0.5 * (y -
                         Z %*% b -
                         Xl %*% beta[, colnames(Xl)] -
                         Xil %*% beta[, colnames(Xil)])^2 / sig_y^2)

  mu_b <- c(Xc %*% beta[, colnames(Xc)] + Xic %*% beta[, colnames(Xic)],
            sapply(seq_along(hc_beta), function(kk) {
              Xc[, na.omit(hc_beta[[kk]]), drop = FALSE] %*% beta[, names(hc_beta[[kk]])]
            })
  )
  part2 <- - 0.5 * (b - mu_b) %*% solve(D) %*% (b - mu_b)
  sum(part1, part2)
}


ranef_sample <- function(object, newdata, subset = object$monitor_params,
                         start = NULL, end = NULL, thin = NULL, exclue_chains = NULL,
                         warn = TRUE, mess = TRUE, n.iter = 1, adj = 1, ...) {
  # extract id variable
  idvar <- extract_id(object$random)

  # extract the outcome and design matrices
  y <- newdata[, colnames(object$Mlist$y)]

  op <- options(na.action = 'na.pass', contrasts = rep("contr.treatment", 2)) # change option to keep missing values

  mfZ <- model.frame(remove_grouping(object$random), object$data)
  mtZ <- attr(mfZ, "terms")
  Z <- model.matrix(mtZ, data = newdata)

  mfX <- model.frame(object$fixed, object$data)
  mtX <- attr(mfX, "terms")
  X <- model.matrix(mtX, data = newdata, na.action = na.pass)

  options(op)

  Xc <- X[match(unique(newdata[, idvar]), newdata[, idvar]),
          object$Mlist$names_main$Xc, drop = FALSE]

  Xic <- X[match(unique(newdata[, idvar]), newdata[, idvar]),
           object$Mlist$names_main$Xic, drop = FALSE]

  Xl <- X[, object$Mlist$names_main$Xl, drop = FALSE]
  Xil <- X[, object$Mlist$names_main$Xil, drop = FALSE]


  # get MCMC sample from object
  MCMC <- prep_MCMC(object, start = start, end = end, thin = thin,
                    subset = subset,
                    exclude_chains = exclude_chains, warn = warn, mess = mess)

  # extract MCMC samples of the D matrix
  Ds <- grep("^D\\[[[:digit:]]*,[[:digit:]]*\\]", colnames(MCMC), value = TRUE)
  Dpos <- t(sapply(strsplit(gsub('D|\\[|\\]', '', Ds), ","), as.numeric))
  Darr <- array(dim = c(max(Dpos), max(Dpos), nrow(MCMC)))

  for (k in seq_along(Ds)) {
    Darr[Dpos[k, 1], Dpos[k, 2], ] <- MCMC[, Ds[k]]
    Darr[Dpos[k, 2], Dpos[k, 1], ] <- MCMC[, Ds[k]]
  }

  # extract sigma
  sig <- try(MCMC[, paste0("sigma_", colnames(object$Mlist$y))])

  # extract beta
  beta <- MCMC[, colnames(X), drop = FALSE]

  # if (object$analysis_type == 'lme') {
    # empirical Bayes estimate
    invVarr <- vapply(1:nrow(MCMC), function(k)
      chol2inv(Z %*% Darr[, , k] %*% t(Z) + sig[k]^2 * diag(nrow(Z))),
      FUN.VALUE = matrix(nrow = nrow(Z), ncol = nrow(Z), data = 0))

    means <- t(sapply(1:nrow(MCMC), function(k)
      # Darr[, , k] %*% t(Z) %*% invVarr[, , k] %*% (y - X %*% beta[k, ])
      Darr[, , k] %*% t(Z) %*% invVarr[, , k] %*% (y - Xl %*% beta[k, colnames(Xl)] - Xil %*% beta[k, colnames(Xil)])
    ))

    K <- vapply(1:nrow(MCMC), function(k)
      invVarr[, , k] - invVarr[, , k] %*% X %*%
        chol2inv(t(X) %*% invVarr[, , k] %*% X * object$Mlist$N) %*%
        t(X) %*% invVarr[, , k],
      FUN.VALUE = matrix(nrow = nrow(Z), ncol = nrow(Z), data = 0)
    )

    vars <- vapply(1:nrow(MCMC), function(k)
      Darr[, , k] %*% t(Z) %*% K[, , k] %*% Z %*% Darr[, , k],
      FUN.VALUE = matrix(nrow = ncol(Z), ncol = ncol(Z), data = 0)
    )
  # } else {

  # }

  hc_beta <- lapply(mod$Mlist$hc_list,
                    function(k) {
                      unlist(sapply(k, function(j) {
                        if(attr(j, 'matrix') == 'Xc')
                          attr(j, 'column')
                        else if(attr(j, 'matrix') == 'Z')
                          1
                      }))
                    }
  )

  start_points <- optim(par = rep(0, ncol(Z)),
                        fn = logPost_b, y = y, Xc = Xc, Xic = Xic, Xl = Xl, Xil = Xil,
                        beta = beta[1, , drop = FALSE], hc_beta = hc_beta,
                        sig_y = sig[1], D = Darr[, , 1], Z = Z,
                        control = list(fnscale = -1), hessian = T)


  out <- list()
  cat(paste0('Sampling random effects for subject ', unique(newdata[, idvar]), ":", '\n'))
  pb <- txtProgressBar(style = 3, width = getOption("width")/2, char = '*')
  for(k in 1:nrow(MCMC)) {
    setTxtProgressBar(pb, k/nrow(MCMC))
    init <- start_points$par #means[k, ]
    if(k > 1) init <- unlist(out$sample[k - 1, ])

    res <- MH_algo(init = init, iters = n.iter,
                   logPost = function(...)
                     logPost_b(y = y, Xc = Xc, Xic = Xic, Xl = Xl, Xil = Xil,
                               beta = beta[k, , drop = FALSE], hc_beta,
                               sig_y = sig[k], D = Darr[, , k], Z = Z, ...),
                   proposal_d = function(...) mvtnorm::dmvnorm(sigma = Darr[, , k], ...),
                   proposal_r = function(...) mvtnorm::rmvnorm(n = 1, sigma = Darr[, , k], ...))
    # proposal_d = function(...) mvtnorm::dmvnorm(sigma = vars[, , k], ...),
    #                proposal_r = function(...) mvtnorm::rmvnorm(n = 1, sigma = vars[, , k], ...))
                   # proposal_d = function(...) mvtnorm::dmvnorm(sigma = adj * chol2inv(start_points$hessian), ...),
                   # proposal_r = function(...) mvtnorm::rmvnorm(n = 1, sigma = adj * chol2inv(start_points$hessian), ...))

    if (k == 1) {
      out$sample <- as.data.frame(res$sample[nrow(res$sample), , drop = FALSE])
      out$proposed <- as.data.frame(res$proposed)
      out$acceptance <- mean(res$acceptance == 'accept')
    } else {
      out$sample <- rbind(out$sample,
                          res$sample[nrow(res$sample), , drop = FALSE])
      out$proposed <- rbind(out$proposed,
                            res$proposed[nrow(res$proposed), , drop = FALSE])
      out$acceptance <- c(out$acceptance, mean(res$acceptance == 'accept'))
    }
  }
  close(pb)
  names(out$sample) <- names(out$proposed) <- colnames(Z)
  return(out)
}
