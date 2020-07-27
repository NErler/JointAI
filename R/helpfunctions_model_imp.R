
make_filename <- function(modeldir, modelname, keep_model, overwrite, mess) {
  # create the model file name, either using a temporary name or values
  # provided by the user
  # - modeldir: optional path
  # - modelname: optional name of the file
  # - keep_model: logical; should the model be kept after MCMC sampling?
  #   otherwise the file will be deleted
  # - overwrite: logical: if a file with the name and path exists, should it
  #   be overwritten?

  # generate default name for model file if not specified
  if (is.null(modeldir)) modeldir <- tempdir()
  if (is.null(modelname)) {
    modelname <- paste0("JointAI_jagsmodel_",
                        format(Sys.time(), "%Y-%m-%d_%H-%M"),
                        "_", sample.int(1.0e6, 1L), ".R")
  } else {
    keep_model <- TRUE
  }
  modelfile <- file.path(modeldir, modelname)


  if (file.exists(modelfile) & is.null(overwrite)) {
    # This warning can not be switched off by warn = FALSE, because an input
    # is required.
    warnmsg("The file %s already exists in %s.",
            dQuote(modelname), dQuote(modeldir))

    reply <- menu(c("yes", "no"),
                  title = "\nDo you want me to overwrite this file?")

    if (reply == 1L) {
      if (mess) msg("The modelfile was overwritten.")
      overwrite <- TRUE
    } else {
      overwrite <- FALSE
      if (mess) msg("The old model will be used.")
    }

    if (mess)
      msg("To skip this question in the future, set %s or %s.",
          dQuote("overwrite = TRUE"), dQuote("overwrite = FALSE"))
  }

  attr(modelfile, "overwrite") <- overwrite
  attr(modelfile, "keep_model") <- keep_model

  modelfile
}




get_initial_values <- function(inits, seed, n_chains, warn) {
  # check if initial values are supplied or should be generated

  oldseed <- .Random.seed
  on.exit({
    .Random.seed <<- oldseed
  })

  if (is.null(inits)) {
    inits <- get_rng(seed, n_chains)

  } else {
    # if initial values are supplied, but they are not a function nor a list,
    # give a warning and do not use them
    if (!(is.null(inits) | inherits(inits, c("function", "list")))) {
      if (warn)
        warnmsg("The object supplied to %s could not be recognized.
              Initial values are set by JAGS.", sQuote("inits"))
      inits <- get_rng(seed, n_chains)

    } else {

      if (inherits(inits, "function")) {
        # if the initial values are supplied as a function, evaluate the
        # function
        if (!is.null(seed)) {
          set_seed(seed)
        }
        inits <- replicate(n_chains, inits(), simplify = FALSE)
      }

      # if initial values are supplied as a list, or were evaluated from a
      # function to a list, check if there are random number generator values
      # specified
      if (inherits(inits, "list")) {
        if (!any(c(".RNG.name", ".RNG.seed") %in% unlist(lapply(inits, names))))
          inits <- Map(function(inits, rng) c(inits, rng),
                       inits = inits,
                       rng = get_rng(seed, n_chains))
      }
    }
  }
  inits
}
