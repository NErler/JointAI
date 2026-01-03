# Extract names of variables from several objects

Version of [`all.vars()`](https://rdrr.io/r/base/allnames.html) that can
handle `formula`s, `lists` of `formulas` and character strings.

## Usage

``` r
all_vars(...)
```

## Arguments

- ...:

  `formula` objects, lists of formulas or character strings that are
  valid variable names (in the sense of `make.vars()`)
