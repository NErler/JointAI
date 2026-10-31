# Obtain a summary of the missing values involved in an object of class JointAI

This function returns the number and proportion of complete cases, and
of missing values per variable, in the data used in the model,
separately per level of the data.

## Usage

``` r
get_missinfo(object)
```

## Arguments

- object:

  object inheriting from class JointAI

## Value

A list with two elements:

- `complete_cases`:

  a `data.frame` with one row per level and columns `#` (number of
  complete cases) and `%` (proportion of complete cases in percent);

- `miss_list`:

  a list with one `data.frame` per level, with one row per variable and
  columns `# NA` (number of missing values) and `% NA` (proportion of
  missing values in percent).

In multi-level settings, the `data.frame`s have an additional column
`level`.

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
