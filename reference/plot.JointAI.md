# Plot an object object inheriting from class 'JointAI'

Plot an object object inheriting from class 'JointAI'

## Usage

``` r
# S3 method for class 'JointAI'
plot(x, ...)
```

## Arguments

- x:

  object inheriting from class 'JointAI'

- ...:

  currently not used

## Note

Currently, [`plot()`](https://rdrr.io/r/graphics/plot.default.html) can
only be used with (generalized) linear (mixed) models.

## Examples

``` r
mod <- lm_imp(y ~ C1 + C2 + B1, data = wideDF, n.iter = 100)
plot(mod)

```
