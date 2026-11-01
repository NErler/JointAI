# Terms of only the time variable in the survival part of a joint model

The baseline hazard of a joint model is a (spline) function of time, so
that the effect of a term that involves nothing but the time variable
(e.g., `day`, `ns(day, df = 3)`, `log(day + 1)` or `I(day^2)`) cannot
(or hardly) be distinguished from it. Interactions of the time variable
with another variable (e.g., `chol:day`) describe an effect of that
other variable that changes over time, and are not concerned.

## Usage

``` r
check_jm_time_terms(fixed, timevar)
```

## Arguments

- fixed:

  the formula of the survival model.

- timevar:

  name of the time variable.

## Value

`NULL`, invisibly; called for the error.

## Details

Stops with an informative error if there is such a term.
