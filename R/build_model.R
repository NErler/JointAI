# Function to write the JAGS model
# info_list contains the info per model that needs to be written
# Mlist contains the info on the interactions that is needed here
write_model <- function(info_list, Mlist, modelfile = "") {

  index <- get_indices(Mlist)

  rd_vcov_full <- lapply(names(Mlist$rd_vcov), function(lvl) {
    if (any(names(Mlist$rd_vcov[[lvl]]) == "full")) {
      lapply(which(names(Mlist$rd_vcov[[lvl]]) == "full"), function(k) {

        rd_vcov <- Mlist$rd_vcov[[lvl]][[k]]

        nam <- attr(rd_vcov, "name")
        nranef <- sapply(attr(rd_vcov, "ranef_index"),
                         function(nr) eval(parse(text = nr)))

        rd_lps <- lapply(rd_vcov, function(x) {
          c(
            paste_rdintercept_lp(info_list[[x]])[[lvl]],
            paste_rdslope_lp(info_list[[x]])[[lvl]]
          )
        })



        paste0("\r",
          tab(), "for (", index[lvl], " in 1:", Mlist$N[lvl], ") {", "\n",

          # distribution specification
          ranef_distr(nam = paste0(nam, "_", lvl),
                      index = index[lvl],
                      nranef = max(unlist(nranef))),

          paste_mu_b_full(lps = unlist(rd_lps, recursive = FALSE),
                          nranef, paste0(nam, "_", lvl), index[lvl]),
          "\n",
          tab(), "}", "\n\n",
          ranef_priors(max(unlist(nranef)), paste0(nam, "_", lvl),
                       rd_vcov = "full")
        )
      })
    }
  })

  cat("model {", "\n\n",
      paste0(lapply(info_list, function(k) {
        if (is.null(k$custom)) {
          get(paste0("jagsmodel_", tolower(k$modeltype)))(k)
        } else {
          k$custom
        }
        }), collapse = "\n\n\n"),

      if (length(unlist(rd_vcov_full)) > 0) {
        paste0("\n\n\n\r", tab(),
               "# correlated random effects specification ",
               paste0(rep("-", 40), collapse = ""), "\n",
               "\r", paste0(unlist(rd_vcov_full), collapse = "\n\n\n")
        )
      },

      '\n',
      if (any(sapply(Mlist$interactions, "attr", "has_NAs"))) {
        paste0("\n", tab(), "# Re-calculate interaction terms\n",
               paste_interactions(Mlist$interactions,
                                  group_lvls = Mlist$group_lvls,
                                  n = Mlist$N), "\n"
        )
      },
      "\r}", file = modelfile
  )
}
