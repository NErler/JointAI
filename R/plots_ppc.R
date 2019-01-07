#' Plot the observed and replicated density of a continuous node
#' @inheritparams sharedParams
#' @param nit number of randomy chosen iterations from the replications
#' @param color color for the lines
#'
#'
#' @export
#'
plot_ppc_dens <- function(object, variable, nit = 10, seed = NULL, color = 'black') {

  if (missing(variable)) {
    variable <- all.vars(object$fixed)
  }

  # exclude variables that are not numeric
  variable <- variable[sapply(object$data[variable], is.numeric)]
  variable <- variable[variable %in% c(colnames(object$Mlist$y), names(object$meth))]

  MCMC <- do.call(rbind, object$MCMC)

  if (!is.null(seed))
    set.seed(seed)

  it <- sample(1:nrow(MCMC), size = nit)

  var_rep <- sapply(variable, function(v) {
    MCMC[it, grep(paste0(v, "_ppc\\["), colnames(MCMC))]
  }, simplify = FALSE)


  obs <- sapply(variable, function(v) {
    if (v %in% names(object$data_list)) {
      object$data_list[[v]]
    } else if (v %in% colnames(object$data_list$Xc)) {
      c(object$data_list$Xc[, v])
    }}, simplify = FALSE)

  if (object$analysis_type %in% c('survreg')) {
    var_rep[[colnames(object$Mlist$y)]] <-
      var_rep[[colnames(object$Mlist$y)]][, object$data_list$cens == 0]

    obs[[colnames(object$Mlist$y)]] <-
      obs[[colnames(object$Mlist$y)]][object$data_list$cens == 0]

    names(obs)[names(obs) == colnames(object$Mlist$y)] <-
      paste0(names(obs)[names(obs) == colnames(object$Mlist$y)], " (event observed)")
    names(var_rep)[names(var_rep) == colnames(object$Mlist$y)] <-
      paste0(names(var_rep)[names(var_rep) == colnames(object$Mlist$y)], " (event observed)")
  }


  a <- as.data.frame(c(iter = as.character('obs'),
                       reshape2::melt(obs)),
                     stringsAsFactors = FALSE)

  b <- reshape2::melt(sapply(names(var_rep), function(k) {
    as.data.frame(cbind(iter = 1:nrow(var_rep[[k]]),
                        var_rep[[k]]), stringsAsFactors = FALSE)
  }, simplify = FALSE), id.vars = 'iter', variable.name = 'id')


  plotDF <- rbind(a[, c('iter', 'value', 'L1')],
                  b[, c('iter', 'value', 'L1')])

  ggplot2::ggplot(plotDF, ggplot2::aes(x = value, group = iter,
                                       size = ifelse(iter == 'obs', 'observed', 'replicated'),
                                       alpha = ifelse(iter == 'obs', 'observed', 'replicated'))) +
    ggplot2::geom_line(stat = 'density', position = 'identity', color = color, na.rm = TRUE) +
    ggplot2::scale_size_manual(name = '',
                               limits = c('observed', 'replicated'),
                               values = c(1, 0.25)) +
    ggplot2::scale_alpha_manual(name = '',
                                limits = c('observed', 'replicated'),
                                values = c(1, 0.3)) +
    ggplot2::facet_wrap('L1', scales = 'free') +
    ggplot2::theme_bw() +
    ggplot2::theme(legend.position = 'bottom',
                   panel.background = ggplot2::element_rect(fill = 'transparent'),
                   panel.grid = ggplot2::element_blank(),
                   legend.margin = ggplot2::margin(-0.5,0,0,0, unit="cm")) +
    ggplot2::xlab('')
}


#' Plot a statistic for the observed and replicated data
#' @inheritParams sharedParams
#' @param stat the statistic to be used; can be specified by the name of a
#'             function as a character string or the function itself
#' @param type one of 'histogram', 'density' or 'chainwise_dens'; may be abbreviated
#'
#' @export
#'
plot_ppc_stat <- function(object, stat, variable,
                     type = c('histogram', 'density', 'chainwise_dens'), ...) {

  type <- match.arg(type)

  thecall <- as.list(match.call())

  if (class(thecall$stat) == "call") {
    xlab <- deparse(body(stat))
  } else {
    xlab <- thecall$stat
  }


  if (missing(variable)) {
    variable <- all.vars(object$fixed)
  }

  variable <- variable[variable %in% c(colnames(object$Mlist$y), names(object$meth))]

  var_dum <- sapply(variable, function(v) {
  if (v %in% names(object$Mlist$refs))
    attr(object$Mlist$refs[[v]], 'dummies')
  else
    v
  })

  var_rep <- sapply(variable, function(v) {
                    object$MCMC[, grep(paste0(v, "_ppc\\["),
                                       colnames(object$MCMC[[1]]))]
  }, simplify = FALSE)

  obs <- sapply(var_dum, function(v) {
    if (v %in% names(object$data_list)) {
      object$data_list[[v]]
    } else if (v %in% colnames(object$data_list$Xc)) {
      c(object$data_list$Xc[, v])
    }}, simplify = FALSE)


  if (object$analysis_type %in% c('survreg')) {
    var_rep[[colnames(object$Mlist$y)]] <-
      var_rep[[colnames(object$Mlist$y)]][, object$data_list$cens == 0]

    obs[[colnames(object$Mlist$y)]] <-
      obs[[colnames(object$Mlist$y)]][object$data_list$cens == 0]

    names(obs)[names(obs) == colnames(object$Mlist$y)] <-
      paste0(names(obs)[names(obs) == colnames(object$Mlist$y)], " (event observed)")
    names(var_rep)[names(var_rep) == colnames(object$Mlist$y)] <-
      paste0(names(var_rep)[names(var_rep) == colnames(object$Mlist$y)], " (event observed)")
  }

  value_obs <- if (any(c('...', 'na.rm') %in% names(formals(stat))))
    reshape2::melt(lapply(obs, stat, na.rm = TRUE))
  else
    reshape2::melt(lapply(obs, stat))

  names(value_obs) <- gsub('L1', 'variable', names(value_obs))

  l <- lapply(var_rep, function(z) {
    reshape2::melt(sapply(z, function(x) {
      apply(x, MARGIN = 1, stat)
    }), varnames = c('iter', 'chain'))
  })

  value_rep <- reshape2::melt(l, id.vars = colnames(l[[1]]))
  names(value_rep) <- gsub('L1', 'variable', names(value_rep))
  value_rep$chain <- factor(value_rep$chain)


  p <- ggplot(value_rep, aes(x = value)) +
    xlab(xlab)

  if (type == 'histogram')
    p <- p + geom_histogram(...)
  if (type == 'density')
    p <- p + geom_density(...)
  if (type == 'chainwise_dens')
    p <- p + geom_line(stat = 'density', aes(color = chain), ...)

  p +
    geom_vline(data = value_obs, aes(xintercept = value)) +
    facet_wrap('variable', scales = 'free')
  # invisible(list(value_rep = value_rep, value_obs = value_obs))
}


#' plot the binned residuals for categorical variables
#' @inheritParams sharedParams
#' @param nbins number of bins
#' @param nit number of iterations to be plotted
#' @param variable variable for which the residuals should be potted; optional
#' @param type one of "quantile" or "dots
#'
#' @export

plot_resid_binned <- function(object, nbins, nit = c(10, 200), variable,
                            type = c('quantiles', 'dots'),
                            seed, ...) {

  type = match.arg(type)


  if (missing(variable)) {
    variable <- all.vars(object$fixed)
  }
  variable <- variable[variable %in% c(colnames(object$Mlist$y), names(object$meth))]
  variable <- variable[sapply(object$data[variable], class) == 'factor']

  if (length(variable) == 0)
    stop("No categorical vaiable.")


  var_dum <- sapply(variable, function(v) {
    if (v %in% names(object$Mlist$refs))
      attr(object$Mlist$refs[[v]], 'dummies')
    else
      v
  })

  MCMC <- do.call(rbind, object$MCMC)

  if (!missing(seed))
    set.seed(seed)

  if (type == 'quantiles')
    nit[2] <- nrow(MCMC)

  it <- list(obs = sample(1:nrow(MCMC), size = nit[1]),
             rep = sample(1:nrow(MCMC), size = nit[2])
  )

  var_rep <- sapply(variable, function(v) {
    mat <- MCMC[sort(unique(unlist(it))),
                grep(paste0(v, "_ppc\\["), colnames(MCMC))]
    names(dimnames(mat)) <- c('iters', 'subj')
    dimnames(mat)[[1]] <- sort(unique(unlist(it)))
    mat
  }, simplify = FALSE)

  var_exp <- sapply(variable, function(v) {
    mat <- MCMC[sort(unique(unlist(it))),
                grep(paste0('mu_', v, "\\["), colnames(MCMC))]
    names(dimnames(mat)) <- c('iters', 'subj')
    dimnames(mat)[[1]] <- sort(unique(unlist(it)))
    mat
  }, simplify = FALSE)

  obs <- sapply(var_dum, function(v) {
    if (v %in% names(object$data_list)) {
      object$data_list[[v]]
    } else if (v %in% colnames(object$data_list$Xc)) {
      c(object$data_list$Xc[, v])
    }}, simplify = FALSE)

  resid_obs <- mapply(FUN = function(o, e) {
    t(apply(e, 1, function(x) o - x))
  }, o = obs, e = var_exp, SIMPLIFY = FALSE)

  resid_rep <- mapply(FUN = function(r, e) {
    r - e
  }, r = var_rep, e = var_exp, SIMPLIFY = FALSE)

  dat1 <- reshape2::melt(var_exp, value.name = 'var_exp')
  dat2 <- reshape2::melt(resid_obs, value.name = 'resid_obs')
  dat3 <- reshape2::melt(resid_rep, value.name = 'resid_rep')

  bindf <- cbind(dat2, var_exp = dat1$var_exp, resid_rep = dat3$resid_rep)


  bindf <- do.call(rbind, lapply(split(bindf, bindf$L1), function(x) {
    x$cut <- cut(x$var_exp, quantile(x$var_exp,
                                     seq(0, 1, length = nbins + 1),
                                     na.rm = TRUE),
                 include.lowest = T)
    x
  }))


  subdat <- subset(bindf, subset = iters %in% it[[1]])

  a <- split(subdat, list(subdat$L1, subdat$iters, subdat$cut))
  a <- a[sapply(a, nrow) > 0]
  binDFobs <- do.call(rbind, lapply(a, function(i) {
      data.frame(x = mean(i$var_exp, na.rm = TRUE),
                 y = mean(i$resid_obs, na.rm = TRUE),
                 iters = unique(i$iters),
                 cut = unique(i$cut),
                 variable = unique(i$L1)
                 )
    })
  )


  if (type == 'quantiles') {
    s <- split(bindf, list(bindf$cut, bindf$L1))
    s <- s[sapply(s, nrow) > 0]

    binDFrep <- c()
    for (x in s) {
      temp <- data.frame(
        mean_var_exp = mean(x$var_exp, na.rm = TRUE),
        mean_resid_rep = sapply(split(x$resid_rep, x$iters), mean, na.rm = TRUE)
      )
      binDFrep <- rbind(binDFrep,
                        data.frame(
                          cut = x$cut[1],
                          x = unique(temp$mean_var_exp),
                          lo = quantile(temp$mean_resid_rep, 0.025, na.rm = TRUE),
                          hi = quantile(temp$mean_resid_rep, 0.975, na.rm = TRUE),
                          variable = x$L1[1]
                        )
      )
    }

    p <- ggplot(binDFrep) +
      geom_ribbon(aes(x = x, ymin = lo, ymax = hi), alpha = 0.3) +
      geom_point(data = binDFobs, aes(x = x, y = y, color = iters, group = factor(iters)), lwd = 1) +
      geom_hline(yintercept = 0) +
      facet_wrap('variable', scales = 'free') +
      theme(legend.position = 'none')

  } else {
    subdat <- subset(bindf, subset = iters %in% it[[2]])
    s <- split(subdat, list(subdat$cut, subdat$L1))
    s <- s[sapply(s, nrow) > 0]

    binDFrep <- c()
    for (x in s) {
      binDFrep <- rbind(binDFrep,
                        data.frame(
                          mean_var_exp = mean(x$var_exp, na.rm = TRUE),
                          mean_resid_rep = sapply(split(x$resid_rep, x$iters), mean, na.rm = TRUE),
                          iters = names(split(x$resid_rep, x$iters)),
                          cut = x$cut[1],
                          variable = x$L1[1]
                        )
      )
    }


    if (type == 'dots')
      p <- ggplot(binDFrep) +
      facet_wrap('variable', scales = 'free') +
      geom_point(aes(x = mean_var_exp, y = mean_resid_rep,
                     group = factor(iters)), alpha = 0.3, color = grey(0.5)) +
      geom_point(data = binDFobs, aes(x = x, y = y, color = iters,
                                      group = factor(iters)), size = 1.5) +
      geom_hline(yintercept = 0) +
      theme(legend.position = 'none')

  }
  return(p)
}



plot_ppc <- function(object, variable,
                type = c('ppc', 'squared_error', 'MSE'), ...) {

    type <- match.arg(type)

    thecall <- as.list(match.call())

    # if (class(thecall$stat) == "call") {
    #   xlab <- deparse(body(stat))
    # } else {
    #   xlab <- thecall$stat
    # }


    if (missing(variable)) {
      variable <- all.vars(object$fixed)
    }

    variable <- variable[variable %in% c(colnames(object$Mlist$y), names(object$meth))]

    var_dum <- sapply(variable, function(v) {
      if (v %in% names(object$Mlist$refs))
        attr(object$Mlist$refs[[v]], 'dummies')
      else
        v
    })

    MCMC <- do.call(rbind, object$MCMC)

    var_rep <- sapply(variable, function(v) {
      mat <- MCMC[, grep(paste0(v, "_ppc\\["),
                         colnames(MCMC))]
      dimnames(mat)[[2]] <- 1:ncol(mat)
      names(dimnames(mat)) <- c('iter', 'id')
      mat
    }, simplify = FALSE)

    var_exp <- sapply(variable, function(v) {
      mat <- MCMC[, grep(paste0("mu_", v, "\\["),
                         colnames(MCMC))]
      dimnames(mat)[[2]] <- 1:ncol(mat)
      names(dimnames(mat)) <- c('iter', 'id')
      mat
    }, simplify = FALSE)

    obs <- sapply(var_dum, function(v) {
      if (v %in% names(object$data_list)) {
        object$data_list[[v]]
      } else if (v %in% colnames(object$data_list$Xc)) {
        c(object$data_list$Xc[, v])
      }}, simplify = FALSE)


    if (object$analysis_type %in% c('survreg')) {
      var_rep[[colnames(object$Mlist$y)]] <-
        var_rep[[colnames(object$Mlist$y)]][, object$data_list$cens == 0]

      var_exp[[colnames(object$Mlist$y)]] <-
        var_exp[[colnames(object$Mlist$y)]][, object$data_list$cens == 0]

      obs[[colnames(object$Mlist$y)]] <-
        obs[[colnames(object$Mlist$y)]][object$data_list$cens == 0]

      names(obs)[names(obs) == colnames(object$Mlist$y)] <-
        paste0(names(obs)[names(obs) == colnames(object$Mlist$y)], " (event observed)")
      names(var_rep)[names(var_rep) == colnames(object$Mlist$y)] <-
        paste0(names(var_rep)[names(var_rep) == colnames(object$Mlist$y)], " (event observed)")
      names(var_exp)[names(var_exp) == colnames(object$Mlist$y)] <-
        paste0(names(var_exp)[names(var_exp) == colnames(object$Mlist$y)], " (event observed)")
    }


    sqE_rep <- mapply(function(o, e) {
      (o - e)^2
    }, o = var_rep, e = var_exp, SIMPLIFY = FALSE)

    sqE_obs <- mapply(function(o, e) {
      (matrix(nrow = nrow(e), ncol = ncol(e), data = o, byrow = TRUE) - e)^2
    }, o = obs, e = var_exp, SIMPLIFY = FALSE)

    val_ppc <- mapply(function(o, r) {
      rowMeans((o - r) > 0, na.rm = TRUE) - 0.5
    }, o = sqE_obs, r = sqE_rep, SIMPLIFY = FALSE)


    sqE <- reshape2::melt(list(rep = sqE_rep, obs = sqE_obs))
    names(sqE) <- gsub('L2', 'variable', names(sqE))
    names(sqE) <- gsub('L1', 'type', names(sqE))

    MSE <- reshape2::melt(list(rep = lapply(sqE_rep, rowMeans, na.rm = TRUE),
                               obs = lapply(sqE_obs, rowMeans, na.rm = TRUE)))
    names(MSE) <- gsub('L2', 'variable', names(MSE))
    names(MSE) <- gsub('L1', 'type', names(MSE))

    ppc <- reshape2::melt(val_ppc)
    names(ppc) <- gsub('L1', 'variable', names(ppc))


    p1 <- ggplot(sqE, aes(x = value, color = type)) +
      geom_line(stat = 'density', na.rm = TRUE) +
      facet_wrap('variable', scales = 'free') +
      scale_x_continuous(trans = 'log') +
      xlab(expression(squared~error~(epsilon^2))) +
      theme_bw() +
      theme(legend.position = c(0.05, 0.9),
            legend.background = element_blank(),
            legend.key = element_blank(),
            panel.grid = element_blank(),
            panel.background = element_rect(fill = 'transparent')) +
      scale_color_discrete(name = "")

    p2 <- ggplot(MSE, aes(x = value, color = type)) +
      geom_line(stat = 'density', na.rm = TRUE) +
      facet_wrap('variable', scales = 'free') +
      xlab(expression(MSE:~frac(1,N)~sum(epsilon^2))) +
      theme_bw() +
      theme(legend.position = c(0.05, 0.9),
            legend.background = element_blank(),
            legend.key = element_blank(),
            panel.grid = element_blank(),
            panel.background = element_rect(fill = 'transparent')) +
      scale_color_discrete(name = "")

    p3 <- ggplot(ppc, aes(x = value)) +
      geom_line(stat = 'density') +
      facet_wrap('variable', scales = 'free') +
      geom_vline(xintercept = 0, lty = 2) +
      xlab(expression(bgroup("[", frac(1, N)~sum(bgroup("(",epsilon[obs]^2>epsilon[rep]^2, ")")),
                             "]")-0.5)) +
      theme_bw() +
      theme(legend.position = c(0.05, 0.9),
            legend.background = element_blank(),
            legend.key = element_blank(),
            panel.grid = element_blank(),
            panel.background = element_rect(fill = 'transparent'))

    if (type == 'squared_error')
      print(p1)
    if (type == 'MSE')
      print(p2)
    if (type == 'ppc')
      print(p3)

    invisible(list(squared_error = p1, MSE = p2, ppc = p3))
}


plot_resid_continuous <- function(object, var, nit, type = c('quantiles', "trajectories", 'dots'), ...) {
  type = match.arg(type)

  if (var %in% names(object$Mlist$refs))
    var_dum <- attr(object$Mlist$refs[[var]], 'dummies')
  else
    var_dum <- var


  MCMC <- do.call(rbind, object$MCMC)
  it <- sample(1:nrow(MCMC), size = nit)

  var_rep <- MCMC[, grep(paste0(var, "_ppc\\["), colnames(MCMC))]
  var_exp <- MCMC[, grep(paste0('mu_', var, "\\["), colnames(MCMC))]

  obs <- if (var_dum %in% names(object$data_list)) {
    object$data_list[[var_dum]]
  } else if (var_dum %in% colnames(object$data_list$Xc)) {
    c(object$data_list$Xc[, var_dum])
  }

  resid_obs <- t(apply(var_exp, 1, function(x) obs - x))
  resid_rep <- var_rep - var_exp

  names(dimnames(resid_obs)) <- names(dimnames(resid_rep)) <- names(dimnames(var_exp)) <- c('iters', 'subj')


  dat1 <- reshape2::melt(var_exp, value.name = 'var_exp')
  dat1$subj <- gsub('\\[|\\]', '',
                    regmatches(as.character(dat1$subj),
                               regexpr('\\[[[:digit:]]*\\]', as.character(dat1$subj))))

  dat2 <- reshape2::melt(resid_obs, value.name = 'resid_obs')
  dat3 <- reshape2::melt(resid_rep, value.name = 'resid_rep')

  bindf <- cbind(dat1, resid_obs = dat2$resid_obs, resid_rep = dat3$resid_rep)
  bindf <- bindf[order(bindf$var_exp), ]

  bindf$cut <- cut(bindf$var_exp, quantile(bindf$var_exp, seq(0, 1, length = nbins + 1), na.rm = TRUE),
                   include.lowest = T)

  # bindf$cut <- cut(bindf$var_exp, seq(min(bindf$var_exp), max(bindf$var_exp), length = nbins + 1),
  #                  include.lowest = T)


  binDFobs <- bindf[bindf$iters %in% it, c('var_exp', 'resid_obs', 'iters')]

  if (type == 'quantiles') {
    binDFrep <- c()
    for (x in split(bindf, bindf$cut)) {
      temp <- data.frame(
        mean_var_exp = mean(x$var_exp, na.rm = TRUE),
        mean_resid_rep = sapply(split(x$resid_rep, x$iters), mean, na.rm = TRUE)
      )
      binDFrep <- rbind(binDFrep,
                        data.frame(
                          cut = x$cut[1],
                          x = unique(temp$mean_var_exp),
                          lo = quantile(temp$mean_resid_rep, 0.025, na.rm = TRUE),
                          hi = quantile(temp$mean_resid_rep, 0.975, na.rm = TRUE)
                        )
      )
    }


    # binDFrep <- c()
    # bindf <- bindf[order(bindf$resid_rep), ]
    # # bindf <- bindf[order(bindf$var_exp), ]
    #
    # bindf$llim <- bindf$var_exp - bdw
    # bindf$ulim <- bindf$var_exp + bdw
    # # S <- order(bindf$resid_rep)
    # # s <- sort(bindf$resid_rep)
    # # #
    # # bindf$candid <- T
    #
    # for (i in 1:nrow(bindf)) {
    #
    #   rows <- (bindf$var_exp > bindf$llim[i]) + (bindf$var_exp < bindf$ulim[i]) == 2
    #
    #   s <- bindf$resid_rep[rows]
    #
    #   binDFrep <- rbind(binDFrep,
    #                     c(var_exp = bindf$var_exp[i],
    #                       lo = s[max(1, round(length(s) * 0.025))],
    #                       hi = s[min(length(s), round(length(s) * 0.975))]
    #                     )
    #   )
    # }

    p <- ggplot(binDFrep) +
      geom_ribbon(aes(x = x, ymin = lo, ymax = hi), alpha = 0.3) +
      geom_point(data = binDFobs, aes(x = var_exp, y = resid_obs, color = iters, group = factor(iters)), lwd = 1) +
      geom_hline(yintercept = 0) +
      theme(legend.position = 'none')

  } else {
    binDFrep <- bindf

    # binDFrep <- c()
    # for (x in split(bindf, bindf$cut)) {
    #   binDFrep <- rbind(binDFrep,
    #                     data.frame(
    #                       mean_var_exp = mean(x$var_exp, na.rm = TRUE),
    #                       mean_resid_rep = sapply(split(x$resid_rep, x$iters), mean, na.rm = TRUE),
    #                       iters = names(split(x$resid_rep, x$iters)),
    #                       cut = x$cut[1]
    #                     )
    #   )
    # }

    if (type == 'trajectories')
      p <- ggplot(binDFrep) +
        geom_line(aes(x = var_exp, y = resid_rep, group = factor(iters)), alpha = 0.3, color = grey(0.5)) +
        geom_line(data = binDFobs, aes(x = var_exp, y = resid_obs, color = iters, group = factor(iters)), lwd = 1) +
        geom_hline(yintercept = 0) +
        theme(legend.position = 'none')

    if (type == 'dots')
      p <- ggplot(binDFrep) +
        geom_point(aes(x = var_exp, y = resid_rep, group = factor(iters)), alpha = 0.3, color = grey(0.5)) +
        geom_point(data = binDFobs, aes(x = var_exp, y = resid_obs, color = iters, group = factor(iters)), size = 1.5) +
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
    KM <- survfit(Surv(resid_y[k, ], as.numeric(object$data$event)) ~ 1)
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


plot_qq <- function(object, var, nit, ...) {

  if (var %in% names(object$Mlist$refs))
    var_dum <- attr(object$Mlist$refs[[var]], 'dummies')
  else
    var_dum <- var


  MCMC <- do.call(rbind, object$MCMC)
  it <- sample(1:nrow(MCMC), size = nit)

  var_rep <- MCMC[, grep(paste0(var, "_ppc\\["), colnames(MCMC))]
  var_exp <- MCMC[, grep(paste0('mu_', var, "\\["), colnames(MCMC))]

  obs <- if (var_dum %in% names(object$data_list)) {
    object$data_list[[var_dum]]
  } else if (var_dum %in% colnames(object$data_list$Xc)) {
    c(object$data_list$Xc[, var_dum])
  }

  resid_obs <- t(apply(var_exp, 1, function(x) obs - x))
  resid_rep <- var_rep - var_exp

  names(dimnames(resid_obs)) <- names(dimnames(resid_rep)) <- names(dimnames(var_exp)) <- c('iters', 'subj')


  dat1 <- reshape2::melt(var_exp, value.name = 'var_exp')
  dat1$subj <- gsub('\\[|\\]', '',
                    regmatches(as.character(dat1$subj),
                               regexpr('\\[[[:digit:]]*\\]', as.character(dat1$subj))))

  dat2 <- reshape2::melt(resid_obs, value.name = 'resid_obs')
  dat3 <- reshape2::melt(resid_rep, value.name = 'resid_rep')

  bindf <- cbind(dat1, resid_obs = dat2$resid_obs, resid_rep = dat3$resid_rep)
  bindf <- bindf[order(bindf$var_exp), ]

  bindf$cut <- cut(bindf$var_exp, quantile(bindf$var_exp, seq(0, 1, length = nbins + 1), na.rm = TRUE),
                   include.lowest = T)


  q_obs <- quantile(scale(resid_obs), seq(0, 1, length = 100), na.rm = T)
  q_rep <- quantile(scale(resid_rep), seq(0, 1, length = 100), na.rm = T)

  plot(q_rep, q_obs)
  abline(a = 0, b = 1, col = 2)

}
