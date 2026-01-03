# Gelman-Rubin criterion for convergence

Calculates the Gelman-Rubin criterion for convergence (uses
[`gelman.diag`](https://rdrr.io/pkg/coda/man/gelman.diag.html) from
package **coda**).

## Usage

``` r
GR_crit(object, confidence = 0.95, transform = FALSE, autoburnin = TRUE,
  multivariate = TRUE, subset = NULL, exclude_chains = NULL,
  start = NULL, end = NULL, thin = NULL, warn = TRUE, mess = TRUE,
  ...)
```

## Arguments

- object:

  object inheriting from class 'JointAI'

- confidence:

  the coverage probability of the confidence interval for the potential
  scale reduction factor

- transform:

  a logical flag indicating whether variables in `x` should be
  transformed to improve the normality of the distribution. If set to
  TRUE, a log transform or logit transform, as appropriate, will be
  applied.

- autoburnin:

  a logical flag indicating whether only the second half of the series
  should be used in the computation. If set to TRUE (default) and
  `start(x)` is less than `end(x)/2` then start of series will be
  adjusted so that only second half of series is used.

- multivariate:

  a logical flag indicating whether the multivariate potential scale
  reduction factor should be calculated for multivariate chains

- subset:

  subset of parameters/variables/nodes (columns in the MCMC sample).
  Follows the same principle as the argument `monitor_params` in
  [`*_imp`](model_imp.md).

- exclude_chains:

  optional vector of the index numbers of chains that should be excluded

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

- warn:

  logical; should warnings be given? Default is `TRUE`.

- mess:

  logical; should messages be given? Default is `TRUE`.

- ...:

  currently not used

## References

Gelman, A and Rubin, DB (1992) Inference from iterative simulation using
multiple sequences, *Statistical Science*, **7**, 457-511.

Brooks, SP. and Gelman, A. (1998) General methods for monitoring
convergence of iterative simulations. *Journal of Computational and
Graphical Statistics*, **7**, 434-455.

## See also

The vignette [Parameter
Selection](https://nerler.github.io/JointAI/articles/SelectingParameters.html)
contains some examples how to specify the argument `subset`.

## Examples

``` r
mod1 <- lm_imp(y ~ C1 + C2 + M2, data = wideDF, n.iter = 100)
GR_crit(mod1)
#> Potential scale reduction factors:
#> 
#>             Point est. Upper C.I.
#> (Intercept)      1.001      1.006
#> C1               1.002      1.006
#> C2               1.009      1.027
#> M22              1.002      1.018
#> M23              0.998      0.999
#> M24              1.002      1.015
#> sigma_y          1.013      1.055
#> 
#> Multivariate psrf
#> 
#> 1.02


```
