#' Joint analysis and imputation of incomplete data
#'
#' \code{lm_imp}, \code{glm_imp} and \code{lme_imp} estimate linear, generalized
#' linear and linear mixed models, respectively, using MCMC sampling.
#'
#' @param formula a two sided model formula (see \code{\link[stats]{formula}})
#' @param fixed a two sided formula describing the fixed-effects part of the
#'              model (see \code{\link[stats]{formula}})
#' @param random only for \code{lme_imp}:
#'               a one-sided formula of the form \code{~x1 + ... + xn | g},
#'               where \code{x1 + ... + xn} specifies the model for the random
#'               effects and \code{g} the grouping variable
#' @param data a data frame
#' @param family only for \code{glm_imp}:
#'               a description of the distribution and link function to
#'               be used in the model. This can be a character string naming a
#'               family function, a family function or the result of a call to
#'               a family function. (See \code{\link[stats]{family}} and the
#'               `Details` section below.)
#' @param monitor_params named vector specifying which parameters should be
#'                       monitored, see details.
#' @param inits optional specification of initial values in the form of a list
#'              or a function (see \code{\link[rjags]{jags.model}}.
#'              If omitted, initial values will be generated automatically.
#'              It is an error to supply an initial value for an observed node.
#' @inheritParams rjags::jags.model
#' @inheritParams rjags::coda.samples
#' @inheritParams rjags::update.jags
#' @inheritParams sharedParams
#' @param modelname optional; character string specifying the name of model file
#'                  (including the ending, either .R or .txt).
#'                  If unspecified a random name will be generated.
#' @param modeldir optional; directory containing model file. If unspecified a
#'                 temporary directory will be created.
#' @param overwrite logical; whether an existing model file with the specified
#'                  \code{modeldir/modelname} should be overwritten. If set to
#'                  \code{FALSE} (default) and a model already exists, that
#'                  model will be used.
#' @param keep_model logical; whether the created JAGS model should be saved
#'                   or removed from the disk (\code{FALSE}; default) when the
#'                   sampling has finished.
#' @param auxvars optional vector of variable names that should be used as
#'                predictors in the imputation procedure (and will be imputed
#'                if necessary) but are not part of the analysis model
#' @param meth optional named vector specifying imputation model types and order.
#'             If \code{NULL} (default) imputation models will be determined
#'             automatically based on the class of the columns of \code{data}
#'             that contain missing values (see Details).
#'             The default order is according to the proportion of missing
#'             values (increasing).
#' @param refcats optional; a named list specifying which category should be
#'                used as reference category for each of the categorical variables.
#'                Options are the category label, the category number,
#'                'first" (the first category) or "largest" (chooses the
#'                category with the most observations). Default is "first".
#' @param scale_vars optional; named vector of (continuous) variables that will
#'                   be scaled (such that mean = 0 and sd = 1) to improve
#'                   convergence of the MCMC sampling. Default is that all
#'                   continuous variables that are not transformed by a function
#'                   (e.g. \code{log(), ns()}) will be scaled. Variables
#'                   for which \code{"lognorm"} is set as imputation model are
#'                   only scaled with regards to the standard deviation, but not
#'                   centered. If set to \code{FALSE} no scaling will be done.
#' @param hyperpars list of hyperparameters, as obtained by \code{\link{default_hyperpars}()};
#'                  only needs to be supplied if hyperparameters other than the
#'                  default should be used
#' @param ... additional, optional arguments, see below
#'
#'
#' @section Optional arguments:
#' There are some optional parameters that can be passed to \code{\dots}
#' \describe{
#' \item{\code{scale_pars}}{optional matrix of parameters used for centering and
#' scaling continuous covariates. If not specified, this will be calculated
#' automatically. If \code{FALSE}, no scaling will be done.}
#'}
#'
#' @section Details:
#' \subsection{Implemented distribution families and link functions for \code{glm_imp()}}{
#' \tabular{ll}{
# \emph{family} \tab \emph{link}\cr
#' \code{gaussian} \tab with links: \code{identity}, \code{log}\cr
#' \code{binomial} \tab with links: \code{logit}, \code{probit}, \code{log}, \code{cloglog}\cr
#' \code{Gamma}    \tab with links: \code{identity}, \code{log}\cr
#' \code{poisson}  \tab with links: \code{log}, \code{identity}
#' }}
#'
#'
#'
#' \subsection{Imputation methods}{
#' Implemented imputation models that can be chosen in the argument \code{meth} are:
#' \tabular{ll}{
#' \code{norm} \tab linear model\cr
#' \code{lognorm} \tab log-linear model for skewed continuous data\cr
#' \code{gamma} \tab gamma model (with log-link) for skewed continuous data\cr
#' \code{beta} \tab beta model (with logit-link) for skewed continuous data in (0, 1)\cr
#' \code{logit} \tab logistic model for binary data\cr
#' \code{multilogit} \tab multinomial logit model for unordered categorical variables\cr
#' \code{cumlogit} \tab cumulative logit model for ordered categorical variables
#' }}
#'
#' \subsection{Parameters to follow (\code{monitor_params})}{
#' See also the vignette: \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Selecting Parameters}
#'
#' Named vector specifying which parameters should be monitored. This can be done
#' either directly by specifying the name of the parameter or indirectly by one
#' of the key words summarizing a number of parameters. Except for \code{other},
#' in which parameter names are specified directly, parameter (groups) are just
#' set as \code{TRUE} or \code{FALSE}.
#' If left unspecified, \code{monitor_params = c("analysis_main" = TRUE)} will be used.
#' \tabular{ll}{
#' \strong{name/key word} \tab \strong{what is monitored}\cr
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
#' \code{other} \tab additional parameters
#' }
#' For example:
#'
#' \code{monitor_params = c("analysis_main" = TRUE, "tau_y" = FALSE)}
#' would monitor the regression parameters \code{betas} and residual standard
#' deviation \code{sigma_y}, but not the residual precision.
#'
#' \code{monitor_params = c(imps = TRUE)} would monitor \code{betas}, \code{tau_y},
#' and \code{sigma_y} (because \code{analysis_main = TRUE} by default) as well as
#' the imputed values.
#'}
#'
#'
#' @return An object of class \code{JointAI}
#'
#'
#'
#' @seealso \code{\link{set_refcat}},
#' \code{\link{traceplot}}, \code{\link{densplot}},
#'          \code{\link{summary.JointAI}}, \code{\link{MC_error}},
#'          \code{\link{GR_crit}}, \code{\link[rjags]{jags.model}},
#'          \code{\link[rjags]{coda.samples}}, \code{predict.JointAI}
#'
#' @examples
#'
#' mod1 <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#' mod2 <- glm_imp(B1 ~ C1 + C2 + M2, data = wideDF,
#'                 family = binomial(link = "logit"), n.iter = 100)
#' mod3 <- lme_imp(y ~ C1 + B2 + L1 + time, random = ~ time|id,
#'                 data = longDF, n.iter = 500)
#'
#'
#' @name model_imp
NULL

model_imp <- function(fixed, data, random = NULL, link, family,
                      n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                      monitor_params = NULL, inits = TRUE,
                      modelname = NULL, modeldir = NULL,
                      overwrite = NULL, keep_model = FALSE,
                      quiet = TRUE, progress.bar = "text", warn = TRUE,
                      mess = TRUE,
                      auxvars = NULL, meth = NULL, refcats = NULL,
                      scale_vars = NULL, scale_pars = NULL, hyperpars = NULL,
                      MCMCpackage = "JAGS", analysis_type,
                      Mlist = NULL, K = NULL, K_imp = NULL, imp_pos = NULL,
                      dest_cols = NULL, imp_par_list = NULL,  data_list = NULL, ...) {

  # Checks & warnings -------------------------------------------------------
  if (mess)
    message("This is new software. Please report any bug to the package maintainer.")

  if (missing(fixed)) {
    stop("No fixed effects structure specified.")
  }

  if (analysis_type != "lme" & !is.null(random)) {
    if (warn)
      warning(gettextf("Random effects structure not used in a model of type %s.",
                       sQuote(analysis_type)), immediate. = TRUE, call. = FALSE)
    random <- NULL
  }

  if (n.iter == 0) {
    if (mess)
      message("Note: No MCMC sample will be created when n.iter is set to 0.")
  }

  # set contrasts to dummies
  opt <- getOption("contrasts")
  options(contrasts = rep("contr.treatment", 2))


  # generate default name for model file if not specified
  if (is.null(modeldir)) modeldir <- tempdir()
  if (is.null(modelname)) {
    modelname <- paste0("JointAI_JAGSmodel_",
                        format(Sys.time(), "%Y-%m-%d"),
                        "_", sample.int(1e6, 1), ".R")
  } else {
    keep_model <- TRUE
  }
  modelfile <- file.path(modeldir, modelname)

  # check if initial values are supplied or should be generated
  if (!(is.null(inits) | inherits(inits, c("logical", "function", "list")))) {
    if (warn)
      warning("The object supplied to 'inits' could not be recognized.
            Default function to create initial values is used.")
    inits <- TRUE
  }


  # default imputation methods, if not specified
  if (is.null(meth)) {
    meth <- get_imp_meth(fixed = fixed, random = random, data = data,
                         auxvars = auxvars)
  }


  if (is.null(Mlist)) {
    Mlist <- divide_matrices(data, fixed, random = random, auxvars = auxvars,
                             scale_vars = scale_vars, refcats = refcats,
                             meth = meth, warn = warn, mess = mess)
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
                        colnames(Mlist$Xtrafo), Mlist$trafos, simplify = FALSE)
  }

  if (is.null(imp_par_list)) {
    imp_par_list <- mapply(get_imp_par_list, meth, names(meth),
                           MoreArgs = list(Mlist$Xc, Mlist$Xcat, K_imp, dest_cols,
                                           Mlist$refs, Mlist$trafos),
                           SIMPLIFY = FALSE)
  }

  # write model ----------------------------------------------------------------
  if (file.exists(modelfile) & is.null(overwrite)) {
    question_asked <- TRUE
    # This warning can not be switched off by warn = FALSE, because an input is required.
    warning(gettextf("\nThe file %s already exists in %s.",
                     dQuote(modelname), dQuote(modeldir)),
              call. = FALSE, immediate. = TRUE)
    reply <- menu(c('yes', 'no'),
                  title = "\nDo you want me to overwrite this file?")
    if (reply == 1) {
      if (mess)
        message('The modelfile was overwritten.')
    overwrite = TRUE
    } else {
      overwrite = FALSE
      if (mess)
        message('The old model will be used.')
    }
    if (mess)
    message("To skip this question in the future, set 'overwrite = TRUE' or 'overwrite = FALSE'.")
  }

  if (!file.exists(modelfile) || (file.exists(modelfile) & overwrite == TRUE)) {
    write_model(analysis_type = analysis_type, family = family,
                link = link, meth = meth, Ntot = nrow(Mlist$y),
                N = nrow(Mlist$Xc),
                y_name = names(Mlist$y), Mlist = Mlist, K = K,
                imp_par_list = imp_par_list,
                file = modelfile)
  }

  if (is.null(data_list)) {
    data_list <- try(get_data_list(analysis_type, family, link, meth, Mlist, K, auxvars,
                                 scale_pars = scale_pars, hyperpars = hyperpars,
                                 data = data))
    scale_pars <- data_list$scale_pars
    hyperpars <- data_list$hyperpars
    data_list <- data_list$data_list
  }

  if (is.logical(inits)) {
    inits <- if (inits)
      replicate(n.chains,
                get_inits.default(meth = meth, Mlist = Mlist, K = K, K_imp = K_imp,
                       analysis_type = analysis_type, family = family), simplify = FALSE
      )
  }

  # run JAGS -----------------------------------------------------------------
  t0 <- Sys.time()
  if (any(n.adapt > 0, n.iter > 0)) {

    adapt <- try(rjags::jags.model(file = modelfile, data = data_list,
                                   inits = inits, quiet = quiet,
                                   n.chains = n.chains, n.adapt = n.adapt))
  }
  if (is.null(monitor_params)) {
    monitor_params <- c("analysis_main" = TRUE)
  } else {
    if (!is.null(scale_pars) & any(grepl('beta[', unlist(monitor_params), fixed = T))) {
      monitor_params <- c(sapply(monitor_params, function(x) {
        if (any(grepl('beta[', x, fixed = TRUE)))
          x[-grep('beta[', x, fixed = TRUE)]
        else x}, simplify = F),
        analysis_main = TRUE)
      if (mess)
        message('Note: Main model parameter were added to the list of parameters to follow.')
    }}
  var.names <- do.call(get_params, c(list(meth = meth, analysis_type = analysis_type,
                                          family = family,
                                          y_name = colnames(Mlist$y),
                                          Zcols = ncol(Mlist$Z),
                                          Xc = Mlist$Xc, Xtrafo = Mlist$Xtrafo,
                                          Xcat = Mlist$Xcat),
                                     monitor_params))

  mcmc <- if (n.iter > 0) {
    try(rjags::coda.samples(adapt, n.iter = n.iter, thin = thin,
                            variable.names = var.names,
                            na.rm = FALSE, progress.bar = progress.bar))
  }
  t1 <- Sys.time()


  if (n.iter > 0) {
    # MCMC <- do.call(rbind, mcmc)
    coefs <- get_coef_names(Mlist, K)


    MCMC <- mcmc
    for (k in 1:length(MCMC)) {
      # change names of MCMC to variable names where possible
      colnames(MCMC[[k]])[na.omit(match(coefs[, 1], colnames(MCMC[[k]])))] <-
        coefs[na.omit(match(colnames(MCMC[[k]]), coefs[, 1])), 2]

      if (!is.null(scale_pars)) {
        # re-scale parameters
        MCMC[[k]] <- as.mcmc(sapply(colnames(MCMC[[k]]), rescale, Mlist$fixed2,
                            scale_pars, MCMC[[k]], Mlist$refs, Mlist$X2_names,
                            Mlist$trafos))
        attr(MCMC[[k]], 'mcpar') <- attr(mcmc[[k]], 'mcpar')
      }
    }
    # colnames(MCMC)[match(coefs[, 1], colnames(MCMC))] <- coefs[, 2]
  }


  if (!keep_model) {file.remove(modelfile)}

  mcmc_settings <- list(MCMCpackage = MCMCpackage,
                        modelfile = modelfile,
                        n.chains = n.chains,
                        n.adapt = n.adapt,
                        n.iter = n.iter,
                        variable.names = if (exists("var.names")) var.names,
                        thin = thin,
                        inits = inits)

  attr(analysis_type, "family") <- family
  attr(analysis_type, "link") <- link

  # set contrasts back to what they were
  options(contrasts = opt)

  return(structure(
    list(analysis_type = analysis_type,
         family = family,
         link = link,
         data = data, meth = meth, fixed = fixed, random = random,
         Mlist = Mlist,
         refcats = Mlist$refs, K = K, K_imp = K_imp,
         mcmc_settings = mcmc_settings,
         monitor_params = c(monitor_params,
                            if(!'analysis_main' %in% names(monitor_params))
                              setNames(TRUE, 'analysis_main')),
         data_list = data_list,
         scale_pars = scale_pars,
         hyperpars = hyperpars,
         model = if (n.adapt > 0) adapt,
         sample = if (n.iter > 0) mcmc,
         MCMC = if (n.iter > 0) as.mcmc.list(MCMC),
         time = t1 - t0
         ), class = "JointAI")
  )
}


#' @rdname model_imp
#' @export
lm_imp <- function(formula, data,
                   n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                   monitor_params = NULL, inits = TRUE,
                   modelname = NULL, modeldir = NULL,
                   overwrite = NULL, keep_model = FALSE,
                   quiet = TRUE, progress.bar = "text", warn = TRUE,
                   mess = TRUE,
                   auxvars = NULL, meth = NULL, refcats = NULL,
                   scale_vars = NULL, hyperpars = NULL, ...){

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

  res <- do.call(model_imp, arglist)
  res$call <- match.call()
  return(res)
}



#' @rdname model_imp
#' @export
glm_imp <- function(formula, family, data,
                    n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                    monitor_params = NULL, inits = TRUE,
                    modelname = NULL, modeldir = NULL,
                    overwrite = NULL, keep_model = FALSE,
                    quiet = TRUE, progress.bar = "text", warn = TRUE,
                    mess = TRUE,
                    auxvars = NULL, meth = NULL, refcats = NULL,
                    scale_vars = NULL, hyperpars = NULL, ...){

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


  if (!arglist$link %in% c("identity", "log", "logit", "probit", "log",
                           "cloglog"))
    stop(gettextf("%s is not an allowed link function.",
                  dQuote(arglist$link)))


  res <- do.call(model_imp, arglist)
  res$call <- match.call()
  return(res)
}



#' @rdname model_imp
#' @export
lme_imp <- function(fixed, data, random,
                    n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                    monitor_params = NULL, inits = TRUE,
                    modelname = NULL, modeldir = NULL,
                    overwrite = NULL, keep_model = FALSE,
                    quiet = TRUE, progress.bar = "text", warn = TRUE,
                    mess = TRUE,
                    auxvars = NULL, meth = NULL, refcats = NULL,
                    scale_vars = NULL, hyperpars = NULL, ...){

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


  res <- do.call(model_imp, arglist)
  res$call <- match.call()

  return(res)
}

