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
#' @param bin integer giving the number of binary variables or a character
#'            vector containing their names
#' @param multi integer giving the number of multinomial variables or a
#'              character vector containing their names
#' @param ord integer giving the number of ordinal variables or a character
#'            vector containing their names
#' @param count integer giving the number of count variables or a character
#'              vector containing their names
#' @param longnorm integer giving the number of longitudinal
#'                 (normally distributed)
#'        variables or a character vector containing their names
#' @param longbin integer giving the number of longitudinal binary
#'        variables or a character vector containing their names
#' @param longord integer giving the number of longitudinal ordered factors
#'         or a character vector containing their names
#' @param longcount integer giving the number of longitudinal count variables
#'         or a character vector containing their names
#' @param coef vector of parameters used to create the outcome (optional), if
#'        NULL, the parameters are drawn from a normal distribution
#' @param misvar vector of variable names or positions to
#'        specify which variables are incomplete
#' @param nmisvar integer specifying the total number of incomplete variables,
#'        necessary when misvar is NULL and incomplete variables are chosen
#'        randomly
#' @param seed optional seed value
#'
#' @details The time variable has a uniform distribution between tmin and tmax.
#'          At the moment only the integer option is implemented for the
#'          parameters norm, bin, multi, etc.
#' @export
#' @keywords internal
sim_data <- function(N = 100, Jmin = 1, Jmax = 6, tmin = 0, tmax = 5,
                     norm = 2, bin = 2, multi = 2, ord = 2, count = 2,
                     longnorm = 2, longbin = 2, longord = 2, longcount = 2,
                     coef = NULL, misvar = NULL, nmisvar = 7,
                     seed = NULL) {

  oldseed <- .Random.seed
  on.exit({
    .Random.seed <<- oldseed
  })

  if (!is.null(seed)) {
    set_seed(seed)
  }

  # time-constant covariates --------------------------------------------------
  if (length(norm) > 0) {
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

  if (length(bin) > 0) {
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
  if (length(multi) > 0) {
    if (is.character(multi)) {
      multi.names <- multi
      n.multi <- length(multi.names)
    }
    if (length(multi) == 1 & is.numeric(multi)) {
      n.multi <- multi
      multi.names <- paste0("Xmulti", 1:n.multi)
    }
    ncat.multi <- sample(3:5, n.multi, replace = TRUE)
    DF.multi <- sapply(1:n.multi,
                       function(i) factor(sample.int(ncat.multi[i],
                                                     N, replace = TRUE)))
    colnames(DF.multi) <- multi.names
  }

  if (length(ord) > 0) {
    if (is.character(ord)) {
      ord.names <- ord
      n.ord <- length(ord.names)
    }
    if (length(ord) == 1 & is.numeric(ord)) {
      n.ord <- ord
      ord.names <- paste0("Xord", 1:n.ord)
    }
    ncat.ord <- sample(3:5, n.ord, replace = TRUE)
    DF.ord <- sapply(1:n.ord,
                     function(i) factor(sample.int(ncat.ord[i],
                                                   N, replace = TRUE)))
    colnames(DF.ord) <- ord.names
  }

  if (length(count) > 0) {
    if (is.character(count)) {
      count.names <- count
      n.count <- length(count.names)
    }
    if (length(count) == 1 & is.numeric(count)) {
      n.count <- count
      count.names <- paste0("Xcount", 1:n.count)
    }
    lambda.count <- runif(n.count, 0.5, 5)
    DF.count <- sapply(1:n.count, function(i)
      rpois(N, lambda = lambda.count[i]))
    colnames(DF.count) <- count.names
  }

  DF <- data.frame(DF.norm, DF.bin, DF.multi, DF.ord, DF.count)
  covars <- names(DF)

  # observation times of outcome ---------------------------------------------
  nrep <- sample(Jmin:Jmax, N, replace = TRUE)
  DF <- DF[rep(1:N, times = nrep), ]

  if (is.list(longnorm)) {
    errormsg("Not yet implemented")

  } else {
    if (is.character(longnorm)) {
      longnorm.names <- longnorm
      n.longnorm <- length(longnorm.names)
    }
    if (length(longnorm) == 1 & is.numeric(longnorm)) {
      n.longnorm <- longnorm
      longnorm.names <- paste0("Xlnorm", 1:n.longnorm)
    }
    mu.longnorm <- rnorm(n.longnorm)
    sig.longnorm <- rgamma(n.longnorm, 0.8, 2)
    DF.longnorm <- sapply(1:n.longnorm,
                      function(i) rnorm(nrow(DF), mu.longnorm[i],
                                        sig.longnorm[i]))
    colnames(DF.longnorm) <- longnorm.names
  }

  if (is.list(longbin)) {
    errormsg("Not yet implemented")

  } else {
    if (is.character(longbin)) {
      longbin.names <- longbin
      n.longbin <- length(longbin)
    }
    if (length(longbin) == 1 & is.numeric(longbin)) {
      n.longbin <- longbin
      longbin.names <- paste0("Xlbin", 1:n.longbin)
    }
    plongbin <- runif(n.longbin)
    DF.longbin <- sapply(1:n.longbin,
                         function(i) factor(rbinom(nrow(DF), size = 1,
                                                   plongbin[i])))
    colnames(DF.longbin) <- longbin.names
  }

  if (is.list(longord)) {
    errormsg("Not yet implemented")

  } else {
    if (is.character(longord)) {
      longord.names <- longord
      n.longord <- length(longord.names)
    }
    if (length(longord) == 1 & is.numeric(longord)) {
      n.longord <- longord
      longord.names <- paste0("Xlord", 1:n.longord)
    }
    ncat.longord <- sample(3:5, n.longord, replace = TRUE)
    DF.longord <- sapply(1:n.longord,
                     function(i) factor(sample.int(ncat.longord[i],
                                                   nrow(DF), replace = TRUE)))
    colnames(DF.longord) <- longord.names
  }

  if (length(longcount) > 0) {
    if (is.character(longcount)) {
      longcount.names <- longcount
      n.longcount <- length(longcount.names)
    }
    if (length(longcount) == 1 & is.numeric(longcount)) {
      n.longcount <- longcount
      longcount.names <- paste0("Xlcount", 1:n.longcount)
    }
    lambda.longcount <- runif(n.longcount, 0.5, 5)
    DF.longcount <- sapply(1:n.longcount,
                           function(i) rpois(nrow(DF),
                                             lambda = lambda.longcount[i]))
    colnames(DF.longcount) <- longcount.names
  }

  DF <- cbind(DF, DF.longnorm, DF.longbin, DF.longord, DF.longcount)

  DF$id <- rep(1:N, times = nrep)
  DF$time <- unlist(sapply(1:N, function(i) sort(runif(nrep[i], tmin, tmax))))


  # fixed effects -------------------------------------------------------------
  fmla <- as.formula(paste("~", paste(names(DF)[names(DF) != "id"],
                                      collapse = "+")))

  X <- model.matrix(fmla, DF)
  DF[, ord.names] <- lapply(DF[, ord.names], as.ordered)
  DF[, longord.names] <- lapply(DF[, longord.names], as.ordered)

  if (is.null(coef)) {
    coef <- rnorm(ncol(X))
  }

  # random effects ------------------------------------------------------------
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

  misid <- lapply(seq_len(length(misvar)),
                  function(i) sample(unique(DF$id), size = N * misperc[i])
  )

  DF.mis <- DF
  for (i in seq_along(misvar)) {
    if (check_varlevel(DF[, misvar[i]], DF$id) == 'lvlone') {
      DF.mis[sample.int(nrow(DF), nrow(DF) * misperc[i]), misvar[i]] <- NA
    } else {
      DF.mis[DF.mis$id %in% misid[[i]], misvar[i]] <- NA
    }
  }
  return(list(DF = DF, DF.mis = DF.mis))
}

