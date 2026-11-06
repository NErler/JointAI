# Print the random effects of a sub-model (used in `list_models()`)

For each grouping level with random effects: the random effects with
their variables, and their covariance matrix with its prior, as in the
JAGS model (`ranef_priors()`): a Gamma prior for the precision of a
single random effect, Gamma priors for the diagonal precision matrix
with `rd_vcov = "indep"`, and otherwise a Wishart prior for the
precision matrix, with Gamma priors for the diagonal of its scale
matrix. With `rd_vcov = "full"`, the random effects of several
sub-models have one covariance matrix; the sub-models that share it are
named.

## Usage

``` r
print_ranefs(info, data_list, priors)
```

## Arguments

- info:

  the model information of the sub-model (an element of `info_list`).

- data_list:

  the data list passed to JAGS (for the hyper-parameters of the priors).

- priors:

  logical; should the priors be printed?

## Value

`NULL`, invisibly; called for the printed output.
