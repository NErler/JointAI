# Replace a full with a block-diagonal variance covariance matrix

Check if a full random effects variance covariance matrix is specified
for a single variable. In that case, it is identical to a block-diagonal
matrix. Change the `rd_vcov` specification to `blockdiag` for clarity
(because then the variable name is used in the name of `b`, `D`, `invD`,
...)

## Usage

``` r
check_full_blockdiag(rd_vcov)
```

## Arguments

- rd_vcov:

  a valid random effects variance-covariance structure specification
  (i.e., checked using
  [`expand_rd_vcov_full()`](expand_rd_vcov_full.md))

## Value

a valid random effects variance-covariance structure specification
