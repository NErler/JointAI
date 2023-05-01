#' Plot the distribution of observed and imputed values
#'
#' Plots densities and bar plots of the observed and imputed values in a
#' long-format dataset (multiple imputed datasets stacked onto each other).
#'
#' @param data a \code{data.frame} containing multiple imputations
#'             and the original incomplete data stacked onto each other
#' @param imp the name of the variable specifying the imputation indicator
#' @param id the name of the variable specifying the subject indicator
#' @param rownr the name of a variable identifying which rows correspond to the
#'              same observation in the original (un-imputed) data
#' @param labeller optional labeller to be passed to
#'                 \code{\link[ggplot2:facet_wrap]{ggplot2::facet_wrap()}}
#'                 to change the facet labels
#' @inheritParams sharedParams
#' @export
#'
#' @examples
#'
#' \dontrun{
#' mod <- lme_imp(y ~ C1 + c2 + B2 + C2, random = ~ 1 | id, data = longDF,
#'                n.iter = 200, monitor_params = c(imps = TRUE), mess = FALSE)
#' impDF <- get_MIdat(mod, m = 5)
#' plot_imp_distr(impDF, id = "id", ncol = 3)
#' }

plot_imp_distr <- function(data, imp = 'Imputation_', id = '.id',
                           rownr = '.rownr',
                           ncol = NULL, nrow = NULL, labeller = NULL) {

  pkgs <- installed.packages()[, "Package"]

  if (!"ggplot2" %in% pkgs)
    msg("This function requires the package ggplot2 to be installed.")

  if (!"ggpubr" %in% pkgs)
    msg("This function requires the package ggpubr to be installed.")

  if (any(!c("ggpubr", "ggplot2") %in% pkgs)) {
    return(NULL)
  }

  subDF <- data[, (colSums(is.na(data[data[, imp] == 0, ])) > 0 &
                   colSums(is.na(data[data[, imp] != 0, ])) == 0) |
                names(data) %in% c(imp, id, rownr)]

  DForig <- subDF[subDF[, imp] == 0, ]

  w <- as.data.frame(is.na(DForig))
  w[, c(imp, id, rownr)] <- DForig[, c(imp, id, rownr)]

  type <- sapply(subDF, is.factor)

  DFlong <- melt_data_frame(subDF, id_vars = c(imp, id, rownr))

  wlong <- melt_data_frame(w, id_vars = c(imp, id, rownr), valname = 'mis')
  wlong <- unique(wlong)


  DFlong <- merge(DFlong, wlong, by = c(id, 'variable', rownr),
                  suffixes = c("",".y"))
  DFlong$type <- ifelse(type[as.character(DFlong$variable)], 'factor',
                        'numeric')

  plotDF <- DFlong[(DFlong[, imp] == 0 & !DFlong$mis) |
                     (DFlong[, imp] != 0 & DFlong$mis), ]


  p <- lapply(split(plotDF, plotDF$variable), function(dat) {
    if (unique(dat$type) == 'factor') {
      dat$value <- factor(dat$value)
      prop <- sapply(split(dat, dat[, imp]),
                     function(x) prop.table(table(x$value)))
      plong <- melt_matrix(prop, valname = 'proportion',
                           varnames = c('value', imp))
      dat <- merge(dat, plong, all = TRUE)
      dat$variable <- unique(na.omit(dat$variable))
    }

    pl <- ggplot2::ggplot(dat) +
      ggplot2::facet_wrap("variable",
                          scales = "free",
                          labeller = if (!is.null(labeller))
                            labeller else "label_value"
      ) +
      ggplot2::scale_color_manual(name = '',
                         limits = c(FALSE, TRUE),
                         values = c('dodgerblue3', 'midnightblue'),
                         labels = c('imputed', 'observed')) +
      ggplot2::scale_fill_manual(name = '', limits = c(FALSE, TRUE),
                        values = c('dodgerblue3', 'midnightblue'),
                        labels = c('imputed', 'observed')) +
      ggplot2::scale_linewidth_manual(name = '',
                                      limits = c(FALSE, TRUE),
                                      values = c(0.5, 1.3),
                                      labels = c('imputed', 'observed')) +
      ggplot2::xlab('')
      if (unique(na.omit(dat$type) == 'numeric')) {
        if (min(table(dat[, imp])) == 1) {
          pl + ggplot2::stat_density(ggplot2::aes(x = as.numeric(.data$value),
                                             color = get(imp) == 0,
                                             linewidth = get(imp) == 0),
                                     geom = 'line',
                                position = 'identity', na.rm = TRUE) +
            ggplot2::geom_point(data = subset(dat, get(imp) > 0),
                                ggplot2::aes(x = as.numeric(.data$value),
                                             y = 0, color = get(imp) == 0,
                                             shape = get(imp) == 0),
                                alpha = 0.5, show.legend = FALSE)
        } else {
          pl + ggplot2::stat_density(ggplot2::aes(x = as.numeric(.data$value),
                                             linewidth = get(imp) == 0,
                                             color = get(imp) == 0,
                                             group = get(imp)), geom = 'line',
                                position = 'identity', na.rm = TRUE)
        }
      } else {
        pl + ggplot2::geom_bar(ggplot2::aes(x = .data$value,
                                            y = .data$proportion,
                                       group = get(imp), fill = get(imp) == 0),
                          position = "dodge", stat = 'identity',
                          color = 'midnightblue') +
          ggplot2::ylab('proportion')
      }
  })

  # get number of rows and columns of plots
  if (is.null(nrow) & is.null(ncol)) {
    dims <- if (length(p) > 25) {
      grDevices::n2mfrow(25)
    } else {
      grDevices::n2mfrow(length(p))
    }
  } else if (is.null(nrow) & !is.null(ncol)) {
    dims <- c(ceiling(length(p)/ncol), ncol)
  } else if (is.null(ncol) & !is.null(nrow)) {
    dims <- c(nrow, ceiling(length(p)/nrow))
  } else {
    dims <- c(nrow, ncol)
  }

  ggpubr::ggarrange(plotlist = p, ncol = dims[2], nrow = dims[1],
                    common.legend = TRUE, legend = "bottom")
}
