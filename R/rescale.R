
rescale <- function(x, fixed2, scale_pars, MCMC, refs, X2_names) {
  # if (!x %in% c("(Intercept)", colnames(scale_pars))) {
  #   MCMC[, x]
  # } else {
  coef_lvl <- X2_names

  coefs <- colnames(attr(terms(fixed2), "factors")) # colnames(MCMC)

  # for (i in coefs[coefs %in% names(refs)]) {
  #    lvls <- levels(refs[[i]])[levels(refs[[i]]) != refs[[i]]]
  #    orig <- unname(unlist(sapply(gen_pat(i), grep, coefs, value = T)))
  #    for (j in lvls) {
  #      coef_lvl <- append(coef_lvl, gsub(i, paste0(i, j), orig))
  #    }
  #    coef_lvl <- coef_lvl[which(!coef_lvl %in% orig)]
  # }

  # for (i in seq_along(refs)) {
  #   coef_lvl <- append(coef_lvl, attr(refs[[i]], "dummies"))
  #   coef_lvl <- coef_lvl[-which(coef_lvl == names(refs)[i])]
  # }

  x_split <- unlist(strsplit(x, ":"))

  coef_split <- sapply(coef_lvl, splitstring2, x = x, x_split = x_split, simplify = F)
  names(coef_split) <- coef_lvl



  pars <- sapply(coef_split, function(i) {
    all(x_split %in% i) | x %in% i
  })
  if (x == "(Intercept)") pars <- !pars
  if (!any(pars)) return(MCMC[, x])

  interact <- names(pars[names(pars) != x & pars])

  vec <- MCMC[, x, drop = F]

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

  new_vec <- vec / prod(scale_pars["scale", unlist(strsplit(x, ":"))]) - inter_sum

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
  splitres <- strsplit(input, x, fixed = T)[[1]]


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
