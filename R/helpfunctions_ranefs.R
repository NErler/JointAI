HC <- function(fixed, random, data, interactions, Mcnam, Mlnam) {

  # for each random effects formula:
  hc <- sapply(seq_along(random), function(k) {
    if (!is.null(random[[k]])) {
      # make the design matrices
      Z <- model.matrix(remove_grouping(random[[k]]), data)
      X <- model.matrix(fixed[[k]], data)

      # identify interactions from fixed
      inters <- interactions[names(interactions) %in% colnames(X)]

      # identify if there are elements of interaction in Z
      inZ <- if (length(inters) > 0)
        sapply(colnames(Z), function(x)
          lapply(lapply(inters, attr, 'elements'), `%in%`, x), simplify = FALSE)

      sapply(colnames(Z), function(x) {
        list(
          main = #if (x %in% colnames(X)) {
            # if the ranom effect is in the fixed effects, find the column of the design matrix
            c(
              if (!is.na(match(x, Mcnam)))
                setNames(match(x, Mcnam), 'Mc'),
              if (!is.na(match(x, Mlnam)))
                setNames(match(x, Mlnam), 'Ml')
            ),
          # if the random effect is not in the fixed effects, return 0
          # } else 0,

          interact = if (any(unlist(inZ[[x]]))) {
            w <- sapply(inZ[[x]], any)
            inters[w]
          }
        )
      }, simplify = FALSE)
    }}, simplify = FALSE)
  names(hc) <- names(random)
  return(hc)
}


get_hc_info <- function(info) {

  if (is.null(info$hc_list))
    return(NULL)

  hc_list <- info$hc_list
  # find the main effect elements in Ml and Mc
  hcinfo <- list()
  allcoefs <- c()
  for (ranefnam in names(hc_list)) {
    # for each random (slope) effect, do:

    if (ranefnam != "(Intercept)") {
      hc <- hc_list[[ranefnam]]

      # main effects in the random effects design matrix
      # (coefficients go into mu_b, b is multiplied with the column of M)
      main_effect <- list(matrix = names(hc$main),
                          column = unname(hc$main),
                          coef_nr = if (names(hc$main) == 'Mc')
                            info$parelmts$Mc[match(hc$main, info$lp$Mc)]
                          else if (names(hc$main) == 'Ml')
                            info$parelmts$Ml[match(hc$main, info$lp$Ml)]
      )

      # interactions of fixed effects with random effects variables
      # (if baseline: coefficient and variable inside mu_b;
      #  if lonitudinal: interaction with random effect treated as standard
      #  longitudinal variable and is added separately)
      interact_effect <- if (!is.null(hc$interact))
        sapply(hc$interact, function(k) {
          # for each interaction with this random (slope) effect, do:

          # find which of the elements of the interaction is not the random effect
          elmts <- k$elmts[which(attr(k, 'elements') != ranefnam)]

          coefnr <- if (names(k$interterm) == 'Mc')
            info$parelmts$Mc[match(k$interterm, info$lp$Mc)]
          else if (names(k$interterm) == 'Ml')
            info$parelmts$Ml[match(k$interterm, info$lp$Ml)]


            list(
              matrix = names(elmts),
              column = unname(elmts),
              coef_nr = coefnr
            )
        }, simplify = FALSE)

      hcinfo[[ranefnam]] <- list(main_effect = main_effect,
                                  interact_effect = interact_effect[
                                    !sapply(interact_effect, "[[", 'coef_nr') %in% allcoefs]
      )
      allcoefs <- c(allcoefs, sapply(interact_effect, "[[", 'coef_nr'))
    }}

  return(hcinfo)
}


organize_hc_parelmts <- function(hc_info, info) {
  # find which parameter elements are used in the hierarchical centering
  # specification of the random slopes

  in_rdslope <- unlist(sapply(hc_info, function(k) {
    c(# coefficients of fixed effects that are also random effects:
      k$main_effect$coef_nr,
      # coefficients of baseline fixed effects that have interaction with rd. effects
      sapply(k$interact_effect, "[[", "coef_nr")[
        sapply(k$interact_effect, "[[", "matrix") %in% "Mc"]
    )
  })
  )

  # parameter elements left for the baseline covariates
  in_b0 <- which(!info$parelmts$Mc %in% in_rdslope)
  # parameter elements left for the longitudinal covariates,
  # added to the "Zb" part of the linear predictor
  notin_b <- which(!info$parelmts$Ml %in% in_rdslope)

  return(list(in_b0 = in_b0, notin_b = notin_b, in_rdslope = in_rdslope))
}

