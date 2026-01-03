# Specify reference categories for all categorical covariates in the model

The function is a helper function that asks questions and, depending on
the answers given by the user, returns the input for the argument
`refcats` in the main analysis functions [`*_imp`](model_imp.md).

## Usage

``` r
set_refcat(data, formula, covars, auxvars = NULL)
```

## Arguments

- data:

  a `data.frame`

- formula:

  optional; model formula or a list of formulas (used to select subset
  of relevant columns of `data`)

- covars:

  optional; vector containing the names of relevant columns of `data`

- auxvars:

  optional; formula containing the names of relevant columns of `data`
  that should be considered additionally to the columns occurring in the
  `formula`

## Details

The arguments `formula`, `covars` and `auxvars` can be used to specify a
subset of the `data` to be considered. If non of these arguments is
specified, all variables in `data` will be considered.

## Examples

``` r
if (FALSE) { # \dontrun{
# Example 1: set reference categories for the whole dataset and choose
# answer option 3:
set_refcat(data = NHANES)
3

# insert the returned string as argument refcats
mod1 <- lm_imp(SBP ~ age + race + creat + educ, data = NHANES,
               refcats = 'largest')

# Example 2:
# specify a model formula
fmla <- SBP ~ age + gender + race + bili + smoke + alc

# write the output of set_refcat to an object
ref_mod2 <- set_refcat(data = NHANES, formula = fmla)
4
2
5
1
1

# enter the output in the model specification
mod2 <- lm_imp(formula = fmla, data = NHANES, refcats = ref_mod2,
               n.adapt = 0)
} # }
```
