# Ensure object is a (list of) formula(s)

Check if an object is NULL, a formula, or a list of formulas and
(optionally) convert it to a list of formulas. If the input is of
unknown type or if it is a list that has entries that are neither
`formula` nor `NULL`, an error is thrown.

## Usage

``` r
check_formula_list(formula, convert = TRUE)
```

## Arguments

- formula:

  An object expected to be either a formula, a list of formulas, or
  `NULL`.

- convert:

  Logical; if `TRUE`, a single formula is wrapped in a list.

## Value

A named `list` of `formula` (and/or `NULL`) objects, or `NULL`. If
`convert` is `FALSE`, a single formula is returned as-is.

## Details

Internal function; used in many help functions, get_refs, \*\_imp,
predict (2022-02-05)
