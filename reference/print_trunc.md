# Print the truncation of a sub-model (used in `list_models()`)

Print the truncation of a sub-model (used in
[`list_models()`](https://nerler.github.io/JointAI/reference/list_models.md))

## Usage

``` r
print_trunc(trunc)
```

## Arguments

- trunc:

  numeric vector of length two with the lower and upper limit of the
  truncation (`NA` if there is no limit), as in the element `trunc` of
  the model information.

## Value

`NULL`, invisibly; called for the printed output.
