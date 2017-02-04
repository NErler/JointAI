#' Joint analysis and imputation
#' @param fixed a two sided formula describing the fixed-effects part of the
#' model (see \code{\link[stats]{formula}})
#' @param data a data frame containing the variabels named in \code{fixed}
#' @inheritParams stats::glm
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
#' @param runMCMC logical
#' @inheritParams base::scale
#' @name model_imp
NULL

model_imp <- function(arglist) {
  cat("Start model_imp", "\n")
  list2env(arglist, sys.frame(sys.nframe()))

  if (!exists("random")) random <- NULL
  if (!exists("family")) family <- NULL

  cat("list2env", "\n")

  # Check if fixed effects formula is specified
  if (is.null(fixed)) {
    stop("\nNo fixed effects structure specified.")
  }

  # generate default name for model file if not specified
  if (is.null(modelfile)) {
    modelfile <- paste0("FitAI_JAGSmodel_",
                        format(Sys.time(), "%Y-%m-%d_%H-%M"), ".txt")
  }

  cat("modelfile", "\n")

  # default imputation methods, if not specified
  if (is.null(meth)) {
    meth <- get_imp_meth(data, fixed, auxvars)
  }

  if (is.null(Mlist)) {
    Mlist <- divide_matrices(data, fixed, random, auxvars,
                             center = center, scale = scale)
  }

  cat("Mlist done", "\n")

  if (is.null(K)) {
    K <- get_model_dim(sapply(Mlist, ncol), Mlist$hc_list)
  }

  cat("K done", "\n")

  if (is.null(imp_pos)) {
    imp_pos <- get_imp_pos(meth, data, Mlist)
  }

  if (is.null(K_imp)) {
    K_imp <- get_imp_dim(meth, imp_pos$pos_Xc)
  }

  if (is.null(dest_cols)) {
    dest_cols <- sapply(names(meth), get_dest_column, data, colnames(Mlist$Xc),
                        colnames(Mlist$Xcat), simplify = F)
  }

  cat("dest_cols done", "\n")

  if (is.null(imp_par_list)) {
    imp_par_list <- mapply(get_imp_par_list, meth, names(meth),
                           MoreArgs = list(Mlist$Xc, Mlist$Xcat, K_imp, dest_cols,
                                           refcats),
                           SIMPLIFY = F)
  }

  cat("imp_par_list done", "\n")

  write_model(analysis_type = analysis_type, family = family$family,
              link = family$link, meth = meth, Ntot = nrow(Mlist$y),
              N = nrow(Mlist$Xc),
              y_name = names(Mlist$y), Mlist = Mlist, K = K,
              imp_par_list = imp_par_list,
              file = modelfile)
  cat("model written", "\n")

  data_list <- get_data_list(type = analysis_type, meth, Mlist)

  cat("data_list written", "\n")

  if (runMCMC) {
    adapt <- rjags::jags.model(file = modelfile, data = data_list,
                               inits = NULL,
                               n.chains = n.chains, n.adapt = n.adapt)

    if (is.null(monitor_params)) {
      monitor_params <- c("analysis_main" = T)
    }
    var.names <- do.call(get_params, c(list(meth = meth, analysis_type = analysis_type,
                                            y_name = colnames(Mlist$y),
                                            Zcols = ncol(Mlist$Z),
                                            Xc = Mlist$Xc, Xcat = Mlist$Xcat),
                                       monitor_params))

    mcmc <- if (n.iter > 0) {
      rjags::coda.samples(adapt, n.iter = n.iter,
                          variable.names = var.names,
                          na.rm = F)
    }
  }


  mcmc_settings <- list(MCMCpackage = MCMCpackage,
                        modelfile = modelfile,
                        n.chains = n.chains,
                        n.adapt = n.adapt,
                        n.iter = n.iter,
                        variable.names = if (exists("var.names")) var.names,
                        thin = thin)

  return(list(meth = meth, Mlist = Mlist, K = K, K_imp = K_imp,
              mcmc_settings = mcmc_settings,
              data_list = data_list,
              model = adapt,
              sample = if (runMCMC) {mcmc}))
}


#' @rdname model_imp
#' @export
lm_imp <- function(fixed, data, auxvars = NULL,
                   monitor_params = NULL, refcats = "largest", modelfile = NULL,
                   n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1, runMCMC = F,
                   MCMCpackage = "JAGS", center = T, scale = T,
                   meth = NULL, Mlist = NULL, K = NULL, K_imp = NULL,
                   imp_pos = NULL, dest_cols = NULL, imp_par_list = NULL){

  arglist <- mget(names(formals()), sys.frame(sys.nframe()))
  arglist$analysis_type <- "lm"

  res <- model_imp(arglist)
  return(res)
}


#' @rdname model_imp
#' @export
lme_imp <- function(fixed, data, random, auxvars = NULL,
                    monitor_params = NULL, refcats = "largest", modelfile = NULL,
                    n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1, runMCMC = F,
                    MCMCpackage = "JAGS",
                    meth = NULL, Mlist = NULL, K = NULL, K_imp = NULL,
                    imp_pos = NULL, dest_cols = NULL, imp_par_list = NULL){

  arglist <- mget(names(formals()), sys.frame(sys.nframe()))
  arglist$analysis_type <- "lme"

  res <- model_imp(arglist)
  return(res)
}



#' @rdname model_imp
#' @export
glm_imp <- function(fixed, family, data, auxvars = NULL,
                    monitor_params = NULL, refcats = "largest", modelfile = NULL,
                    n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1, runMCMC = F,
                    MCMCpackage = "JAGS", center = F, scale = F,
                    meth = NULL, Mlist = NULL, K = NULL, K_imp = NULL,
                    imp_pos = NULL, dest_cols = NULL, imp_par_list = NULL){

  arglist <- mget(names(formals()), sys.frame(sys.nframe()))

  # if (family$family == "binomial" & family$link == "logit"){
  #   arglist$analysis_type <- "logit"
  # }

  arglist$analysis_type <- "glm"


  res <- model_imp(arglist)
  return(res)
}
