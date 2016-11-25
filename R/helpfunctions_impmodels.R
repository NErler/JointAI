#' Build linear predictor for imputation models
#' @param varname character string, name of the variable to be imputed
#' @param par_els numeric vector specifying the elements of the vector of
#' regression parameters
#' @param Xc_cols numeric vector specifying the columns in the design matrix Xc
#' @param par_name character string, specifying the name of the regression
#' parameters (e.g. "alpha")
paste_predictor <- function(varname, par_els, Xc_cols, par_name, indent) {
  lb <- c(rep("", 3),
          rep(c(paste0(c("\n", rep(" ", indent)), collapse = ""), rep("", 2)),
              ceiling((length(par_els) - 3)/3))
  )[1:length(par_els)]

  paste0(lb,
         "Xc[i, ", Xc_cols, "] * ", par_name, "[", par_els, "]",
         collapse = " + ")
}


#' Creates a list of parameters that will be passed to the functions generating the imputation models
#' @param impmeth character string specifying the imputation method
#' @param varname name of the variable to be imputed
#' @param Xc design matrix of time-constant covariates
#' @param Xcat matrix of incomplete categorical covariates with more than 2 categories
#' @param K_imp matrix specifying the range of elements of the vector of regression
#' coefficients to be used in each imputation model
#' @param imp_pos list specifying which column(s) of Xc contain(s) the variable
#' to be imputed
#' @export
get_imp_par_list <- function(impmeth, varname, Xc, Xcat, K_imp, dest_cols) {
  list(varname = varname,
       impmeth = impmeth,
       intercept = !impmeth %in% c("ordinal"),
       dest_mat = if (impmeth %in% c("multinomial", "ordinal")) {"Xcat"} else {"Xc"},
       dest_col = if (impmeth %in% c("multinomial", "ordinal")) {
         dest_cols[[varname]]$Xcat
         } else {
           dest_cols[[varname]]$Xc
           },
       par_elmts = K_imp[varname, 1]:K_imp[varname, 2],
       Xc_cols = (1 + (impmeth == "ordinal")):(min(dest_cols[[varname]]$Xc) - 1),
       dummy_cols = if (impmeth %in% c("ordinal", "multinomial")) {
         dest_cols[[varname]]$Xc
       },
       ncat = if (impmeth %in% c("ordinal", "multinomial")) {
         length(dest_cols[[varname]]$Xc) + 1
       },
       refcat = if (impmeth %in% c("ordinal", "multinomial")) {
         1
       },
       par_name = "alpha"
  )
}


#' Find which column in either Xc or Xcat contains the variable to be imputed
#' @param impmeth imputation method
#' @param varname variable name
#' @param Xc_names column names of the design matrix of baseline effects
#' @param Xcat_names column names of the matrix of categorical variables
#' @export
# get_dest_column <- function(meth, varname, Xc, Xcat) {
#   match(varname,
#         if (impmeth %in% c("multinomial", "ordinal")) {
#           colnames(Xcat)
#         } else {
#           colnames(Xc)
#         })
# }
get_dest_column <- function(varname, DF, Xc_names, Xcat_names) {
  list("Xc" = match_positions(varname, DF, Xc_names),
       "Xcat" = match(varname, Xcat_names))
}



#' Write syntax to divide categorical variable into dummy variables in JAGS
#' @param categories numeric vector of categories for which dummy variables
#' need to be created (i.e., excluding the reference category)
#' @param dest_col integer specifying the column in Xcat that contains the categorical variable
#' @param dummy_cols numeric vector specifying the columns in Xc that contain
#' the dummy variables corresponding to the categorical variable
#' @export
paste_dummies <- function(categories, dest_col, dummy_cols, ...){
  sapply(dummy_cols, function(k) {
    paste0("Xc[i, ", k, "] <- ifelse(Xcat[i, ", dest_col, "] == ", match(k, dummy_cols), ", 1, 0)")
  })
  mapply(function(dummy_cols, categories) {
    paste0("Xc[i, ", dummy_cols, "] <- ifelse(Xcat[i, ", dest_col, "] == ", categories, ", 1, 0)")
  }, dummy_cols, categories)
}



#' Call and paste imputation models
#' @param imp_par_list list of parameters
#' @export
paste_imp_model <- function(imp_par_list) {

  imp_model <- switch(imp_par_list$impmeth,
                      norm = impmodel_normal,
                      binary = impmodel_logit,
                      ordinal = impmodel_ordinal)

  do.call(imp_model, imp_par_list)
}

#' Call and paste imputation priors
#' @param imp_par_list list of parameters
#' @export
paste_imp_priors <- function(imp_par_list) {

  imp_model <- switch(imp_par_list$impmeth,
                      norm = impprior_normal,
                      binary = impprior_logit,
                      ordinal = impprior_ordinal)

  do.call(imp_model, imp_par_list)
}
