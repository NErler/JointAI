# Extract the random effects variance covariance matrix

Returns the posterior mean of the variance-covariance matrix/matrices of
the random effects in a fitted JointAI object.

## Usage

``` r
rd_vcov(object, outcome = NULL, start = NULL, end = NULL, thin = NULL,
  exclude_chains = NULL, mess = TRUE, warn = TRUE)
```

## Arguments

- object:

  object inheriting from class 'JointAI'

- outcome:

  optional; vector of integers giving the indices of the outcomes for
  which the random effects variance-covariance matrix/matrices should be
  returned.

- start:

  the first iteration of interest (see
  [`window.mcmc`](https://rdrr.io/pkg/coda/man/window.mcmc.html))

- end:

  the last iteration of interest (see
  [`window.mcmc`](https://rdrr.io/pkg/coda/man/window.mcmc.html))

- thin:

  thinning interval (integer; see
  [`window.mcmc`](https://rdrr.io/pkg/coda/man/window.mcmc.html)). For
  example, `thin = 1` (default) will keep the MCMC samples from all
  iterations; `thin = 5` would only keep every 5th iteration.

- exclude_chains:

  optional vector of the index numbers of chains that should be excluded

- mess:

  logical; should messages be given? Default is `TRUE`.

- warn:

  logical; should warnings be given? Default is `TRUE`.
