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
    thin <- thin(object$MCMC)

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
      t(sapply(strsplit(gsub(paste0(pat, '|\\[|\\]'), '', Ds), ","), as.numeric))
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


# used in get_subset() (2020-06-10)
get_aux <- function(object) {
  # obtain names of auxiliary variables from a JointAI object and replace
  # facors with the corresponding dummy variables
  # - object: object of class JointAI

  aux <- object$Mlist$auxvars

  unlist(sapply(if (!is.null(object$Mlist$auxvars))
    attr(terms(aux), 'term.labels'),
    function(x)
      if (x %in% names(object$Mlist$refs))
        attr(object$Mlist$refs[[x]], 'dummies')
    else x
  ))
}



# used in print.summary.JointAI(), print.JointAI() and list_models() (2020-06-11)
print_type <- function(x) {
  # collection of model titles to be printed at the start of the summary of
  # each sub-model
  # - x: model type

  a <- switch(x,
              lm = "Linear model",
              glm = "Generalized linear model",
              lme = "Linear mixed model",
              glmm = 'Generalized linear mixed model',
              glme = 'Generalized linear mixed model',
              coxph = 'Cox proportional hazards model',
              survreg = 'Weibull survival model',
              clm = 'Cumulative logit model',
              clmm = 'Cumulative logit mixed model',
              mlogit = "Multinomial logit model",
              mlogitmm = "Multinomial logit mixed model",
              JM = "Joint survival and longitudinal model"
  )
  return(a)
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
