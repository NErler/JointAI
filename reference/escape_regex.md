# Escape special characters for use in a regular expression

Names of variables and parameters may contain characters with a special
meaning in a regular expression, e.g., `.` in `y.1` and `[` in
`beta[1]`. With this function they only match themselves.

## Usage

``` r
escape_regex(x)
```

## Arguments

- x:

  character vector.

## Value

`x` with a backslash before each special character.
