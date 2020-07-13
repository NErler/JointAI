#' Extract residuals from an object of class JointAI
#'
#' @inheritParams sharedParams
#' @param type type of residuals: \code{"deviance"}, \code{"response"},
#'             \code{"working"}
#' @param ... currently not used
#'
#' @section Note:
#' \itemize{
#' \item For mixed models residuals are currently calculated using the fixed
#'       effects only.
#' \item For ordinal (mixed) models and parametric survival models only
#'       \code{type = "response"} is available.
#' \item For Cox proportional hazards models residuals are not yet implemented.
#' }
#'
#' @examples
#' mod <- glm_imp(B1 ~ C1 + C2 + O1, data = wideDF, n.iter = 100,
#'                family = binomial(), mess = FALSE)
#' summary(residuals(mod, type = 'response')[[1]])
#' summary(residuals(mod, type = 'working')[[1]])
#'
#'
#' @export

residuals.JointAI <- function(object,
                              type, # = c('working', 'deviance', 'response'),
                              warn = TRUE, ...) {


  if (!inherits(object, "JointAI")) errormsg("Use only with 'JointAI' objects.")


  # type <- match.arg(type)

  # Error for survreg models because not all types of residuals are available!
  if (object$analysis_type %in% c('survreg') & type %in% c('working',
                                                           'deviance'))
    errormsg("Residuals of type %s are not implemented for a JointAI model of
            type %s. Currently only residuals of type %s are available for
             parametric survival models.",
             dQuote(type), dQuote(object$analysis_type), dQuote('response'))


  # set type of residuals
  # - if type is one character string, apply it to all models
  # - if type is a vector it must have names matching the names of (some of)
  #   the outcomes
  if (length(type) == 1) {
    types <- setNames(rep(type, length(object$fixed)),
                      names(object$fixed))
  } else {
    if (any(!names(type) %in% names(object$fixed))) {
      errormsg('When %s is a named vector, the names must match outcome
               variables, i.e., %s.',
               dQuote('type'), dQuote(names(object$fixed)))
    }
    types <- setNames(rep(type, length(object$fixed)),
                      names(object$fixed))
    types[names(type)] <- type
  }


  # select the correct function calculating residuals for each model
  resids <- sapply(names(object$fixed), function(varname) {
    resid_fun <- switch(object$info_list[[varname]]$modeltype,
                        glm = resid_glm,
                        glmm = resid_glm,
                        clm = resid_clm,
                        clmm = resid_clm,
                        survreg = resid_survreg,
                        coxph = resid_coxph,
                        JM = resid_coxph
    )

    # If a function could be selected, call this function, otherwise give a
    # warning message
    if (!is.null(resid_fun)) {
      resid_fun(varname = varname,
                mu = if (is.list(object$fitted.values)) {
                  object$fitted.values[[varname]]
                } else {object$fitted.values},
                type = types[varname], data = object$data,
                MCMC = object$MCMC, info = object$info_list[[varname]],
                warn = warn)

    } else {
      if (warn)
        warnmsg("Prediction is not yet implemented for a model of type %s.",
                dQuote(object$info_list[[varname]]$modeltype))
    }
  },  simplify = FALSE)

  if (length(resids) == 1) {
    resids[[1]]
  } else {
    resids
  }
}




# used in residuals.JointAI() (2020-06-14)
resid_glm <- function(varname, type = c("working", "pearson", "response"),
                      data, info, mu, warn = TRUE, ...) {

  # Implemented types for GLM in JointAI are 'working', 'pearson' and
  # 'response'.
  # In stats::residuals.glm() there are also "deviance" and "partial" residuals.
  # For deviance residuals the rank of the design matrix must be known, which
  # is not straightforward in missing data settings.
  # For partial residuals terms and some other elements are necessary that
  # are not direclty available in JointAI. (and maybe some other reasons
  # why it is not possible to calcculate these residuals...)
  #
  # Defaults for standard (base R) GLMs are
  # - residuals included in glm() are 'working'
  # - default for predict.glm() is "deviance"
  # => for JointAI we use "working as default type in either case

  type <- match.arg(type)

  y <- as.numeric(data[, varname]) - is.factor(data[, varname])


  # obtain the link function
  family <- if (info$family %in% c('gaussian', 'binomial', 'Gamma',
                                   'poisson')) {
    get(info$family)(link = info$link)
  } else if (info$family %in% c('lognorm')) {
    gaussian(link = 'log')
  } else if (info$family %in% c('beta') & type %in% c('response')) {
    function(x){log(x/(1 - x))}
  } else {
    errormsg('Residuals of type %s for %s models are currently not available.',
             dQuote(type), dQuote(info$family))
  }

  # linear predictor
  eta <- family$linkfun(mu)

  # working residuals
  r <- (y - mu)/family$mu.eta(eta)

  resid <- switch(type,
                  working = r,
                  response = y - mu,
                  pearson = (y - mu)/sqrt(family$variance(mu))
  )
  resid
}


resid_clm <- function(...) {
  errormsg("It is currently not possible to obtain residuals for clm and clmm
          models.")
}

resid_survreg <- function(...) {
  errormsg('It is currently not possible to obtain residuals for parametric
           survival models.')
}

resid_coxph <- function(...) {
  errormsg('It is currently not possible to obtain residuals for coxph modes.')
  # martingale residuals
  # mresid <- lung$status - 1 + logsurv
}


