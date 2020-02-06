#' Create a new dataframe for prediction
#'
#' Build a \code{data.frame} for prediction, where one variable
#' varies and all other variables are set to the reference value (median for
#' continuous variables).
#'
#' @inheritParams model_imp
#' @inheritParams sharedParams
#' @param dat original data
#' @param var name of variable that should be varying
#' @param length number of values used in the sequence when \code{var} is continuous
#' @param ... optional, additional arguments (currently not used)
#'
#' @seealso \code{\link{predict.JointAI}}, \code{\link{lme_imp}}, \code{\link{glm_imp}},
#'           \code{\link{lm_imp}}
#' @examples
#' # fit a JointAI model
#' mod <- lm_imp(y ~ C1 + C2 + M2, data = wideDF, n.iter = 100)
#'
#' # generate a dataframe with varying "C2" and reference values for all other variables in the model
#' newDF <- predDF(mod, var = "C2")
#'
#' head(newDF)
#'
#' @export

predDF <- function(object, ...) {
  UseMethod("predDF")
}


#' @rdname predDF
#' @export
predDF.JointAI <- function(object, var, length = 100, ...) {

  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  predDF(formula = object$fixed[[1]], dat = object$data, var = var, ...)
}


#' @rdname predDF
#' @export
predDF.formula <- function(formula, dat, var, length = 100, ...) {

  allvars <- all.vars(formula)

  if (!var %in% allvars) {
    stop(paste0(var , "was not used in the model formula."))
  }

  vals <- sapply(allvars, function(k) {
    if (k %in% var) {
      if (is.factor(dat[, k])) {
        unique(dat[, k])
      } else {
        seq(min(dat[, k], na.rm = TRUE),
            max(dat[, k], na.rm = TRUE), length = length)
      }
    } else {
      if (is.factor(dat[, k])) {
        factor(levels(dat[, k])[1], levels = levels(dat[, k]))
      } else if (is.logical(dat[, k]) | is.character(dat[, k])) {
        factor(levels(as.factor(dat[, k]))[1],
               levels = levels(as.factor(dat[, k])))
      } else if (is.numeric(dat[, k])) {
        median(dat[, k], na.rm = TRUE)
      }
    }
  })
  expand.grid(vals)
}






#' Predict values from an object of class JointAI
#'
#' Obtains predictions and corresponding credible intervals from an object of class 'JointAI'.
#' @inheritParams summary.JointAI
#' @param newdata optional new dataset for prediction. If left empty, the original data is used.
#' @param quantiles quantiles of the predicted distribution of the outcome
#' @param type the type of prediction. The default is on the scale of the
#'         linear predictor (\code{"link"} or \code{"lp"}). For generalized
#'         linear (mixed) models \code{type = "response"} transforms the
#'         predicted values to the scale of the response. For ordinal (mixed)
#'         models \code{type} may be \code{"prob"} (to obtain probabilities per
#'         class) or \code{"class"} to obtain the class with the highest posterior
#'         probability.
#'
#' @details A \code{model.matrix} \eqn{X} is created from the model formula (currently fixed
#'          effects only) and \code{newdata}. \eqn{X\beta} is then calculated for
#'          each iteration of the MCMC sample in \code{object}, i.e., \eqn{X\beta}
#'          has \code{n.iter} rows and \code{nrow(newdata)} columns.
#'          A subset of the MCMC sample can be selected using \code{start},
#'          \code{end} and  \code{thin}.
#'
#' @return A list with entries \code{dat}, \code{fit} and \code{quantiles},
#'         where
#'         \code{fit} contains the predicted values (mean over the values calculated
#'         from the iterations of the MCMC sample),
#'         \code{quantiles} contain the specified quantiles (by default 2.5\%
#'         and 97.5\%),
#'         and \code{dat} is \code{newdata}, extended with \code{fit} and \code{quantiles}
#'         (unless prediction for an ordinal outcome is done with \code{type = "prob"},
#'         in which case the quantiles are an array with three dimensions and are
#'         therefore not included in \code{dat}).
#'
#' @seealso \code{\link{predDF.JointAI}}, \code{\link[JointAI:model_imp]{*_imp}}
#'
#' @section Note:
#' \itemize{
#' \item So far, \code{predict} cannot calculate predicted values for cases with
#'       missing values in covariates. Predicted values for such cases are \code{NA}.
#' \item For repeated measures models prediction currently only uses fixed effects.
#' }
#' Functionality will be extended in the future.
#'
#' @examples
#' # fit model
#' mod <- lm_imp(y ~ C1 + C2 + I(C2^2), data = wideDF, n.iter = 100)
#'
#' # calculate the fitted values
#' fit <- predict(mod)
#'
#' # create dataset for prediction
#' newDF <- predDF(mod, var = "C2")
#'
#' # obtain predicted values
#' pred <- predict(mod, newdata = newDF)
#'
#' # plot predicted values and 95% confidence band
#' plot(newDF$C2, pred$fit[[1]]$fit, type = "l", ylim = range(pred$quantiles),
#'      xlab = "C2", ylab = "predicted values")
#' matplot(newDF$C2, pred$quantiles, lty = 2, add = TRUE, type = "l", col = 1)
#'

#' @export
predict.JointAI <- function(object, newdata, quantiles = c(0.025, 0.975),
                            type = 'lp',
                            start = NULL, end = NULL, thin = NULL,
                            exclude_chains = NULL, mess = TRUE, warn = TRUE, ...) {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  if (any(sapply(object$info_list, "[[", "modeltype") %in% c('glmm', 'clmm', 'mlogitmm')) & warn) {
    warning("Prediction for multi-level models is currently only possible on the population level (not using random effects).")
    # stop("Prediction is currently only available for (generalized) linear
    #      and (generalized) linear mixed models.")
  }

  if (missing(newdata))
    newdata <- object$data

  MCMC <- prep_MCMC(object, start = start, end = end, thin = thin,
                    subset = FALSE, exclude_chains = exclude_chains,
                    mess = mess, ...)


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

  preds <- sapply(names(object$fixed), function(varname) {
    predict_fun <- switch(object$info_list[[varname]]$modeltype,
                          glm = predict_glm,
                          glmm = predict_glm,
                          clm = predict_clm,
                          clmm = predict_clm,
                          survreg = predict_survreg,
                          coxph = predict_coxph
    )
    if (!is.null(predict_fun)) {
      predict_fun(formula = object$fixed[[varname]],
                  newdata = newdata, type = types[varname], data = object$data,
                  MCMC = MCMC, varname = varname,
                  coef_list = object$coef_list, info_list = object$info_list,
                  quantiles = quantiles)
    } else {
      warning(gettextf("Prediction is not yet implemented for a model of type %s.",
                       dQuote(object$info_list[[varname]]$modeltype)))
    }
  },  simplify = FALSE)

  return(list(
    if (length(preds) == 1) {
      cbind(newdata, unlist(unname(preds), recursive = FALSE))

    } else {
      cbind(newdata, unlist(preds, recursive = FALSE))
    },
    fitted = preds
  ))
}


predict_glm <- function(formula, newdata, type = c("link", "response", "lp"),
                        data, MCMC, varname, coef_list, info_list,
                        quantiles = c(0.025, 0.975), mess = TRUE, ...) {

  type <- match.arg(type)

  if (type == "lp")
    type <- "link"

  linkinv <- if (info_list[[varname]]$family %in%
                 c('gaussian', 'binomial', 'Gamma', 'poisson')) {
    get(info_list[[varname]]$family)(link = info_list[[varname]]$link)$linkinv
  }

  coefs <- coef_list[[varname]]

  mf <- model.frame(as.formula(paste(formula)[-2]),
                    data, na.action = na.pass)
  mt <- attr(mf, "terms")

  op <- options(contrasts = rep("contr.treatment", 2),
                na.action = na.pass)
  X <- model.matrix(mt, data = newdata)


  if (mess * any(is.na(X)))
    message('Prediction for cases with missing covariates is not implemented.')


  # linear predictor values for the selected iterations of the MCMC sample
  pred <- sapply(1:nrow(X), function(i)
    MCMC[, coefs$coef[match(colnames(X), coefs$varname)],
         drop = FALSE] %*% X[i, ])

  # fitted values: mean over the (transformed) predicted values
  fit <- if (type == 'response') {
    if (info_list[[varname]]$family %in% c('beta', 'lognorm'))
      stop(paste0('Prediction for beta and lognorm models is currently only possible with type ',
                  dQuote('link'), '.'))

    if (info_list[[varname]]$family == 'poisson') {
      round(colMeans(linkinv(pred)))
    } else {
      colMeans(linkinv(pred))
    }
  } else {
    colMeans(pred)
  }

  # qunatiles
  quants <- if (!is.null(quantiles)) {
    if (type == 'response') {
      t(apply(pred, 2, function(q) {
        quantile(linkinv(q), probs = quantiles, na.rm  = TRUE)
      }))
    } else {
      t(apply(pred, 2, quantile, quantiles, na.rm  = TRUE))
    }
  }

  on.exit(options(op))

  resDF <- if (!is.null(quantiles)) {
    cbind(data.frame(fit = fit),
          as.data.frame(quants))
  } else {
    data.frame(fit = fit)
  }

  return(resDF)
}



predict_survreg <- function(formula, newdata, type = c("response", "link",  "lp",
                                                       "linear"),
                            data, MCMC, varname, coef_list, info_list,
                            quantiles = c(0.025, 0.975), mess = TRUE, ...) {

  type <- match.arg(type)

  if (type == "link")
    type <- "lp"

  if (type == "linear")
    type <- "lp"

  coefs <- coef_list[[varname]]

  mf <- model.frame(as.formula(paste(formula)[-2]),
                    data, na.action = na.pass)
  mt <- attr(mf, "terms")

  op <- options(contrasts = rep("contr.treatment", 2),
                na.action = na.pass)
  X <- model.matrix(mt, data = newdata)


  if (mess * any(is.na(X)))
    message('Prediction for cases with missing covariates is not implemented.')


  # linear predictor values for the selected iterations of the MCMC sample
  pred <- sapply(1:nrow(X), function(i)
    MCMC[, coefs$coef[match(colnames(X), coefs$varname)],
         drop = FALSE] %*% X[i, ])

  # fitted values: mean over the (transformed) predicted values
  fit <- if (type == 'response') {
    colMeans(exp(pred))
  } else {
    colMeans(pred)
  }

  # qunatiles
  quants <- if (!is.null(quantiles)) {
    if (type == 'response') {
      t(apply(pred, 2, function(q) {
        quantile(exp(q), probs = quantiles, na.rm  = TRUE)
      }))
    } else {
      t(apply(pred, 2, quantile, quantiles, na.rm  = TRUE))
    }}

  on.exit(options(op))

  resDF <- if (!is.null(quantiles)) {
    cbind(data.frame(fit = fit),
          as.data.frame(quants))
  } else {
    data.frame(fit = fit)
  }

  return(resDF)
}



predict_coxph <- function(formula, newdata, type = c("lp", "risk", "expected",
                                                     "survival"),
                          data, MCMC, varname, coef_list, info_list,
                          quantiles = c(0.025, 0.975), mess = TRUE, ...) {

  type <- match.arg(type)

  coefs <- coef_list[[varname]]

  mf <- model.frame(as.formula(paste(formula)[-2]),
                    data, na.action = na.pass)
  mt <- attr(mf, "terms")

  op <- options(contrasts = rep("contr.treatment", 2),
                na.action = na.pass)
  X <- model.matrix(mt, data = newdata)[, -1, drop = FALSE]


  if (mess * any(is.na(X)))
    message('Prediction for cases with missing covariates is not implemented.')


  # linear predictor values for the selected iterations of the MCMC sample
  pred <- sapply(1:nrow(X), function(i)
    MCMC[, coefs$coef[match(colnames(X), coefs$varname)],
         drop = FALSE] %*% X[i, ])

  pred <- pred - mean(c(pred))

  logsurv <- MCMC[, grep('log.surv', colnames(MCMC))]


  # fitted values: mean over the (transformed) predicted values
  fit <- if (type == 'risk') {
    colMeans(exp(pred))
  } else if (type == 'lp') {
    colMeans(pred)
  } else if (type == 'expected') {
    colMeans(-logsurv)
  } else if (type == 'survival') {
    colMeans(exp(logsurv))
  }

  # quantiles
  quants <- if (!is.null(quantiles)) {
    if (type == 'risk') {
      t(apply(exp(pred), 2, quantile, quantiles, na.rm  = TRUE))
    } else if (type == 'lp') {
      t(apply(pred, 2, quantile, quantiles, na.rm  = TRUE))
    } else if (type == 'expected') {
      if (ncol(logsurv) == 0)
        stop(paste0('\nFor predictions of type ', dQuote('expected'), ' or ',
                    dQuote('survival'), ', ', dQuote('log.surv'),
                    ' needs to be monitored.\n',
                    'Set ', dQuote('monitor_params = list(other = "log.surv")', ),
                    '.'), call. = FALSE)
      t(apply(-logsurv, 2, quantile, quantiles, na.rm  = TRUE))
    } else if (type == 'survival') {
      if (ncol(logsurv) == 0)
        stop(paste0('\nFor predictions of type ', dQuote('expected'), ' or ',
                    dQuote('survival'), ', ', dQuote('log.surv'),
                    ' needs to be monitored.\n',
                    'Set ', dQuote('monitor_params = list(other = "log.surv")', ),
                    '.'), call. = FALSE)
      t(apply(exp(logsurv), 2, quantile, quantiles, na.rm  = TRUE))
    }
  }

  on.exit(options(op))

  resDF <- if (!is.null(quantiles)) {
    cbind(data.frame(fit = fit),
          as.data.frame(quants))
  } else {
    data.frame(fit = fit)
  }
  return(resDF)
}


predict_clm <- function(formula, newdata, type = c("lp", "prob", "class", "response"),
                        data, MCMC, varname, coef_list, info_list,
                        quantiles = c(0.025, 0.975), mess = TRUE, ...) {

  type <- match.arg(type)
  if (type == 'response')
    type <- 'class'

  coefs <- coef_list[[varname]]

  mf <- model.frame(as.formula(paste(formula)[-2]),
                    data, na.action = na.pass)
  mt <- attr(mf, "terms")

  op <- options(contrasts = rep("contr.treatment", 2),
                na.action = na.pass)
  X <- model.matrix(mt, data = newdata)[, -1, drop = FALSE]

  if (mess * any(is.na(X)))
    message('Prediction for cases with missing covariates is not implemented.')

  eta <- sapply(1:nrow(X), function(i)
    MCMC[, coefs$coef[match(colnames(X), coefs$varname)],
         drop = FALSE] %*% X[i, ])

  pred <- sapply(grep(paste0('gamma_', varname), colnames(MCMC), value = TRUE),
                 function(k)
                   eta + matrix(nrow = nrow(eta), ncol = ncol(eta),
                                data = rep(MCMC[, k], ncol(eta)),
                                byrow = FALSE),
                 simplify = 'array'
  )


  probs <- sapply(1:dim(pred)[1], function(k) {
    cbind(plogis(pred[k, , 1]),
          t(apply(cbind(plogis(pred[k, , ]), 1), 1, diff)))
  }, simplify = 'array')

  dimnames(probs)[[2]] <- paste0("P(", varname, "=",
                                 levels(data[, varname]),
                                 ")")
  fit <- apply(probs, 1:2, mean, na.rm = TRUE)

  if (type == 'class') {
    fit <- apply(fit, 1, function(x) if (all(is.na(x))) NA else which.max(x))
  }

  quants <- if (type == 'prob' & !is.null(quants)) {
    aperm(apply(probs, 1:2, quantile, probs = quantiles, na.rm = TRUE),
          c(2,1,3))
  }

  resDF <- if (type == 'prob' & !is.null(quants)) {
    cbind(as.data.frame(fit),
          as.data.frame(quants))
  } else {
    as.data.frame(fit)
  }

  on.exit(options(op))
  return(resDF)
}



fitted.JointAI <- function(object, ...) {

  types <- sapply(names(object$fixed), function(k) {
    switch(object$info_list[[k]]$modeltype,
           glm = 'response',
           glmm = 'response',
           clm = 'prob',
           clmm = 'prob',
           survreg = 'response',
           coxph = 'lp')
  })

  pred <- predict(object, quantiles = NULL, mess = FALSE, type = types, fitted = TRUE)

  if (length(pred$fitted) == 1)
    pred$fitted[[1]]
  else
    pred$fitted
}


# predict1 <- function(formula, data, newdata, coefs, family = NULL, type, varname,
#                      quantiles = c(0.025, 0.975), MCMC, ...) {
#   mf <- model.frame(as.formula(paste(formula)[-2]),
#                     data, na.action = na.pass)
#   mt <- attr(mf, "terms")
#
#   op <- options(contrasts = rep("contr.treatment", 2),
#                 na.action = na.pass)
#   X <- model.matrix(mt, data = newdata)
#
#
#
#   if (attr(formula, "type") %in% c('clm', 'clmm')) {
#     X <- X[, -1, drop = FALSE]
#     eta <- sapply(1:nrow(X), function(i)
#       MCMC[, coefs$coef[match(colnames(X), coefs$varname)], drop = FALSE] %*% X[i, ])
#     pred <- sapply(grep(paste0('gamma_', varname), colnames(MCMC), value = TRUE),
#                    function(k)
#                      eta + matrix(nrow = nrow(eta), ncol = ncol(eta),
#                                   data = rep(MCMC[, k], ncol(eta)),
#                                   byrow = FALSE),
#                    simplify = 'array'
#     )
#
#     fit <- apply(pred, 2:3, function(k) mean(plogis(k)))
#     fit <- cbind(fit[, 1], t(apply(cbind(fit, 1), 1, diff)))
#     colnames(fit) <- paste0("P(", varname, "=",
#                             levels(data[, varname]),
#                             ")")
#     if (type == 'class') {
#       fit <- apply(fit, 1, which.max)
#     }
#
#     quants <- if (type == 'prob') {
#       aperm(apply(pred, 2:3, function(q) {
#         quantile(plogis(q), probs = quantiles, na.rm  = TRUE)
#       }), c(2, 1, 3))
#     }
#   } else {
#     if (attr(formula, "type") %in% c('coxph', 'JM')) {
#       X <- X[, -1, drop = FALSE]
#     }
#
#     if (ncol(X) == 0)
#       stop('Prediction without covariates is not possible.',
#            call. = FALSE)
#
#     pred <- sapply(1:nrow(X), function(i)
#       MCMC[, coefs$coef[match(colnames(X), coefs$varname)],
#            drop = FALSE] %*% X[i, ])
#
#     if (attr(formula, "type") %in% 'coxph') {
#       pred <- pred - mean(c(pred))
#     }
#
#     fit <- if (type == 'response' | type == 'risk' & attr(formula, "type") == 'coxph') {
#       if (attr(formula, "type") == 'survreg') {
#         colMeans(family$linkinv(pred, MCMC[, 'shape_time']))
#       } else if (family$family == 'poisson') {
#         round(colMeans(family$linkinv(pred)))
#       } else {
#         colMeans(family$linkinv(pred))
#       }
#     } else {
#       colMeans(pred)
#     }
#
#     quants <- if (type == 'response' | type == 'risk' & attr(formula, "type") == 'coxph') {
#       if (attr(formula, "type") == 'survreg') {
#         t(apply(pred, 2, function(q) {
#           quantile(family$linkinv(q, MCMC[, 'shape_time']),
#                    probs = quantiles, na.rm  = TRUE)
#         }))
#       } else {
#         t(apply(pred, 2, function(q) {
#           quantile(family$linkinv(q), probs = quantiles, na.rm  = TRUE)
#         }))
#       }
#     } else {
#       t(apply(pred, 2, quantile, quantiles, na.rm  = TRUE))
#     }
#   }
#
#   dat <- as.data.frame(cbind(newdata, fit))
#   if (length(dim(quants)) <= 2 & !is.null(quants))
#     dat <- cbind(dat, quants)
#
#   on.exit(options(op))
#   return(list(dat = dat, fit = fit, quantiles = quants))
#
# }
