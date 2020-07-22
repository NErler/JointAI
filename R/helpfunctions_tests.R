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

get_predprob <- function(mod, varname) {
  MCMC <- do.call(rbind, mod$MCMC)
  ps <- grep(paste0("^p_", varname, "\\b"), colnames(MCMC), value = TRUE)
  cat <- gsub("\\]$", ")",
              gsub(paste0("^p_", varname, "\\[[[:digit:]]+,"),
              paste0("P(", varname, "="), ps)
  )


  problist <- lapply(split(ps, cat), function(n) {
    samp <- MCMC[, n]
    cbind(fit = colMeans(samp),
          t(apply(samp, 2, quantile, c(0.025, 0.975)))
    )
  })


  array(dim = c(dim(problist[[1]]), length(problist)),
        dimnames = list(c(), colnames(problist[[1]]), names(problist)),
        unlist(problist))
}

check_predprob <- function(mod) {
  varname <- names(mod$fixed)[1]
  f <- predict(mod, type = "prob", warn = FALSE)$fit
  g <- get_predprob(mod, varname = varname)

  sum(round(f - g, 10), na.rm = TRUE)
}



compare_modeltype <- function(mod) {
  call <- deparse(mod$call, width.cutoff = 500)

  type <- gsub("_[[:print:]]+", "", call)
  fam <- gsub("family = |,", "",
              regmatches(call,
                         regexpr("family = [[:alpha:]]+\\([[:print:]]*\\),",
                                 call)))
  family = eval(parse(text = fam))

  m <- mod$models[names(mod$fixed)[1]]


  c(
    list(
      # compare analysis model type
      analysis_model_type = all.equal(as.vector(mod$analysis_type), type),

      # compare family
      family = if (type != "lm") {
        all.equal(attr(mod$analysis_type, "family"), family)
      }
    ),

    # compare models element
    if (type %in% c("glm", "glmm")) {
      list(
        models_type = all.equal(get_modeltype(m), type),
        models_family = all.equal(get_family(m), family$family),
        models_link = all.equal(get_link(m), family$link)
      )
    } else {
      list(
        models_type = !inherits(get_modeltype(m), "try-error"),
        models_family = !inherits(get_family(m), "try-error"),
        models_link = !inherits(get_link(m), "try-error")
      )
    }
  )
}
