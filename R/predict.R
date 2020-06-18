#' Create a new dataframe for prediction
#'
#' Build a \code{data.frame} for prediction, where one variable
#' varies and all other variables are set to the reference value (median for
#' continuous variables).
#'
#' @inheritParams model_imp
#' @inheritParams sharedParams
#' @param vars name of variable that should be varying
#' @param length number of values used in the sequence when \code{vars} is continuous
#' @param outcome vector of variable names or numbers identifying for which
#'                outcome(s) the prediction should be performed.
#' @param ... optional, additional arguments (currently not used)
#'
#' @seealso \code{\link{predict.JointAI}}, \code{\link{lme_imp}}, \code{\link{glm_imp}},
#'           \code{\link{lm_imp}}
#' @examples
#' # fit a JointAI model
#' mod <- lm_imp(y ~ C1 + C2 + M2, data = wideDF, n.iter = 100)
#'
#' # generate a data frame with varying "C2" and reference values for all other variables in the model
#' newDF <- predDF(mod, vars = ~ C2)
#'
#' head(newDF)
#'
#' @export

predDF <- function(object, ...) {
  UseMethod("predDF")
}


#' @rdname predDF
#' @export
predDF.JointAI <- function(object, vars, outcome = 1, length = 100, ...) {

  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  predDF(formulas = c(object$fixed[[outcome]],
                      object$random[[outcome]],
                      object$auxvars,
                      if (!is.null(object$Mlist$timevar))
                          as.formula(paste0("~", object$Mlist$timevar))
  ),
  dat = object$data, vars = vars,
  length = length, idvar = object$Mlist$idvar, ...)
}


# @rdname predDF
# @export
predDF.formula <- function(formula, dat, vars, length = 100, ...) {
  if (!inherits(formula, "formula"))
    stop("Use only with 'formula' objects.\n")

  predDF(formulas = check_formula_list(formula), dat = dat, vars = vars,
         length = length, ...)
}

# @rdname predDF
# @export
predDF.list <- function(formulas, dat, vars, length = 100, idvar = NULL, ...) {

  id_vars <- extract_id(vars, warn = FALSE)
  varying <- all_vars(vars)

  if (is.null(idvar))
    idvar <- 'id'

  allvars <- all_vars(formulas)

  if (any(!varying %in% allvars)) {
    stop(paste0(varying , "was not used in the model formula."))
  }

  vals <- sapply(allvars, function(k) {
    if (k %in% varying) {
      if (is.factor(dat[, k])) {
        if (k %in% names(list(...))) {
          list(...)[[k]]
        } else {
          unique(na.omit(dat[, k]))
        }
      } else {
        if (k %in% names(list(...))) {
          list(...)[[k]]
        } else {
          seq(min(dat[, k], na.rm = TRUE),
              max(dat[, k], na.rm = TRUE), length = length)
        }
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

  ndf <- expand.grid(vals)

  if (!is.null(id_vars)) {
    id_df <- unique(subset(ndf, select = id_vars))
    id_df[, idvar] <- 1:nrow(id_df)
    ndf <- merge(subset(ndf, select = !names(ndf) %in% idvar),
                 id_df)
  }
  ndf
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
#' @param outcome vector of variable names or numbers identifying for which
#'        outcome(s) the prediction should be performed.
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
#' newDF <- predDF(mod, vars = ~ C2)
#'
#' # obtain predicted values
#' pred <- predict(mod, newdata = newDF)
#'
#' # plot predicted values and 95% confidence band
#' matplot(newDF$C2, pred$fitted, lty = c(1, 2, 2), type = "l", col = 1,
#' xlab = 'C2', ylab = 'predicted values')
#'

#' @export
predict.JointAI <- function(object, outcome = 1, newdata, quantiles = c(0.025, 0.975),
                            type = 'lp',
                            start = NULL, end = NULL, thin = NULL,
                            exclude_chains = NULL, mess = TRUE, warn = TRUE, ...) {


  if (!inherits(object, "JointAI")) errormsg("Use only with 'JointAI' objects.")

  if (any(sapply(object$info_list, "[[", "modeltype") %in%
          c('glmm', 'clmm', 'mlogitmm')) & warn) {
    warnmsg("Prediction for multi-level models is currently only possible on
            the population level (not using random effects).")
  }

  if (missing(newdata)) {
    newdata <- object$data
  } else {
    newdata <- convert_variables(data = newdata,
                                 allvars = unique(c(all_vars(object$fixed),
                                                    all_vars(object$random),
                                                    all_vars(object$auxvars))),
                                 mess = FALSE,
                                 data_orig = object$data)
  }


  MCMC <- prep_MCMC(object, start = start, end = end, thin = thin,
                    subset = FALSE, exclude_chains = exclude_chains,
                    mess = mess, ...)


  if (length(type) == 1 & length(outcome == 1)) {
    types <- setNames(rep(type, length(object$fixed)),
                      names(object$fixed))
  } else {
    if (any(!names(type) %in% names(object$fixed))) {
      errormsg('When %s is a named vector, the names must match outcome
               variables, i.e., %s.', dQuote('type'),
               dQuote(names(object$fixed)))


    }
    types <- setNames(rep(type, length(object$fixed)),
                      names(object$fixed))
    types[names(type)] <- type
  }

  preds <- sapply(names(object$fixed)[outcome], function(varname) {
    predict_fun <- switch(object$info_list[[varname]]$modeltype,
                          glm = predict_glm,
                          glmm = predict_glm,
                          clm = predict_clm,
                          clmm = predict_clm,
                          survreg = predict_survreg,
                          coxph = predict_coxph,
                          JM = predict_coxph
    )
    if (!is.null(predict_fun)) {
      predict_fun(formula = object$fixed[[varname]],
                  newdata = newdata, type = types[varname], data = object$data,
                  MCMC = MCMC, varname = varname,
                  Mlist = get_Mlist(object), srow = object$data_list$srow,
                  coef_list = object$coef_list, info_list = object$info_list,
                  quantiles = quantiles, mess = mess,
                  contr_list = lapply(object$Mlist$refs, attr, 'contr_matrix'))
    } else {
      if (warn)
        warnmsg("Prediction is not yet implemented for a model of type %s.",
                dQuote(object$info_list[[varname]]$modeltype))
    }
  },  simplify = FALSE)


  list(
    newdata = if (length(preds) == 1) cbind(newdata, preds[[1]])
    else cbind(newdata, unlist(preds, recursive = FALSE)),
    fitted = if (length(preds) == 1) preds[[1]] else preds
  )
}


predict_glm <- function(formula, newdata, type = c("link", "response", "lp"),
                        data, MCMC, varname, coef_list, info_list,
                        quantiles = c(0.025, 0.975), mess = TRUE,
                        contr_list, ...) {

  type <- match.arg(type)

  if (type == "lp")
    type <- "link"

  linkinv <- if (info_list[[varname]]$family %in%
                 c('gaussian', 'binomial', 'Gamma', 'poisson')) {
    get(info_list[[varname]]$family)(link = info_list[[varname]]$link)$linkinv
  } else if (info_list[[varname]]$family %in% 'lognorm') {
    gaussian(link = 'log')$linkinv
  } else if (info_list[[varname]]$family %in% 'beta') {
    plogis
  }

  coefs <- coef_list[[varname]]

  mf <- model.frame(as.formula(paste(formula[-2], collapse = " ")),
                    data, na.action = na.pass)
  mt <- attr(mf, "terms")

  op <- options(na.action = na.pass)

  X <- model.matrix(mt, data = newdata,
                    contrasts.arg = contr_list[intersect(names(contr_list),
                                                         all_vars(mt))])


  if (mess & any(is.na(X)))
    msg('Note: Prediction for cases with missing covariates is not yet implemented.
        I will report %s instead of predicted values for those cases.',
        dQuote('NA'), exdent = 6)


  # linear predictor values for the selected iterations of the MCMC sample
  pred <- sapply(1:nrow(X), function(i)
    MCMC[, coefs$coef[match(colnames(X), coefs$varname)],
         drop = FALSE] %*% X[i, ])

  # fitted values: mean over the (transformed) predicted values
  fit <- if (type == 'response') {
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
                            quantiles = c(0.025, 0.975), mess = TRUE,
                            contr_list, ...) {

  type <- match.arg(type)

  if (type == "link")
    type <- "lp"

  if (type == "linear")
    type <- "lp"

  coefs <- coef_list[[varname]]

  mf <- model.frame(as.formula(paste(formula[-2], collapse = " ")),
                    data, na.action = na.pass)
  mt <- attr(mf, "terms")

  op <- options(na.action = na.pass)
  X <- model.matrix(mt, data = newdata,
                    contrasts.arg = contr_list[intersect(names(contr_list),
                                                         all_vars(mt))])


  if (mess & any(is.na(X)))
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



predict_coxph <- function(Mlist, coef_list, MCMC, newdata, data, info_list,
                          type = c("lp", "risk", "expected", "survival"),
                          varname, quantiles = c(0.025, 0.975),
                          srow = NULL, mess = TRUE, contr_list,  ...) {
  type <- match.arg(type)

  coefs <- coef_list[[varname]]

  survinfo <- get_survinfo(info_list, Mlist)[varname]


  # timevar <- Mlist$outcomes$outnams[[varname]][1]
  resp_mat <- info_list[[varname]]$resp_mat[2]
  surv_lvl <- survinfo[[1]]$surv_lvl
  surv_colnames <- names(Mlist$outcomes$outcomes[[varname]])

  mf <- model.frame(as.formula(paste(Mlist$fixed[[varname]][-2], collapse = " ")),
                    data, na.action = na.pass)
  mt <- attr(mf, "terms")


  op <- options(na.action = na.pass)

  X0 <- model.matrix(mt, data = newdata,
                     contrasts.arg = contr_list[intersect(names(contr_list),
                                                          all_vars(mt))]
  )[, -1, drop = FALSE]

  X <- sapply(names(Mlist$M), function(lvl) {
    X0[, colnames(X0) %in% colnames(Mlist$M[[lvl]]), drop = FALSE]
  }, simplify = FALSE)

  # Xc <- X[, colnames(X) %in% colnames(Mlist$M[[info_list[[varname]]$resp_mat[2]]]), drop = FALSE]

  if (mess & any(is.na(X)))
    message('Prediction for cases with missing covariates is not yet implemented.')

  scale_pars <- do.call(rbind, unname(Mlist$scale_pars))
  if (!is.null(scale_pars)) {
    scale_pars$center[is.na(scale_pars$center)] <- 0
  }

  lp_list <- sapply(X, function(x) {
    sapply(1:nrow(x), function(i)
      if (!is.null(scale_pars)) {
        MCMC[, coefs$coef[match(colnames(x), coefs$varname)], drop = FALSE] %*%
          (x[i, ] - scale_pars$center[match(colnames(x), rownames(scale_pars))])
      } else {
        MCMC[, coefs$coef[match(colnames(x), coefs$varname)], drop = FALSE] %*% x[i, ]
      }
    )
  }, simplify = FALSE)

  lps <- array(unlist(lp_list), dim = c(nrow(lp_list[[1]]),
                                        ncol(lp_list[[1]]),
                                        length(lp_list)),
               dimnames = list(c(), c(), gsub("M_", "", names(lp_list))))


  eta_surv <- if (any(Mlist$group_lvls >= Mlist$group_lvls[gsub("M_", "", resp_mat)])) {
    apply(lps[, , names(which(Mlist$group_lvls >=
                                          Mlist$group_lvls[gsub("M_", "", resp_mat)]))],
        c(1,2), sum)
  } else {0}

  eta_surv_long <- if (any(Mlist$group_lvls < Mlist$group_lvls[gsub("M_", "", resp_mat)])) {
    apply(lps[, , names(which(Mlist$group_lvls <
                              Mlist$group_lvls[gsub("M_", "", resp_mat)]))],
          c(1,2), sum)
  } else {0}

  gkx <- gauss_kronrod()$gkx
  ordgkx <- order(gkx)
  gkw <- gauss_kronrod()$gkw[ordgkx]


  srow <- if (is.null(Mlist$timevar)) {
    1:nrow(Mlist$M[[resp_mat]])
  } else {
    which(Mlist$M$M_lvlone[, Mlist$timevar] ==
            Mlist$M[[resp_mat]][Mlist$groups[[surv_lvl]], survinfo[[1]]$time_name])
  }


  h0knots <- get_knots_h0(nkn = Mlist$df_basehaz - 4,
                          Time = survinfo[[1]]$survtime,
                          event = NULL, gkx = gkx)

  if (type %in% c('expected', 'survival')) {

    Bsh0 <- splines::splineDesign(h0knots,
                                  c(t(outer(newdata[, survinfo[[1]]$time_name]/2, gkx + 1))),
                                  ord = 4, outer.ok = TRUE)

    logh0s <- lapply(1:nrow(MCMC), function(m) {
      matrix(Bsh0 %*% MCMC[m, grep(paste0('\\bbeta_Bh0_', clean_survname(varname), '\\b'), colnames(MCMC))],
             ncol = 15, nrow = nrow(newdata), byrow = TRUE)
    })


    tvpred <- if (any(Mlist$group_lvls < Mlist$group_lvls[gsub("M_", "", resp_mat)])) {
      Mgk <- do.call(rbind,
                      get_Mgk(Mlist, gkx, surv_lvl = gsub("M_", "", resp_mat),
                              survinfo = survinfo, data = newdata, rows = 1:nrow(newdata),
                              td_cox = unique(sapply(survinfo, "[[", "modeltype")) == 'coxph'))

      vars <- coefs$varname[na.omit(match(dimnames(Mgk)[[2]], coefs$varname))]

      lapply(1:nrow(MCMC), function(m) {
        if (!is.null(scale_pars)) {
          matrix((Mgk[, vars, drop = FALSE] -
                    outer(rep(1, prod(dim(Mgk)[-2])),
                          scale_pars$center[match(vars, rownames(scale_pars))])) %*%
                   MCMC[m, coefs$coef[match(vars, coefs$varname)]],
                 nrow = nrow(newdata), ncol = length(gkx))
        } else {
          matrix(Mgk[, vars, drop = FALSE] %*%
                   MCMC[m, coefs$coef[match(vars, coefs$varname)]],
                 nrow = nrow(newdata), ncol = length(gkx))
        }
      })
    } else {
      0
    }

    Surv <- mapply(function(logh0s, tvpred) {
      exp(logh0s + tvpred) %*% gkw
    }, logh0s = logh0s, tvpred = tvpred)

    logSurv <- -exp(t(eta_surv)) * Surv * outer(newdata[, survinfo[[1]]$time_name],
                                                rep(1, nrow(MCMC)))/2

  } else {

    Bh0 <- splines::splineDesign(h0knots, newdata[, survinfo[[1]]$time_name],
                                 ord = 4, outer.ok = TRUE)

    logh0 <- sapply(1:nrow(Bh0), function(i) {
      MCMC[, grep('beta_Bh0', colnames(MCMC))] %*% Bh0[i, ]
    })


    logh <- logh0 + eta_surv + eta_surv_long# <- eta_surv - mean(c(eta_surv))
  }


  # fitted values: mean over the (transformed) predicted values
  fit <- if (type == 'risk') {
    colMeans(exp(logh))
  } else if (type == 'lp') {
    colMeans(logh)
  } else if (type == 'expected') {
    rowMeans(-logSurv)
  } else if (type == 'survival') {
    rowMeans(exp(logSurv))
  }

  # quantiles
  quants <- if (!is.null(quantiles)) {
    if (type == 'risk') {
      t(apply(exp(logh), 2, quantile, quantiles, na.rm  = TRUE))
    } else if (type == 'lp') {
      t(apply(logh, 2, quantile, quantiles, na.rm  = TRUE))
    } else if (type == 'expected') {
      t(apply(-logSurv, 1, quantile, quantiles, na.rm  = TRUE))
    } else if (type == 'survival') {
      t(apply(exp(logSurv), 1, quantile, quantiles, na.rm  = TRUE))
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
                        quantiles = c(0.025, 0.975), mess = TRUE,
                        contr_list, ...) {

  type <- match.arg(type)
  if (type == 'response')
    type <- 'class'

  coefs <- coef_list[[varname]]

  mf <- model.frame(as.formula(paste(formula[-2], collapse = " ")),
                    data, na.action = na.pass)
  mt <- attr(mf, "terms")

  op <- options(na.action = na.pass)
  X <- model.matrix(mt, data = newdata,
                    contrasts.arg = contr_list[intersect(names(contr_list),
                                                         all_vars(mt))]
  )[, -1, drop = FALSE]

  if (mess & any(is.na(X)))
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

  quants <- if (type == 'prob' & !is.null(quantiles)) {
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



fitted_values <- function(object, ...) {

  types <- sapply(names(object$fixed), function(k) {
    switch(object$info_list[[k]]$modeltype,
           glm = 'response',
           glmm = 'response',
           clm = 'prob',
           clmm = 'prob',
           survreg = 'response',
           coxph = 'lp')
  })


  predict(object, quantiles = NULL, type = types, ...)$fitted
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
