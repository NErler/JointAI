#' Create a new dataframe for prediction
#'
#' Build a \code{data.frame} for prediction, where one variable
#' varies and all other variables are set to the reference value (median for
#' continuous variables.)
#'
#' @param formula model formula (only fixed effects)
#' @param dat original data
#' @param var name of variable that should be varying
#' @param object object inheriting from class \code{JointAI}
#' @param ... optional, additional arguments (currently not used)
#'
#' @seealso \code{\link{predict.JointAI}}, \code{\link{lme_imp}}, \code{\link{glm_imp}},
#'           \code{\link{lm_imp}}
#' @examples
#' \dontrun{
#' mod1 <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#' newDF <- predDF(mod1)
#' }
#' @export

predDF <- function(...) {
  UseMethod("predDF")
}


#' @rdname predDF
predDF.default <- function(formula, dat, var, ...) {
  allvars <- all.vars(formula)

  vals <- sapply(allvars, function(k) {
    if (k == var) {
      seq(min(dat[, k], na.rm = T),
          max(dat[, k], na.rm = T), length = 100)
    } else {
      if (is.factor(dat[, k])) {
        factor(levels(dat[, k])[1], levels = levels(dat[, k]))
      } else if (is.logical(dat[, k]) | is.character(dat[, k])) {
        factor(levels(as.factor(dat[, k]))[1],
               levels = levels(as.factor(dat[, k])))
      } else if (is.numeric(dat[, k])) {
        median(dat[, k], na.rm = T)
      }
    }
  })
  expand.grid(vals)
}

#' @rdname predDF
#' @export
predDF.JointAI <- function(object, var, ...) {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  predDF(object$fixed, dat = object$data, var = var, ...)
}




#' Predict values from an object of class JointAI
#'
#' Calculates the expected outcome value for a given set of covariate values
#' and an object of class JointAI, and corresponding 2.5\% and 97.5\% (or other
#' quantiles) credible intervals.
#' @inheritParams summary.JointAI
#' @param newdata new dataset for prediction
#' @param quantiles quantiles of the predicted distribution of the outcome
#'
#' @details A \code{model.matrix} $X$ is created from the model formula (fixed
#'          effects only) and \code{newdata}. \eqn{X\beta} is then calculated for
#'          each iteration of the MCMC sample in \code{object}, i.e., \eqn{X\beta}
#'          has \code{n.iter} rows and \code{nrow(newdata)} columns.
#'          A subset of the MCMC sample can be selected using \code{start},
#'          \code{end} and  \code{thin}.
#'
#' @return A list with entries "fit" and "quantiles", where
#'         "fit" contains the column means of \eqn{X\beta} (see details)
#'         and "quantiles" contain the specified quantiles (by default 2.5%
#'         and 97.5%) of each column of \eqn{X\beta}.
#' @seealso \code{\link{predDF.JointAI}}, \code{\link{lme_imp}}, \code{\link{glm_imp}},
#'           \code{\link{lm_imp}}
#'
#' @examples
#' \dontrun{
#' mod1 <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#' newDF <- predDF(mod1, var = "C1")
#' predict(mod1, newdata = newDF)
#' }

#' @export
predict.JointAI <- function(object, newdata, quantiles = c(0.025, 0.975),
                            start = NULL, end = NULL, thin = NULL, ...) {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  if (is.null(start)) {
    start <- start(object$sample)
  } else {
    start <- max(start, start(object$sample))
  }

  if (is.null(end)) {
    end <- end(object$sample)
  } else {
    end <- min(end, end(object$sample))
  }

  if (is.null(thin))
    thin <- thin(object$sample)

  MCMC <- window(object$MCMC,
                 start = start,
                 end = end,
                 thin = thin)


  mf <- model.frame(object$fixed, object$data)
  mt <- attr(mf, "terms")

  oldop <- getOption(contrasts)
  options(contrasts = rep("contr.treatment", 2))
  X <- model.matrix(mt, data = newdata)
  options(contrasts = oldop)

  pred <- sapply(1:nrow(X), function(i) MCMC[, colnames(X)] %*% X[i, ])

  fit <- colMeans(pred)
  quantiles <- apply(pred, 2, quantile, quantiles)

  return(list(fit = fit, quantiles = quantiles))
}
