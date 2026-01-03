# Obtain a summary of the missing values involved in an object of class JointAI

This function returns a `data.frame` or a `list` of `data.frame`s per
grouping level. Each of the `data.frames` has columns `variable`, `#NA`
(number of missing values) and `%NA` (proportion of missing values in
percent).

## Usage

``` r
get_missinfo(object)
```

## Arguments

- object:

  object inheriting from class JointAI

## Examples

``` r
mod <-  lm_imp(y ~ C1 + B2 + C2, data = wideDF, n.iter = 100)
get_missinfo(mod)
#> $complete_cases
#>         #  %
#> lvlone 77 77
#> 
#> $miss_list
#> $miss_list$lvlone
#>    # NA % NA
#> y     0    0
#> C1    0    0
#> C2    4    4
#> B2   20   20
#> 
#> 

```
