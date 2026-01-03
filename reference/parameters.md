# Parameter names of an JointAI object

Returns the names of the parameters/nodes of an object of class
'JointAI' for which a monitor is set.

## Usage

``` r
parameters(object, expand_ranef = FALSE, mess = TRUE, warn = TRUE, ...)
```

## Arguments

- object:

  object inheriting from class 'JointAI'

- expand_ranef:

  logical; should all elements of the random effects vectors/matrices be
  shown separately?

- mess:

  logical; should messages be given? Default is `TRUE`.

- warn:

  logical; should warnings be given? Default is `TRUE`.

- ...:

  currently not used

## Examples

``` r
# (This function does not need MCMC samples to work, so we will set
# n.adapt = 0 and n.iter = 0 to reduce computational time)
mod1 <- lm_imp(y ~ C1 + C2 + M2 + O2 + B2, data = wideDF, n.adapt = 0,
               n.iter = 0, mess = FALSE)
#> Warning: 
#> It is currently not possible to use “contr.poly” for incomplete
#> categorical covariates. I will use “contr.treatment” instead.  You can
#> specify (globally) which types of contrasts are used by changing
#> “options('contrasts')”.

parameters(mod1)
#> 
#> Note: “mod1” does not contain MCMC samples.
#>    outcome outcat     varname     coef
#> 1        y   <NA> (Intercept)  beta[1]
#> 2        y   <NA>          C1  beta[2]
#> 3        y   <NA>          C2  beta[3]
#> 4        y   <NA>         M22  beta[4]
#> 5        y   <NA>         M23  beta[5]
#> 6        y   <NA>         M24  beta[6]
#> 7        y   <NA>         O22  beta[7]
#> 8        y   <NA>         O23  beta[8]
#> 9        y   <NA>         O24  beta[9]
#> 10       y   <NA>         B21 beta[10]
#> 11       y   <NA>        <NA>  sigma_y
```
