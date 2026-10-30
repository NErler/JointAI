# Transform the covariance matrix of random effects back: D = A D_s A'

Transform the covariance matrix of random effects back: D = A D_s A'

## Usage

``` r
rescale_vcov(MCMC, D_name, A)
```

## Arguments

- MCMC:

  MCMC sample (matrix); the elements of the covariance matrix are the
  columns `<D_name>[i,j]` with `i <= j` (as monitored in JAGS).

- D_name:

  name of the covariance matrix, e.g. `"D_y_id"`.

- A:

  transformation matrix
  ([`ranef_transformation()`](https://nerler.github.io/JointAI/reference/ranef_transformation.md)).

## Value

`MCMC` with the covariance matrix transformed back, in each iteration;
unchanged if the matrix is not (completely) in the sample.
