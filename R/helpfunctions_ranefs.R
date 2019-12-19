
paste_ranefpreds <- function(ranefpreds, info) {
  if (length(ranefpreds) > 0) {
    paste0(tab(4), "mu_b_", info$varname, "[", info$index[2], ", ", seq_along(ranefpreds), "] <- ",
           ranefpreds, collapse = "\n")
  } else {
    paste0(tab(4), "mu_b_", info$varname, "[", info$index[2], ", 1] <- 0", collapse = "\n")
  }
}


get_ranefpreds <- function(info) {
  hc_list <- info$hc_list
  # find the main effect elements in Ml and Mc
  rdslopes <- sapply(names(hc_list), function(ranefnam) {

    if (ranefnam != "(Intercept)") {
      hc <- hc_list[[ranefnam]]

      main_effect <- list(matrix = names(hc$main),
                          column = unname(hc$main),
                          coef_nr = if (names(hc$main) == 'Mc')
                            info$parelmts$Mc[match(hc$main, info$lp$Mc)]
                          else if (names(hc$main) == 'Ml')
                            info$parelmts$Ml[match(hc$main, info$lp$Ml)]
      )


      interact_effect <- if(!is.null(hc$interact))
        sapply(hc$interact, function(k) {
          elmts <- k$elmts[which(attr(k, 'elements') != ranefnam)]

          list(
            matrix = names(elmts),
            column = unname(elmts),
            coef_nr = if (names(k$interterm) == 'Mc')
              info$parelmts$Mc[match(k$interterm, info$lp$Mc)]
            else if (names(k$interterm) == 'Ml')
              info$parelmts$Ml[match(k$interterm, info$lp$Ml)]
          )
        }, simplify = FALSE)


      list(main_effect = main_effect,
           interact_effect = interact_effect,
           ranefpred = if (is.na(main_effect$coef_nr)) {
             "0"
           } else {
             paste0(
               c(paste0(info$parname, "[", main_effect$coef_nr, "]"),
                 if (!is.null(interact_effect))
                   paste0(info$parname, "[",
                          sapply(interact_effect, "[[", 'coef_nr')[sapply(interact_effect, "[[", 'matrix') == 'Mc'],
                          "] * Mc[", info$index, ", ",
                          sapply(interact_effect, "[[", 'column')[sapply(interact_effect, "[[", 'matrix') == 'Mc'],
                          "]")
               ), collapse = " + ")
           }
      )
    }}, simplify = FALSE)


  ranefpreds <- sapply(rdslopes, "[[", 'ranefpred')

  in_rdslope <- unlist(lapply(rdslopes[!sapply(rdslopes, is.null)], function(k) {
    c(k$main_effect$coef_nr,
      sapply(k$interact_effect, "[[", 'coef_nr'))
  }))

  w <- which(!info$parelmts$Mc %in% in_rdslope)

  # random intercept:
  if (length(info$lp$Mc[w]) > 0)
    ranefpreds[["(Intercept)"]] <- paste_predictor(parnam = info$parname, parindex = info$index[2],
                                                   matnam = 'Mc',
                                                   cols = info$lp$Mc[w],
                                                   scale_pars = info$scale_pars$Mc,
                                                   parelmts = info$parelmts$Mc[w],
                                                   indent = linkindent(info$link) + nchar(info$varname) + 14)


  wl <- which(!info$parelmts$Ml %in% in_rdslope)

  Ml_predictor <- if (length(info$parelmts$Ml[wl]) > 0)
    paste0(tab(4 + nchar(info$varname) + 2 + 8),
           paste_predictor(parnam = info$parname, parindex = info$index[1],
                           matnam = 'Ml',
                           cols = info$lp$Ml[wl],
                           scale_pars = info$scale_pars$Ml[wl, ],
                           parelmts = info$parelmts$Ml[wl],
                           indent = 4 + nchar(info$varname) + 2 + 8)
    )


  Z_predictor <- paste0(
    ifelse(!sapply(rdslopes, is.null),
           paste0(
             sapply(sapply(rdslopes, "[[", 'main_effect'), "[[", 'matrix'), "[",
             info$index[1], ", ",
             sapply(sapply(rdslopes, "[[", 'main_effect'), "[[", 'column'), "] * "
           ), ''),
    'b_', info$varname, "[group[", info$index[1], "], ", seq_along(ranefpreds), "]",
    collapse = " + "
  )



  # "mu_b_", info$varname, "[] * "

  # ranefpreds
  return(list(ranefpreds = paste_ranefpreds(ranefpreds, info),
              Ml_predictor = Ml_predictor,
              Z_predictor = Z_predictor))
}
