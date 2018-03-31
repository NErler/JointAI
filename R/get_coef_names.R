# extract names of regression coefficients
# @param Mlist Mlist
# @param K K
# @export
get_coef_names <- function(Mlist, K) {

  coefs <- rbind(
    if (!is.null(Mlist$Xc))
      cbind(paste0("beta[", K["Xc", 1]:K["Xc", 2], "]"),
            colnames(Mlist$Xc)),
    if (!is.null(Mlist$Xic))
      cbind(paste0("beta[", K["Xic", 1]:K["Xic", 2], "]"),
            colnames(Mlist$Xic)),
    if (!is.null(Mlist$hc_list))
      cbind(
        unlist(
          sapply(names(Mlist$hc_list)[rowSums(is.na(K[names(Mlist$hc_list), , drop = FALSE])) == 0],
                 function(x) {
                   paste0("beta[", K[x, 1]:K[x, 2], "]")
                 })
        ),
        unlist(lapply(Mlist$hc_list, function(x) {
          names(x)[which(attr(x, "matrix") %in% c("Xc", "Z"))]
        }))
      ),
    if (!is.null(Mlist$Xl))
      cbind(paste0("beta[", K["Xl", 1]:K["Xl", 2], "]"),
            colnames(Mlist$Xl)),
    if (!is.null(Mlist$Xil))
      cbind(paste0("beta[", K["Xil", 1]:K["Xil", 2], "]"),
            colnames(Mlist$Xil))
  )

  return(coefs)
}
