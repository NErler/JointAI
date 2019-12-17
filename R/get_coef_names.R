

get_coef_names <- function(info_list) {
  sapply(info_list, function(info) {
    if (any(!sapply(info$lp, is.null)))
    data.frame(outcome = info$varname,
               varname = names(unlist(unname(info$lp))),
               coef = paste0(info$parname, "[", unlist(info$parelmts), "]"),
               stringsAsFactors = FALSE
    )
  }, simplify = FALSE)
}


#
#
# get_coef_names <- function(Mlist, K) {
#
#   coeflist <- sapply(names(K), function(i) {
#   coefs <- rbind(
#     if (length(Mlist$cols_main[[i]]$Xc) > 0)
#       cbind(paste0("beta[", K[[i]]["Xc", 1]:K[[i]]["Xc", 2], "]"),
#             colnames(Mlist$Xc)[Mlist$cols_main[[i]]$Xc]),
#     if (length(Mlist$cols_main[[i]]$Xic) > 0)
#       cbind(paste0("beta[", K["Xic", 1]:K["Xic", 2], "]"),
#             colnames(Mlist$Xic)[Mlist$cols_main[[i]]$Xic]),
#     if (!is.null(Mlist$hc_list))
#       cbind(
#         unlist(
#           sapply(names(Mlist$hc_list)[rowSums(is.na(K[[i]][names(Mlist$hc_list)[names(Mlist$hc_list %in% rownames(K[[i]]))], , drop = FALSE])) == 0],
#                  function(x) {
#                    paste0("beta[", K[[i]][x, 1]:K[[i]][x, 2], "]")
#                  }, simplify = FALSE)
#         ),
#         unlist(lapply(Mlist$hc_list[rowSums(is.na(K[[i]][names(Mlist$hc_list)[names(Mlist$hc_list %in% rownames(K[[i]]))], , drop = FALSE])) == 0], function(x) {
#           names(x)[sapply(x, attr, 'matrix') %in% c('Xc', 'Z')]
#         }))
#       ),
#     if (length(Mlist$cols_main[[i]]$Xl) > 0)
#       cbind(paste0("beta[", K[[i]]["Xl", 1]:K[[i]]["Xl", 2], "]"),
#             colnames(Mlist$Xl)[Mlist$cols_main[[i]]$Xl]),
#     if (length(Mlist$cols_main[[i]]$Xil) > 0)
#       cbind(paste0("beta[", K[[i]]["Xil", 1]:K[[i]]["Xil", 2], "]"),
#             colnames(Mlist$Xil)[Mlist$cols_main[[i]]$Xil])
#   )
#   if (max(c(0, K[[i]]), na.rm = TRUE) == 1) { # case with only intercept
#     coefs[, 1] <- gsub('beta\\[1\\]', 'beta', coefs[, 1])
#   }
#   colnames(coefs) <- c('JAGS', 'data')
#   as.data.frame(coefs, stringsAsFactors = FALSE)
#   }, simplify = FALSE)
#
#   if (length(coeflist) == 1) coeflist[[1]] else coeflist
# }
