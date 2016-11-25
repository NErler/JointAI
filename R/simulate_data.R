#' Simulate dataset
#'
#' @param N sample size (integer)
#' @param Jmin minimum number of repeated measurements in longitudinal variable
#' @param Jmax maximum number of repeated measurements in longitudinal variable
#' @param tmin minimum of time variable
#' @param tmax maximum of time variable
#' @param norm integer giving the number of normally distributed variables to
#'        create or list of parameters to create normally distributed variables
#'        from. If norm is an integer, the mean and standard deviation are
#'        drawn from distributions.
#' @param bin integer giving the number of binary variables or list
#' @param multi integer giving the number of multinomial variables or list
#' @param ord integer giving the number of ordinal variables or list
#' @param count integer giving the number of ordinal variables or list (not yet used)
#' @param long integer giving the number of longitudinal (normally distributed)
#'        varaibles or list containing parameters
#' @param coef vector of parameters used to create the outcome (optional), if
#'        NULL, the parameters are drawn from a normal distribution
#' @param misvar vector of variable names or positions (??? check this) to
#'        specify which variables are incomplete
#' @param nmisvar integer specifying the total number of incomplete variables,
#'        necessary when misvar is NULL and incomplete variables are chosen
#'        randomly
#' @param format "long" or "wide" ("wide" not yet implemented)
#'
#' @details The time variable has a uniform distribution between tmin and tmax.
#'          At the moment only the integer option is implemented for the
#'          parameters norm, bin, multi, etc.
#' @export
sim_data <- function(N = 100, Jmin = 1, Jmax = 6, tmin = 0, tmax = 5,
                     norm = 2, bin = 2, multi = 2, ord = 2, count = NULL,
                     long = 2,
                     coef = NULL, misvar = NULL, nmisvar = 7,
                     format = "long") {

  # time-constant covariates
  if (is.list(norm)) {
    stop("Not yet implemented")
  } else {
    if (is.character(norm)) {
      norm.names <- norm
      n.norm <- length(norm.names)
    }
    if (length(norm) == 1 & is.numeric(norm)) {
      n.norm <- norm
      norm.names <- paste0("Xnorm", 1:n.norm)
    }
    mu <- rnorm(n.norm)
    sig <- rgamma(n.norm, 0.8, 2)
    DF.norm <- sapply(1:n.norm, function(i) rnorm(N, mu[i], sig[i]))
    colnames(DF.norm) <- norm.names
  }

  if (is.list(bin)) {
    stop("Not yet implemented")
  } else {
    if (is.character(bin)) {
      bin.names <- bin
      n.bin <- length(bin)
    }
    if (length(bin) == 1 & is.numeric(bin)) {
      n.bin <- bin
      bin.names <- paste0("Xbin", 1:n.bin)
    }
    pbin <- runif(n.bin)
    DF.bin <- sapply(1:n.bin, function(i) factor(rbinom(N, size = 1, pbin[i])))
    colnames(DF.bin) <- bin.names
  }
  if (is.list(multi)) {
    stop("Not yet implemented")
  } else {
    if (is.character(multi)) {
      multi.names <- multi
      n.multi <- length(multi.names)
    }
    if (length(multi) == 1 & is.numeric(multi)) {
      n.multi <- multi
      multi.names <- paste0("Xmulti", 1:n.multi)
    }
    ncat.multi <- sample(3:5, n.multi, replace = T)
    DF.multi <- sapply(1:n.multi,
                       function(i) factor(sample.int(ncat.multi[i],
                                                     N, replace = T)))
    colnames(DF.multi) <- multi.names
  }

  if (is.list(ord)) {
    stop("Not yet implemented")
  } else {
    if (is.character(ord)) {
      ord.names <- ord
      n.ord <- length(ord.names)
    }
    if (length(ord) == 1 & is.numeric(ord)) {
      n.ord <- ord
      ord.names <- paste0("Xord", 1:n.ord)
    }
    ncat.ord <- sample(3:5, n.ord, replace = T)
    DF.ord <- sapply(1:n.ord,
                     function(i) factor(sample.int(ncat.multi[i],
                                                   N, replace = T)))
    colnames(DF.ord) <- ord.names
  }

  DF <- data.frame(DF.norm, DF.bin, DF.multi, DF.ord)
  covars <- names(DF)

  # observation times of outcome
  nrep <- sample(Jmin:Jmax, N, replace = T)
  DF <- DF[rep(1:N, times = nrep), ]

  if (is.list(long)) {
    stop("Not yet implemented")
  } else {
    if (is.character(long)) {
      long.names <- long
      n.long <- length(long.names)
    }
    if (length(long) == 1 & is.numeric(long)) {
      n.long <- long
      long.names <- paste0("Xl", 1:n.long)
    }
    mu.long <- rnorm(n.long)
    sig.long <- rgamma(n.long, 0.8, 2)
    DF.long <- sapply(1:n.long,
                      function(i) rnorm(nrow(DF), mu.long[i], sig.long[i]))
    colnames(DF.long) <- long.names
  }

  DF <- cbind(DF, DF.long)

  DF$id <- rep(1:N, times = nrep)
  DF$time <- unlist(sapply(1:N, function(i) sort(runif(nrep[i], tmin, tmax))))


  # fixed effects
  fmla <- as.formula(paste("~", paste(names(DF)[names(DF) != "id"],
                                      collapse = "+")))

  X <- model.matrix(fmla, DF)
  DF[, ord.names] <- lapply(DF[, ord.names], as.ordered)

  if (is.null(coef)) {
    coef <- rnorm(ncol(X))
  }

  # random effects
  D <- rWishart(1, df = 2, Sigma = diag(rep(0.1, 2)))[, , 1]
  b <- MASS::mvrnorm(N, c(0,0), Sigma = D)
  Z <- model.matrix(~time, DF)

  # outcome
  DF$y <- as.numeric(X %*% coef + rowSums(Z * b[match(DF$id, unique(DF$id))]) +
                       rnorm(nrow(DF), 0, 0.5))


  if (is.null(misvar)) {
    misvar <- sample(covars, nmisvar)
  }
  misperc <- runif(n = length(misvar), max = 0.5)

  misid <- lapply(1:length(misvar),
                  function(i) sample(unique(DF$id), size = N * misperc[i])
  )

  DF.mis <- DF
  for (i in 1:length(misvar)) {
    if (check_tvar(DF[, misvar[i]], "id")) {
      DF.mis[sample.int(nrow(DF), nrow(DF) * misperc[i]), misvar[i]] <- NA
    } else {
      DF.mis[DF.mis$id %in% misid[[i]], misvar[i]] <- NA
    }
  }
  return(DF.mis)
}

