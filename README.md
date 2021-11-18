
<!-- README.md is generated from README.Rmd. Please edit that file -->

# JointAI: Joint Analysis and Imputation of Incomplete Data <img src="man/figures/logo.png" align="right" alt="" width="160" />

<!-- badges: start -->

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version-last-release/JointAI)](https://CRAN.R-project.org/package=JointAI)
[![](https://cranlogs.r-pkg.org/badges/grand-total/JointAI)](https://CRAN.R-project.org/package=JointAI)
[![Download
counter](https://cranlogs.r-pkg.org/badges/JointAI)](https://cran.r-project.org/package=JointAI)
[![Rdoc](https://www.rdocumentation.org/badges/version/JointAI)](https://www.rdocumentation.org/packages/JointAI)
[![codecov](https://codecov.io/gh/NErler/JointAI/branch/master/graph/badge.svg)](https://app.codecov.io/gh/NErler/JointAI)
[![Travis-CI Build
Status](https://travis-ci.org/NErler/JointAI.svg?branch=master)](https://travis-ci.org/NErler/JointAI)
[![R build
status](https://github.com/NErler/JointAI/workflows/R-CMD-check/badge.svg)](https://github.com/NErler/JointAI/actions)
<!-- badges: end -->

The package **JointAI** provides functionality to perform joint analysis
and imputation of a range of model types in the Bayesian framework.
Implemented are (generalized) linear regression models and extensions
thereof, models for (un-/ordered) categorical data, as well as
multi-level (mixed) versions of these model types.

Moreover, survival models and joint models for longitudinal and survival
data are available. It is also possible to fit multiple models of mixed
types simultaneously. Missing values in (if present) will be imputed
automatically.

**JointAI** performs some preprocessing of the data and creates a
[JAGS](https://mcmc-jags.sourceforge.io/) model, which will then
automatically be passed to [JAGS](https://mcmc-jags.sourceforge.io/)
with the help of the R package
[**rjags**](https://CRAN.R-project.org/package=rjags).

Besides the main modelling functions, **JointAI** also provides a number
of functions to summarize and visualize results and incomplete data.

## Installation

**JointAI** can be installed from [CRAN](https://cran.r-project.org/):

``` r
install.packages('JointAI')
```

Alternatively, you can install **JointAI** from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("NErler/JointAI")
```

## Main functions

**JointAI** provides the following main functions:

``` r
lm_imp()                 # linear regression
glm_imp()                # generalized linear regression
clm_imp()                # cumulative logit model
mlogit_imp()             # multinomial logit model
lognorm_imp()            # log-normal regression
betareg_imp()            # beta regression
lme_imp() / lmer_imp()   # linear mixed model
glme_imp() / glmer_imp() # generalized linear mixed model
clmm_imp()               # cumulative logit mixed model
mlogitmm_imp()           # multinomial logit model
lognormmm_imp()          # log-normal regression
betamm_imp()             # beta regression
survreg_imp()            # parametric (Weibull) survival model
coxph_imp()              # proportional hazards survival model
JM_imp()                 # joint model for longitudinal and survival data
```

The functions use specification similar to that of well known standard
functions like `lm()` and `glm()` from base R, `nlme::lme()` (from the
package [**nlme**](https://CRAN.R-project.org/package=nlme)) ,
`lme4::lmer()` or `lme4::glmer()` (from the package
[**lme4**](https://CRAN.R-project.org/package=lme4)) and
`survival::survreg()` and `survival::coxph()` (from the package
[**survival**](https://CRAN.R-project.org/package=survival)).

Functions `summary()`, `coef()`, `traceplot()` and `densplot()` provide
a summary of the posterior distribution and its visualization.

`GR_crit()` and `MC_error()` implement the Gelman-Rubin diagnostic for
convergence and the Monte Carlo error of the MCMC sample, respectively.

**JointAI** also provides functions for exploration of the distribution
of the data and missing values, export of imputed values and prediction.

## Minimal Example

### Visualize the observed data and missing data pattern

``` r
library(JointAI)

plot_all(NHANES[c(1, 5:6, 8:12)], fill = '#D10E3B', border = '#460E1B', ncol = 4, breaks = 30)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" style="display: block; margin: auto;" />

``` r
md_pattern(NHANES, color = c('#460E1B', '#D10E3B'))
```

<img src="man/figures/README-unnamed-chunk-4-1.png" style="display: block; margin: auto;" />

### Fit a linear regression model with incomplete covariates

``` r
lm1 <- lm_imp(SBP ~ gender + age + WC + alc + educ + bili,
              data = NHANES, n.iter = 500, progress.bar = 'none', seed = 2020)
```

### Visualize the MCMC sample

``` r
traceplot(lm1, col = c('#d4af37', '#460E1B', '#D10E3B'), ncol = 4)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" style="display: block; margin: auto;" />

``` r
densplot(lm1, col = c('#d4af37', '#460E1B', '#D10E3B'), ncol = 4, lwd = 2)
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" style="display: block; margin: auto;" />

### Summarize the Result

``` r
summary(lm1)
#> 
#> Bayesian linear model fitted with JointAI
#> 
#> Call:
#> lm_imp(formula = SBP ~ gender + age + WC + alc + educ + bili, 
#>     data = NHANES, n.iter = 500, seed = 2020, progress.bar = "none")
#> 
#> 
#> Posterior summary:
#>                Mean     SD    2.5%   97.5% tail-prob. GR-crit MCE/SD
#> (Intercept)  87.984 9.0412  70.110 107.092    0.00000    1.00 0.0258
#> genderfemale -3.501 2.2488  -8.039   1.059    0.10400    1.00 0.0258
#> age           0.333 0.0713   0.199   0.471    0.00000    1.01 0.0275
#> WC            0.226 0.0757   0.072   0.373    0.00267    1.00 0.0258
#> alc>=1        6.509 2.3290   1.899  10.859    0.01067    1.00 0.0270
#> educhigh     -2.780 2.1237  -6.886   1.248    0.19733    1.00 0.0258
#> bili         -5.173 4.8315 -14.599   4.109    0.28800    1.01 0.0303
#> 
#> Posterior summary of residual std. deviation:
#>           Mean    SD 2.5% 97.5% GR-crit MCE/SD
#> sigma_SBP 13.6 0.739 12.3  15.1    1.01 0.0289
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

``` r
coef(lm1)
#> $SBP
#>  (Intercept) genderfemale          age           WC       alc>=1     educhigh 
#>   87.9839157   -3.5010429    0.3329532    0.2262894    6.5093606   -2.7800225 
#>         bili    sigma_SBP 
#>   -5.1730414   13.5670206

confint(lm1)
#> $SBP
#>                      2.5%       97.5%
#> (Intercept)   70.11037933 107.0920122
#> genderfemale  -8.03905105   1.0594821
#> age            0.19919441   0.4705334
#> WC             0.07201019   0.3734877
#> alc>=1         1.89897665  10.8594963
#> educhigh      -6.88561508   1.2481772
#> bili         -14.59898407   4.1089909
#> sigma_SBP     12.25273343  15.1162472
```
