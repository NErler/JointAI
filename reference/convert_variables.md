# Convert variables

Cleans up the data by

- changing `NaN` to `NA`

- converting continuous variables with just two values to factor

- converting logical variables to a factor

- cleaning factor labels (using
  [`make.names()`](https://rdrr.io/r/base/make.names.html))

## Usage

``` r
convert_variables(data, allvars, mess = TRUE)
```

## Arguments

- data:

  a `data.frame`

- allvars:

  a character vector of the relevant variables in `data`

- mess:

  logical, if `TRUE` messages are printed

## Value

the cleaned `data.frame`

## Details

used in model_imp (2025-09-07)
