# Create a new data frame for prediction

Build a `data.frame` for prediction, where one variable varies and all
other variables are set to the reference value (median for continuous
variables).

## Usage

``` r
predDF(object, ...)

# S3 method for class 'JointAI'
predDF(object, vars, length = 100L, ...)

# S3 method for class 'formula'
predDF(object, data, vars, length = 100L, ...)

# S3 method for class 'list'
predDF(object, data, vars, length = 100L, idvar = NULL, ...)
```

## Arguments

- object:

  object inheriting from class 'JointAI'

- ...:

  optional specification of the values used for some (or all) of the
  variables given in `vars`

- vars:

  name of variable that should be varying

- length:

  number of values used in the sequence when `vars` is continuous

- data:

  a `data.frame` containing the original data (more details below)

- idvar:

  optional name of an ID variable

## See also

[`predict.JointAI`](https://nerler.github.io/JointAI/reference/predict.JointAI.md),
[`lme_imp`](https://nerler.github.io/JointAI/reference/model_imp.md),
[`glm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md),
[`lm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)

## Examples

``` r
# fit a JointAI model
mod <- lm_imp(y ~ C1 + C2 + M2, data = wideDF, n.iter = 100)

# generate a data frame with varying "C2" and reference values for all other
# variables in the model
newDF <- predDF(mod, vars = ~ C2)

head(newDF)
#>           y       C1         C2 M2
#> 1 -3.183137 1.434298 -0.9226220  1
#> 2 -3.183137 1.434298 -0.9046136  1
#> 3 -3.183137 1.434298 -0.8866052  1
#> 4 -3.183137 1.434298 -0.8685968  1
#> 5 -3.183137 1.434298 -0.8505885  1
#> 6 -3.183137 1.434298 -0.8325801  1


newDF2 <- predDF(mod, vars = ~ C2 + M2,
                 C2 = seq(-0.5, 0.5, 0.25),
                 M2 = levels(wideDF$M2)[2:3])
newDF2
#>            y       C1    C2 M2
#> 1  -3.183137 1.434298 -0.50  2
#> 2  -3.183137 1.434298 -0.25  2
#> 3  -3.183137 1.434298  0.00  2
#> 4  -3.183137 1.434298  0.25  2
#> 5  -3.183137 1.434298  0.50  2
#> 6  -3.183137 1.434298 -0.50  3
#> 7  -3.183137 1.434298 -0.25  3
#> 8  -3.183137 1.434298  0.00  3
#> 9  -3.183137 1.434298  0.25  3
#> 10 -3.183137 1.434298  0.50  3
```
