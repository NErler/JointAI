
# used in idSurv() (2020-06-11)
idfun <- function(time, status, ...) {
  # helper function extract the names of the arguments passed to this function
  # (used together with idSurv())

  args <- as.list(match.call())[-1]
  return(lapply(args, deparse, width.cutoff = 500))
}

# used in extract_outcome_data() (2020-06-11)
idSurv <- function(LHS) {
  # helper function to mirror the Surv() function from the survival package
  # to be able to extract the names of the arguments passed to this function

  eval(parse(text = gsub("^Surv\\(", 'idfun\\(', LHS)))
}



# used in data_list() and predict_coxph() (2020-06-11)
gauss_kronrod <- function() {
  # return a list with Gauss-Kronrod quadrature points and weights

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


# used in get_data_list() and predict_coxph() (2020-06-11)
get_knots_h0 <- function(nkn, Time, event, gkx, obs_kn = TRUE) {
  # obtain the knots used in the B-spline specification of the baseline hazard
  # in coxph and JM
  # - nkn: number of (inner) knots
  # - Time: vecor of event times
  # - event: vector of event indicators
  # - gkx: Gauss-Kronrod quadrature points
  # - obs_kn: logical; use all observations of the event times
  #           (events and censorings; TRUE) or just actual event times (FALSE)

  pp <- seq(0, 1, length.out = nkn + 2)
  pp <- tail(head(pp, -1), -1) # remove first and last
  tt <- if (obs_kn) { # use only event times or all times
    Time
  } else {
    Time[event == 1]
  }
  kn <- quantile(tt, pp, names = FALSE)

  kn <- kn[kn <= max(Time)]
  sort(c(rep(range(Time, outer(Time/2, gkx + 1)), 4), kn))
}

