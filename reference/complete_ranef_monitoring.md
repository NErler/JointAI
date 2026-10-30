# Complete the monitored parameters for transforming random effects back

With scaled covariates, the random effects and their covariance matrices
are transformed back after sampling
([`rescale_ranefs()`](https://nerler.github.io/JointAI/reference/rescale_ranefs.md)).
This needs, per block of random effects
([`get_ranef_blocks()`](https://nerler.github.io/JointAI/reference/get_ranef_blocks.md)):

- all random effects of a monitored group (one row of `b`), because `A`
  combines the random effects of a group,

- all elements of the covariance matrix `D`, because `D = A D_s A'`,

- the regression coefficients of the sub-model, for the shift `delta`.

## Usage

``` r
complete_ranef_monitoring(var_names, info_list, mess = TRUE)
```

## Arguments

- var_names:

  character vector of the parameters (nodes) to monitor, as passed to
  JAGS (`get_params()`).

- info_list:

  list with the model information of each sub-model
  (`get_model_info()`).

- mess:

  logical; show a message about the added parameters?

## Value

`var_names` with the parameters that need to be added.

## Details

Only these are added: if some random effects of a few groups are
monitored (e.g. `b_y_id[5,2]`), only the rest of their rows is added
(`b_y_id[5,1:2]`), not the random effects of all groups.
