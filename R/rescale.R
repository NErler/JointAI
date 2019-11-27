
rescale <- function(x, fixed2, scale_pars, MCMC, refs, coef_lvl, coefs) {
  coefs <- if (inherits(coefs, 'list'))
    melt_data.frame_list(coefs, id.vars = colnames(coefs[[1]])) else coefs

  x_data <- if(x %in% coefs[, 'JAGS']) {
    coefs[na.omit(match(x, coefs[, "JAGS"])), "data"]
  } else x

  x_split <- unlist(strsplit(x_data, ":"))

  if (!any(x_split %in% coefs[, 'JAGS']))
    return(MCMC[, x])

  coef_lvl <- unlist(coef_lvl[[coefs[na.omit(match(x, coefs[, 'JAGS'])), "L1"]]])

  coef_split <- sapply(coef_lvl, splitstring2, x = x_data, x_split = x_split, simplify = FALSE)
  names(coef_split) <- coef_lvl



  pars <- sapply(coef_split, function(i) {
    all(x_split %in% i) | x_data %in% i
  })
  if (x_data == "(Intercept)") pars <- !pars
  if (!any(pars)) return(MCMC[, x])

  interact <- names(pars[names(pars) != x_data & pars])

  vec <- MCMC[, x, drop = FALSE]

  interactions <- sapply(interact, function(i) {
    other <- coef_split[[i]][coef_split[[i]] != x_data]
    split_coef <- unlist(strsplit(coef_split[[i]], ":"))
    as.numeric(MCMC[ , i]) / prod(scale_pars["scale", split_coef]) *
      prod(scale_pars["center", other]) * (-1)^(length(other) + 1)
  })

  inter_sum <- if (!is.null(dim(interactions))) {
    rowSums(interactions)
  } else {
    0
  }

  new_vec <- vec / prod(scale_pars["scale", unlist(strsplit(x_data, ":"))]) - inter_sum
  new_vec
}


splitstring = function(input, pattern) {
  splitres = strsplit(input, pattern)[[1]]

  T1 <- splitres[1] == "" | substr(splitres[1],
                                   start = nchar(splitres[1]),
                                   stop = nchar(splitres[1])) == ":"
  T2 <- T
  if (length(splitres) > 1) {
    T2 <-  splitres[2] == "" | substr(splitres[2], start = 1, stop = 1) == ":"
  }
  if (T1 & T2) {
    res <- unlist(c(pattern, strsplit(splitres, ":")))
    res <- res[which(res != "")]
  } else {
    res <- unlist(strsplit(input, ":"))
  }
  return(res)
}



splitstring2 <- function(input, x, x_split) {
  if (length(x_split) > 1) {
    split_input <- unlist(strsplit(input, ":"))
    if (all(x_split %in% split_input)) {
      splitmatch <- split_input %in% x_split
      input <- paste0(c(split_input[splitmatch], split_input[!splitmatch]), collapse = ":")
    }
  }
  splitres <- strsplit(input, x, fixed = TRUE)[[1]]


  T1 <- splitres[1] == "" | substr(splitres[1],
                                   start = nchar(splitres[1]),
                                   stop = nchar(splitres[1])) == ":"
  T2 <- T
  if (length(splitres) > 1) {
    T2 <-  splitres[2] == "" | substr(splitres[2], start = 1, stop = 1) == ":"
  }
  if (T1 & T2) {
    res <- unlist(c(x, strsplit(splitres, ":")))
    res <- res[which(res != "")]
  } else {
    res <- unlist(strsplit(input, ":"))
  }
  return(res)
}
