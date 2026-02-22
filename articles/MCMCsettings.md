# MCMC Settings

In **JointAI**, models are estimated in the Bayesian framework, using
MCMC ([Markov Chain Monte
Carlo](https://en.wikipedia.org/wiki/Markov_chain_Monte_Carlo))
sampling. The sampling is done by the software
[JAGS](https://mcmc-jags.sourceforge.io/) (“Just Another Gibbs
Sampler”), which performs
[Gibbs](https://en.wikipedia.org/wiki/Gibbs_sampling) sampling.
**JointAI** pre-processes the data to get it into a form that can be
passed to JAGS and writes the JAGS model. The R package
[**rjags**](https://CRAN.R-project.org/package=rjags) is used as an
interface to JAGS.

This vignette describes how to specify the arguments in the main
functions that control MCMC related settings. To learn more about how to
specify the other arguments in **JointAI** models or the theoretical
background of the statistical approach, check out the vignettes [*Model
Specification*](https://nerler.github.io/JointAI/articles/ModelSpecification.html)
and
[*TheoreticalBackground*](https://nerler.github.io/JointAI/articles/TheoreticalBackground.html).

In this vignette, we use the
[NHANES](https://nerler.github.io/JointAI/reference/NHANES.html) data
for examples in cross-sectional data and the dataset
[simLong](https://nerler.github.io/JointAI/reference/simLong.html) for
examples in longitudinal data. For more info on these datasets, check
out the vignette [*Visualizing Incomplete
Data*](https://nerler.github.io/JointAI/articles/VisualizingIncompleteData.html),
in which the distributions of variables and missing values in both sets
is explored.

**Note:**  
In several examples we use `progress.bar = 'none'` which prevents
printing of the progress of the MCMC sampling, since this would result
in lengthy output in the vignette.

## MCMC related parameters in **JointAI**

The main functions
[`*_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)
have a number of arguments that specify settings for the MCMC sampling:

- `n.chains`: number of MCMC chains
- `n.adapt`: number of iterations in the adaptive phase
- `n.iter`: number of iterations in the sampling phase
- `thin`: thinning degree
- `monitor_params`: parameters/nodes to be monitored
- `seed`: optional seed value for reproducibility
- `inits`: initial values

And some other parameters passed to functions from **rjags**:

- `quiet`: should printing of information be suppressed?
- `progress.bar`: type of progress bar

## Chains and Iterations

In MCMC sampling, values are drawn from a probability distribution. The
distribution of the current value is drawn from depends on the
previously drawn value (but not on values before that). Values, thus,
form a chain. Once the chain has converged, its elements can be seen as
a sample from the target posterior distribution.

### Number of chains

To evaluate the convergence of MCMC chains it is helpful to create
multiple chains that have different starting values. The argument
`n.chains` selects the number of chains (by default, `n.chains = 3`).

For calculating the model summary, multiple chains are merged.

### Adaptive phase

JAGS has an adaptive mode, in which samplers are optimized (for example
the step size is adjusted). Samples obtained during the adaptive mode do
not form a Markov chain and are discarded. The argument `n.adapt`
controls the length of this adaptive phase.

The default value for `n.adapt` is 100, which works well in many of the
examples considered here. Complex models may require longer adaptive
phases. If the adaptive phase is not sufficient for JAGS to optimize the
samplers, a warning message will be printed (see example below).

### Sampling iterations

`n.iter` specifies the number of iterations in the sampling phase, i.e.,
the length of the MCMC chain. How many samples are required to reach
convergence and to have sufficient precision depends on the complexity
of data and model, and may range from as few as 100 to several million.

#### Side note: How to evaluate convergence?

Convergence can, for instance, be evaluated visually using a
[`traceplot()`](https://nerler.github.io/JointAI/reference/traceplot.html)
or using the Gelman-Rubin diagnostic criterion[¹](#fn1) (implemented in
[`GR_crit()`](https://nerler.github.io/JointAI/reference/GR_crit.html),
but also returned with the model summary). The latter compares within
and between chain variability and requires the JointAI object to have at
least two chains.

#### Side note: How to check precision?

The precision of the MCMC sample can be checked with the function
[`MC_error()`](https://nerler.github.io/JointAI/reference/MC_error.html).
It calculates the Monte Carlo error (the error that is made since the
sample is finite) and compares it to the standard deviation of the
posterior sample. A rule of thumb is that the Monte Carlo error should
not be more than 5% of the standard deviation.[²](#fn2)

### Thinning

In settings with high autocorrelation, i.e., there are no large jumps in
the chain but sampled values are always close to the previous value, it
may take many iterations before a sample is created that sufficiently
represents the whole range of the posterior distribution.

Processing of such long chains can be slow and take a lot of memory. The
parameter `thin` allows the user to specify if and how much the MCMC
chains should be thinned out before storing them. By default `thin = 1`
is used, which corresponds to keeping all values. A value `thin = 10`
would result in keeping every 10th value and discarding all other
values.

### Examples

#### Default settings

`n.adapt = 100` and `thin = 1` with 100 sampling iterations

``` r
mod1 <- lm_imp(SBP ~ alc, data = NHANES, n.iter = 100, progress.bar = 'none')
```

The relevant part of the model summary (obtained with
[`summary()`](https://nerler.github.io/JointAI/reference/summary.JointAI.html))
shows that the first 100 iterations (adaptive phase) were discarded, and
the 100 iterations that follow form the posterior sample. Thinning was
set to 1 and there are 3 chains.

    #> [...]
    #> MCMC settings:
    #> Iterations = 101:200
    #> Sample size per chain = 100 
    #> Thinning interval = 1 
    #> Number of chains = 3

#### Insufficient adaptation phase

``` r
mod2 <- lm_imp(
  SBP ~ alc,
  data = NHANES,
  n.adapt = 10,
  n.iter = 100,
  progress.bar = 'none'
)
#> Warning in rjags::jags.model(file = modelfile, data = data_list, inits = inits, : Adaptation
#> incomplete
#> NOTE: Stopping adaptation
```

Specifying `n.adapt = 10` results in a warning message. The relevant
part of the model summary from the resulting model is:

    #> [...]
    #> MCMC settings:
    #> Iterations = 11:110
    #> Sample size per chain = 100 
    #> Thinning interval = 1 
    #> Number of chains = 3

#### Thinning

``` r
mod3 <- lm_imp(
  SBP ~ alc,
  data = NHANES,
  n.iter = 500,
  thin = 10,
  progress.bar = 'none'
)
```

Here, iterations 110 until 600 are used in the output, but due to
thinning interval of ten, the resulting MCMC chains contain only 50
samples instead of 500, that is, the samples from iteration 110, 120,
130, …

    #> [...]
    #> MCMC settings:
    #> Iterations = 110:600
    #> Sample size per chain = 49 
    #> Thinning interval = 10 
    #> Number of chains = 3

## Parameters to follow

JAGS only saves the values of MCMC chains for those nodes/parameters for
which the user has specified that they should be monitored. This is also
the case in **JointAI**.

#### What are nodes?

Nodes are variables in the Bayesian framework, i.e., everything observed
or unobserved. This includes the data and parameters that are estimated,
but also missing values in the data or parts of the data that are
generally unobserved, such as random effects or latent class indicators.

### Specifying which nodes should be monitored

For this purpose, the main analysis functions `*_imp` have an argument
`monitor_params`.

For details, explanation and examples see the vignette [*Parameter
Selection*](https://nerler.github.io/JointAI/articles/SelectingParameters.html).

## Initial values

Initial values are the starting point for the MCMC sampler. Setting good
initial values, i.e., initial values that are likely under the posterior
distribution, can speed up convergence. By default, the argument
`inits = NULL`, which means that initial values for the nodes are
generated by JAGS. **JointAI** only sets the initial values for the
random number generators to allow reproducibility of the results.

The argument `seed` allows the specification of a seed value with which
the starting values of the random number generator can be reproduced.

### User-specified initial values

It is possible to supply initial values directly as

- a list or
- a function.

Initial values can be specified for every unobserved node, that is,
parameters and missing values, but it is possible to only specify
initial values for a subset of nodes.

Unless the user-specified initial values contain initial values for the
random number generator (named `.RNG.name` and `.RNG.seed`), **JointAI**
will add these to the initial values. This is necessary for
reproducibility of the results but also when the MCMC chains are sampled
in parallel.

#### Initial values in a list of lists

A list containing initial values should have the same length as the
number of chains, where each element is a named list of initial values.
Initial values should differ between the chains.

For example, to create initial values for the parameter vector `beta`
and the precision parameter `tau_SBP` for three chains:

``` r
init_list <- lapply(1:3, function(i) {
  list(beta = rnorm(4), tau_SBP = rgamma(1, 1, 1))
})

init_list
#> [[1]]
#> [[1]]$beta
#> [1] -0.005571287  0.621552721  1.148411606 -1.821817661
#> 
#> [[1]]$tau_SBP
#> [1] 0.3404071
#> 
#> 
#> [[2]]
#> [[2]]$beta
#> [1] -1.5247442  1.9694248  0.4631747 -0.8561524
#> 
#> [[2]]$tau_SBP
#> [1] 1.063226
#> 
#> 
#> [[3]]
#> [[3]]$beta
#> [1]  0.07580396  0.49176144 -0.75354071  0.34902735
#> 
#> [[3]]$tau_SBP
#> [1] 0.3864889
```

The list is then passed to the argument `inits`. The amended version of
the user provided lists of initial values are stored in the JointAI
object:

``` r
mod4a <- lm_imp(
  SBP ~ gender + age + WC,
  data = NHANES,
  progress.bar = 'none',
  inits = init_list
)

mod4a$mcmc_settings$inits
#> [[1]]
#> [[1]]$beta
#> [1] -0.005571287  0.621552721  1.148411606 -1.821817661
#> 
#> [[1]]$tau_SBP
#> [1] 0.3404071
#> 
#> [[1]]$.RNG.name
#> [1] "base::Marsaglia-Multicarry"
#> 
#> [[1]]$.RNG.seed
#> [1] 98229
#> 
#> 
#> [[2]]
#> [[2]]$beta
#> [1] -1.5247442  1.9694248  0.4631747 -0.8561524
#> 
#> [[2]]$tau_SBP
#> [1] 1.063226
#> 
#> [[2]]$.RNG.name
#> [1] "base::Super-Duper"
#> 
#> [[2]]$.RNG.seed
#> [1] 25506
#> 
#> 
#> [[3]]
#> [[3]]$beta
#> [1]  0.07580396  0.49176144 -0.75354071  0.34902735
#> 
#> [[3]]$tau_SBP
#> [1] 0.3864889
#> 
#> [[3]]$.RNG.name
#> [1] "base::Wichmann-Hill"
#> 
#> [[3]]$.RNG.seed
#> [1] 20660
```

#### Initial values as a function

Initial values can be specified by a function. The function should
either take no arguments or a single argument called `chain`, and return
a named list that supplies values for one chain.

For example, to create initial values for the parameter vectors `beta`
and `alpha`:

``` r
inits_fun <- function() {
  list(beta = rnorm(4), alpha = rnorm(3))
}

inits_fun()
#> $beta
#> [1]  0.4681544  0.3629513 -1.3045435  0.7377763
#> 
#> $alpha
#> [1]  1.8885049 -0.0974451 -0.9358474


mod4b <- lm_imp(
  SBP ~ gender + age + WC,
  data = NHANES,
  progress.bar = 'none',
  inits = inits_fun
)

mod4b$mcmc_settings$inits
#> [[1]]
#> [[1]]$beta
#> [1] -0.8267890 -1.5123997  0.9353632  0.1764886
#> 
#> [[1]]$alpha
#> [1] 0.2436855 1.6235489 0.1120381
#> 
#> [[1]]$.RNG.name
#> [1] "base::Wichmann-Hill"
#> 
#> [[1]]$.RNG.seed
#> [1] 30762
#> 
#> 
#> [[2]]
#> [[2]]$beta
#> [1] -0.1339970 -1.9100875 -0.2792372 -0.3134460
#> 
#> [[2]]$alpha
#> [1]  1.06730788  0.07003485 -0.63912332
#> 
#> [[2]]$.RNG.name
#> [1] "base::Marsaglia-Multicarry"
#> 
#> [[2]]$.RNG.seed
#> [1] 14316
#> 
#> 
#> [[3]]
#> [[3]]$beta
#> [1] -0.0499649 -0.2514834  0.4447971  2.7554176
#> 
#> [[3]]$alpha
#> [1] 0.04653138 0.57770907 0.11819487
#> 
#> [[3]]$.RNG.name
#> [1] "base::Mersenne-Twister"
#> 
#> [[3]]$.RNG.seed
#> [1] 54759
```

When a function is supplied, the function will be evaluated once per
chain and the resulting list is stored.

### For which nodes can initial values be specified?

Initial values can be specified for all unobserved stochastic nodes,
i.e., parameters or unobserved data for which a distribution is
specified in the JAGS model.

Initial values have to be supplied in the format the parameter or
unobserved value is used in the JAGS model.

To find out which nodes there are in a model, the function
[`coef()`](https://rdrr.io/r/stats/coef.html) from package **rjags** can
be used on a JAGS model object. It returns a list with the current
values of the MCMC chains, by default the first chain. Elements of the
initial values should have the same structure as the elements in this
list.

**Example:  
** We are using a longitudinal model and the `simLong` data in this
example. The output is abbreviated to show the relevant parts.

``` r
mod4c <- lme_imp(
  bmi ~ time + HEIGHT_M + hc + SMOKE,
  random = ~ time | ID,
  data = simLong,
  no_model = 'time',
  progress.bar = 'none'
)

str(coef(mod4c$model))
#> List of 15
#>  $ M_ID        : num [1:200, 1:5] NA NA NA NA NA 1 NA NA NA NA ...
#>  $ M_lvlone    : num [1:2400, 1:3] NA NA 0 0 NA NA NA NA NA NA ...
#>  $ RinvD_bmi_ID: num [1:2, 1:2] 0.836 NA NA 0.114
#>  $ alpha       : num [1:7] 45.5303 0.1008 0.0652 0.0802 3.8216 ...
#>  $ b_bmi_ID    : num [1:200, 1:2] 16 17 15.4 15.6 17.2 ...
#>  $ b_hc_ID     : num [1:200, 1] 44.3 45.2 47.2 47.4 45.7 ...
#>  $ beta        : num [1:6] 16.4886 0.1199 0.1475 -0.0524 -1.3963 ...
#>  $ delta_SMOKE : num -1.53
#>  $ gamma_SMOKE : num [1:2] -1.2 NA
#>  $ invD_bmi_ID : num [1:2, 1:2] 1.69 -1.87 -1.87 8.16
#>  $ invD_hc_ID  : num [1, 1] 0.637
#>  $ mu_b_bmi_ID : num [1:200, 1:2] NA NA NA NA NA NA NA NA NA NA ...
#>  $ tau_HEIGHT_M: num 0.0195
#>  $ tau_bmi     : num 4.19
#>  $ tau_hc      : num 0.232
```

`M_ID` and `M_lvlone` are design matrices containing the the parts of
the variables that belong to a given level of the hierarchy. In this
example, `M_ID` contains all the subject specific variables, `M_lvlone`
the time-varying variables. In **JointAI**, design matrices are always
named `M_<level>`, and `lvlone` refers to the lowest level, the level
for which there is no grouping variable.

The first eight rows of `M_ID` in the data that is passed to JAGS (which
is stored in `data_list` in a JointAI object) are:

``` r
head(mod4c$data_list$M_ID, 8)
```

    #>       SMOKE HEIGHT_M (Intercept) SMOKEsmoked until[...] SMOKEcontin[...]
    #> 1.1       1 172.2782           1                     NA               NA
    #> 10.1      1 170.5049           1                     NA               NA
    #> 100.1     3 170.0612           1                     NA               NA
    #> 101.1     1 161.7947           1                     NA               NA
    #> 102.1     1 175.9738           1                     NA               NA
    #> 103.1    NA 163.9138           1                     NA               NA
    #> 104.1     3 174.1171           1                     NA               NA
    #> 105.1     1 154.9146           1                     NA               NA

If we wanted to specify initial values for the incomplete subject
specific variables we would have to specify a full matrix of initial
values corresponding to `M_ID`. That matrix would have to look like
this:

``` r
head(coef(mod4c$model)$M_ID, 8)
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,]   NA   NA   NA   NA   NA
#> [2,]   NA   NA   NA   NA   NA
#> [3,]   NA   NA   NA   NA   NA
#> [4,]   NA   NA   NA   NA   NA
#> [5,]   NA   NA   NA   NA   NA
#> [6,]    1   NA   NA   NA   NA
#> [7,]   NA   NA   NA   NA   NA
#> [8,]   NA   NA   NA   NA   NA
```

The matrix for the initial values has to have the same dimension as the
matrix containing the data, but has `NA` wherever the value in the data
is observed (e.g., the first 5 elements of the first column) and a
numeric value where data is missing (e.g., the 6th value of the first
column).

Since `SMOKE` is a categorical covariate and coded using dummy coding,
there are columns containing the dummy variables (columns 4 and 5) as
well as a column containing the original version of `SMOKE` (first
column). The dummy variables are calculated (not sampled) in the JAGS
model and are thus completely empty in the data matrix (otherwise
**JAGS** would throw an error) and the matrix of initial values.

The corresponding part of the JAGS model is:

    #> [...]
    #>   # Cumulative logit model for SMOKE ----------------------------------------------
    #>   for (ii in 1:200) {
    #>     M_ID[ii, 1] ~ dcat(p_SMOKE[ii, 1:3])
    #> 
    #> [...]
    #> 
    #>     M_ID[ii, 4] <- ifelse(M_ID[ii, 1] == 2, 1, 0)
    #>     M_ID[ii, 5] <- ifelse(M_ID[ii, 1] == 3, 1, 0)
    #>   }
    #> 
    #> [...]

`RinvD_bmi_ID` refers to the scale matrix in the Wishart prior for the
inverse of the random effects design matrix `D_bmi_ID`. To distinguish
random effects of different models and grouping levels, the names always
end with `..._<response>_<level>`.

In the data that is passed to JAGS this matrix is specified as diagonal
matrix, with unknown diagonal elements:

``` r
mod4c$data_list['RinvD_bmi_ID']
#> $RinvD_bmi_ID
#>      [,1] [,2]
#> [1,]   NA    0
#> [2,]    0   NA
```

These diagonal elements are estimated in the model and have a Gamma
prior. The corresponding part of the JAGS model is:

    #> [...]
    #> 
    #>   for (k in 1:2) {
    #>     RinvD_bmi_ID[k, k] ~ dgamma(shape_diag_RinvD, rate_diag_RinvD)
    #>   }
    #>   invD_bmi_ID[1:2, 1:2] ~ dwish(RinvD_bmi_ID[ , ], KinvD_bmi_ID)
    #>   D_bmi_ID[1:2, 1:2] <- inverse(invD_bmi_ID[ , ])
    #> 
    #> [...]

The element `RinvD_bmi_ID` in the initial values has to be a 2 \times 2
matrix, with positive values on the diagonal and `NA` as off-diagonal
elements, since these are fixed in the data:

``` r
coef(mod4c$model)$RinvD_bmi_ID
#>           [,1]      [,2]
#> [1,] 0.1996369        NA
#> [2,]        NA 0.9486955
```

Elements that are completely unobserved, like the parameter vectors
`alpha` and `beta`, the random effects `b_<response>_<level>`
(e.g. `b_bmi_ID` and `b_hc_ID`) or scalar parameters `delta_<response>`
or `tau_<response>` are entirely specified in the initial values.

## Parallel sampling

To reduce computational time, it is possible to perform sampling of
multiple MCMC chains in parallel on multiple cores. This can be achieved
with the help of the package
[**future**](https://CRAN.R-project.org/package=future).

To perform parallel sampling, a plan how to “resolve futures” needs to
be specified; this is the specification that determines if sampling is
performed sequentially or in parallel. For example,

``` r
future::plan(future::multisession, workers = 4)
```

specifies that the different MCMC chains are sampled in 4 different R
sessions.

This specification has to be done before the **JointAI** model function
is called and remains in place until it is overwritten.

To re-set to sequential evaluation,

``` r
future::plan(future::sequential())
```

can be used.

More information on parallel computation can be found in the help files
and the [vignette of the package
**future**](https://CRAN.R-project.org/package=future).

Unfortunately, currently it is not possible to obtain a progress bar
when using parallel computation and warning messages produced during the
sampling are not returned.

## Other arguments

There are two more arguments in `*_imp()` that are passed directly to
the **rjags** functions `jags.model()` or `coda.samples()`:

- `quiet`: should messages generated during compilation be suppressed?
- `progress.bar`: allows to select the type of progress bar. Possible
  values are `"text"`, `"gui"` and `"none"`.

------------------------------------------------------------------------

1.  Gelman, A., Meng, X. L., & Stern, H. (1996). Posterior predictive
    assessment of model fitness via realized discrepancies. Statistica
    Sinica, 733-760.

2.  See p. 195 of Lesaffre, E., & Lawson, A. B. (2012). Bayesian
    Biostatistics. John Wiley & Sons.
