# Create a Survival Object

This function just calls `Surv()` from the
[**survival**](https://CRAN.R-project.org/package=survival) package.

## Usage

``` r
Surv(time, time2, event, type = c("right", "left", "interval", "counting",
  "interval2"), origin = 0)
```

## Arguments

- time:

  for right censored data, this is the follow up time. For interval
  data, the first argument is the starting time for the interval.

- time2:

  ending time of the interval for interval censored or counting process
  data only. Intervals are assumed to be open on the left and closed on
  the right, `(start, end]`. For counting process data, `event`
  indicates whether a transtion to another state occurred at the end of
  the interval.

- event:

  The status indicator, normally 0=alive, 1=dead. Other choices are
  `TRUE`/`FALSE` (`TRUE` = death), 1/2 (2=death), or a factor variable.
  For interval censored data, the status indicator is 0=right censoed,
  1=event at `time`, 2=left censored, 3=interval censored. For multiple
  endpoint data the event variable will always be a factor, whose first
  level is treated as censoring, or more formally "no transtition at
  this time point". There is no constraint on the labels of the factor.
  Although unusual, the event indicator can be omitted, in which case
  all subjects are assumed to have an event.

- type:

  character string specifying the type of censoring. Possible values are
  `"right"`, `"left"`, `"counting"`, `"interval"`, `"interval2"`. The
  default is multi-state if `event` is a factor, counting process if
  `time2` is present, or right censored, in that order.

- origin:

  for counting process data, the hazard function origin. This option was
  intended to be used in conjunction with a model containing time
  dependent strata in order to align the subjects properly when they
  cross over from one strata to another, but it has rarely proven useful
  and is depricated.
