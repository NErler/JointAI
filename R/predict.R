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

  predDF(formula = object$fixed, dat = object$data, var = var, ...)
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
#' plot(newDF$C2, pred$fit, type = "l", ylim = range(pred$quantiles),
#'      xlab = "C2", ylab = "predicted values")
#' matplot(newDF$C2, pred$quantiles, lty = 2, add = TRUE, type = "l", col = 1)
#'

#' @export
predict.JointAI <- function(object, newdata, quantiles = c(0.025, 0.975),
                            type = c("link", "response", "prob", "class",
                                     "lp", "risk"),
                            start = NULL, end = NULL, thin = NULL,
                            exclude_chains = NULL, mess = TRUE, ...) {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  if (!object$analysis_type %in% c('lm', 'glm', 'lme', 'glme', 'clm', 'clmm',
                                   'survreg', 'coxph')) {
    stop("Prediction is currently only available for (generalized) linear
         and (generalized) linear mixed models.")
  }

  type <- match.arg(type)

  if (missing(newdata))
    newdata <- object$data
    # newdata <- subset(object$data,
    #                   subset = complete.cases(object$data[, all.vars(object$fixed)[
    #                     !all.vars(object$fixed) %in% extract_outcome(object$fixed)]]
    #                   ))


  MCMC <- prep_MCMC(object, start = start, end = end, thin = thin, subset = NULL,
                    exclude_chains = exclude_chains,
                    mess = mess, ...)

  mf <- model.frame(as.formula(paste(object$fixed)[-2]),
                    object$data, na.action = na.pass)
  mt <- attr(mf, "terms")

  op <- options(contrasts = rep("contr.treatment", 2),
          na.action = na.pass)
  X <- model.matrix(mt, data = newdata)


  if (object$analysis_type %in% c('clm', 'clmm')) {
    X <- X[, -1, drop = FALSE]
    eta <- sapply(1:nrow(X), function(i) MCMC[, colnames(X), drop = FALSE] %*% X[i, ])
    pred <- sapply(grep(paste0('gamma_', names(object$Mlist$y)), colnames(MCMC), value = TRUE),
                   function(k)
                     eta + matrix(nrow = nrow(eta), ncol = ncol(eta),
                                  data = rep(MCMC[, k], ncol(eta)),
                                  byrow = FALSE),
                   simplify = 'array'
    )

    fit <- apply(pred, 2:3, function(k) mean(plogis(k)))
    fit <- cbind(fit[, 1], t(apply(cbind(fit, 1), 1, diff)))
    colnames(fit) <- paste0("P(", names(object$Mlist$y), "=",
                            levels(object$data[, colnames(object$Mlist$y)]),
                            ")")
    if (type == 'class') {
      fit <- apply(fit, 1, which.max)
    }

    quants <- if (type == 'prob') {
      aperm(apply(pred, 2:3, function(q) {
        quantile(plogis(q), probs = quantiles, na.rm  = TRUE)
      }), c(2, 1, 3))
    }
  } else {
    if (object$analysis_type %in% 'coxph') {
      X <- X[, -1, drop = FALSE]
    }
    if (ncol(X) == 0)
      stop('Prediction without covariates is currently not possible.', call. = FALSE)

    pred <- sapply(1:nrow(X), function(i) MCMC[, colnames(X),
                                               drop = FALSE] %*% X[i, ])

    if (object$analysis_type %in% 'coxph') {
      pred <- pred - mean(c(pred))
    }

    fit <- if (type == 'response' | type == 'risk' & object$analysis_type == 'coxph') {
      if (object$analysis_type == 'survreg') {
        colMeans(family(object)$linkinv(pred, MCMC[, 'shape_time']))
      } else if (family(object)$family == 'poisson') {
        round(colMeans(family(object)$linkinv(pred)))
      } else {
        colMeans(family(object)$linkinv(pred))
      }
    } else {
      colMeans(pred)
    }

    quants <- if (type == 'response' | type == 'risk' & object$analysis_type == 'coxph') {
      if (object$analysis_type == 'survreg') {
        t(apply(pred, 2, function(q) {
          quantile(family(object)$linkinv(q, MCMC[, 'shape_time']),
                   probs = quantiles, na.rm  = TRUE)
        }))
      } else {
        t(apply(pred, 2, function(q) {
          quantile(family(object)$linkinv(q), probs = quantiles, na.rm  = TRUE)
        }))
      }
    } else {
      t(apply(pred, 2, quantile, quantiles, na.rm  = TRUE))
    }
  }


  dat <- as.data.frame(cbind(newdata, fit))
  if (length(dim(quants)) <= 2 & !is.null(quants))
    dat <- cbind(dat, quants)

  on.exit(options(op))
  return(list(dat = dat, fit = fit, quantiles = quants))
}
