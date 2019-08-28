#' Plot an object object inheriting from class 'JointAI'
#'
#' @param x object inheriting from class 'JointAI'
#' @param ... currently not used
#'
#' @examples
#' mod <- lm_imp(y ~ C1 + C2 + B1, data = wideDF, n.iter = 100)
#' plot(mod)
#'
#' @export
plot.JointAI <- function(x, ...) {
  if (!inherits(x, "JointAI"))
    stop("Use only with objects of class JointAI.")

  if (!x$analysis_type %in% c('lm', 'lme', 'glm', 'glme'))
    stop(gettextf('At the moment there is not plotting method implemented for a %s model of type %s.',
         dQuote("JointAI"), dQuote(x$analysis_type)), call. = FALSE)

  l.fit <- if (x$analysis_type %in% c('glm', 'glme'))  {
    "Predicted values"
  } else {"Fitted values"}

  fit <- predict(x)$fit
  r <- residuals(x)

  plot(fit, r, xlab = l.fit,
       ylab = "Residuals", main = 'Residuals vs Fitted'
       # ylim = ylim, type = "n"
  )
  panel.smooth(fit, r,
               iter = ifelse(x$analysis_type %in% c('glm', 'glmer'), 0, 3))
  abline(h = 0, lty = 3, col = "gray")
}



#' @export
family.JointAI <- function(object, ...) {
  eval(
    parse(text = paste0(attr(object$analysis_type, 'family'),
                        "(link = ",
                        attr(object$analysis_type, 'link'), ")")))
}


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
#' summary(residuals(mod, type = 'response'))
#' summary(residuals(mod, type = 'working'))
#'
#'
#' @export
residuals.JointAI <- function(object,
                              type = c('deviance', 'response', 'working'), ...) {
  type <- match.arg(type)

  if (object$analysis_type %in% c('survreg') & type %in% c('working', 'deviance'))
    stop(gettextf("Residuals of type %s are not implemented for a JointAI model of type %s. Currently only residuals of type %s are available for parametric survival models.",
                  dQuote(type), dQuote(object$analysis_type), dQuote('response')),
         call. = FALSE)

  if (object$analysis_type %in% c('coxph', 'clm', 'clmm'))
    stop(gettextf("Residuals are not yet implemented for a JointAI model of type %s.",
                  dQuote(object$analysis_type)), call. = FALSE)

  # r <- object$residuals
  y <- object$data_list[[names(object$Mlist$y)]]
  mu <- object$fitted.values
  wts <- rep(1, length(mu))

  if (object$analysis_type == 'survreg') {
    MCMC <- prep_MCMC(object, ...)
  }



  res <- switch(type,
                working = (y - mu)/family(object)$mu.eta(predict(object, type = 'link')$fit),
                response = y - mu,
                deviance = sqrt(pmax((family(object)$dev.resids)(y, mu, wts), 0)) * ifelse(y > mu, 1, -1)
  )
  return(res)
}

