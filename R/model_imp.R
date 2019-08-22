#' Joint analysis and imputation of incomplete data
#'
#' Functions to estimate (generalized) linear and (generalized) linear mixed models,
#' ordinal and ordinal mixed models,
#' and parametric (Weibull) as well as Cox proportional hazards
#' survival models using MCMC sampling, while imputing missing values.
#'
#' @param formula a two sided model formula (see \code{\link[stats]{formula}})
#' @param fixed a two sided formula describing the fixed-effects part of the
#'              model (see \code{\link[stats]{formula}})
#' @param random only for multi-level models:
#'               a one-sided formula of the form \code{~x1 + ... + xn | g},
#'               where \code{x1 + ... + xn} specifies the model for the random
#'               effects and \code{g} the grouping variable
#' @param data a \code{data.frame}
#' @param family only for \code{glm_imp} and \code{glmm_imp}:
#'               a description of the distribution and link function to
#'               be used in the model. This can be a character string naming a
#'               family function, a family function or the result of a call to
#'               a family function. (See \code{\link[stats]{family}} and the
#'               `Details` section below.)
#' @param monitor_params named vector specifying which parameters should be
#'                       monitored (see details)
#' @param inits optional specification of initial values in the form of a list
#'              or a function (see \code{\link[rjags]{jags.model}}).
#'              If omitted, initial values will be generated automatically by JAGS.
#'              It is an error to supply an initial value for an observed node.
#' @param progress.bar character string specifying the type of progress bar.
#'                     Possible values are "text", "gui", and "none" (see
#'                     \code{\link[rjags]{update}}). Note: when sampling is performed
#'                     in parallel it is currently not possible to display a
#'                     progress bar.
#' @inheritParams sharedParams
#' @param modelname optional; character string specifying the name of the model file
#'                  (including the ending, either .R or .txt).
#'                  If unspecified a random name will be generated.
#' @param modeldir optional; directory containing the model file or directory in which
#'                 the model file should be written. If unspecified a
#'                 temporary directory will be created.
#' @param overwrite logical; whether an existing model file with the specified
#'                  \code{<modeldir>/<modelname>} should be overwritten. If set to
#'                  \code{FALSE} and a model already exists, that model will be used.
#'                  If unspecified (\code{NULL}) and a file exists, the user is
#'                  asked for input on how to proceed.
#' @param keep_model logical; whether the created JAGS model should be saved
#'                   or removed from the disk (\code{FALSE}; default) when the
#'                   sampling has finished.
#' @param auxvars optional one-sided formula of variables that should be used as
#'                predictors in the imputation procedure (and will be imputed
#'                if necessary) but are not part of the analysis model
#' @param models optional named vector specifying the types of models for
#'               (incomplete) covariates.
#'               This arguments replaces the argument \code{meth} used in earlier versions.
#'               If \code{NULL} (default) models will be determined
#'             automatically based on the class of the respective columns of \code{data}.
#' @param refcats optional; either one of \code{"first"}, \code{"last"}, \code{"largest"}
#'                (which sets the category for all categorical variables)
#'                or a named list specifying which category should be
#'                used as reference category for each of the categorical variables.
#'                Options are the category label, the category number, or one of
#'                "first" (the first category), "last" (the last category)
#'                or "largest" (chooses the category with the most observations).
#'                Default is "first". (See also \code{\link{set_refcat}})
#' @param trunc optional named list specifying the limits of truncation for the
#'              distribution of the named incomplete variables (see the vignette
#'              \href{https://nerler.github.io/JointAI/articles/ModelSpecification.html#functions-with-restricted-support}{ModelSpecification})
#' @param hyperpars list of hyperparameters, as obtained by \code{\link{default_hyperpars}()};
#'                  only needs to be supplied if hyperparameters other than the
#'                  default should be used
#' @param scale_vars optional; named vector of (continuous) variables that will
#'                   be scaled (such that mean = 0 and sd = 1) to improve
#'                   convergence of the MCMC sampling. Default is that all
#'                   continuous variables that are not transformed by a function
#'                   (e.g. \code{log(), ns()}) will be scaled. Variables
#'                   for which a log-normal model is used are
#'                   only scaled with regards to the standard deviation, but not
#'                   centered. Variables modeled with a Gamma or beta distribution
#'                   are not scaled.
#'                   If set to \code{FALSE} no scaling will be done.
#' @param scale_pars optional matrix of parameters used for centering and
#'                   scaling of continuous covariates. If not specified, this will
#'                   be calculated automatically. If \code{FALSE}, no scaling
#'                   will be done.
#' @param keep_scaled_mcmc should the "original" MCMC sample
#'                         (i.e., the scaled version returned by \code{coda.samples()}) be kept?
#'                         (The MCMC sample that is re-scaled to the scale of the
#'                         data is always kept.)
#' @param ... additional, optional arguments
#' @importFrom foreach foreach %dopar%
#'
#'
#'
#' @section Details:
#' See also the vignettes
#' \href{https://nerler.github.io/JointAI/articles/ModelSpecification.html}{Model Specification},
#' \href{https://nerler.github.io/JointAI/articles/MCMCsettings.html}{MCMC Settings} and
#' \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}.
#'
#' \subsection{Implemented distribution families and link functions for \code{glm_imp()}
#' and \code{glme_imp()}}{
#' \tabular{ll}{
# \emph{family} \tab \emph{link}\cr
#' \code{gaussian} \tab with links: \code{identity}, \code{log}\cr
#' \code{binomial} \tab with links: \code{logit}, \code{probit}, \code{log}, \code{cloglog}\cr
#' \code{Gamma}    \tab with links: \code{inverse}, \code{identity}, \code{log}\cr
#' \code{poisson}  \tab with links: \code{log}, \code{identity}
#' }
#' }
#'
#'
#'
#' \subsection{Imputation methods}{
#' Implemented imputation models that can be chosen in the argument \code{models} are:
#' \tabular{ll}{
#' \code{norm} \tab linear model\cr
#' \code{lognorm} \tab log-normal model for skewed continuous data\cr
#' \code{gamma} \tab gamma model (with log-link) for skewed continuous data\cr
#' \code{beta} \tab beta model (with logit-link) for skewed continuous data in (0, 1)\cr
#' \code{logit} \tab logistic model for binary data\cr
#' \code{multilogit} \tab multinomial logit model for unordered categorical variables\cr
#' \code{cumlogit} \tab cumulative logit model for ordered categorical variables\cr
#' \code{lmm} \tab linear mixed model for continuous longitudinal covariates\cr
#' \code{glmm_lognorm} \tab log-normal mixed model for skewed longitudinal covariates\cr
#' \code{glmm_gamma} \tab Gamma mixed model for skewed longitudinal covariates\cr
#' \code{glmm_logit} \tab logit mixed model for binary longitudinal covariates\cr
#' \code{glmm_poisson} \tab Poisson mixed model for longitudinal count covariates\cr
#' \code{clmm} \tab cumulative logit mixed model for longitudinal ordered factors
#' }
#' When models are specified for only a subset of the incomplete or longitudinal
#' covariates involved in a model, the default choices are used for the unspecified
#' variables.
#' }
#'
#' \subsection{Parameters to follow (\code{monitor_params})}{
#' See also the vignette: \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}\cr
#'
#' Named vector specifying which parameters should be monitored. This can be done
#' either directly by specifying the name of the parameter or indirectly by one
#' of the key words selecting a set of parameters. Except for \code{other},
#' in which parameter names are specified directly, parameter (groups) are just
#' set as \code{TRUE} or \code{FALSE}.
#' If left unspecified, \code{monitor_params = c("analysis_main" = TRUE)} will be used.
#' \tabular{ll}{
#' \strong{name/key word} \tab \strong{what is monitored}\cr
#' \code{analysis_main} \tab \code{betas} and \code{sigma_y} (and \code{D} in multi-level models)\cr
#' \code{analysis_random} \tab \code{ranef}, \code{D}, \code{invD}, \code{RinvD}\cr
#' \code{imp_pars} \tab \code{alphas}, \code{tau_imp}, \code{gamma_imp}, \code{delta_imp}\cr
#' \code{imps} \tab imputed values\cr
#' \code{betas} \tab regression coefficients of the analysis model\cr
#' \code{tau_y} \tab precision of the residuals from the analysis model\cr
#' \code{sigma_y} \tab standard deviation of the residuals from the analysis model\cr
#' \code{ranef} \tab random effects \code{b}\cr
#' \code{D} \tab covariance matrix of the random effects\cr
#' \code{invD} \tab inverse of \code{D}\cr
#' \code{RinvD} \tab matrix in the prior for \code{invD}\cr
#' \code{alphas} \tab regression coefficients in the covariate models\cr
#' \code{tau_imp} \tab precision parameters of the residuals from covariate models\cr
#' \code{gamma_imp} \tab intercepts in ordinal covariate models\cr
#' \code{delta_imp} \tab increments of ordinal intercepts\cr
#' \code{other} \tab additional parameters
#' }
#' \strong{For example:}\cr
#' \code{monitor_params = c(analysis_main = TRUE, tau_y = TRUE, sigma_y = FALSE)}
#' would monitor the regression parameters \code{betas} and the
#' residual precision \code{tau_y} instead of the residual standard
#' deviation \code{sigma_y}.
#'
#' \code{monitor_params = c(imps = TRUE)} would monitor \code{betas}, \code{tau_y},
#' and \code{sigma_y} (because \code{analysis_main = TRUE} by default) as well as
#' the imputed values.
#'}
#'
#'
#' @return An object of class \link[=JointAIObject]{JointAI}.
#'
#' @section Note:
#' \subsection{Coding of variables:}{
#' The default imputation methods are chosen based on the \code{class} of each
#' of the incomplete variables, distinguishing between \code{numeric},
#' \code{factor} with two levels, unordered \code{factor} with >2 levels and
#' ordered \code{factor} with >2 levels.\cr
#'
#' When a continuous variable has only two different values it is
#' assumed to be binary and its coding and default (imputation) model will be
#' changed accordingly. This behavior can be overwritten specifying a model type
#' via the argument \code{models}.\cr
#'
#' Variables of type \code{logical} are automatically converted to unordered factors.\cr
#'
#' Contrary to base R behavior, dummy coding (i.e., \code{contr.treatment} contrasts)
#' are used for ordered factors in any linear predictor.
#' It is not possible to overwrite this behavior using the base R contrasts specification.
#' However, since the order of levels in an ordered factor contains information relevant
#' to the imputation of missing values, it is important that incomplete ordinal
#' variables are coded as such.
#' }
#'
#' \subsection{Non-linear effects and transformation of variables:}{
#' \strong{JointAI} handles non-linear effects, transformation of covariates and
#' interactions the following way:\cr
#' When, for instance, the model formula contains the function \code{log(x)} and
#' \code{x} has missing values, \code{x} will be imputed and used in the linear
#' predictor of models for covariates, i.e., it is assumed that
#' the other variables have a linear association with \code{x} but not with
#' \code{log(x)}. The \code{log()} of the observed and imputed values of
#' \code{x} is calculated and used in the linear predictor of the analysis model.\cr
#'
#' If, instead of using \code{log(x)} in the model formula, a pre-calculated
#' variable \code{logx} is used instead, this variable is imputed directly
#' and used in the linear predictors of all models, implying that
#' variables that have \code{logx} in their linear predictors have a linear
#' association with \code{logx} but not with \code{x}.\cr
#'
#' When different transformations of the same incomplete variable are used in
#' one model it is strongly discouraged to calculate these transformations beforehand
#' and supply them as different variables.
#' If, for example, a model formula contains both \code{x} and \code{x2} (where
#' \code{x2} = \code{x^2}), they are treated as separate variables and imputed
#' with separate models. Imputed values of \code{x2} are thus not equal to the
#' square of imputed values of \code{x}.
#' Instead, \code{x} and \code{I(x^2)} should be used in the model formula. Then only
#' \code{x} is imputed and used in the linear predictor of models for other
#' incomplete variables, and \code{x^2} is calculated from the imputed values
#' of \code{x} internally.
#'
#' The same applies to interactions involving incomplete variables.
#' }
#'
#' \subsection{Sequence of covariate models:}{
#'             The default order is incomplete baseline covariates, complete
#'             longitudinal covariates, incomplete longitudinal covariates,
#'             and within each group variables are ordered according to the
#'             proportion of missing values (increasing).
#' }
#'
#' \subsection{Not (yet) possible:}{
#' \itemize{
#' \item multiple nesting levels of random effects (nested or crossed)
#' \item prediction (using \code{predict}) conditional on random effects
#' \item the use of splines for incomplete variables
#' \item the use of \code{\link[survival]{pspline}},
#'       \code{\link[survival]{frailty}}, \code{\link[survival]{cluster}}
#'       or \code{\link[survival]{strata}} in survival models
#' \item left censored or interval censored data
#' }
#' }
#'
#'
#' @seealso \code{\link{set_refcat}}, \code{\link{get_models}},
#'          \code{\link{traceplot}}, \code{\link{densplot}},
#'          \code{\link{summary.JointAI}}, \code{\link{MC_error}},
#'          \code{\link{GR_crit}},
#'          \code{\link{predict.JointAI}}, \code{\link{add_samples}},
#'          \code{\link{JointAIObject}}, \code{\link{add_samples}},
#'          \code{\link{parameters}}, \code{\link{list_models}}
#'
#' Vignettes
#' \itemize{
#'   \item \href{https://nerler.github.io/JointAI/articles/MinimalExample.html}{Minimal Example}
#'   \item \href{https://nerler.github.io/JointAI/articles/ModelSpecification.html}{Model Specification}
#'   \item \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}
#'   \item \href{https://nerler.github.io/JointAI/articles/AfterFitting.html}{After Fitting}
#'}
#'
#'
#' @examples
#' # Example 1: Linear regression with incomplete covariates
#' mod1 <- lm_imp(y ~ C1 + C2 + M1 + B1, data = wideDF, n.iter = 100)
#'
#'
#' # Example 2: Logistic regression with incomplete covariats
#' mod2 <- glm_imp(B1 ~ C1 + C2 + M1, data = wideDF,
#'                 family = binomial(link = "logit"), n.iter = 100)
#'
#'
#' # Example 3: Linear mixed model with incomplete covariates
#' mod3 <- lme_imp(y ~ C1 + B2 + c1 + time, random = ~ time|id,
#'                 data = longDF, n.iter = 300)
#'
#'
#' @name model_imp
NULL

model_imp <- function(fixed, data, random = NULL, link, family,
                      n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                      monitor_params = NULL,  auxvars = NULL, refcats = NULL,
                      models = NULL, no_model = NULL, trunc = NULL,
                      ridge = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                      parallel = FALSE, n.cores = NULL,
                      scale_vars = NULL, scale_pars = NULL, hyperpars = NULL,
                      modelname = NULL, modeldir = NULL,
                      keep_model = FALSE, overwrite = NULL,
                      quiet = TRUE, progress.bar = "text",
                      warn = TRUE, mess = TRUE,
                      keep_scaled_mcmc = FALSE,
                      analysis_type,
                      Mlist = NULL, K = NULL, K_imp = NULL, imp_pos = NULL,
                      dest_cols = NULL, imp_par_list = NULL,  data_list = NULL, ...) {


  # Checks & warnings -------------------------------------------------------
  if (missing(fixed)) {
    stop("A fixed effects structure needs to be specified.")
  }

  if (!analysis_type %in% c("lme", "glme", "clmm") & !is.null(random)) {
    if (warn)
      warning(gettextf("Random effects structure not used in a model of type %s.",
                       sQuote(analysis_type)), immediate. = TRUE, call. = FALSE)
    random <- NULL
  }

  if (analysis_type %in% c("lme", "glme", "clmm") & is.null(random)) {
    stop(gettextf("A random effects structure needs to be specified when using a model of type %s.",
                  sQuote(analysis_type)))
    random <- NULL
  }

  if (n.iter == 0) {
    if (mess)
      message("Note: No MCMC sample will be created when n.iter is set to 0.")
  }

  # check if the argument meth is provided (no longer used)
  args <- as.list(match.call())
  if (!is.null(args$meth))
      warning('The argument "meth" has been changed to "models". Please use "models".',
              call. = FALSE, immediate. = TRUE)



  # data pre-processing --------------------------------------------------------
  # * set contrasts to dummies -------------------------------------------------
  opt <- getOption("contrasts")
  options(contrasts = rep("contr.treatment", 2))

  allvars <- unique(c(all.vars(fixed),
                      all.vars(random),
                      all.vars(auxvars))
  )

  if (any(!allvars %in% names(data))) {
    stop(gettextf("Variable(s) %s were not found in the data." ,
                  paste(dQuote(allvars[!allvars %in% names(data)]), collapse = ", ")),
         call. = FALSE)
  }


  # * check classes of covariates ----------------------------------------------
  covars <- unique(c(all.vars(fixed),
                     all.vars(remove_grouping(random)),
                     all.vars(auxvars)))
  classes <- unique(unlist(sapply(data[covars], class)))

  if (any(!classes %in% c('numeric', 'ordered', 'factor', 'logical', 'integer'))) {
    w <- which(!classes %in% c('numeric', 'ordered', 'factor', 'logical', 'integer'))
    stop(gettextf("Variables of type %s can not be handled.",
                  paste(dQuote(classes[w]), collapse = ', ')))
  }


  # * drop empty categories ----------------------------------------------------
  data_orig <- data
  data[allvars] <- droplevels(data[allvars])

  if (mess) {
    lvl1 <- sapply(data_orig[allvars], function(x) length(levels(x)))
    lvl2 <- sapply(data[allvars], function(x) length(levels(x)))
    if (any(lvl1 != lvl2)) {
      message(gettextf('Empty levels were dropped from %s.',
                       dQuote(names(lvl1)[which(lvl1 != lvl2)])))
    }
  }


  # * convert continuous variable with 2 different values to factor ------------
  for (k in allvars) {
    if (all(class(data[, k]) != 'factor') & length(unique(na.omit(data[, k]))) == 2) {
      data[, k] <- factor(data[, k])
      if (mess)
        message(gettextf('The variable %s was converted to a factor.',
                         dQuote(k)))
    }
  }


  # * convert logicals to factors ----------------------------------------------
  # if (any(unlist(sapply(data[allvars], class)) == 'logical')) {
  #   for (x in allvars) {
  #     if ('logical' %in% class(data[, x])) {
  #       data[, x] <- factor(data[, x])
  #       if (mess)
  #         message(gettextf('%s was converted to a factor.', dQuote(x)))
  #     }
  for (x in allvars) {
    if ('logical' %in% class(data[, x])) {
      data[, x] <- factor(data[, x])
      if (mess)
        message(gettextf('%s was converted to a factor.', dQuote(x)))
    }
    if (is.factor(data[, x])) {
      levels(data[, x]) <- clean_names(levels(data[, x]))
    }
  }



  # imputation method ----------------------------------------------------------
  models <- get_models(fixed = fixed, random = random, data = data,
                       auxvars = auxvars, no_model = no_model, models)$models

  # if (is.null(models)) {
  #   models <- models_default
  #   models_user <- NULL
  # } else {
  #   models_user <- models
  #   if (!setequal(names(models_user), names(models_default))) {
  #     models <- models_default
  #     models[names(models_user)] <- models_user
  #
  #   }
  # }

  # warning if JointAI set imputation method for a continuous variable with only
  # two different values to "logit"
  for (k in names(models)[models == 'logit']) {
    if (is.numeric(data[, k]) & !k %in% names(models) & warn) {
      data[, k] <- factor(data[, k])
      warning(
        gettextf("\nThe variable %s is coded as continuous but has only two different values. I will consider it binary.\nTo overwrite this behavior, specify a different imputation modelsod for %s using the argument %s.",
                 dQuote(k), dQuote(k), dQuote("models")),
        call. = FALSE, immediate. = TRUE)
    }
  }


  # divide matrices ------------------------------------------------------------
  if (is.null(Mlist)) {
    Mlist <- divide_matrices(data, fixed, analysis_type = analysis_type,
                             random = random, auxvars = auxvars,
                             scale_vars = scale_vars, refcats = refcats,
                             models = models, warn = warn, mess = mess, ppc = ppc,
                             ridge = ridge)
  }


  # model dimensions -----------------------------------------------------------

  if (is.null(K)) {
    K <- get_model_dim(Mlist$cols_main, Mlist$hc_list)
  }

  if (is.null(imp_pos)) {
    # position of the variables to be imputed in Xc, Xic, Xl, Xil, Xcat
    imp_pos <- get_imp_pos(models, Mlist)
  }

  if (is.null(K_imp)) {
    K_imp <- get_imp_dim(models, imp_pos, Mlist)
  }

  # imputation parameters/specifications ---------------------------------------
  if (is.null(dest_cols)) {
    dest_cols <- sapply(unique(c(names(models), colnames(Mlist$Xtrafo), colnames(Mlist$Xltrafo))),
                        get_dest_column, Mlist = Mlist, simplify = FALSE)
  }

  if (is.null(imp_par_list)) {
    imp_par_list <- mapply(get_imp_par_list, models, names(models),
                           MoreArgs = list(Mlist, K_imp, dest_cols, trunc, models),
                           SIMPLIFY = FALSE)
  }


  # data list ------------------------------------------------------------------
  if (is.null(data_list)) {
    data_list <- try(get_data_list(analysis_type, family, link, models, Mlist,
                                   scale_pars = scale_pars, hyperpars = hyperpars,
                                   data = data, imp_par_list = imp_par_list))
    scale_pars <- data_list$scale_pars
    hyperpars <- data_list$hyperpars
    data_list <- data_list$data_list
  }


  # write model ----------------------------------------------------------------
  # generate default name for model file if not specified
  if (is.null(modeldir)) modeldir <- tempdir()
  if (is.null(modelname)) {
    modelname <- paste0("JointAI_JAGSmodel_",
                        format(Sys.time(), "%Y-%m-%d_%H-%M"),
                        "_", sample.int(1e6, 1), ".R")
  } else {
    keep_model <- TRUE
  }
  modelfile <- file.path(modeldir, modelname)


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
    Ntot <- #ifelse(analysis_type == 'coxph',
           #sum(data_list$RiskSet != 0),
           length(data_list[[names(Mlist$y)]])#)

    write_model(analysis_type = analysis_type, family = family,
                link = link, models = models,
                Ntot = Ntot, Mlist = Mlist, K = K,
                imp_par_list = imp_par_list,
                file = modelfile)
  }


  # initial values -------------------------------------------------------------
  # * check if initial values are supplied or should be generated
  if (!(is.null(inits) | inherits(inits, c("function", "list")))) {
    if (warn)
      warning("The object supplied to 'inits' could not be recognized.
            Initial values are set by JAGS.")
    inits <- NULL
  }

if (!is.null(inits)) {
  if (inherits(inits, 'function')) {
    # if (!is.null(seed) | parallel) {
      if (!is.null(seed)) set.seed(seed)
      inits <- replicate(n.chains, inits(), simplify = FALSE)
    # }
  }
  if (inherits(inits, "list")) {
    if (!any(c('.RNG.name', '.RNG.seed') %in% unlist(lapply(inits, names))))
      inits <- mapply(function(inits, rng) c(inits, rng), inits = inits,
                      rng = get_RNG(seed, n.chains),
                      SIMPLIFY = FALSE)
  }
} else {
  inits <- get_RNG(seed, n.chains)
}
  # parameters to monitor ------------------------------------------------------

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
  var.names <- do.call(get_params, c(list(models = models, analysis_type = analysis_type,
                                          family = family, Mlist,
                                          imp_par_list = imp_par_list,
                                          ppc = ppc, mess = mess),
                                     monitor_params))


  # run JAGS -----------------------------------------------------------------
  t0 <- Sys.time()
  if (parallel == TRUE) {
    if (!requireNamespace('foreach', quietly = TRUE))
      stop("Parallel sampling requires the 'foreach' package to be installed.")

    if (!requireNamespace('doParallel', quietly = TRUE))
      stop("Parallel sampling requires the 'doParallel' package to be installed.")

    if (any(n.adapt > 0, n.iter > 0)) {
      if (is.null(n.cores)) n.cores <- min(parallel::detectCores() - 2, n.chains)

      doParallel::registerDoParallel(cores = n.cores)
      if (mess)
        message(paste0("Parallel sampling on ", n.cores, " cores started (",
                       Sys.time(), ")."))

      res <- foreach(i = seq_along(inits)) %dopar% {run_jags(inits[[i]], data_list = data_list,
                          modelfile = modelfile,
                          n.adapt = n.adapt, n.iter = n.iter, thin = thin,
                          var.names = var.names)}
      doParallel::stopImplicitCluster()
      mcmc <- as.mcmc.list(lapply(res, function(x) x$mcmc[[1]]))
      adapt <- lapply(res, function(x) x$adapt)
    }
  } else {
    if (any(n.adapt > 0, n.iter > 0)) {
      adapt <- try(rjags::jags.model(file = modelfile, data = data_list,
                                     inits = inits, quiet = quiet,
                                     n.chains = n.chains, n.adapt = n.adapt))
    }
    mcmc <- if (n.iter > 0 & !inherits(adapt, 'try-error')) {
      try(rjags::coda.samples(adapt, n.iter = n.iter, thin = thin,
                              variable.names = var.names,
                              na.rm = FALSE, progress.bar = progress.bar))
    }
  }
  t1 <- Sys.time()

  if (n.iter > 0 & class(mcmc) != 'mcmc.list')
    warning('There is no mcmc sample. Something went wrong.',
            call. = FALSE, immediate. = TRUE)

  # post processing ------------------------------------------------------------
  if (n.iter > 0 & !is.null(mcmc)) {
    MCMC <- mcmc

    coefs <- try(get_coef_names(Mlist, K))

    if (!inherits(coefs, "try-error")) {
    for (k in 1:length(MCMC)) {
      # change names of MCMC to variable names where possible
      colnames(MCMC[[k]])[na.omit(match(coefs[, 1], colnames(MCMC[[k]])))] <-
        coefs[na.omit(match(colnames(MCMC[[k]]), coefs[, 1])), 2]

      if (!is.null(scale_pars)) {
        # re-scale parameters
        MCMC[[k]] <- as.mcmc(sapply(colnames(MCMC[[k]]), rescale, Mlist$fixed2,
                                    scale_pars, MCMC[[k]], Mlist$refs,
                                    unlist(Mlist$names_main)))
        attr(MCMC[[k]], 'mcpar') <- attr(mcmc[[k]], 'mcpar')
      }
    }
    }
  }


  # prepare output -------------------------------------------------------------
  if (!keep_model) {file.remove(modelfile)}

  mcmc_settings <- list(modelfile = modelfile,
                        n.chains = n.chains,
                        n.adapt = n.adapt,
                        n.iter = n.iter,
                        variable.names = if (exists("var.names")) var.names,
                        thin = thin,
                        inits = inits,
                        parallel = parallel,
                        n.cores = if (parallel) n.cores)

  attr(analysis_type, "family") <- family
  attr(analysis_type, "link") <- link

  # set contrasts back to what they were
  options(contrasts = opt)

  object <- structure(
    list(analysis_type = analysis_type,
         data = data, models = models, fixed = fixed, random = random,
         Mlist = Mlist,
         K = K,
         K_imp = K_imp,
         mcmc_settings = mcmc_settings,
         monitor_params = c(monitor_params,
                            if (!'analysis_main' %in% names(monitor_params))
                              setNames(TRUE, 'analysis_main')),
         data_list = data_list,
         scale_pars = scale_pars,
         hyperpars = hyperpars,
         imp_par_list = imp_par_list,
         model = if (n.adapt > 0) adapt,
         sample = if (n.iter > 0 & !is.null(mcmc) & keep_scaled_mcmc) mcmc,
         MCMC = if (n.iter > 0 & !is.null(mcmc)) as.mcmc.list(MCMC),
         time = t1 - t0
    ), class = "JointAI")

  object$fitted.values <- try(predict(object, type = 'response')$fit, silent = TRUE)
  object$residuals <- try(residuals(object, type = 'working'),
                          silent = TRUE)

  if (!inherits(object$residuals, 'try-error')) {
    if (!object$analysis_type %in% c('clm', 'clmm'))
      names(object$fitted.values) <- names(object$residuals) <- rownames(object$Mlist$y)
  }

  if (inherits(object$fitted.values, 'try-error'))
    object$fitted.values <- NULL
  if (inherits(object$residuals, 'try-error'))
    object$residuals <- NULL

  return(object)
}


#' @rdname model_imp
#' @export
lm_imp <- function(formula, data,
                   n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                   monitor_params = NULL,  auxvars = NULL, refcats = NULL,
                   models = NULL, no_model = NULL, trunc = NULL,
                   ridge = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                   parallel = FALSE, n.cores = NULL,
                   scale_vars = NULL, scale_pars = NULL, hyperpars = NULL,
                   modelname = NULL, modeldir = NULL,
                   keep_model = FALSE, overwrite = NULL,
                   quiet = TRUE, progress.bar = "text",
                   warn = TRUE, mess = TRUE,
                   keep_scaled_mcmc = FALSE, ...){

  if (missing(formula))
    stop("No model formula specified.")

  if (missing(data))
    stop("No dataset given.")


  arglist <- mget(names(formals()), sys.frame(sys.nframe()))
  arglist$fixed <- arglist$formula
  arglist$analysis_type <- "lm"
  arglist$family <- "gaussian"
  arglist$link <- "identity"

  thiscall <- as.list(match.call())[-1L]
  # thiscall <- lapply(thiscall, function(x) {
  #   if (is.language(x)) eval(x) else x
  # })

  arglist <- c(arglist,
               thiscall[!names(thiscall) %in% names(arglist)])


  res <- do.call(model_imp, arglist)
  res$call <- match.call()
  return(res)
}



#' @rdname model_imp
#' @export
glm_imp <- function(formula, family, data,
                    n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                    monitor_params = NULL,  auxvars = NULL, refcats = NULL,
                    models = NULL, no_model = NULL, trunc = NULL,
                    ridge = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                    parallel = FALSE, n.cores = NULL,
                    scale_vars = NULL, scale_pars = NULL, hyperpars = NULL,
                    modelname = NULL, modeldir = NULL,
                    keep_model = FALSE, overwrite = NULL,
                    quiet = TRUE, progress.bar = "text",
                    warn = TRUE, mess = TRUE,
                    keep_scaled_mcmc = FALSE, ...){

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
  # thiscall <- lapply(thiscall, function(x) {
  #   if (is.language(x)) eval(x) else x
  # })

  arglist <- c(arglist,
               thiscall[!names(thiscall) %in% names(arglist)])


  if (!arglist$link %in% c("identity", "log", "logit", "probit", "log",
                           "cloglog", "inverse"))
    stop(gettextf("%s is not an allowed link function.",
                  dQuote(arglist$link)))


  res <- do.call(model_imp, arglist)
  res$call <- match.call()
  return(res)
}


#' @rdname model_imp
#' @export
clm_imp <- function(fixed, data,
                    n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                    monitor_params = NULL,  auxvars = NULL, refcats = NULL,
                    models = NULL, no_model = NULL, trunc = NULL,
                    ridge = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                    parallel = FALSE, n.cores = NULL,
                    scale_vars = NULL, scale_pars = NULL, hyperpars = NULL,
                    modelname = NULL, modeldir = NULL,
                    keep_model = FALSE, overwrite = NULL,
                    quiet = TRUE, progress.bar = "text",
                    warn = TRUE, mess = TRUE,
                    keep_scaled_mcmc = FALSE, ...){

  if (missing(fixed))
    stop("No fixed effects structure specified.")
  if (missing(data))
    stop("No dataset given.")

  arglist <- mget(names(formals()), sys.frame(sys.nframe()))
  arglist$analysis_type <- "clm"
  arglist$family <- "ordinal"
  arglist$link <- "logit"


  thiscall <- as.list(match.call())[-1L]
  # thiscall <- lapply(thiscall, function(x) {
  #   if (is.language(x)) eval(x) else x
  # })

  arglist <- c(arglist,
               thiscall[!names(thiscall) %in% names(arglist)])


  res <- do.call(model_imp, arglist)
  res$call <- match.call()

  return(res)
}


#' @rdname model_imp
#' @export
lme_imp <- function(fixed, data, random,
                    n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                    monitor_params = NULL,  auxvars = NULL, refcats = NULL,
                    models = NULL, no_model = NULL, trunc = NULL,
                    ridge = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                    parallel = FALSE, n.cores = NULL,
                    scale_vars = NULL, scale_pars = NULL, hyperpars = NULL,
                    modelname = NULL, modeldir = NULL,
                    keep_model = FALSE, overwrite = NULL,
                    quiet = TRUE, progress.bar = "text",
                    warn = TRUE, mess = TRUE,
                    keep_scaled_mcmc = FALSE, ...){

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
  # thiscall <- lapply(thiscall, function(x) {
  #   if (is.language(x)) {
  #     eval(x)
  #     } else x
  # })

  arglist <- c(arglist,
               thiscall[!names(thiscall) %in% names(arglist)])


  res <- do.call(model_imp, arglist)
  res$call <- match.call()

  return(res)
}


#' @rdname model_imp
#' @aliases glmer_imp
#' @export
glme_imp <- function(fixed, data, random, family,
                     n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                     monitor_params = NULL,  auxvars = NULL, refcats = NULL,
                     models = NULL, no_model = NULL, trunc = NULL,
                     ridge = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                     parallel = FALSE, n.cores = NULL,
                     scale_vars = NULL, scale_pars = NULL, hyperpars = NULL,
                     modelname = NULL, modeldir = NULL,
                     keep_model = FALSE, overwrite = NULL,
                     quiet = TRUE, progress.bar = "text",
                     warn = TRUE, mess = TRUE,
                     keep_scaled_mcmc = FALSE, ...){

  if (missing(fixed))
    stop("No fixed effects structure specified.")
  if (missing(random))
    stop("No random effects structure specified.")
  if (missing(data))
    stop("No dataset given.")

  arglist <- mget(names(formals()), sys.frame(sys.nframe()))
  arglist$analysis_type <- "glme"

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

  if (!arglist$link %in% c("identity", "log", "logit", "probit", "log",
                           "cloglog", "inverse"))
    stop(gettextf("%s is not an allowed link function.",
                  dQuote(arglist$link)))



  thiscall <- as.list(match.call())[-1L]
  # thiscall <- lapply(thiscall, function(x) {
  #   if (is.language(x)) eval(x) else x
  # })

  arglist <- c(arglist,
               thiscall[!names(thiscall) %in% names(arglist)])


  res <- do.call(model_imp, arglist)
  res$call <- match.call()

  return(res)
}


#' @rdname model_imp
#' @export
clmm_imp <- function(fixed, data, random,
                     n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                     monitor_params = NULL,  auxvars = NULL, refcats = NULL,
                     models = NULL, no_model = NULL, trunc = NULL,
                     ridge = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                     parallel = FALSE, n.cores = NULL,
                     scale_vars = NULL, scale_pars = NULL, hyperpars = NULL,
                     modelname = NULL, modeldir = NULL,
                     keep_model = FALSE, overwrite = NULL,
                     quiet = TRUE, progress.bar = "text",
                     warn = TRUE, mess = TRUE,
                     keep_scaled_mcmc = FALSE, ...){

  if (missing(fixed))
    stop("No fixed effects structure specified.")
  if (missing(random))
    stop("No random effects structure specified.")
  if (missing(data))
    stop("No dataset given.")

  arglist <- mget(names(formals()), sys.frame(sys.nframe()))
  arglist$analysis_type <- "clmm"
  arglist$family <- "ordinal"
  arglist$link <- "logit"


  thiscall <- as.list(match.call())[-1L]
  # thiscall <- lapply(thiscall, function(x) {
  #   if (is.language(x)) eval(x) else x
  # })

  arglist <- c(arglist,
               thiscall[!names(thiscall) %in% names(arglist)])


  res <- do.call(model_imp, arglist)
  res$call <- match.call()

  return(res)
}



#' @rdname model_imp
#' @export
survreg_imp <- function(formula, data,
                        n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                        monitor_params = NULL,  auxvars = NULL, refcats = NULL,
                        models = NULL, no_model = NULL, trunc = NULL,
                        ridge = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                        parallel = FALSE, n.cores = NULL,
                        scale_vars = NULL, scale_pars = NULL, hyperpars = NULL,
                        modelname = NULL, modeldir = NULL,
                        keep_model = FALSE, overwrite = NULL,
                        quiet = TRUE, progress.bar = "text",
                        warn = TRUE, mess = TRUE,
                        keep_scaled_mcmc = FALSE, ...){

  if (missing(formula))
    stop("No model formula specified.")

  if (missing(data))
    stop("No dataset given.")


  arglist <- mget(names(formals()), sys.frame(sys.nframe()))
  arglist$fixed <- arglist$formula
  arglist$analysis_type <- "survreg"
  arglist$family <- 'weibull'
  arglist$link <- "log"
  arglist$fixed <- formula

  thiscall <- as.list(match.call())[-1L]
  # thiscall <- lapply(thiscall, function(x) {
  #   if (is.language(x)) eval(x) else x
  # })

  arglist <- c(arglist,
               thiscall[!names(thiscall) %in% names(arglist)])

  res <- do.call(model_imp, arglist)
  res$call <- match.call()
  return(res)
}




#' @rdname model_imp
#' @export
coxph_imp <- function(formula, data,
                      n.chains = 3, n.adapt = 100, n.iter = 0, thin = 1,
                      monitor_params = NULL,  auxvars = NULL, refcats = NULL,
                      models = NULL, no_model = NULL, trunc = NULL,
                      ridge = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
                      parallel = FALSE, n.cores = NULL,
                      scale_vars = NULL, scale_pars = NULL, hyperpars = NULL,
                      modelname = NULL, modeldir = NULL,
                      keep_model = FALSE, overwrite = NULL,
                      quiet = TRUE, progress.bar = "text",
                      warn = TRUE, mess = TRUE,
                      keep_scaled_mcmc = FALSE, ...){

  if (missing(formula))
    stop("No model formula specified.")

  if (missing(data))
    stop("No dataset given.")


  arglist <- mget(names(formals()), sys.frame(sys.nframe()))
  arglist$fixed <- arglist$formula
  arglist$analysis_type <- "coxph"
  arglist$family <- 'prophaz'
  arglist$link <- "log"
  arglist$fixed <- formula

  thiscall <- as.list(match.call())[-1L]
  # thiscall <- lapply(thiscall, function(x) {
  #   if (is.language(x)) eval(x) else x
  # })

  arglist <- c(arglist,
               thiscall[!names(thiscall) %in% names(arglist)])

  res <- do.call(model_imp, arglist)
  res$call <- match.call()
  return(res)
}

