#' Add samples to an object of class JointAI
#'
#' Allows to continue sampling from an existing object of class 'JointAI'.
#' When the original sample was created using parallel computation, the
#' separate 'jags' objects will be recompiled and sampling will again be
#' performed in parallel.
#'
#' @inheritParams sharedParams
#' @inheritParams model_imp
#' @param add logical; should the new MCMC samples be added to the existing
#'            samples or replace them? If samples are added, \code{thin} and
#'            \code{var.names} are ignored.
#'
#' @seealso
#' \code{\link{lm_imp}}, \code{\link{glm_imp}}, \code{\link{lme_imp}}, \code{\link{clm_imp}}
#' \code{\link{glme_imp}}, \code{\link{clmm_imp}}, \code{\link{survreg_imp}},
#' \code{\link{coxph_imp}}
#'
#' The vignette \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}
#' contains some examples how to specify the argument \code{monitor_params}.
#'
#' @export
#'
#' @examples
#' # Example 1:
#' # Run an initial JointAI model:
#' mod <- lm_imp(y~C1 + C2 + M2, data = wideDF, n.iter = 100)
#'
#' # Continue sampling:P
#' mod_add <- add_samples(mod, n.iter = 200, add = TRUE)
#'
#'
#' # Example 2:
#' # Continue sampling, but additionally sample imputed values.
#' # Note: Setting different parameters to monitor than in the original model
#' # requires add = FALSE.
#' imps <- add_samples(mod, n.iter = 200, monitor_params = c("imps" = TRUE),
#'                     add = FALSE)
#'

add_samples <- function(object, n.iter, add = TRUE, thin = NULL,
                        monitor_params = NULL, progress.bar = "text", mess = TRUE) {
  if (!inherits(object, "JointAI"))
    stop("Use only with 'JointAI' objects.\n")

  if (is.null(thin))
    thin <- object$mcmc_settings$thin


  if (is.null(monitor_params)) {
    var.names <- object$mcmc_settings$variable.names
  } else {
    var.names <- do.call(get_params, c(list(models = object$models,
                                            analysis_type = object$analysis_type,
                                            family = attr(object$analysis_type, "family"),
                                            Mlist = object$Mlist,
                                            imp_par_list = object$imp_par_list,
                                            ppc = object$Mlist$ppc),
                                       monitor_params))
  }

  if (!identical(var.names, object$mcmc_settings$variable.names) & add == TRUE)
    stop("The provided parameters to monitor do not match the monitored parameters in the original JointAI object.")

  t0 <- Sys.time()
  if (object$mcmc_settings$parallel) {
    ncores <- object$mcmc_settings$ncores
    cl <- parallel::makeCluster(ncores,
                                type = ifelse(grepl('linux', R.Version()$platform),
                                              'FORK', 'PSOCK'))
    doParallel::registerDoParallel(cl)

    if (mess)
      message(paste0("Parallel sampling on ", ncores, " cores started."))
    res <- foreach::`%dopar%`(foreach::foreach(i = seq_along(object$model)),
                              run_samples(object$model[[i]], n.iter = n.iter, var.names = var.names)
    )

    parallel::stopCluster(cl)
    mcmc <- as.mcmc.list(lapply(res, function(x) x$mcmc[[1]]))
    adapt <- lapply(res, function(x) x$adapt)
  } else {
    mcmc <- rjags::coda.samples(object$model, variable.names = var.names,
                                n.iter = n.iter, thin = thin,
                                na.rm = FALSE, progress.bar = progress.bar)
  }
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
                                  unlist(object$Mlist$names_main), object$Mlist$trafos)
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
                                   function(k) mcmc(rbind(object$MCMC[[k]],
                                                          MCMC[[k]]),
                                                    start = start(object$MCMC),
                                                    end = end(object$MCMC) +
                                                      niter(mcmc[[k]]))
    ))

  } else {
    new <- mcmc
    newMCMC <- MCMC
  }

  newobject <- object
  newobject$sample <- new
  newobject$MCMC <- newMCMC
  newobject$call <- list(object$call, match.call())
  newobject$mcmc_settings$n.iter <- ifelse(add, c(object$mcmc_settings$n.iter, niter(new)), niter(new))
  newobject$mcmc_settings$variable.names <- var.names
  newobject$mcmc_settings$thin <- ifelse(add, c(object$mcmc_settings$thin, thin(new)), thin(new))
  newobject$time <- ifelse(add, object$time + difftime(t1, t0), difftime(t1, t0))
  newobject$model <- if (object$mcmc_settings$parallel) {adapt} else {object$model}

  return(newobject)
}
