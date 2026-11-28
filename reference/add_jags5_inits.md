# Add initial values for nodes that JAGS \>= 5 cannot initialise

JAGS \>= 5 sets initial values that are not given from the prior (see
[`rjags::jags.model()`](https://rdrr.io/pkg/rjags/man/jags.model.html),
argument `initrep`): for a bounded parameter, it takes the value with
the highest prior density, for an unbounded parameter the mean of many
draws from the prior. For some parameters of JointAI's models, these
values are extreme, and the model cannot be initialised ("Node
inconsistent with parents"):

- The precision of random effects with a truncated gamma prior (see
  [`get_ranef_precision_nodes()`](https://nerler.github.io/JointAI/reference/get_ranef_precision_nodes.md))
  starts close to the lower bound 1e-16; the random effects then start
  at extreme values (e.g., in proportional hazards models or generalised
  linear mixed models).

- The shape parameter of a Weibull survival model (see
  [`get_survreg_shape_nodes()`](https://nerler.github.io/JointAI/reference/get_survreg_shape_nodes.md))
  starts at about 100 (the mean of its prior); the survival time to the
  power of the shape then overflows.

## Usage

``` r
add_jags5_inits(inits, nodes, seed, jags5 = rjags::jags.version() >= "5.0.0")
```

## Arguments

- inits:

  a list with one list of initial values per chain, as obtained from
  `get_initial_values()`

- nodes:

  a named integer vector, as obtained from
  [`get_jags5_init_nodes()`](https://nerler.github.io/JointAI/reference/get_jags5_init_nodes.md):
  per node the number of rows and columns of a precision matrix, or `0L`
  for a single value

- seed:

  an optional seed value, to draw the same values again

- jags5:

  logical; whether the initial values are added (by default with JAGS
  \>= 5)

## Value

`inits`, with an initial value for each node that is not in the initial
values of a chain (see
[`draw_jags5_init()`](https://nerler.github.io/JointAI/reference/draw_jags5_init.md))

## Details

JAGS 4 started these models at values that worked (the random effects at
zero, the shape at about 10), so nothing is changed for JAGS \< 5.

The initial values are drawn per chain from a log-uniform distribution
between 0.5 and 2 (so that the chains start at different values; for a
precision, the variance then lies in the same range). Values the user
supplied for a node are kept.
