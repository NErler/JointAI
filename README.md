
<!-- README.md is generated from README.Rmd. Please edit that file -->

# JointAI: Joint Analysis and Imputation of Incomplete Data

[![Travis-CI Build
Status](https://travis-ci.org/NErler/JointAI.svg?branch=master)](https://travis-ci.org/NErler/JointAI)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version-last-release/JointAI)](https://CRAN.R-project.org/package=JointAI)
[![](https://cranlogs.r-pkg.org/badges/grand-total/JointAI)](https://CRAN.R-project.org/package=JointAI)
[![Download
counter](http://cranlogs.r-pkg.org/badges/JointAI)](https://cran.r-project.org/package=JointAI)
[![Rdoc](http://www.rdocumentation.org/badges/version/JointAI)](http://www.rdocumentation.org/packages/JointAI)

The package **JointAI** provides joint analysis and imputation of
(generalized) linear regression models, (generalized) linear mixed
models and parametric (Weibull) survival models with incomplete
(covariate) data in the Bayesian framework.

The package performs some preprocessing of the data and creates a
[JAGS](http://mcmc-jags.sourceforge.net) model, which will then
automatically be passed to [JAGS](http://mcmc-jags.sourceforge.net) with
the help of the R package
[**rjags**](https://CRAN.R-project.org/package=rjags).

**JointAI** also provides summary and plotting functions for the output.

## Installation

You can install **JointAI** from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("NErler/JointAI")
```

## Main functions

Currently, there are the following main functions:

``` r
lm_imp()      # linear regression
glm_imp()     # generalized linear regression 
clm_imp()     # cumulative logit model
lme_imp()     # linear mixed model
glme_imp()    # generalized linear mixed model
clmm_imp()    # cumulative logit mixed model
survreg_imp() # parametric (Weibull) survival model
coxph_imp()   # Cox proportional hazards survival model
```

The functions `lm_imp()`, `glm_imp()` and `clm_imp()` use specification
similar to their complete data counterparts `lm()` and `glm()` from base
R and `clm()` from the package
[**ordinal**](https://CRAN.R-project.org/package=ordinal).

The functions for mixed models, `lme_imp()`, `glme_imp()` and
`clmm_imp()` use similar specification as `lme()` from the package
[**nlme**](https://CRAN.R-project.org/package=nlme) (and `clmm2()` from
[**ordinal**](https://CRAN.R-project.org/package=nlme)).

`survreg_imp()` and `coxph_imp()` are missing data versions of
`survreg()` and `coxph()` from the package
[**survival**](https://CRAN.R-project.org/package=survival).

Functions `summary()`, `coef()`, `traceplot()` and `densityplot()`
provide a summary of the posterior distribution and its visualization.

`GR_crit()` and `MC_error()` provide the Gelman-Rubin diagnostic for
convergence and the Monte Carlo error of the MCMC sample, respectively.

**JointAI** also provides functions for exploration of the distribution
of the data and missing values, export of imputed values and prediction.

## Minimal Example

### Visualize the observed data and missing data pattern

``` r
library(JointAI)

par(mar = c(2.5, 3, 2.5, 1), mgp = c(2, 0.8, 0))
plot_all(NHANES[c(1, 5:6, 8:12)], fill = '#18bc9c', border = '#2C3E50', ncol = 4, nclass = 30)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" style="display: block; margin: auto;" />

``` r
md_pattern(NHANES, color = c('#2C3E50', '#18bc9c'))
```

<img src="man/figures/README-unnamed-chunk-3-1.png" style="display: block; margin: auto;" />

### Fit a linear regression model with incomplete covariates

``` r
lm1 <- lm_imp(SBP ~ gender + age + WC + alc + educ + bili,
              data = NHANES, n.iter = 500, progress.bar = 'none')
```

### Visualize the MCMC sample

``` r
traceplot(lm1, col = c('#E74C3C', '#2C3E50', '#18bc9c'), ncol = 4)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" style="display: block; margin: auto;" />

``` r
densplot(lm1, col = c('#E74C3C', '#2C3E50', '#18bc9c'), ncol = 4, lwd = 2)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" style="display: block; margin: auto;" />

### Summarize the Result

``` r
summary(lm1)
#> 
#>  Linear model fitted with JointAI 
#> 
#> Call:
#> lm_imp(formula = SBP ~ gender + age + WC + alc + educ + bili, 
#>     data = NHANES, n.iter = 500, progress.bar = "none")
#> 
#> Posterior summary:
#>                Mean     SD    2.5%   97.5% tail-prob. GR-crit
#> (Intercept)  88.089 8.8597  69.619 105.178    0.00000    1.01
#> genderfemale -3.566 2.2571  -7.950   0.803    0.11333    1.04
#> age           0.335 0.0700   0.193   0.469    0.00000    1.01
#> WC            0.226 0.0725   0.080   0.368    0.00267    1.00
#> alc>=1        6.350 2.3114   1.783  10.889    0.01200    1.00
#> educhigh     -2.828 2.0465  -6.797   1.157    0.17333    1.03
#> bili         -5.356 4.9196 -14.911   4.290    0.27867    1.04
#> 
#> Posterior summary of residual std. deviation:
#>           Mean    SD 2.5% 97.5% GR-crit
#> sigma_SBP 13.5 0.738 12.2  15.2       1
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
#>  (Intercept) genderfemale          age           WC       alc>=1 
#>   88.0889587   -3.5660647    0.3350489    0.2262964    6.3497173 
#>     educhigh         bili 
#>   -2.8283599   -5.3562879

confint(lm1)
#>                      2.5%       97.5%
#> (Intercept)   69.61859898 105.1784708
#> genderfemale  -7.95045888   0.8034015
#> age            0.19331277   0.4685157
#> WC             0.07998274   0.3681013
#> alc>=1         1.78289844  10.8888495
#> educhigh      -6.79742752   1.1568467
#> bili         -14.91144335   4.2900062
#> sigma_SBP     12.17745503  15.1533245
```
