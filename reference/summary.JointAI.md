# Summarize the results from an object of class JointAI

Obtain and print the `summary`, (fixed effects) coefficients (`coef`)
and credible interval (`confint`) for an object of class 'JointAI'.

## Usage

``` r
# S3 method for class 'Dmat'
print(x, digits = getOption("digits"),
  scientific = getOption("scipen"), ...)

# S3 method for class 'JointAI'
summary(object, start = NULL, end = NULL, thin = NULL,
  quantiles = c(0.025, 0.975), subset = NULL, exclude_chains = NULL,
  outcome = NULL, missinfo = FALSE, warn = TRUE, mess = TRUE, ...)

# S3 method for class 'summary.JointAI'
print(x, digits = max(3, .Options$digits - 4), ...)

# S3 method for class 'JointAI'
coef(object, start = NULL, end = NULL, thin = NULL,
  subset = NULL, exclude_chains = NULL, warn = TRUE, mess = TRUE, ...)

# S3 method for class 'JointAI'
confint(object, parm = NULL, level = 0.95,
  quantiles = NULL, start = NULL, end = NULL, thin = NULL,
  subset = NULL, exclude_chains = NULL, warn = TRUE, mess = TRUE, ...)

# S3 method for class 'JointAI'
print(x, digits = max(4, getOption("digits") - 4), ...)
```

## Arguments

- x:

  an object of class `summary.JointAI` or `JointAI`

- digits:

  the minimum number of significant digits to be printed in values.

- scientific:

  A penalty to be applied when deciding to print numeric values in fixed
  or exponential notation, by default the value obtained from
  `getOption("scipen")`

- ...:

  currently not used

- object:

  object inheriting from class 'JointAI'

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

- quantiles:

  posterior quantiles

- subset:

  subset of parameters/variables/nodes (columns in the MCMC sample).
  Follows the same principle as the argument `monitor_params` in
  [`*_imp`](https://nerler.github.io/JointAI/reference/model_imp.md).

- exclude_chains:

  optional vector of the index numbers of chains that should be excluded

- outcome:

  optional; vector identifying for which outcomes the summary should be
  given, either by specifying their indices, or their names (LHS of the
  respective model formulas as character string).

- missinfo:

  logical; should information on the number and proportion of missing
  values be included in the summary?

- warn:

  logical; should warnings be given? Default is `TRUE`.

- mess:

  logical; should messages be given? Default is `TRUE`.

- parm:

  same as `subset` (for consistency with `confint` method for other
  types of objects)

- level:

  confidence level (default is 0.95)

## See also

The model fitting functions
[`lm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md),
[`glm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md),
[`clm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md),
[`lme_imp`](https://nerler.github.io/JointAI/reference/model_imp.md),
[`glme_imp`](https://nerler.github.io/JointAI/reference/model_imp.md),
[`survreg_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
and
[`coxph_imp`](https://nerler.github.io/JointAI/reference/model_imp.md),
and the vignette [Parameter
Selection](https://nerler.github.io/JointAI/articles/SelectingParameters.html)
for examples how to specify the parameter `subset`.

## Examples

``` r
if (FALSE) { # \dontrun{
mod1 <- lm_imp(y ~ C1 + C2 + M2, data = wideDF, n.iter = 100)

summary(mod1, missinfo = TRUE)
coef(mod1)
confint(mod1)
} # }
```
