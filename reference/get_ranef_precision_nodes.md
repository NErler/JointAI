# Get the precisions of random effects that have a truncated gamma prior

The precision of a single random effect, and the precisions of
independent random effects (`rd_vcov = "indep"`), have a truncated gamma
prior (`dgamma(...)T(1e-16, 1e16)`, see `rd_vcov_univ()` and
`rd_vcov_indep()`). Correlated random effects (`"blockdiag"`, `"full"`)
have a Wishart prior; a `"full"` structure always has more than one
random effect (with a single outcome it is `"blockdiag"`).

## Usage

``` r
get_ranef_precision_nodes(info_list)
```

## Arguments

- info_list:

  a list with the information on the sub-models, as obtained from
  `get_model_info()`

## Value

a named integer vector: the number of random effects (the dimension of
the precision matrix), named by the node of the precision matrix (e.g.,
`c(invD_y_id = 1L)`); of length zero if there are no such nodes
