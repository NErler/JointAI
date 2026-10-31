# Check that the names of dummy variables are unique

The columns of the design matrix are identified by their names. A
variable whose name is equal to the name of a dummy variable of a factor
(e.g., a variable `B11` and the dummy of level `1` of a factor `B1`), or
two factors with dummy variables of the same name, would be merged into
one column. This function stops with an informative error in that case
(#75).

## Usage

``` r
check_dummy_names(refs, varnames)
```

## Arguments

- refs:

  a list with the reference categories of the factors, as returned by
  `get_refs()`; the attribute `"dummies"` of each element holds the
  names of the dummy variables

- varnames:

  a character vector with the names of all variables used in the model

## Value

nothing, but throws an error if the name of a dummy variable is equal to
the name of a variable or of another dummy variable

## Details

used in divide_matrices (2026-10-31)
