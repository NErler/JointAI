
rescale <- function(x, fixed, scale_pars, MCMC, refs) {
  coefs <- coef_lvl <- colnames(attr(terms(fixed), "factors"))

  for (i in coefs[coefs %in% names(refs)]) {
    lvls <- levels(refs[[i]])[levels(refs[[i]]) != refs[[i]]]
    orig <- unname(unlist(sapply(gen_pat(i), grep, coefs, value = T)))
    for (j in lvls) {
      coef_lvl <- append(coef_lvl, gsub(i, paste0(i, j), orig))
    }
    coef_lvl <- coef_lvl[which(!coef_lvl %in% orig)]
  }

  coef_split <- sapply(coef_lvl, splitstring, pattern = x)
  names(coef_split) <- coef_lvl


  x_split <- unlist(strsplit(x, ":"))

  pars <- sapply(coef_split, function(i) {
    all(x_split %in% i) | x %in% i
  })
  if (x == "(Intercept)") pars <- !pars

  interact <- names(pars[names(pars) != x & pars])

  vec <- MCMC[, x, drop = F]

  interactions <- sapply(interact, function(i) {
    other <- coef_split[[i]][coef_split[[i]] != x]
    split_coef <- unlist(strsplit(coef_split[[i]], ":"))
    MCMC[ , i] / prod(scale_pars["scale", split_coef]) *
      prod(scale_pars["center", other]) * (-1)^(length(other) + 1)
  })

  inter_sum <- if (!is.null(dim(interactions))) {
    rowSums(interactions)
  } else {
    0
  }

  new_vec <- vec / prod(scale_pars["scale", unlist(strsplit(x, ":"))]) - inter_sum

  return(new_vec)
}


splitstring = function(input, pattern){
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

