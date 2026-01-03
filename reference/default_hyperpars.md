# Get the default values for hyper-parameters

This function returns a list of default values for the hyper-parameters.

## Usage

``` r
default_hyperpars()
```

## Details

**norm:** hyper-parameters for normal and log-normal models

|                  |                                                                                   |
|------------------|-----------------------------------------------------------------------------------|
| `mu_reg_norm`    | mean in the priors for regression coefficients                                    |
| `tau_reg_norm`   | precision in the priors for regression coefficients                               |
| `shape_tau_norm` | shape parameter in Gamma prior for the precision of the (log-)normal distribution |
| `rate_tau_norm`  | rate parameter in Gamma prior for the precision of the (log-)normal distribution  |

**gamma:** hyper-parameters for Gamma models

|                   |                                                                            |
|-------------------|----------------------------------------------------------------------------|
| `mu_reg_gamma`    | mean in the priors for regression coefficients                             |
| `tau_reg_gamma`   | precision in the priors for regression coefficients                        |
| `shape_tau_gamma` | shape parameter in Gamma prior for the precision of the Gamma distribution |
| `rate_tau_gamma`  | rate parameter in Gamma prior for the precision of the Gamma distribution  |

**beta:** hyper-parameters for beta models

|                  |                                                                             |
|------------------|-----------------------------------------------------------------------------|
| `mu_reg_beta`    | mean in the priors for regression coefficients                              |
| `tau_reg_beta`   | precision in the priors for regression coefficients                         |
| `shape_tau_beta` | shape parameter in Gamma prior for the precision of the beta distribution   |
| `rate_tau_beta`  | rate parameter in Gamma prior for precision of the of the beta distribution |

**binom:** hyper-parameters for binomial models

|                 |                                                     |
|-----------------|-----------------------------------------------------|
| `mu_reg_binom`  | mean in the priors for regression coefficients      |
| `tau_reg_binom` | precision in the priors for regression coefficients |

**poisson:** hyper-parameters for poisson models

|                   |                                                     |
|-------------------|-----------------------------------------------------|
| `mu_reg_poisson`  | mean in the priors for regression coefficients      |
| `tau_reg_poisson` | precision in the priors for regression coefficients |

**multinomial:** hyper-parameters for multinomial models

|                       |                                                     |
|-----------------------|-----------------------------------------------------|
| `mu_reg_multinomial`  | mean in the priors for regression coefficients      |
| `tau_reg_multinomial` | precision in the priors for regression coefficients |

**ordinal:** hyper-parameters for ordinal models

|                     |                                                     |
|---------------------|-----------------------------------------------------|
| `mu_reg_ordinal`    | mean in the priors for regression coefficients      |
| `tau_reg_ordinal`   | precision in the priors for regression coefficients |
| `mu_delta_ordinal`  | mean in the prior for the intercepts                |
| `tau_delta_ordinal` | precision in the priors for the intercepts          |

**ranef:** hyper-parameters for the random effects variance-covariance
matrices (when there is only one random effect a Gamma distribution is
used instead of the Wishart distribution)

|                    |                                                                                                                                                                                                                                                  |
|--------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `shape_diag_RinvD` | shape parameter in Gamma prior for the diagonal elements of `RinvD`                                                                                                                                                                              |
| `rate_diag_RinvD`  | rate parameter in Gamma prior for the diagonal elements of `RinvD`                                                                                                                                                                               |
| `KinvD_expr`       | a character string that can be evaluated to calculate the number of degrees of freedom in the Wishart distribution used for the inverse of the variance-covariance matrix for random effects, depending on the number of random effects `nranef` |

**surv:** parameters for survival models (`survreg`, `coxph` and `JM`)

|                |                                                     |
|----------------|-----------------------------------------------------|
| `mu_reg_surv`  | mean in the priors for regression coefficients      |
| `tau_reg_surv` | precision in the priors for regression coefficients |

## Note

**From the [JAGS user
manual](https://sourceforge.net/projects/mcmc-jags/files/Manuals/) on
the specification of the Wishart distribution:**  
For `KinvD` larger than the dimension of the variance-covariance matrix
the prior on the correlation between the random effects is concentrated
around 0, so that larger values of `KinvD` indicate stronger prior
belief that the elements of the multivariate normal distribution are
independent. For `KinvD` equal to the number of random effects the
Wishart prior puts most weight on the extreme values (correlation 1 or
-1).

## Examples

``` r
default_hyperpars()
#> $norm
#>    mu_reg_norm   tau_reg_norm shape_tau_norm  rate_tau_norm 
#>          0e+00          1e-04          1e-02          1e-02 
#> 
#> $gamma
#>    mu_reg_gamma   tau_reg_gamma shape_tau_gamma  rate_tau_gamma 
#>           0e+00           1e-04           1e-02           1e-02 
#> 
#> $beta
#>    mu_reg_beta   tau_reg_beta shape_tau_beta  rate_tau_beta 
#>          0e+00          1e-04          1e-02          1e-02 
#> 
#> $binom
#>  mu_reg_binom tau_reg_binom 
#>         0e+00         1e-04 
#> 
#> $poisson
#>  mu_reg_poisson tau_reg_poisson 
#>           0e+00           1e-04 
#> 
#> $multinomial
#>  mu_reg_multinomial tau_reg_multinomial 
#>               0e+00               1e-04 
#> 
#> $ordinal
#>    mu_reg_ordinal   tau_reg_ordinal  mu_delta_ordinal tau_delta_ordinal 
#>             0e+00             1e-04             0e+00             1e-04 
#> 
#> $ranef
#> shape_diag_RinvD  rate_diag_RinvD       KinvD_expr 
#>           "0.01"          "0.001"   "nranef + 1.0" 
#> 
#> $surv
#>  mu_reg_surv tau_reg_surv 
#>        0.000        0.001 
#> 

# To change the hyper-parameters:
hyp <- default_hyperpars()
hyp$norm['rate_tau_norm'] <- 1e-3
mod <- lm_imp(y ~ C1 + C2 + B1, data = wideDF, hyperpars = hyp, mess = FALSE)
#> Error in lm_imp(y ~ C1 + C2 + B1, data = wideDF, hyperpars = hyp, mess = FALSE): object 'hyp' not found

```
