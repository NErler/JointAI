# Part of the shift of the random effects that depends on covariates

The shift of the random effects of group `g` is
`delta_g = mu(x_g) - A mu_s(x_g)`, with `x_g` the covariates in the
means of the random effects of that group. It is affine in `x_g`:
`delta_g = delta + sum_w slope_w * x_gw`, with `delta` from
[`ranef_shift()`](https://nerler.github.io/JointAI/reference/ranef_shift.md).
Usually, `slope_w` is zero for each covariate (the covariates drop out,
because the fixed effects are transformed back consistently), so that
the data are not needed. It is not zero, e.g., in
`y ~ C1 * time + (time | id) + (C1 | center)`: the part of `C1:time`
that the back-transformation moves into the coefficient of C1 belongs to
the center-level random slope of C1, not to the id-level random
intercept.

## Usage

``` r
ranef_covariate_shift(part, A_part, MCMC, rescaled, coefs, scale_pars,
  data_list)
```

## Arguments

- part:

  one outcome of a block of random effects: element of the `parts` of a
  block
  ([`get_ranef_blocks()`](https://nerler.github.io/JointAI/reference/get_ranef_blocks.md)),
  with `info`, `lvl_info` and `cols`.

- A_part:

  transformation matrix of the random effects of this outcome
  ([`ranef_transformation()`](https://nerler.github.io/JointAI/reference/ranef_transformation.md)).

- MCMC:

  MCMC sample (matrix) on the scale used in JAGS.

- rescaled:

  MCMC sample (matrix) in which the coefficients are already transformed
  back (`rescale_coefs()`).

- coefs:

  `data.frame` with one row per regression coefficient
  (`do.call(rbind, get_coef_names(info_list))`); used to find the
  coefficients in the means of the random effects.

- scale_pars:

  `data.frame` of scaling parameters (columns `center` and `scale`, one
  row per design-matrix column, named by the column), with centre 0 and
  scale 1 for columns that are not scaled.

- data_list:

  data list passed to JAGS (for the names of design-matrix columns).

## Value

List with one element per covariate for which `slope_w` is not zero: `w`
(column name), `matrix` and `col` (data matrix and column number), and
`slope` (matrix with one row per iteration and one column per random
effect of this outcome).
