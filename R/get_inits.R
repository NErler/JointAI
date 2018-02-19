get_inits <- function(object, ...) {
  UseMethod("get_inits")
}


get_inits.default = function(meth, Mlist, K, K_imp, analysis_type, family){
  l <- list()

  # analysis model ---------------------------------------------------------------
  # fixed parameters: beta and precision parameter
  mean.betas <- c(colMeans(Mlist$y, na.rm = T),
                  rep(0, max(K[, "end"], na.rm = T) - 1))
  l[["beta"]] = rnorm(length(mean.betas), mean.betas, 1)
  if (family %in% c('gaussian', 'Gamma'))
    l[[paste0("tau_", colnames(Mlist$y))]] = rgamma(1, 1, 1)


  # random effects and random effects covariance
  if (analysis_type == "lme") {
    l[["b"]] = matrix(nrow = nrow(Mlist$Xc),
                      ncol = ncol(Mlist$Z),
                      data = rnorm(nrow(Mlist$Xc  * ncol(Mlist$Z))))
    l[["priorR.invD"]] = if (ncol(Mlist$Z) == 1) {
      matrix(nrow = 1, ncol = 1, data = rgamma(1, var(Mlist$y)*10, 10))
    } else {
      RinvD <- matrix(ncol = ncol(Mlist$Z),
                      nrow = ncol(Mlist$Z), data = NA)
      diag(RinvD) <- c(rgamma(ncol(Mlist$Z),
                             shape = apply(cbind(Mlist$y,
                                                 Mlist$Z[, -1]), 2, var) * 10,
                             rate = 10))
      RinvD
    }
  }

  # imputation models ------------------------------------------------------------
  # regression coefficients alpha
  if (!is.null(K_imp))
    l[["alpha"]] = rnorm(max(K_imp), 0, 1)

  # precision parameters for normal imputation models
  if  (any(meth %in% c("norm", "lognorm"))) {
    for (k in names(meth)[meth %in% c("norm", "lognorm")]) {
      l[[paste0("tau_", k)]] <- rgamma(1, 1, 1)
    }
  }

  # group specific intercepts of ordinal covariates
  if (any(meth == "cumlogit")) {
    for (k in names(meth)[meth ==  "cumlogit"]) {
      l[[paste0("delta_", k)]] = rnorm(imp_par_list[[k]]$ncat - 2, 0, 0.5)
      l[[paste0("gamma_", k)]] = c(rnorm(1, 0, 0.5), rep(NA, imp_par_list[[k]]$ncat - 2))
    }
  }

  return(l)
}


# get_inits.JointAI = function(object) {
#   get_inits.default(meth = object$meth, Mlist = object$Mlist, K = object$K,
#                     K_imp = object$K_imp, analysis_type = object$analysis_type,
#                     family = attr(object$analysis_type, "family"))
# }
