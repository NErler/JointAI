# Parameters to include in the auto- and cross-correlation of MCMC samples

Parameters to include in the auto- and cross-correlation of MCMC samples

## Usage

``` r
get_corr_nodes(object, outcome)
```

## Arguments

- object:

  an object of class JointAI

- outcome:

  optional; vector of indices or names of the sub-models whose
  parameters are selected; `NULL` selects all monitored parameters

## Value

a character vector with the names of the selected columns of the MCMC
sample, in the order of the MCMC sample
