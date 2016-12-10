#' Create list of data passed to JAGS
#' @param type analysis model type
#' @param meth vector of imputation methods
#' @param Mlist list of data matrices etc.
#' @export
get_data_list <- function(type, meth, Mlist) {

  l <- list()
  l <- c(l,
         c(Mlist$y),
         sapply(Mlist[!sapply(Mlist, is.null) &
                           names(Mlist) %in% c("Xc", "Xcat", "Xic",
                                               "Xl", "Xil", "Z")],
                   data.matrix))

  # hyperparameters analysis model
  l$mu_reg_main <- 0
  l$tau_reg_main <- 0.01
  l$a_tau_main <- 0.01
  l$b_tau_main <- 0.001

  if (type == "lme") {
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

  return(l)
}