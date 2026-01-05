# Remove grouping part from (random effects) formula

Removes the part after (and including) the pipe symbol (`|`) in a
formula.

## Usage

``` r
remove_formula_grouping(formula)
```

## Arguments

- formula:

  A `formula` object (NOT a list of formulas)

## Value

A list of one-sided `formula` objects without the grouping part, split
by grouping variable

## See also

[`remove_grouping()`](https://nerler.github.io/JointAI/reference/remove_grouping.md)
