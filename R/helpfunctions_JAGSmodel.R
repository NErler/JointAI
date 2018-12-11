# build a linear predictor -----------------------------------------------------
paste_predictor <- function(parnam, parindex, matnam, parelmts, cols, indent) {

  lb <- c(rep("", 3),
          rep(c(paste0(c("\n", tab(indent)), collapse = ""), rep("", 2)),
              ceiling((length(parelmts) - 3)/3))
  )[1:length(parelmts)]

  paste0(lb,
         matnam, "[", parindex, ", ", cols, "] * ", parnam, "[", parelmts, "]",
         collapse = " + ")
}


# Help function for indenting lines in model files -----------------------------
tab <- function(times = 2) {
  tb <- " "
  paste(rep(tb, times), collapse = "")
}



# switch for imp_model ---------------------------------------------------------
paste_imp_model <- function(imp_par_list) {
  imp_model <- switch(imp_par_list$impmeth,
                      norm = impmodel_continuous,
                      lognorm = impmodel_continuous,
                      gamma = impmodel_continuous,
                      beta = impmodel_continuous,
                      logit = impmodel_logit,
                      multilogit = impmodel_multilogit,
                      cumlogit = impmodel_cumlogit)
  do.call(imp_model, imp_par_list)
}


# switch for imp_prior ---------------------------------------------------------
paste_imp_priors <- function(imp_par_list) {
  imp_prior <- switch(imp_par_list$impmeth,
                      norm = impprior_continuous,
                      lognorm = impprior_continuous,
                      gamma = impprior_continuous,
                      beta = impprior_continuous,
                      logit = impprior_logit,
                      multilogit = impprior_multilogit,
                      cumlogit = impprior_cumlogit)
  do.call(imp_prior, imp_par_list)
}


# paste dummy variables --------------------------------------------------------
paste_dummies <- function(categories, dest_col, dummy_cols, ...){
  # sapply(dummy_cols, function(k) {
  #   paste0(tab(4), "Xc[i, ", k, "] <- ifelse(Xcat[i, ", dest_col, "] == ",
  #          match(k, dummy_cols), ", 1, 0)")
  # })
  mapply(function(dummy_cols, categories) {
    paste0(tab(4), "Xc[i, ", dummy_cols, "] <- ifelse(Xcat[i, ",
           dest_col, "] == ", categories, ", 1, 0)")
  }, dummy_cols, categories)
}


# paste transformations of continuous imputed variables ------------------------
paste_trafos <- function(dest_col, trafo_cols, trafos, ...) {
  mapply(function(trafo_cols, trafo) {
    paste0(tab(4), "Xc[i, ", trafo_cols, "] <- ", trafo)
  }, trafo_cols = trafo_cols, trafo = trafos)
}


# random effects specifications ------------------------------------------------
ranef_priors <- function(Z){
  paste0(
    tab(), "# Priors for the covariance of the random effects", "\n",
    if (ncol(Z) > 1) {
      paste0(
        tab(), "for (k in 1:", ncol(Z), "){", "\n",
        tab(4), "RinvD[k, k] ~ dgamma(a_diag_RinvD, b_diag_RinvD)", "\n",
        tab(), "}", "\n")
    },
    tab(), "invD[1:", ncol(Z), ", 1:", ncol(Z),"] ~ ", invD_distr(Z), "\n",
    tab(), "D[1:", ncol(Z),", 1:", ncol(Z),"] <- inverse(invD[ , ])"
  )
}


invD_distr <- function(Z){
  if (ncol(Z) == 1) {
    "dgamma(a_diag_RinvD, b_diag_RinvD)"
  } else {
    "dwish(RinvD[ , ], KinvD)"
  }
}



# ------------------------------------------------------------------------------
capitalize <- function(string) {
  capped <- grep("^[^A-Z]*$", string, perl = TRUE)
  substr(string[capped], 1, 1) <- toupper(substr(string[capped],
                                                 1, 1))
  return(string)
}



# Paste interaction terms for JAGS model
paste_interactions <- function(index, mat0, mat1, mat0_col, mat1_col) {
  mat0_skip <- sapply(max(nchar(mat0_col)) - nchar(mat0_col), tab)

  paste0(tab(4),
         paste0(mat0, "[", index, ", ", mat0_skip, mat0_col, "] <- "),
         lapply(mat1_col, function(x){
           paste0(mat1, "[", index, ", ", x, "]", collapse = " * ")
         })
  )
}


paste_long_interactions <- function(index, mat0, mat1, mat0_col, mat1_col) {
  mat0_skip <- sapply(max(nchar(mat0_col)) - nchar(mat0_col), tab)

  out <- paste0(tab(4),
                paste0(mat0, "[", index, ", ", mat0_skip, mat0_col, "] <- "),
                lapply(seq_along(mat1_col), function(i){
                  paste0(mat1[[i]], "[", index, ", ", mat1_col[[i]], "]", collapse = " * ")
                })
  )
  out <- gsub(paste0("Xc[", index, ","),
              paste0("Xc[groups[", index, "],"),
              out, fixed = TRUE)
  out
}
