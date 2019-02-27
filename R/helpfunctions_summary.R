
prep_MCMC <- function(object, start = NULL, end = NULL, thin = NULL, subset = NULL, warn = warn, ...) {

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

  MCMC <- get_subset(object, subset, warn = warn)

  MCMC <- do.call(rbind,
                  window(MCMC,
                         start = start,
                         end = end,
                         thin = thin))

  return(MCMC)
}


get_Dmat <- function(x) {
  MCMC <- prep_MCMC(x, start = NULL, end = NULL, thin = NULL, subset = NULL)

  Ds <- grep("^D\\[[[:digit:]]*,[[:digit:]]*\\]", colnames(MCMC), value = TRUE)
  Dpos <- t(sapply(strsplit(gsub('D|\\[|\\]', '', Ds), ","), as.numeric))

  term <- terms(remove_grouping(x$random))

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
  unlist(sapply(aux, function(x)
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
              glme = 'Generalized linear mixed model',
              coxph = 'Cox proportional hazards model',
              survreg = 'Weibul survival model',
              clm = 'Cumulative logit model',
              clmm = 'Cumulative logit mixed model'
  )
  paste0(a, " fitted with JointAI")
}

get_intercepts <- function(x, yname) {
  x[grep(paste0("gamma_", yname), rownames(x)), ]
}

print_intercepts <- function(interc, yname, lvl) {
  rownames(interc) <- paste(yname, "\u2264", lvl[-length(lvl)])
  interc
}


computeP <- function(x) {
  above <- mean(x > 0)
  below <- mean(x < 0)
  2 * min(above, below)
}
