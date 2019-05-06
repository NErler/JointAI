
get_coef_names <- function(Mlist, K) {

  coefs <- rbind(
    if (length(Mlist$cols_main$Xc) > 0)
      cbind(paste0("beta[", K["Xc", 1]:K["Xc", 2], "]"),
            colnames(Mlist$Xc)[Mlist$cols_main$Xc]),
    if (length(Mlist$cols_main$Xic) > 0)
      cbind(paste0("beta[", K["Xic", 1]:K["Xic", 2], "]"),
            colnames(Mlist$Xic)[Mlist$cols_main$Xic]),
    if (!is.null(Mlist$hc_list))
      cbind(
        unlist(
          sapply(names(Mlist$hc_list)[rowSums(is.na(K[names(Mlist$hc_list), , drop = FALSE])) == 0],
                 function(x) {
                   paste0("beta[", K[x, 1]:K[x, 2], "]")
                 }, simplify = FALSE)
        ),
        unlist(lapply(Mlist$hc_list[rowSums(is.na(K[names(Mlist$hc_list), , drop = FALSE])) == 0], function(x) {
          names(x)[sapply(x, attr, 'matrix') %in% c('Xc', 'Z')]
        }))
      ),
    if (length(Mlist$cols_main$Xl) > 0)
      cbind(paste0("beta[", K["Xl", 1]:K["Xl", 2], "]"),
            colnames(Mlist$Xl)[Mlist$cols_main$Xl]),
    if (length(Mlist$cols_main$Xil) > 0)
      cbind(paste0("beta[", K["Xil", 1]:K["Xil", 2], "]"),
            colnames(Mlist$Xil)[Mlist$cols_main$Xil])
  )
  if (max(c(0, K), na.rm = TRUE) == 1) { # case with only intercept
    coefs[, 1] <- gsub('beta\\[1\\]', 'beta', coefs[, 1])
  }

  return(coefs)
}
