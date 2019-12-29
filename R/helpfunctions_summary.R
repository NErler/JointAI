
prep_MCMC <- function(object, start = NULL, end = NULL, thin = NULL, subset = NULL,
                      exclude_chains = NULL,
                      warn = TRUE, mess = TRUE, ...) {

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

  MCMC <- get_subset(object, subset, warn = warn, mess = mess)

  chains <- seq_along(MCMC)
  if (!is.null(exclude_chains)) {
    chains <- chains[-exclude_chains]
  }

  MCMC <- do.call(rbind,
                  window(MCMC[chains],
                         start = start,
                         end = end,
                         thin = thin))
  return(MCMC)
}


# @param x object of class JointAI
get_Dmat <- function(x, varname) {
  MCMC <- prep_MCMC(x, start = NULL, end = NULL, thin = NULL, subset = NULL,
                    exclude_chains = NULL, warn = TRUE, mess = TRUE)

  Ds <- grep(paste0("^D\\_", varname, "\\[[[:digit:]]*,[[:digit:]]*\\]"), colnames(MCMC), value = TRUE)
  Dpos <- t(sapply(strsplit(gsub(paste0('D_', varname, '|\\[|\\]'), '', Ds), ","), as.numeric))

  term <- terms(remove_grouping(x$random[[varname]]))

  dimnam <- c(if (attr(term, 'intercept') == 1) "(Intercept)",
              attr(term, 'term.labels'))

  Dmat <- matrix(nrow = length(dimnam), ncol = length(dimnam),
                 dimnames = list(dimnam, dimnam))
  for (k in seq_along(Ds)) {
    Dmat[Dpos[k, 1], Dpos[k, 2]] <- mean(MCMC[, Ds[k]])
  }

  Dmat
}



get_aux <- function(object) {
  aux <- object$Mlist$auxvars
  unlist(sapply(if (!is.null(object$Mlist$auxvars))
    attr(terms(aux), 'term.labels'),
    function(x)
      if (x %in% names(object$Mlist$refs))
        attr(object$Mlist$refs[[x]], 'dummies')
    else x
  ))
}

print_type <- function(x) {
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
  # paste0(a, " fitted with JointAI")
}

# get_intercepts <- function(x, yname) {
#   x[grep(paste0("gamma_", yname), rownames(x)), ]
# }

get_intercepts <- function(stats, varname, lvls) {
  interc <-   stats[grep(paste0("gamma_", varname), rownames(stats)), ]
  rownames(interc) <- paste(varname, "\u2264", lvls[-length(lvls)])
  interc
}


computeP <- function(x) {
  above <- mean(x > 0)
  below <- mean(x < 0)
  2 * min(above, below)
}
