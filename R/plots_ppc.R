# plot_ppc <- function(object, fun, var, type = c('histogram', 'density',
#  'chainwise_dens'), ...) {
#
#   type <- match.arg(type)
#
#   if (var %in% names(object$Mlist$refs))
#     var_dum <- attr(object$Mlist$refs[[var]], 'dummies')
#   else
#     var_dum <- var
#
#   var_rep <- object$MCMC[, grep(paste0(var, "_ppc\\["),
#    colnames(object$MCMC[[1]]))]
#
#   if (object$analysis_type == 'survreg' & var == colnames(object$Mlist$y)) {
#     obs <- object$data_list$ctime
#     cens <- ifelse(object$data_list$cens == 1, 'censored', 'event observed')
#   } else {
#     obs <- if (var_dum %in% names(object$data_list)) {
#       object$data_list[[var_dum]]
#     } else if (var_dum %in% colnames(object$data_list$Xc)) {
#                 c(object$data_list$Xc[, var_dum])
#     }
#     cens <- 0
#   }
#
#   value_obs <- if (any(c('...', 'na.rm') %in% names(formals(fun))))
#     reshape2::melt(lapply(split(obs, cens), fun, na.rm = TRUE))
#   else
#     reshape2::melt(lapply(split(obs, cens), fun))
#
#   names(value_obs) <- gsub('L1', 'group', names(value_obs))
#
#   l <- lapply(var_rep, apply, MARGIN = 1, function(x) {
#     lapply(split(x, cens), fun)
#   })
#
#   names(l) <- as.character(1:length(l))
#   value_rep <- reshape2::melt(l)
#   names(value_rep) <- gsub('L1', 'chain', names(value_rep))
#   names(value_rep) <- gsub('L2', 'iteration', names(value_rep))
#   names(value_rep) <- gsub('L3', 'group', names(value_rep))
#
#
#   p <- ggplot2::ggplot(value_rep, ggplot2::aes(x = value)) +
#     ggplot2::xlab(var)
#
#   if (type == 'histogram')
#     p <- p + ggplot2::geom_histogram(...)
#   if (type == 'density')
#     p <- p + ggplot2::geom_density(...)
#   if (type == 'chainwise_dens')
#     p <- p + ggplot2::geom_density(ggplot2::aes(color = chain), ...)
#
#
#   p <- p + ggplot2::geom_vline(data = value_obs,
#   ggplot2::aes(xintercept = value))
#
#   if (object$analysis_type == 'survreg')
#     print(p + ggplot2::facet_wrap('group'))
#   else print(p)
#
#   invisible(list(value_rep = value_rep, value_obs = value_obs))
# }
#
#

## plot binned residuals
##
## @importFrom rlang .data
##
#
#
# plot_resid_binned <- function(object, nbins, nit, var,
#                             type = c('quantiles', "trajectories",
#                             'dots'), ...) {
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
#                                regexpr('\\[[[:digit:]]*\\]',
#                                 as.character(dat1$subj))))
#
#   dat2 <- reshape2::melt(resid_obs, value.name = 'resid_obs')
#   dat3 <- reshape2::melt(resid_rep, value.name = 'resid_rep')
#
#   bindf <- cbind(dat1, resid_obs = dat2$resid_obs, resid_rep = dat3$resid_rep)
#
#   bindf$cut <- cut(bindf$var_exp, quantile(bindf$var_exp,
#                                            seq(0, 1, length = nbins + 1),
#                                             na.rm = TRUE),
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
#                                             y = mean(i$resid_obs,
#                                             na.rm = TRUE),
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
#         mean_resid_rep = sapply(split(x$resid_rep, x$iters), mean,
#          na.rm = TRUE)
#       )
#       binDFrep <- rbind(binDFrep,
#                         data.frame(
#                           cut = x$cut[1],
#                           x = unique(temp$mean_var_exp),
#                           lo = quantile(temp$mean_resid_rep, 0.025,
#                           na.rm = TRUE),
#                           hi = quantile(temp$mean_resid_rep, 0.975,
#                            na.rm = TRUE)
#                         )
#       )
#     }
#
#     p <- ggplot2::ggplot(binDFrep) +
#       ggplot2::geom_ribbon(ggplot2::aes(x = x, ymin = .data$lo,
#       ymax = .data$hi),
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
#         ggplot2::geom_line(ggplot2::aes(x = .data$mean_var_exp,
#         y = .data$mean_resid_rep,
#                                         group = factor(.data$iters)),
#                                          alpha = 0.3,
#                            color = grDevices::grey(0.5)) +
#         ggplot2::geom_line(data = binDFobs,
#                            ggplot2::aes(x = x, y = y, color = .data$iters,
#                                         group = factor(.data$iters)),
#                                          lwd = 1) +
#         ggplot2::geom_hline(yintercept = 0) +
#         ggplot2::theme(legend.position = 'none')
#
#     if (type == 'dots')
#       p <- ggplot2::ggplot(binDFrep) +
#         ggplot2::geom_point(ggplot2::aes(x = .data$mean_var_exp,
#         y = .data$mean_resid_rep,
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
#                                   type = c('quantiles', "trajectories",
#                                   'dots'), ...) {
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
#                                regexpr('\\[[[:digit:]]*\\]',
#                                as.character(dat1$subj))))
#
#   dat2 <- reshape2::melt(resid_obs, value.name = 'resid_obs')
#   dat3 <- reshape2::melt(resid_rep, value.name = 'resid_rep')
#
#   bindf <- cbind(dat1, resid_obs = dat2$resid_obs, resid_rep = dat3$resid_rep)
#   bindf <- bindf[order(bindf$var_exp), ]
#
#   bindf$cut <- cut(bindf$var_exp, quantile(bindf$var_exp,
#   seq(0, 1, length = nbins + 1), na.rm = TRUE),
#                    include.lowest = T)
#
#   # bindf$cut <- cut(bindf$var_exp, seq(min(bindf$var_exp),
#   max(bindf$var_exp), length = nbins + 1),
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
#         mean_resid_rep = sapply(split(x$resid_rep, x$iters), mean,
#         na.rm = TRUE)
#       )
#       binDFrep <- rbind(binDFrep,
#                         data.frame(
#                           cut = x$cut[1],
#                           x = unique(temp$mean_var_exp),
#                           lo = quantile(temp$mean_resid_rep, 0.025,
#                           na.rm = TRUE),
#                           hi = quantile(temp$mean_resid_rep, 0.975,
#                           na.rm = TRUE)
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
#     #   rows <- (bindf$var_exp > bindf$llim[i]) +
#     (bindf$var_exp < bindf$ulim[i]) == 2
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
#       ggplot2::geom_ribbon(ggplot2::aes(x = x, ymin = .data$lo,
#       ymax = .data$hi),
#                            alpha = 0.3) +
#       ggplot2::geom_point(data = binDFobs,
#                           ggplot2::aes(x = var_exp, y = resid_obs,
#                           color = .data$iters,
#                                        group = factor(.data$iters)),
#                                         lwd = 1) +
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
#     #                       mean_resid_rep = sapply(split(x$resid_rep,
#     x$iters), mean, na.rm = TRUE),
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
#                             ggplot2::aes(x = var_exp, y = resid_obs,
#                             color = iters,
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
#   resid_y <- t(sapply(seq_len(nrow(y_exp)), function(k)
#   (log(y) - log(y_exp[k, ]))/shape[k]))
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
#   plot(resKM, mark.time = FALSE, xlab = 'AFT Residuals',
#   ylab = 'Survival Probability')
#   xx <- seq(min(c(resid_y)), max(c(resid_y)), length.out = 35)
#   yy <- exp(-exp(xx))
#   lines(xx, yy, col = 'red')
# }
#
#
# ppc_dens <- function(object, nit) {
#   if (var %in% names(object$Mlist$refs))
#     var_dum <- attr(object$Mlist$refs[[var]], 'dummies')
#   else
#     var_dum <- var
#

#   MCMC <- do.call(rbind, object$MCMC)
#   it <- sample(1:nrow(MCMC), size = nit)
#
#   var_rep <- MCMC[it, grep(paste0(var, "_ppc\\["), colnames(MCMC))]
#
#   obs <- if (var_dum %in% names(object$data_list)) {
#     object$data_list[[var_dum]]
#   } else if (var_dum %in% colnames(object$data_list$Xc)) {
#     c(object$data_list$Xc[, var_dum])
#   }
#
#   a <- data.frame(iter = 'obs',
#                   value = obs, stringsAsFactors = FALSE)
#
#   b <- reshape2::melt(as.data.frame(cbind(iter = 1:nrow(var_rep),
#                                           var_rep), stringsAsFactors = FALSE),
#                       id.vars = 'iter',
#                       variable.name = 'id')
#   plotDF <- rbind(a, b[, names(b) != 'id'])
#
#   ggplot2::ggplot(plotDF, ggplot2::aes(x = value, group = iter,
#                                        size = ifelse(iter == 'obs',
#                                         'observed', 'replicated'),
#                                        alpha = ifelse(iter == 'obs',
#                                         'observed', 'replicated'))) +
#     ggplot2::geom_line(stat = 'density', position = 'identity') +
#     ggplot2::scale_size_manual(name = '',
#                                limits = c('observed', 'replicated'),
#                                values = c(1, 0.25)) +
#     ggplot2::scale_alpha_manual(name = '',
#                                 limits = c('observed', 'replicated'),
#                                 values = c(1, 0.3))
#
#
# }
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
#                                regexpr('\\[[[:digit:]]*\\]',
#                                as.character(dat1$subj))))
#
#   dat2 <- reshape2::melt(resid_obs, value.name = 'resid_obs')
#   dat3 <- reshape2::melt(resid_rep, value.name = 'resid_rep')
#
#   bindf <- cbind(dat1, resid_obs = dat2$resid_obs, resid_rep = dat3$resid_rep)
#   bindf <- bindf[order(bindf$var_exp), ]
#
#   bindf$cut <- cut(bindf$var_exp, quantile(bindf$var_exp,
#   seq(0, 1, length = nbins + 1), na.rm = TRUE),
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
