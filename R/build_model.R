# Function to write the JAGS model
# info_list contains the info per model that needs to be written
# Mlist contains the info on the interactions that is needed here
write_model <- function(info_list, Mlist, modelfile = "") {

    cat("model {", "\n\n",
      paste0(lapply(info_list, function(k) {
        get(paste0("JAGSmodel_", k$modeltype))(k)
      }), collapse = "\n\n\n"),

      '\n',
      if (any(sapply(Mlist$interactions, "attr", "has_NAs"))) {
        paste0("\n", tab(), "# Re-calculate interaction terms\n",
               paste_interactions(Mlist$interactions,
                                  group_lvls = Mlist$group_lvls,
                                  N = Mlist$N), "\n"
        )
      },
      "\r}", file = modelfile
  )
}
