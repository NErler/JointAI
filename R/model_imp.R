#' Joint analysis and imputation
#'
#' \code{lm_imp}, \code{glm_imp} and \code{lme_imp} estimate linear, generalized
#' linear and linear mixed models, respectively, using MCMC sampling.
#'
#' @param formula a two sided model formula (see \code{\link[stats]{formula}})
#' @param fixed a two sided formula describing the fixed-effects part of the
#' model (see \code{\link[stats]{formula}})
#' @param random only for \code{lme_imp}:
#'               a one-sided formula of the form \code{~x1 + ... + xn | g},
#'               where \code{x1 + ... + xn} specifies the model for the random
#'               effects and \code{g} the grouping variable
#' @param data a data frame containing the variabels named in \code{fixed}
#' @param family only for \code{glm_imp}:
#'               a description of the error distribution and link function to
#'               be used in the model. This can be a character string naming a
#'               family function, a family function or the result of a call to
#'               a family function. (See \code{\link[stats]{family}} and the
#'               `Details` section below.)
#' @param n.iter number of iterations of the MCMC sampler per chain
#'               (passed to \code{\link[rjags]{coda.samples}}).
#'               If \code{n.iter = 0}, no MCMC sample is produced.
#' @param ... additional, optional parameters, see below
#'
#'
#' @section Optional arguments:
#' There are some optional parameters that can be passed to \code{...}
#' \subsection{Imputation settings}{
#' \describe{
#' \item{\code{meth}}{named vector specifying imputation model types and order or
#'                  NULL (default). If NULL, imputation models will be determined
#'                  automatically based on the class of the columns of \code{data}
#'                  that contain missing values. The default order is according
#'                  to the proportion of missing values (increasing).
#'                  Implemented models are:
#' \tabular{ll}{
#' \code{norm} \tab linear model\cr
#' \code{lognormal} \tab log-linear model for skewed continuous data\cr
#' \code{logit} \tab logistic model for binary data\cr
#' \code{multinomial} \tab multinomial logit model for unordered categorical variables\cr
#' \code{ordinal} \tab cumulative logit model for ordered categorical variables\cr
#' }}
#' \item{\code{auxvars}}{vector of variable names that shoud be used as
#'                     predictors in the imputation procedure (and will be
#'                     imputed if necessary) but are not part of the analysis
#'                     model}
#' \item{\code{refcats}}{a named list specifying which category should be used as
#'                     reference category for each of the categorical variables.
#'                     Options are the category label, the category number,
#'                     'first" (the first cateogry) or "largest" (chooses the
#'                     category with the most observations).
#'                     Default is "first".}
#' }}
#'
#' \subsection{}{
#' \describe{
#' \item{\code{scale_vars}}{named vector of (continuous) variables that will be
#'                        scaled (so that mean = 0 and sd = 1) to improve
#'                        convergence of the MCMC sampling. Default is that all
#'                        continuous variables will be scaled.}
#' }}
#'
#' \subsection{MCMC settings}{
#' \describe{
#' \item{\code{n.chains}}{the number of parallel chains for the model}
#' \item{\code{n.adapt}}{the number of iterations for adaptation (default = 100).
#'                See \code{\link[rjags]{jags.model}} for details. If n.adapt = 0
#'                then no adaptation takes place.}
#' \item{\code{thin}}{thinning interval for monitors
#'                  (passed to \code{\link[rjags]{coda.samples}})}
#' \item{\code{inits}}{optional specification of initial values in the form of
#'                     a list or a function (see \code{\link[rjags]{jags.model}}).
#'                     If omitted, initial values will be generated automatically.}
#' \item{\code{monitor_params}}{a character vector giving the names of variables
#'                            to be monitored, see `Details'.}
#' \item{\code{modelname}}{character string specifying the name of the file
#'                        containing the JAGS model (or in which the model will
#'                        be writen), including the file ending (\code{.R}
#'                        or \code{.txt}). If not specified a random name will be
#'                        created.}
#' \item{\code{modeldir}}{directory containing the model or directory in which
#' the model should be written. If not specified, a temporary directory is created.}
#' \item{\code{overwrite}}{In case the specified model file already exists, should
#' it be overwritten? Default is \code{FALSE}}
#' \item{\code{keep_model}}{A logical value to specify if the model file should be
#'                        stored after the calculation finishes (default is \code{FALSE}).}
#' \item{\code{quiet}}{see \code{\link[rjags]{jags.model}}}
#' \item{\code{progress.bar}}{see \code{\link[rjags]{update.jags}}}
#' \item{\code{MCMCpackage}}{currently only \code{JAGS} is implemented}
#' }}
#'
#' \subsection{Other settings}{
#' \describe{
#' \item{\code{scale_vars}}{optional vector of variable names that should be scaled and
#' centered during for the MCMC sampling for better convergence (results and
#' imputations will be returned on the original scale). If not specified,
#' all continuous covariates are scaled, except if they are included in the
#' model formula in a spline function). If set to \code{FALSE} no scaling will
#' be done (not suggested).}
#' \item{\code{scale_pars}}{optional matrix of parameters used for centering and
#' scaling continuous covariates. If not specified, this will be calculated
#' automatically. If \code{FALSE}, no scaling will be done.}
#' }}
#'
#' @section Details:
#' \subsection{Implemented distribution families and link functions for \code{glm_imp}}{
#' \tabular{ll}{
#' \emph{family} \tab \emph{link}\cr
#' gaussian: \tab \code{identity}, \code{log}, \code{inverse}\cr
#' binomial: \tab \code{logit}, \code{probit}, \code{log}, \code{cloglog}\cr
#' Gamma:    \tab \code{inverse}, \code{identity}, \code{log}\cr
#' poisson:  \tab \code{log}, \code{identity}\cr
#' }}
#'
#'
#'
#' \subsection{Details on \code{monitor_pars}}{
#' Named vector specifying which parameters should be monitored. Possible elements are
#' \tabular{ll}{
#' \code{analysis_main} \tab \code{betas}, \code{tau_y} and \code{sigma_y}\cr
#' \code{analysis_random} \tab \code{ranef}, \code{D}, \code{invD}, \code{RinvD}\cr
#' \code{imp_pars} \tab \code{alphas}, \code{tau_imp}, \code{gamma_imp}, \code{delta_imp}\cr
#' \code{imps} \tab imputed values\cr
#' \code{betas} \tab regression coefficients of the analysis model\cr
#' \code{tau_y} \tab precision of the residuals from the analysis model\cr
#' \code{sigma_y} \tab standard deviation of the residuals from the analysis model\cr
#' \code{ranef} \tab random effects\cr
#' \code{D} \tab covariance matrix of the random effects\cr
#' \code{invD} \tab inverse of \code{D}\cr
#' \code{RinvD} \tab matrix in prior for \code{invD}\cr
#' \code{alphas} \tab regression coefficients in the imputation models\cr
#' \code{tau_imp} \tab precision parameters of the residuals from imputation models\cr
#' \code{gamma_imp} \tab intercepts in ordinal imputation models\cr
#' \code{delta_imp} \tab increments of ordinal intercepts\cr
#' \code{other} \tab additional parameters\cr
#' }
#' Examples:
#'
#' \code{monitor_pars = c("analysis_main" = T, "tau_y" = F)}
#' would monitor the regression parameters \code{betas} and residual standard
#' deviation \code{sigma_y}, but not the residual precision.
#' }
#' \code{monitor_pars = c(imps = T)} would monitor \code{betas}, \code{tau_y},
#' and \code{sigma_y} (because \code{analysis_main = T} by default) as well as
#' the imputed values.
#'
#'
#' @section Value:
#' An object of class \code{JointAI} with elements
#' \describe{
#' \item{\code{call}}{the original call}
#' \item{\code{analysis_type}}{\code{lm}, \code{glm} or \code{lme}, with attributes
#'                             \code{family} and \code{link}}
#' \item{\code{data}}{the original dataset}
#' \item{\code{meth}}{named vector specifying imputation methods and sequence}
#' \item{\code{fixed}}{supplied fixed effects structure}
#' \item{\code{random}}{supplied random effects structure}
#' \item{\code{Mlist}}{a list of matrices that contain the data split up into
#'        outcome (y), cross-sectional main effects (Xc), cross-sectional interactions (Xic),
#'        longitudinal main effects (Xl), longitudinal interactions (Xil),
#'        categorical incomplete variables (Xcat), transformed cross-sectional
#'        variables (Xtrafo), random effects design matrix (Z),
#'        the vector of variables to be scaled (scale_vars), reference values
#'        and dummies for categorical variables (refs), specification for
#'        transformations (trafos), specification for hierarchical centering (hc_list),
#'        vector of auxiliary variables (auxvars), grouping specification (groups),
#'        updated fixed effects structure (fixed2), names of updated design matrix
#'        (X2_names)}
#' \item{\code{K}}{matrix specifying the indices of the regression coefficients
#' that are related to different parts of the model}
#' \item{\code{K_imp}}{matrix specifying the indices of regression coefficients
#' for the imputation models relating to different covariates}
#' \item{\code{mcmc_settings}}{a list with elements
#'      \describe{
#'      \item{\code{MCMCpackage}}{which package has been used (at the moment only JAGS is implemented)}
#'      \item{\code{modelfile}}{name and path of JAGS model file}
#'      \item{\code{n.chains}}{number of MCMC chains}
#'      \item{\code{n.adapt}}{number of iterations in the adaptive phase}
#'      \item{\code{n.iter}}{number of iterations in the MCMC sample}
#'      \item{\code{variable.names}}{monitored nodes}
#'      \item{\code{thin}}{thinning of the MCMC sample}
#'      }}
#' \item{\code{data_list}}{list with data that was passed to JAGS}
#' \item{\code{scale_pars}}{matrix with parameters used to center and scale the continuous variables}
#' \item{\code{model}}{JAGS model}
#' \item{\code{sample}}{MCMC sample (Note: if continuous variables have been scaled
#' during the sampling, the posterior sample here is on the scaled scale, not on
#' the original scale.)}
#' }
#'
#' @seealso \code{\link{traceplot}}, \code{\link{densplot}},
#'          \code{\link{summary.JointAI}}, \code{\link{MC_error}},
#'          \code{\link{GR_crit}}
#'
#' @examples
#' \dontrun{
#' library(JointAI)
#' mod1 <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#' mod2 <- glm_imp(B1 ~ C1 + C2 + M2, data = wideDF,
#'                 family = binomial(link = "logit"), n.iter = 100)
#' mod3 <- lme_imp(y ~ C1 + B2 + L1 + time, random = ~ time|id,
#'                 data = longDF, n.iter = 500)
#' }
#'
#' @name model_imp
NULL

model_imp <- function(arglist) {
  list2env(arglist, sys.frame(sys.nframe()))

  for (x in c("auxvars", "meth", "random", "monitor_params", "refcats",
              "modelname", "modeldir", "scale_vars", "scale_pars", "Mlist", "K", "K_imp",
              "imp_pos", "dest_cols", "imp_par_list", "data_list", "inits")) {
    if (!x %in% ls()) assign(x, NULL)
  }

  for (x in c("overwrite", "quiet", "keep_model")) {
    if (!x %in% ls()) assign(x, FALSE)
  }

  if (!"progress.bar" %in% ls()) assign("progress.bar", "text")

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
  if (is.null(modeldir)) modeldir <- tempdir()
  if (is.null(modelname)) {
    modelname <- paste0("FitAI_JAGSmodel_",
                        format(Sys.time(), "%Y-%m-%d"),
                        "_", sample.int(1e6, 1), ".R")
  } else {
    keep_model <- TRUE
  }
  modelfile <- file.path(modeldir, modelname)


  # default imputation methods, if not specified
  if (is.null(meth)) {
    meth <- get_imp_meth(fixed = fixed, random = random, data = data,
                         auxvars = auxvars)
  }


  if (is.null(Mlist)) {
    Mlist <- divide_matrices(data, fixed, random = random, auxvars = auxvars,
                             scale_vars = scale_vars, refcats = refcats, meth = meth)
  }

  if (is.null(K)) {
    K <- get_model_dim(sapply(Mlist, ncol), Mlist$hc_list)
  }

  if (is.null(imp_pos)) {
    # position of the variables to be imputed in Xc, Xic, Xl, Xil, Xcat
    imp_pos <- get_imp_pos(meth, Mlist)
  }

  if (is.null(K_imp)) {
    K_imp <- get_imp_dim(meth, imp_pos$pos_Xc)
  }

  if (is.null(dest_cols)) {
    dest_cols <- sapply(names(meth), get_dest_column, Mlist$refs,
                        colnames(Mlist$Xc), colnames(Mlist$Xcat),
                        colnames(Mlist$Xtrafo), Mlist$trafos, simplify = F)
  }

  if (is.null(imp_par_list)) {
    imp_par_list <- mapply(get_imp_par_list, meth, names(meth),
                           MoreArgs = list(Mlist$Xc, Mlist$Xcat, K_imp, dest_cols,
                                           Mlist$refs, Mlist$trafos),
                           SIMPLIFY = F)
  }

  # write model ----------------------------------------------------------------
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
    scale_pars <- data_list$scale_pars
    data_list <- data_list$data_list
  }


  # run JAGS -----------------------------------------------------------------
  if (any(n.adapt > 0, n.iter > 0)) {

    adapt <- try(rjags::jags.model(file = modelfile, data = data_list,
                                   inits = inits, quiet = quiet,
                                   n.chains = n.chains, n.adapt = n.adapt))
  }
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
    try(rjags::coda.samples(adapt, n.iter = n.iter, thin = thin,
                            variable.names = var.names,
                            na.rm = F, progress.bar = progress.bar))
  }


  if (!keep_model) {file.remove(modelfile)}

  mcmc_settings <- list(MCMCpackage = MCMCpackage,
                        modelfile = modelfile,
                        n.chains = n.chains,
                        n.adapt = n.adapt,
                        n.iter = n.iter,
                        variable.names = if (exists("var.names")) var.names,
                        thin = thin)

  attr(analysis_type, "family") <- family
  attr(analysis_type, "link") <- link

  return(structure(
    list(call = thecall,
         analysis_type = analysis_type,
         data = data, meth = meth, fixed = fixed, random = random,
         Mlist = Mlist, K = K, K_imp = K_imp,
         mcmc_settings = mcmc_settings,
         data_list = data_list,
         scale_pars = scale_pars,
         model = if (n.adapt > 0) adapt,
         sample = if (n.iter > 0) mcmc), class = "JointAI")
  )
}


#' @rdname model_imp
#' @export
lm_imp <- function(formula, data,
                   n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                   MCMCpackage = "JAGS", ...){

  if (missing(formula))
    stop("No model formula specified.")

  if (missing(data))
    stop("No dataset given.")


  arglist <- mget(names(formals()), sys.frame(sys.nframe()))
  arglist$fixed <- arglist$formula
  arglist$analysis_type <- "lm"
  arglist$family <- "gaussian"
  arglist$link <- "identity"
  arglist$fixed <- formula

  thiscall <- as.list(match.call())[-1L]
  thiscall <- lapply(thiscall, function(x) {
    if (is.language(x)) eval(x) else x
  })

  arglist <- c(thecall = match.call(),
               arglist,
               thiscall[!names(thiscall) %in% names(arglist)])

  res <- model_imp(arglist)
  return(res)
}



#' @rdname model_imp
#' @export
glm_imp <- function(formula, family, data,
                    n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                    MCMCpackage = "JAGS", ...){

  if (missing(formula))
    stop("No model formula specified.")
  if (missing(data))
    stop("No dataset given.")
  if (missing(family))
    stop("The family needs to be specified.")

  arglist <- mget(names(formals()), sys.frame(sys.nframe()))
  arglist$fixed <- arglist$formula


  arglist$analysis_type <- "glm"


  if (is.character(family)) {
    family <- get(family, mode = "function", envir = parent.frame())
    arglist$family <- family()$family
    arglist$link <- family()$link
  }

  if (is.function(family)) {
    arglist$family <- family()$family
    arglist$link <- family()$link
  }

  if (inherits(family, "family")) {
    arglist$family <- family$family
    arglist$link <- family$link
  }

  arglist$fixed <- formula

  thiscall <- as.list(match.call())[-1L]
  thiscall <- lapply(thiscall, function(x) {
    if (is.language(x)) eval(x) else x
  })

  arglist <- c(thecall = match.call(),
               arglist,
               thiscall[!names(thiscall) %in% names(arglist)])


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
  arglist$link <- "identity"


  thiscall <- as.list(match.call())[-1L]
  thiscall <- lapply(thiscall, function(x) {
    if (is.language(x)) eval(x) else x
  })

  arglist <- c(thecall = match.call(),
               arglist,
               thiscall[!names(thiscall) %in% names(arglist)])


  res <- model_imp(arglist)
  return(res)
}
