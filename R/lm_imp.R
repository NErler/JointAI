#' Main function for analysis with a linear model
#' @param fixed a two sided formula describing the fixed-effects part of the
#' model (see \code{\link[stats]{formula}})
#' @param data a data frame containing the variabels named in \code{fixed}
#' @param auxvars an optional vector of variable names that shoud be included
#'                as predictors in the imputation procedure but are not part of
#'                the analysis model
#' @param refcats a named vector specifying which category should be treated as
#'                as reference category for each categorical variable, "first"
#'                or "largest" (default). When \code{refcat = "largest"}, the
#'                category with the most observations is chosen for each
#'                categorical variable.
#' @param modelfile optional name (and path) of the file the JAGS model will be
#'                  written to
#' @param n.chains number of mcmc chains
#' @param n.adapt number of iterations in adaptive phase
#' @param n.iter number of iterations in sampling
#' @param runJAGS logical
#' @export
lm_imp <- function(fixed, data, auxvars = NULL,
                   refcats = "largest", modelfile = NULL,
                   n.chains = 3, n.adapt = 100, n.iter = 0, runJAGS = F){
  this_call <- match.call()

  if (is.null(fixed)) {
    stop("\nNo fixed effects structure specified.")
  }

  if (is.null(modelfile)) {
    modelfile <- paste0("FitAI_JAGSmodel_",
                        format(Sys.time(), "%Y-%m-%d_%H-%M"), ".txt")
  }

  meth <- get_imp_meth(data, fixed, auxvars)

  Mlist <- divide_matrices(data, fixed, auxvars)
  K <- get_model_dim(sapply(Mlist, ncol), Mlist$hc_list)

  imp_pos <- get_imp_pos(meth, data, Mlist)
  K_imp <- get_imp_dim(meth, imp_pos$pos_Xc)

  dest_cols <- sapply(names(meth), get_dest_column, data, colnames(Mlist$Xc),
                      colnames(Mlist$Xcat), simplify = F)

  imp_par_list <- mapply(get_imp_par_list, meth, names(meth),
                         MoreArgs = list(Mlist$Xc, Mlist$Xcat, K_imp, dest_cols,
                                         refcats),
                         SIMPLIFY = F)


  write_model(type = "lm", meth = meth, Ntot = nrow(Mlist$y),
              N = nrow(Mlist$Xc),
              y_name = names(Mlist$y), Mlist = Mlist, K = K,
              imp_par_list = imp_par_list,
              file = modelfile)

  data_list <- get_data_list(type = "lm", meth, Mlist)
  if (runJAGS) {
    adapt <- jags.model(file = modelfile, data = data_list, inits = NULL,
                        n.chains = n.chains, n.adapt = n.adapt)
    mcmc <- if (n.iter > 0) {
      coda.samples(adapt, n.iter = n.iter,
                   variable.names = get_params(meth, type = "lme",
                                               y_name = colnames(Mlist$y),
                                               Zcols = ncol(Mlist$Z),
                                               betas = T, tau_y = T, D = T,
                                               Xc = Mlist$Xc, Xcat = Mlist$Xcat),
                   na.rm = F)
    }
  }

  return(list(this_call, data_list = data_list, sample = if (runJAGS) {mcmc}))
}
