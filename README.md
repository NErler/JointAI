
<!-- README.md is generated from README.Rmd. Please edit that file -->

# JointAI: Joint Analysis and Imputation of Incomplete Data <img src="man/figures/logo.png" align="right" alt="" width="160" />

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

op <- par(mar = c(2.5, 3, 2.5, 1), mgp = c(2, 0.8, 0))
plot_all(NHANES[c(1, 5:6, 8:12)], fill = '#e30f41', border = '#34111b', ncol = 4, nclass = 30)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" style="display: block; margin: auto;" />

``` r
par(op)
```

``` r
md_pattern(NHANES, color = c('#34111b', '#e30f41'))
```

<img src="man/figures/README-unnamed-chunk-3-1.png" style="display: block; margin: auto;" />

### Fit a linear regression model with incomplete covariates

``` r
lm1 <- lm_imp(SBP ~ gender + age + WC + alc + educ + bili,
              data = NHANES, n.iter = 500, progress.bar = 'none')
```

### Visualize the MCMC sample

``` r
traceplot(lm1, col = c('#d4af37', '#34111b', '#e30f41'), ncol = 4)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" style="display: block; margin: auto;" />

``` r
densplot(lm1, col = c('#d4af37', '#34111b', '#e30f41'), ncol = 4, lwd = 2)
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
#>                Mean     SD     2.5%   97.5% tail-prob. GR-crit
#> (Intercept)  88.066 9.1234  70.9406 105.990    0.00000   1.000
#> genderfemale -3.392 2.2278  -7.8947   1.001    0.12800   1.027
#> age           0.333 0.0683   0.2004   0.476    0.00000   1.003
#> WC            0.228 0.0747   0.0829   0.369    0.00133   0.999
#> alc>=1        6.231 2.2845   1.9325  10.565    0.00667   1.006
#> educhigh     -2.922 2.1708  -7.3576   1.198    0.18933   1.001
#> bili         -5.264 4.9555 -15.3574   4.495    0.27733   1.007
#> 
#> Posterior summary of residual std. deviation:
#>           Mean    SD 2.5% 97.5% GR-crit
#> sigma_SBP 13.6 0.741 12.2  15.2    1.01
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
#>   88.0658628   -3.3918580    0.3332954    0.2276082    6.2308668 
#>     educhigh         bili 
#>   -2.9221744   -5.2639112

confint(lm1)
#>                      2.5%       97.5%
#> (Intercept)   70.94063285 105.9902466
#> genderfemale  -7.89471742   1.0012343
#> age            0.20038858   0.4755302
#> WC             0.08292169   0.3692680
#> alc>=1         1.93251832  10.5647886
#> educhigh      -7.35763120   1.1975503
#> bili         -15.35739492   4.4949908
#> sigma_SBP     12.23240846  15.1502809
```
