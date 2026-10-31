# Monte Carlo error of each column of an MCMC sample

Used by
[`MC_error()`](https://nerler.github.io/JointAI/reference/MC_error.md),
for the sample on the data scale and on the scale used in JAGS.

## Usage

``` r
mce_matrix(mcmc, names, ...)
```

## Arguments

- mcmc:

  matrix of MCMC samples (all chains combined), one column per node.

- names:

  character vector; names of the nodes (as printed), used as row names.

- ...:

  optional arguments passed to
  [`mcmcse::mcse()`](https://rdrr.io/pkg/mcmcse/man/mcse.html).

## Value

Matrix with one row per node and columns `est` (posterior mean), `MCSE`
(Monte Carlo error), `SD` (posterior standard deviation) and `MCSE/SD`.
If [`mcmcse::mcse()`](https://rdrr.io/pkg/mcmcse/man/mcse.html) fails
for a node, `est` and `MCSE` are `NA`.
