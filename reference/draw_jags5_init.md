# Draw an initial value for a node (JAGS \>= 5)

Draw an initial value for a node (JAGS \>= 5)

## Usage

``` r
draw_jags5_init(size)
```

## Arguments

- size:

  the number of rows and columns of a precision matrix, or `0L` for a
  single value (see
  [`get_jags5_init_nodes()`](https://nerler.github.io/JointAI/reference/get_jags5_init_nodes.md))

## Value

a single value, or, for `size > 0`, a matrix with the values on the
diagonal and `NA` elsewhere (these elements are data or not used); the
values are drawn from a log-uniform distribution between 0.5 and 2
