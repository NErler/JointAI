# Get the nodes that JAGS monitors

Temporary, until rjags is fixed: rjags \>= 5 (checked with rjags 5-5 and
5-6) cannot set a monitor on an element of a node whose name contains an
underscore, letters and another underscore (e.g., `D_y_id[1,2]`, the
covariance matrix of the random effects of `y` on the level `id`); it
warns "Failed to set value trace monitor". The cause is in
`parse.varnames()` of rjags, which takes such names for reserved names
(like `"_observed_"`) and does not split them into node and index. The
whole node can be monitored. With rjags \>= 5, such elements are
therefore replaced by their node, and
[`select_monitored_columns()`](https://nerler.github.io/JointAI/reference/select_monitored_columns.md)
keeps the requested elements. Other names (e.g., `beta`,
`M_lvlone[3,2]`) are monitored as they are. Monitoring whole nodes costs
time for large nodes (e.g., the random effects of all subjects), so it
is only done with rjags \>= 5.

## Usage

``` r
get_monitor_nodes(var_names,
  whole_nodes = numeric_version(getNamespaceVersion("rjags")) >= "5.0")
```

## Arguments

- var_names:

  a character vector with the names of the nodes and elements to monitor
  (e.g., `"beta"`, `"D_y_id[1,2]"`)

- whole_nodes:

  logical; whether the affected elements are replaced by their node (by
  default with rjags \>= 5)

## Value

a character vector with the names to give to JAGS: `var_names`, with the
affected elements replaced by the name of their node (each node once) if
`whole_nodes` is `TRUE`, otherwise `var_names`
