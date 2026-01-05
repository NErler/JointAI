# Extract variable names from the left-hand side of a formula

This internal helper function extracts variable names from the left-hand
side (LHS) of a formula or a list of formulas. It supports standard
formulas, survival objects, transformations (e.g., `log(x)`), and
multivariate outcomes (e.g., `cbind(a, b, c)`).

## Usage

``` r
extract_lhs_varnames(formula)
```

## Arguments

- formula:

  A formula object, a list of formulas, or `NULL`.

## Value

A character vector of variable names from the LHS of the formula, or a
list of such vectors if a list of formulas is provided. Returns `NULL`
if the input is `NULL`.

## See also

[`extract_lhs_string()`](https://nerler.github.io/JointAI/reference/extract_lhs_string.md)
