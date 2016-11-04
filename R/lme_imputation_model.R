lme.model <- function(index1, out, pred, model.dim, dm, name, ...){
  # out <- sub(pattern="index1", x=out, replacement=index1)
  # pred <- lapply(pred, sub, pattern="index1", replacement=index1)
  # predictor <- NULL
  # for(k in 1:length(pred)){
  #   predictor <- paste(c(predictor,
  #                        paste("inprod(", pred[[k]][1], ", ", pred[[k]][2],")", sep="")), collapse=" + ")
  # }
  #
  #
  # long.covars <- if(!is.null(dm$Xl)){
  #   paste(" + inprod(Xl[", index1, ", ], beta[", model.dim$K.l[1], ":", model.dim$K.l[2], "])", sep="")
  # }
  #

  norm.distr  <- if(ncols$Z < 2) {"dnorm"} else {"dmnorm"}

  # Xic.part <- if(!is.null(dm$Xic)){
  #   Xic.part <- paste(" + inprod(beta[", model.dim$K.ic[1],":", model.dim$K.ic[2],"], Xic[i, ])", sep="")
  # }
  #
  rd.slopes <- NULL
  if(ncols$Z > 1){
    for (k in 2:ncols$Z) {
      rd.slopes <- c(rd.slopes,
                     paste0("\t", "mu.b[i, ", k,"] <- ",
                            paste("beta[", K[colnames(Z)[k], 1]:K[colnames(Z)[k], 2], "] * Xc[", index2, ", ",
                                  time_hc[[k-1]], "]", sep = "", collapse = " + "))
      )
    }
  }


  paste0("\t", "# Linear mixed effects model for ", names(y), "\n",
         "\t", y, "[", index1, "] ~ dnorm(mu.", names(y), "[", index1, "], tau.", names(y), ")", "\n",
         "\t", "mu.", names(y), "[", index1, "] <- inprod(b[subj[", index1, "], ], Z[", index1, ", ])",
         # "\t", long.covars,
         "\n", "}", "\n\n",
         "for(", index2, " in 1:", N, "){", "\n",
         "\t", "b[", index2, ", 1:", ncols$Z, "] ~ ", norm.distr, "(mu.b[", index2, ", ], inv.D[ , ])", "\n",
         "\t", "mu.b[", index2, ", 1] <- inprod(beta[", K["Xc", 1], ":", K["Xc", 2], "], Xc[", index2, ", ])",
         # "\t", Xic.part,
         "\n",
         paste(rd.slopes, collapse = "\n", sep = "")
  )
}



y = c("BMI" = "bmi")
index1 = "j"
index2 = "i"

Mlist = divide_matrices(DF, fmla1, rndm2)
K = get_model_dim(sapply(Mlist, ncol), Mlist$time_hc)
ncols <- sapply(Mlist, ncol)
Z <- Mlist$Z
time_hc <- Mlist$time_hc

get_model_dim(sapply(Mlist, ncol), Mlist$time_hc)
Mlist$time_hc
