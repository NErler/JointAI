# First validation for rd_vcov

Checks if `rd_vcov` is a `list` with elements for all grouping levels or
does not specify a grouping level. If valid, this function also make
sure that `rd_vcov` is a list per grouping level by duplicating the
contents if necessary.

## Usage

``` r
check_rd_vcov_list(rd_vcov, idvar)
```

## Arguments

- rd_vcov:

  a character string or a list describing the the random effects
  variance covariance structure (provided by the user)

- idvar:

  vector with the names of all grouping variables (except "lvlone")

## Value

A named list per grouping level where each elements contains information
on how the random effects variance-covariance matrices on that level are
structured. Per level it can be either a character string (e.g.
`"full"`) or a list specifying structures per (groups) of variable(s)
(e.g. `list(full = c("a", "b"), indep = "c")`)
