# Run all data related checks

Wrapper function to check that

- all used variables are present in the `data`

- that the classes of the variables are of a type for which default
  model types are defined

- checks for empty variable levels

- converts binary continuous variables and logical variables to factors

## Usage

``` r
check_data(data, fixed, random, auxvars, timevar, mess, warn)
```

## Arguments

- data:

  a `data.frame`

- fixed:

  a `formula` (or list of formulas)

- random:

  a one-sided `formula` (or list of one-sided formulas)

- auxvars:

  a one-sided `formula`

- timevar:

  a character string (name of the time variable, used in joint models)

- mess:

  logical, if `TRUE` messages are printed

- warn:

  logical, if `TRUE` warnings are printed

## Value

the cleaned `data.frame`

## Details

used in [`model_imp()`](model_imp.md) (2025-09-04)
