# Check for empty factor levels

CHECKS if there are empty factor levels in any of the variables used in
the model.

## Usage

``` r
drop_levels(data, allvars, warn = TRUE, mess = NULL)
```

## Arguments

- data:

  a `data.frame`

- allvars:

  a character vector (of all variable names used in the model)

- warn:

  logical, if `TRUE` warnings are printed

## Value

the `data.frame` (unchanged)

## Note

Originally, the function also dropped these levels. Then, I
(accidentally?) had commented out a line so that no check was performed.
Now, only create a warning if there are empty levels, but do not drop
them.

used in model_imp (2020-06-09)
