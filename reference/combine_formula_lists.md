# Combine fixed and random effects formulas

A function to combine nlme-style fixed and random effects formulas into
lme4 style formulas.

## Usage

``` r
combine_formula_lists(fixed, random, warn = TRUE)
```

## Arguments

- fixed:

  a fixed effects formula or list of such formulas

- random:

  a random effects formula (only RHS) or list of such formulas

- warn:

  logical; should the warning(s) be printed

## Details

Internal function. Lists of formulas can be named or unnamed. Uses
[`combine_formulas()`](https://nerler.github.io/JointAI/reference/combine_formulas.md).
