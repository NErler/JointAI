#' Imputation by cumulative logistic regression
#' @param varname name of the variable to be imputed
#' @param dest_col column of Xc containing the variable to be imputed
#' @param Xc_cols columns of the design matrix to used in linear predictor
#' @param par_elmts elements of the parameter vector to be used
#' @param par_name name of the parameter
#' @export
impmodel_ordinal <- function(varname, dest_col, Xc_cols, par_elmts, par_name, dummy_cols, ncat, refcat, ...){

  if (length(Xc_cols) != length(par_elmts)) {
    stop("The size of the design matrix and length of parameter vector don't match!")
  }

  indent <- nchar(varname) + 11
  predictor <- paste_predictor(varname, par_elmts, Xc_cols, par_name, indent)


  probs <- sapply(2:(ncat - 1), function(k){
    paste0("p.", varname, "[i, ", k, "] <- max(1e-6, min(0.999999, psum.",
           varname, "[i, ", k,"] - psum.", varname, "[i, ", k - 1, "]))")})

  logits <- sapply(1:(ncat - 1), function(k) {
    paste0("logit(psum.", varname, "[i, ", k, "])  <- gamma.", varname,
           "[", k, "]", " + eta.", varname,"[i]")
  })

  dummies <- paste_dummies(c(1:ncat)[-refcat], dest_col, dummy_cols)

  paste0("# ordinal imputation for ", varname, "\n",
         "Xcat[i, ", dest_col, "] ~ dcat(p.", varname, "[i, 1:", ncat, "])", "\n",
         "eta.", varname,"[i] <- ", predictor, "\n\n",
         "p.", varname, "[i, 1] <- max(1e-6, min(0.999999, psum.", varname, "[i, 1]))", "\n",
         paste(probs, collapse = "\n"), "\n",
         "p.", varname, "[i, ", ncat, "] <- 1 - max(1e-6, min(0.999999, sum(p.",
         varname, "[i, 1:", ncat - 1,"])))", "\n\n",
         paste0(logits, collapse = "\n"), "\n\n",
         paste0(dummies, collapse = "\n"), "\n\n")
}



#' Priors for ordinal imputation model
#' @param varname name of the variable to be imputed
#' @param par_elmts elements of the parameter vector to be used
#' @param par_name name of the parameter
#' @export
impprior_ordinal <- function(varname, par_elmts, par_name, ncat, ...){
  deltas <- sapply(1:(ncat - 1), function(k) {
    paste0("delta.", varname, "[", k, "] ~ dnorm(0, 1e-3)")
  })

  gammas <- sapply(1:ncat, function(k) {
    if (k == 1) {
      paste0("gamma.", varname, "[", k, "] ~ dnorm(0, 1e-3)")
    } else {
      paste0("gamma.", varname, "[", k, "] <- gamma.", varname, "[", k - 1, "] + exp(delta.", varname, "[", k, "])")
    }
  })

  paste0("# Priors for ", varname, "\n",
         "for(k in ", min(par_elmts), ":", max(par_elmts), "){", "\n",
         "  ", par_name, "[k] ~ dnorm(0, 4/9)", "\n",
         "}", "\n\n",
         paste(deltas, collapse = "\n"), "\n\n",
         paste(gammas, collapse = "\n"), "\n\n")
}