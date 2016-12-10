#' Main function for analysis with a linear mixed model
#' @param fixed a two sided formula describing the fixed-effects part of the
#' model (see \code{\link[stats]{formula}})
#' @param data a data frame containing the variabels named in \code{fixed} and
#'             \code{random}
#' @param random a one sided formula of the form "\code{ ~ x | id}", where
#'               \code{x} is the variable that has a random effect and \code{id}
#'               is the variable specifying the grouping structure.
#' @param auxvars an optional vector of variable names that shoud be included
#'                as predictors in the imputation procedure but are not part of
#'                the analysis model
#' @param refcats a named vector specifying which category should be treated as
#'                as reference category for each categorical variable, "first"
#'                or "largest" (default). When \code{refcat = "largest"}, the
#'                category with the most observations is chosen for each
#'                categorical variable.
#' @param monitor_params a character vector giving the names of variables to be monitored, see details
#' @param modelfile optional name (and path) of the file the JAGS model will be
#'                  written to
#' @inheritParams rjags::jags.model
#' @inheritParams rjags::coda.samples
#' @param runJAGS logical
#' @inheritParams base::scale
#' @export
lme_imp <- function(fixed, data, random, auxvars = NULL,
                    refcats = "largest",
                    monitor_params = NULL, modelfile = NULL, n.chains = 3,
                    n.adapt = 100, n.iter = 100, runJAGS = FALSE, center = T,
                    scale = T){
  this_call <- match.call()

  if (is.null(fixed)) {
    stop("\nNo fixed effects structure specified.")
  }

  if (is.null(random)) {
    stop("\nNo random effects structure specified.")
  }

  if (is.null(modelfile)) {
    modelfile <- paste0("FitAI_JAGSmodel_",
                        format(Sys.time(), "%Y-%m-%d_%H-%M"), ".R")
  }

  meth <- get_imp_meth(data, fixed, random, auxvars)

  Mlist <- divide_matrices(data, fixed, random, auxvars)
  K <- get_model_dim(sapply(Mlist, ncol), Mlist$hc_list)

  imp_pos <- get_imp_pos(meth, data, Mlist)
  K_imp <- get_imp_dim(meth, imp_pos$pos_Xc)

  dest_cols <- sapply(names(meth), get_dest_column, data, colnames(Mlist$Xc),
                      colnames(Mlist$Xcat), simplify = F)

  imp_par_list <- mapply(get_imp_par_list, meth, names(meth),
                         MoreArgs = list(Mlist$Xc, Mlist$Xcat, K_imp, dest_cols,
                                         refcats, center, scale),
                         SIMPLIFY = F)


  write_model(type = "lme", meth = meth, Ntot = nrow(Mlist$y),
              N = nrow(Mlist$Xc),
              y_name = names(Mlist$y), Mlist = Mlist, K = K,
              imp_par_list = imp_par_list,
              file = modelfile)

  data_list <- get_data_list(type = "lme", meth, Mlist, center, scale)

  if (runJAGS) {
    adapt <- rjags::jags.model(file = modelfile, data = data_list, inits = NULL,
                        n.chains = n.chains, n.adapt = n.adapt)

    mcmc <- if (n.iter > 0) {
      if (is.null(monitor_params)) {
        monitor_params <- c("analysis_main" = T)
      }
      var.names <- do.call(get_params, c(list(meth = meth, analysis_type = "lme",
                                            y_name = colnames(Mlist$y),
                                            Zcols = ncol(Mlist$Z),
                                            Xc = Mlist$Xc, Xcat = Mlist$Xcat),
                                            monitor_params))
      print(var.names)

      rjags::coda.samples(adapt, n.iter = n.iter,
                   variable.names = var.names,
                   na.rm = F)
    }
  }

  return(list(call = this_call, data_list = data_list, sample = if (runJAGS) {mcmc}))
}

