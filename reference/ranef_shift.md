# Shift delta of the random effects of one outcome and level

`b = A b_s + delta` with `delta = mu(0) - A mu_s(0)`: the difference
between the means of the random effects on the original and the scaled
scale, evaluated at covariate values 0 (the covariates drop out when the
fixed effects are transformed consistently, so any value would do). On
the original scale, only the constant terms remain; on the scaled scale,
a covariate `w` at 0 has the value `-c_w / s_w`.

## Usage

``` r
ranef_shift(part, A_part, MCMC, rescaled, coefs, scale_pars, data_list)
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
  back
  ([`rescale_coefs()`](https://nerler.github.io/JointAI/reference/rescale_coefs.md)).

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

Matrix with one row per iteration and one column per random effect.
