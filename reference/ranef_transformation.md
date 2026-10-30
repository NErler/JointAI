# Transformation matrix A for the random effects of one outcome and level

The random-slope variables enter JAGS as `(z_j - c_j) / s_j`, so
`sum_j b_s,j * (z_j - c_j) / s_j = sum_j (A b_s)_j * z_j` with
`A[j, j] = 1 / s_j` and, in the row of the random intercept,
`A[1, j] = -c_j / s_j`: the centring is the same for all observations of
a group and moves to the random intercept.

## Usage

``` r
ranef_transformation(lvl_info, scale_pars)
```

## Arguments

- lvl_info:

  hierarchical-centring information of one grouping level (element of
  `hc_list$hcvars` of a sub-model).

- scale_pars:

  `data.frame` of scaling parameters (columns `center` and `scale`, one
  row per design-matrix column, named by the column), with centre 0 and
  scale 1 for columns that are not scaled.

## Value

Square matrix, one row and column per random effect.

## Details

Without random intercept, the random-slope variables are not centred
([`get_uncentred_columns()`](https://nerler.github.io/JointAI/reference/get_uncentred_columns.md)),
so that only the scaling is undone here.
