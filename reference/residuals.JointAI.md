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

  type of residuals: `"deviance"`, `"response"`, `"working"`

- warn:

  logical; should warnings be given? Default is `TRUE`.

- ...:

  currently not used

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
summary(residuals(mod, type = 'response')[[1]])
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>  0.1469  0.1469  0.1469  0.1469  0.1469  0.1469 
summary(residuals(mod, type = 'working')[[1]])
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>   1.172   1.172   1.172   1.172   1.172   1.172 

```
