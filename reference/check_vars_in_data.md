# Check that all variables in formulas are in the data

Check that all variables in formulas are in the data

## Usage

``` r
check_vars_in_data(datanames, fixed = NULL, random = NULL,
  auxvars = NULL, timevar = NULL)
```

## Arguments

- datanames:

  a character vector (of all variable names in the data)

- fixed:

  the fixed effects formula (or list of formulas)

- random:

  the random effects formula (or list of formulas)

- auxvars:

  one-sided formula of auxiliary variables

- timevar:

  a character string (name of the time variable, used in joint models)

## Value

nothing, but throws an error if a variable is missing
