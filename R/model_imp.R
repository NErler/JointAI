#' Joint analysis and imputation
#'
#' \code{lm_imp}, \code{glm_imp} and \code{lme_imp} estimate linear, generalized
#' linear and linear mixed models, respectively, using MCMC sampling.
#'
#' @param fixed a two sided formula describing the fixed-effects part of the
#' model (see \code{\link[stats]{formula}})
#' @param data a data frame containing the variabels named in \code{fixed}
#' @param family only for \code{glm_imp}:
#'               a description of the error distribution and link function to
#'               be used in the model. This can be a character string naming a
#'               family function, a family function or the result of a call to
#'               a family function. (See \code{\link[stats]{family}} and the
#'               `Details` section below.)
#' @param random only for \code{lme_imp}:
#'               a one-sided formula of the form \code{~x1 + ... + xn | g},
#'               where \code{x1 + ... + xn} specifies the model for the random
#'               effects and \code{g} the grouping variable
#' @param n.chains the number of parallel chains for the model
#' @param n.adapt	the number of iterations for adaptation.
#'                See \code{\link[rjags]{adapt}} for details. If n.adapt = 0
#'                then no adaptation takes place.
#' @param n.iter number of iterations to monitor
#' @param thin thinning interval for monitors
#' @param ... additional, optional parameters, see below
#'
#' @section Optional arguments:
#' There are some optional parameters that can be passed to \code{...}
#' \tabular{ll}{
#' \code{auxvars} \tab vector of variable names that shoud be used as
#'                     predictors in the imputation procedure (and will be
#'                     imputed if necessary) but are not part of the analysis
#'                     model\cr
#' \code{refcats} \tab a named list specifying which category should be used as
#'                     reference category for the categorical variables. "first"
#'                or "largest" (default). When \code{refcat = "largest"}, the
#'                category with the most observations is chosen for each
#'                categorical variable.\cr
#' \code{scale_vars} \tab named vector of (continuous) variables that will be
#'                        scaled (so that mean = 0 and sd = 1) to improve
#'                        convergence of the MCMC sampling. Default is that all
#'                        continuous variables will be scaled.\cr
#' \code{monitor_params} \tab a character vector giving the names of variables
#'                            to be monitored, see details\cr
#' \code{model file} \tab optional name (and path) of the file the JAGS model
#'                        will be written to. Needs to be specified including
#'                        the file ending. Possible file endings are \code{.R}
#'                        or {.txt}.\cr
#' \code{overwrite} \tab some explanation\cr
#' }
#'
#' @section Details:
#' Some more details
#'
#' @name model_imp
NULL

model_imp <- function(arglist) {
  list2env(arglist, sys.frame(sys.nframe()))

  if (!"family" %in% names(arglist)) {
    family <- NULL
    link <- NULL
  }

  for (x in c("auxvars", "meth", "random", "monitor_params", "refcats",
              "modelfile", "scale_vars", "scale_pars", "Mlist", "K", "K_imp",
              "imp_pos", "dest_cols", "imp_par_list", "data_list")) {
    if (!x %in% ls()) assign(x, NULL)
  }

  for (x in c("scale_functions", "overwrite")) {
    if (!x %in% ls()) assign(x, FALSE)
  }


  # Checks & warnings -------------------------------------------------------
  if (missing(fixed)) {
    stop("\nNo fixed effects structure specified.")
  }

  if (analysis_type != "lme" & !is.null(random)) {
    warning(paste0("Random effects structure not used in a model of type `",
                   analysis_type, "'."), immediate. = T, call. = F)
    random <- NULL
  }

  if (n.iter == 0) {
    message(paste0("Note: No MCMC sample will be created when n.iter is set to ",
                   n.iter, "."))
  }


  # generate default name for model file if not specified
  if (is.null(modelfile)) {
    modelfile <- paste0("FitAI_JAGSmodel_",
                        format(Sys.time(), "%Y-%m-%d_%H-%M"), ".txt")
  }


  # default imputation methods, if not specified
  if (is.null(meth)) {
    meth <- get_imp_meth(data, fixed, random, auxvars)
  }


  if (is.null(Mlist)) {
    Mlist <- divide_matrices(data, fixed, random = random, auxvars = auxvars,
                             scale_vars = scale_vars, refcats = refcats,
                             scale_functions = scale_functions)
  }

  if (is.null(K)) {
    K <- get_model_dim(sapply(Mlist, ncol), Mlist$hc_list)
  }

  if (is.null(imp_pos)) {
    imp_pos <- get_imp_pos(meth, Mlist)
  }

  if (is.null(K_imp)) {
    K_imp <- get_imp_dim(meth, imp_pos$pos_Xc)
  }

  if (is.null(dest_cols)) {
    dest_cols <- sapply(names(meth), get_dest_column, Mlist$refs, colnames(Mlist$Xc),
                        colnames(Mlist$Xcat), simplify = F)
  }

  if (is.null(imp_par_list)) {
    imp_par_list <- mapply(get_imp_par_list, meth, names(meth),
                           MoreArgs = list(Mlist$Xc, Mlist$Xcat, K_imp, dest_cols,
                                           Mlist$refs),
                           SIMPLIFY = F)
  }

  if (!file.exists(modelfile) | (file.exists(modelfile) & overwrite == T)) {
    write_model(analysis_type = analysis_type, family = family,
                link = link, meth = meth, Ntot = nrow(Mlist$y),
                N = nrow(Mlist$Xc),
                y_name = names(Mlist$y), Mlist = Mlist, K = K,
                imp_par_list = imp_par_list,
                file = modelfile)
  } else {
    warning(expr = paste0("\nThe file '", modelfile, "' already exists and no new model was written.",
                          "\n",
                          "To overwrite the model set 'overwrite = T'."),
            call. = F, immediate. = T)
  }


  if (is.null(data_list)) {
    data_list <- try(get_data_list(analysis_type, family, meth, Mlist, K, auxvars,
                                 scale_pars = scale_pars))
  }



  adapt <- try(rjags::jags.model(file = modelfile, data = data_list$data_list,
                          inits = NULL,
                          n.chains = n.chains, n.adapt = n.adapt))

  if (is.null(monitor_params)) {
    monitor_params <- c("analysis_main" = T)
  }
  var.names <- do.call(get_params, c(list(meth = meth, analysis_type = analysis_type,
                                          family = family,
                                          y_name = colnames(Mlist$y),
                                          Zcols = ncol(Mlist$Z),
                                          Xc = Mlist$Xc, Xcat = Mlist$Xcat),
                                     monitor_params))

  mcmc <- if (n.iter > 0) {
    try(rjags::coda.samples(adapt, n.iter = n.iter,
                            variable.names = var.names,
                            na.rm = F))
  }



  mcmc_settings <- list(MCMCpackage = MCMCpackage,
                        modelfile = modelfile,
                        n.chains = n.chains,
                        n.adapt = n.adapt,
                        n.iter = n.iter,
                        variable.names = if (exists("var.names")) var.names,
                        thin = thin)

  return(structure(
    list(meth = meth, fixed = fixed, random = random, Mlist = Mlist, K = K, K_imp = K_imp,
         mcmc_settings = mcmc_settings,
         data_list = data_list$data_list,
         scale_pars = data_list$scale_pars,
         model = if (n.adapt > 0) adapt,
         sample = if (n.iter > 0) mcmc), class = "JointAI")
  )
}


#' @rdname model_imp
#' @export
lm_imp <- function(fixed, data,
                   n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                   MCMCpackage = "JAGS", ...){

  if (missing(fixed))
    stop("No fixed effects structure specified.")
  if (missing(data))
    stop("No dataset given.")

  arglist <- mget(names(formals()), sys.frame(sys.nframe()))
  arglist$analysis_type <- "lm"
  arglist$family <- "gaussian"

  thiscall <- as.list(match.call())[-1L]
  thiscall <- lapply(thiscall, function(x) {
    if (is.language(x)) eval(x) else x
  })

  arglist <- c(arglist, thiscall[!names(thiscall) %in% names(arglist)])

  res <- model_imp(arglist)
  return(res)
}



#' @rdname model_imp
#' @export
glm_imp <- function(fixed, family, data,
                    n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                    MCMCpackage = "JAGS", ...){

  if (missing(fixed))
    stop("No fixed effects structure specified.")
  if (missing(data))
    stop("No dataset given.")
  if (missing(family))
    stop("The family needs to be specified.")


  arglist <- mget(names(formals()), sys.frame(sys.nframe()))

  arglist$analysis_type <- "glm"
  arglist$family <- family$family
  arglist$link <- family$link

  thiscall <- as.list(match.call())[-1L]
  thiscall <- lapply(thiscall, function(x) {
    if (is.language(x)) eval(x) else x
  })

  arglist <- c(arglist, thiscall[!names(thiscall) %in% names(arglist)])


  res <- model_imp(arglist)
  return(res)
}



#' @rdname model_imp
#' @export
lme_imp <- function(fixed, data, random,
                    n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                    MCMCpackage = "JAGS", ...){

  if (missing(fixed))
    stop("No fixed effects structure specified.")
  if (missing(random))
    stop("No random effects structure specified.")
  if (missing(data))
    stop("No dataset given.")

  arglist <- mget(names(formals()), sys.frame(sys.nframe()))
  arglist$analysis_type <- "lme"
  arglist$family <- "gaussian"

  thiscall <- as.list(match.call())[-1L]
  thiscall <- lapply(thiscall, function(x) {
    if (is.language(x)) eval(x) else x
  })

  arglist <- c(arglist, thiscall[!names(thiscall) %in% names(arglist)])


  res <- model_imp(arglist)
  return(res)
}
