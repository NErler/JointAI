
rescale <- function(x, fixed2, scale_pars, MCMC, refs, coef_lvl, trafos) {

  coefs <- colnames(attr(terms(fixed2), "factors"))

  x_split <- unlist(strsplit(x, ":"))

  coef_split <- sapply(coef_lvl, splitstring2, x = x, x_split = x_split, simplify = FALSE)
  names(coef_split) <- coef_lvl



  pars <- sapply(coef_split, function(i) {
    all(x_split %in% i) | x %in% i
  })
  if (x == "(Intercept)") pars <- !pars
  if (!any(pars)) return(MCMC[, x])

  interact <- names(pars[names(pars) != x & pars])

  vec <- MCMC[, x, drop = FALSE]

  interactions <- sapply(interact, function(i) {
    other <- coef_split[[i]][coef_split[[i]] != x]
    split_coef <- unlist(strsplit(coef_split[[i]], ":"))
    as.numeric(MCMC[ , i]) / prod(scale_pars["scale", split_coef]) *
      prod(scale_pars["center", other]) * (-1)^(length(other) + 1)
  })

  inter_sum <- if (!is.null(dim(interactions))) {
    rowSums(interactions)
  } else {
    0
  }

  # square <- if (x %in% trafos$var & any(trafos$fct == paste0(x, "^2"))) {
  #   qdr_var <- trafos$X_var[which(trafos$var == x &
  #                                          trafos$fct == paste0(x, "^2"))]
  #   2 * as.numeric(MCMC[ , qdr_var])/scale_pars["scale", x]^2 * scale_pars["center", x]
  # } else {
  #   0
  # }

  new_vec <- vec / prod(scale_pars["scale", unlist(strsplit(x, ":"))]) - inter_sum# - square

  new_vec
  # }
}


splitstring = function(input, pattern){
  # pat <- paste0(c(":", "^"), pattern)
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
  # pat <- paste0(c(":", "^"), pattern)
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
