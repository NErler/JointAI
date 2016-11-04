lme_imp <- function(fixed, data, random, auxvars = NULL){
  this_call <- as.list(match.call())

  if (is.null(this_call$fixed)) {
    stop("No fixed effects structure specified.")
  }
  if (is.null(this_call$random)) {
    stop("No random effects structure specified.")
  }
  if (is.null(this_call$data)) {
    stop("No data given.")
  }

  meth <- get_imp_meth(DF, fixed, random, auxvars)
  Mlist <- divide_matrices(DF, fixed, random, auxvars)
  K <- get_model_dim(sapply(Mlist, ncol), Mlist$time_hc)
  imp_pos <- get_imp_pos(meth, DF, Mlist)
  K_imp <- get_imp_dim(meth, imp_pos$pos_Xc)

  return(list(meth = meth,
              Mlist = Mlist,
              K = K,
              imp_pos = imp_pos,
              K_imp = K_imp))
}

