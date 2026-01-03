# Replace ":" with "\_" in a string

Cleans up factor levels (or other strings) by replacing ":" with "\_" to
avoid issues with the current implementation of identifying interactions
(which looks for ":" in model terms).

## Usage

``` r
clean_names(string)
```

## Arguments

- string:

  a character string

## Value

the cleaned character string

## Details

used in this file (in convert_variables()) (2020-06-09)
