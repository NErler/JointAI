plot_ppc <- function(object, fun) {
  y_name <- colnames(object$Mlist$y)

  y_rep <- object$MCMC[, grep(paste0(y_name, "_ppc\\["), colnames(object$MCMC[[1]]))]

  if (object$analysis_type == 'survreg') {
    y <- object$data_list$ctime
    cens <- ifelse(object$data_list$cens == 1, 'censored', 'event observed')
  } else {
    y <- object$data_list[[y_name]]
    cens <- 0
  }

  value_obs <- reshape2::melt(lapply(split(y, cens), fun))
  names(value_obs) <- gsub('L1', 'group', names(value_obs))

  l <- lapply(y_rep, apply, MARGIN = 1, function(x) {
    lapply(split(x, cens), fun)
  })

  names(l) <- as.character(1:length(l))
  value_rep <- reshape2::melt(l)
  names(value_rep) <- gsub('L1', 'chain', names(value_rep))
  names(value_rep) <- gsub('L2', 'iteration', names(value_rep))
  names(value_rep) <- gsub('L3', 'group', names(value_rep))


  p <- ggplot(value_rep, aes(x = value)) +
    geom_density(aes(color = chain)) +
    geom_vline(data = value_obs, aes(xintercept = value)) +
    xlab(y_name)

  if (object$analysis_type == 'survreg')
    p + facet_wrap('group')
  else p
}



plot_ppc_binned <- function(object, nbins, nit,
                            type = c('quantiles', "trajectories", 'dots'), ...) {

  type = match.arg(type)

  MCMC <- do.call(rbind, object$MCMC)

  y_name <- colnames(object$Mlist$y)

  y_rep <- MCMC[, grep(paste0(y_name, "_ppc\\["), colnames(MCMC))]
  y_exp <- MCMC[, grep(paste0('mu_', y_name, "\\["), colnames(MCMC))]

  y <- object$data_list[[y_name]]

  resid_y <- t(apply(y_exp, 1, function(x) y - x))
  resid_rep <- y_rep - y_exp

  names(dimnames(resid_y)) <- names(dimnames(resid_rep)) <- names(dimnames(y_exp)) <- c('iters', 'subj')


  dat1 <- reshape2::melt(y_exp, value.name = 'y_exp')
  dat1$subj <- gsub('\\[|\\]', '',
                    regmatches(as.character(dat1$subj),
                               regexpr('\\[[[:digit:]]*\\]', as.character(dat1$subj))))

  dat2 <- reshape2::melt(resid_y, value.name = 'resid_y')
  dat3 <- reshape2::melt(resid_rep, value.name = 'resid_rep')

  bindf <- cbind(dat1, resid_y = dat2$resid_y, resid_rep = dat3$resid_rep)

  bindf$cut <- cut(bindf$y_exp, quantile(bindf$y_exp, seq(0, 1, length = nbins + 1)),
                   include.lowest = T)

  it <- sample(1:nrow(MCMC), size = nit)

  binDFobs <- do.call(rbind,
                      lapply(split(bindf, bindf$cut),
                             function(x) {
                               subdat <- subset(x, subset = iters %in% it)
                               a <- split(subdat, subdat$iters)
                               do.call(rbind, lapply(a, function(i)
                                 data.frame(x = mean(i$y_exp),
                                            y = mean(i$resid_y),
                                            iters = unique(i$iters),
                                            cut = unique(i$cut)))
                               )
                             }
                      )
  )

  if (type == 'quantiles') {
    binDFrep <- c()
    for (x in split(bindf, bindf$cut)) {
      temp <- data.frame(
        mean_y_exp = mean(x$y_exp),
        mean_resid_rep = sapply(split(x$resid_rep, x$iters), mean)
      )
      binDFrep <- rbind(binDFrep,
                        data.frame(
                          cut = x$cut[1],
                          x = unique(temp$mean_y_exp),
                          lo = quantile(temp$mean_resid_rep, 0.025),
                          hi = quantile(temp$mean_resid_rep, 0.975)
                        )
      )
    }

    p <- ggplot(binDFrep) +
      geom_ribbon(aes(x = x, ymin = lo, ymax = hi), alpha = 0.3) +
      geom_line(data = binDFobs, aes(x = x, y = y, color = iters, group = factor(iters)), lwd = 1) +
      geom_hline(yintercept = 0) +
      theme(legend.position = 'none')

  } else {
    binDFrep <- c()
    for (x in split(bindf, bindf$cut)) {
      binDFrep <- rbind(binDFrep,
                        data.frame(
                          mean_y_exp = mean(x$y_exp),
                          mean_resid_rep = sapply(split(x$resid_rep, x$iters), mean),
                          iters = names(split(x$resid_rep, x$iters)),
                          cut = x$cut[1]
                        )
      )
    }

    if (type == 'trajectories')
      p <- ggplot(binDFrep) +
        geom_line(aes(x = mean_y_exp, y = mean_resid_rep, group = factor(iters)), alpha = 0.3, color = grey(0.5)) +
        geom_line(data = binDFobs, aes(x = x, y = y, color = iters, group = factor(iters)), lwd = 1) +
        geom_hline(yintercept = 0) +
        theme(legend.position = 'none')

    if (type == 'dots')
      p <- ggplot(binDFrep) +
        geom_point(aes(x = mean_y_exp, y = mean_resid_rep, group = factor(iters)), alpha = 0.3, color = grey(0.5)) +
        geom_point(data = binDFobs, aes(x = x, y = y, color = iters, group = factor(iters)), size = 1.5) +
        geom_hline(yintercept = 0) +
        theme(legend.position = 'none')

  }
  return(p)
}




plot_resid_KM <- function(object) {
  MCMC <- do.call(rbind, object$MCMC)

  y_name <- colnames(object$Mlist$y)

  # y_rep <- MCMC[, grep(paste0(y_name, "_ppc\\["), colnames(MCMC))]
  y_exp <- MCMC[, grep(paste0('mu_', y_name, "\\["), colnames(MCMC))]
  y <- object$data_list[["ctime"]]
  shape <- MCMC[, grep(paste0('shape_', y_name), colnames(MCMC))]

  resid_y <- t(sapply(seq_len(nrow(y_exp)), function(k) (log(y) - log(y_exp[k, ]))/shape[k]))

  resKM <- lapply(1:500, function(k) {
    KM <- survfit(Surv(resid_y[k, ], as.numeric(object$data$death)) ~ 1)
    data.frame(time = KM$time, surv = KM$surv)
  })

  plot(resKM[[1]], type = 'l')
  for (k in 2:length(resKM))
    lines(resKM[[k]])

  plot(resKM, mark.time = FALSE, xlab = 'AFT Residuals', ylab = 'Survival Probability')
  xx <- seq(min(c(resid_y)), max(c(resid_y)), length.out = 35)
  yy <- exp(-exp(xx))
  lines(xx, yy, col = 'red')
}
