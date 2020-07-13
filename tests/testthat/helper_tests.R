find_dupl_parms <- function(mod) {
  betas <- unlist(regmatches(mod$JAGSmodel,
                             gregexpr('beta[[[:digit:]]+]', mod$JAGSmodel)))
  alphas <- unlist(regmatches(mod$JAGSmodel,
                              gregexpr('alpha[[[:digit:]]+]', mod$JAGSmodel)))

  c(if (any(duplicated(betas)))
    betas[duplicated(betas)],

    if (any(duplicated(alphas)))
      alphas[duplicated(alphas)]
  )
}
