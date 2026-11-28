# Cross-correlation of MCMC samples

These functions compute the cross-correlations of the MCMC samples in an
JointAI object via
[`coda::crosscorr()`](https://rdrr.io/pkg/coda/man/crosscorr.html) and
plot them using either the **corrplot** package or
[`coda::crosscorr.plot()`](https://rdrr.io/pkg/coda/man/crosscorr.plot.html).

## Usage

``` r
cross_corr(object, outcome = NULL, start = NULL, end = NULL,
  thin = NULL)

cross_corr_plot(object, outcome = NULL, start = NULL, end = NULL,
  thin = NULL, type = "corrplot")
```

## Arguments

- object:

  an object of class JointAI

- outcome:

  optional; vector identifying the sub-models whose parameters are
  included, either by their indices (in the order of the list of model
  formulas) or their names (LHS of the respective model formula as
  character string). If `NULL` (default), all monitored parameters are
  included. With parameters from several sub-models, the coefficients
  are named `"outcome: variable"`, otherwise by the variable only.

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
#>             (Intercept)          C1            C2         B21       sigma_y
#> (Intercept)  1.00000000 -0.99935973  0.0205291724  0.13256381 -0.0649855279
#> C1          -0.99935973  1.00000000 -0.0252383511 -0.16690200  0.0664606044
#> C2           0.02052917 -0.02523835  1.0000000000  0.18724852 -0.0007680653
#> B21          0.13256381 -0.16690200  0.1872485222  1.00000000 -0.0393446484
#> sigma_y     -0.06498553  0.06646060 -0.0007680653 -0.03934465  1.0000000000
cross_corr_plot(fit, type = "coda")
```
