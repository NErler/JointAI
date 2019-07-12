#' Plot a posterior predictive summary
#'
#' @inheritParams sharedParams
#' @param fun the function to be used to summarize the sample
#' @param vars optional; names of the variables for which the posterior predictive summary should be plotted
#' @param type type of the plot; one of \code{"histogram"}, \code{"density"} or \code{"chainwise_density"} (may be abbreviated)
#' @param ... additional parameters passed to the geom that is used
#' @export

ppc_summary <- function(object, fun, vars = NULL, type = c('histogram', 'density', 'chainwise_dens'), ...) {

  if (!object$Mlist$ppc)
    stop(paste0("A posterior predictive check requires the fitted values to ",
                "be monitored (set the argument ", dQuote('ppc = TRUE'), ")."))

  type <- match.arg(type)

  if (is.null(vars)) {
    vars <- c(names(object$models), colnames(object$Mlist$y))
  }

  dat <- sapply(vars, function(var) {

    if (var %in% names(object$Mlist$refs))
      var_dum <- attr(object$Mlist$refs[[var]], 'dummies')
    else
      var_dum <- var

    var_rep <- object$MCMC[, grep(paste0(var, "_ppc\\["), colnames(object$MCMC[[1]]))]

    if (object$analysis_type == 'survreg' & var == colnames(object$Mlist$y)) {
      obs <- object$data_list$ctime
      cens <- ifelse(object$data_list$cens == 1, 'censored', 'event observed')
    } else {
      obs <- if (var %in% names(object$data_list)) {
        c(na.omit(object$data_list[[var]]))
      } else if (var %in% object$Mlist$trafos$var) {
        c(na.omit(object$data_list$Xtrafo[, var]))
      } else if (var %in% names(object$Mlist$refs) &
                 length(levels(object$Mlist$refs[[var]])) > 2) {
        c(na.omit(object$data_list$Xcat[, var]))
      } else if (var_dum %in% colnames(object$data_list$Xc)) {
        c(na.omit(object$data_list$Xc[, var_dum]))
      }
      cens <- 0
    }

    value_obs <- #if (any(c('...', 'na.rm') %in% names(formals(fun))))
      # reshape2::melt(lapply(split(obs, cens), fun, na.rm = TRUE))
      melt_list(lapply(split(obs, cens), fun), varnames = 'group')
    # else
    #   reshape2::melt(lapply(split(obs, cens), fun))

    # names(value_obs) <- gsub('L1', 'group', names(value_obs))

    l <- lapply(var_rep, apply, MARGIN = 1, function(x) {
      lapply(split(x, cens), fun)
    })

    names(l) <- as.character(1:length(l))
    # value_rep <- reshape2::melt(l)
    # names(value_rep) <- gsub('L1', 'chain', names(value_rep))
    # names(value_rep) <- gsub('L2', 'iteration', names(value_rep))
    # names(value_rep) <- gsub('L3', 'group', names(value_rep))

    value_rep <- melt_list(l)
    names(value_rep) <- gsub('L3', 'chain', names(value_rep))
    names(value_rep) <- gsub('L2', 'iteration', names(value_rep))
    names(value_rep) <- gsub('L1', 'group', names(value_rep))

    list(rep = value_rep, obs = as.data.frame(value_obs))
  }, simplify = FALSE)


  dat_obs <- melt_list(lapply(dat, "[[", 'obs'))
  names(dat_obs) <- gsub("L2", 'var', names(dat_obs))
  dat_rep <- melt_list(lapply(dat, "[[", 'rep'))
  names(dat_rep) <- gsub("L1", 'var', names(dat_rep))


  p <- ggplot2::ggplot(dat_rep, ggplot2::aes(x = value))
    # ggplot2::xlab(var) +
    # ggplot2::facet_wrap('var', scales = 'free')

  if (type == 'histogram')
    p <- p + ggplot2::geom_histogram(...)
  if (type == 'density')
    p <- p + ggplot2::stat_density(geom = 'line', ...)
  if (type == 'chainwise_dens')
    p <- p + ggplot2::stat_density(ggplot2::aes(color = chain), geom = 'line', ...)


  p <- p + ggplot2::geom_vline(data = dat_obs, ggplot2::aes(xintercept = value))

  if (object$analysis_type == 'survreg')
    print(p + ggplot2::facet_wrap(group ~ var, scales = 'free'))
  else print(p + ggplot2::facet_wrap('var', scales = 'free'))

  invisible(list(rep = dat_rep, obs = dat_obs))
}


#' Plot a posterior predictive check
#'
#' @inheritParams sharedParams
#' @param fun the function to be applied
#' @param vars optional; names of the variables for which the posterior predictive summary should be plotted
#' @param input type of input expected by the function; one of \code{"matrix"}
#'              (iterations are rows, observations are columns) or \code{"scalar"}
#'
#' @export
ppc_plot <- function(object, fun, vars = NULL, input = c('matrix', 'scalar')) {

  input <- match.arg(input)

  if (is.null(vars)) {
    vars <- c(names(object$models), colnames(object$Mlist$y))
  }

  dat <- sapply(vars, function(var) {

    if (var %in% names(object$Mlist$refs))
      var_dum <- attr(object$Mlist$refs[[var]], 'dummies')
    else
      var_dum <- var



    # get the replications from the MCMC sample
    rep_list <- object$MCMC[, grep(paste0(var, "_ppc\\["),
                                   colnames(object$MCMC[[1]]))]

    # get the expected values from the MCMC sample
    mu_list <- object$MCMC[, grep(paste0("mu_", var, "\\["),
                                  colnames(object$MCMC[[1]]))]


    # get the observed values from the data_list
    if (object$analysis_type == 'survreg' & var == colnames(object$Mlist$y)) {
      obs <- object$data_list$ctime
      cens <- ifelse(object$data_list$cens == 1, 'censored', 'event observed')
    } else {
      obs <- if (var %in% names(object$data_list)) {
        c(object$data_list[[var]])
      } else if (var %in% object$Mlist$trafos$var) {
        c(object$data_list$Xtrafo[, var])
      } else if (var %in% names(object$Mlist$refs) &
                 length(levels(object$Mlist$refs[[var]])) > 2) {
        if (var %in% names(object$data_list$Xcat)) {
          c(object$data_list$Xcat[, var])
        } else {
          c(object$data_list$Xlcat[, var])
        }
      } else if (var_dum %in% colnames(object$data_list$Xc)) {
        c(object$data_list$Xc[, var_dum])
      } else if (var_dum %in% colnames(object$data_list$Xl)) {
        c(object$data_list$Xl[, var_dum])
      }
      cens <- 0
    }

    if (length(obs) != ncol(mu_list[[1]]))
      stop("Dimension mismatch between obs and mu_list.")

    obs <- matrix(obs, nrow = nrow(mu_list[[1]]), ncol = length(obs), byrow = TRUE)
    obs_list <- replicate(length(mu_list), obs, simplify = FALSE)


    if (input == 'matrix') {
      mapply(fun, obs = obs_list, rep = rep_list, mu = mu_list, SIMPLIFY = FALSE)
    } else {
      lapply(seq_along(mu_list), function(m) {
        sapply(1:nrow(mu_list[[m]]), function(k) {
          fun(obs_list[[m]][k, ], rep_list[[m]][k, ], mu_list[[m]][k, ])
        })
      })
    }
  }, simplify = FALSE)

  plotDF <- melt_list(dat)

  ggplot2::ggplot(plotDF, ggplot2::aes(x = value, group = .data$L1, color = factor(.data$L1))) +
    ggplot2::stat_density(geom = 'line', position = 'identity') +
    ggplot2::facet_wrap('L2', scales = 'free')

}

ppc_ks <- function(object, var, exact = NULL) {
    # get the replications from the MCMC sample
    rep_list <- object$MCMC[, grep(paste0(var, "_ppc\\["),
                                   colnames(object$MCMC[[1]]))]

    obs <- get_obs(object, var)

    dat <- lapply(seq_along(rep_list), function(m) {
      sapply(1:nrow(rep_list[[m]]), function(k) {
        as.data.frame(ks.test(obs, rep_list[[m]][k, ], exact = exact)[c("statistic", "p.value")])
      }, simplify = FALSE)
    })

    return(melt_list(dat))
}


get_obs <- function(object, var) {

  if (var %in% names(object$Mlist$refs))
    var_dum <- attr(object$Mlist$refs[[var]], 'dummies')
  else
    var_dum <- var

  # get the observed values from the data_list
  if (object$analysis_type == 'survreg' & var == colnames(object$Mlist$y)) {
    obs <- object$data_list$ctime
    cens <- ifelse(object$data_list$cens == 1, 'censored', 'event observed')
  } else {
    obs <- if (var %in% names(object$data_list)) {
      c(object$data_list[[var]])
    } else if (var %in% object$Mlist$trafos$var) {
      c(object$data_list$Xtrafo[, var])
    } else if (var %in% names(object$Mlist$refs) &
               length(levels(object$Mlist$refs[[var]])) > 2) {
      if (var %in% names(object$data_list$Xcat)) {
        c(object$data_list$Xcat[, var])
      } else {
        c(object$data_list$Xlcat[, var])
      }
    } else if (var_dum %in% colnames(object$data_list$Xc)) {
      c(object$data_list$Xc[, var_dum])
    } else if (var_dum %in% colnames(object$data_list$Xl)) {
      c(object$data_list$Xl[, var_dum])
    }
    cens <- 0
  }
  return(obs)
}


ppc_mcnemar <- function(object, var, correct = TRUE) {
  # get the replications from the MCMC sample
  rep_list <- object$MCMC[, grep(paste0(var, "_ppc\\["),
                                 colnames(object$MCMC[[1]]))]

  obs <- factor(get_obs(object, var))

  dat <- lapply(seq_along(rep_list), function(m) {
    sapply(1:nrow(rep_list[[m]]), function(k) {
      as.data.frame(
        mcnemar.test(table(obs,
                         factor(rep_list[[m]][k, ],
                                levels = levels(obs)),
                         exclude = NA), correct = correct)[c("statistic", "p.value")])
    }, simplify = FALSE)
  })

  return(melt_list(dat))
}



ppc_test <- function(object, vars = NULL, summary = FALSE) {

  if (is.null(vars)) {
    vars <- c(names(object$models), colnames(object$Mlist$y))
  }

  dat <- sapply(vars, function(var) {
    if (var %in% names(object$Mlist$refs))
      ppc_mcnemar(object, var)
    else
      ppc_ks(object, var)
  }, simplify = FALSE)


  plotDF <- melt_list(dat)

  p <- ggplot2::ggplot(plotDF,
                       ggplot2::aes(x = p.value, group = .data$L3, color = factor(.data$L3))) +
    ggplot2::stat_density(geom = 'line', position = 'identity') +
    ggplot2::facet_wrap("L3", scales = 'free')

  print(p)

  if (summary) {
    s <- lapply(dat, function(x) {
      apply(x[, c('statistic', 'p.value')], 2, summary)
    })
    return(s)
  }
}



# fun1 <- function(obs, rep, mu) {
#   sqe_obs <- (obs - mu)^2
#   sqe_rep <- (rep - mu)^2
#   rowMeans(sqe_obs > sqe_rep, na.rm = TRUE) - 0.5
# }
#
# fun2 <- function(obs, rep, mu) {
#   qd_obs <- (obs - mu)^2
#   qd_rep <- (rep - mu)^2
#   mean(qd_obs > qd_rep, na.rm = TRUE) - 0.5
# }


## plot binned residuals
##
## @importFrom rlang .data
##
#
#
# plot_resid_binned <- function(object, nbins, nit, var,
#                             type = c('quantiles', "trajectories", 'dots'), ...) {
#
#   type = match.arg(type)
#
#   if (var %in% names(object$Mlist$refs))
#     var_dum <- attr(object$Mlist$refs[[var]], 'dummies')
#   else
#     var_dum <- var
#
#   MCMC <- do.call(rbind, object$MCMC)
#   it <- sample(1:nrow(MCMC), size = nit)
#
#   var_rep <- MCMC[, grep(paste0(var, "_ppc\\["), colnames(MCMC))]
#   var_exp <- MCMC[, grep(paste0('mu_', var, "\\["), colnames(MCMC))]
#
#   obs <- if (var_dum %in% names(object$data_list)) {
#     object$data_list[[var_dum]]
#   } else if (var_dum %in% colnames(object$data_list$Xc)) {
#     c(object$data_list$Xc[, var_dum])
#   }
#
#   resid_obs <- t(apply(var_exp, 1, function(x) obs - x))
#   resid_rep <- var_rep - var_exp
#
#   names(dimnames(resid_obs)) <- names(dimnames(resid_rep)) <-
#     names(dimnames(var_exp)) <- c('iters', 'subj')
#
#
#   dat1 <- reshape2::melt(var_exp, value.name = 'var_exp')
#   dat1$subj <- gsub('\\[|\\]', '',
#                     regmatches(as.character(dat1$subj),
#                                regexpr('\\[[[:digit:]]*\\]', as.character(dat1$subj))))
#
#   dat2 <- reshape2::melt(resid_obs, value.name = 'resid_obs')
#   dat3 <- reshape2::melt(resid_rep, value.name = 'resid_rep')
#
#   bindf <- cbind(dat1, resid_obs = dat2$resid_obs, resid_rep = dat3$resid_rep)
#
#   bindf$cut <- cut(bindf$var_exp, quantile(bindf$var_exp,
#                                            seq(0, 1, length = nbins + 1), na.rm = TRUE),
#                    include.lowest = T)
#
#
#   binDFobs <- do.call(rbind,
#                       lapply(split(bindf, bindf$cut),
#                              function(x) {
#                                subdat <- subset(x, subset = iters %in% it)
#                                a <- split(subdat, subdat$iters)
#                                do.call(rbind, lapply(a, function(i)
#                                  data.frame(x = mean(i$var_exp, na.rm = TRUE),
#                                             y = mean(i$resid_obs, na.rm = TRUE),
#                                             iters = unique(i$iters),
#                                             cut = unique(i$cut)))
#                                )
#                              }
#                       )
#   )
#
#   if (type == 'quantiles') {
#     binDFrep <- c()
#     for (x in split(bindf, bindf$cut)) {
#       temp <- data.frame(
#         mean_var_exp = mean(x$var_exp, na.rm = TRUE),
#         mean_resid_rep = sapply(split(x$resid_rep, x$iters), mean, na.rm = TRUE)
#       )
#       binDFrep <- rbind(binDFrep,
#                         data.frame(
#                           cut = x$cut[1],
#                           x = unique(temp$mean_var_exp),
#                           lo = quantile(temp$mean_resid_rep, 0.025, na.rm = TRUE),
#                           hi = quantile(temp$mean_resid_rep, 0.975, na.rm = TRUE)
#                         )
#       )
#     }
#
#     p <- ggplot2::ggplot(binDFrep) +
#       ggplot2::geom_ribbon(ggplot2::aes(x = x, ymin = .data$lo, ymax = .data$hi),
#                            alpha = 0.3) +
#       ggplot2::geom_line(data = binDFobs,
#                          ggplot2::aes(x = x, y = y, color = .data$iters,
#                                       group = factor(.data$iters)), lwd = 1) +
#       ggplot2::geom_hline(yintercept = 0) +
#       ggplot2::theme(legend.position = 'none')
#
#   } else {
#     binDFrep <- c()
#     for (x in split(bindf, bindf$cut)) {
#       binDFrep <- rbind(binDFrep,
#                         data.frame(
#                           mean_var_exp = mean(x$var_exp, na.rm = TRUE),
#                           mean_resid_rep = sapply(split(x$resid_rep, x$iters),
#                                                   mean, na.rm = TRUE),
#                           iters = names(split(x$resid_rep, x$iters)),
#                           cut = x$cut[1]
#                         )
#       )
#     }
#
#     if (type == 'trajectories')
#       p <- ggplot2::ggplot(binDFrep) +
#         ggplot2::geom_line(ggplot2::aes(x = .data$mean_var_exp, y = .data$mean_resid_rep,
#                                         group = factor(.data$iters)), alpha = 0.3,
#                            color = grDevices::grey(0.5)) +
#         ggplot2::geom_line(data = binDFobs,
#                            ggplot2::aes(x = x, y = y, color = .data$iters,
#                                         group = factor(.data$iters)), lwd = 1) +
#         ggplot2::geom_hline(yintercept = 0) +
#         ggplot2::theme(legend.position = 'none')
#
#     if (type == 'dots')
#       p <- ggplot2::ggplot(binDFrep) +
#         ggplot2::geom_point(ggplot2::aes(x = .data$mean_var_exp, y = .data$mean_resid_rep,
#                                          group = factor(iters)), alpha = 0.3,
#                             color = grDevices::grey(0.5)) +
#         ggplot2::geom_point(data = binDFobs,
#                             ggplot2::aes(x = x, y = y, color = iters,
#                                          group = factor(iters)), size = 1.5) +
#         ggplot2::geom_hline(yintercept = 0) +
#         ggplot2::theme(legend.position = 'none')
#
#   }
#   return(p)
# }
#
# plot_resid_continuous <- function(object, var, nit, nbins,
#                                   type = c('quantiles', "trajectories", 'dots'), ...) {
#   type = match.arg(type)
#
#   if (var %in% names(object$Mlist$refs))
#     var_dum <- attr(object$Mlist$refs[[var]], 'dummies')
#   else
#     var_dum <- var
#
#
#   MCMC <- do.call(rbind, object$MCMC)
#   it <- sample(1:nrow(MCMC), size = nit)
#
#   var_rep <- MCMC[, grep(paste0(var, "_ppc\\["), colnames(MCMC))]
#   var_exp <- MCMC[, grep(paste0('mu_', var, "\\["), colnames(MCMC))]
#
#   obs <- if (var_dum %in% names(object$data_list)) {
#     object$data_list[[var_dum]]
#   } else if (var_dum %in% colnames(object$data_list$Xc)) {
#     c(object$data_list$Xc[, var_dum])
#   }
#
#   resid_obs <- t(apply(var_exp, 1, function(x) obs - x))
#   resid_rep <- var_rep - var_exp
#
#   names(dimnames(resid_obs)) <- names(dimnames(resid_rep)) <-
#     names(dimnames(var_exp)) <- c('iters', 'subj')
#
#
#   dat1 <- reshape2::melt(var_exp, value.name = 'var_exp')
#   dat1$subj <- gsub('\\[|\\]', '',
#                     regmatches(as.character(dat1$subj),
#                                regexpr('\\[[[:digit:]]*\\]', as.character(dat1$subj))))
#
#   dat2 <- reshape2::melt(resid_obs, value.name = 'resid_obs')
#   dat3 <- reshape2::melt(resid_rep, value.name = 'resid_rep')
#
#   bindf <- cbind(dat1, resid_obs = dat2$resid_obs, resid_rep = dat3$resid_rep)
#   bindf <- bindf[order(bindf$var_exp), ]
#
#   bindf$cut <- cut(bindf$var_exp, quantile(bindf$var_exp, seq(0, 1, length = nbins + 1), na.rm = TRUE),
#                    include.lowest = T)
#
#   # bindf$cut <- cut(bindf$var_exp, seq(min(bindf$var_exp), max(bindf$var_exp), length = nbins + 1),
#   #                  include.lowest = T)
#
#
#   binDFobs <- bindf[bindf$iters %in% it, c('var_exp', 'resid_obs', 'iters')]
#
#   if (type == 'quantiles') {
#     binDFrep <- c()
#     for (x in split(bindf, bindf$cut)) {
#       temp <- data.frame(
#         mean_var_exp = mean(x$var_exp, na.rm = TRUE),
#         mean_resid_rep = sapply(split(x$resid_rep, x$iters), mean, na.rm = TRUE)
#       )
#       binDFrep <- rbind(binDFrep,
#                         data.frame(
#                           cut = x$cut[1],
#                           x = unique(temp$mean_var_exp),
#                           lo = quantile(temp$mean_resid_rep, 0.025, na.rm = TRUE),
#                           hi = quantile(temp$mean_resid_rep, 0.975, na.rm = TRUE)
#                         )
#       )
#     }
#
#
#     # binDFrep <- c()
#     # bindf <- bindf[order(bindf$resid_rep), ]
#     # # bindf <- bindf[order(bindf$var_exp), ]
#     #
#     # bindf$llim <- bindf$var_exp - bdw
#     # bindf$ulim <- bindf$var_exp + bdw
#     # # S <- order(bindf$resid_rep)
#     # # s <- sort(bindf$resid_rep)
#     # # #
#     # # bindf$candid <- T
#     #
#     # for (i in 1:nrow(bindf)) {
#     #
#     #   rows <- (bindf$var_exp > bindf$llim[i]) + (bindf$var_exp < bindf$ulim[i]) == 2
#     #
#     #   s <- bindf$resid_rep[rows]
#     #
#     #   binDFrep <- rbind(binDFrep,
#     #                     c(var_exp = bindf$var_exp[i],
#     #                       lo = s[max(1, round(length(s) * 0.025))],
#     #                       hi = s[min(length(s), round(length(s) * 0.975))]
#     #                     )
#     #   )
#     # }
#
#     p <- ggplot2::ggplot(binDFrep) +
#       ggplot2::geom_ribbon(ggplot2::aes(x = x, ymin = .data$lo, ymax = .data$hi),
#                            alpha = 0.3) +
#       ggplot2::geom_point(data = binDFobs,
#                           ggplot2::aes(x = var_exp, y = resid_obs, color = .data$iters,
#                                        group = factor(.data$iters)), lwd = 1) +
#       ggplot2::geom_hline(yintercept = 0) +
#       ggplot2::theme(legend.position = 'none')
#
#   } else {
#     binDFrep <- bindf
#
#     # binDFrep <- c()
#     # for (x in split(bindf, bindf$cut)) {
#     #   binDFrep <- rbind(binDFrep,
#     #                     data.frame(
#     #                       mean_var_exp = mean(x$var_exp, na.rm = TRUE),
#     #                       mean_resid_rep = sapply(split(x$resid_rep, x$iters), mean, na.rm = TRUE),
#     #                       iters = names(split(x$resid_rep, x$iters)),
#     #                       cut = x$cut[1]
#     #                     )
#     #   )
#     # }
#
#     if (type == 'trajectories')
#       p <- ggplot2::ggplot(binDFrep) +
#         ggplot2::geom_line(ggplot2::aes(x = var_exp, y = resid_rep,
#                                         group = factor(iters)), alpha = 0.3,
#                            color = grDevices::grey(0.5)) +
#         ggplot2::geom_line(data = binDFobs,
#                            ggplot2::aes(x = var_exp, y = resid_obs,
#                                         color = iters, group = factor(iters)),
#                            lwd = 1) +
#         ggplot2::geom_hline(yintercept = 0) +
#         ggplot2::theme(legend.position = 'none')
#
#     if (type == 'dots')
#       p <- ggplot2::ggplot(binDFrep) +
#         ggplot2::geom_point(ggplot2::aes(x = var_exp, y = resid_rep,
#                                          group = factor(iters)), alpha = 0.3,
#                             color = grDevices::grey(0.5)) +
#         ggplot2::geom_point(data = binDFobs,
#                             ggplot2::aes(x = var_exp, y = resid_obs, color = iters,
#                                          group = factor(iters)), size = 1.5) +
#         ggplot2::geom_hline(yintercept = 0) +
#         ggplot2::theme(legend.position = 'none')
#   }
#   return(p)
# }
#
#
# plot_resid_KM <- function(object) {
#   MCMC <- do.call(rbind, object$MCMC)
#
#   y_name <- colnames(object$Mlist$y)
#
#   # y_rep <- MCMC[, grep(paste0(y_name, "_ppc\\["), colnames(MCMC))]
#   y_exp <- MCMC[, grep(paste0('mu_', y_name, "\\["), colnames(MCMC))]
#   y <- object$data_list[["ctime"]]
#   shape <- MCMC[, grep(paste0('shape_', y_name), colnames(MCMC))]
#
#   resid_y <- t(sapply(seq_len(nrow(y_exp)), function(k) (log(y) - log(y_exp[k, ]))/shape[k]))
#
#   resKM <- lapply(1:500, function(k) {
#     KM <- survival::survfit(survival::Surv(resid_y[k, ],
#                                            as.numeric(object$data$death)) ~ 1)
#     data.frame(time = KM$time, surv = KM$surv)
#   })
#
#   plot(resKM[[1]], type = 'l')
#   for (k in 2:length(resKM))
#     lines(resKM[[k]])
#
#   plot(resKM, mark.time = FALSE, xlab = 'AFT Residuals', ylab = 'Survival Probability')
#   xx <- seq(min(c(resid_y)), max(c(resid_y)), length.out = 35)
#   yy <- exp(-exp(xx))
#   lines(xx, yy, col = 'red')
# }
#
#
ppc_dens <- function(object, nit, var) {
  if (var %in% names(object$Mlist$refs))
    var_dum <- attr(object$Mlist$refs[[var]], 'dummies')
  else
    var_dum <- var

  MCMC <- do.call(rbind, object$MCMC)
  it <- sample(1:nrow(MCMC), size = nit)

  var_rep <- MCMC[it, grep(paste0(var, "_ppc\\["), colnames(MCMC))]

  obs <- if (var_dum %in% names(object$data_list)) {
    object$data_list[[var_dum]]
  } else if (var_dum %in% colnames(object$data_list$Xc)) {
    c(object$data_list$Xc[, var_dum])
  }

  a <- data.frame(iter = 'obs',
                  value = obs, stringsAsFactors = FALSE)

  b <- reshape2::melt(as.data.frame(cbind(iter = 1:nrow(var_rep),
                                          var_rep), stringsAsFactors = FALSE),
                      id.vars = 'iter',
                      variable.name = 'id')
  plotDF <- rbind(a, b[, names(b) != 'id'])

  ggplot2::ggplot(plotDF, ggplot2::aes(x = value, group = iter,
                                       size = ifelse(iter == 'obs', 'observed', 'replicated'),
                                       alpha = ifelse(iter == 'obs', 'observed', 'replicated'))) +
    ggplot2::geom_line(stat = 'density', position = 'identity') +
    ggplot2::scale_size_manual(name = '',
                               limits = c('observed', 'replicated'),
                               values = c(1, 0.25)) +
    ggplot2::scale_alpha_manual(name = '',
                                limits = c('observed', 'replicated'),
                                values = c(1, 0.3))


}
#
# plot_qq <- function(object, var, nit, nbins, ...) {
#
#   if (var %in% names(object$Mlist$refs))
#     var_dum <- attr(object$Mlist$refs[[var]], 'dummies')
#   else
#     var_dum <- var
#
#
#   MCMC <- do.call(rbind, object$MCMC)
#   it <- sample(1:nrow(MCMC), size = nit)
#
#   var_rep <- MCMC[, grep(paste0(var, "_ppc\\["), colnames(MCMC))]
#   var_exp <- MCMC[, grep(paste0('mu_', var, "\\["), colnames(MCMC))]
#
#   obs <- if (var_dum %in% names(object$data_list)) {
#     object$data_list[[var_dum]]
#   } else if (var_dum %in% colnames(object$data_list$Xc)) {
#     c(object$data_list$Xc[, var_dum])
#   }
#
#   resid_obs <- t(apply(var_exp, 1, function(x) obs - x))
#   resid_rep <- var_rep - var_exp
#
#   names(dimnames(resid_obs)) <- names(dimnames(resid_rep)) <-
#     names(dimnames(var_exp)) <- c('iters', 'subj')
#
#
#   dat1 <- reshape2::melt(var_exp, value.name = 'var_exp')
#   dat1$subj <- gsub('\\[|\\]', '',
#                     regmatches(as.character(dat1$subj),
#                                regexpr('\\[[[:digit:]]*\\]', as.character(dat1$subj))))
#
#   dat2 <- reshape2::melt(resid_obs, value.name = 'resid_obs')
#   dat3 <- reshape2::melt(resid_rep, value.name = 'resid_rep')
#
#   bindf <- cbind(dat1, resid_obs = dat2$resid_obs, resid_rep = dat3$resid_rep)
#   bindf <- bindf[order(bindf$var_exp), ]
#
#   bindf$cut <- cut(bindf$var_exp, quantile(bindf$var_exp, seq(0, 1, length = nbins + 1), na.rm = TRUE),
#                    include.lowest = T)
#
#
#   q_obs <- quantile(scale(resid_obs), seq(0, 1, length = 100), na.rm = T)
#   q_rep <- quantile(scale(resid_rep), seq(0, 1, length = 100), na.rm = T)
#
#   plot(q_rep, q_obs)
#   abline(a = 0, b = 1, col = 2)
#
# }
