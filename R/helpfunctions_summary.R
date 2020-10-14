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


get_D_names <- function(params, varname, lvls) {
  nams <- nlapply(lvls, function(lvl) {
    params$coef[
      lvapply(params$outcome, function(x) varname %in% x) &
        grepl(paste0("^D[[:digit:]]*_[", varname, "_]*", lvl, "\\["),
              params$coef)
    ]
  })

  Filter(length, nams)
}


# used in print.JointAI() (2020-06-10)
get_Dmat <- function(object, varname, lvls = "all") {
  # Return the posterior mean of the random effects variance matrices in
  # matrix form (one matrix per grouping level)
  # - object: object of class JointAI
  # - varname: name of the outcome of the sub-model
  # - lvls: vector of the levels for which the D matrix should be returned

  if (lvls == "all") {
    lvls <- object$Mlist$idvar
  }

    MCMC <- prep_MCMC(object, start = NULL, end = NULL, thin = NULL,
                      subset = NULL, exclude_chains = NULL, warn = TRUE,
                      mess = TRUE)

    Ds <- get_D_names(parameters(object), varname = varname, lvls = lvls)

    Dpos <- lapply(Ds, function(d) {
      t(sapply(strsplit(gsub("[[:print:]]+\\[|\\]", "", d), ","),
               as.numeric))
    })

    Dmat <- nlapply(names(Dpos), function(lvl) {
      nam <- get_rdvcov_names(object, varname, lvl)

      m <- matrix(nrow = max(Dpos[[lvl]][, 1]),
                  ncol = max(Dpos[[lvl]][, 2]),
                  dimnames = list(nam$nam, nam$nam))
      structure(m,
                class = "Dmat",
                structure = nam
      )
    })


    for (lvl in names(Dmat)) {
      for (k in seq_along(Ds[[lvl]])) {
        Dmat[[lvl]][Dpos[[lvl]][k, 1],
                    Dpos[[lvl]][k, 2]] <- mean(MCMC[, Ds[[lvl]][k]])
      }
      Dmat[[lvl]][is.na(Dmat[[lvl]])] <- t(Dmat[[lvl]])[is.na(Dmat[[lvl]])]
    }

  Dmat
}


#' @rdname summary.JointAI
#' @export
print.Dmat <- function(x, digits = getOption("digits"),
                       scientific = getOption("scipen"), ...) {

  r <- rbind(c(rep("", 2), attr(x, "structure")$variable),
             c(rep("", 2), colnames(x)),
             cbind(attr(x, "structure")$variable,
                   rownames(x),
                   unname(format(x, digits = digits,
                                 scientific = scientific, ...))
             )
  )

  cat(format_Dmat(r), sep = c(rep(" ",  ncol(r) - 1), "\n"))
}


format_Dmat <- function(r) {
  spaces <- sapply(max(nchar(r)) - nchar(r), function(k) {
    if (k > 0L) {
      paste0(rep(" ", k), collapse = "")
    } else {
      ""
    }
  })
  matrix(nrow = nrow(r), ncol = ncol(r), data = paste0(spaces, r)  )

}

get_rdvcov_names <- function(object, varname, lvl) {

  pos <- sapply(attr(object$info_list[[varname]]$rd_vcov[[lvl]], "ranef_index"),
                function(nr) eval(parse(text = nr)))

  if (length(pos) > 0L) {
    nam <- nlapply(names(pos), function(v) {
      attr(object$info_list[[v]]$hc_list$hcvars[[lvl]], "Znam")
    })
    melt_list(
      Map(function(pos, nam) {
        cbind(pos, nam)
      }, pos = pos, nam = nam), varname = "variable"
    )

  } else {
    nam <- attr(object$info_list[[varname]]$hc_list$hcvars[[lvl]], "Znam")
    if (!is.null(nam)) {
      data.frame(pos = seq_along(nam),
                 nam = nam,
                 variable = varname)
    }
  }
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
