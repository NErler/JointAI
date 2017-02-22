#' Create list of data passed to JAGS
#' @param type analysis model type
#' @param meth vector of imputation methods
#' @param Mlist list of data matrices etc.
#' @export
get_data_list <- function(analysis_type, meth, Mlist, scale_pars = NULL) {

  if (is.null(scale_pars)) {
    scale_vars <- Mlist$scale_vars
  }
  scaled_dat <- sapply(Mlist[!sapply(Mlist, is.null) &
                               names(Mlist) %in% c("Xc", "Xl", "Z")],
                       scaled_data.matrix, scale_vars = Mlist$scale_vars,
                       scale_pars = scale_pars,
                       simplify = FALSE)



  scale_pars <- as.data.frame(lapply(scaled_dat, "[[", 2))
  if (nrow(scale_pars) > 0) {
    names(scale_pars) <- unlist(lapply(lapply(scaled_dat, "[[", 2), names))


    scale_terms1 <- attr(terms(fixed), "factors")[names(scale_pars), ]
    scale_terms2 <- attr(terms(fixed), "factors")[, which(colSums(scale_terms1) > 0)]
    scale_terms2 <- scale_terms2[which(rowSums(scale_terms2) > 0), ]
    scale_terms3 <- scale_terms2

    for (i in 1:nrow(scale_terms3)) {
      invin.col <- which(scale_terms2[i, , drop = F] == 1)
      invin.row <- which(rowSums(scale_terms2[, invin.col, drop = F]) > 0)
      scale_terms3[invin.row, i] <- 1
    }

    add_scale <- unique(unlist(dimnames(scale_terms2)))
    add_scale <- add_scale[which(!add_scale %in% colnames(scale_pars))]
    for (x in add_scale) {
      nams <- names(which(scale_terms[, x] == 1))
      scale_pars["scale", x] <- prod(scale_pars["scale", nams])
      scale_pars["center", x] <- -prod(scale_pars["center", nams])
    }
  } else {
    scale_pars <- NULL
  }

  l <- list()
  l <- c(l,
         c(Mlist$y),
         lapply(scaled_dat, "[[", 1)
  )
  if (!is.null(Mlist$Xcat))  l$Xcat <- data.matrix(Mlist$Xcat)
  if (!is.null(Mlist$Xic)) l$Xic <- data.matrix(Mlist$Xic)
  if (!is.null(Mlist$Xil)) l$Xil <- data.matrix(Mlist$Xil)


  # hyperparameters analysis model
  l$mu_reg_main <- 0
  l$tau_reg_main <- 0.01
  l$a_tau_main <- 0.01
  l$b_tau_main <- 0.001

  if (analysis_type == "lme") {
    l$groups <- match(Mlist$groups, unique(Mlist$groups))
    if (ncol(Mlist$Z) > 1) {
      l$RinvD <- diag(rep(NA, ncol(Mlist$Z)))
      l$KinvD <- ncol(Mlist$Z)
    } else {
      l$RinvD <- NA
    }
    l$a_diag_RinvD <- 0.1
    l$b_diag_RinvD <- 0.01
  }

  # hyperparameters imputation models
  if (any(meth == "norm")) {
    l$mu_reg_norm <- 0
    l$tau_reg_norm <- 0.001
    l$a_tau_norm <- 0.01
    l$b_tau_norm <- 0.01
  }

  if (any(meth == "logit")) {
    l$mu_reg_logit <- 0
    l$tau_reg_logit <- 4/9
  }

  if (any(meth == "multinomial")) {
    l$mu_reg_multinomial <- 0
    l$tau_reg_multinomial <- 4/9
  }

  if (any(meth == "ordinal")) {
    l$mu_reg_ordinal <- 0
    l$tau_reg_ordinal <- 4/9
    l$mu_delta_ordinal <- 0
    l$tau_delta_ordinal <- 0.001
  }



  return(list(data_list = l,
              scale_pars = scale_pars))
}