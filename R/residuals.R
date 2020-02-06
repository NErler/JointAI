#' Extract residuals from an object of class JointAI
#'
#' @inheritParams sharedParams
#' @param type type of residuals: \code{"deviance"}, \code{"response"},
#'             \code{"working"}
#' @param ... currently not used
#'
#' @section Note:
#' \itemize{
#' \item For mixed models residuals are currently calculated using the fixed effects only.
#' \item For ordinal (mixed) models and parametric survival models only \code{type = "response"} is available.
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
                              type = c('working', 'deviance', 'response'), warn = TRUE, ...) {

  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")


  type <- match.arg(type)

  if (object$analysis_type %in% c('survreg') & type %in% c('working', 'deviance'))
    stop(gettextf("Residuals of type %s are not implemented for a JointAI model of type %s. Currently only residuals of type %s are available for parametric survival models.",
                  dQuote(type), dQuote(object$analysis_type), dQuote('response')),
         call. = FALSE)

  # if (object$analysis_type %in% c('coxph', 'clm', 'clmm', 'JM'))
  #   stop(gettextf("Residuals are not yet implemented for a JointAI model of type %s.",
  #                 dQuote(object$analysis_type)), call. = FALSE)

  if (length(type) == 1) {
    types <- setNames(rep(type, length(object$fixed)),
                      names(object$fixed))
  } else {
    if (any(!names(type) %in% names(object$fixed))) {
      stop(paste0('When ', dQuote('type'), ' is a named vector, the names must',
                  'match outcome variables, ',
                  gettextf('i.e., %s.', dQuote(names(object$fixed)))
      ))
    }
    types <- setNames(rep(type, length(object$fixed)),
                      names(object$fixed))
    types[names(type)] <- type
  }

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

    if (!is.null(resid_fun)) {
      resid_fun(varname = varname,
                mu = if(is.data.frame(object$fitted.values))
                  object$fitted.values else object$fitted.values[[varname]],
                type = types[varname], data = object$data,
                MCMC = object$MCMC, info_list = object$info_list)

    } else {
      if (warn)
      warning(gettextf("Prediction is not yet implemented for a model of type %s.",
                       dQuote(object$info_list[[varname]]$modeltype)))
    }
  },  simplify = FALSE)
}



resid_glm <- function(varname, type = c("working", "pearson", "response"),
                      data, info, fitted, ...) {

  type <- match.arg(type)

  y <- data[, varname]
  mu <- fitted


  family <- if(info$family %in% c('gaussian', 'binomial', 'Gamma', 'poisson')) {
    get(info$family)(link = info$link)
  } else if (info$family %in% c('lognorm')) {
    gaussian(link = 'log')
  } else {
    warning(gettextf('Residuals for %s models are currently not available.',
                     dQuote(info$family)),
            call. = FALSE)
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


resid_clm <- function(..., warn = TRUE) {
  if (warn)
  warning('It is currently not possible to obtain residuals for clm and clmm modes.')
}

resid_survreg <- function(..., warn = TRUE) {
  if (warn)
  warning('It is currently not possible to obtain residuals for survreg modes.')
}

resid_coxph <- function(..., warn = TRUE) {
  if (warn)
  warning('It is currently not possible to obtain residuals for coxph modes.')
  # martingale residuals
  # mresid <- lung$status - 1 + logsurv
}


