# Cross-correlation of MCMC samples

These functions compute the cross-correlations of the MCMC samples in an
JointAI object via
[`coda::crosscorr()`](https://rdrr.io/pkg/coda/man/crosscorr.html) and
plot them using either the **corrplot** package or
[`coda::crosscorr.plot()`](https://rdrr.io/pkg/coda/man/crosscorr.plot.html).

## Usage

``` r
cross_corr(object, outcome = 1L, start = NULL, end = NULL, thin = NULL)

cross_corr_plot(object, outcome = 1L, start = NULL, end = NULL,
  thin = NULL, type = "corrplot")
```

## Arguments

- object:

  an object of class JointAI

- outcome:

  integer; index of the outcome model for which the correlations should
  be plotted

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

- type:

  character; type of plot to be produced. Either "corrplot" (default) or
  "coda".

## Value

a matrix (or a plot)

## Examples

``` r
fit <- lm_imp(y ~ C1 + C2 + B2, data = wideDF, n.iter = 200)
cross_corr(fit)
#>              (Intercept)           C1           C2        B21      sigma_y
#> (Intercept)  1.000000000 -0.999337698 -0.009232185  0.1058412 -0.004013081
#> C1          -0.999337698  1.000000000  0.006052573 -0.1407318  0.004398230
#> C2          -0.009232185  0.006052573  1.000000000  0.1199271 -0.006365958
#> B21          0.105841151 -0.140731823  0.119927130  1.0000000 -0.010219705
#> sigma_y     -0.004013081  0.004398230 -0.006365958 -0.0102197  1.000000000
cross_corr_plot(fit, type = "coda")
```
