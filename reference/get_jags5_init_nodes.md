# Get the nodes that get initial values from JointAI with JAGS \>= 5

Get the nodes that get initial values from JointAI with JAGS \>= 5

## Usage

``` r
get_jags5_init_nodes(info_list)
```

## Arguments

- info_list:

  a list with the information on the sub-models, as obtained from
  `get_model_info()`

## Value

a named integer vector, as obtained from
[`get_ranef_precision_nodes()`](https://nerler.github.io/JointAI/reference/get_ranef_precision_nodes.md)
and
[`get_survreg_shape_nodes()`](https://nerler.github.io/JointAI/reference/get_survreg_shape_nodes.md):
the number of rows and columns of a precision matrix, or `0L` for a
single value
