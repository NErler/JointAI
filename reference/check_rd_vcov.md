# Check / create the random effects variance-covariance matrix specification

Check / create the random effects variance-covariance matrix
specification

## Usage

``` r
check_rd_vcov(rd_vcov, nranef)
```

## Arguments

- rd_vcov:

  variance covariance specification provided by the user

- nranef:

  list by level with named vectors of number of random effects per
  variable (obtained by
  [`get_nranef()`](https://nerler.github.io/JointAI/reference/get_nranef.md))
