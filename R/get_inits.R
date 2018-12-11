get_inits <- function(object, ...) {
  UseMethod("get_inits")
}


get_inits.default = function(meth, Mlist, K, K_imp, analysis_type, family, link = link, ...){
  l <- list()

  # analysis model ---------------------------------------------------------------
  # fixed parameters: beta and precision parameter
  if (analysis_type %in% c('lm', 'glm')) {
    mu0 <- coef(glm(unlist(Mlist$y) ~ 1,
                     family = get(family)(link = link)))
  } else if (analysis_type == 'survreg') {
    mu0 <- log(colMeans(Mlist$y))
  } else {
    mu0 <- 0
  }

  mean.betas <- c(mu0, rep(0, max(K[, "end"], na.rm = TRUE) - 1))

  l[["beta"]] <- setNames(rnorm(length(mean.betas), mean.betas, 1),
                          get_coef_names(Mlist, K)[, 2])

  # if (!is.null(Mlist$auxvars)) {
  #   nams <- sapply(Mlist$auxvars, function(x) {
  #     if (x %in% names(Mlist$refs)) {
  #       paste0(x, levels(Mlist$refs[[x]])[levels(Mlist$refs[[x]]) !=
  #                                           Mlist$refs[[x]]])
  #     } else {
  #       x
  #     }
  #   })
  #
  #   l[["beta"]][unlist(nams)] <- NA
  # }

  if (family %in% c('gaussian', 'Gamma'))
    l[[paste0("tau_", colnames(Mlist$y))]] = rgamma(1, 1, 1)


  # random effects and random effects covariance
  if (analysis_type %in% c("lme", "glme")) {
    l[["b"]] = matrix(nrow = Mlist$N,
                      ncol = ncol(Mlist$Z),
                      data = rnorm(nrow(Mlist$Xc  * ncol(Mlist$Z))))



    l[["invD"]] = if (ncol(Mlist$Z) == 1) {
      matrix(nrow = 1, ncol = 1, data = rgamma(1, var(data.matrix(Mlist$y))*10, 10))
    } else {
      RinvD <- matrix(ncol = ncol(Mlist$Z),
                      nrow = ncol(Mlist$Z), data = 0)
      diag(RinvD) <- c(rgamma(ncol(Mlist$Z),
                              shape = apply(cbind(Mlist$y,
                                                  Mlist$Z[, -1]), 2, var) * 10,
                              rate = 10))
      rWishart(1, ncol(Mlist$Z), RinvD)[, , 1]
    }
  }

  # imputation models ------------------------------------------------------------
  # regression coefficients alpha
  if (!is.null(K_imp))
    l[["alpha"]] = rnorm(max(K_imp), 0, 1)

  if (any(meth == "beta")) {
    whichalpha <- K_imp[names(meth[meth == "beta"]), "start"]:K_imp[names(meth[meth == "beta"]), "end"]
    l[["alpha"]][whichalpha] <- rnorm(length(whichalpha), 0, 0.1)

    for (k in names(meth)[meth %in% c("beta")]) {
      l[[paste0("tau_", k)]] <- rgamma(1, 15, 0.1)
    }
  }

  # precision parameters for normal imputation models
  if  (any(meth %in% c("norm", "lognorm"))) {
    for (k in names(meth)[meth %in% c("norm", "lognorm")]) {
      l[[paste0("tau_", k)]] <- rgamma(1, 1, 1)
    }
  }

  # group specific intercepts of ordinal covariates
  if (any(meth == "cumlogit")) {
    for (k in names(meth)[meth ==  "cumlogit"]) {
      l[[paste0("delta_", k)]] = rnorm(length(levels(Mlist$refs[[k]])) - 2, 0, 0.5)
      l[[paste0("gamma_", k)]] = c(rnorm(1, 0, 0.5),
                                   rep(NA, length(levels(Mlist$refs[[k]])) - 2))
    }
  }

  return(l)
}


# get_inits.JointAI = function(object) {
#   get_inits.default(meth = object$meth, Mlist = object$Mlist, K = object$K,
#                     K_imp = object$K_imp, analysis_type = object$analysis_type,
#                     family = attr(object$analysis_type, "family"))
# }
