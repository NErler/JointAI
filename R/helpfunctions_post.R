get_subset <- function(subset, MCMC, object) {
  if (any(subset != "main")) {
    subset <- subset[which(subset != "main")]

    if (inherits(MCMC, "mcmc.list")) {
      subset <- sapply(subset, function(i) {
        if (is.na(match(i, colnames(MCMC[[1]])))) {
          colnames(MCMC[[1]])[as.numeric(i)]
        } else {
          i
        }
      })
    } else {
      subset <- sapply(subset, function(i) {
        if (is.na(match(i, colnames(MCMC))) & i != "main") {
          colnames(MCMC)[as.numeric(i)]
        } else {
          i
        }
      })
    }
  }

  if (any(subset == "main")) {
    coefs <- get_coef_names(object$Mlist, object$K)

    subset <- append(subset[which(subset != "main")], coefs[, 2], after = 0)
    if (!is.null(object$Mlist$auxvars))
      subset <- subset[-which(subset %in% c(object$Mlist$auxvars,
                                            unlist(lapply(object$Mlist$refs[object$Mlist$auxvars],
                                                          attr, "dummies"))))]

    if (object$analysis_type == "lm" |
        (object$analysis_type == "glm" &
         attr(object$analysis_type, "family") %in% c("Gamma", "gaussian"))) {
      subset <- c(subset, paste0("sigma_", names(object$Mlist$y)))
    }
    if (object$analysis_type == "lme") {
      subset <- c(subset,
                  paste0("sigma_", names(object$Mlist$y)),
                  grep("^D\\[[[:digit:]]*,[[:digit:]]*\\]", colnames(MCMC), value = T))
    }
  }
  return(MCMC[, subset, drop = F])
}




computeP <- function(x) {
    above <- mean(x > 0)
    below <- mean(x < 0)
    2 * min(above, below)
}
