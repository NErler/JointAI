# Expand rd_vcov using variable names in case "full" is used

Expand rd_vcov using variable names in case "full" is used

## Usage

``` r
expand_rd_vcov_full(rd_vcov, rd_outnam)
```

## Arguments

- rd_vcov:

  the random effects variance covariance structure provided by the user
  ([`check_rd_vcov_list()`](https://nerler.github.io/JointAI/reference/check_rd_vcov_list.md)
  is called internally)

- rd_outnam:

  list by grouping level of the names of the outcome variables that have
  random effects on this level

## Value

A named list per grouping level where each elements contains information
on how the random effects variance-covariance matrices on that level are
structured. Per level there is a list of grouping structures containing
the names of variables in each structure (e.g.
`list(full = c("a", "b"), indep = "c")`)
