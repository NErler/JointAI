
<!-- README.md is generated from README.Rmd. Please edit that file -->

# JointAI: Joint Analysis and Imputation of Incomplete Data

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/JointAI)](https://cran.r-project.org/package=JointAI)
[![Travis-CI Build
Status](https://travis-ci.org/NErler/JointAI.svg?branch=master)](https://travis-ci.org/NErler/JointAI)
[![](https://cranlogs.r-pkg.org/badges/grand-total/JointAI)](https://CRAN.R-project.org/package=JointAI)
<!-- [![Rdoc](http://www.rdocumentation.org/badges/version/JointAI)](http://www.rdocumentation.org/packages/JointAI) -->
<!-- [![Download counter](http://cranlogs.r-pkg.org/badges/JointAI)](https://cran.r-project.org/package=JointAI) -->

The package **JointAI** provides joint analysis and imputation of linear
regression models, generalized linear regression models or linear mixed
models with incomplete (covariate) data in the Bayesian framework.

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

Currently, there are three main functions that perform linear,
generalized linear or linear mixed regression:

``` r
lm_imp()
glm_imp()
lme_imp()
```

`lm_imp()` and `glm_imp()` use specification similar to their complete
data counterparts `lm()` and `glm()`, whereas `lme_imp()` uses similar
specification as `lme()` from the package
[**nlme**](https://CRAN.R-project.org/package=nlme).

Functions `summary()`, `traceplot()`, `densityplot()` provide a summary
of the posterior distribution and its visualization.

`gr_crit()` and `mc_error()` provide the Gelman-Rubin diagnostic for
convergence and the Monte Carlo error of the MCMC sample, respectively.
