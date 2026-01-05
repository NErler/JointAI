# Split a list of formulas into fixed and random effects parts.

Calls
[`extract_fixef_formula()`](https://nerler.github.io/JointAI/reference/extract_fixef_formula.md)
and
[`extract_ranef_formula()`](https://nerler.github.io/JointAI/reference/extract_ranef_formula.md)
on each formula in a list to create one list of the fixed effects
formulas and one list containing the random effects formulas.

## Usage

``` r
split_formula_list(formula)
```

## Arguments

- formula:

  a `formula` or a `list` of `formula` objects

## Value

A `list` with two elements, `fixed` and `random`, each of which is a
named `list` of `formula` objects (or `NULL`)

## Details

Internal function, used in \*\_imp() (2022-02-06)
