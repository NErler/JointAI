#' Plot an object of class JointAI
#'
#' @export
plot.JointAI <- function(x) {
  if (!inherits(x, "JointAI"))
    stop("use only with objects of class JointAI.")

  l.fit <- if (x$analysis_type %in% c('glm', 'glme'))  {
    "Predicted values"
  } else {"Fitted values"}

  plot(x$fitted.values, x$residuals, xlab = l.fit,
       ylab = "Residuals", main = 'Residuals vs Fitted'
       # ylim = ylim, type = "n"
  )
  panel.smooth(x$fitted.values, x$residuals)
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
#' @type type of residuals: deviance, response, working
#' @export
residuals.JointAI <- function(object,
                              type = c('deviance', 'response', 'working'), ...) {
  type <- match.arg(type)
  # r <- object$residuals
  y <- object$data_list[[names(object$Mlist$y)]]
  mu <- object$fitted.values
  wts <- rep(1, length(mu))

  res <- switch(type,
                working = (y - mu)/family(object)$mu.eta(predict(object, type = 'link')$fit),
                response = y - mu,
                deviance = sqrt(pmax((family(object)$dev.resids)(y, mu, wts), 0)) * ifelse(y > mu, 1, -1)
  )
  return(res)
}

