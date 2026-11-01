# Extract residuals from an object of class JointAI

Extract residuals from an object of class JointAI

## Usage

``` r
# S3 method for class 'JointAI'
residuals(object, type = c("working", "pearson",
  "response"), warn = TRUE, ...)
```

## Arguments

- object:

  object inheriting from class 'JointAI'

- type:

  type of residuals: `"working"` (default), `"pearson"` or `"response"`

- warn:

  logical; should warnings be given? Default is `TRUE`.

- ...:

  currently not used

## Value

A numeric vector of residuals, or, for models with more than one model
formula, a list with one such vector per outcome.

## Note

- For mixed models residuals are currently calculated using the fixed
  effects only.

- For ordinal (mixed) models and parametric survival models only
  `type = "response"` is available.

- For Cox proportional hazards models residuals are not yet implemented.

## Examples

``` r
mod <- glm_imp(B1 ~ C1 + C2 + O1, data = wideDF, n.iter = 100,
               family = binomial(), mess = FALSE)
summary(residuals(mod, type = 'response'))
#>     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      NAs 
#> -0.89817  0.08904  0.16999 -0.01056  0.23780  0.40613        4 
summary(residuals(mod, type = 'working'))
#>     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.      NAs 
#> -9.82016  1.09776  1.20481 -0.05372  1.31209  1.68388        4 

```
