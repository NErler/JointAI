# Plot the posterior density from object of class JointAI

The function plots a set of densities (per chain and coefficient) from
the MCMC sample of an object of class "JointAI".

## Usage

``` r
densplot(object, ...)

# S3 method for class 'JointAI'
densplot(object, start = NULL, end = NULL, thin = NULL,
  subset = c(analysis_main = TRUE), outcome = NULL,
  exclude_chains = NULL, vlines = NULL, nrow = NULL, ncol = NULL,
  joined = FALSE, use_ggplot = FALSE, warn = TRUE, mess = TRUE, ...)
```

## Arguments

- object:

  object inheriting from class 'JointAI'

- ...:

  additional parameters passed to
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html)

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

- subset:

  subset of parameters/variables/nodes (columns in the MCMC sample).
  Follows the same principle as the argument `monitor_params` in
  [`*_imp`](model_imp.md).

- outcome:

  optional; vector identifying a subset of sub-models included in the
  output, either by specifying their indices (using the order used in
  the list of model formulas), or their names (LHS of the respective
  model formula as character string)

- exclude_chains:

  optional vector of the index numbers of chains that should be excluded

- vlines:

  list, where each element is a named list of parameters that can be
  passed to
  [`graphics::abline()`](https://rdrr.io/r/graphics/abline.html) to
  create vertical lines. Each of the list elements needs to contain at
  least `v = <x location>` where `<x location>` is a vector of the same
  length as the number of plots (see examples).

- nrow:

  optional; number of rows in the plot layout; automatically chosen if
  unspecified

- ncol:

  optional; number of columns in the plot layout; automatically chosen
  if unspecified

- joined:

  logical; should the chains be combined before plotting?

- use_ggplot:

  logical; Should ggplot be used instead of the base graphics?

- warn:

  logical; should warnings be given? Default is `TRUE`.

- mess:

  logical; should messages be given? Default is `TRUE`.

## See also

The vignette [Parameter
Selection](https://nerler.github.io/JointAI/articles/SelectingParameters.html)
contains some examples how to specify the argument `subset`.

## Examples

``` r
if (FALSE) { # \dontrun{
# fit a JointAI object:
mod <- lm_imp(y ~ C1 + C2 + M1, data = wideDF, n.iter = 100)

# Example 1: basic densityplot
densplot(mod)
densplot(mod, exclude_chains = 2)


# Example 2: use vlines to mark zero
densplot(mod, col = c("darkred", "darkblue", "darkgreen"),
         vlines = list(list(v = rep(0, nrow(summary(mod)$res$y$regcoef)),
                            col = grey(0.8))))


# Example 3: use vlines to visualize posterior mean and 2.5%/97.5% quantiles
res <- rbind(summary(mod)$res$y$regcoef[, c('Mean', '2.5%', '97.5%')],
             summary(mod)$res$y$sigma[, c('Mean', '2.5%', '97.5%'),
             drop = FALSE]
             )
densplot(mod, vlines = list(list(v = res[, "Mean"], lty = 1, lwd = 2),
                            list(v = res[, "2.5%"], lty = 2),
                            list(v = res[, "97.5%"], lty = 2)))


# Example 4: ggplot version
densplot(mod, use_ggplot = TRUE)


# Example 5: change how the ggplot version looks
library(ggplot2)

densplot(mod, use_ggplot = TRUE) +
  xlab("value") +
  theme(legend.position = 'bottom') +
  scale_color_brewer(palette = 'Dark2', name = 'chain')
} # }
```
