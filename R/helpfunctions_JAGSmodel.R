# build a linear predictor -----------------------------------------------------
paste_predictor <- function(parnam, parindex, matnam, parelmts, cols, indent) {

  if (length(cols) != length(parelmts)) {
    stop("The size of the design matrix and length of parameter vector do not match!")
  }

  lb <- c(rep("", 3),
          rep(c(paste0(c("\n", tab(indent)), collapse = ""), rep("", 2)),
              ceiling((length(parelmts) - 3)/3))
  )[1:length(parelmts)]

  paste0(lb,
         matnam, "[", parindex, ", ", cols, "] * ", parnam, "[", parelmts, "]",
         collapse = " + ")
}


paste_ranef_predictor <- function(parnam, parindex, matnam, parelmts, cols, indent) {
  if (length(cols) != length(parelmts)) {
    stop("The size of the design matrix and length of parameter vector do not match!")
  }

  lb <- c(rep("", 3),
          rep(c(paste0(c("\n", tab(indent)), collapse = ""), rep("", 2)),
              ceiling((length(parelmts) - 3)/3))
  )[1:length(parelmts)]

  paste0(lb,
         matnam, "[", parindex, ", ", cols, "] * ", parnam, "[groups[", parindex, "], ", parelmts, "]",
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
                      cumlogit = impmodel_cumlogit,
                      clmm = impmodel_clmm,
                      lmm = impmodel_lmm,
                      glmm_logit = impmodel_glmm_logit,
                      glmm_gamma = impmodel_glmm_gamma,
                      glmm_poisson = impmodel_glmm_poisson)
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
                      cumlogit = impprior_cumlogit,
                      clmm = impprior_clmm,
                      lmm = impprior_lmm,
                      glmm_logit = impprior_glmm_logit,
                      glmm_gamma = impprior_glmm_gamma,
                      glmm_poisson = impprior_glmm_poisson)
  do.call(imp_prior, imp_par_list)
}


# paste dummy variables --------------------------------------------------------
paste_dummies <- function(categories, dest_mat, dest_col, dummy_mat, dummy_cols, index, ...){
  mapply(function(dummy_cols, categories) {
    paste0(tab(4), dummy_mat, "[", index, ", ", dummy_cols, "] <- ifelse(", dest_mat,
           "[", index, ", ",
           dest_col, "] == ", categories, ", 1, 0)")
  }, dummy_cols, categories)
}


# paste transformations of continuous imputed variables ------------------------
paste_trafos <- function(dest_col, trafo_cols, trafos, Xmat, index, ...) {
  mapply(function(trafo_cols, trafo) {
    paste0(tab(4), Xmat, "[", index, ", ", trafo_cols, "] <- ", trafo)
  }, trafo_cols = trafo_cols, trafo = trafos)
}


# random effects specifications ------------------------------------------------
ranef_priors <- function(Zcols, varnam = NULL){
  modnam <- if (!is.null(varnam))
    paste0(" for ", varnam)

  if (!is.null(varnam))
    varnam <- paste0("_", varnam)


  paste0("\n",
         tab(), "# Priors for the covariance of the random effects", modnam, "\n",
         if (Zcols > 1) {
           paste0(
             tab(), "for (k in 1:", Zcols, "){", "\n",
             tab(4), "RinvD", varnam, "[k, k] ~ dgamma(shape_diag_RinvD, rate_diag_RinvD)", "\n",
             tab(), "}", "\n")
         },
         tab(), "invD", varnam, "[1:", Zcols, ", 1:", Zcols,"] ~ ", invD_distr(Zcols, varnam), "\n",
         tab(), "D", varnam, "[1:", Zcols,", 1:", Zcols, "] <- inverse(invD", varnam, "[ , ])"
  )
}


invD_distr <- function(Zcols, varnam = NULL){
  if (Zcols == 1) {
    "dgamma(shape_diag_RinvD, rate_diag_RinvD)"
  } else {
    paste0("dwish(RinvD", varnam, "[ , ], KinvD", varnam, ")")
  }
}

paste_rdslopes <- function(nranef, hc_list, K){
  if (nranef > 1) {
    rd_slopes <- list()
    for (k in 2:nranef) {
      beta_start <- K[names(hc_list)[k - 1], 1]
      beta_end <- K[names(hc_list)[k - 1], 2]

      if (any(sapply(hc_list[[k - 1]], attr, "matrix") %in% c("Xc", 'Z')) & !is.na(beta_start)) {
        vec <- sapply(hc_list[[k - 1]], attr, "matrix")

        Xc_pos <- lapply(seq_along(vec), function(i) {
          switch(vec[i], 'Xc' = attr(hc_list[[k - 1]][[i]], 'column'),
                 'Z' = NA,
                 'Xlong' = NULL)
        })

        hc_interact <- paste0("beta[", beta_start:beta_end, "]",
                              sapply(unlist(Xc_pos), function(x) {
                                if (!is.na(x)) {
                                  paste0(" * Xc[i, ", x, "]")
                                } else {
                                  ""
                                }
                              })
        )
      } else {
        hc_interact <- "0"
      }
      rd_slopes[[k - 1]] <- paste0(tab(4), "mu_b[i, ", k,"] <- ",
                                   paste0(hc_interact, sep = "", collapse = " + "))
    }
    paste(rd_slopes, collapse = "\n")
  }
}


# ------------------------------------------------------------------------------
capitalize <- function(string) {
  capped <- grep("^[^A-Z]*$", string, perl = TRUE)
  substr(string[capped], 1, 1) <- toupper(substr(string[capped],
                                                 1, 1))
  return(string)
}



# interaction terms ------------------------------------------------------------
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





paste_regcoef_prior <- function(K_list, distr, coefnam) {
  paste0(c(
    apply(K_list[which(rownames(K_list) == 'uni'), , drop = FALSE], 1, function(x) {
      paste0(tab(), "for (k in ", x['start'], ":", x['end'], ") {", "\n",
             distr,
             tab(), "}", "\n"
      )
    }),

    apply(K_list[which(rownames(K_list) != 'uni'), , drop = FALSE], 1, function(x) {
      paste0(tab(), coefnam, "[", x['start'], ":", x['end'], "] ~ dmnorm(priorMean_",
             x["varname"], ", tau_", coefnam, "_", x["varname"], " * priorTau_",
             x["varname"], ")", "\n",
             tab(), "tau_", coefnam, "_", x["varname"], " ~ dgamma(1, 0.005)", "\n")
    })
  ), collapse = '')
}
