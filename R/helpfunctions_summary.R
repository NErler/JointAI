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


#' Extract the random effects variance covariance matrix
#' Returns the posterior mean of the variance-covariance matrix/matrices of
#' the random effects in a fitted JointAI object.
#'
#' @inheritParams sharedParams
#' @param outcome optional; vector of integers giving the indices of the
#'                outcomes for which the random effects variance-covariance
#'                matrix/matrices should be returned.
#' @export
rd_vcov <- function(object, outcome = NULL, start = NULL, end = NULL,
                    thin = NULL,
                    exclude_chains = NULL, mess = TRUE, warn = TRUE) {


  vars <- if (is.null(outcome)) {
    names(object$coef_list)
  } else {
    names(object$coef_list)[outcome]
  }

  rd_vcov_list <- nlapply(vars, function(varname) {
    get_Dmat(object, varname, start = start, end = end, thin = thin,
             exclude_chains = exclude_chains, mess = mess, warn = warn)
  })

  if (length(rd_vcov_list) == 1L) {
    rd_vcov_list[[1]]
  } else {
    rd_vcov_list
  }
}



# used in print.JointAI() (2020-06-10)
get_Dmat <- function(object, varname, start = NULL, end = NULL, thin = NULL,
                     exclude_chains = NULL, mess = TRUE, warn = TRUE) {
  # Return the posterior mean of the random effects variance matrices in
  # matrix form (one matrix per grouping level)
  # - object: object of class JointAI
  # - varname: name of the outcome of the sub-model

    MCMC <- prep_MCMC(object, start = start, end = end, thin = thin,
                      subset = NULL, exclude_chains = exclude_chains,
                      warn = warn, mess = mess)


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

    contr_list <- lapply(object$Mlist$refs, attr, "contr_matrix")

    Dmat <- lapply(remove_grouping(object$random[[varname]]), function(r) {
      term <- terms(r)

      dimnam <- colnames(
        model.matrix(r, object$data,
                     contrasts.arg = contr_list[intersect(
                       names(contr_list),
                       sapply(attr(term, "variables")[-1], deparse,
                              width.cutoff = 500)
                     )]
        ))

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
get_intercepts <- function(stats, varname, lvls, rev = FALSE) {
  # format the output for the intercepts in ordinal models
  # - stats: matrix of posterior summaries
  # - varname: name of the ordinal outcome variable
  # - lvls: levels of the ordinal factor

  interc <- stats[grep(paste0("gamma_", varname), rownames(stats)), ,
                  drop = FALSE]
  attr(interc, "rownames_orig") <- rownames(interc)

  if (isTRUE(rev)) {
    rownames(interc) <- paste(varname, "\u2264", lvls[-length(lvls)])
  } else {
    rownames(interc) <- paste(varname, ">", lvls[-length(lvls)])
  }
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
