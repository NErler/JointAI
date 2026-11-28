# Get the shape parameters of Weibull survival models

The shape parameter of a Weibull survival model
([`survreg_imp()`](https://nerler.github.io/JointAI/reference/model_imp.md))
has the prior `dexp(0.01)` (see `jagsmodel_survreg()`).

## Usage

``` r
get_survreg_shape_nodes(info_list)
```

## Arguments

- info_list:

  a list with the information on the sub-models, as obtained from
  `get_model_info()`

## Value

a named integer vector with the value `0L` (a single value, see
[`add_jags5_inits()`](https://nerler.github.io/JointAI/reference/add_jags5_inits.md)),
named by the node of the shape parameter (e.g.,
`c(shape_Srv_ftm_stts_cn = 0L)`); of length zero if there are no survreg
models
