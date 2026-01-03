# List model details

This function prints information on all models, those explicitly
specified by the user and those specified automatically by JointAI for
(incomplete) covariates in a JointAI object.

## Usage

``` r
list_models(object, predvars = TRUE, regcoef = TRUE, otherpars = TRUE,
  priors = TRUE, refcat = TRUE)
```

## Arguments

- object:

  object inheriting from class 'JointAI'

- predvars:

  logical; should information on the predictor variables be printed?
  (default is `TRUE`)

- regcoef:

  logical; should information on the regression coefficients be printed?
  (default is `TRUE`)

- otherpars:

  logical; should information on other parameters be printed? (default
  is `TRUE`)

- priors:

  logical; should information on the priors (and hyper-parameters) be
  printed? (default is `TRUE`)

- refcat:

  logical; should information on the reference category be printed?
  (default is `TRUE`)

## Note

The models listed by this function are not the actual imputation models,
but the conditional models that are part of the specification of the
joint distribution. Briefly, the joint distribution is specified as a
sequence of conditional models

\\p(y \| x_1, x_2, x_3, ..., \theta) p(x_1\|x_2, x_3, ..., \theta)
p(x_2\|x_3, ..., \theta) ...\\ The actual imputation models are the full
conditional distributions \\p(x_1 \| \cdot)\\ derived from this joint
distribution. Even though the conditional distributions do not contain
the outcome and all other covariates in their linear predictor, outcome
and other covariates are taken into account implicitly, since
imputations are sampled from the full conditional distributions. For
more details, see Erler et al. (2016) and Erler et al. (2019).

The function `list_models` prints information on the conditional
distributions of the covariates (since they are what is specified; the
full-conditionals are automatically derived within JAGS). The outcome
is, thus, not part of the printed linear predictor, but is still
included during imputation.

## References

Erler, N.S., Rizopoulos, D., Rosmalen, J.V., Jaddoe, V.W., Franco, O.H.,
& Lesaffre, E.M.E.H. (2016). Dealing with missing covariates in
epidemiologic studies: A comparison between multiple imputation and a
full Bayesian approach. *Statistics in Medicine*, 35(17), 2955-2974.

Erler NS, Rizopoulos D, Lesaffre EMEH (2021). "JointAI: Joint Analysis
and Imputation of Incomplete Data in R." *Journal of Statistical
Software*, *100*(20), 1-56.
[doi:10.18637/jss.v100.i20](https://doi.org/10.18637/jss.v100.i20) .

## Examples

``` r
# (set n.adapt = 0 and n.iter = 0 to prevent MCMC sampling to save time)
mod1 <- lm_imp(y ~ C1 + C2 + M2 + O2 + B2, data = wideDF, n.adapt = 0,
               n.iter = 0, mess = FALSE)
#> Warning: 
#> It is currently not possible to use “contr.poly” for incomplete
#> categorical covariates. I will use “contr.treatment” instead.  You can
#> specify (globally) which types of contrasts are used by changing
#> “options('contrasts')”.

list_models(mod1)
#> Linear model for “y” 
#>    family: gaussian 
#>    link: identity 
#> * Predictor variables:
#>   (Intercept), C1, C2, M22, M23, M24, O22, O23, O24, B21 
#> * Regression coefficients:
#>   beta[1:10] (normal prior(s) with mean 0 and precision 1e-04) 
#> * Precision of  “y” :
#>   tau_y (Gamma prior with shape parameter 0.01 and rate parameter 0.01)
#> 
#> 
#> Binomial model for “B2” 
#>    family: binomial 
#>    link: logit 
#> * Reference category: “0”
#> * Predictor variables:
#>   (Intercept), C1, C2, M22, M23, M24, O22, O23, O24 
#> * Regression coefficients:
#>   alpha[1:9] (normal prior(s) with mean 0 and precision 1e-04) 
#> 
#> 
#> Linear model for “C2” 
#>    family: gaussian 
#>    link: identity 
#> * Predictor variables:
#>   (Intercept), C1, M22, M23, M24, O22, O23, O24 
#> * Regression coefficients:
#>   alpha[10:17] (normal prior(s) with mean 0 and precision 1e-04) 
#> * Precision of  “C2” :
#>   tau_C2 (Gamma prior with shape parameter 0.01 and rate parameter 0.01)
#> 
#> 
#> Multinomial logit model for “M2” 
#> * Reference category: “1”
#> * Predictor variables:
#>   (Intercept), C1, O22, O23, O24 
#> * Regression coefficients:
#>   M22: alpha[18:22]
#>   M23: alpha[23:27]
#>   M24: alpha[28:32] (normal prior(s) with mean 0 and precision 1e-04) 
#> 
#> 
#> Cumulative logit model for “O2” 
#> * Reference category: “1”
#> * Predictor variables:
#>   C1 
#> * Regression coefficients:
#>   alpha[33] (normal prior(s) with mean 0 and precision 1e-04) 
#> * Intercepts:
#>   - 1: gamma_O2[1] (normal prior with mean 0 and precision 1e-04)
#>   - 2: gamma_O2[2] = gamma_O2[1] + exp(delta_O2[1])
#>   - 3: gamma_O2[3] = gamma_O2[2] + exp(delta_O2[2])
#> * Increments:
#>   delta_O2[1:2] (normal prior(s) with mean 0 and precision 1e-04)
#> 
#> 
```
