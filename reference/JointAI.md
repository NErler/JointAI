# JointAI: Joint Analysis and Imputation of Incomplete Data

The **JointAI** package performs simultaneous imputation and inference
for incomplete or complete data under the Bayesian framework. Models for
incomplete covariates, conditional on other covariates, are specified
automatically and modelled jointly with the analysis model. MCMC
sampling is performed in ['JAGS'](https://mcmc-jags.sourceforge.io/) via
the R package [**rjags**](https://CRAN.R-project.org/package=rjags).

## Main functions

**JointAI** provides the following main functions that facilitate
analysis with different models:

- [`lm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  for linear regression

- [`glm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  for generalized linear regression

- [`betareg_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  for regression using a beta distribution

- [`lognorm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  for regression using a log-normal distribution

- [`clm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  for (ordinal) cumulative logit models

- [`mlogit_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  for multinomial models

- [`lme_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  or
  [`lmer_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  for linear mixed models

- [`glme_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  or
  [`glmer_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  for generalized linear mixed models

- [`betamm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  for mixed models using a beta distribution

- [`lognormmm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  for mixed models using a log-normal distribution

- [`clmm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  for (ordinal) cumulative logit mixed models

- [`survreg_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  for parametric (Weibull) survival models

- [`coxph_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  for (Cox) proportional hazard models

- [`JM_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  for joint models of longitudinal and survival data

As far as possible, the specification of these functions is analogous to
the specification of widely used functions for the analysis of complete
data, such as [`lm`](https://rdrr.io/r/stats/lm.html),
[`glm`](https://rdrr.io/r/stats/glm.html),
[`lme`](https://rdrr.io/pkg/nlme/man/lme.html) (from the package
[**nlme**](https://CRAN.R-project.org/package=nlme)),
[`survreg`](https://rdrr.io/pkg/survival/man/survreg.html) (from the
package [**survival**](https://CRAN.R-project.org/package=survival)) and
[`coxph`](https://rdrr.io/pkg/survival/man/coxph.html) (from the package
[**survival**](https://CRAN.R-project.org/package=survival)).

Computations can be performed in parallel to reduce computational time,
using the package future, the argument `shrinkage` allows the user to
impose a penalty on the regression coefficients of some or all models
involved, and hyper-parameters can be changed via the argument
`hyperpars`.

To obtain summaries of the results, the functions
[`summary()`](https://nerler.github.io/JointAI/reference/summary.JointAI.md),
[`coef()`](https://nerler.github.io/JointAI/reference/summary.JointAI.md)
and
[`confint()`](https://nerler.github.io/JointAI/reference/summary.JointAI.md)
are available, and results can be visualized with the help of
[`traceplot()`](https://nerler.github.io/JointAI/reference/traceplot.md)
or
[`densplot()`](https://nerler.github.io/JointAI/reference/densplot.md).

The function
[`predict()`](https://nerler.github.io/JointAI/reference/predict.JointAI.md)
allows prediction (including credible intervals) from `JointAI` models.

## Evaluation and export

Two criteria for evaluation of convergence and precision of the
posterior estimate are available:

- [`GR_crit`](https://nerler.github.io/JointAI/reference/GR_crit.md)
  implements the Gelman-Rubin criterion ('potential scale reduction
  factor') for convergence

- [`MC_error`](https://nerler.github.io/JointAI/reference/MC_error.md)
  calculates the Monte Carlo error to evaluate the precision of the MCMC
  sample

Imputed data can be extracted (and exported to SPSS) using
[`get_MIdat()`](https://nerler.github.io/JointAI/reference/get_MIdat.md).
The function
[`plot_imp_distr()`](https://nerler.github.io/JointAI/reference/plot_imp_distr.md)
allows visual comparison of the distribution of observed and imputed
values.

## Other useful functions

- [`parameters`](https://nerler.github.io/JointAI/reference/parameters.md)
  and
  [`list_models`](https://nerler.github.io/JointAI/reference/list_models.md)
  to gain insight in the specified model

- [`plot_all`](https://nerler.github.io/JointAI/reference/plot_all.md)
  and
  [`md_pattern`](https://nerler.github.io/JointAI/reference/md_pattern.md)
  to visualize the distribution of the data and the missing data pattern

## Vignettes

The following vignettes are available

- [*Minimal
  Example*](https://nerler.github.io/JointAI/articles/MinimalExample.html):  
  A minimal example demonstrating the use of
  [`lm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md),
  [`summary.JointAI`](https://nerler.github.io/JointAI/reference/summary.JointAI.md),
  [`traceplot`](https://nerler.github.io/JointAI/reference/traceplot.md)
  and
  [`densplot`](https://nerler.github.io/JointAI/reference/densplot.md).

- [*Visualizing Incomplete
  Data*](https://nerler.github.io/JointAI/articles/VisualizingIncompleteData.html):  
  Demonstrations of the options in
  [`plot_all`](https://nerler.github.io/JointAI/reference/plot_all.md)
  (plotting histograms and bar plots for all variables in the data) and
  [`md_pattern`](https://nerler.github.io/JointAI/reference/md_pattern.md)
  (plotting or printing the missing data pattern).

- [*Model
  Specification*](https://nerler.github.io/JointAI/articles/ModelSpecification.html):  
  Explanation and demonstration of all parameters that are required or
  optional to specify the model structure in
  [`lm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md),
  [`glm_imp`](https://nerler.github.io/JointAI/reference/model_imp.md)
  and
  [`lme_imp`](https://nerler.github.io/JointAI/reference/model_imp.md).
  Among others, the functions
  [`parameters`](https://nerler.github.io/JointAI/reference/parameters.md),
  [`list_models`](https://nerler.github.io/JointAI/reference/list_models.md)
  and
  [`set_refcat`](https://nerler.github.io/JointAI/reference/set_refcat.md)
  are used.

- [*Parameter
  Selection*](https://nerler.github.io/JointAI/articles/SelectingParameters.html):  
  Examples on how to select the parameters/variables/nodes to follow
  using the argument `monitor_params` and the parameters/variables/nodes
  displayed in the [`summary`](https://rdrr.io/r/base/summary.html),
  [`traceplot`](https://nerler.github.io/JointAI/reference/traceplot.md),
  [`densplot`](https://nerler.github.io/JointAI/reference/densplot.md)
  or when using
  [`GR_crit`](https://nerler.github.io/JointAI/reference/GR_crit.md) or
  [`MC_error`](https://nerler.github.io/JointAI/reference/MC_error.md).

- [*MCMC
  Settings*](https://nerler.github.io/JointAI/articles/MCMCsettings.html):  
  Examples demonstrating how to set the arguments controlling settings
  of the MCMC sampling, i.e., `n.adapt`, `n.iter`, `n.chains`, `thin`,
  `inits`.

- [*After
  Fitting*](https://nerler.github.io/JointAI/articles/AfterFitting.html):  
  Examples on the use of functions to be applied after the model has
  been fitted, including
  [`traceplot`](https://nerler.github.io/JointAI/reference/traceplot.md),
  [`densplot`](https://nerler.github.io/JointAI/reference/densplot.md),
  [`summary`](https://rdrr.io/r/base/summary.html),
  [`GR_crit`](https://nerler.github.io/JointAI/reference/GR_crit.md),
  [`MC_error`](https://nerler.github.io/JointAI/reference/MC_error.md),
  [`predict`](https://rdrr.io/r/stats/predict.html),
  [`predDF`](https://nerler.github.io/JointAI/reference/predDF.md) and
  [`get_MIdat`](https://nerler.github.io/JointAI/reference/get_MIdat.md).

- [*Theoretical
  Background*](https://nerler.github.io/JointAI/articles/TheoreticalBackground.html):  
  Explanation of the statistical method implemented in **JointAI**.

## References

Erler NS, Rizopoulos D, Lesaffre EMEH (2021). "JointAI: Joint Analysis
and Imputation of Incomplete Data in R." *Journal of Statistical
Software*, *100*(20), 1-56.
[doi:10.18637/jss.v100.i20](https://doi.org/10.18637/jss.v100.i20) .

Erler, N.S., Rizopoulos, D., Rosmalen, J., Jaddoe, V.W.V., Franco, O.
H., & Lesaffre, E.M.E.H. (2016). Dealing with missing covariates in
epidemiologic studies: A comparison between multiple imputation and a
full Bayesian approach. *Statistics in Medicine*, 35(17), 2955-2974.
[doi:10.1002/sim.6944](https://doi.org/10.1002/sim.6944)

Erler, N.S., Rizopoulos D., Jaddoe, V.W.V., Franco, O.H. & Lesaffre,
E.M.E.H. (2019). Bayesian imputation of time-varying covariates in
linear mixed models. *Statistical Methods in Medical Research*, 28(2),
555–568.
[doi:10.1177/0962280217730851](https://doi.org/10.1177/0962280217730851)

## See also

Useful links:

- <https://nerler.github.io/JointAI/>

- Report bugs at <https://github.com/nerler/JointAI/issues/>

## Author

**Maintainer**: Nicole S. Erler <n.s.erler@umcutrecht.nl>
([ORCID](https://orcid.org/0000-0002-9370-6832))
