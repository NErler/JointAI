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
#' mod <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#'
#' # generate a dataframe with varying "C2" and reference values for all other variables in the model
#' newDF <- predDF(mod, var = "C2")
#'
#' head(newDF)
#'
#' @export

predDF <- function(...) {
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

  vals <- sapply(allvars, function(k) {
    if (k %in% var) {
      if (is.factor(dat[, k])) {
        unique(na.omit(dat[, k]))
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
#' Calculates the expected outcome value for a given set of covariate values
#' and an object of class 'JointAI', and corresponding 2.5\% and 97.5\% (or other
#' quantiles) credible intervals.
#' @inheritParams summary.JointAI
#' @param newdata new dataset for prediction
#' @param quantiles quantiles of the predicted distribution of the outcome
#' @param random should the random effects be used to generate subject specific predictions?
#' @param n.iter number of iterations used when random effects have to be sampled
#'               (for new subjects or when they were not monitored in the original model)
#'
#' @details A \code{model.matrix} \eqn{X} is created from the model formula (fixed
#'          effects only) and \code{newdata}. \eqn{X\beta} is then calculated for
#'          each iteration of the MCMC sample in \code{object}, i.e., \eqn{X\beta}
#'          has \code{n.iter} rows and \code{nrow(newdata)} columns.
#'          A subset of the MCMC sample can be selected using \code{start},
#'          \code{end} and  \code{thin}.
#'
#' @return A list with entries "fit" and "quantiles", where
#'         "fit" contains the column means of \eqn{X\beta} (see details)
#'         and "quantiles" contain the specified quantiles (by default 2.5\%
#'         and 97.5\%) of each column of \eqn{X\beta}.
#' @seealso \code{\link{predDF.JointAI}}, \code{\link{lme_imp}}, \code{\link{glm_imp}},
#'           \code{\link{lm_imp}}
#'
#' @section Note:
#' \itemize{
#' \item For repeated measures models prediction is performed on fixed effects only.
#' \item Prediction is performed on the scale of the linear predictor.
#' }
#' Functionality will be extended in the future.
#'
#' @examples
#' # fit model
#' mod <- lm_imp(y ~ C1 + C2 + I(C2^2), data = wideDF, n.iter = 100)
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
#' matplot(newDF$C2, t(pred$quantiles), lty = 2, add = TRUE, type = "l", col = 1)
#'

#' @export
predict.JointAI <- function(object, newdata, quantiles = c(0.025, 0.975),
                            random = NULL, n.iter = 1,
                            start = NULL, end = NULL, thin = NULL,
                            exclude_chains = NULL, mess = TRUE, adj = 1,  ...) {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  MCMC <- prep_MCMC(object, start = start, end = end, thin = thin,
                    subset = c(analysis_main = TRUE, ranef = TRUE),
                    exclude_chains = exclude_chains,
                    mess = mess, ...)


  op <- options(na.action = 'na.pass',  # change option to keep missing values
                contrasts = rep("contr.treatment", 2))

  if (!is.null(object$random)) {
    mfZ <- model.frame(remove_grouping(object$random), object$data)
    mtZ <- attr(mfZ, "terms")
    # Z <- model.matrix(mtZ, data = newdata)

    idvar <- extract_id(object$random)
  } else {
    random <- NULL
  }

  mfX <- model.frame(object$fixed, object$data)
  mtX <- attr(mfX, "terms")

  options(op)

  if (is.null(random)) {
    X <- model.matrix(mtX, data = newdata, na.action = na.pass)
    if (!"(Intercept)" %in% object$Mlist$names_main)
      X <- X[, -1, drop = FALSE]

    pred <- sapply(1:nrow(X),
                   function(i) MCMC[, colnames(X), drop = FALSE] %*% X[i, ])
    fit <- colMeans(pred)
    quantiles <- apply(pred, 2, quantile, quantiles)
    dat <- as.data.frame(cbind(newdata, fit, t(quantiles)))
    smpl_list <- acceptance <- NULL
  } else {
    if (any(unique(newdata[, idvar]) %in% object$data[, idvar])) {
      # if the subject was in the original data, use the random effects from that model
      ndl <- split(newdata, newdata[, idvar])

      datlist <- smpl_list <- list()
      acceptance <- numeric()
      for(x in names(ndl)) {
        group <- unique(object$data_list$groups[which(object$data[, idvar] == x)])

        X <- model.matrix(mtX, data = ndl[[x]])
        Z <- model.matrix(mtZ, data = ndl[[x]])
        Xl <- X[, object$Mlist$names_main$Xl, drop = FALSE]
        Xil <- X[, object$Mlist$names_main$Xil, drop = FALSE]

        if (x %in% object$data[, idvar] &
            any(grepl(paste0('^b\\[', group, ",[[:digit:]]+\\]"),
                      colnames(MCMC)))) {

          ranefs <- MCMC[, grep(paste0('^b\\[', group, ",[[:digit:]]+\\]"),
                                colnames(MCMC))] %*% t(Z) +
            MCMC[, colnames(Xl), drop = FALSE] %*% t(Xl) +
            MCMC[, colnames(Xil), drop = FALSE] %*% t(Xil)

          ranef_summary <- rbind(
            fit = colMeans(ranefs),
            apply(ranefs, 2, quantile, quantiles)
          )
        } else {
          rf_smpl <- ranef_sample(object, ndl[[x]], start = start,
                                  end = end, thin = thin,
                                  exclude_chains = exclude_chains,
                                  warn = warn, mess = mess,
                                  n.iter = n.iter, adj = adj)
          ranefs <- as.matrix(rf_smpl$sample) %*% t(Z) +
            MCMC[, colnames(Xl), drop = FALSE] %*% t(Xl) +
            MCMC[, colnames(Xil), drop = FALSE] %*% t(Xil)

          ranef_summary <- rbind(
            fit = colMeans(ranefs),
            apply(ranefs, 2, quantile, quantiles)
          )
          acceptance <- c(acceptance, mean(rf_smpl$acceptance))
          names(acceptance)[length(acceptance)] <- x
          smpl_list[[x]] <- cbind(it = 1:nrow(rf_smpl$sample), rf_smpl$sample)
        }
        datlist[[x]] <- cbind(ndl[[x]], t(ranef_summary))
      }
      dat <- do.call(rbind, datlist)
    }
    fit <- NULL
    quantiles <- NULL
  }
  return(list(dat = dat, fit = fit, quantiles = quantiles,
              acceptance = acceptance, smpl = smpl_list))
}



# predict.JointAI <- function(object, newdata, quantiles = c(0.025, 0.975),
#                             start = NULL, end = NULL, thin = NULL,
#                             exclude_chains = NULL, mess = TRUE, ...) {
#   if (!inherits(object, "JointAI"))
#     stop("Use only with 'JointAI' objects.\n")
#
#   MCMC <- prep_MCMC(object, start = start, end = end, thin = thin, subset = NULL,
#                     exclude_chains = exclude_chains,
#                     mess = mess, ...)
#
#
#   mf <- model.frame(object$fixed, object$data)
#   mt <- attr(mf, "terms")
#
#   oldop <- getOption("contrasts")
#   options(contrasts = rep("contr.treatment", 2))
#   X <- model.matrix(mt, data = newdata)
#   options(contrasts = oldop)
#
#   pred <- sapply(1:nrow(X), function(i) MCMC[, colnames(X), drop = FALSE] %*% X[i, ])
#
#   fit <- colMeans(pred)
#   quantiles <- apply(pred, 2, quantile, quantiles)
#
#   return(list(dat = as.data.frame(cbind(newdata, fit, t(quantiles))),
#               fit = fit, quantiles = quantiles))
# }
#

