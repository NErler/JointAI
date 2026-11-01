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
current state of the sampler (values of the last iteration) for the
subset of nodes identified based on the pattern the user has specified.

## Examples

``` r
# \donttest{
mod <- lme_imp(y ~ C1 + time + (time | id), data = longDF, n.iter = 100,
               mess = FALSE)

# by default: the random effects and the (inverse) variance parameters
state <- extract_state(mod)
names(state[[1]])
#> [1] "RinvD_y_id" "invD_y_id"  "tau_y"      "b_y_id"    

# only the nodes whose name matches a pattern
extract_state(mod, pattern = "^tau_")
#> [[1]]
#> [[1]]$tau_y
#> [1] 0.0508033
#> 
#> 
#> [[2]]
#> [[2]]$tau_y
#> [1] 0.05117399
#> 
#> 
#> [[3]]
#> [[3]]$tau_y
#> [1] 0.05106452
#> 
#> 
# }
```
