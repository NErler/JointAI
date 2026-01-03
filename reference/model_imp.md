# Joint Analysis and Imputation of incomplete data

Main analysis functions to estimate different types of models using MCMC
sampling, while imputing missing values.

## Usage

``` r
lm_imp(formula, data, n.chains = 3, n.adapt = 100, n.iter = 0,
  thin = 1, monitor_params = c(analysis_main = TRUE), auxvars = NULL,
  refcats = NULL, models = NULL, no_model = NULL, shrinkage = FALSE,
  ppc = TRUE, seed = NULL, inits = NULL, warn = TRUE, mess = TRUE,
  ...)

glm_imp(formula, family, data, n.chains = 3, n.adapt = 100, n.iter = 0,
  thin = 1, monitor_params = c(analysis_main = TRUE), auxvars = NULL,
  refcats = NULL, models = NULL, no_model = NULL, shrinkage = FALSE,
  ppc = TRUE, seed = NULL, inits = NULL, warn = TRUE, mess = TRUE,
  ...)

clm_imp(formula, data, n.chains = 3, n.adapt = 100, n.iter = 0,
  thin = 1, monitor_params = c(analysis_main = TRUE), auxvars = NULL,
  refcats = NULL, nonprop = NULL, rev = NULL, models = NULL,
  no_model = NULL, shrinkage = FALSE, ppc = TRUE, seed = NULL,
  inits = NULL, warn = TRUE, mess = TRUE, ...)

lognorm_imp(formula, data, n.chains = 3, n.adapt = 100, n.iter = 0,
  thin = 1, monitor_params = c(analysis_main = TRUE), auxvars = NULL,
  refcats = NULL, models = NULL, no_model = NULL, shrinkage = FALSE,
  ppc = TRUE, seed = NULL, inits = NULL, warn = TRUE, mess = TRUE,
  ...)

betareg_imp(formula, data, n.chains = 3, n.adapt = 100, n.iter = 0,
  thin = 1, monitor_params = c(analysis_main = TRUE), auxvars = NULL,
  refcats = NULL, models = NULL, no_model = NULL, shrinkage = FALSE,
  ppc = TRUE, seed = NULL, inits = NULL, warn = TRUE, mess = TRUE,
  ...)

mlogit_imp(formula, data, n.chains = 3, n.adapt = 100, n.iter = 0,
  thin = 1, monitor_params = c(analysis_main = TRUE), auxvars = NULL,
  refcats = NULL, models = NULL, no_model = NULL, shrinkage = FALSE,
  ppc = TRUE, seed = NULL, inits = NULL, warn = TRUE, mess = TRUE,
  ...)

lme_imp(fixed, data, random, n.chains = 3, n.adapt = 100, n.iter = 0,
  thin = 1, monitor_params = c(analysis_main = TRUE), auxvars = NULL,
  refcats = NULL, rd_vcov = "blockdiag", models = NULL,
  no_model = NULL, shrinkage = FALSE, ppc = TRUE, seed = NULL,
  inits = NULL, warn = TRUE, mess = TRUE, ...)

lmer_imp(fixed, data, random, n.chains = 3, n.adapt = 100, n.iter = 0,
  thin = 1, monitor_params = c(analysis_main = TRUE), auxvars = NULL,
  refcats = NULL, rd_vcov = "blockdiag", models = NULL,
  no_model = NULL, shrinkage = FALSE, ppc = TRUE, seed = NULL,
  inits = NULL, warn = TRUE, mess = TRUE, ...)

glme_imp(fixed, data, random, family, n.chains = 3, n.adapt = 100,
  n.iter = 0, thin = 1, monitor_params = c(analysis_main = TRUE),
  auxvars = NULL, refcats = NULL, rd_vcov = "blockdiag", models = NULL,
  no_model = NULL, shrinkage = FALSE, ppc = TRUE, seed = NULL,
  inits = NULL, warn = TRUE, mess = TRUE, ...)

glmer_imp(fixed, data, random, family, n.chains = 3, n.adapt = 100,
  n.iter = 0, thin = 1, monitor_params = c(analysis_main = TRUE),
  auxvars = NULL, refcats = NULL, rd_vcov = "blockdiag", models = NULL,
  no_model = NULL, shrinkage = FALSE, ppc = TRUE, seed = NULL,
  inits = NULL, warn = TRUE, mess = TRUE, ...)

betamm_imp(fixed, random, data, n.chains = 3, n.adapt = 100, n.iter = 0,
  thin = 1, monitor_params = c(analysis_main = TRUE), auxvars = NULL,
  refcats = NULL, rd_vcov = "blockdiag", models = NULL,
  no_model = NULL, shrinkage = FALSE, ppc = TRUE, seed = NULL,
  inits = NULL, warn = TRUE, mess = TRUE, ...)

lognormmm_imp(fixed, random, data, n.chains = 3, n.adapt = 100,
  n.iter = 0, thin = 1, monitor_params = c(analysis_main = TRUE),
  auxvars = NULL, refcats = NULL, rd_vcov = "blockdiag", models = NULL,
  no_model = NULL, shrinkage = FALSE, ppc = TRUE, seed = NULL,
  inits = NULL, warn = TRUE, mess = TRUE, ...)

clmm_imp(fixed, data, random, n.chains = 3, n.adapt = 100, n.iter = 0,
  thin = 1, monitor_params = c(analysis_main = TRUE), auxvars = NULL,
  refcats = NULL, nonprop = NULL, rev = NULL, rd_vcov = "blockdiag",
  models = NULL, no_model = NULL, shrinkage = FALSE, ppc = TRUE,
  seed = NULL, inits = NULL, warn = TRUE, mess = TRUE, ...)

mlogitmm_imp(fixed, data, random, n.chains = 3, n.adapt = 100,
  n.iter = 0, thin = 1, monitor_params = c(analysis_main = TRUE),
  auxvars = NULL, refcats = NULL, rd_vcov = "blockdiag", models = NULL,
  no_model = NULL, shrinkage = FALSE, ppc = TRUE, seed = NULL,
  inits = NULL, warn = TRUE, mess = TRUE, ...)

survreg_imp(formula, data, n.chains = 3, n.adapt = 100, n.iter = 0,
  thin = 1, monitor_params = c(analysis_main = TRUE), auxvars = NULL,
  refcats = NULL, models = NULL, no_model = NULL, shrinkage = FALSE,
  ppc = TRUE, seed = NULL, inits = NULL, warn = TRUE, mess = TRUE,
  ...)

coxph_imp(formula, data, df_basehaz = 6, n.chains = 3, n.adapt = 100,
  n.iter = 0, thin = 1, monitor_params = c(analysis_main = TRUE),
  auxvars = NULL, refcats = NULL, models = NULL, no_model = NULL,
  shrinkage = FALSE, ppc = TRUE, seed = NULL, inits = NULL,
  warn = TRUE, mess = TRUE, ...)

JM_imp(formula, data, df_basehaz = 6, n.chains = 3, n.adapt = 100,
  n.iter = 0, thin = 1, monitor_params = c(analysis_main = TRUE),
  auxvars = NULL, timevar = NULL, refcats = NULL,
  rd_vcov = "blockdiag", models = NULL, no_model = NULL,
  assoc_type = NULL, shrinkage = FALSE, ppc = TRUE, seed = NULL,
  inits = NULL, warn = TRUE, mess = TRUE, ...)
```

## Arguments

- formula:

  a two sided model formula (see
  [`formula`](https://rdrr.io/r/stats/formula.html)) or a list of such
  formulas; (more details below).

- data:

  a `data.frame` containing the original data (more details below)

- n.chains:

  number of MCMC chains

- n.adapt:

  number of iterations for adaptation of the MCMC samplers (see
  [`adapt`](https://rdrr.io/pkg/rjags/man/adapt.html))

- n.iter:

  number of iterations of the MCMC chain (after adaptation; see
  [`coda.samples`](https://rdrr.io/pkg/rjags/man/coda.samples.html))

- thin:

  thinning interval (integer; see
  [`window.mcmc`](https://rdrr.io/pkg/coda/man/window.mcmc.html)). For
  example, `thin = 1` (default) will keep the MCMC samples from all
  iterations; `thin = 5` would only keep every 5th iteration.

- monitor_params:

  named list or vector specifying which parameters should be monitored
  (more details below)

- auxvars:

  optional; one-sided formula of variables that should be used as
  predictors in the imputation procedure (and will be imputed if
  necessary) but are not part of the analysis model(s). For more details
  with regards to the behaviour with non-linear effects see the vignette
  on [Model
  Specification](https://nerler.github.io/JointAI/articles/ModelSpecification.html#auxvars)

- refcats:

  optional; either one of `"first"`, `"last"`, `"largest"` (which sets
  the category for all categorical variables) or a named list specifying
  which category should be used as reference category per categorical
  variable. Options are the category label, the category number, or one
  of "first" (the first category), "last" (the last category) or
  "largest" (chooses the category with the most observations). Default
  is "first". If reference categories are specified for a subset of the
  categorical variables the default will be used for the remaining
  variables. (See also [`set_refcat`](set_refcat.md))

- models:

  optional; named vector specifying the types of models for (incomplete)
  covariates. This arguments replaces the argument `meth` used in
  earlier versions. If `NULL` (default) models will be determined
  automatically based on the class of the respective columns of `data`.

- no_model:

  optional; vector of names of variables for which no model should be
  specified. Note that this is only possible for completely observed
  variables and implies the assumptions of independence between the
  excluded variable and the incomplete variables.

- shrinkage:

  optional; either a character string naming the shrinkage method to be
  used for regression coefficients in all models or a named vector
  specifying the type of shrinkage to be used in the models given as
  names.

- ppc:

  logical: should monitors for posterior predictive checks be set? (not
  yet used)

- seed:

  optional; seed value (for reproducibility)

- inits:

  optional; specification of initial values in the form of a list or a
  function (see
  [`jags.model`](https://rdrr.io/pkg/rjags/man/jags.model.html)). If
  omitted, starting values for the random number generator are created
  by **JointAI**, initial values are then generated by JAGS. It is an
  error to supply an initial value for an observed node.

- warn:

  logical; should warnings be given? Default is `TRUE`.

- mess:

  logical; should messages be given? Default is `TRUE`.

- ...:

  additional, optional arguments

  `trunc`

  :   named list specifying limits of truncation for the distribution of
      the named incomplete variables (see the vignette
      [ModelSpecification](https://nerler.github.io/JointAI/articles/ModelSpecification.html#functions-with-restricted-support))

  `hyperpars`

  :   list of hyper-parameters, as obtained by
      [`default_hyperpars()`](default_hyperpars.md)

  `scale_vars`

  :   named vector of (continuous) variables that will be centred and
      scaled (such that mean = 0 and sd = 1) when they enter a linear
      predictor to improve convergence of the MCMC sampling. Default is
      that all numeric variables and integer variables with \>20
      different values will be scaled. If set to `FALSE` no scaling will
      be done.

  `custom`

  :   named list of JAGS model chunks (character strings) that replace
      the model for the given variable.

  `append_data_list`

  :   list that will be appended to the list containing the data that is
      passed to **rjags** (`data_list`). This may be necessary if
      additional data / variables are needed for custom (covariate)
      models. Note: since version 1.0.7 elements of `append_data_list`
      will overwrite existing elements of the `data_list` with the same
      name.

  `progress.bar`

  :   character string specifying the type of progress bar. Possible
      values are "text" (default), "gui", and "none" (see `update`).
      Note: when sampling is performed in parallel it is not possible to
      display a progress bar.

  `quiet`

  :   logical; if `TRUE` then messages generated by **rjags** during
      compilation as well as the progress bar for the adaptive phase
      will be suppressed, (see
      [`jags.model`](https://rdrr.io/pkg/rjags/man/jags.model.html))

  `keep_scaled_mcmc`

  :   should the "original" MCMC sample (i.e., the scaled version
      returned by `coda.samples()`) be kept? (The MCMC sample that is
      re-scaled to the scale of the data is always kept.)

  `modelname`

  :   character string specifying the name of the model file (including
      the ending, either .R or .txt). If unspecified a random name will
      be generated.

  `modeldir`

  :   directory containing the model file or directory in which the
      model file should be written. If unspecified a temporary directory
      will be created.

  `overwrite`

  :   logical; whether an existing model file with the specified
      `<modeldir>/<modelname>` should be overwritten. If set to `FALSE`
      and a model already exists, that model will be used. If
      unspecified (`NULL`) and a file exists, the user is asked for
      input on how to proceed.

  `keep_model`

  :   logical; whether the created JAGS model file should be saved or
      removed from (`FALSE`; default) when the sampling has finished.

- family:

  only for `glm_imp` and `glmm_imp`/`glmer_imp`: a description of the
  distribution and link function to be used in the model. This can be a
  character string naming a family function, a family function or the
  result of a call to a family function. (For more details see below and
  [`family`](https://rdrr.io/r/stats/family.html).)

- nonprop:

  optional named list of one-sided formulas specifying covariates that
  have non-proportional effects in cumulative logit models. These
  covariates should also be part of the regular model formula, and the
  names of the list should be the names of the ordinal response
  variables.

- rev:

  optional character vector; vector of ordinal outcome variable names
  for which the odds should be reversed, i.e., \\logit(y\le k)\\ instead
  of \\logit(y \> k)\\.

- fixed:

  a two sided formula describing the fixed-effects part of the model
  (see [`formula`](https://rdrr.io/r/stats/formula.html))

- random:

  only for multi-level models: a one-sided formula of the form
  `~x1 + ... + xn | g`, where `x1 + ... + xn` specifies the model for
  the random effects and `g` the grouping variable

- rd_vcov:

  character string or list specifying the structure of the random
  effects variance covariance matrix, see details below.

- df_basehaz:

  degrees of freedom for the B-spline used to model the baseline hazard
  in proportional hazards models (`coxph_imp` and `JM_imp`)

- timevar:

  name of the variable indicating the time of the measurement of a
  time-varying covariate in a proportional hazards survival model (also
  in a joint model). The variable specified in "timevar" will
  automatically be added to "no_model".

- assoc_type:

  named vector specifying the type of the association used for a
  time-varying covariate in the linear predictor of the survival model
  when using a "JM" model. Implemented options are "underl.value"
  (linear predictor; default for covariates modelled using a Gaussian,
  Gamma, beta or log-normal distribution) covariates) and "obs.value"
  (the observed/imputed value; default for covariates modelled using
  other distributions).

## Value

An object of class [JointAI](JointAIObject.md).

## Model formulas

### Random effects

It is possible to specify multi-level models as it is done in the
package [nlme](https://CRAN.R-project.org/package=nlme), using `fixed`
and `random`, or as it is done in the package
[lme4](https://CRAN.R-project.org/package=lme4), using `formula` and
specifying the random effects in brackets:

    formula = y ~ x1 + x2 + x3 + (1 | id)

is equivalent to

    fixed = y ~ x1 + x2 + x3, random = ~ 1|id

### Multiple levels of grouping

For multiple levels of grouping the specification using `formula` should
be used. There is no distinction between nested and crossed random
effects, i.e., `... + (1 | id) + (1 | center)` is treated the same as
`... + (1 | center/id)`.

### Nested vs crossed random effects

The distinction between nested and crossed random effects should come
from the levels of the grouping variables, i.e., if `id` is nested in
`center`, then there cannot be observations with the same `id` but
different values for `center`.

### Modelling multiple models simultaneously & joint models

To fit multiple main models at the same time, a `list` of `formula`
objects can be passed to the argument `formula`. Outcomes of one model
may be contained as covariates in another model and it is possible to
combine models for variables on different levels, for example:

    formula = list(y ~ x1 + x2 + x3 + x4 + time + (time | id),
                         x2 ~ x3 + x4 + x5)

This principle is also used for the specification of a joint model for
longitudinal and survival data.

Note that it is not possible to specify multiple models for the same
outcome variable.

#### Random effects variance-covariance structure

(Note: This feature is new and has not been fully tested yet.)

By default, a block-diagonal structure is assumed for the
variance-covariance matrices of the random effects in models with random
effects. This means that per outcome and level random effects are
assumed to be correlated, but random effects of different outcomes are
modelled as independent. The argument `rd_vcov` allows the user specify
different assumptions about these variance-covariance matrices.
Implemented structures are `full`, `blockdiag` and `indep` (all
off-diagonal elements are zero).

If `rd_vcov` is set to one of these options, the structure is assumed
for all random effects variance-covariance matrices. Alternatively, it
is possible to specify a named list of vectors, where the names are the
structures and the vectors contain the names of the response variables
which are included in this structure.

For example, for a multivariate mixed model with five outcomes `y1`,
..., `y5`, the specification could be:

    rd_vcov = list(blockdiag = c("y1", "y2"),
                   full = c("y3", "y4"),
                   indep = "y5")

This would entail that the random effects for `y3` and `y4` are assumed
to be correlated (within and across outcomes), random effects for `y1`
and `y2` are assumed to be correlated within each outcome, and the
random effects for `y5` are assumed to be independent.

It is possible to have multiple sets of response variables for which
separate full variance-covariance matrices are used, for example:

    rd_vcov = list(full = c("y1", "y2", "y5"),
                   full = c("y3", "y4"))

In models with multiple levels of nesting, separate structures can be
specified per level:

    rd_vcov = list(id = list(blockdiag = c("y1", "y2"),
                             full = c("y3", "y4"),
                             indep = "y5"),
                  center = "indep")

### Survival models with frailties or time-varying covariates

Random effects specified in brackets can also be used to indicate a
multi-level structure in survival models, as would, for instance be
needed in a multi-centre setting, where patients are from multiple
hospitals.

It also allows to model time-dependent covariates in a proportional
hazards survival model (using `coxph_imp`), also in combination with
additional grouping levels.

In time-dependent proportional hazards models,
last-observation-carried-forward is used to fill in missing values in
the time-varying covariates, and to determine the value of the covariate
at the event time. Preferably, all time-varying covariates should be
measured at baseline (`timevar = 0`). If a value for a time-varying
covariate needs to be filled in and there is no previous observation,
the next observation will be carried backward.

### Differences to basic regression models

It is not possible to specify transformations of outcome variables,
i.e., it is not possible to use a model formula like

    log(y) ~ x1 + x2 + ...

In the specific case of a transformation with the natural logarithm, a
log-normal model can be used instead of a normal model.

Moreover, it is not possible to use `.` to indicate that all variables
in a `data.frame` other than the outcome variable should be used as
covariates. I.e., a formula `y ~ .` is not valid in **JointAI**.

## Data structure

For multi-level settings, the data must be in long format, so that
repeated measurements are recorded in separate rows.

For survival data with time-varying covariates (`coxph_imp` and
`JM_imp`) the data should also be in long format. The survival/censoring
times and event indicator variables must be stored in separate variables
in the same data and should be constant across all rows referring to the
same subject.

During the pre-processing of the data the survival/censoring times will
automatically be merged with the observation times of the time-varying
covariates (which must be supplied via the argument `timevar`).

It is possible to have multiple time-varying covariates, which do not
have to be measured at the same time points, but there can only be one
`timevar`.

## Distribution families and link functions

|            |                                                 |
|------------|-------------------------------------------------|
| `gaussian` | with links: `identity`, `log`                   |
| `binomial` | with links: `logit`, `probit`, `log`, `cloglog` |
| `Gamma`    | with links: `inverse`, `identity`, `log`        |
| `poisson`  | with links: `log`, `identity`                   |

## Imputation methods / model types

Implemented model types that can be chosen in the argument `models` for
baseline covariates (not repeatedly measured) are:

|                        |                                                                                                                     |
|------------------------|---------------------------------------------------------------------------------------------------------------------|
| `lm`                   | linear (normal) model with identity link (alternatively: `glm_gaussian_identity`); default for continuous variables |
| `glm_gaussian_log`     | linear (normal) model with log link                                                                                 |
| `glm_gaussian_inverse` | linear (normal) model with inverse link                                                                             |
| `glm_logit`            | logistic model for binary data (alternatively: `glm_binomial_logit`); default for binary variables                  |
| `glm_probit`           | probit model for binary data (alternatively: `glm_binomial_probit`)                                                 |
| `glm_binomial_log`     | binomial model with log link                                                                                        |
| `glm_binomial_cloglog` | binomial model with complementary log-log link                                                                      |
| `glm_gamma_inverse`    | gamma model with inverse link for skewed continuous data                                                            |
| `glm_gamma_identity`   | gamma model with identity link for skewed continuous data                                                           |
| `glm_gamma_log`        | gamma model with log link for skewed continuous data                                                                |
| `glm_poisson_log`      | Poisson model with log link for count data                                                                          |
| `glm_poisson_identity` | Poisson model with identity link for count data                                                                     |
| `lognorm`              | log-normal model for skewed continuous data                                                                         |
| `beta`                 | beta model (with logit link) for skewed continuous data in (0, 1)                                                   |
| `mlogit`               | multinomial logit model for unordered categorical variables; default for unordered factors with \>2 levels          |
| `clm`                  | cumulative logit model for ordered categorical variables; default for ordered factors                               |

For repeatedly measured variables the following model types are
available:

|                         |                                                                                                                            |
|-------------------------|----------------------------------------------------------------------------------------------------------------------------|
| `lmm`                   | linear (normal) mixed model with identity link (alternatively: `glmm_gaussian_identity`); default for continuous variables |
| `glmm_gaussian_log`     | linear (normal) mixed model with log link                                                                                  |
| `glmm_gaussian_inverse` | linear (normal) mixed model with inverse link                                                                              |
| `glmm_logit`            | logistic mixed model for binary data (alternatively: `glmm_binomial_logit`); default for binary variables                  |
| `glmm_probit`           | probit model for binary data (alternatively: `glmm_binomial_probit`)                                                       |
| `glmm_binomial_log`     | binomial mixed model with log link                                                                                         |
| `glmm_binomial_cloglog` | binomial mixed model with complementary log-log link                                                                       |
| `glmm_gamma_inverse`    | gamma mixed model with inverse link for skewed continuous data                                                             |
| `glmm_gamma_identity`   | gamma mixed model with identity link for skewed continuous data                                                            |
| `glmm_gamma_log`        | gamma mixed model with log link for skewed continuous data                                                                 |
| `glmm_poisson_log`      | Poisson mixed model with log link for count data                                                                           |
| `glmm_poisson_identity` | Poisson mixed model with identity link for count data                                                                      |
| `glmm_lognorm`          | log-normal mixed model for skewed covariates                                                                               |
| `glmm_beta`             | beta mixed model for continuous data in (0, 1)                                                                             |
| `mlogitmm`              | multinomial logit mixed model for unordered categorical variables; default for unordered factors with \>2 levels           |
| `clmm`                  | cumulative logit mixed model for ordered factors; default for ordered factors                                              |

When models are specified for only a subset of the variables for which a
model is needed, the default model choices (as indicated in the tables)
are used for the unspecified variables.

## Parameters to follow (`monitor_params`)

See also the vignette: [Parameter
Selection](https://nerler.github.io/JointAI/articles/SelectingParameters.html)  

Named vector specifying which parameters should be monitored. This can
be done either directly by specifying the name of the parameter or
indirectly by one of the key words selecting a set of parameters. Except
for `other`, in which parameter names are specified directly, parameter
(groups) are just set as `TRUE` or `FALSE`.

Models are divided into two groups, the main models, which are the
models for which the user has explicitly specified a formula (via
`formula` or `fixed`), and all other models, for which models were
specified automatically.

If left unspecified, `monitor_params = c("analysis_main" = TRUE)` will
be used.

|                   |                                                                                                                                                                                                                                          |
|-------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **name/key word** | **what is monitored**                                                                                                                                                                                                                    |
| `analysis_main`   | `betas` and `sigma_main`, `tau_main` (for beta regression) or `shape_main` (for parametric survival models), `gamma_main` (for cumulative logit models), `D_main` (for multi-level models) and `basehaz` in proportional hazards models) |
| `analysis_random` | `ranef_main`, `D_main`, `invD_main`, `RinvD_main`                                                                                                                                                                                        |
| `other_models`    | `alphas`, `tau_other`, `gamma_other`, `delta_other`                                                                                                                                                                                      |
| `imps`            | imputed values                                                                                                                                                                                                                           |
| `betas`           | regression coefficients of the main analysis model                                                                                                                                                                                       |
| `tau_main`        | precision of the residuals from the main analysis model(s)                                                                                                                                                                               |
| `sigma_main`      | standard deviation of the residuals from the main analysis model(s)                                                                                                                                                                      |
| `gamma_main`      | intercepts in ordinal main model(s)                                                                                                                                                                                                      |
| `delta_main`      | increments of ordinal main model(s)                                                                                                                                                                                                      |
| `ranef_main`      | random effects from the main analysis model(s) `b`                                                                                                                                                                                       |
| `D_main`          | covariance matrix of the random effects from the main model(s)                                                                                                                                                                           |
| `invD_main`       | inverse(s) of `D_main`                                                                                                                                                                                                                   |
| `RinvD_main`      | matrices in the priors for `invD_main`                                                                                                                                                                                                   |
| `alphas`          | regression coefficients in the covariate models                                                                                                                                                                                          |
| `tau_other`       | precision parameters of the residuals from covariate models                                                                                                                                                                              |
| `gamma_other`     | intercepts in ordinal covariate models                                                                                                                                                                                                   |
| `delta_other`     | increments of ordinal intercepts                                                                                                                                                                                                         |
| `ranef_other`     | random effects from the other models `b`                                                                                                                                                                                                 |
| `D_other`         | covariance matrix of the random effects from the other models                                                                                                                                                                            |
| `invD_other`      | inverses of `D_other`                                                                                                                                                                                                                    |
| `RinvD_other`     | matrices in the priors for `invD_other`                                                                                                                                                                                                  |
| `other`           | additional parameters                                                                                                                                                                                                                    |

**For example:**  
`monitor_params = c(analysis_main = TRUE, tau_main = TRUE, sigma_main = FALSE)`
would monitor the regression parameters `betas` and the residual
precision `tau_main` instead of the residual standard deviation
`sigma_main`.

For a linear model, `monitor_params = c(imps = TRUE)` would monitor
`betas`, and `sigma_main` (because `analysis_main = TRUE` by default) as
well as the imputed values.

## Cumulative logit (mixed) models

In the default setting for cumulative logit models, i.e, `rev = NULL`,
the odds for a variable \\y\\ with \\K\\ ordered categories are defined
as \\\log\left(\frac{P(y_i \> k)}{P(y_i \leq k)}\right) = \gamma_k +
\eta_i, \quad k = 1, \ldots, K-1,\\ where \\\gamma_k\\ is a category
specific intercept and \\\eta_i\\ the subject specific linear predictor.

To reverse the odds to \\\log\left(\frac{P(y_i \leq k)}{P(y_i \>
k)}\right) = \gamma_k + \eta_i, \quad k = 1, \ldots, K-1,\\ the name of
the response variable has to be specified in the argument `rev`, e.g.,
`rev = c("y")`.

By default, proportional odds are assumed and only the intercepts differ
per category of the ordinal response. To allow for non-proportional
odds, i.e., \\\log\left(\frac{P(y_i \> k)}{P(y_i \leq k)}\right) =
\gamma_k + \eta_i + \eta\_{ki}, \quad k = 1, \ldots, K-1,\\ the argument
`nonprop` can be specified. It takes a one-sided formula or a list of
one-sided formulas. When a single formula is supplied, or a unnamed list
with just one element, it is assumed that the formula corresponds to the
main model. To specify non-proportional effects for linear predictors in
models for ordinal covariates, the list has to be named with the names
of the ordinal response variables.

For example, the following three specifications are equivalent and
assume a non-proportional effect of `C1` on `O1`, but `C1` is assumed to
have a proportional effect on the incomplete ordinal covariate `O2`:

    clm_imp(O1 ~ C1 + C2 + B2 + O2, data = wideDF, nonprop = ~ C1)
    clm_imp(O1 ~ C1 + C2 + B2 + O2, data = wideDF, nonprop = list(~ C1))
    clm_imp(O1 ~ C1 + C2 + B2 + O2, data = wideDF, nonprop = list(O1 = ~ C1))

To specify non-proportional effects on `O2`, a named list has to be
provided:

    clm_imp(O1 ~ C1 + C2 + B2 + O2 + B1, data = wideDF,
            nonprop = list(O1 = ~ C1,
                           O2 = ~ C1 + B1))

The variables for which a non-proportional effect is assumed also have
to be part of the regular model formula.

## Custom model parts

(Note: This feature is experimental and has not been fully tested yet.)

Via the argument `custom` it is possible to provide custom sub-models
that replace the sub-models that are automatically generated by
**JointAI**.

Using this feature it is, for instance, possible to use the value of a
repeatedly measured variable at a specific time point as covariate in
another model. An example would be the use of "baseline" cholesterol
(`chol` at `day = 0`) as covariate in a survival model.

First, the variable `chol0` is added to the `PBC` data. For most
patients the value of cholesterol at baseline is observed, but not for
all. It is important that the data has a row with `day = 0` for each
patient.

    PBC <- merge(PBC,
                 subset(PBC, day == 0, select = c("id", "chol")),
                 by = "id", suffixes = c("", "0"))

Next, the custom piece of JAGS model syntax needs to be specified. We
loop here only over the patients for which the baseline cholesterol is
missing.

    calc_chol0 <- "
    for (ii in 1:28) {
      M_id[row_chol0_id[ii], 3] <- M_lvlone[row_chol0_lvlone[ii], 1]
      }"

To be able to run the model with the custom imputation "model" for
baseline cholesterol we need to provide the numbers of the rows in the
data matrices that contain the missing values of baseline cholesterol
and the rows that contain the imputed cholesterol at `day = 0`:

    row_chol0_lvlone <- which(PBC$day == 0 & is.na(PBC$chol0))
    row_chol0_id <- match(PBC$id, unique(PBC$id))[row_chol0_lvlone]

Then we pass both the custom sub-model and the additional data to the
analysis function `coxph_imp()`. Note that we explicitly need to specify
the model for `chol`.

    coxph_imp(list(Surv(futime, status != "censored") ~ age + sex + chol0,
                   chol ~ age + sex + day + (day | id)),
              no_model = "day", data = PBC,
              append_data_list = list(row_chol0_lvlone = row_chol0_lvlone,
                                      row_chol0_id = row_chol0_id),
              custom = list(chol0 = calc_chol0))

## Note

### Coding of variables:

The default covariate (imputation) models are chosen based on the
`class` of each of the variables, distinguishing between `numeric`,
`factor` with two levels, unordered `factor` with \>2 levels and ordered
`factor` with \>2 levels.  

When a continuous variable has only two different values it is assumed
to be binary and its coding and default (imputation) model will be
changed accordingly. This behaviour can be overwritten specifying a
model type via the argument `models`.  

Variables of type `logical` are automatically converted to unordered
factors.  

#### Contrasts

**JointAI** version \\\geq\\ 1.0.0 uses the globally (via
`options("contrasts")`) specified contrasts. However, for incomplete
categorical variables, for which the contrasts need to be re-calculated
within the JAGS model, currently only `contr.treatment` and `contr.sum`
are possible. Therefore, when an in complete ordinal covariate is used
and the default contrasts
([`contr.poly()`](https://rdrr.io/r/stats/contrast.html)) are set to be
used for ordered factors, a warning message is printed and dummy coding
([`contr.treatment()`](https://rdrr.io/r/stats/contrast.html)) is used
for that variable instead.

### Non-linear effects and transformation of variables:

**JointAI** handles non-linear effects, transformation of covariates and
interactions the following way:  
When, for instance, a model formula contains the function `log(x)` and
`x` has missing values, `x` will be imputed and used in the linear
predictor of models for which no formula was specified, i.e., it is
assumed that the other variables have a linear association with `x`. The
[`log()`](https://rdrr.io/r/base/Log.html) of the observed and imputed
values of `x` is calculated and used in the linear predictor of the main
analysis model.  

If, instead of using `log(x)` in the model formula, a pre-calculated
variable `logx` is used, this variable is imputed directly and used in
the linear predictors of all models, implying that variables that have
`logx` in their linear predictors have a linear association with `logx`
but not with `x`.  

When different transformations of the same incomplete variable are used
in one model it is strongly discouraged to calculate these
transformations beforehand and supply them as different variables. If,
for example, a model formula contains both `x` and `x2` (where `x2` =
`x^2`), they are treated as separate variables and imputed with separate
models. Imputed values of `x2` are thus not equal to the square of
imputed values of `x`. Instead, `x` and `I(x^2)` should be used in the
model formula. Then only `x` is imputed and `x^2` is calculated from the
imputed values of `x` internally.

The same applies to interactions involving incomplete variables.

### Sequence of models:

Models generated automatically (i.e., not mentioned in `formula` or
`fixed` are specified in a sequence based on the level of the outcome of
the respective model in the multi-level hierarchy and within each level
according to the number of missing values. This means that level-1
variables have all level-2, level-3, ... variables in their linear
predictor, and variables on the highest level only have variables from
the same level in their linear predictor. Within each level, the
variable with the most missing values has the most variables in its
linear predictor.

### Not (yet) possible:

- prediction (using `predict`) conditional on random effects

- the use of splines for incomplete variables

- the use of (or equivalents for)
  [`pspline`](https://rdrr.io/pkg/survival/man/pspline.html), or
  [`strata`](https://rdrr.io/pkg/survival/man/strata.html) in survival
  models

- left censored or interval censored data

## See also

[`set_refcat`](set_refcat.md), [`traceplot`](traceplot.md),
[`densplot`](densplot.md), [`summary.JointAI`](summary.JointAI.md),
[`MC_error`](MC_error.md), [`GR_crit`](GR_crit.md),
[`predict.JointAI`](predict.JointAI.md),
[`add_samples`](add_samples.md), [`JointAIObject`](JointAIObject.md),
[`add_samples`](add_samples.md), [`parameters`](parameters.md),
[`list_models`](list_models.md)

Vignettes

- [Minimal
  Example](https://nerler.github.io/JointAI/articles/MinimalExample.html)

- [Model
  Specification](https://nerler.github.io/JointAI/articles/ModelSpecification.html)

- [Parameter
  Selection](https://nerler.github.io/JointAI/articles/SelectingParameters.html)

- [MCMC
  Settings](https://nerler.github.io/JointAI/articles/MCMCsettings.html)

- [After
  Fitting](https://nerler.github.io/JointAI/articles/AfterFitting.html)

- [Theoretical
  Background](https://nerler.github.io/JointAI/articles/TheoreticalBackground.html)

## Examples

``` r
# Example 1: Linear regression with incomplete covariates
mod1 <- lm_imp(y ~ C1 + C2 + M1 + B1, data = wideDF, n.iter = 100)


# Example 2: Logistic regression with incomplete covariates
mod2 <- glm_imp(B1 ~ C1 + C2 + M1, data = wideDF,
                family = binomial(link = "logit"), n.iter = 100)

if (FALSE) { # \dontrun{

# Example 3: Linear mixed model with incomplete covariates
mod3 <- lme_imp(y ~ C1 + B2 + c1 + time, random = ~ time|id,
                data = longDF, n.iter = 300)


# Example 4: Parametric Weibull survival model
mod4 <- survreg_imp(Surv(time, status) ~ age + sex + meal.cal + wt.loss,
                    data = survival::lung, n.iter = 100)


# Example 5: Proportional hazards survival model
mod5 <- coxph_imp(Surv(time, status) ~ age + sex + meal.cal + wt.loss,
                    data = survival::lung, n.iter = 200)

# Example 6: Joint model for longitudinal and survival data
mod6 <- JM_imp(list(Surv(futime, status != 'censored') ~ age + sex +
                    albumin + copper + trig + (1 | id),
                    albumin ~ day + age + sex + (day | id)),
                    timevar = 'day', data = PBC, n.iter = 100)

# Example 7: Proportional hazards  model with a time-dependent covariate
mod7 <- coxph_imp(Surv(futime, status != 'censored') ~ age + sex + copper +
                  trig + stage + (1 | id),
                  timevar = 'day', data = PBC, n.iter = 100)



# Example 8: Parallel computation
# If no strategy how the "future" should be handled is specified, the
# MCMC chains are run sequentially.
# To run MCMC chains in parallel, a strategy can be specified using the
# package \pkg{future} (see ?future::plan), for example:
future::plan(future::multisession, workers = 4)
mod8 <- lm_imp(y ~ C1 + C2 + B2, data = wideDF, n.iter = 500, n.chains = 8)
mod8$comp_info$future
# To re-set the strategy to sequential computation, the sequential strategy
# can be specified:
future::plan(future::sequential)

} # }
```
