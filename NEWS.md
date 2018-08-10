# JointAI 0.2.1

## Bug fixes
* `monitor_params` is now checked to avoid problems when only part of the main parameters is selected
* categorical imputation models now use min-max trick to prevent probabilities outside [0, 1]
* initial value generation for logistic analysis model fixed
* `lm_imp()`, `glm_imp()` and `lme_imp()` return family and link that was used (needed in for `add_sample`)
* bugfix in re-ordering columns when a function is part of the linear predictor
* bugfix in intial values for categorical covariates
* bugfix in finding imputation method when function of variable is specified as
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

## Extensions
* `plot_all()` function added
* `densplot()` and `traceplot()` optional with ggplot
* `densplot()` option to combine chains before plotting
* example datasets `NHANES`, `simLong` and `simWide` added
* `list_impmodels` to print information on the imputation models and hyperparameters
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
