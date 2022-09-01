# jagsmodel remains the same

    Code
      lapply(models, "[[", "jagsmodel")
    Output
      $m0a
      model { 
      
         # Cox PH model for Srv_ftm_stts_cn ----------------------------------------------
        for (i in 1:312) {
          logh0_Srv_ftm_stts_cn[i] <- inprod(beta_Bh0_Srv_ftm_stts_cn[], Bh0_Srv_ftm_stts_cn[i, ])
          eta_Srv_ftm_stts_cn[i] <- 0
          logh_Srv_ftm_stts_cn[i] <- logh0_Srv_ftm_stts_cn[i] + eta_Srv_ftm_stts_cn[i]
      
          logh0s_Srv_ftm_stts_cn[i, 1:15] <- Bsh0_Srv_ftm_stts_cn[, i, ] %*% beta_Bh0_Srv_ftm_stts_cn[]
          Surv_Srv_ftm_stts_cn[i, 1:15] <- gkw[] * exp(1)^(logh0s_Srv_ftm_stts_cn[i, ])
      
          log.surv_Srv_ftm_stts_cn[i] <- -exp(eta_Srv_ftm_stts_cn[i]) * M_lvlone[i, 1]/2 * sum(Surv_Srv_ftm_stts_cn[i, ])
          phi_Srv_ftm_stts_cn[i] <- 5000 - ((M_lvlone[i, 2] * logh_Srv_ftm_stts_cn[i])) - (log.surv_Srv_ftm_stts_cn[i])
          zeros_Srv_ftm_stts_cn[i] ~ dpois(phi_Srv_ftm_stts_cn[i])
        }
      
      
        # Priors for the coefficients in the model for Srv_ftm_stts_cn
        for (k in 1:6) {
          beta_Bh0_Srv_ftm_stts_cn[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
       
       }
      $m1a
      model { 
      
         # Cox PH model for Srv_ftm_stts_cn ----------------------------------------------
        for (i in 1:312) {
          logh0_Srv_ftm_stts_cn[i] <- inprod(beta_Bh0_Srv_ftm_stts_cn[], Bh0_Srv_ftm_stts_cn[i, ])
          eta_Srv_ftm_stts_cn[i] <- (M_lvlone[i, 4] - spM_lvlone[4, 1])/spM_lvlone[4, 2] * beta[1] +
                                    M_lvlone[i, 5] * beta[2]
          logh_Srv_ftm_stts_cn[i] <- logh0_Srv_ftm_stts_cn[i] + eta_Srv_ftm_stts_cn[i]
      
          logh0s_Srv_ftm_stts_cn[i, 1:15] <- Bsh0_Srv_ftm_stts_cn[, i, ] %*% beta_Bh0_Srv_ftm_stts_cn[]
          Surv_Srv_ftm_stts_cn[i, 1:15] <- gkw[] * exp(1)^(logh0s_Srv_ftm_stts_cn[i, ])
      
          log.surv_Srv_ftm_stts_cn[i] <- -exp(eta_Srv_ftm_stts_cn[i]) * M_lvlone[i, 1]/2 * sum(Surv_Srv_ftm_stts_cn[i, ])
          phi_Srv_ftm_stts_cn[i] <- 5000 - ((M_lvlone[i, 2] * logh_Srv_ftm_stts_cn[i])) - (log.surv_Srv_ftm_stts_cn[i])
          zeros_Srv_ftm_stts_cn[i] ~ dpois(phi_Srv_ftm_stts_cn[i])
        }
      
      
        # Priors for the coefficients in the model for Srv_ftm_stts_cn
        for (k in 1:2) {
          beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
      
        for (k in 1:6) {
          beta_Bh0_Srv_ftm_stts_cn[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
       
       }
      $m1b
      model { 
      
         # Cox PH model for Srv_ftm_stts_cn ----------------------------------------------
        for (i in 1:312) {
          logh0_Srv_ftm_stts_cn[i] <- inprod(beta_Bh0_Srv_ftm_stts_cn[], Bh0_Srv_ftm_stts_cn[i, ])
          eta_Srv_ftm_stts_cn[i] <- (M_lvlone[i, 4] - spM_lvlone[4, 1])/spM_lvlone[4, 2] * beta[1] +
                                    M_lvlone[i, 5] * beta[2]
          logh_Srv_ftm_stts_cn[i] <- logh0_Srv_ftm_stts_cn[i] + eta_Srv_ftm_stts_cn[i]
      
          logh0s_Srv_ftm_stts_cn[i, 1:15] <- Bsh0_Srv_ftm_stts_cn[, i, ] %*% beta_Bh0_Srv_ftm_stts_cn[]
          Surv_Srv_ftm_stts_cn[i, 1:15] <- gkw[] * exp(1)^(logh0s_Srv_ftm_stts_cn[i, ])
      
          log.surv_Srv_ftm_stts_cn[i] <- -exp(eta_Srv_ftm_stts_cn[i]) * M_lvlone[i, 1]/2 * sum(Surv_Srv_ftm_stts_cn[i, ])
          phi_Srv_ftm_stts_cn[i] <- 5000 - ((M_lvlone[i, 2] * logh_Srv_ftm_stts_cn[i])) - (log.surv_Srv_ftm_stts_cn[i])
          zeros_Srv_ftm_stts_cn[i] ~ dpois(phi_Srv_ftm_stts_cn[i])
        }
      
      
        # Priors for the coefficients in the model for Srv_ftm_stts_cn
        for (k in 1:2) {
          beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
      
        for (k in 1:6) {
          beta_Bh0_Srv_ftm_stts_cn[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
       
       }
      $m2a
      model { 
      
         # Cox PH model for Srv_ftm_stts_cn ----------------------------------------------
        for (i in 1:312) {
          logh0_Srv_ftm_stts_cn[i] <- inprod(beta_Bh0_Srv_ftm_stts_cn[], Bh0_Srv_ftm_stts_cn[i, ])
          eta_Srv_ftm_stts_cn[i] <- (M_lvlone[i, 3] - spM_lvlone[3, 1])/spM_lvlone[3, 2] * beta[1]
          logh_Srv_ftm_stts_cn[i] <- logh0_Srv_ftm_stts_cn[i] + eta_Srv_ftm_stts_cn[i]
      
          logh0s_Srv_ftm_stts_cn[i, 1:15] <- Bsh0_Srv_ftm_stts_cn[, i, ] %*% beta_Bh0_Srv_ftm_stts_cn[]
          Surv_Srv_ftm_stts_cn[i, 1:15] <- gkw[] * exp(1)^(logh0s_Srv_ftm_stts_cn[i, ])
      
          log.surv_Srv_ftm_stts_cn[i] <- -exp(eta_Srv_ftm_stts_cn[i]) * M_lvlone[i, 1]/2 * sum(Surv_Srv_ftm_stts_cn[i, ])
          phi_Srv_ftm_stts_cn[i] <- 5000 - ((M_lvlone[i, 2] * logh_Srv_ftm_stts_cn[i])) - (log.surv_Srv_ftm_stts_cn[i])
          zeros_Srv_ftm_stts_cn[i] ~ dpois(phi_Srv_ftm_stts_cn[i])
        }
      
      
        # Priors for the coefficients in the model for Srv_ftm_stts_cn
        for (k in 1:1) {
          beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
      
        for (k in 1:6) {
          beta_Bh0_Srv_ftm_stts_cn[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
      
      
      
        # Normal model for copper -------------------------------------------------------
        for (i in 1:312) {
          M_lvlone[i, 3] ~ dnorm(mu_copper[i], tau_copper)
          mu_copper[i] <- M_lvlone[i, 4] * alpha[1]
        }
      
        # Priors for the model for copper
        for (k in 1:1) {
          alpha[k] ~ dnorm(mu_reg_norm, tau_reg_norm)
        }
        tau_copper ~ dgamma(shape_tau_norm, rate_tau_norm)
        sigma_copper <- sqrt(1/tau_copper)
       
       }
      $m3a
      model { 
      
         # Cox PH model for Srv_ftm_stts_cn ----------------------------------------------
        for (i in 1:312) {
          logh0_Srv_ftm_stts_cn[i] <- inprod(beta_Bh0_Srv_ftm_stts_cn[], Bh0_Srv_ftm_stts_cn[i, ])
          eta_Srv_ftm_stts_cn[i] <- (M_lvlone[i, 4] - spM_lvlone[4, 1])/spM_lvlone[4, 2] * beta[1] +
                                    M_lvlone[i, 6] * beta[2] +
                                    (M_lvlone[i, 7] - spM_lvlone[7, 1])/spM_lvlone[7, 2] * beta[3] +
                                    (M_lvlone[i, 8] - spM_lvlone[8, 1])/spM_lvlone[8, 2] * beta[4] +
                                    (M_lvlone[i, 9] - spM_lvlone[9, 1])/spM_lvlone[9, 2] * beta[5]
          logh_Srv_ftm_stts_cn[i] <- logh0_Srv_ftm_stts_cn[i] + eta_Srv_ftm_stts_cn[i]
      
          logh0s_Srv_ftm_stts_cn[i, 1:15] <- Bsh0_Srv_ftm_stts_cn[, i, ] %*% beta_Bh0_Srv_ftm_stts_cn[]
          Surv_Srv_ftm_stts_cn[i, 1:15] <- gkw[] * exp(1)^(logh0s_Srv_ftm_stts_cn[i, ])
      
          log.surv_Srv_ftm_stts_cn[i] <- -exp(eta_Srv_ftm_stts_cn[i]) * M_lvlone[i, 1]/2 * sum(Surv_Srv_ftm_stts_cn[i, ])
          phi_Srv_ftm_stts_cn[i] <- 5000 - ((M_lvlone[i, 2] * logh_Srv_ftm_stts_cn[i])) - (log.surv_Srv_ftm_stts_cn[i])
          zeros_Srv_ftm_stts_cn[i] ~ dpois(phi_Srv_ftm_stts_cn[i])
        }
      
      
        # Priors for the coefficients in the model for Srv_ftm_stts_cn
        for (k in 1:5) {
          beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
      
        for (k in 1:6) {
          beta_Bh0_Srv_ftm_stts_cn[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
      
      
      
        # Normal model for trig ---------------------------------------------------------
        for (i in 1:312) {
          M_lvlone[i, 3] ~ dnorm(mu_trig[i], tau_trig)T(1e-04, )
          mu_trig[i] <- M_lvlone[i, 5] * alpha[1] +
                        (M_lvlone[i, 4] - spM_lvlone[4, 1])/spM_lvlone[4, 2] * alpha[2] +
                        M_lvlone[i, 6] * alpha[3] +
                        (M_lvlone[i, 7] - spM_lvlone[7, 1])/spM_lvlone[7, 2] * alpha[4]
      
          M_lvlone[i, 9] <- log(M_lvlone[i, 3])
      
      
        }
      
        # Priors for the model for trig
        for (k in 1:4) {
          alpha[k] ~ dnorm(mu_reg_norm, tau_reg_norm)
        }
        tau_trig ~ dgamma(shape_tau_norm, rate_tau_norm)
        sigma_trig <- sqrt(1/tau_trig)
      
      
      
        # Normal model for copper -------------------------------------------------------
        for (i in 1:312) {
          M_lvlone[i, 4] ~ dnorm(mu_copper[i], tau_copper)
          mu_copper[i] <- M_lvlone[i, 5] * alpha[5] + M_lvlone[i, 6] * alpha[6] +
                          (M_lvlone[i, 7] - spM_lvlone[7, 1])/spM_lvlone[7, 2] * alpha[7]
      
          M_lvlone[i, 8] <- abs(M_lvlone[i, 7] - M_lvlone[i, 4])
      
      
        }
      
        # Priors for the model for copper
        for (k in 5:7) {
          alpha[k] ~ dnorm(mu_reg_norm, tau_reg_norm)
        }
        tau_copper ~ dgamma(shape_tau_norm, rate_tau_norm)
        sigma_copper <- sqrt(1/tau_copper)
       
       }
      $m3b
      model { 
      
         # Cox PH model for Srv_ftm_stts_cn ----------------------------------------------
        for (i in 1:312) {
          logh0_Srv_ftm_stts_cn[i] <- inprod(beta_Bh0_Srv_ftm_stts_cn[], Bh0_Srv_ftm_stts_cn[i, ])
          eta_Srv_ftm_stts_cn[i] <- b_Srv_ftm_stts_cn_center[group_center[i], 1] +
                                    beta[1] * (M_lvlone[i, 4] - spM_lvlone[4, 1])/spM_lvlone[4, 2] +
                                    beta[2] * M_lvlone[i, 5] +
                                    beta[3] * (M_lvlone[i, 6] - spM_lvlone[6, 1])/spM_lvlone[6, 2] +
                                    beta[4] * (M_lvlone[i, 7] - spM_lvlone[7, 1])/spM_lvlone[7, 2] +
                                    beta[5] * (M_lvlone[i, 8] - spM_lvlone[8, 1])/spM_lvlone[8, 2]
          logh_Srv_ftm_stts_cn[i] <- logh0_Srv_ftm_stts_cn[i] + eta_Srv_ftm_stts_cn[i]
      
          logh0s_Srv_ftm_stts_cn[i, 1:15] <- Bsh0_Srv_ftm_stts_cn[, i, ] %*% beta_Bh0_Srv_ftm_stts_cn[]
          Surv_Srv_ftm_stts_cn[i, 1:15] <- gkw[] * exp(1)^(logh0s_Srv_ftm_stts_cn[i, ])
      
          log.surv_Srv_ftm_stts_cn[i] <- -exp(eta_Srv_ftm_stts_cn[i]) * M_lvlone[i, 1]/2 * sum(Surv_Srv_ftm_stts_cn[i, ])
          phi_Srv_ftm_stts_cn[i] <- 5000 - ((M_lvlone[i, 2] * logh_Srv_ftm_stts_cn[i])) - (log.surv_Srv_ftm_stts_cn[i])
          zeros_Srv_ftm_stts_cn[i] ~ dpois(phi_Srv_ftm_stts_cn[i])
        }
      
        for (ii in 1:10) {
          b_Srv_ftm_stts_cn_center[ii, 1:1] ~ dnorm(mu_b_Srv_ftm_stts_cn_center[ii, ], invD_Srv_ftm_stts_cn_center[ , ])
          mu_b_Srv_ftm_stts_cn_center[ii, 1] <- 0
        }
      
      
        # Priors for the coefficients in the model for Srv_ftm_stts_cn
        for (k in 1:5) {
          beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
      
        for (k in 1:6) {
          beta_Bh0_Srv_ftm_stts_cn[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
      
        invD_Srv_ftm_stts_cn_center[1, 1] ~ dgamma(shape_diag_RinvD, rate_diag_RinvD)T(1e-16, 1e16)
        D_Srv_ftm_stts_cn_center[1, 1] <- 1 / (invD_Srv_ftm_stts_cn_center[1, 1])
      
      
        # Normal mixed effects model for trig -------------------------------------------
        for (i in 1:312) {
          M_lvlone[i, 3] ~ dnorm(mu_trig[i], tau_trig)T(1e-04, )
          mu_trig[i] <- b_trig_center[group_center[i], 1] +
                        alpha[2] * (M_lvlone[i, 4] - spM_lvlone[4, 1])/spM_lvlone[4, 2] +
                        alpha[3] * M_lvlone[i, 5] +
                        alpha[4] * (M_lvlone[i, 6] - spM_lvlone[6, 1])/spM_lvlone[6, 2]
      
      
          M_lvlone[i, 8] <- log(M_lvlone[i, 3])
      
        }
      
        for (ii in 1:10) {
          b_trig_center[ii, 1:1] ~ dnorm(mu_b_trig_center[ii, ], invD_trig_center[ , ])
          mu_b_trig_center[ii, 1] <- M_center[ii, 1] * alpha[1]
        }
      
        # Priors for the model for trig
        for (k in 1:4) {
          alpha[k] ~ dnorm(mu_reg_norm, tau_reg_norm)
        }
        tau_trig ~ dgamma(shape_tau_norm, rate_tau_norm)
        sigma_trig <- sqrt(1/tau_trig)
      
        invD_trig_center[1, 1] ~ dgamma(shape_diag_RinvD, rate_diag_RinvD)T(1e-16, 1e16)
        D_trig_center[1, 1] <- 1 / (invD_trig_center[1, 1])
      
      
        # Normal mixed effects model for copper -----------------------------------------
        for (i in 1:312) {
          M_lvlone[i, 4] ~ dnorm(mu_copper[i], tau_copper)
          mu_copper[i] <- b_copper_center[group_center[i], 1] + alpha[6] * M_lvlone[i, 5] +
                          alpha[7] * (M_lvlone[i, 6] - spM_lvlone[6, 1])/spM_lvlone[6, 2]
      
      
          M_lvlone[i, 7] <- abs(M_lvlone[i, 6] - M_lvlone[i, 4])
      
        }
      
        for (ii in 1:10) {
          b_copper_center[ii, 1:1] ~ dnorm(mu_b_copper_center[ii, ], invD_copper_center[ , ])
          mu_b_copper_center[ii, 1] <- M_center[ii, 1] * alpha[5]
        }
      
        # Priors for the model for copper
        for (k in 5:7) {
          alpha[k] ~ dnorm(mu_reg_norm, tau_reg_norm)
        }
        tau_copper ~ dgamma(shape_tau_norm, rate_tau_norm)
        sigma_copper <- sqrt(1/tau_copper)
      
        invD_copper_center[1, 1] ~ dgamma(shape_diag_RinvD, rate_diag_RinvD)T(1e-16, 1e16)
        D_copper_center[1, 1] <- 1 / (invD_copper_center[1, 1]) 
       }
      $m4a
      model { 
      
         # Cox PH model for Srv_ftm_stts_cn ----------------------------------------------
        for (ii in 1:312) {
          logh0_Srv_ftm_stts_cn[ii] <- inprod(beta_Bh0_Srv_ftm_stts_cn[], Bh0_Srv_ftm_stts_cn[ii, ])
          eta_Srv_ftm_stts_cn[ii] <- (M_id[ii, 4] - spM_id[4, 1])/spM_id[4, 2] * beta[1] +
                                     M_id[ii, 5] * beta[2] + M_id[ii, 6] * beta[3]
          logh_Srv_ftm_stts_cn[ii] <- logh0_Srv_ftm_stts_cn[ii] + eta_Srv_ftm_stts_cn[ii] +
                                      (M_lvlone[srow_Srv_ftm_stts_cn[ii], 1] - spM_lvlone[1, 1])/spM_lvlone[1, 2] * beta[4] +
                                      (M_lvlone[srow_Srv_ftm_stts_cn[ii], 2] - spM_lvlone[2, 1])/spM_lvlone[2, 2] * beta[5] +
                                      M_lvlone[srow_Srv_ftm_stts_cn[ii], 3] * beta[6] +
                                      M_lvlone[srow_Srv_ftm_stts_cn[ii], 4] * beta[7] +
                                      M_lvlone[srow_Srv_ftm_stts_cn[ii], 5] * beta[8]
      
          logh0s_Srv_ftm_stts_cn[ii, 1:15] <- Bsh0_Srv_ftm_stts_cn[, ii, ] %*% beta_Bh0_Srv_ftm_stts_cn[]
          Surv_Srv_ftm_stts_cn[ii, 1:15] <- gkw[] * exp(1)^(logh0s_Srv_ftm_stts_cn[ii, ] +
                                         (M_lvlonegk[ii, 1, 1:15] - spM_lvlone[1, 1])/spM_lvlone[1, 2] * beta[4] +
                                         (M_lvlonegk[ii, 2, 1:15] - spM_lvlone[2, 1])/spM_lvlone[2, 2] * beta[5] +
                                         M_lvlonegk[ii, 3, 1:15] * beta[6] +
                                         M_lvlonegk[ii, 4, 1:15] * beta[7] +
                                         M_lvlonegk[ii, 5, 1:15] * beta[8])
      
          log.surv_Srv_ftm_stts_cn[ii] <- -exp(eta_Srv_ftm_stts_cn[ii]) * M_id[ii, 1]/2 * sum(Surv_Srv_ftm_stts_cn[ii, ])
          phi_Srv_ftm_stts_cn[ii] <- 5000 - ((M_id[ii, 2] * logh_Srv_ftm_stts_cn[ii])) - (log.surv_Srv_ftm_stts_cn[ii])
          zeros_Srv_ftm_stts_cn[ii] ~ dpois(phi_Srv_ftm_stts_cn[ii])
        }
      
      
        # Priors for the coefficients in the model for Srv_ftm_stts_cn
        for (k in 1:8) {
          beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
      
        for (k in 1:6) {
          beta_Bh0_Srv_ftm_stts_cn[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
       
       }
      $m4b
      model { 
      
         # Cox PH model for Srv_ftm_stts_cn ----------------------------------------------
        for (ii in 1:312) {
          logh0_Srv_ftm_stts_cn[ii] <- inprod(beta_Bh0_Srv_ftm_stts_cn[], Bh0_Srv_ftm_stts_cn[ii, ])
          eta_Srv_ftm_stts_cn[ii] <- (M_id[ii, 4] - spM_id[4, 1])/spM_id[4, 2] * beta[1] +
                                     M_id[ii, 5] * beta[2] + M_id[ii, 6] * beta[3] +
                                     M_id[ii, 7] * beta[4]
          logh_Srv_ftm_stts_cn[ii] <- logh0_Srv_ftm_stts_cn[ii] + eta_Srv_ftm_stts_cn[ii] +
                                      (M_lvlone[srow_Srv_ftm_stts_cn[ii], 1] - spM_lvlone[1, 1])/spM_lvlone[1, 2] * beta[5] +
                                      (M_lvlone[srow_Srv_ftm_stts_cn[ii], 2] - spM_lvlone[2, 1])/spM_lvlone[2, 2] * beta[6]
      
          logh0s_Srv_ftm_stts_cn[ii, 1:15] <- Bsh0_Srv_ftm_stts_cn[, ii, ] %*% beta_Bh0_Srv_ftm_stts_cn[]
          Surv_Srv_ftm_stts_cn[ii, 1:15] <- gkw[] * exp(1)^(logh0s_Srv_ftm_stts_cn[ii, ] +
                                         (M_lvlonegk[ii, 1, 1:15] - spM_lvlone[1, 1])/spM_lvlone[1, 2] * beta[5] +
                                         (M_lvlonegk[ii, 2, 1:15] - spM_lvlone[2, 1])/spM_lvlone[2, 2] * beta[6])
      
          log.surv_Srv_ftm_stts_cn[ii] <- -exp(eta_Srv_ftm_stts_cn[ii]) * M_id[ii, 1]/2 * sum(Surv_Srv_ftm_stts_cn[ii, ])
          phi_Srv_ftm_stts_cn[ii] <- 5000 - ((M_id[ii, 2] * logh_Srv_ftm_stts_cn[ii])) - (log.surv_Srv_ftm_stts_cn[ii])
          zeros_Srv_ftm_stts_cn[ii] ~ dpois(phi_Srv_ftm_stts_cn[ii])
        }
      
      
        # Priors for the coefficients in the model for Srv_ftm_stts_cn
        for (k in 1:6) {
          beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
      
        for (k in 1:6) {
          beta_Bh0_Srv_ftm_stts_cn[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
       
       }
      $m4c
      model { 
      
         # Cox PH model for Srv_ftm_stts_cn ----------------------------------------------
        for (ii in 1:312) {
          logh0_Srv_ftm_stts_cn[ii] <- inprod(beta_Bh0_Srv_ftm_stts_cn[], Bh0_Srv_ftm_stts_cn[ii, ])
          eta_Srv_ftm_stts_cn[ii] <- b_Srv_ftm_stts_cn_center[group_center[pos_id[ii]], 1] +
                                     beta[1] * (M_id[ii, 3] - spM_id[3, 1])/spM_id[3, 2] +
                                     beta[2] * M_id[ii, 4]
          logh_Srv_ftm_stts_cn[ii] <- logh0_Srv_ftm_stts_cn[ii] + eta_Srv_ftm_stts_cn[ii] +
                                      (M_lvlone[srow_Srv_ftm_stts_cn[ii], 1] - spM_lvlone[1, 1])/spM_lvlone[1, 2] * beta[3] +
                                      (M_lvlone[srow_Srv_ftm_stts_cn[ii], 2] - spM_lvlone[2, 1])/spM_lvlone[2, 2] * beta[4]
      
          logh0s_Srv_ftm_stts_cn[ii, 1:15] <- Bsh0_Srv_ftm_stts_cn[, ii, ] %*% beta_Bh0_Srv_ftm_stts_cn[]
          Surv_Srv_ftm_stts_cn[ii, 1:15] <- gkw[] * exp(1)^(logh0s_Srv_ftm_stts_cn[ii, ] +
                                         (M_lvlonegk[ii, 1, 1:15] - spM_lvlone[1, 1])/spM_lvlone[1, 2] * beta[3] +
                                         (M_lvlonegk[ii, 2, 1:15] - spM_lvlone[2, 1])/spM_lvlone[2, 2] * beta[4])
      
          log.surv_Srv_ftm_stts_cn[ii] <- -exp(eta_Srv_ftm_stts_cn[ii]) * M_id[ii, 1]/2 * sum(Surv_Srv_ftm_stts_cn[ii, ])
          phi_Srv_ftm_stts_cn[ii] <- 5000 - ((M_id[ii, 2] * logh_Srv_ftm_stts_cn[ii])) - (log.surv_Srv_ftm_stts_cn[ii])
          zeros_Srv_ftm_stts_cn[ii] ~ dpois(phi_Srv_ftm_stts_cn[ii])
        }
      
        for (iii in 1:10) {
          b_Srv_ftm_stts_cn_center[iii, 1:1] ~ dnorm(mu_b_Srv_ftm_stts_cn_center[iii, ], invD_Srv_ftm_stts_cn_center[ , ])
          mu_b_Srv_ftm_stts_cn_center[iii, 1] <- 0
        }
      
      
        # Priors for the coefficients in the model for Srv_ftm_stts_cn
        for (k in 1:4) {
          beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
      
        for (k in 1:6) {
          beta_Bh0_Srv_ftm_stts_cn[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
      
        invD_Srv_ftm_stts_cn_center[1, 1] ~ dgamma(shape_diag_RinvD, rate_diag_RinvD)T(1e-16, 1e16)
        D_Srv_ftm_stts_cn_center[1, 1] <- 1 / (invD_Srv_ftm_stts_cn_center[1, 1]) 
       }
      $m4d
      model { 
      
         # Cox PH model for Srv_ftm_stts_cn ----------------------------------------------
        for (ii in 1:312) {
          logh0_Srv_ftm_stts_cn[ii] <- inprod(beta_Bh0_Srv_ftm_stts_cn[], Bh0_Srv_ftm_stts_cn[ii, ])
          eta_Srv_ftm_stts_cn[ii] <- b_Srv_ftm_stts_cn_center[group_center[pos_id[ii]], 1] +
                                     beta[1] * (M_id[ii, 3] - spM_id[3, 1])/spM_id[3, 2] +
                                     beta[2] * M_id[ii, 4]
          logh_Srv_ftm_stts_cn[ii] <- logh0_Srv_ftm_stts_cn[ii] + eta_Srv_ftm_stts_cn[ii] +
                                      (M_lvlone[srow_Srv_ftm_stts_cn[ii], 1] - spM_lvlone[1, 1])/spM_lvlone[1, 2] * beta[3] +
                                      (M_lvlone[srow_Srv_ftm_stts_cn[ii], 2] - spM_lvlone[2, 1])/spM_lvlone[2, 2] * beta[4] +
                                      (M_lvlone[srow_Srv_ftm_stts_cn[ii], 3] - spM_lvlone[3, 1])/spM_lvlone[3, 2] * beta[5]
      
          logh0s_Srv_ftm_stts_cn[ii, 1:15] <- Bsh0_Srv_ftm_stts_cn[, ii, ] %*% beta_Bh0_Srv_ftm_stts_cn[]
          Surv_Srv_ftm_stts_cn[ii, 1:15] <- gkw[] * exp(1)^(logh0s_Srv_ftm_stts_cn[ii, ] +
                                         (M_lvlonegk[ii, 1, 1:15] - spM_lvlone[1, 1])/spM_lvlone[1, 2] * beta[3] +
                                         (M_lvlonegk[ii, 2, 1:15] - spM_lvlone[2, 1])/spM_lvlone[2, 2] * beta[4] +
                                         (M_lvlonegk[ii, 3, 1:15] - spM_lvlone[3, 1])/spM_lvlone[3, 2] * beta[5])
      
          log.surv_Srv_ftm_stts_cn[ii] <- -exp(eta_Srv_ftm_stts_cn[ii]) * M_id[ii, 1]/2 * sum(Surv_Srv_ftm_stts_cn[ii, ])
          phi_Srv_ftm_stts_cn[ii] <- 5000 - ((M_id[ii, 2] * logh_Srv_ftm_stts_cn[ii])) - (log.surv_Srv_ftm_stts_cn[ii])
          zeros_Srv_ftm_stts_cn[ii] ~ dpois(phi_Srv_ftm_stts_cn[ii])
        }
      
        for (iii in 1:10) {
          b_Srv_ftm_stts_cn_center[iii, 1:1] ~ dnorm(mu_b_Srv_ftm_stts_cn_center[iii, ], invD_Srv_ftm_stts_cn_center[ , ])
          mu_b_Srv_ftm_stts_cn_center[iii, 1] <- 0
        }
      
      
        # Priors for the coefficients in the model for Srv_ftm_stts_cn
        for (k in 1:5) {
          beta[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
      
        for (k in 1:6) {
          beta_Bh0_Srv_ftm_stts_cn[k] ~ dnorm(mu_reg_surv, tau_reg_surv)
        }
      
        invD_Srv_ftm_stts_cn_center[1, 1] ~ dgamma(shape_diag_RinvD, rate_diag_RinvD)T(1e-16, 1e16)
        D_Srv_ftm_stts_cn_center[1, 1] <- 1 / (invD_Srv_ftm_stts_cn_center[1, 1]) 
       }

# GRcrit and MCerror give same result

    Code
      lapply(models0, GR_crit, multivariate = FALSE)
    Output
      $m0a
      Potential scale reduction factors:
      
                                  Point est. Upper C.I.
      beta_Bh0_Srv_ftm_stts_cn[1]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[2]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[3]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[4]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[5]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[6]        NaN        NaN
      
      
      $m1a
      Potential scale reduction factors:
      
                                  Point est. Upper C.I.
      age                                NaN        NaN
      sexfemale                          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[1]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[2]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[3]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[4]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[5]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[6]        NaN        NaN
      
      
      $m1b
      Potential scale reduction factors:
      
                                  Point est. Upper C.I.
      age                                NaN        NaN
      sexfemale                          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[1]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[2]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[3]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[4]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[5]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[6]        NaN        NaN
      
      
      $m2a
      Potential scale reduction factors:
      
                                  Point est. Upper C.I.
      beta_Bh0_Srv_ftm_stts_cn[1]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[2]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[3]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[4]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[5]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[6]        NaN        NaN
      copper                             NaN        NaN
      
      
      $m3a
      Potential scale reduction factors:
      
                                  Point est. Upper C.I.
      copper                             NaN        NaN
      sexfemale                          NaN        NaN
      age                                NaN        NaN
      abs(age - copper)                  NaN        NaN
      log(trig)                          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[1]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[2]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[3]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[4]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[5]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[6]        NaN        NaN
      
      
      $m3b
      Potential scale reduction factors:
      
                                    Point est. Upper C.I.
      copper                               NaN        NaN
      sexfemale                            NaN        NaN
      age                                  NaN        NaN
      abs(age - copper)                    NaN        NaN
      log(trig)                            NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[1]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[2]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[3]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[4]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[5]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[6]          NaN        NaN
      D_Srv_ftm_stts_cn_center[1,1]        NaN        NaN
      
      
      $m4a
      Potential scale reduction factors:
      
                                  Point est. Upper C.I.
      age                                NaN        NaN
      sexfemale                          NaN        NaN
      trtplacebo                         NaN        NaN
      albumin                            NaN        NaN
      platelet                           NaN        NaN
      stage.L                            NaN        NaN
      stage.Q                            NaN        NaN
      stage.C                            NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[1]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[2]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[3]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[4]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[5]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[6]        NaN        NaN
      
      
      $m4b
      Potential scale reduction factors:
      
                                  Point est. Upper C.I.
      age                                NaN        NaN
      sexfemale                          NaN        NaN
      trtplacebo                         NaN        NaN
      sexfemale:trtplacebo               NaN        NaN
      albumin                            NaN        NaN
      log(platelet)                      NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[1]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[2]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[3]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[4]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[5]        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[6]        NaN        NaN
      
      
      $m4c
      Potential scale reduction factors:
      
                                    Point est. Upper C.I.
      age                                  NaN        NaN
      sexfemale                            NaN        NaN
      albumin                              NaN        NaN
      log(platelet)                        NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[1]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[2]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[3]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[4]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[5]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[6]          NaN        NaN
      D_Srv_ftm_stts_cn_center[1,1]        NaN        NaN
      
      
      $m4d
      Potential scale reduction factors:
      
                                    Point est. Upper C.I.
      age                                  NaN        NaN
      sexfemale                            NaN        NaN
      albumin                              NaN        NaN
      ns(platelet, df = 2)1                NaN        NaN
      ns(platelet, df = 2)2                NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[1]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[2]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[3]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[4]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[5]          NaN        NaN
      beta_Bh0_Srv_ftm_stts_cn[6]          NaN        NaN
      D_Srv_ftm_stts_cn_center[1,1]        NaN        NaN
      
      

---

    Code
      lapply(models0, MC_error)
    Output
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      $m0a
                                  est MCSE SD MCSE/SD
      beta_Bh0_Srv_ftm_stts_cn[1]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[2]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[3]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[4]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[5]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[6]   0    0  0     NaN
      
      $m1a
                                  est MCSE SD MCSE/SD
      age                           0    0  0     NaN
      sexfemale                     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[1]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[2]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[3]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[4]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[5]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[6]   0    0  0     NaN
      
      $m1b
                                  est MCSE SD MCSE/SD
      age                           0    0  0     NaN
      sexfemale                     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[1]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[2]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[3]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[4]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[5]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[6]   0    0  0     NaN
      
      $m2a
                                  est MCSE SD MCSE/SD
      beta_Bh0_Srv_ftm_stts_cn[1]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[2]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[3]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[4]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[5]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[6]   0    0  0     NaN
      copper                        0    0  0     NaN
      
      $m3a
                                  est MCSE SD MCSE/SD
      copper                        0    0  0     NaN
      sexfemale                     0    0  0     NaN
      age                           0    0  0     NaN
      abs(age - copper)             0    0  0     NaN
      log(trig)                     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[1]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[2]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[3]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[4]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[5]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[6]   0    0  0     NaN
      
      $m3b
                                    est MCSE SD MCSE/SD
      copper                          0    0  0     NaN
      sexfemale                       0    0  0     NaN
      age                             0    0  0     NaN
      abs(age - copper)               0    0  0     NaN
      log(trig)                       0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[1]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[2]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[3]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[4]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[5]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[6]     0    0  0     NaN
      D_Srv_ftm_stts_cn_center[1,1]   0    0  0     NaN
      
      $m4a
                                  est MCSE SD MCSE/SD
      age                           0    0  0     NaN
      sexfemale                     0    0  0     NaN
      trtplacebo                    0    0  0     NaN
      albumin                       0    0  0     NaN
      platelet                      0    0  0     NaN
      stage.L                       0    0  0     NaN
      stage.Q                       0    0  0     NaN
      stage.C                       0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[1]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[2]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[3]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[4]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[5]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[6]   0    0  0     NaN
      
      $m4b
                                  est MCSE SD MCSE/SD
      age                           0    0  0     NaN
      sexfemale                     0    0  0     NaN
      trtplacebo                    0    0  0     NaN
      sexfemale:trtplacebo          0    0  0     NaN
      albumin                       0    0  0     NaN
      log(platelet)                 0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[1]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[2]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[3]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[4]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[5]   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[6]   0    0  0     NaN
      
      $m4c
                                    est MCSE SD MCSE/SD
      age                             0    0  0     NaN
      sexfemale                       0    0  0     NaN
      albumin                         0    0  0     NaN
      log(platelet)                   0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[1]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[2]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[3]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[4]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[5]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[6]     0    0  0     NaN
      D_Srv_ftm_stts_cn_center[1,1]   0    0  0     NaN
      
      $m4d
                                    est MCSE SD MCSE/SD
      age                             0    0  0     NaN
      sexfemale                       0    0  0     NaN
      albumin                         0    0  0     NaN
      ns(platelet, df = 2)1           0    0  0     NaN
      ns(platelet, df = 2)2           0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[1]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[2]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[3]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[4]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[5]     0    0  0     NaN
      beta_Bh0_Srv_ftm_stts_cn[6]     0    0  0     NaN
      D_Srv_ftm_stts_cn_center[1,1]   0    0  0     NaN
      

# summary output remained the same

    Code
      lapply(models0, print)
    Output
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ 1, data = PBC2, 
          n.adapt = 1, n.iter = 4, seed = 2020, warn = FALSE, mess = FALSE)
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex, data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020, warn = FALSE, 
          mess = FALSE)
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
            age sexfemale 
              0         0 
      
      Call:
      coxph_imp(formula = Surv(futime, I(status != "censored")) ~ age + 
          sex, data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020, warn = FALSE, 
          mess = FALSE)
      
       Bayesian proportional hazards model for "Surv(futime, I(status != "censored"))" 
      
      
      Coefficients:
            age sexfemale 
              0         0 
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ copper, 
          data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020, warn = FALSE, 
          mess = FALSE)
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
      copper 
           0 
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ copper + 
          sex + age + abs(age - copper) + log(trig), data = PBC2, n.adapt = 2, 
          n.iter = 10, seed = 2020, warn = FALSE, mess = FALSE, trunc = list(trig = c(1e-04, 
              NA)))
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
                 copper         sexfemale               age abs(age - copper) 
                      0                 0                 0                 0 
              log(trig) 
                      0 
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ copper + 
          sex + age + abs(age - copper) + log(trig) + (1 | center), 
          data = PBC2, n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, 
          mess = FALSE, trunc = list(trig = c(1e-04, NA)))
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
                 copper         sexfemale               age abs(age - copper) 
                      0                 0                 0                 0 
              log(trig) 
                      0 
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex + trt + albumin + platelet + stage + (1 | id), data = PBC, 
          n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, mess = FALSE, 
          timevar = "day")
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
             age  sexfemale trtplacebo    albumin   platelet    stage.L    stage.Q 
               0          0          0          0          0          0          0 
         stage.C 
               0 
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex * trt + albumin + log(platelet) + (1 | id), data = PBC, 
          n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, mess = FALSE, 
          timevar = "day")
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
                       age            sexfemale           trtplacebo 
                         0                    0                    0 
      sexfemale:trtplacebo              albumin        log(platelet) 
                         0                    0                    0 
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex + albumin + log(platelet) + (1 | id) + (1 | center), 
          data = PBC, n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, 
          mess = FALSE, timevar = "day")
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
                age     sexfemale       albumin log(platelet) 
                  0             0             0             0 
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex + albumin + ns(platelet, df = 2) + (1 | id) + (1 | center), 
          data = PBC, n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, 
          mess = FALSE, timevar = "day")
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
                        age             sexfemale               albumin 
                          0                     0                     0 
      ns(platelet, df = 2)1 ns(platelet, df = 2)2 
                          0                     0 
      $m0a
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ 1, data = PBC2, 
          n.adapt = 1, n.iter = 4, seed = 2020, warn = FALSE, mess = FALSE)
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      $m1a
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex, data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020, warn = FALSE, 
          mess = FALSE)
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
            age sexfemale 
              0         0 
      
      $m1b
      
      Call:
      coxph_imp(formula = Surv(futime, I(status != "censored")) ~ age + 
          sex, data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020, warn = FALSE, 
          mess = FALSE)
      
       Bayesian proportional hazards model for "Surv(futime, I(status != "censored"))" 
      
      
      Coefficients:
            age sexfemale 
              0         0 
      
      $m2a
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ copper, 
          data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020, warn = FALSE, 
          mess = FALSE)
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
      copper 
           0 
      
      $m3a
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ copper + 
          sex + age + abs(age - copper) + log(trig), data = PBC2, n.adapt = 2, 
          n.iter = 10, seed = 2020, warn = FALSE, mess = FALSE, trunc = list(trig = c(1e-04, 
              NA)))
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
                 copper         sexfemale               age abs(age - copper) 
                      0                 0                 0                 0 
              log(trig) 
                      0 
      
      $m3b
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ copper + 
          sex + age + abs(age - copper) + log(trig) + (1 | center), 
          data = PBC2, n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, 
          mess = FALSE, trunc = list(trig = c(1e-04, NA)))
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
                 copper         sexfemale               age abs(age - copper) 
                      0                 0                 0                 0 
              log(trig) 
                      0 
      
      $m4a
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex + trt + albumin + platelet + stage + (1 | id), data = PBC, 
          n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, mess = FALSE, 
          timevar = "day")
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
             age  sexfemale trtplacebo    albumin   platelet    stage.L    stage.Q 
               0          0          0          0          0          0          0 
         stage.C 
               0 
      
      $m4b
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex * trt + albumin + log(platelet) + (1 | id), data = PBC, 
          n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, mess = FALSE, 
          timevar = "day")
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
                       age            sexfemale           trtplacebo 
                         0                    0                    0 
      sexfemale:trtplacebo              albumin        log(platelet) 
                         0                    0                    0 
      
      $m4c
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex + albumin + log(platelet) + (1 | id) + (1 | center), 
          data = PBC, n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, 
          mess = FALSE, timevar = "day")
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
                age     sexfemale       albumin log(platelet) 
                  0             0             0             0 
      
      $m4d
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex + albumin + ns(platelet, df = 2) + (1 | id) + (1 | center), 
          data = PBC, n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, 
          mess = FALSE, timevar = "day")
      
       Bayesian proportional hazards model for "Surv(futime, status != "censored")" 
      
      
      Coefficients:
                        age             sexfemale               albumin 
                          0                     0                     0 
      ns(platelet, df = 2)1 ns(platelet, df = 2)2 
                          0                     0 
      

---

    Code
      lapply(models0, coef)
    Output
      $m0a
      $m0a$`Surv(futime, status != "censored")`
      beta_Bh0_Srv_ftm_stts_cn[1] beta_Bh0_Srv_ftm_stts_cn[2] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[3] beta_Bh0_Srv_ftm_stts_cn[4] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[5] beta_Bh0_Srv_ftm_stts_cn[6] 
                                0                           0 
      
      
      $m1a
      $m1a$`Surv(futime, status != "censored")`
                              age                   sexfemale 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[1] beta_Bh0_Srv_ftm_stts_cn[2] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[3] beta_Bh0_Srv_ftm_stts_cn[4] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[5] beta_Bh0_Srv_ftm_stts_cn[6] 
                                0                           0 
      
      
      $m1b
      $m1b$`Surv(futime, I(status != "censored"))`
                              age                   sexfemale 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[1] beta_Bh0_Srv_ftm_stts_cn[2] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[3] beta_Bh0_Srv_ftm_stts_cn[4] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[5] beta_Bh0_Srv_ftm_stts_cn[6] 
                                0                           0 
      
      
      $m2a
      $m2a$`Surv(futime, status != "censored")`
                           copper beta_Bh0_Srv_ftm_stts_cn[1] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[2] beta_Bh0_Srv_ftm_stts_cn[3] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[4] beta_Bh0_Srv_ftm_stts_cn[5] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[6] 
                                0 
      
      
      $m3a
      $m3a$`Surv(futime, status != "censored")`
                           copper                   sexfemale 
                                0                           0 
                              age           abs(age - copper) 
                                0                           0 
                        log(trig) beta_Bh0_Srv_ftm_stts_cn[1] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[2] beta_Bh0_Srv_ftm_stts_cn[3] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[4] beta_Bh0_Srv_ftm_stts_cn[5] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[6] 
                                0 
      
      
      $m3b
      $m3b$`Surv(futime, status != "censored")`
                             copper                     sexfemale 
                                  0                             0 
                                age             abs(age - copper) 
                                  0                             0 
                          log(trig) D_Srv_ftm_stts_cn_center[1,1] 
                                  0                             0 
        beta_Bh0_Srv_ftm_stts_cn[1]   beta_Bh0_Srv_ftm_stts_cn[2] 
                                  0                             0 
        beta_Bh0_Srv_ftm_stts_cn[3]   beta_Bh0_Srv_ftm_stts_cn[4] 
                                  0                             0 
        beta_Bh0_Srv_ftm_stts_cn[5]   beta_Bh0_Srv_ftm_stts_cn[6] 
                                  0                             0 
      
      
      $m4a
      $m4a$`Surv(futime, status != "censored")`
                              age                   sexfemale 
                                0                           0 
                       trtplacebo                     albumin 
                                0                           0 
                         platelet                     stage.L 
                                0                           0 
                          stage.Q                     stage.C 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[1] beta_Bh0_Srv_ftm_stts_cn[2] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[3] beta_Bh0_Srv_ftm_stts_cn[4] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[5] beta_Bh0_Srv_ftm_stts_cn[6] 
                                0                           0 
      
      
      $m4b
      $m4b$`Surv(futime, status != "censored")`
                              age                   sexfemale 
                                0                           0 
                       trtplacebo        sexfemale:trtplacebo 
                                0                           0 
                          albumin               log(platelet) 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[1] beta_Bh0_Srv_ftm_stts_cn[2] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[3] beta_Bh0_Srv_ftm_stts_cn[4] 
                                0                           0 
      beta_Bh0_Srv_ftm_stts_cn[5] beta_Bh0_Srv_ftm_stts_cn[6] 
                                0                           0 
      
      
      $m4c
      $m4c$`Surv(futime, status != "censored")`
                                age                     sexfemale 
                                  0                             0 
                            albumin                 log(platelet) 
                                  0                             0 
      D_Srv_ftm_stts_cn_center[1,1]   beta_Bh0_Srv_ftm_stts_cn[1] 
                                  0                             0 
        beta_Bh0_Srv_ftm_stts_cn[2]   beta_Bh0_Srv_ftm_stts_cn[3] 
                                  0                             0 
        beta_Bh0_Srv_ftm_stts_cn[4]   beta_Bh0_Srv_ftm_stts_cn[5] 
                                  0                             0 
        beta_Bh0_Srv_ftm_stts_cn[6] 
                                  0 
      
      
      $m4d
      $m4d$`Surv(futime, status != "censored")`
                                age                     sexfemale 
                                  0                             0 
                            albumin         ns(platelet, df = 2)1 
                                  0                             0 
              ns(platelet, df = 2)2 D_Srv_ftm_stts_cn_center[1,1] 
                                  0                             0 
        beta_Bh0_Srv_ftm_stts_cn[1]   beta_Bh0_Srv_ftm_stts_cn[2] 
                                  0                             0 
        beta_Bh0_Srv_ftm_stts_cn[3]   beta_Bh0_Srv_ftm_stts_cn[4] 
                                  0                             0 
        beta_Bh0_Srv_ftm_stts_cn[5]   beta_Bh0_Srv_ftm_stts_cn[6] 
                                  0                             0 
      
      

---

    Code
      lapply(models0, confint)
    Output
      $m0a
      $m0a$`Surv(futime, status != "censored")`
                                  2.5% 97.5%
      beta_Bh0_Srv_ftm_stts_cn[1]    0     0
      beta_Bh0_Srv_ftm_stts_cn[2]    0     0
      beta_Bh0_Srv_ftm_stts_cn[3]    0     0
      beta_Bh0_Srv_ftm_stts_cn[4]    0     0
      beta_Bh0_Srv_ftm_stts_cn[5]    0     0
      beta_Bh0_Srv_ftm_stts_cn[6]    0     0
      
      
      $m1a
      $m1a$`Surv(futime, status != "censored")`
                                  2.5% 97.5%
      age                            0     0
      sexfemale                      0     0
      beta_Bh0_Srv_ftm_stts_cn[1]    0     0
      beta_Bh0_Srv_ftm_stts_cn[2]    0     0
      beta_Bh0_Srv_ftm_stts_cn[3]    0     0
      beta_Bh0_Srv_ftm_stts_cn[4]    0     0
      beta_Bh0_Srv_ftm_stts_cn[5]    0     0
      beta_Bh0_Srv_ftm_stts_cn[6]    0     0
      
      
      $m1b
      $m1b$`Surv(futime, I(status != "censored"))`
                                  2.5% 97.5%
      age                            0     0
      sexfemale                      0     0
      beta_Bh0_Srv_ftm_stts_cn[1]    0     0
      beta_Bh0_Srv_ftm_stts_cn[2]    0     0
      beta_Bh0_Srv_ftm_stts_cn[3]    0     0
      beta_Bh0_Srv_ftm_stts_cn[4]    0     0
      beta_Bh0_Srv_ftm_stts_cn[5]    0     0
      beta_Bh0_Srv_ftm_stts_cn[6]    0     0
      
      
      $m2a
      $m2a$`Surv(futime, status != "censored")`
                                  2.5% 97.5%
      copper                         0     0
      beta_Bh0_Srv_ftm_stts_cn[1]    0     0
      beta_Bh0_Srv_ftm_stts_cn[2]    0     0
      beta_Bh0_Srv_ftm_stts_cn[3]    0     0
      beta_Bh0_Srv_ftm_stts_cn[4]    0     0
      beta_Bh0_Srv_ftm_stts_cn[5]    0     0
      beta_Bh0_Srv_ftm_stts_cn[6]    0     0
      
      
      $m3a
      $m3a$`Surv(futime, status != "censored")`
                                  2.5% 97.5%
      copper                         0     0
      sexfemale                      0     0
      age                            0     0
      abs(age - copper)              0     0
      log(trig)                      0     0
      beta_Bh0_Srv_ftm_stts_cn[1]    0     0
      beta_Bh0_Srv_ftm_stts_cn[2]    0     0
      beta_Bh0_Srv_ftm_stts_cn[3]    0     0
      beta_Bh0_Srv_ftm_stts_cn[4]    0     0
      beta_Bh0_Srv_ftm_stts_cn[5]    0     0
      beta_Bh0_Srv_ftm_stts_cn[6]    0     0
      
      
      $m3b
      $m3b$`Surv(futime, status != "censored")`
                                    2.5% 97.5%
      copper                           0     0
      sexfemale                        0     0
      age                              0     0
      abs(age - copper)                0     0
      log(trig)                        0     0
      D_Srv_ftm_stts_cn_center[1,1]    0     0
      beta_Bh0_Srv_ftm_stts_cn[1]      0     0
      beta_Bh0_Srv_ftm_stts_cn[2]      0     0
      beta_Bh0_Srv_ftm_stts_cn[3]      0     0
      beta_Bh0_Srv_ftm_stts_cn[4]      0     0
      beta_Bh0_Srv_ftm_stts_cn[5]      0     0
      beta_Bh0_Srv_ftm_stts_cn[6]      0     0
      
      
      $m4a
      $m4a$`Surv(futime, status != "censored")`
                                  2.5% 97.5%
      age                            0     0
      sexfemale                      0     0
      trtplacebo                     0     0
      albumin                        0     0
      platelet                       0     0
      stage.L                        0     0
      stage.Q                        0     0
      stage.C                        0     0
      beta_Bh0_Srv_ftm_stts_cn[1]    0     0
      beta_Bh0_Srv_ftm_stts_cn[2]    0     0
      beta_Bh0_Srv_ftm_stts_cn[3]    0     0
      beta_Bh0_Srv_ftm_stts_cn[4]    0     0
      beta_Bh0_Srv_ftm_stts_cn[5]    0     0
      beta_Bh0_Srv_ftm_stts_cn[6]    0     0
      
      
      $m4b
      $m4b$`Surv(futime, status != "censored")`
                                  2.5% 97.5%
      age                            0     0
      sexfemale                      0     0
      trtplacebo                     0     0
      sexfemale:trtplacebo           0     0
      albumin                        0     0
      log(platelet)                  0     0
      beta_Bh0_Srv_ftm_stts_cn[1]    0     0
      beta_Bh0_Srv_ftm_stts_cn[2]    0     0
      beta_Bh0_Srv_ftm_stts_cn[3]    0     0
      beta_Bh0_Srv_ftm_stts_cn[4]    0     0
      beta_Bh0_Srv_ftm_stts_cn[5]    0     0
      beta_Bh0_Srv_ftm_stts_cn[6]    0     0
      
      
      $m4c
      $m4c$`Surv(futime, status != "censored")`
                                    2.5% 97.5%
      age                              0     0
      sexfemale                        0     0
      albumin                          0     0
      log(platelet)                    0     0
      D_Srv_ftm_stts_cn_center[1,1]    0     0
      beta_Bh0_Srv_ftm_stts_cn[1]      0     0
      beta_Bh0_Srv_ftm_stts_cn[2]      0     0
      beta_Bh0_Srv_ftm_stts_cn[3]      0     0
      beta_Bh0_Srv_ftm_stts_cn[4]      0     0
      beta_Bh0_Srv_ftm_stts_cn[5]      0     0
      beta_Bh0_Srv_ftm_stts_cn[6]      0     0
      
      
      $m4d
      $m4d$`Surv(futime, status != "censored")`
                                    2.5% 97.5%
      age                              0     0
      sexfemale                        0     0
      albumin                          0     0
      ns(platelet, df = 2)1            0     0
      ns(platelet, df = 2)2            0     0
      D_Srv_ftm_stts_cn_center[1,1]    0     0
      beta_Bh0_Srv_ftm_stts_cn[1]      0     0
      beta_Bh0_Srv_ftm_stts_cn[2]      0     0
      beta_Bh0_Srv_ftm_stts_cn[3]      0     0
      beta_Bh0_Srv_ftm_stts_cn[4]      0     0
      beta_Bh0_Srv_ftm_stts_cn[5]      0     0
      beta_Bh0_Srv_ftm_stts_cn[6]      0     0
      
      

---

    Code
      lapply(models0, summary)
    Output
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      $m0a
      
      Bayesian proportional hazards model fitted with JointAI
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ 1, data = PBC2, 
          n.adapt = 1, n.iter = 4, seed = 2020, warn = FALSE, mess = FALSE)
      
      
      Number of events: 169 
      
      Posterior summary:
           Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      
      Posterior summary of other parameters:
                                  Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      beta_Bh0_Srv_ftm_stts_cn[1]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[2]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[3]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[4]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[5]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[6]    0  0    0     0          0     NaN    NaN
      
      
      MCMC settings:
      Iterations = 2:5
      Sample size per chain = 4 
      Thinning interval = 1 
      Number of chains = 3 
      
      Number of observations: 312 
      
      $m1a
      
      Bayesian proportional hazards model fitted with JointAI
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex, data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020, warn = FALSE, 
          mess = FALSE)
      
      
      Number of events: 169 
      
      Posterior summary:
                Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      age          0  0    0     0          0     NaN    NaN
      sexfemale    0  0    0     0          0     NaN    NaN
      
      Posterior summary of other parameters:
                                  Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      beta_Bh0_Srv_ftm_stts_cn[1]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[2]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[3]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[4]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[5]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[6]    0  0    0     0          0     NaN    NaN
      
      
      MCMC settings:
      Iterations = 3:6
      Sample size per chain = 4 
      Thinning interval = 1 
      Number of chains = 3 
      
      Number of observations: 312 
      
      $m1b
      
      Bayesian proportional hazards model fitted with JointAI
      
      Call:
      coxph_imp(formula = Surv(futime, I(status != "censored")) ~ age + 
          sex, data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020, warn = FALSE, 
          mess = FALSE)
      
      
      Number of events: 169 
      
      Posterior summary:
                Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      age          0  0    0     0          0     NaN    NaN
      sexfemale    0  0    0     0          0     NaN    NaN
      
      Posterior summary of other parameters:
                                  Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      beta_Bh0_Srv_ftm_stts_cn[1]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[2]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[3]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[4]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[5]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[6]    0  0    0     0          0     NaN    NaN
      
      
      MCMC settings:
      Iterations = 3:6
      Sample size per chain = 4 
      Thinning interval = 1 
      Number of chains = 3 
      
      Number of observations: 312 
      
      $m2a
      
      Bayesian proportional hazards model fitted with JointAI
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ copper, 
          data = PBC2, n.adapt = 2, n.iter = 4, seed = 2020, warn = FALSE, 
          mess = FALSE)
      
      
      Number of events: 169 
      
      Posterior summary:
             Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      copper    0  0    0     0          0     NaN    NaN
      
      Posterior summary of other parameters:
                                  Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      beta_Bh0_Srv_ftm_stts_cn[1]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[2]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[3]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[4]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[5]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[6]    0  0    0     0          0     NaN    NaN
      
      
      MCMC settings:
      Iterations = 3:6
      Sample size per chain = 4 
      Thinning interval = 1 
      Number of chains = 3 
      
      Number of observations: 312 
      
      $m3a
      
      Bayesian proportional hazards model fitted with JointAI
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ copper + 
          sex + age + abs(age - copper) + log(trig), data = PBC2, n.adapt = 2, 
          n.iter = 10, seed = 2020, warn = FALSE, mess = FALSE, trunc = list(trig = c(1e-04, 
              NA)))
      
      
      Number of events: 169 
      
      Posterior summary:
                        Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      copper               0  0    0     0          0     NaN    NaN
      sexfemale            0  0    0     0          0     NaN    NaN
      age                  0  0    0     0          0     NaN    NaN
      abs(age - copper)    0  0    0     0          0     NaN    NaN
      log(trig)            0  0    0     0          0     NaN    NaN
      
      Posterior summary of other parameters:
                                  Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      beta_Bh0_Srv_ftm_stts_cn[1]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[2]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[3]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[4]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[5]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[6]    0  0    0     0          0     NaN    NaN
      
      
      MCMC settings:
      Iterations = 3:12
      Sample size per chain = 10 
      Thinning interval = 1 
      Number of chains = 3 
      
      Number of observations: 312 
      
      $m3b
      
      Bayesian proportional hazards model fitted with JointAI
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ copper + 
          sex + age + abs(age - copper) + log(trig) + (1 | center), 
          data = PBC2, n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, 
          mess = FALSE, trunc = list(trig = c(1e-04, NA)))
      
      
      Number of events: 169 
      
      Posterior summary:
                        Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      copper               0  0    0     0          0     NaN    NaN
      sexfemale            0  0    0     0          0     NaN    NaN
      age                  0  0    0     0          0     NaN    NaN
      abs(age - copper)    0  0    0     0          0     NaN    NaN
      log(trig)            0  0    0     0          0     NaN    NaN
      
      
      Posterior summary of random effects covariance matrix:
                                    Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      D_Srv_ftm_stts_cn_center[1,1]    0  0    0     0                NaN    NaN
      
      
      Posterior summary of other parameters:
                                  Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      beta_Bh0_Srv_ftm_stts_cn[1]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[2]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[3]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[4]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[5]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[6]    0  0    0     0          0     NaN    NaN
      
      
      MCMC settings:
      Iterations = 3:12
      Sample size per chain = 10 
      Thinning interval = 1 
      Number of chains = 3 
      
      Number of observations: 312 
      Number of groups:
       - center: 10
      
      $m4a
      
      Bayesian proportional hazards model fitted with JointAI
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex + trt + albumin + platelet + stage + (1 | id), data = PBC, 
          n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, mess = FALSE, 
          timevar = "day")
      
      
      Number of events: 169 
      
      Posterior summary:
                 Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      age           0  0    0     0          0     NaN    NaN
      sexfemale     0  0    0     0          0     NaN    NaN
      trtplacebo    0  0    0     0          0     NaN    NaN
      albumin       0  0    0     0          0     NaN    NaN
      platelet      0  0    0     0          0     NaN    NaN
      stage.L       0  0    0     0          0     NaN    NaN
      stage.Q       0  0    0     0          0     NaN    NaN
      stage.C       0  0    0     0          0     NaN    NaN
      
      Posterior summary of other parameters:
                                  Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      beta_Bh0_Srv_ftm_stts_cn[1]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[2]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[3]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[4]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[5]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[6]    0  0    0     0          0     NaN    NaN
      
      
      MCMC settings:
      Iterations = 3:12
      Sample size per chain = 10 
      Thinning interval = 1 
      Number of chains = 3 
      
      Number of observations: 2257 
      Number of groups:
       - id: 312
      
      $m4b
      
      Bayesian proportional hazards model fitted with JointAI
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex * trt + albumin + log(platelet) + (1 | id), data = PBC, 
          n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, mess = FALSE, 
          timevar = "day")
      
      
      Number of events: 169 
      
      Posterior summary:
                           Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      age                     0  0    0     0          0     NaN    NaN
      sexfemale               0  0    0     0          0     NaN    NaN
      trtplacebo              0  0    0     0          0     NaN    NaN
      sexfemale:trtplacebo    0  0    0     0          0     NaN    NaN
      albumin                 0  0    0     0          0     NaN    NaN
      log(platelet)           0  0    0     0          0     NaN    NaN
      
      Posterior summary of other parameters:
                                  Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      beta_Bh0_Srv_ftm_stts_cn[1]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[2]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[3]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[4]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[5]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[6]    0  0    0     0          0     NaN    NaN
      
      
      MCMC settings:
      Iterations = 3:12
      Sample size per chain = 10 
      Thinning interval = 1 
      Number of chains = 3 
      
      Number of observations: 2257 
      Number of groups:
       - id: 312
      
      $m4c
      
      Bayesian proportional hazards model fitted with JointAI
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex + albumin + log(platelet) + (1 | id) + (1 | center), 
          data = PBC, n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, 
          mess = FALSE, timevar = "day")
      
      
      Number of events: 169 
      
      Posterior summary:
                    Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      age              0  0    0     0          0     NaN    NaN
      sexfemale        0  0    0     0          0     NaN    NaN
      albumin          0  0    0     0          0     NaN    NaN
      log(platelet)    0  0    0     0          0     NaN    NaN
      
      
      Posterior summary of random effects covariance matrix:
                                    Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      D_Srv_ftm_stts_cn_center[1,1]    0  0    0     0                NaN    NaN
      
      
      Posterior summary of other parameters:
                                  Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      beta_Bh0_Srv_ftm_stts_cn[1]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[2]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[3]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[4]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[5]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[6]    0  0    0     0          0     NaN    NaN
      
      
      MCMC settings:
      Iterations = 3:12
      Sample size per chain = 10 
      Thinning interval = 1 
      Number of chains = 3 
      
      Number of observations: 2257 
      Number of groups:
       - center: 10
       - id: 312
      
      $m4d
      
      Bayesian proportional hazards model fitted with JointAI
      
      Call:
      coxph_imp(formula = Surv(futime, status != "censored") ~ age + 
          sex + albumin + ns(platelet, df = 2) + (1 | id) + (1 | center), 
          data = PBC, n.adapt = 2, n.iter = 10, seed = 2020, warn = FALSE, 
          mess = FALSE, timevar = "day")
      
      
      Number of events: 169 
      
      Posterior summary:
                            Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      age                      0  0    0     0          0     NaN    NaN
      sexfemale                0  0    0     0          0     NaN    NaN
      albumin                  0  0    0     0          0     NaN    NaN
      ns(platelet, df = 2)1    0  0    0     0          0     NaN    NaN
      ns(platelet, df = 2)2    0  0    0     0          0     NaN    NaN
      
      
      Posterior summary of random effects covariance matrix:
                                    Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      D_Srv_ftm_stts_cn_center[1,1]    0  0    0     0                NaN    NaN
      
      
      Posterior summary of other parameters:
                                  Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      beta_Bh0_Srv_ftm_stts_cn[1]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[2]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[3]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[4]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[5]    0  0    0     0          0     NaN    NaN
      beta_Bh0_Srv_ftm_stts_cn[6]    0  0    0     0          0     NaN    NaN
      
      
      MCMC settings:
      Iterations = 3:12
      Sample size per chain = 10 
      Thinning interval = 1 
      Number of chains = 3 
      
      Number of observations: 2257 
      Number of groups:
       - center: 10
       - id: 312
      

---

    Code
      lapply(models0, function(x) coef(summary(x)))
    Output
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      [1] "No variability observed in a component. Setting batch size to 1"
      $m0a
      $m0a$`Surv(futime, status != "censored")`
           Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      
      
      $m1a
      $m1a$`Surv(futime, status != "censored")`
                Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      age          0  0    0     0          0     NaN    NaN
      sexfemale    0  0    0     0          0     NaN    NaN
      
      
      $m1b
      $m1b$`Surv(futime, I(status != "censored"))`
                Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      age          0  0    0     0          0     NaN    NaN
      sexfemale    0  0    0     0          0     NaN    NaN
      
      
      $m2a
      $m2a$`Surv(futime, status != "censored")`
             Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      copper    0  0    0     0          0     NaN    NaN
      
      
      $m3a
      $m3a$`Surv(futime, status != "censored")`
                        Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      copper               0  0    0     0          0     NaN    NaN
      sexfemale            0  0    0     0          0     NaN    NaN
      age                  0  0    0     0          0     NaN    NaN
      abs(age - copper)    0  0    0     0          0     NaN    NaN
      log(trig)            0  0    0     0          0     NaN    NaN
      
      
      $m3b
      $m3b$`Surv(futime, status != "censored")`
                        Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      copper               0  0    0     0          0     NaN    NaN
      sexfemale            0  0    0     0          0     NaN    NaN
      age                  0  0    0     0          0     NaN    NaN
      abs(age - copper)    0  0    0     0          0     NaN    NaN
      log(trig)            0  0    0     0          0     NaN    NaN
      
      
      $m4a
      $m4a$`Surv(futime, status != "censored")`
                 Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      age           0  0    0     0          0     NaN    NaN
      sexfemale     0  0    0     0          0     NaN    NaN
      trtplacebo    0  0    0     0          0     NaN    NaN
      albumin       0  0    0     0          0     NaN    NaN
      platelet      0  0    0     0          0     NaN    NaN
      stage.L       0  0    0     0          0     NaN    NaN
      stage.Q       0  0    0     0          0     NaN    NaN
      stage.C       0  0    0     0          0     NaN    NaN
      
      
      $m4b
      $m4b$`Surv(futime, status != "censored")`
                           Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      age                     0  0    0     0          0     NaN    NaN
      sexfemale               0  0    0     0          0     NaN    NaN
      trtplacebo              0  0    0     0          0     NaN    NaN
      sexfemale:trtplacebo    0  0    0     0          0     NaN    NaN
      albumin                 0  0    0     0          0     NaN    NaN
      log(platelet)           0  0    0     0          0     NaN    NaN
      
      
      $m4c
      $m4c$`Surv(futime, status != "censored")`
                    Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      age              0  0    0     0          0     NaN    NaN
      sexfemale        0  0    0     0          0     NaN    NaN
      albumin          0  0    0     0          0     NaN    NaN
      log(platelet)    0  0    0     0          0     NaN    NaN
      
      
      $m4d
      $m4d$`Surv(futime, status != "censored")`
                            Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
      age                      0  0    0     0          0     NaN    NaN
      sexfemale                0  0    0     0          0     NaN    NaN
      albumin                  0  0    0     0          0     NaN    NaN
      ns(platelet, df = 2)1    0  0    0     0          0     NaN    NaN
      ns(platelet, df = 2)2    0  0    0     0          0     NaN    NaN
      
      

