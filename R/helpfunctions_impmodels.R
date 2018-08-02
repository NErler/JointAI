# Build linear predictor for imputation models
# @param varname character string, name of the variable to be imputed
# @param par_elmts numeric vector specifying the elements of the vector of
# regression parameters
# @param Xc_cols numeric vector specifying the columns in the design matrix Xc
# @param par_name character string, specifying the name of the regression
# parameters (e.g. "alpha")
paste_predictor <- function(varname, par_elmts, Xc_cols, par_name, indent) {
  if (!is.list(par_elmts)) {
    par_elmts <- list(par_elmts)
  }

  lb <- c(rep("", 3),
          rep(c(paste0(c("\n", rep(" ", indent)), collapse = ""), rep("", 2)),
              ceiling((length(par_elmts[[1]]) - 3)/3))
  )[1:length(par_elmts[[1]])]

  lapply(1:length(par_elmts), function(k) {
    paste0(lb,
           "Xc[i, ", Xc_cols, "] * ", par_name, "[", par_elmts[[k]], "]",
           collapse = " + ")
  })
}


# Creates a list of parameters that will be passed to the functions generating the imputation models
# @param impmeth character string specifying the imputation method
# @param varname name of the variable to be imputed
# @param Xc design matrix of time-constant covariates
# @param Xcat matrix of incomplete categorical covariates with more than 2 categories
# @param K_imp matrix specifying the range of elements of the vector of regression
# coefficients to be used in each imputation model
# @param dest_cols column numbers in Xc matrix
# @param refs list of reference values
# @param trafos matrix of transformations
# @export
get_imp_par_list <- function(impmeth, varname, Xc, Xcat, K_imp, dest_cols,
                             refs, trafos) {

  # intercept = ifelse(impmeth %in% c("cumlogit"),
  #                    ifelse(K_imp[varname, "end"] == 1, T, F), T)
  #
  intercept = ifelse(impmeth %in% c("cumlogit"),
                     ifelse(min(dest_cols[[varname]]$Xc) > 2, F, T), T)

  dest_cols[[varname]]$Xc

  list(varname = varname,
       impmeth = impmeth,
       intercept = intercept,
       dest_mat = if (impmeth %in% c("multilogit", "cumlogit")) {
         "Xcat"
       } else if (!is.na(dest_cols[[varname]]$Xtrafo)) {
         "Xtrafo"
       } else {"Xc"},
       dest_col = if (impmeth %in% c("multilogit", "cumlogit")) {
         dest_cols[[varname]]$Xcat
       } else if (!is.na(dest_cols[[varname]]$Xtrafo)) {
         dest_cols[[varname]]$Xtrafo
       } else {
         dest_cols[[varname]]$Xc
       },
       par_elmts = if (impmeth == "multilogit") {
         sapply(names(dest_cols[[varname]]$Xc), function(i) {
           K_imp[i, 1]:K_imp[i, 2]
         }, simplify = FALSE)
       } else {
         K_imp[varname, 1]:K_imp[varname, 2]
       },
       Xc_cols = (1 + (!intercept)):(min(dest_cols[[varname]]$Xc) - 1),
       dummy_cols = if (impmeth %in% c("cumlogit", "multilogit")) {
         dest_cols[[varname]]$Xc
       },
       ncat = if (impmeth %in% c("cumlogit", "multilogit")) {
         length(dest_cols[[varname]]$Xc) + 1
       },
       refcat = if (impmeth %in% c("logit", "cumlogit", "multilogit")) {
         which(refs[[varname]] == levels(refs[[varname]]))
       },
       trafo_cols = if (!is.na(dest_cols[[varname]]$Xtrafo)) {
         dest_cols[[varname]]$Xc
       },
       trfo_fct = if (!is.na(dest_cols[[varname]]$Xtrafo)) {
         apply(trafos[trafos[, "var"] == varname, ], 1, get_trafo,
               dest_col = dest_cols[[varname]]$Xtrafo)
       },
       trafos = trafos,
       par_name = "alpha")
}


get_trafo <- function(trafo_vec, dest_col) {
  if (trafo_vec["type"] == "identity") {
    ret <- paste0("Xtrafo[i, ", dest_col, "]")
  }
  if (trafo_vec["type"] == "log") {
    ret <- paste0("log(Xtrafo[i, ", dest_col, "])")
  }
  if (trafo_vec["type"] == "sqrt") {
    ret <- paste0("sqrt(Xtrafo[i, ", dest_col, "])")
  }
  if (trafo_vec["type"] == "exp") {
    ret <- paste0("exp(Xtrafo[i, ", dest_col, "])")
  }
  if (trafo_vec["type"] == "I") {
    is_power <- regexpr(paste0(trafo_vec["var"], "\\^[[:digit:]]+"),
                        trafo_vec["fct"]) > 0
    if (is_power) {
      pow <- gsub(paste0(trafo_vec["var"], "\\^"), "", trafo_vec["fct"])
      ret <- paste0("pow(Xtrafo[i, ", dest_col, "], ", pow, ")")
    }
  }
  ret
}

# Specify the reference category for a categorical variable
# @param varname name of the variable
# @param Xcat matrix of categorical covariates
# @param refcats character string or named vector of reference categories for
#                each categorical variable
get_refcat <- function(varname, Xcat, refcats, mess = TRUE) {
  if (refcats %in% c("first", "largest")) {
    useval <- refcats
  } else if (refcats[varname] %in% c("first", "largest")) {
    useval <- refcats[varname]
  } else if (is.numeric(refcats[varname])) {
    if (refcats[varname] <= length(levels(Xcat[, varname]))) {
      useval <- refcats[varname]
    } else {
      useval <- "largest"
      if (mess)
        message(gettextf("Wrong specification of the reference category for %s. Default used instead.",
                         dQuote(varname)))

    }
  } else if (is.character(refcats[varname])) {
    useval <- match(refcats[varname], names(Xcat))
    if (is.na(useval)) {
      useval <- "largest"
      if (mess)
        message(gettextf("Wrong specification of the reference category for %s. Default used instead.",
                         dQuote(varname)))
    }
  }

  if (useval == "first") 1
  else if (useval == "largest") which.max(table(Xcat[, varname]))
  else useval
}



# Find which column in either Xc or Xcat contains the variable to be imputed
# @param impmeth imputation method
# @param varname variable name
# @param Xc_names column names of the design matrix of baseline effects
# @param Xcat_names column names of the matrix of categorical variables
get_dest_column <- function(varname, refs, Xc_names, Xcat_names, Xtrafo_names,
                            trafos) {
  nams <- if (varname %in% names(refs)) {
    attr(refs[[varname]], "dummies")
    # paste0(varname,
    #              levels(refs[[varname]])[levels(refs[[varname]]) !=
    #                                        refs[[varname]]])
  } else if (varname %in% trafos$var) {
    trafos$Xc_var[trafos$var == varname]
  } else {
    varname
  }

  list("Xc" = setNames(match(make.names(nams), make.names(Xc_names)), nams),
       "Xcat" = setNames(match(make.names(varname), make.names(Xcat_names)), varname),
       "Xtrafo" = setNames(match(make.names(varname), make.names(Xtrafo_names)), varname))
}



# Write syntax to divide categorical variable into dummy variables in JAGS
# @param categories numeric vector of categories for which dummy variables
# need to be created (i.e., excluding the reference category)
# @param dest_col integer specifying the column in Xcat that contains the categorical variable
# @param dummy_cols numeric vector specifying the columns in Xc that contain
# the dummy variables corresponding to the categorical variable
paste_dummies <- function(categories, dest_col, dummy_cols, ...){
  sapply(dummy_cols, function(k) {
    paste0(tab(), "Xc[i, ", k, "] <- ifelse(Xcat[i, ", dest_col, "] == ",
           match(k, dummy_cols), ", 1, 0)")
  })
  mapply(function(dummy_cols, categories) {
    paste0(tab(), "Xc[i, ", dummy_cols, "] <- ifelse(Xcat[i, ",
           dest_col, "] == ", categories, ", 1, 0)")
  }, dummy_cols, categories)
}


# paste trafo
paste_trafos <- function(dest_col, trafo_cols, trafos,...) {
  mapply(function(trafo_cols, trafo) {
    paste0(tab(), "Xc[i, ", trafo_cols, "] <- ", trafo)
  }, trafo_cols = trafo_cols, trafo = trafos)
}


# Call and paste imputation models
# @param imp_par_list list of parameters
paste_imp_model <- function(imp_par_list) {

  imp_model <- switch(imp_par_list$impmeth,
                      norm = impmodel_normal,
                      lognorm = impmodel_lognorm,
                      gamma = impmodel_gamma,
                      beta = impmodel_beta,
                      logit = impmodel_logit,
                      multilogit = impmodel_multilogit,
                      cumlogit = impmodel_cumlogit)

  do.call(imp_model, imp_par_list)
}

# Call and paste imputation priors
# @param imp_par_list list of parameters
paste_imp_priors <- function(imp_par_list) {

  imp_prior <- switch(imp_par_list$impmeth,
                      norm = impprior_normal,
                      lognorm = impprior_lognorm,
                      gamma = impprior_gamma,
                      beta = impprior_beta,
                      logit = impprior_logit,
                      multilogit = impprior_multilogit,
                      cumlogit = impprior_cumlogit)

  do.call(imp_prior, imp_par_list)
}


# Help function for indenting lines in model files
tab <- function(times = 2) {
  tb <- " "
  paste(rep(tb, times), collapse = "")
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
