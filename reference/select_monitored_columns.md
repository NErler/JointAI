# Keep the requested elements of nodes that were monitored as a whole

The samples of a node that was monitored as a whole instead of some of
its elements (see
[`get_monitor_nodes()`](https://nerler.github.io/JointAI/reference/get_monitor_nodes.md))
are reduced to the requested elements, in the requested order, at the
position of the node. All other columns stay as they are. The result is
the same as if the elements had been monitored.

## Usage

``` r
select_monitored_columns(mcmc, var_names, monitor_nodes)
```

## Arguments

- mcmc:

  an `mcmc.list` with the samples (one column per element)

- var_names:

  a character vector with the requested names of nodes and elements (as
  given to
  [`get_monitor_nodes()`](https://nerler.github.io/JointAI/reference/get_monitor_nodes.md))

- monitor_nodes:

  a character vector with the names that were given to JAGS, as obtained
  from
  [`get_monitor_nodes()`](https://nerler.github.io/JointAI/reference/get_monitor_nodes.md)

## Value

an `mcmc.list`
