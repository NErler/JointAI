# Fitted object of class 'JointAI'

An object returned by one of the main functions [`*_imp`](model_imp.md).

## Value

- `analysis_type`:

  `lm`, `glm`, `clm`, `lme`, `glme`, `clmm`, `survreg` or `coxph` (with
  attributes `family` and `link` for GLM-type models

- `formula`:

  The formula used in the (analysis) model.

- `data`:

  original (incomplete, but pre-processed) data

- `models`:

  named vector specifying the the types of all sub-models

- `fixed`:

  a list of the fixed effects formulas of the sub-model(s) for which the
  use had specified a formula

- `random`:

  a list of the random effects formulas of the sub-model(s) for which
  the use had specified a formula

- `Mlist`:

  a list (for internal use) containing the data and information
  extracted from the data and model formulas, split up into

  - a named vector identifying the levels (in the hierarchy) of all
    variables (`Mlvls`)

  - a vector of the id variables that were extracted from the random
    effects formulas (`idvar`)

  - a list of grouping information for each grouping level of the data
    (`groups`)

  - a named vector identifying the hierarchy of the grouping levels
    (`group_lvls`)

  - a named vector giving the number of observations on each level of
    the hierarchy (`N`)

  - the name of the time variable (only for survival models with
    time-varying covariates) (`timevar`)

  - a formula of auxiliary variables (`auxvars`)

  - a list specifying the reference categories and dummy variables for
    all factors involved in the models (`refs`)

  - a list of linear predictor information (column numbers per design
    matrix) for all sub-models (`lp_cols`)

  - a list identifying information for interaction terms found in the
    model formulas (`interactions`)

  - a `data.frame` containing information on transformations of
    incomplete variables (`trafos`)

  - a `data.frame` containing information on transformations of all
    variables (`fcts_all`)

  - a logical indicator if parameter for posterior predictive checks
    should be monitored (`ppc`; not yet used)

  - a vector specifying if shrinkage of regression coefficients should
    be performed, and if so for which models and what type of shrinkage
    (`shrinkage`)

  - the number of degrees of freedom to be used in the spline
    specification of the baseline hazard in proportional hazards
    survival models (`df_basehaz`)

  - a list of matrices, one per level of the data, specifying centring
    and scaling parameters for the data (`scale_pars`)

  - a list containing information on the outcomes (mostly relevant for
    survival outcomes; `outcomes`)

  - a list of terms objects, needed to be able to build correct design
    matrices for the Gauss-Kronrod quadrature when, for example, splines
    are used to model time in a joint model (`terms_list`)

- `par_index_main`:

  a list of matrices specifying the indices of the regression
  coefficients for each of the main models per design matrix

- `par_index_other`:

  a list of matrices specifying the indices of regression coefficients
  for each covariate model per design matrix

- `jagsmodel`:

  The JAGS model as character string.

- `mcmc_settings`:

  a list containing MCMC sampling related information with elements

  `modelfile`:

  :   path and name of the JAGS model file

  `n.chains`:

  :   number of MCMC chains

  `n.adapt`:

  :   number of iterations in the adaptive phase

  `n.iter`:

  :   number of iterations in the MCMC sample

  `variable.names`:

  :   monitored nodes

  `thin`:

  :   thinning interval of the MCMC sample

  `inits`:

  :   a list containing the initial values that were passed to **rjags**

- `monitor_params`:

  the named list of parameter groups to be monitored

- `data_list`:

  list with data that was passed to **rjags**

- `hyperpars`:

  a list containing the values of the hyper-parameters used

- `info_list`:

  a list with information used to write the imputation model syntax

- `coef_list`:

  a list relating the regression coefficient vectors used in the JAGS
  model to the names of the corresponding covariates

- `model`:

  the JAGS model (an object of class 'jags', created by **rjags**)

- `sample`:

  MCMC sample on the sampling scale (included only if
  `keep_scaled_sample = TRUE`)

- `MCMC`:

  MCMC sample, scaled back to the scale of the data

- `comp_info`:

  a list with information on the computational setting (`start_time`:
  date and time the calculation was started, `duration`: computational
  time of the model adaptive and sampling phase, `JointAI_version`:
  package version, `R_version`: the `R.version.string`, `parallel`:
  whether parallel computation was used, `workers`: if parallel
  computation was used, the number of workers)

- `fitted.values`:

  fitted/predicted values (if available)

- `residuals`:

  residuals (if available)

- `call`:

  the original call
