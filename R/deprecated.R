
# This internal function was used up until JointAI version 1.0.3 to determine
# whether a parallel future is specified in the current work session. From
# version 1.0.4 this is no longer needed (and probably this is also not how
# one should work with parallel futures...). This function is only kept in here
# because its removal would break the reverse-dependent "remiod" package.

get_future_info <- function(mess = TRUE) {

  if (mess) {
    msg("The function %s is deprecated and will be removed in future versions
        of JointAI.", dQuote("get_future_info()"))
  }

  oplan <- future::plan(future::sequential)
  theplan <- attr(oplan[[1L]], "call")
  future::plan(oplan)
  strategies <- vapply(oplan, function(o) {
    setdiff(class(o), c("tweaked", "function"))[1L]
  }, FUN.VALUE = character(1L))
  if (length(strategies) > 1L) {
    warnmsg("There is a list of future strategies.\n            I will use the first element, %s.",
            strategies[1L])
  }
  list(strategy = strategies[1L], parallel = !strategies[1L] %in%
         c("sequential", "transparent"), workers = formals(oplan[[1L]])$workers,
       call = theplan)

}



run_seq <- function(n_adapt, n_iter, n_chains, inits, thin = 1L,
                    data_list, var_names, modelfile, quiet = TRUE,
                    progress_bar = "text", mess = TRUE, warn = TRUE, ...) {


  if (mess) {
    msg("The function %s is deprecated and will be removed in future versions
        of JointAI.", dQuote("run_seq()"))
  }

  adapt <- if (any(n_adapt > 0L, n_iter > 0L)) {
    if (warn == FALSE) {
      suppressWarnings({
        try(rjags::jags.model(file = modelfile, data = data_list,
                              inits = inits, quiet = quiet,
                              n.chains = n_chains, n.adapt = n_adapt))
      })
    } else {
      try(rjags::jags.model(file = modelfile, data = data_list,
                            inits = inits, quiet = quiet,
                            n.chains = n_chains, n.adapt = n_adapt))
    }
  }
  mcmc <- if (n_iter > 0L & !inherits(adapt, "try-error")) {
    if (mess == FALSE) {
      sink(tempfile())
      on.exit(sink())
      force(suppressMessages(
        try(rjags::coda.samples(adapt, n.iter = n_iter, thin = thin,
                                variable.names = var_names,
                                progress.bar = progress_bar))
      ))
    } else {
      try(rjags::coda.samples(adapt, n.iter = n_iter, thin = thin,
                              variable.names = var_names,
                              progress.bar = progress_bar))

    }
  }

  list(adapt = adapt, mcmc = mcmc)
}
