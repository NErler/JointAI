#' Create list of data passed to JAGS
#' @param type analysis model type
#' @param meth vector of imputation methods
#' @param Mlist list of data matrices etc.
#' @export
get_data_list <- function(analysis_type, family, meth, Mlist, K, auxvas, scale_pars = NULL) {

  scaled <- get_scaling(Mlist, scale_pars, meth)

  l <- list()
  l[[names(Mlist$y)]] <- if (any(sapply(Mlist$y, is.factor))) {
    c(sapply(Mlist$y, as.numeric) - 1)
  } else {
    unname(unlist(Mlist$y))
  }
  l <- c(l,
         scaled$scaled_matrices
  )
  if (!is.null(Mlist$Xcat))  l$Xcat <- data.matrix(Mlist$Xcat)
  if (!is.null(Mlist$Xic)) l$Xic <- data.matrix(Mlist$Xic)
  if (!is.null(Mlist$Xil)) l$Xil <- data.matrix(Mlist$Xil)


  # hyperparameters analysis model
  l$mu_reg_main <- 0
  l$tau_reg_main <- 0.01
  if (!family %in% c("binomial", "Poisson")) {
    l$a_tau_main <- 0.01
    l$b_tau_main <- 0.001
  }


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
  if (any(meth %in% c("norm", "lognorm"))) {
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

  if (!is.null(Mlist$auxvars)) {
    l$beta <- setNames(rep(NA, max(K, na.rm = T)), get_coef_names(Mlist, K)[, 2])
    nams <- sapply(Mlist$auxvars, function(x) {
      if (x %in% names(Mlist$refs)) {
        paste0(x, levels(Mlist$refs[[x]])[levels(Mlist$refs[[x]]) !=
                                            Mlist$refs[[x]]])
      } else {
        x
      }
    })
    l$beta[unlist(nams)] <- 0
  }

  return(list(data_list = l,
              scale_pars = scaled$scale_pars))
}