# Parts of the names of parameters in the MCMC sample

A parameter is the whole node (`"alpha"`), or one or more of its
elements: `"alpha[3]"`, `"alpha[2:4]"`, `"b_y_id[5,1:2]"`.

- `par_node()`: the name of the node (`"alpha"`, `"b_y_id"`).

- `par_index_text()`: the text between the brackets, without
  interpreting it (`"3"`, `"2:4"`, `"5,1:2"`).

- `is_node_element()`: is it an element of the given node? This does not
  include the whole node itself, or nodes with a longer name
  (`"alpha2[3]"`).

## Usage

``` r
par_node(x)

par_index_text(x)

is_node_element(x, node)
```

## Arguments

- x:

  character vector of parameter names.

- node:

  character string; name of the node.

## Value

`par_node()`: character vector, `x` up to the first `"["`.
`par_index_text()`: character vector, the text between the first `"["`
and the last `"]"`; a name without index is returned unchanged.
`is_node_element()`: logical vector.
