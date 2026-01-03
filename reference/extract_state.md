# Return the current state of a 'JointAI' model

Return the current state of a 'JointAI' model

## Usage

``` r
extract_state(object, pattern = paste0("^", c("RinvD", "invD", "tau", "b"),
  "_"))
```

## Arguments

- object:

  an object of class 'JointAI'

- pattern:

  vector of patterns to be matched with the names of the nodes

## Value

A list with one element per chain of the MCMC sampler, containing the
Returns the current state of the MCMC sampler (values of the last
iteration) for the subset of nodes identified based on the pattern the
user has specified.
