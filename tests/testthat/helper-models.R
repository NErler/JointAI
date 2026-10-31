# Helpers for the model test files (test-glm.R, test-clm.R, ...): check the
# JAGS model and predicted probabilities, and prepare fitted models for
# snapshots. Moved here from R/helpfunctions_tests.R (they are only used by
# the tests).

find_dupl_parms <- function(mod) {
  betas <- unlist(regmatches(
    mod$jagsmodel,
    gregexpr('beta[[[:digit:]]+]', mod$jagsmodel)
  ))
  alphas <- unlist(regmatches(
    mod$jagsmodel,
    gregexpr('alpha[[[:digit:]]+]', mod$jagsmodel)
  ))

  c(
    if (any(duplicated(betas))) {
      betas[duplicated(betas)]
    },

    if (any(duplicated(alphas))) {
      alphas[duplicated(alphas)]
    }
  )
}

get_predprob <- function(mod, varname) {
  MCMC <- do.call(rbind, mod$MCMC)
  ps <- grep(paste0("^p_", varname, "\\b"), colnames(MCMC), value = TRUE)
  cat <- gsub(
    "\\]$",
    ")",
    gsub(
      paste0("^p_", varname, "\\[[[:digit:]]+,"),
      paste0("P(", varname, "="),
      ps
    )
  )

  problist <- lapply(split(ps, cat), function(n) {
    samp <- MCMC[, n]
    cbind(fit = colMeans(samp), t(apply(samp, 2, quantile, c(0.025, 0.975))))
  })

  array(
    dim = c(dim(problist[[1]]), length(problist)),
    dimnames = list(NULL, colnames(problist[[1]]), names(problist)),
    unlist(problist)
  )
}

check_predprob <- function(mod) {
  varname <- names(mod$fixed)[1]
  f <- predict(mod, type = "prob", warn = FALSE)$fit
  g <- get_predprob(mod, varname = varname)

  sum(round(f - g, 10), na.rm = TRUE)
}


set0 <- function(object) {
  object$MCMC <- coda::as.mcmc.list(lapply(object$MCMC, function(x) {
    x * 0
  }))
  object$comp_info$duration <- 0
  object$comp_info$start_time <- 0
  object$comp_info$JointAI_version <- 0

  rm_attr <- setdiff(
    names(attr(object$analysis_type, "family")),
    c("family", "link")
  )
  attr(object$analysis_type, "family")[rm_attr] <- NULL

  object
}

set0_list <- function(lst) {
  lapply(lst, set0)
}

normalize_numeric <- function(x, digits = 14) {
  if (is.numeric(x)) {
    round(x, digits)
  } else if (is.data.frame(x)) {
    x[] <- lapply(x, normalize_numeric, digits = digits)
    x
  } else if (is.list(x)) {
    lapply(x, normalize_numeric, digits = digits)
  } else {
    x
  }
}
