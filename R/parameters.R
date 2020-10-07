
#' Parameter names of an JointAI object
#'
#' Returns the names of the parameters/nodes of an object of class 'JointAI' for
#' which a monitor is set.
#'
#' @inheritParams sharedParams
#' @param expand_ranef logical; should all elements of the random effects
#'                     vectors/matrices be shown separately?
#' @param ... currently not used
#'
#' @examples
#' # (This function does not need MCMC samples to work, so we will set
#' # n.adapt = 0 and n.iter = 0 to reduce computational time)
#' mod1 <- lm_imp(y ~ C1 + C2 + M2 + O2 + B2, data = wideDF, n.adapt = 0,
#'                n.iter = 0, mess = FALSE)
#'
#' parameters(mod1)
#'
#' @export
#'
parameters <- function(object, expand_ranef = FALSE, mess = TRUE, warn = TRUE,
                       ...) {

  if (!inherits(object, "JointAI"))
    errormsg("Use only with 'JointAI' objects.")

  args <- as.list(match.call())

  if (is.null(object$MCMC) & mess)
    msg("Note: %s does not contain MCMC samples.", dQuote(args$object))

  # the variable.names that were passed to JAGS
  vnam <- object$mcmc_settings$variable.names
  # expand baseline hazard parameters
  vnam <- expand_params(pattern = "^beta_Bh0",
                        vnam = vnam,
                        n = object$Mlist$df_basehaz)


  # expand random effects
  if (expand_ranef) {
    vnam <- expand_ranefs(pattern = paste0("^b[[:print:]]*_", object$Mlist$idvar,
                                           "$", collapse = "|"),
                          vnam = vnam,
                          MCMC_names = colnames(object$MCMC[[1]]))
  }

  # expand ordinal intercepts
  gammas <- grep("^gamma_", vnam, value = TRUE)
  for (k in gammas) {
    vnam <- expand_params(pattern = k,
                          vnam = vnam,
                          n = object$info_list[[gsub("gamma_", "", k)]]$ncat - 1)
  }

  # the coef_list, containing the regression coefficient info
  coefs <- do.call(rbind, object$coef_list)

  # figure out which part of vnam is already included in "coefs" and which part
  # needs to be added
  rows <- unlist(lapply(paste0('\\b', vnam, '\\b'), grep, x = coefs$coef))
  add <- sapply(vnam, function(x) {
    !any(grepl(paste0('\\b', x, '\\b'), coefs$coef))
  })




  df_names <- if (is.null(coefs)) {
    c("outcome", "outcat", "varname", "coef")
  } else {
    names(coefs)
  }
  add_pars <- as.list(setNames(rep(NA, length(df_names)), df_names))
  add_pars$coef <- vnam[add]

  pat_full <- unlist(
    lapply(names(object$Mlist$rd_vcov), function(lvl) {
        lapply(which(names(object$Mlist$rd_vcov[[lvl]]) == "full"), function(k) {
          list(
            pattern = paste0("^", c("D", "invD", "RinvD", "KinvD", "b"),
                             attr(object$Mlist$rd_vcov[[lvl]][[k]], "name"),
                             "_", lvl),
            vars = as.character(object$Mlist$rd_vcov[[lvl]][[k]])
          )
        })
    }), recursive = FALSE)

  # identify which outcome the remaining parameters belong to by matching the
  # outcome names with the parameter names
  patterns <- lapply(clean_survname(names(object$coef_list)), function(out) {
    paste0("_", out, "$|_", out, "_|_", out, "\\[")
  })


  matches <- regexpr(paste0(patterns, collapse = "|"), add_pars$coef)
  out_match <- regmatches(add_pars$coef, matches)

  if (length(out_match) > 0) {
    add_pars$outcome <- rep(NA, length(add_pars$coef))
    add_pars$outcome[matches > 0] <- gsub("^_|_$|\\[$", "", out_match)
  }

  for (x in pat_full) {
    r <- unlist(lapply(x$pattern, grep, add_pars$coef))
    add_pars$outcome[r] <- list(x$vars)
  }



  params <- if (any(add)) {
    add_df <- as.data.frame(add_pars[-which(names(add_pars) == "outcome")])
    add_df$outcome <- add_pars$outcome

    rbind(coefs[rows, , drop = FALSE], add_df)
  } else {
    coefs
  }

  rownames(params) <- NULL

  params <- params[, setdiff(names(params), 'varnam_print')]

  # has to be sorted so that the additional parameters are together with the
  # regression coefficients
  params[order(match(params$outcome,
                     clean_survname(names(object$coef_list)))), ]
}




expand_params <- function(pattern, vnam, n) {
  if (any(grepl(pattern, vnam))) {
    pars <- grep(pattern, vnam)

    for (k in pars) {
      vnam <- c(vnam, paste0(vnam[k], "[", seq_len(n), "]"))
    }
    vnam <- vnam[-pars]
  }
  vnam
}

expand_ranefs <- function(pattern, vnam, MCMC_names) {
  if (any(grepl(pattern, vnam))) {
    pos <- grep(pattern, vnam)

    for (k in pos) {
      vnam <- c(vnam,
                grep(paste0("^", vnam[k], "\\["), MCMC_names, value = TRUE))
    }
    vnam <- vnam[-pos]
  }
  vnam
}
