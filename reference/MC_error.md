# Calculate and plot the Monte Carlo error

Calculate, print and plot the Monte Carlo error of the samples from a
'JointAI' model, combining the samples from all MCMC chains.

## Usage

``` r
MC_error(x, subset = NULL, exclude_chains = NULL, start = NULL,
  end = NULL, thin = NULL, digits = 2, warn = TRUE, mess = TRUE, ...)

# S3 method for class 'MCElist'
plot(x, data_scale = TRUE, plotpars = NULL,
  ablinepars = list(v = 0.05), minlength = 20, ...)
```

## Arguments

- x:

  object inheriting from class 'JointAI'

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

- digits:

  number of digits for the printed output

- warn:

  logical; should warnings be given? Default is `TRUE`.

- mess:

  logical; should messages be given? Default is `TRUE`.

- ...:

  Arguments passed on to
  [`mcmcse::mcse.mat`](https://rdrr.io/pkg/mcmcse/man/mcse.mat.html)

  `size`

  :   represents the batch size in “`bm`” and the truncation point in
      “`bartlett`” and “`tukey`”. Default is `NULL` which implies that
      an optimal batch size is calculated using the `batchSize`
      function. Can take character values of “`sqroot`” and “`cuberoot`”
      or any numeric value between 1 and n/2. “`sqroot`” means size is
      \\\lfloor n^{1/2} \rfloor\\ and “`cuberoot`” means size is
      \\\lfloor n^{1/3} \rfloor\\.

  `g`

  :   a function such that \\E(g(x))\\ is the quantity of interest. The
      default is `NULL`, which causes the identity function to be used.

  `method`

  :   any of “`bm`”,“`obm`”,“`bartlett`”, “`tukey`”. “`bm`” represents
      batch means estimator, “`obm`” represents overlapping batch means
      estimator with, “`bartlett`” and “`tukey`” represents the
      modified-Bartlett window and the Tukey-Hanning windows for
      spectral variance estimators.

  `r`

  :   The lugsail parameters (`r`) that converts a lag window into its
      lugsail equivalent. Larger values of `r` will typically imply less
      underestimation of “`cov`”, but higher variability of the
      estimator. Default is `r = 3` and `r = 1,2` are also good choices
      although may lead to underestimates of the variance. `r > 5` is
      not recommended.

- data_scale:

  logical; show the Monte Carlo error of the sample transformed back to
  the scale of the data (`TRUE`) or on the sampling scale (this requires
  the argument `keep_scaled_mcmc = TRUE` to be set when fitting the
  model)

- plotpars:

  optional; list of parameters passed to
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html)

- ablinepars:

  optional; list of parameters passed to
  [`abline()`](https://rdrr.io/r/graphics/abline.html)

- minlength:

  number of characters the variable names are abbreviated to

## Value

An object of class `MCElist` with elements `unscaled`, `scaled` and
`digits`. The first two are matrices with columns `est` (posterior
mean), `MCSE` (Monte Carlo error), `SD` (posterior standard deviation)
and `MCSE/SD` (Monte Carlo error divided by post. standard deviation.)

## Functions

- `plot(MCElist)`: plot Monte Carlo error

## Note

Lesaffre & Lawson (2012; p. 195) suggest the Monte Carlo error of a
parameter should not be more than 5% of the posterior standard deviation
of this parameter (i.e., \\MCSE/SD \le 0.05\\).

**Long variable names:**  
The default plot margins may not be wide enough when variable names are
longer than a few characters. The plot margin can be adjusted (globally)
using the argument `"mar"` in
[`par`](https://rdrr.io/r/graphics/par.html).

## References

Lesaffre, E., & Lawson, A. B. (2012). *Bayesian Biostatistics*. John
Wiley & Sons.

## See also

The vignette [Parameter
Selection](https://nerler.github.io/JointAI/articles/SelectingParameters.html)
provides some examples how to specify the argument `subset`.

## Examples

``` r
if (FALSE) { # \dontrun{

mod <- lm_imp(y ~ C1 + C2 + M2, data = wideDF, n.iter = 100)

MC_error(mod)

plot(MC_error(mod), ablinepars = list(lty = 2),
     plotpars = list(pch = 19, col = 'blue'))
} # }
```
