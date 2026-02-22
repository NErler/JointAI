# Minimal Example

This vignette gives a first and very brief overview of how the package
**JointAI** can be used. The different settings and options are
explained in more depth in the [help
pages](https://nerler.github.io/JointAI/reference/index.html) and other
[vignettes](https://nerler.github.io/JointAI/articles/index.html).

Here, we use the NHANES data that are part of the **JointAI** package.
For more info on this data, check the [help
file](https://nerler.github.io/JointAI/reference/NHANES.html) for the
NHANES data, go to the [web page of the National Health and Nutrition
Examination Survey (NHANES)](https://www.cdc.gov/nchs/nhanes/index.htm)
and check out the vignette [*Visualizing Incomplete
Data*](https://nerler.github.io/JointAI/articles/VisualizingIncompleteData.html),
in which the NHANES data is explored.

## Fitting a linear regression model

Fitting a linear regression model with **JointAI** is straightforward
with the function
[`lm_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html):

``` r
lm1 <- lm_imp(SBP ~ gender + age + race + WC + alc + educ + albu + bili,
              data = NHANES, n.iter = 500, progress.bar = "none")
```

The specification of
[`lm_imp()`](https://nerler.github.io/JointAI/reference/model_imp.md) is
similar to the specification of a linear regression model for complete
data using [`lm()`](https://rdrr.io/r/stats/lm.html). In this minimal
example, the only difference is that for
[`lm_imp()`](https://nerler.github.io/JointAI/reference/model_imp.md)
the number of iterations `n.iter` has to be specified. Of course, there
are many more parameters that can (and sometimes should) be specified.
In the vignette [*Model
Specification*](https://nerler.github.io/JointAI/articles/ModelSpecification.html),
many of these parameters are explained in detail.

`n.iter` specifies the length of the [Markov
chain](https://en.wikipedia.org/wiki/Markov_chain), i.e., the number of
draws from the posterior distribution of the parameter or unobserved
value. How many iterations are necessary depends on the data and
complexity of the model and can vary from as few as 100 up to thousands
or millions.

One important criterion is that the Markov chains need to have
converged. Convergence can be evaluated visually with a trace plot.

## Traceplot

``` r
traceplot(lm1)
```

![](figures_MinimalExample/results_lm1-1.svg)

The function
[`traceplot()`](https://nerler.github.io/JointAI/reference/traceplot.html)
produces a plot of the sampled values across iterations per parameter.
Different chains are represented by different colours.

When the sampler has converged, the chains show a horizontal band, as in
the above figure. Consequently, when traces show a trend, convergence
has not been reached, and more iterations are necessary (e.g., using the
function
[`add_samples()`](https://nerler.github.io/JointAI/reference/add_samples.html)).

When the chains have converged, we can obtain the result of the model
from the model summary.

## Model Summary

Results from a model fitted with **JointAI** can be printed using
[`summary()`](https://rdrr.io/r/base/summary.html):

``` r
summary(lm1)
#> 
#> Bayesian linear model fitted with JointAI
#> 
#> Call:
#> lm_imp(formula = SBP ~ gender + age + race + WC + alc + educ + 
#>     albu + bili, data = NHANES, n.iter = 500, progress.bar = "none")
#> 
#> 
#> Posterior summary:
#>                          Mean      SD     2.5%   97.5% tail-prob. GR-crit MCE/SD
#> (Intercept)            60.879 22.8704  19.1247 106.227     0.0040    1.00 0.0271
#> genderfemale           -3.177  2.2549  -7.6423   1.099     0.1640    1.00 0.0258
#> age                     0.364  0.0708   0.2196   0.505     0.0000    1.01 0.0258
#> raceOther Hispanic      0.518  5.0580  -9.2403  10.675     0.9373    1.00 0.0258
#> raceNon-Hispanic White -1.451  3.0937  -7.2049   4.686     0.6227    1.00 0.0276
#> raceNon-Hispanic Black  9.047  3.6389   2.0441  16.042     0.0147    1.00 0.0267
#> raceother               3.686  3.4550  -3.0852  10.725     0.2653    1.00 0.0268
#> WC                      0.236  0.0822   0.0754   0.392     0.0040    1.00 0.0258
#> alc>=1                  7.272  2.3870   2.5418  11.763     0.0040    1.03 0.0284
#> educhigh               -3.397  2.1457  -7.3896   0.869     0.1120    1.00 0.0258
#> albu                    5.320  4.0590  -2.7810  12.922     0.1987    1.00 0.0291
#> bili                   -5.516  4.9060 -15.2486   4.592     0.2413    1.01 0.0274
#> 
#> Posterior summary of residual std. deviation:
#>           Mean    SD 2.5% 97.5% GR-crit MCE/SD
#> sigma_SBP 13.2 0.738 11.9  14.7    1.02 0.0282
#> 
#> 
#> MCMC settings:
#> Iterations = 101:600
#> Sample size per chain = 500 
#> Thinning interval = 1 
#> Number of chains = 3 
#> 
#> Number of observations: 186
```

The output gives the posterior summary, i.e., the summary of the MCMC
([Markov Chain Monte
Carlo](https://en.wikipedia.org/wiki/Markov_chain_Monte_Carlo)) sample,
which consists of all chains combined.

By default,
[`summary()`](https://nerler.github.io/JointAI/reference/summary.JointAI.html)
will only print the posterior summary for the main model parameters of
the analysis model. How one can select which parameters are shown is
described in the vignette [*Selecting
Parameters*](https://nerler.github.io/JointAI/articles/SelectingParameters.html).

The summary consists of the posterior mean, the standard deviation, 2.5%
and 97.5% quantiles of the MCMC sample, the tail probability, the
Gelman-Rubin criterion for convergence and the ratio of the Monte Carlo
error to the standard deviation of the posterior sample.

#### Tail probability

The tail probability is a measure of how likely the value 0 is under the
estimated posterior distribution, and is calculated as
2\times\min\left\\Pr(\theta \> 0), Pr(\theta \< 0)\right\\ (where \theta
is the parameter of interest).

In the following graphics, the shaded areas represent the minimum of
Pr(\theta \> 0) and Pr(\theta \< 0):
![](figures_MinimalExample/tailprob-1.svg)

#### Gelman-Rubin criterion

The Gelman-Rubin[¹](#fn1) criterion, also available via the function
[`GR_crit()`](https://nerler.github.io/JointAI/reference/GR_crit.html),
compares the within and between chain variation. When it is close enough
to 1[²](#fn2), the chains can be assumed to have converged.

#### Monte Carlo error

The Monte Carlo error is a measure of the error that is made because the
estimate is based on a finite sample. It can also be obtained using the
function
[`MC_error()`](https://nerler.github.io/JointAI/reference/MC_error.html).
Ideally, the Monte Carlo error should be small compared to the standard
error of the posterior sample. The values shown in the model summary are
the Monte Carlo error divided by the posterior standard deviation.

#### Additional information

In the model summary, additionally, some important characteristics of
the MCMC samples on which the summary is based, are given. This includes
the range and number of iterations (= `Sample size per chain`), thinning
interval and number of chains.

Furthermore, the number of observations (the sample size of the data) is
given.

With the arguments `start`, `end` and `thin` it is possible to select
which iterations from the MCMC sample are included in the summary.

For example:  
When the traceplot shows that the chains only converged after 1500
iterations, `start = 1500` should be specified in
[`summary()`](https://nerler.github.io/JointAI/reference/summary.JointAI.html).

A summary of the missing values in all variables involved in the model
can be added to the summary by setting `missinfo = TRUE`.

## Plot of the posterior distributions

The posterior distributions can be visualized using the function
[`densplot()`](https://nerler.github.io/JointAI/reference/densplot.md):

``` r
densplot(lm1)
```

![](figures_MinimalExample/densplot-1.svg)

By default,
[`densplot()`](https://nerler.github.io/JointAI/reference/densplot.md)
plots the empirical distribution of each of the chains separately. When
`joined = TRUE` the distributions of the combined chains are plotted.

## Other types of models

Besides linear regression models, it is also possible to fit

- **generalized linear models**:
  [`glm_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)

- **log-normal models**:
  [`lognorm_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)

- **beta models** for continuous outcomes between 0 and 1 (proportions):
  [`betareg_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)

- **cumulative logit models** for ordinal outcomes:
  [`clm_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)

- **multinomial logit models** for unordered factors with multiple
  levels:
  [`mlogit_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)

- **linear mixed models**:
  [`lme_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)
  or
  [`lmer_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)
  (identical)

- **generalized linear mixed models**:
  [`glme_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)
  or
  [`glmer_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)
  (identical)

- **log-normal mixed models**:
  [`lognormmm_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)

- **beta mixed models**:
  [`betamm_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)

- **cumulative logit mixed models**:
  [`clmm_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)

- **multinomial logit mixed models**:
  [`mlogitmm_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)

- **parametric (Weibull) survival models**:
  [`survreg_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)

- **proportional hazards survival models**:
  [`coxph_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)

- **joint models for longitudinal and survival data**:
  [`JM_imp()`](https://nerler.github.io/JointAI/reference/model_imp.html)

It is also possible to specify multiple analysis models at the same
time, by providing a list of model formulas.

------------------------------------------------------------------------

1.  Gelman, A and Rubin, DB (1992) Inference from iterative simulation
    using multiple sequences, Statistical Science, 7, 457-511.  
    Brooks, SP. and Gelman, A. (1998) General methods for monitoring
    convergence of iterative simulations. Journal of Computational and
    Graphical Statistics, 7, 434-455.

2.  for example \< 1.1; but this is not a generally accepted cut-off
