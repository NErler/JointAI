#' Continue sampling from an object of class JointAI
#'
#' This function continues the sampling from the MCMC chains of an existing
#' object of class 'JointAI'.\cr
#' If the original sample was created using parallel computation, the
#' separate 'JAGS' objects will be recompiled and sampling will again be
#' performed in parallel.
#'
#' @inheritParams sharedParams
#' @inheritParams model_imp
#' @param n.iter the number of additional iterations of the MCMC chain
#' @param add logical; should the new MCMC samples be added to the existing
#'            samples (\code{TRUE}; default) or replace them?
#'            If samples are added the arguments \code{monitor_params} and
#'            \code{thin} are ignored.
#' @param monitor_params named list or vector specifying which parameters should
#'                       be monitored. For details, see
#'                       \code{\link[JointAI:model_imp]{*_imp}} and the vignette
#'                        \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}.
#'                        Ignored when \code{add = TRUE}.
#' @param thin thinning interval (see \code{\link[coda]{window.mcmc}});
#'             ignored when \code{add = TRUE}.
#'
#'
#'
#'
#' @seealso
#' \code{\link[JointAI:model_imp]{*_imp}}
#'
#' The vignette
#' \href{https://nerler.github.io/JointAI/articles/SelectingParameters.html}{Parameter Selection}
#' contains some examples on how to specify the argument \code{monitor_params}.
#'
#' @export
#'
#' @examples
#' # Example 1:
#' # Run an initial JointAI model:
#' mod <- lm_imp(y ~ C1 + C2, data = wideDF, n.iter = 100)
#'
#' # Continue sampling:
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
                        monitor_params = NULL, progress.bar = "text",
                        mess = TRUE) {

  if (!inherits(object, "JointAI"))
    errormsg("Use only with 'JointAI' objects.")


  if (is.null(thin)) {
    thin <- object$mcmc_settings$thin[length(object$mcmc_settings$thin)]
  } else {
    if (add & thin != object$mcmc_settings$thin) {
      thin <- object$mcmc_settings$thin[length(object$mcmc_settings$thin)]

      if (mess)
        msg("When adding samples (%s) the thinning interval cannot be
           changed. I will use the setting of the existing object
          (%s).", dQuote("add = TRUE"), dQuote(paste0("thin = ", thin)))
    }
  }

  if (is.null(monitor_params)) {
    var.names <- object$mcmc_settings$variable.names
  } else {
    var.names <- do.call(get_params,
                         c(list(Mlist = get_Mlist(object),
                                info_list = object$info_list,
                                data = object$data, mess = mess),
                           monitor_params))
  }


  if (!identical(var.names, object$mcmc_settings$variable.names) & add)
    errormsg("When %s it is not possible to monitor different parameters than
             were monitored in the original model.", dQuote("add = TRUE"))

  t0 <- Sys.time()
  if (object$mcmc_settings$parallel) {
    n.cores <- object$mcmc_settings$n.cores
    cl <- parallel::makeCluster(n.cores,
                                type = ifelse(grepl('linux',
                                                    R.Version()$platform),
                                              'FORK', 'PSOCK'))
    doParallel::registerDoParallel(cl)

    if (mess)
      msg("Parallel sampling on %s cores started (%s).", n.cores, Sys.time())

    res <- foreach::`%dopar%`(foreach::foreach(i = seq_along(object$model)),
                              run_samples(object$model[[i]], n.iter = n.iter,
                                          thin = thin, var.names = var.names)
    )

    parallel::stopCluster(cl)
    mcmc <- coda::as.mcmc.list(lapply(res, function(x) x$mcmc[[1]]))
    adapt <- lapply(res, function(x) x$adapt)
  } else {
    mcmc <- rjags::coda.samples(object$model, variable.names = var.names,
                                n.iter = n.iter, thin = thin,
                                progress.bar = progress.bar)
  }
  t1 <- Sys.time()



  MCMC <- mcmc

  if (!all(sapply(object$Mlist$scale_pars, is.null))) {
    coefs <- try(get_coef_names(object$info_list))
    for (k in seq_len(length(MCMC))) {
      MCMC[[k]] <- coda::as.mcmc(
        rescale(MCMC[[k]], coefs = do.call(rbind, coefs),
                scale_pars = do.call(rbind, unname(object$Mlist$scale_pars)),
                object$info_list))
      attr(MCMC[[k]], 'mcpar') <- attr(mcmc[[k]], 'mcpar')
    }
  }

  if (isTRUE(add)) {
    newmcmc <- if (!is.null(object$sample)) {
      coda::as.mcmc.list(
        lapply(seq_len(length(mcmc)),
               function(x) mcmc(rbind(object$sample[[x]],
                                      mcmc[[x]]),
                                start = start(object$sample),
                                end = end(object$sample) +
                                  coda::niter(mcmc[[x]])
               )
        ))
    }

    newMCMC <- coda::as.mcmc.list(
      lapply(seq_len(length(MCMC)), function(k)
        mcmc(rbind(object$MCMC[[k]], MCMC[[k]]),
             start = start(object$MCMC),
             end = end(object$MCMC) + coda::niter(mcmc[[k]]) * thin(mcmc[[k]]),
             thin = thin(mcmc[[k]]))
      ))
  } else {
    newmcmc <- mcmc
    newMCMC <- MCMC
  }

  newobject <- object
  newobject$sample <- newmcmc
  newobject$MCMC <- newMCMC
  newobject$call <- list(object$call, match.call())
  newobject$mcmc_settings$variable.names <- var.names
  newobject$model <- if (object$mcmc_settings$parallel) {
    adapt
    } else {object$model}

  # add/set new argument values n.iter and thin to/in JointAI object
  newobject$mcmc_settings$n.iter <- c(object$mcmc_settings$n.iter, n.iter)

  newobject$mcmc_settings$thin <- c(object$mcmc_settings$thin,
                                    coda::thin(newMCMC))

  # add computational time to JointAI object
  newobject$time <- c(object$time, difftime(t1, t0))

  return(newobject)
}
