# used in various output/summary functions (2020-06-11)
prep_MCMC <- function(object, start = NULL, end = NULL, thin = NULL,
                      subset = NULL, exclude_chains = NULL, warn = TRUE,
                      mess = TRUE, ...) {
  # general processing of the MCMC sample for various output functions;
  # creating a subset of the sample wrt iterations, chains and parameters
  # - object: an object of class JointAI
  # - start: first iteration to be used
  # - end: last iteration to be used
  # - thin: thinning to be applied
  # - subset: subset of parameters (columns of the mcmc object) to be used
  # - exclude_chains: optional vector of numbers, indexing MCMC chains to be
  #                   excluded from the output
  # - warn: logical, should warning messages be displayed?
  # - mess: logical, should messages be displayed?


  # set start, end and thin (or use values from MCMC sample)
  if (is.null(start)) {
    start <- start(object$MCMC)
  } else {
    start <- max(start, start(object$MCMC))
  }

  if (is.null(end)) {
    end <- end(object$MCMC)
  } else {
    end <- min(end, end(object$MCMC))
  }

  if (is.null(thin))
    thin <- coda::thin(object$MCMC)

  # obtain subset of parameters of the MCMC samples
  MCMC <- get_subset(object, subset, warn = warn, mess = mess)

  # exclude chains, if set by user
  chains <- seq_along(MCMC)
  if (!is.null(exclude_chains)) {
    chains <- chains[-exclude_chains]
  }

  # restrict MCMC sample to selected iterations and chains
  MCMC <- do.call(rbind,
                  window(MCMC[chains],
                         start = start,
                         end = end,
                         thin = thin))
  return(MCMC)
}



# used in print.JointAI() (2020-06-10)
get_Dmat <- function(object, varname) {
  # Return the posterior mean of the random effects variance matrices in
  # matrix form (one matrix per grouping level)
  # - object: object of class JointAI
  # - varname: name of the outcome of the sub-model

    MCMC <- prep_MCMC(object, start = NULL, end = NULL, thin = NULL,
                      subset = NULL, exclude_chains = NULL, warn = TRUE,
                      mess = TRUE)


    pat <- sapply(names(object$Mlist$group_lvls), function(lvl)
      paste0("^D_", varname, "_", lvl))

    # find the right column names in the MCMC sample matrix
    Ds <- sapply(pat, function(p)
      grep(paste0(p, "\\[[[:digit:]]+,[[:digit:]]+\\]"),
           colnames(MCMC), value = TRUE),
      simplify = FALSE)

    Dpos <- mapply(function(pat, Ds) {
      t(sapply(strsplit(gsub(paste0(pat, "|\\[|\\]"), "", Ds), ","),
               as.numeric))
    }, pat = pat, Ds = Ds)

    Dmat <- lapply(remove_grouping(object$random[[varname]]), function(r) {
      term <- terms(r)
      dimnam <- c(if (attr(term, 'intercept') == 1) "(Intercept)",
                  attr(term, 'term.labels'))

      matrix(nrow = length(dimnam), ncol = length(dimnam),
             dimnames = list(dimnam, dimnam))
    })

    for (i in names(Dmat)) {
      for (k in seq_along(Ds[[i]])) {
        Dmat[[i]][Dpos[[i]][k, 1], Dpos[[i]][k, 2]] <- mean(MCMC[, Ds[[i]][k]])
      }
      Dmat[[i]][is.na(Dmat[[i]])] <- t(Dmat[[i]])[is.na(Dmat[[i]])]
    }


  Dmat
}



# used in print.summary.JointAI(), print.JointAI(), list_models() (2020-06-18)
print_type <- function(type, family = NULL, upper = FALSE) {
  # collection of model titles to be printed at the start of the summary of
  # each sub-model
  # - type: model type
  # - family: family in case of a (extended) exponential family model

  a <- switch(type,
              # lm = "Linear model",
              glm = switch(family,
                           gaussian = 'linear model',
                           binomial = 'binomial model',
                           Gamma = 'Gamma model',
                           poisson = 'poisson model',
                           lognorm = 'log-normal model',
                           beta = 'beta model'
              ),
              # lme = "Linear mixed model",
              glmm = switch(family,
                            gaussian = 'linear mixed model',
                            binomial = 'binomial mixed model',
                            Gamma = 'Gamma mixed model',
                            poisson = 'poisson mixed model',
                            lognorm = 'log-normal mixed model',
                            beta = 'beta mixed model'
                            ),
              # glme = 'Generalized linear mixed model',
              coxph = 'proportional hazards model',
              survreg = 'weibull survival model',
              clm = 'cumulative logit model',
              clmm = 'cumulative logit mixed model',
              mlogit = "multinomial logit model",
              mlogitmm = "multinomial logit mixed model",
              JM = "joint survival and longitudinal model"
  )

  if (upper)
    substr(a, 1, 1) <- toupper(substr(a, 1, 1))
  a
}



# used in summary() (2020-06-10)
get_intercepts <- function(stats, varname, lvls) {
  # format the output for the intercepts in ordinal models
  # - stats: matrix of posterior summaries
  # - varname: name of the ordinal outcome variable
  # - lvls: levels of the ordinal factor

  interc <-   stats[grep(paste0("gamma_", varname), rownames(stats)), ]
  rownames(interc) <- paste(varname, "\u2264", lvls[-length(lvls)])
  interc
}


# used in summary() (2020-06-10)
computeP <- function(x) {
  # calculate tail probability
  # - x: vector of MCMC samples for one parameter

  above <- mean(x > 0)
  below <- mean(x < 0)
  2 * min(above, below)
}
