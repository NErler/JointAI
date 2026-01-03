# Check classes of all variables used in the model

Runs a check that all variables that are used in the model are of a
known class (numeric, ordered, factor, logical, integer) so that
type-appropriate models can be specified. Note: This function does not
check the type of grouping variables, which may be character strings.

## Usage

``` r
check_classes(data, fixed = NULL, random = NULL, auxvars = NULL,
  timevar = NULL, mess = TRUE)
```

## Arguments

- data:

  a `data.frame`

- fixed:

  a `formula`

- random:

  a `formula`

- auxvars:

  a one-sided `formula`

- timevar:

  a character string (name of the time variable, used in joint models)

- mess:

  logical, if `TRUE` messages are printed

## Value

nothing, but throws an error if a variable is of an unknown class

## Details

used in model_imp (2020-06-09)
