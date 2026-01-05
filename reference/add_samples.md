# Continue sampling from an object of class JointAI

This function continues the sampling from the MCMC chains of an existing
object of class 'JointAI'.  

## Usage

``` r
add_samples(object, n.iter, add = TRUE, thin = NULL,
  monitor_params = NULL, progress.bar = "text", mess = TRUE)
```

## Arguments

- object:

  object inheriting from class 'JointAI'

- n.iter:

  the number of additional iterations of the MCMC chain

- add:

  logical; should the new MCMC samples be added to the existing samples
  (`TRUE`; default) or replace them? If samples are added the arguments
  `monitor_params` and `thin` are ignored.

- thin:

  thinning interval (see
  [`window.mcmc`](https://rdrr.io/pkg/coda/man/window.mcmc.html));
  ignored when `add = TRUE`.

- monitor_params:

  named list or vector specifying which parameters should be monitored.
  For details, see
  [`*_imp`](https://nerler.github.io/JointAI/reference/model_imp.md) and
  the vignette [Parameter
  Selection](https://nerler.github.io/JointAI/articles/SelectingParameters.html).
  Ignored when `add = TRUE`.

- progress.bar:

  character string specifying the type of progress bar. Possible values
  are "text" (default), "gui", and "none" (see `update`). Note: when
  sampling is performed in parallel it is not possible to display a
  progress bar.

- mess:

  logical; should messages be given? Default is `TRUE`.

## See also

[`*_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)

The vignette [Parameter
Selection](https://nerler.github.io/JointAI/articles/SelectingParameters.html)
contains some examples on how to specify the argument `monitor_params`.

## Examples

``` r
# Example 1:
# Run an initial JointAI model:
mod <- lm_imp(y ~ C1 + C2, data = wideDF, n.iter = 100)

# Continue sampling:
mod_add <- add_samples(mod, n.iter = 200, add = TRUE)


# Example 2:
# Continue sampling, but additionally sample imputed values.
# Note: Setting different parameters to monitor than in the original model
# requires add = FALSE.
imps <- add_samples(mod, n.iter = 200, monitor_params = c("imps" = TRUE),
                    add = FALSE)
```
