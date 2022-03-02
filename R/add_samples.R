#' Continue sampling from an object of class JointAI
#'
#' This function continues the sampling from the MCMC chains of an existing
#' object of class 'JointAI'.\cr
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

  # check/set settings -----------------------------------------------------
  thin <- check_add_thinning(object = object, thin = thin, add = add,
                             mess = mess)

  var_names <- check_add_varnames(object = object,
                                  monitor_params = monitor_params,
                                  add = add, mess = mess)


  # run mcmc ----------------------------------------------------------------

  jags_res <- run_parallel(n_adapt = NULL, n_iter = n.iter,
                           n_chains = object$mcmc_settings$n.chains,
                           inits = NULL, thin = thin,
                           data_list = NULL, var_names = var_names,
                           modelfile = NULL, quiet = TRUE,
                           progress_bar = progress.bar, mess = mess,
                           warn = TRUE, add_samples = TRUE,
                           models = object$model)
  adapt <- jags_res$adapt
  mcmc <- jags_res$mcmc


  # process MCMC samples --------------------------------------------------------
  MCMC <- mcmc

  if (!all(sapply(object$Mlist$scale_pars, is.null))) {
    coefs <- try(get_coef_names(object$info_list))

    for (k in seq_len(length(MCMC))) {
      MCMC[[k]] <- coda::as.mcmc(
        rescale(MCMC[[k]],
                coefs = do.call(rbind, coefs),
                scale_pars = do.call(rbind, unname(object$Mlist$scale_pars)),
                info_list = object$info_list,
                data_list = object$data_list,
                groups = object$Mlist$groups))

      attr(MCMC[[k]], "mcpar") <- attr(mcmc[[k]], "mcpar")
    }
  }

  # combine with/replace original samples --------------------------------------
  if (isTRUE(add)) {
    newmcmc <- if (!is.null(object$sample)) {
      coda::as.mcmc.list(
        lapply(seq_len(length(mcmc)),
               function(x) coda::mcmc(rbind(object$sample[[x]],
                                            mcmc[[x]]),
                                      start = start(object$sample),
                                      end = end(object$sample) +
                                        coda::niter(mcmc[[x]])
               )
        ))
    }

    newMCMC <- coda::as.mcmc.list(
      lapply(seq_len(length(MCMC)), function(k)
        coda::mcmc(rbind(object$MCMC[[k]], MCMC[[k]]),
                   start = start(object$MCMC),
                   end = end(object$MCMC) + coda::niter(mcmc[[k]]) *
                     coda::thin(mcmc[[k]]),
                   thin = coda::thin(mcmc[[k]]))
      ))
  } else {
    newmcmc <- if (!is.null(object$sample)) mcmc
    newMCMC <- MCMC
  }


  # create new JointAI object --------------------------------------------------
  newobject <- object
  newobject$sample <- newmcmc
  newobject$MCMC <- newMCMC
  newobject$call <- c(object$call, match.call())
  newobject$mcmc_settings$variable.names <- var_names
  newobject$comp_info$parallel <- c(object$comp_info$parallel,
                                  jags_res$parallel)
  newobject$model <- if (isTRUE(jags_res$parallel)) {
    adapt
  } else {
    object$model
  }

  # add/set new argument values n.iter and thin to/in JointAI object
  newobject$mcmc_settings$n.iter <- c(object$mcmc_settings$n.iter, n.iter)

  newobject$mcmc_settings$thin <- c(object$mcmc_settings$thin,
                                    coda::thin(newMCMC))

  # add computational time to JointAI object
  newobject$comp_info$duration <- rbind_duration(
    object$comp_info$duration,
    list("adapt" = jags_res$time_adapt,
         "sample" = jags_res$time_sample))

  return(newobject)
}




check_add_thinning <- function(thin, object, add, mess = TRUE) {

  if (is.null(thin)) {
    thin <- object$mcmc_settings$thin[length(object$mcmc_settings$thin)]
  } else {
    if (add &
        thin != object$mcmc_settings$thin[length(object$mcmc_settings$thin)]) {
      thin <- object$mcmc_settings$thin[length(object$mcmc_settings$thin)]

      if (mess)
        msg("When adding samples (%s) the thinning interval cannot be
           changed. I will use the setting of the existing object
          (%s).", dQuote("add = TRUE"), dQuote(paste0("thin = ", thin)))
    }
  }
  thin
}



check_add_varnames <- function(object, monitor_params, mess = TRUE, add) {

  if (is.null(monitor_params)) {
    var_names <- object$mcmc_settings$variable.names
  } else {
    var_names <- do.call(get_params,
                         c(list(Mlist = get_Mlist(object),
                                info_list = object$info_list,
                                mess = mess),
                           monitor_params))
  }
  if (!identical(var_names, object$mcmc_settings$variable.names) & add)
    errormsg("When %s it is not possible to monitor different parameters than
             were monitored in the original model.", dQuote("add = TRUE"))

  var_names
}
