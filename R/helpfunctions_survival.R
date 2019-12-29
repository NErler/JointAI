
idfun <- function(time, status, ...) {
  args <- as.list(match.call())[-1]
  return(lapply(args, deparse))
}

# used in helpfunctions_formulas.R
idSurv <- function(LHS) {
  eval(parse(text = gsub("^Surv\\(", 'idfun\\(', LHS)))
}




gauss_kronrod <- function() {
  m <- matrix(nrow = 15, ncol = 2, byrow = TRUE,
              data = c(-0.9914553711208126392069,	0.0229353220105292249637,
                       -0.9491079123427585245262,	0.0630920926299785532907,
                       -0.8648644233597690727897,	0.1047900103222501838399,
                       -0.7415311855993944398639,	0.140653259715525918745,
                       -0.5860872354676911302941,	0.1690047266392679028266,
                       -0.4058451513773971669066,	0.1903505780647854099133,
                       -0.2077849550078984676007,	0.2044329400752988924142,
                       0,	0.209482141084727828013,
                       0.2077849550078984676007,	0.2044329400752988924142,
                       0.4058451513773971669066,	0.190350578064785409913,
                       0.5860872354676911302941,	0.1690047266392679028266,
                       0.7415311855993944398639,	0.1406532597155259187452,
                       0.8648644233597690727897,	0.10479001032225018384,
                       0.9491079123427585245262,	0.0630920926299785532907,
                       0.9914553711208126392069,	0.02293532201052922496373))
  return(list(gkx = m[, 1], gkw = m[, 2]))
}


# used in get_data_list.R
get_knots_h0 <- function(nkn, Time, event, gkx, obs_kn = TRUE) {
  pp <- seq(0, 1, length.out = nkn + 2)
  pp <- tail(head(pp, -1), -1) # remove first and last
  tt <- if (obs_kn) { # use only event times or all times
    Time
  } else {
    Time[event == 1]
  }
  kn <- quantile(tt, pp, names = FALSE)

  kn <- kn[kn < max(Time)]
  sort(c(rep(range(Time, outer(Time/2, gkx + 1)), 4), kn))
}

