#' Add samples to an object of class JointAI
#'
#' Allows to continue sampling from an existing object of class JointAI
#' @param object object inheriting from class \code{JointAI}
#' @inheritParams model_imp
#' @param add logical; should the new MCMC samples be added to the existing
#'            samples or replace them? If samples are added, \code{thin} and
#'            \code{var.names} are ignored
#' @export
#'
#' @examples
#' \dontrun{
#'
#' mod1 <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#' mod1_add <- add_samples(mod1, n.iter = 200)
#'
#' }

add_samples <- function(object, n.iter, add = T, thin = NULL,
                        monitor_params = NULL,
                        progress.bar = "text") {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  if (is.null(thin))
    thin <- object$mcmc_settings$thin
  if (is.null(monitor_params)) {
    var.names <- object$mcmc_settings$variable.names
  } else {
    var.names <- do.call(get_params, c(list(meth = object$meth,
                                            analysis_type = object$analysis_type,
                                            family = object$family,
                                            y_name = colnames(object$Mlist$y),
                                            Zcols = ncol(object$Mlist$Z),
                                            Xc = object$Mlist$Xc,
                                            Xcat = object$Mlist$Xcat),
                                       monitor_params))
  }

  t0 <- Sys.time()
  mcmc <- rjags::coda.samples(object$model, variable.names = var.names,
                              n.iter = n.iter, thin = thin,
                              na.rm = F, progress.bar = progress.bar)
  t1 <- Sys.time()


  if (add == T) {
    new <- as.mcmc.list(lapply(1:length(mcmc),
                               function(x) mcmc(rbind(object$sample[[x]],
                                                      mcmc[[x]]),
                                                start = start(object$sample),
                                                end = end(object$sample) + niter(mcmc[[x]])
                               )
    ))
  } else {
    new <- mcmc
  }

  newobject <- object
  newobject$sample <- new
  newobject$call <- c(object$call, match.call())
  newobject$mcmc_settings$n.iter <- niter(new)
  newobject$mcmc_settings$variable.names <- var.names
  newobject$mcmc_settings$thin <- thin(new)
  newobject$time <- object$time + difftime(t1, t0)

  return(newobject)
}
