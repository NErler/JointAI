# Normalize formula arguments in arglist

Normalize formula arguments in arglist

## Usage

``` r
normalize_formula_args(arglist)
```

## Arguments

- arglist:

  A list containing at least `formula`, `fixed`, and `random` elements.

## Value

The updated `arglist` with formulas converted to lists.

## Note

Helper function used in
[`prep_arglist()`](https://nerler.github.io/JointAI/reference/prep_arglist.md).
