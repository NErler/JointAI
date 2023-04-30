#' Create a new data frame for prediction
#'
#' Build a \code{data.frame} for prediction, where one variable varies and all
#' other variables are set to the reference value (median for continuous
#' variables).
#'
#' @inheritParams model_imp
#' @inheritParams sharedParams
#' @param vars name of variable that should be varying
#' @param length number of values used in the sequence when \code{vars} is
#'   continuous
#' @param ... optional specification of the values used for some (or all) of the
#'   variables given in \code{vars}
#'
#' @seealso \code{\link{predict.JointAI}}, \code{\link{lme_imp}},
#'   \code{\link{glm_imp}}, \code{\link{lm_imp}}
#' @examples
#' # fit a JointAI model
#' mod <- lm_imp(y ~ C1 + C2 + M2, data = wideDF, n.iter = 100)
#'
#' # generate a data frame with varying "C2" and reference values for all other
#' # variables in the model
#' newDF <- predDF(mod, vars = ~ C2)
#'
#' head(newDF)
#'
#'
#' newDF2 <- predDF(mod, vars = ~ C2 + M2,
#'                  C2 = seq(-0.5, 0.5, 0.25),
#'                  M2 = levels(wideDF$M2)[2:3])
#' newDF2
#'
#' @export

predDF <- function(object, ...) {
  UseMethod("predDF", object)
}


#' @rdname predDF
#' @export
predDF.JointAI <- function(object, vars, length = 100L, ...) {

  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  predDF.list(object = c(object$fixed,
                         object$random,
                         object$Mlist$auxvars,
                         if (!is.null(object$Mlist$timevar))
                           as.formula(paste0("~", object$Mlist$timevar))
  ),
  data = object$data, vars = vars,
  length = length, idvar = object$Mlist$idvar, ...)
}


#' @rdname predDF
#' @export
predDF.formula <- function(object, data, vars, length = 100L, ...) {
  if (!inherits(object, "formula"))
    stop("Use only with 'formula' objects.\n")

  predDF(object = check_formula_list(object), data = data, vars = vars,
         length = length, ...)
}

#' @rdname predDF
#' @param idvar optional name of an ID variable
#' @keywords internal
#' @export
predDF.list <- function(object, data, vars, length = 100L, idvar = NULL, ...) {

  id_vars <- extract_id(vars, warn = FALSE)
  varying <- all_vars(vars)

  if (is.null(idvar))
    idvar <- "id"

  allvars <- all_vars(object)

  if (any(!varying %in% allvars)) {
    errormsg("%s was not used in the model formula.", varying)
  }

  vals <- nlapply(allvars, function(k) {
    if (k %in% varying) {
      if (is.factor(data[, k])) {
        if (k %in% names(list(...))) {
          list(...)[[k]]
        } else {
          unique(na.omit(data[, k]))
        }
      } else {
        if (k %in% names(list(...))) {
          list(...)[[k]]
        } else {
          seq(min(data[, k], na.rm = TRUE),
              max(data[, k], na.rm = TRUE), length = length)
        }
      }
    } else {
      if (is.factor(data[, k])) {
        factor(levels(data[, k])[1L], levels = levels(data[, k]))
      } else if (is.logical(data[, k]) | is.character(data[, k])) {
        factor(levels(as.factor(data[, k]))[1L],
               levels = levels(as.factor(data[, k])))
      } else if (is.numeric(data[, k])) {
        median(data[, k], na.rm = TRUE)
      }
    }
  })

  ndf <- expand.grid(vals)

  if (!is.null(id_vars)) {
    id_df <- unique(subset(ndf, select = id_vars))
    id_df[, idvar] <- seq_len(nrow(id_df))
    ndf <- merge(subset(ndf, select = !names(ndf) %in% idvar),
                 id_df)
  }
  ndf
}






#' Predict values from an object of class JointAI
#'
#' Obtains predictions and corresponding credible intervals from an object of
#' class 'JointAI'.
#' @inheritParams summary.JointAI
#' @param newdata optional new dataset for prediction. If left empty, the
#'   original data is used.
#' @param quantiles quantiles of the predicted distribution of the outcome
#' @param type the type of prediction. The default is on the scale of the linear
#'   predictor (\code{"link"} or \code{"lp"}). Additionally, for generalized
#'   linear (mixed) models (incl. beta and log-normal) \code{type = "response"}
#'   transforms the predicted values to the scale of the response, and for
#'   ordinal and multinomial (mixed) models \code{type} may be \code{"prob"} (to
#'   obtain probabilities per class), \code{"class"} to obtain the class with
#'   the highest posterior probability, or \code{"lp"}. For parametric survival
#'   models \code{type} can be \code{"lp" } or "response", and for proportional
#'   hazards survival models the options are \code{"lp"}, \code{"risk"} (=
#'   \code{exp(lp)}), \code{"survival"} or \code{"expected"} (=
#'   \code{-log(survival)}).
#' @param outcome vector of variable names or integers identifying for which
#'   outcome(s) the prediction should be performed.
#' @param return_sample logical; should the full sample on which the summary
#'                      (mean and quantiles) is calculated be returned?#'
#' @details A \code{model.matrix} \eqn{X} is created from the model formula
#'   (currently fixed effects only) and \code{newdata}. \eqn{X\beta} is then
#'   calculated for each iteration of the MCMC sample in \code{object}, i.e.,
#'   \eqn{X\beta} has \code{n.iter} rows and \code{nrow(newdata)} columns. A
#'   subset of the MCMC sample can be selected using \code{start}, \code{end}
#'   and  \code{thin}.
#'
#' @return A list with entries \code{dat}, \code{fit} and \code{quantiles},
#'   where \code{fit} contains the predicted values (mean over the values
#'   calculated from the iterations of the MCMC sample), \code{quantiles}
#'   contain the specified quantiles (by default 2.5% and 97.5%), and \code{dat}
#'   is \code{newdata}, extended with \code{fit} and \code{quantiles} (unless
#'   prediction for an ordinal outcome is done with \code{type = "prob"}, in
#'   which case the quantiles are an array with three dimensions and are
#'   therefore not included in \code{dat}).
#'
#' @seealso \code{\link{predDF.JointAI}}, \code{\link[JointAI:model_imp]{*_imp}}
#'
#' @section Note: \itemize{ \item So far, \code{predict} cannot calculate
#'   predicted values for cases with missing values in covariates. Predicted
#'   values for such cases are \code{NA}. \item For repeated measures models
#'   prediction currently only uses fixed effects. } Functionality will be
#'   extended in the future.
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
predict.JointAI <- function(object, outcome = 1L, newdata,
                            quantiles = c(0.025, 0.975),
                            type = "lp",
                            start = NULL, end = NULL, thin = NULL,
                            exclude_chains = NULL, mess = TRUE,
                            warn = TRUE, return_sample = FALSE, ...) {


  if (!inherits(object, "JointAI")) errormsg("Use only with 'JointAI' objects.")

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


  if (length(type) == 1L & length(outcome == 1L)) {
    types <- setNames(rep(type, length(object$fixed)),
                      names(object$fixed))
  } else {
    if (any(!names(type) %in% names(object$fixed))) {
      errormsg("When %s is a named vector, the names must match outcome
               variables, i.e., %s.", dQuote("type"),
               dQuote(names(object$fixed)))


    }
    types <- setNames(rep(type, length(object$fixed)),
                      names(object$fixed))
    types[names(type)] <- type
  }

  preds <- lapply(names(object$fixed)[outcome], function(varname) {

    if (!is.null(object$info_list[[varname]]$hc_list) & warn) {
      warnmsg("Prediction in multi-level settings currently only takes into
               account the fixed effects, i.e., assumes that the random effect
               realizations are equal to zero.")
    }

    predict_fun <- switch(object$info_list[[varname]]$modeltype,
                          glm = predict_glm,
                          glmm = predict_glm,
                          clm = predict_clm,
                          mlogit = predict_mlogit,
                          clmm = predict_clm,
                          mlogitmm = predict_mlogit,
                          survreg = predict_survreg,
                          coxph = predict_coxph,
                          JM = predict_jm
    )
    if (!is.null(predict_fun)) {
      predict_fun(formula = object$fixed[[varname]],
                  newdata = newdata, type = types[varname], data = object$data,
                  MCMC = MCMC, varname = varname,
                  Mlist = get_Mlist(object), srow = object$data_list$srow,
                  coef_list = object$coef_list, info_list = object$info_list,
                  quantiles = quantiles, mess = mess, warn = warn,
                  contr_list = lapply(object$Mlist$refs, attr, "contr_matrix"),
                  return_sample = return_sample)
    } else {
      errormsg("Prediction is not yet implemented for a model of type %s.",
               dQuote(object$info_list[[varname]]$modeltype))
    }
  })
  names(preds) <- names(object$fixed)[outcome]

  pred_df <- nlapply(preds, "[[", "res_df")
  sample <- nlapply(preds, "[[", "sample")

  outlist <- list(
    newdata = if (length(preds) == 1L) {
      cbind(newdata, pred_df[[1L]])

    } else {
      cbind(newdata, unlist(pred_df, recursive = FALSE))
    },
    fitted = if (length(preds) == 1L)  {
      pred_df[[1L]]
    } else {
      pred_df
    },
    sample = if (length(preds) == 1L)  {
      sample[[1L]]
    } else {
      sample
    }
  )
  Filter(Negate(is.null), outlist)
}


predict_glm <- function(formula, newdata, type = c("link", "response", "lp"),
                        data, MCMC, varname, coef_list, info_list,
                        quantiles = c(0.025, 0.975), warn = TRUE,
                        contr_list, Mlist, return_sample = FALSE, ...) {

  type <- match.arg(type)

  if (type == "lp")
    type <- "link"

  linkinv <- if (info_list[[varname]]$family %in%
                 c("gaussian", "binomial", "Gamma", "poisson")) {
    get(info_list[[varname]]$family)(link = info_list[[varname]]$link)$linkinv
  } else if (info_list[[varname]]$family %in% "lognorm") {
    gaussian(link = "log")$linkinv
  } else if (info_list[[varname]]$family %in% "beta") {
    plogis
  }

  coefs <- coef_list[[varname]]

  scale_pars <- if (attr(terms(formula), "intercept") == 0L) {
    scale_pars <- do.call(rbind, unname(Mlist$scale_pars))
    if (!is.null(scale_pars)) {
      scale_pars$center[is.na(scale_pars$center)] <- 0L
    }
    scale_pars
  }


  mf <- model.frame(as.formula(paste(formula[-2L], collapse = " ")),
                    data, na.action = na.pass)
  mt <- attr(mf, "terms")

  op <- options(na.action = na.pass)

  desgn_mat <- model.matrix(mt, data = newdata,
                            contrasts.arg = contr_list[intersect(
                              names(contr_list),
                              cvapply(attr(mt, "variables")[-1L], deparse,
                                      width.cutoff = 500L)
                            )]
  )


  if (warn & any(is.na(desgn_mat)))
    warnmsg("Prediction for cases with missing covariates is not yet
        implemented.
        I will report %s instead of predicted values for those cases.",
        dQuote("NA"), exdent = 6L)


  # linear predictor values for the selected iterations of the MCMC sample
  pred <- calc_lp(
    regcoefs = MCMC[, coefs$coef[match(colnames(desgn_mat),
                                       coefs$varname)], drop = FALSE],
    design_mat = desgn_mat,
    scale_pars)

  # fitted values: mean over the (transformed) predicted values
  fit <- if (type == "response") {
    if (info_list[[varname]]$family == "poisson") {
      round(colMeans(linkinv(pred)))
    } else {
      colMeans(linkinv(pred))
    }
  } else {
    colMeans(pred)
  }

  # quantiles
  quants <- if (!is.null(quantiles)) {
    if (type == "response") {
      t(apply(pred, 2L, function(q) {
        quantile(linkinv(q), probs = quantiles, na.rm  = TRUE)
      }))
    } else {
      t(apply(pred, 2L, quantile, quantiles, na.rm  = TRUE))
    }
  }

  sample <- if (return_sample) {
    s <- if (type == "response") {
      if (info_list[[varname]]$family == "poisson") {
        round(linkinv(pred))
      } else {
        linkinv(pred)
      }
    } else {
      pred
    }
    s <- melt_data.frame(cbind(newdata, t(s)), id.vars = names(newdata))
    names(s) <- gsub("^variable$", "iteration", names(s))
    s
  }

  on.exit(options(op))

  res_df <- if (!is.null(quantiles)) {
    cbind(data.frame(fit = fit),
          as.data.frame(quants))
  } else {
    data.frame(fit = fit)
  }

  list(res_df = res_df, sample = sample)
}



predict_survreg <- function(formula, newdata, type = c("response", "link",
                                                       "lp",
                                                       "linear"),
                            data, MCMC, varname, coef_list, info_list,
                            quantiles = c(0.025, 0.975), warn = TRUE,
                            contr_list, return_sample = FALSE, ...) {

  type <- match.arg(type)

  if (type == "link")
    type <- "lp"

  if (type == "linear")
    type <- "lp"

  coefs <- coef_list[[varname]]

  mf <- model.frame(as.formula(paste(formula[-2L], collapse = " ")),
                    data, na.action = na.pass)
  mt <- attr(mf, "terms")

  op <- options(na.action = na.pass)
  desgn_mat <- model.matrix(mt, data = newdata,
                            contr_list[intersect(
                              names(contr_list),
                              cvapply(attr(mt, "variables")[-1L], deparse,
                                      width.cutoff = 500L)
                            )]
  )


  if (warn & any(is.na(desgn_mat)))
    warnmsg("Prediction for cases with missing covariates is not yet
            implemented.")


  # linear predictor values for the selected iterations of the MCMC sample
  pred <- vapply(seq_len(nrow(desgn_mat)), function(i) {
    MCMC[, coefs$coef[match(colnames(desgn_mat), coefs$varname)],
         drop = FALSE] %*% desgn_mat[i, ]
  }, FUN.VALUE = numeric(nrow(MCMC)))

  # fitted values: mean over the (transformed) predicted values
  fit <- if (type == "response") {
    colMeans(exp(pred))
  } else {
    colMeans(pred)
  }

  # quantiles
  quants <- if (!is.null(quantiles)) {
    if (type == "response") {
      t(apply(pred, 2L, function(q) {
        quantile(exp(q), probs = quantiles, na.rm  = TRUE)
      }))
    } else {
      t(apply(pred, 2L, quantile, quantiles, na.rm  = TRUE))
    }}

  sample <- if (return_sample) {
    s <- if (type == "response") {
      exp(pred)
    } else {
      pred
    }
    s <- melt_data.frame(cbind(newdata, t(s)), id.vars = names(newdata))
    names(s) <- gsub("^variable$", "iteration", names(s))
    s
  }

  on.exit(options(op))

  res_df <- if (!is.null(quantiles)) {
    cbind(data.frame(fit = fit),
          as.data.frame(quants))
  } else {
    data.frame(fit = fit)
  }

  list(res_df = res_df, sample = sample)
}



predict_coxph <- function(Mlist, coef_list, MCMC, newdata, data, info_list,
                          type = c("lp", "risk", "expected", "survival"),
                          varname, quantiles = c(0.025, 0.975),
                          srow = NULL, warn = TRUE, contr_list,
                          return_sample = FALSE, ...) {
  type <- match.arg(type)

  coefs <- coef_list[[varname]]

  survinfo <- get_survinfo(info_list, Mlist)[varname]


  resp_mat <- info_list[[varname]]$resp_mat[2L]
  surv_lvl <- survinfo[[1L]]$surv_lvl

  mf <- model.frame(as.formula(paste(Mlist$fixed[[varname]][-2L],
                                     collapse = " ")),
                    data, na.action = na.pass)
  mt <- attr(mf, "terms")


  op <- options(na.action = na.pass)

  desgn_mat_sub <- model.matrix(mt, data = newdata,
                                contr_list[intersect(
                                  names(contr_list),
                                  cvapply(attr(mt, "variables")[-1L], deparse,
                                          width.cutoff = 500L)
                                )]
  )[, -1L, drop = FALSE]

  desgn_mat <- setNames(lapply(names(Mlist$M), function(lvl) {
    desgn_mat_sub[, colnames(desgn_mat_sub) %in% colnames(Mlist$M[[lvl]]),
                  drop = FALSE]
  }), names(Mlist$M))


  if (warn & any(is.na(desgn_mat)))
    warnmsg("Prediction for cases with missing covariates is not yet
            implemented.")

  scale_pars <- do.call(rbind, unname(Mlist$scale_pars))
  if (!is.null(scale_pars)) {
    scale_pars$center[is.na(scale_pars$center)] <- 0L
  }

  lp_list <- lapply(desgn_mat, function(x) {
    if (!is.null(scale_pars)) {
      MCMC[, coefs$coef[match(colnames(x), coefs$varname)], drop = FALSE] %*%
        (t(x) - scale_pars$center[match(colnames(x), rownames(scale_pars))])
    } else {
      t(x) %*% MCMC[, coefs$coef[match(colnames(x), coefs$varname)],
                    drop = FALSE]
    }
  })


  eta_surv <- if (any(Mlist$group_lvls >=
                      Mlist$group_lvls[gsub("M_", "", resp_mat)])) {

    lvls <- names(which(Mlist$group_lvls >=
                          Mlist$group_lvls[gsub("M_", "", resp_mat)]))

    Reduce(function(x1, x2) x1 + x2,
           lp_list[paste0("M_", lvls)])

  } else {
    0L
  }

  eta_surv_long <- if (any(Mlist$group_lvls <
                           Mlist$group_lvls[gsub("M_", "", resp_mat)]) &
                       survinfo[[1L]]$haslong) {

    lvls <- names(which(Mlist$group_lvls <
                          Mlist$group_lvls[gsub("M_", "", resp_mat)]))

    Reduce(function(x1, x2) x1 + x2,
           lp_list[paste0("M_", lvls)])

  } else {
    0L
  }

  gkx <- gauss_kronrod()$gkx
  ordgkx <- order(gkx)
  gkw <- gauss_kronrod()$gkw[ordgkx]


  srow <- if (is.null(Mlist$timevar)) {
    seq_len(nrow(Mlist$M[[resp_mat]]))
  } else {
    which(Mlist$M$M_lvlone[, Mlist$timevar] ==
            Mlist$M[[resp_mat]][Mlist$groups[[surv_lvl]],
                                survinfo[[1L]]$time_name])
  }


  h0knots <- get_knots_h0(nkn = Mlist$df_basehaz - 4L,
                          Time = survinfo[[1L]]$survtime,
                          event = NULL, gkx = gkx)

  if (type %in% c("expected", "survival")) {

    Bsh0 <-
      splines::splineDesign(h0knots,
                            c(t(outer(newdata[, survinfo[[1L]]$time_name] / 2L,
                                      gkx + 1L))),
                            ord = 4L, outer.ok = TRUE)

    mcmc_cols <- grep(paste0("\\bbeta_Bh0_", clean_survname(varname), "\\b"),
                      colnames(MCMC))

    logh0s <- lapply(seq_len(nrow(MCMC)), function(m) {
      matrix(Bsh0 %*% MCMC[m, mcmc_cols],
             ncol = 15L, nrow = nrow(newdata), byrow = TRUE)
    })


    tvpred <- if (any(Mlist$group_lvls <
                      Mlist$group_lvls[gsub("M_", "", resp_mat)]) &
                  survinfo[[1L]]$haslong) {
      mat_gk <- do.call(rbind,
                        get_matgk(Mlist, gkx, surv_lvl = gsub("M_", "", resp_mat),
                                  survinfo = survinfo, data = newdata,
                                  rows = seq_len(nrow(newdata)),
                                  td_cox = unique(
                                    cvapply(survinfo, "[[", "modeltype")
                                  ) == "coxph"))

      vars <- coefs$varname[na.omit(match(dimnames(mat_gk)[[2L]], coefs$varname))]

      lapply(seq_len(nrow(MCMC)), function(m) {
        if (!is.null(scale_pars)) {
          matrix((mat_gk[, vars, drop = FALSE] -
                    outer(rep(1L, prod(dim(mat_gk)[-2L])),
                          scale_pars$center[match(vars,
                                                  rownames(scale_pars))])) %*%
                   MCMC[m, coefs$coef[match(vars, coefs$varname)]],
                 nrow = nrow(newdata), ncol = length(gkx))
        } else {
          matrix(mat_gk[, vars, drop = FALSE] %*%
                   MCMC[m, coefs$coef[match(vars, coefs$varname)]],
                 nrow = nrow(newdata), ncol = length(gkx))
        }
      })
    } else {
      0L
    }

    surv <- Map(function(logh0s, tvpred) {
      exp(logh0s + tvpred) %*% gkw
    }, logh0s = logh0s, tvpred = tvpred)

    log_surv <- -exp(t(eta_surv)) * do.call(cbind, surv) *
      outer(newdata[, survinfo[[1L]]$time_name],
            rep(1L, nrow(MCMC))) / 2L

  } else {

    Bh0 <- splines::splineDesign(h0knots, newdata[, survinfo[[1L]]$time_name],
                                 ord = 4L, outer.ok = TRUE)

    logh0 <- vapply(seq_len(nrow(Bh0)), function(i) {
      MCMC[, grep("beta_Bh0", colnames(MCMC))] %*% Bh0[i, ]
    }, FUN.VALUE = numeric(nrow(MCMC)))


    logh <- logh0 + eta_surv + eta_surv_long
  }


  # fitted values: mean over the (transformed) predicted values
  fit <- if (type == "risk") {
    colMeans(exp(logh))
  } else if (type == "lp") {
    colMeans(logh)
  } else if (type == "expected") {
    rowMeans(-log_surv)
  } else if (type == "survival") {
    rowMeans(exp(log_surv))
  }

  # quantiles
  quants <- if (!is.null(quantiles)) {
    if (type == "risk") {
      t(apply(exp(logh), 2L, quantile, quantiles, na.rm  = TRUE))
    } else if (type == "lp") {
      t(apply(logh, 2L, quantile, quantiles, na.rm  = TRUE))
    } else if (type == "expected") {
      t(apply(-log_surv, 1L, quantile, quantiles, na.rm  = TRUE))
    } else if (type == "survival") {
      t(apply(exp(log_surv), 1L, quantile, quantiles, na.rm  = TRUE))
    }
  }


  sample <- if (return_sample) {
    s <- if (type == "risk") {
      exp(logh)
    } else if (type == "lp") {
      logh
    } else if (type == "expected") {
      -log_surv
    } else if (type == "survival") {
      exp(log_surv)
    }
    s <- melt_data.frame(cbind(newdata, t(s)), id.vars = names(newdata))
    names(s) <- gsub("^variable$", "iteration", names(s))
    s
  }

  on.exit(options(op))

  res_df <- if (!is.null(quantiles)) {
    cbind(data.frame(fit = fit),
          as.data.frame(quants))
  } else {
    data.frame(fit = fit)
  }


  list(res_df = res_df, sample = sample)
}


predict_clm <- function(formula, newdata,
                        type = c("prob", "lp", "class", "response"),
                        data, MCMC, varname, coef_list, info_list,
                        quantiles = c(0.025, 0.975), warn = TRUE,
                        contr_list, Mlist, return_sample = FALSE, ...) {

  type <- match.arg(type)

  if (type == "response")
    type <- "class"


  coefs <- coef_list[[varname]]

  scale_pars <- do.call(rbind, unname(Mlist$scale_pars))
  if (!is.null(scale_pars)) {
    scale_pars$center[is.na(scale_pars$center)] <- 0L
  }

  mf <- model.frame(as.formula(paste(formula[-2L], collapse = " ")),
                    data, na.action = na.pass)
  mt <- attr(mf, "terms")

  op <- options(na.action = na.pass)
  desgn_mat <- model.matrix(mt,
                            data = newdata,
                            contrasts.arg = contr_list[intersect(
                              names(contr_list),
                              cvapply(attr(mt, "variables")[-1L], deparse,
                                      width.cutoff = 500L)
                            )]
  )[, -1L, drop = FALSE]

  if (warn & any(is.na(desgn_mat)))
    warnmsg("Prediction for cases with missing covariates is not yet
            implemented.")

  # multiply MCMC sample with design matrix to get linear predictor
  coefs_prop <- coefs[is.na(coefs$outcat) &
                        coefs$varname %in% colnames(desgn_mat), ]
  coefs_nonprop <- coefs[!is.na(coefs$outcat) &
                           coefs$varname %in% colnames(desgn_mat), ]
  coefs_nonprop <- split(coefs_nonprop, coefs_nonprop$outcat)


  eta <- calc_lp(regcoefs = MCMC[, coefs_prop$coef, drop = FALSE],
                 design_mat = desgn_mat[, coefs_prop$varname, drop = FALSE],
                 scale_pars)

  eta_nonprop <- if (length(coefs_nonprop) > 0L) {
    lapply(coefs_nonprop, function(c_np_k) {
      calc_lp(regcoefs = MCMC[, c_np_k$coef, drop = FALSE],
              design_mat = desgn_mat[, c_np_k$varname, drop = FALSE],
              scale_pars = scale_pars)
    })
  }


  gammas <- lapply(
    grep(paste0("gamma_", varname), colnames(MCMC), value = TRUE),
    function(k)
      matrix(nrow = nrow(eta), ncol = ncol(eta),
             data = rep(MCMC[, k], ncol(eta)),
             byrow = FALSE)
  )


  # add the category specific intercepts to the linear predictor
  lp <- lapply(seq_along(gammas), function(k) {
    gammas[[k]] + eta +
      if (is.null(eta_nonprop)) 0L else eta_nonprop[[k]]
  })

  mat1 <- matrix(nrow = nrow(eta), ncol = ncol(eta), data = 1L)
  mat0 <- mat1 * 0L


  if (info_list[[varname]]$rev) {
    names(lp) <- paste0("logOdds(", varname, "<=", seq_along(lp), ")")
    pred <- rev(c(lapply(rev(lp), plogis), list(mat0)))

    probs <- lapply(seq_along(pred)[-1L], function(k) {
      minmax_mat(pred[[k]] - pred[[k - 1L]])
    })

    probs <- c(probs,
               list(
                 1L - minmax_mat(
                   apply(array(dim = c(dim(probs[[1L]]), length(probs)),
                               unlist(probs)), c(1L, 2L), sum)
                 ))
    )
  } else {
    names(lp) <- paste0("logOdds(", varname, ">", seq_along(lp), ")")
    pred <- c(lapply(lp, plogis), list(mat0))

    probs <- lapply(seq_along(pred)[-1L], function(k) {
      minmax_mat(pred[[k - 1L]] - pred[[k]])
    })

    probs <- c(list(
      1L - minmax_mat(
        apply(array(dim = c(dim(probs[[1L]]), length(probs)),
                    unlist(probs)), c(1L, 2L), sum)
      )),
      probs)
  }
  names(probs) <- paste0("P(", varname, "=",
                         levels(data[, varname]),
                         ")")

  if (type == "lp") {
    fit <- lapply(lp, colMeans)
    quants <- if (!is.null(quantiles)) {
      lapply(lp, function(x) {
        t(apply(x, 2L, quantile, probs = quantiles, na.rm = TRUE))
      })
    }
    s <- lp
  } else if (type == "prob") {
    fit <- lapply(probs, colMeans)
    quants <- if (!is.null(quantiles)) {
      lapply(probs, function(x) {
        t(apply(x, 2L, quantile, probs = quantiles, na.rm = TRUE))
      })
    }
    s <- probs
  } else if (type == "class") {
    fit <- apply(do.call(cbind, lapply(probs, colMeans)), 1L,
                 function(x) if (all(is.na(x))) NA else which.max(x))
    quants <- NULL
    s <- NULL
  }

  res_df <- if (!is.null(quants)) {
    res <- Map(function(fit, quants) {
      cbind(fit = fit, quants)
    }, fit = fit, quants = quants)

    array(dim = c(dim(res[[1L]]), length(res)),
          dimnames = list(NULL, colnames(res[[1L]]), names(res)),
          unlist(res))
  } else {
    data.frame(fit, check.names = FALSE)
  }

  sample <- if (return_sample) {
    errormsg("Returning the sample of predicted values is not yet possible for
             a %s.", dQuote("clm(m)"))
    # s <- melt_data.frame(cbind(newdata, t(s)), id.vars = names(newdata))
    # names(s) <- gsub("^variable$", "iteration", names(s))
    # s
  }


  on.exit(options(op))

  list(res_df = res_df, sample = sample)
}




predict_mlogit <- function(formula, newdata,
                           type = c("prob", "lp", "class", "response"),
                           data, MCMC, varname, coef_list, info_list,
                           quantiles = c(0.025, 0.975), warn = TRUE,
                           contr_list, Mlist, return_sample = FALSE, ...) {

  type <- match.arg(type)

  if (type == "response")
    type <- "class"


  coefs <- coef_list[[varname]]

  scale_pars <- do.call(rbind, unname(Mlist$scale_pars))
  if (!is.null(scale_pars)) {
    scale_pars$center[is.na(scale_pars$center)] <- 0L
  }

  mf <- model.frame(as.formula(paste(formula[-2L], collapse = " ")),
                    data, na.action = na.pass)
  mt <- attr(mf, "terms")

  op <- options(na.action = na.pass)
  desgn_mat <- model.matrix(mt,
                            data = newdata,
                            contrasts.arg = contr_list[intersect(
                              names(contr_list),
                              cvapply(attr(mt, "variables")[-1L], deparse,
                                      width.cutoff = 500L)
                            )]
  )

  if (warn & any(is.na(desgn_mat)))
    warnmsg("Prediction for cases with missing covariates is not yet
            implemented.")

  # multiply MCMC sample with design matrix to get linear predictor
  coefs_nonprop <- split(coefs, coefs$outcat)

  etas <- lapply(coefs_nonprop, function(c_np_k) {
    calc_lp(regcoefs = MCMC[, c_np_k$coef, drop = FALSE],
            design_mat = desgn_mat[, c_np_k$varname, drop = FALSE],
            scale_pars = NULL)
  })


  mat0 <- matrix(nrow = nrow(etas[[1L]]), ncol = ncol(etas[[1L]]), data = 0L)
  lp <- c(list(mat0), etas)

  phis <- lapply(lp, exp)
  sum_phis <- apply(array(dim = c(dim(phis[[1L]]), length(phis)),
                          unlist(phis)), c(1L, 2L), sum)

  probs <- lapply(seq_along(phis), function(k) {
    minmax_mat(phis[[k]] / sum_phis)
  })

  names(probs) <- paste0("P(", varname, "=",
                         levels(data[, varname]),
                         ")")

  if (type == "lp") {
    fit <- lapply(lp, colMeans)
    quants <- if (!is.null(quantiles)) {
      lapply(lp, function(x) {
        t(apply(x, 2L, quantile, probs = quantiles, na.rm = TRUE))
      })
    }
    s <- lp
  } else if (type == "prob") {
    fit <- lapply(probs, colMeans)
    quants <- if (!is.null(quantiles)) {
      lapply(probs, function(x) {
        t(apply(x, 2L, quantile, probs = quantiles, na.rm = TRUE))
      })
    }
    s <- probs
  } else if (type == "class") {
    fit <- apply(do.call(cbind, lapply(probs, colMeans)), 1L,
                 function(x) if (all(is.na(x))) NA else which.max(x))
    quants <- NULL
  }

  res_df <- if (!is.null(quants)) {
    res <- Map(function(fit, quants) {
      cbind(fit = fit, quants)
    }, fit = fit, quants = quants)

    array(dim = c(dim(res[[1L]]), length(res)),
          dimnames = list(NULL, colnames(res[[1L]]), names(res)),
          unlist(res))
  } else {
    data.frame(fit, check.names = FALSE)
  }

  sample <- if (return_sample) {
    errormsg("Returning the sample of predicted values is not yet possible for
             a %s or %s.", dQuote("mlogit"), dQuote("mlogitmm"))
    # s <- melt_data.frame(cbind(newdata, t(s)), id.vars = names(newdata))
    # names(s) <- gsub("^variable$", "iteration", names(s))
    # s
  }


  on.exit(options(op))
  list(res_df = res_df, sample = sample)

}



predict_jm <- function(...) {
  errormsg("Prediction is not yet implemented for models for joint models for
           longitudinal and survival data.")
}



fitted_values <- function(object, ...) {

  types <- cvapply(names(object$fixed), function(k) {
    switch(object$info_list[[k]]$modeltype,
           glm = "response",
           glmm = "response",
           clm = "prob",
           clmm = "prob",
           survreg = "response",
           coxph = "lp")
  })


  fit <- predict(object, outcome = seq_along(object$fixed), quantiles = NULL,
                 type = types, ...)$fitted

  if (length(fit) == 1L) {
    c(fit$fit)
  } else {
    lapply(fit, "[[", "fit")
  }
}
