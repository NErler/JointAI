# Identify the data matrix containing a given response variable

Identify the data matrix containing a given response variable

## Usage

``` r
get_resp_mat(resp, Mlvls, outnames)
```

## Arguments

- resp:

  character string; name of the response variable

- Mlvls:

  named vector where the names are all column names of all data
  matrices, and the values are the names of the corresponding data
  matrices

- outnames:

  character vector; names of the columns in the data matrices that
  contain the response variable (or multiple columns in case of a
  survival outcome)

## Value

character string; the name(s) of the data matrix/matrices of the
response variable(s)
