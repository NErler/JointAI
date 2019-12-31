rescale <- function(MCMC, coefs, scale_pars, info_list) {
  # MCMC: a mcmc object (only one element of the mcmc.list)
  # coefs: combined coef_list (do.call(rbind, coef_list))
  # scale_pars: combined scaling parameters (do.call(rbind, unname(Mlist$scale_pars)))
  # info_list

  scale_pars$center[is.na(scale_pars$center)] <- 0
  scale_pars$scale[is.na(scale_pars$scale)] <- 1

  sapply(colnames(MCMC), function(k) {
    if (k %in% coefs$coef) {
      # variable name
      varnam <- coefs$varname[which(coefs$coef == k)]

      if (varnam == "(Intercept)") {
        outcome <- coefs$outcome[which(coefs$coef == k)]
        covnames <- names(unlist(unname(test$info_list[[outcome]]$lp)))
        covnames <- covnames[which(!covnames %in% "(Intercept)")]

        scaled_covs <- sapply(covnames, function(j) {
          MCMC[, coefs$coef[match(j, coefs$varname)]] * scale_pars[j, 'center']/scale_pars[j, 'scale']
        })

        MCMC[, k] - rowSums(scaled_covs)
      } else {
        # scaling parameters
        sp <- scale_pars[varnam, ]

        MCMC[, k] / sp$scale
      }
    } else {
      MCMC[, k]
    }
  })
}

#
# rescale <- function(x, fixed2, scale_pars, MCMC, refs, coef_lvl, coefs) {
#   coefs <- if (inherits(coefs, 'list'))
#     melt_data.frame_list(coefs, id.vars = colnames(coefs[[1]])) else coefs
#
#   x_data <- if(x %in% coefs[, 'JAGS']) {
#     coefs[na.omit(match(x, coefs[, "JAGS"])), "data"]
#   } else x
#
#   x_split <- unlist(strsplit(x_data, ":"))
#
#   if (!any(x_split %in% coefs[, 'JAGS']))
#     return(MCMC[, x])
#
#   coef_lvl <- unlist(coef_lvl[[coefs[na.omit(match(x, coefs[, 'JAGS'])), "L1"]]])
#
#   coef_split <- sapply(coef_lvl, splitstring2, x = x_data, x_split = x_split, simplify = FALSE)
#   names(coef_split) <- coef_lvl
#
#
#
#   pars <- sapply(coef_split, function(i) {
#     all(x_split %in% i) | x_data %in% i
#   })
#   if (x_data == "(Intercept)") pars <- !pars
#   if (!any(pars)) return(MCMC[, x])
#
#   interact <- names(pars[names(pars) != x_data & pars])
#
#   vec <- MCMC[, x, drop = FALSE]
#
#   interactions <- sapply(interact, function(i) {
#     other <- coef_split[[i]][coef_split[[i]] != x_data]
#     split_coef <- unlist(strsplit(coef_split[[i]], ":"))
#     as.numeric(MCMC[ , i]) / prod(scale_pars["scale", split_coef]) *
#       prod(scale_pars["center", other]) * (-1)^(length(other) + 1)
#   })
#
#   inter_sum <- if (!is.null(dim(interactions))) {
#     rowSums(interactions)
#   } else {
#     0
#   }
#
#   new_vec <- vec / prod(scale_pars["scale", unlist(strsplit(x_data, ":"))]) - inter_sum
#   new_vec
# }
#
#
# splitstring = function(input, pattern) {
#   splitres = strsplit(input, pattern)[[1]]
#
#   T1 <- splitres[1] == "" | substr(splitres[1],
#                                    start = nchar(splitres[1]),
#                                    stop = nchar(splitres[1])) == ":"
#   T2 <- T
#   if (length(splitres) > 1) {
#     T2 <-  splitres[2] == "" | substr(splitres[2], start = 1, stop = 1) == ":"
#   }
#   if (T1 & T2) {
#     res <- unlist(c(pattern, strsplit(splitres, ":")))
#     res <- res[which(res != "")]
#   } else {
#     res <- unlist(strsplit(input, ":"))
#   }
#   return(res)
# }
#
#
#
# splitstring2 <- function(input, x, x_split) {
#   if (length(x_split) > 1) {
#     split_input <- unlist(strsplit(input, ":"))
#     if (all(x_split %in% split_input)) {
#       splitmatch <- split_input %in% x_split
#       input <- paste0(c(split_input[splitmatch], split_input[!splitmatch]), collapse = ":")
#     }
#   }
#   splitres <- strsplit(input, x, fixed = TRUE)[[1]]
#
#
#   T1 <- splitres[1] == "" | substr(splitres[1],
#                                    start = nchar(splitres[1]),
#                                    stop = nchar(splitres[1])) == ":"
#   T2 <- T
#   if (length(splitres) > 1) {
#     T2 <-  splitres[2] == "" | substr(splitres[2], start = 1, stop = 1) == ":"
#   }
#   if (T1 & T2) {
#     res <- unlist(c(x, strsplit(splitres, ":")))
#     res <- res[which(res != "")]
#   } else {
#     res <- unlist(strsplit(input, ":"))
#   }
#   return(res)
# }
