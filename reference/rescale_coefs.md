# Transform regression coefficients back to the original scale

In JAGS, a covariate `x` enters a linear predictor as
`(x - center) / scale`, with coefficient `beta_s`. On the original
scale:

- coefficient of a covariate: `beta = beta_s / scale`

- intercept: `beta0 = beta0_s - sum(beta_s * center / scale)`, summing
  over all covariate coefficients of the same linear predictor.

## Usage

``` r
rescale_coefs(MCMC, coefs, scale_pars, info_list, data_list)
```

## Arguments

- MCMC:

  MCMC sample of one chain (`mcmc` object or matrix), on the scale used
  in JAGS.

- coefs:

  `data.frame` with one row per regression coefficient
  (`do.call(rbind, get_coef_names(info_list))`).

- scale_pars:

  `data.frame` of scaling parameters (columns `center` and `scale`, one
  row per design-matrix column, named by the column), as in
  [`rescale()`](https://nerler.github.io/JointAI/reference/rescale.md),
  but without missing values (centre 0 and scale 1 for columns that are
  not scaled).

- info_list:

  list with the model info of each sub-model.

- data_list:

  data list passed to JAGS (for the names of design-matrix columns).

## Value

Matrix with the same columns as `MCMC`; the regression coefficients,
thresholds and coefficients of the baseline hazard are transformed back,
all other parameters are unchanged.

## Details

Models without intercept have other parameters that take the role of the
intercept and are shifted in the same way: the thresholds of ordinal
models (`gamma_<y>[k]`; with the non-proportional effects of category
`k`) and the coefficients of the baseline hazard of proportional hazards
and joint models (`beta_Bh0_<y>`; all by the same amount, because the
rows of the B-spline basis sum to 1).

Cross-level interactions in the mean of a random slope (hierarchical
centring; e.g. `C1:time` with `(time | id)`) enter JAGS as the product
of the separately scaled variables `w` (higher level) and `z`
(random-slope variable): `(w - c_w) / s_w * (z - c_z) / s_z`. The
coefficient is divided by `s_w * s_z`, the coefficients of `w` and `z`
change by `-beta_s * c_z / (s_w * s_z)` and
`-beta_s * c_w / (s_w * s_z)`, and the intercept by
`+beta_s * c_w * c_z / (s_w * s_z)`.

A linear predictor is identified by the outcome and, for models with
category-specific coefficients (e.g. multinomial models), the category
(`coefs$outcat`; `NA` otherwise). All matching is done by name:
parameters by their name in `MCMC` (`coefs$coef`), scaling parameters by
the name of the design-matrix column (`coefs$varname`).
