# JointAI (development version)

* clean-up of helper functions and additional unit tests
* fix typos in argument names in helpfiles
* fix documentation syntax (CRAN NOTEs)

--------------------------------------------------------------------------------



# JointAI 1.0.5

(update request by CRAN)

* use a wrapper for `bs()` to avoid warning in CMD check when run on older version
  of R where `splines::bs()` did not yet have the argument `warn.outside`.

--------------------------------------------------------------------------------

# JointAI 1.0.4

## New features
* `md_pattern()` has an additional argument `sort_columns` to provide the option
  to switch off the sorting of columns by number of missing values.
* `sum_duration()`: new function to get sum of computational time across chains,
  phases, runs, ...

## Bug fixes
* `formula()` now also return the model formula when `add_samples()` is used.
* `JM_imp()` with ordinal longitudinal outcome is not using the correct 
  version of the linear predictor in the quadrature procedure approximating the
  integral in the survival.
* Bug causing the wrong elements of the data matrix to be monitored when 
  `monitor_params(imps = TRUE)` in survival models fixed.
* `predDF()`: bugfix for models including auxiliary variables (which were
   previously not included into the data)  
* `nonprop`: bugfix for non-proportional effects in covariate models

## Small improvements
* Use of `add_samples()` will now result in the `call` element of a `JointAI`
  object being a `list` and no longer a nested list.
* Re-structuring of the JAGS model code for proportional hazards models to
  reduce computational time.
* change in how parallel computation is done: does not rely on **doFuture** and
  **foreach** any more, only package **future** is required.
* `comp_info` element of fitted `JointAI` object has changed due to the changes
  in parallel computing, and computational time is not reported separately for
  the adaptive phase and the sampling phase, and separately per chain when
  parallel computation was used.
* `predict()` is now a lot faster for proportional hazards models.


-----------------------------------------------------------------------------

# JointAI 1.0.3


## New features
* `custom`: new argument in the main analysis functions that allows the user
  to replace the JAGS syntax for sub-models with custom syntax. The argument
  expects a named list where the names are the names of the variables 
  for which the custom model will be used. This feature requires some knowledge
  of JAGS syntax.
* `append_data_list`: new argument in the main analysis functions that allows
  the user to add elements to the list of data that is passed to JAGS. This 
  may be necessary for custom sub-models.
* `rd_vcov`: new argument in the main analysis functions that allows the 
  specification of the structure of the random effects variance-covariance
  matrices in (multivariate) mixed models (and joint models).



## Minor improvements and bug fixes
* Bug fix in re-scaling of random effects variance covariance matrix in
  multi-level models with >2 levels where some levels have only random intercept.
* Bug fix in generating the names of random effect nodes to monitor when there
  are multiple analysis models and some do not have random effects.
* Bug fix in `plot_all()` not displaying the variable name in the message shown
  for character string variables.
* Bug fix in `set_refcat()`: wasn't displaying the factor labels correctly
* `print.JointAI`: bugfix for multivariate mixed models with full
  variance-covariance matrix of the random effects that had the same number of
  random effects for each outcome, for which the printing of this matrix
  resulted in an error.
* Bug fix: when using a function of a variable as auxiliary this is now (again)
  correctly used as covariate in the linear predictor of covariate models (bug
  was introduced in commit 15014dcd)



-----------------------------------------------------------------------------

# JointAI 1.0.2

## New features
* `rd_vcov()`: new function added to extract the random effect variance-
  covariance matrices (posterior means)

## Minor improvements and bug fixes
* change in the way the model formula is contained in the model call, which 
  should make it possible to call `*_imp()` functions from within another
  function that has the model formula as an argument.
* fixed issue that resulted in an error when the data was previously attached
  to the search path


--------------------------------------------------------------------------------


# JointAI 1.0.1

## Minor improvements and bug fixes
* `data_list`: omit data matrix `M_*` from `data_list` if `ncol == 0`
* `data_list`: syntax to checking which `pos_*` to include can handle the case
  with multiple grouping variables being on the same, lowest level; 
  before `pos_*` was excluded for only one of them
* random effects: it is now possible to use different grouping levels in
  different sub-models (when providing a list of model formulas)
* `add_samples()`: remove unnecessary call to `doFuture::registerDoFuture()`
* `predDF()` bug fix: the parameter for all methods is now called `object`
* `list_models()` now also works for errored JointAI objects
* Bug fix for models with an interaction between a repeatedly measured variable
  and a random slope variable. (The term was wrongly written in the mean 
  structure for the random effect instead of the main linear predictor.)

--------------------------------------------------------------------------------


# JointAI 1.0.0

This version of **JointAI** contains some major changes. To extend the package
it was necessary to change the internal structure and it was not possible to 
assure backward compatibility.

## New features
### New analysis model types
* `betareg_imp()`: beta regression
* `betamm_imp()`: beta mixed model
* `lognorm_imp()`: log-normal regression model
* `lognormmm_imp()`: log-normal mixed model
* `mlogit_imp()`: multinomial logit model
* `mlogitmm_imp()`: multinomial mixed model
* `JM_imp()`: joint model for longitudinal and survival data

### Hierarchical models with multiple levels of grouping
It is now possible to fit **hierarchical models with more than one level of
grouping**, with nested as well as crossed random effects (check [the help
file](https://nerler.github.io/JointAI/reference/model_imp.html)) of the main
model function for details on how to specify such random effects structures.

This does also apply to survival models, i.e., it is possible to specify a
random effects structure to model survival outcomes in data with a hierarchical
structure, e.g., in a multi-centre setting.

### Proportional hazards model with time-dependent covariates
`coxph_imp()` can now handle **time-dependent covariates** using
last-observation-carried-forward. This requires to add `(1 | <id variable>)` to
the model formula to identify which rows belong to the same subject, and to
specify the argument `timevar` to identify the variable that contains the
observation time of the longitudinal measurements.

### Multivariate models
By providing a list of model formulas it is possible to fit multiple 
analysis models (of different types) simultaneously. The models can share
covariates and it is possible to have the response of one model as covariate
in another model (in a sequential manner, however, not circular).

### Partial proportional odds models for ordinal responses
As before, proportional odds are assumed by default for all covariates of a 
cumulative logit model. The argument `nonprop` accepts a one-sided formula or 
a named list of one-sided formulas in which the covariates are specified for
which non-proportional odds should be assumed.

Additionally, the argument `rev` is available to specify a vector of 
names of ordinal responses for which the odds should be inverted.
For details, see the [the help
file](https://nerler.github.io/JointAI/reference/model_imp.html).


### Other new features
* The functions `lmer_imp()` and `glmer_imp()` are aliases for `lme_imp()` 
  and `glme_imp()`.
* All mixed models can be specified using the **nlme** type specification
  (using `fixed` and `random`) as well as using specification as in **lme4**
  (with a combined model formula for fixed and random effects).
* The argument `df_basehaz` in `coxph_imp()` and `JM_imp()` allows setting the
  number of degrees of freedom in the B-spline basis used to model the 
  baseline hazard.
* The global setting `options("contrasts")` is no longer ignored. For completely
  observed covariates, any of the contrasts available in base R are possible
  and `options("contrasts")` is used to determine which contrasts to use.
  For covariates with missing values, effect coding (`contr.sum`) and 
  dummy coding (`contr.treatment`) are possible. 
  This means that for completely observed ordered factors the default is
  `contr.poly`, but for incomplete ordered factors the default is
  `contr.treatment`.
  

## Other changes
* Within `summary()`, the argument `multivariate` to the function `GR_crit()` is
  now set to `FALSE` to avoid issues. The multivariate version can still be 
  obtained by using `GR_crit()` directly.
* The parameters of the baseline hazard for `coxph_imp()` and `JM_imp()`
  are monitored automatically when "analysis_main = TRUE".
* The function `get_models()` is no longer exported because it now requires 
  more input variables and is no longer convenient to use. To obtain the default
  specification of the model types use one of the main functions (`*_imp()`),
  set `n.adapt = 0` (and `n.iter = 0`), and obtain the model types as
  `<mymodel>$models`.
* `list_models()` now returns information on all sub-models, including the 
  main analysis models (previously it included only information on covariates).
* The output of `parameters()` has changed. The function returns a list of 
  matrices, one per analysis model, with information on the response variable,
  response category, name of the regression coefficient and its associated
  covariate.
* The argument `missinfo = TRUE` in `summar()` adds information on the missing
  values in the data involved in a JointAI model (number and proportion of 
  complete cases, number and proportion of missing values per variable).
* The argument `ridge` has changed to `shrinkage`. If `shrinkage = "ridge"`,
  a ridge prior is used for all regression coefficients in all sub-models.
  If a vector of response variable names is provided to `shinkage`, ridge 
  priors are only used for the coefficients in these models.
* `default_hyperpars()`: The default hyper-parameters for random effects are no
  longer provided as a function but more consistently with the hyper-parameters
  for other model parts, as a vector (within the list of all hyper-parameters).
* `default_hyperpars()`: **the default number of degrees of freedom in the
  Wishart distribution used for the inverse of the random effects covariance
  matrix is now the number of random effects + 1 (was the number of random
  effects before).**
* The effect of using a `seed` in **JointAI** is now only local, i.e., in
  functions in which `set.seed()` is called, the random number generator state
  `.Random.seed` before setting the seed is recorded, and re-set to that value
  on exiting the function.
* In `predDF()` the argument `var` has changed to `vars` and expects a 
  formula. This extends the functionality of `predDF()` to let multiple
  variables vary.
* Some of the elements of a `JointAI` object have changed. Potentially relevant
  for users:
    * `JointAI` objects now contain information on the computational time and
      environment they were run in: the element `comp_info` contains the
      time-stamp the model was fitted, the duration of the computation, the
      JointAI version number and the R session info.
    * The JAGS model is stored as character string in the element `jagsmodel`.
* The arguments `warn` and `mess` now also affect the output of **rjags**.
* The **doFuture** package is used for parallel computation instead of
  **doParallel**. Parallel computation is specified by setting a
  `future::plan()` for how the "future" should be handled. As a consequence,
  the arguments `parallel` and `n.cores` are no longer used. Information on the
  setting that was used with regards to parallel computation is returned in a
  `JointAI object` via `comp_list$future`.
    
  
## Bug fixes
* Scaling of continuous covariates is no longer done in the data, but in the 
  JAGS model. This fixes the issue that previously the estimated variance 
  parameters of continuous covariates and variance parameters of their random
  effects were incorrect (this issue only affected the covariate models, not the
  main analysis model).


--------------------------------------------------------------------------------

# JointAI 0.6.1

## Bug fixes
* Fixed bug that messed up coefficients in `clmm` covariate model when there are
  no baseline covariates in the model
* enable `newdata` for `predict()` that does not contain the outcome variable
* `add_samples()`: calculation of `end()` of MCMC samples fixed

--------------------------------------------------------------------------------

# JointAI 0.6.0

## Bug fixes
* bug in `add_samples()` when used in parallel with thinning fixed
* bug fixed that occurred when a complete longitudinal categorical variable was
  used in a model that did not contain any incomplete baseline variables
* bug-fix for monitoring random effects
* fixed typo in selecting parameters in Gamma models
* `predict()` can now handle `newdata` with missing outcome values; predicted
  values for cases with missing covariates are `NA` (prediction with incomplete
  covariates is planned to be implemented in the future)
* bug-fix for `get_MIdat()` and `plot_imp_distr()` when only one variable has missing values
* bug-fix for longitudinal model with interaction with random slope variable
* bug-fix for model with multiple longitudinal ordinal incomplete covariates
 (fixed wrong selection of columns of the design matrix of longitudinal covariates
  in these models)

## Minor changes
* moved message about bug reports to startup
* enabled inverse link by adding max restriction
* ":" in factor labels are automatically replaced by "_"
* argument `ncores` has changed to `n.cores` for consistency with `n.iter`, `n.chains`, etc.
* `coxph_imp()` does no longer use a counting process implementation but uses the
  likelihood in JAGS directly via the zeros trick


## New Features / Extensions
* `predict()` now has an argument `length` to change number of evaluation points
* `summary()`, `predict()`, `traceplot()`, `densplot()`, `GR_crit()`, `MC_error()`
   now have an argument `exclude_chains` that allows to specify chains that should be omitted
* `citation()` now refers to a manuscript on arXiv
* `glmm_lognorm` available to impute level-1 covariates with a log-normal mixed model
* methods `residuals()` and `plot()` available for (some of the) main analysis types (details see documentation)
* argument `models` added to `get_models()` so that the user can specify to also
  include models for complete covariates (which are then positioned in the 
  sequence of models according to the systematic used in **JointAI**).
  Specification of a model not needed for imputation prints a notification.
* `JointAI` objects (most types) now also include residuals and fitted values (so far, only using fixed effects)

--------------------------------------------------------------------------------

# JointAI 0.5.2

## Bug fixes
* Error message in `print.JointAI` fixed

--------------------------------------------------------------------------------

# JointAI 0.5.1

## Bug fixes
* bug in ordinal models with only completely observed variables fixed 
  (all necessary data is not passed to JAGS)
* enable thinning when using parallel sampling
* matrix `Xl` is no longer included in `data_list` when it is not used in the model
* bug-fix in `subset` when specified as vector
* bug-fix in ridge regression (gave an error message)
* bug-fix in recognition of binary factors that are coded as numeric and have missing values
* bug-fix in `summary`: range of iterations is printed correctly now when argument `end` is used
* bug-fix: error that occurred in re-scaling when reference category was changed is solved
* bug-fix in survival models: coding of censoring variable fixed


## Minor changes
* `summary()` calls `GR_crit()` with argument `autoburnin = FALSE` unless specified otherwise via `...`
* when `inits` is specified as a function, the function is evaluated and the resulting list passed to JAGS (previously the function was passed to JAGS)
* the example data `simong` and `simWide` have changed (more variables, less subjects)
* added check if there are incomplete covariates before setting `imp_pars = TRUE`
  (when user specified via `monitor_params` or `subset`)
* in `survreg_imp` the sign of the regression coefficient is now opposite to match the one from `survreg`

--------------------------------------------------------------------------------

# JointAI 0.5.0
 
## Important
* the argument `meth` has changed to `models`

## Bug fixes
* `add_samples()`: bug that copied the last chain to all other chains fixed
* bug-fix for the order of columns in the matrix `Xc`, so that specification of
  functions of covariates in auxiliary variables works better
* adding vertical lines to a `densplot()` issue (all plots showed all lines) fixed
* nested functions involving powers made possible
* typo causing issue in poisson glm and glme removed

## Minor changes
* `plot_all()`, `densplot()`, and `traceplot()` limit the number of plots on one
  page to 64 when rows and columns of the layout are not user specified (to 
  avoid the 'figure margins too large' error)
* change in `longDF` example data: new version containing complete and incomplete
  categorical longitudinal variables (and variable names L1 and L2 changed to c1 and c2)
* Some minor changes in notes, warnings and error messages
* The function `list_impmodels()` changed to `list_models()`
  (but `list_impmodels()` is kept as an alias for now)
* improved handling of functional forms of covariates (also in longitudinal 
  covariates and random effects)


## New Features / Extensions
* `clm_imp()` and `clmm_imp()`: new functions for analysis of **ordinal (mixed) models**
* It is now possible to impute **incomplete longitudinal covariates**
  (continuous, binary and ordered factors).
* `coxph_imp()`: new function to fit Cox proportional hazards models with 
  incomplete (baseline) covariates
* Argument `no_model` allows to specify names of completely observed variables
  for which no model should be specified (e.g., "time" in a mixed model)
* **Shrinkage:** argument `ridge = TRUE` allows to use shrinkage priors on the 
  precision of the regression coefficients in the analysis model
* `plot_all()` can now handle variables from classes `Date` and `POSIXt`
* new argument `parallel` allows different MCMC chains to be sampled in parallel
* new argument `ncores` allows to specify the maximum number of cores to be used
* new argument `seed` added for reproducible results; also a sampler (`.RNG.name`)
  and seed value for the sampler (`.RNG.seed`) are set or added to user-provided
  initial values (necessary for parallel sampling and reproducibility of results)
* `plot_imp_distr()`: new function to plot distribution of observed and imputed values

--------------------------------------------------------------------------------


# JointAI 0.4.0

## Bug fixes
* `RinvD` is no longer selected to be monitored in random intercept model (`RinvD` is not used in such a model)
* fixed various bugs for models in which only the intercept is used (no covariates)

## Minor changes
* `summary()`: reduced default number of digits
* continuous variables with two distinct values are converted to factor
* argument `meth` now uses default values if only specified for subset of incomplete variables
* `get_MIdat()`: argument `minspace` added to ensure spacing of iterations selected as imputations
* `densplot()`: accepts additional options, e.g., `lwd`, `col`, ...
* `list_models()` replaces the function `list_impmodels()` (which is now an alias)


## Extensions
* `coef()` method added for `JointAI` object and `summary.JointAI` object
* `confint()` method added for `JointAI` object
* `print()` method added for `JointAI` object
* `survreg_imp()` added to perform analysis of parametric (Weibull) survival models
* `glme_imp()` added to perform generalized linear mixed modelling
* extended documentation; two new vignettes on MCMC parameters and functions for after the model is estimated;
  added messages about coding of ordinal variables


--------------------------------------------------------------------------------

# JointAI 0.3.4

## Bug fixes
* `traceplot()`, `densplot()`: specification of `nrow` AND `ncol` possible;
  fixed bug when only `nrow` specified

# JointAI 0.3.3

## Bug fixes
* remove deprecated code specifying `contrast.arg` that now in some cases cause error
* fixed problem identifying non-linear functions in formula when the name of
  another variable contains the function name

--------------------------------------------------------------------------------
# JointAI 0.3.2

## Bug fixes
* `lme_imp()`: fixed error in JAGS model when interaction between random slope
   variable and longitudinal variable 

## Minor changes
* unused levels of factors are dropped 
 
--------------------------------------------------------------------------------
# JointAI 0.3.1

## Bug fixes
* `plot_all()` uses correct level-2 %NA in title
* `simWide`: case with no observed `bmi` values removed
* `traceplot()`, `densplot()`: `ncol` and `nrow` now work with `use_ggplot = TRUE`
* `traceplot()`, `densplot()`: error in specification of `nrow` fixed
* `densplot()`: use of color fixed
* functions with argument `subset` now return random effects covariance matrix correctly
* `summary()` displays output with row name when only one node is returned and
  fixed display of `D` matrix
* `GR_crit()`: Literature reference corrected
* `predict()`: prediction with varying factor fixed
* no scaling for variables involved in a function to avoid problems with re-scaling

## Minor changes
* `plot_all()` uses `xpd = TRUE` when printing text for character variables
* `list_impmodels()` uses line break when output of predictor variables exceeds
  `getOption("width")`
* `summary()` now displays tail-probabilities for off-diagonal elements of `D`
* added option to show/hide constant effects of auxiliary variables in plots
* `predict()`: now also returns `newdata` extended with prediction

  
--------------------------------------------------------------------------------
# JointAI 0.3.0

## Bug fixes
* `monitor_params` is now checked to avoid problems when only part of the main
  parameters is selected
* categorical imputation models now use min-max trick to prevent probabilities
  outside [0, 1]
* initial value generation for logistic analysis model fixed
* bug-fix in re-ordering columns when a function is part of the linear predictor
* bug-fix in initial values for categorical covariates
* bug-fix in finding imputation method when function of variable is specified as
  auxiliary variable

## Minor changes
* `md.pattern()` now uses ggplot, which scales better than the previous version
* `lm_imp()`, `glm_imp()` and `lme_imp()` now ask about overwriting a model file
* `analysis_main = T` stays selected when other parameters are followed as well
* `get_MIdat()`: argument `include` added to select if original data are included
  and id variable `.id` is added to the dataset
* `subset` argument uses same logit as `monitor_params` argument
* added switch to hide messages; distinction between messages and warnings
* `lm_imp()`, `glm_imp()` and `lme_imp()` now take argument `trunc` in order
  to truncate the distribution of incomplete variables
* `summary()` now omits auxiliary variables from the output
* `imp_par_list` is now returned from JointAI models
* `cat_vars` is no longer returned from `lm_imp()`, `glm_imp()` and `lme_imp()`,
  because it is contained in `Mlist$refs`

## Extensions
* `plot_all()` function added
* `densplot()` and `traceplot()` optional with ggplot
* `densplot()` option to combine chains before plotting
* example datasets `NHANES`, `simLong` and `simWide` added
* `list_impmodels` to print information on the imputation models and hyper-parameters
* `parameters()` added to display the parameters to be/that were monitored
* `set_refcat()` added to guide specification of reference categories
* extension of possible functions of variables in model formula to (almost all)
  functions that are available in JAGS
* added vignettes *Minimal Example*, *Visualizing Incomplete Data*,
  *Parameter Selection* and *Model Specification*


--------------------------------------------------------------------------------
# JointAI 0.2.0
## Bug fixes
* `md_pattern()`: does not generate duplicate plot any more
* corrected names of imputation methods in help file
* scaling when no continuous covariates are in the model or scaling is deselected fixed
* initial value specification for coefficient for auxiliary variables fixed
* `get_MIdat()`: imputed values are now filled in in the correct order
* `get_MIdat()`: variables imputed with `lognorm` are now included when extracting an imputed dataset
* `get_MIdat()`: imputed values of transformed variables are now included in imputed datasets
* problem with non valid names of factor labels fixed
* data matrix is now ordered according to order in user-specified `meth` argument

## Minor changes
* `md.pattern()`: adaptation to new version of `md.pattern()` from the **mice** package
* internally change all `NaN` to `NA`
* allow for scaling of incomplete covariates with quadratic effects
* changed hyperparameter for precision in models with logit link from 4/9 to 0.001

## Extensions
* `gamma` and `beta` imputation methods implemented
