#' Add samples to an object of class JointAI
#'
#' Allows to continue sampling from an existing object of class "JointAI".
#' @inheritParams sharedParams
#' @inheritParams model_imp
#' @param add logical; should the new MCMC samples be added to the existing
#'            samples or replace them? If samples are added, \code{thin} and
#'            \code{var.names} are ignored.
#'
#' @seealso
#' \code{\link{lm_imp}}, \code{\link{glm_imp}}, \code{\link{lme_imp}}
#'
#' The vignette \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}
#' contains some examples how to specify the argument \code{monitor_params}.
#'
#' @export
#'
#' @examples
#' # Example 1:
#' # run an initial JointAI model:
#' mod <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#'
#' # continue sampling
#' mod_add <- add_samples(mod, n.iter = 200, add = TRUE)
#'
#'
#' # Example 2:
#' # continue sampling, but additionally sample imputed values
#' imps <- add_samples(mod, n.iter = 200, monitor_params = c("imps" = TRUE),
#'                     add = FALSE)
#'
#'

add_samples <- function(object, n.iter, add = TRUE, thin = NULL,
                        monitor_params = NULL, progress.bar = "text") {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  if (is.null(thin))
    thin <- object$mcmc_settings$thin


  if (is.null(monitor_params)) {
    var.names <- object$mcmc_settings$variable.names
  } else {
    var.names <- do.call(get_params, c(list(meth = object$meth,
                                            analysis_type = object$analysis_type,
                                            family = attr(object$analysis_type, "family"),
                                            y_name = colnames(object$Mlist$y),
                                            Zcols = ncol(object$Mlist$Z),
                                            Xc = object$Mlist$Xc,
                                            Xcat = object$Mlist$Xcat,
                                            Xtrafo = object$Mlist$Xtrafo,
                                            imp_par_list = object$imp_par_list),
                                       monitor_params))
  }

  if (!identical(var.names, object$mcmc_settings$variable.names) & add == TRUE)
    stop("The provided parameters to monitor do not match the monitored parameters in the original JointAI object.")

  t0 <- Sys.time()
  mcmc <- rjags::coda.samples(object$model, variable.names = var.names,
                              n.iter = n.iter, thin = thin,
                              na.rm = FALSE, progress.bar = progress.bar)
  t1 <- Sys.time()


  coefs <- get_coef_names(object$Mlist, object$K)

  MCMC <- mcmc
  for (k in 1:length(MCMC)) {
    colnames(MCMC[[k]])[na.omit(match(coefs[, 1], colnames(MCMC[[k]])))] <- coefs[, 2]
    if (!is.null(object$scale_pars)) {
      # re-scale parameters
      MCMC[[k]] <- as.mcmc(sapply(colnames(MCMC[[k]]), rescale,
                                  object$Mlist$fixed2,
                                  object$scale_pars,
                                  MCMC[[k]], object$Mlist$refs,
                                  object$Mlist$X2_names, object$Mlist$trafos)
      )
      attr(MCMC[[k]], 'mcpar') <- attr(mcmc[[k]], 'mcpar')
    }
  }

  if (add == TRUE) {
    new <- as.mcmc.list(lapply(1:length(mcmc),
                               function(x) mcmc(rbind(object$sample[[x]],
                                                      mcmc[[x]]),
                                                start = start(object$sample),
                                                end = end(object$sample) + niter(mcmc[[x]])
                               )
    ))

    newMCMC <- as.mcmc.list(lapply(1:length(MCMC),
                                   function(x) mcmc(rbind(object$MCMC[[k]],
                                                          MCMC[[k]]),
                                                    start = start(object$MCMC),
                                                    end = end(object$MCMC) +
                                                      niter(mcmc[[x]]))
    ))

  } else {
    new <- mcmc
    newMCMC <- MCMC
  }

  newobject <- object
  newobject$sample <- new
  newobject$MCMC <- newMCMC
  newobject$call <- c(object$call, match.call())
  newobject$mcmc_settings$n.iter <- niter(new)
  newobject$mcmc_settings$variable.names <- var.names
  newobject$mcmc_settings$thin <- thin(new)
  newobject$time <- object$time + difftime(t1, t0)

  return(newobject)
}
