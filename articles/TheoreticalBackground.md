# Theoretical Background

Consider the general setting of a regression model where interest lies
in a set of parameters \\\boldsymbol\theta\\ that describe the
association between a univariate outcome \\\mathbf y\\ and a set of
covariates \\\mathbf X = (\mathbf x_1, \ldots, \mathbf x_p)\\. In the
Bayesian framework, inference over \\\boldsymbol\theta\\ is obtained by
estimation of the posterior distribution of \\\boldsymbol\theta\\, which
is proportional to the product of the likelihood of the data \\(\mathbf
y, \mathbf X)\\ and the prior distribution of \\\boldsymbol\theta\\, \\
p(\boldsymbol\theta\mid \mathbf y, \mathbf X) \propto p(\mathbf y,
\mathbf X \mid \boldsymbol\theta)\\p(\boldsymbol\theta).\\

When some of the covariates are incomplete, \\\mathbf X\\ consists of
two parts, the completely observed variables \\\mathbf X\_{obs}\\ (i.e.,
those columns of \\\mathbf X\\ that do not have any missing values) and
those variables that are incomplete, \\\mathbf X\_{mis}\\ (i.e., those
columns of \\\mathbf X\\ that do have missing values). If \\\mathbf y\\
had missing values (and this missingness was ignorable), the only
necessary change in the formulas below would be to replace \\\mathbf y\\
by \\\mathbf y\_{mis}\\. Here, we will, therefore, consider \\\mathbf
y\\ to be completely observed. In the implementation in the R package
**JointAI**, however, missing values in the outcome are allowed and are
imputed automatically.

The likelihood of the complete data, i.e., observed and unobserved data,
can be factorized in the following convenient way: \\p(\mathbf y,
\mathbf X\_{obs}, \mathbf X\_{mis} \mid \boldsymbol\theta) = p(\mathbf y
\mid \mathbf X\_{obs}, \mathbf X\_{mis}, \boldsymbol\theta\_{y\mid x})\\
p(\mathbf X\_{mis} \mid \mathbf X\_{obs}, \boldsymbol\theta_x), \\ where
the first factor constitutes the analysis model of interest, described
by a vector of parameters \\\boldsymbol\theta\_{y\mid x}\\, and the
second factor is the joint distribution of the incomplete variables,
i.e., the imputation part of the model, described by parameters
\\\boldsymbol\theta_x\\, and \\\boldsymbol\theta =
(\boldsymbol\theta\_{y\mid x}^\top, \boldsymbol\theta_x^\top)^\top\\.

Explicitly specifying the joint distribution of all data is one of the
major advantages of the Bayesian approach, since this facilitates the
use of all available information of the outcome in the imputation of the
incomplete covariates (Erler et al. 2016), which becomes especially
relevant for more complex outcomes like repeatedly measured variables
(see the section on [imputation with longitudinal
outcomes](#sec:impLong)).

In complex models the posterior distribution can usually not be derived
analytically. Therefore, MCMC methods are used to obtain samples from
the posterior distribution. The MCMC sampling in **JointAI** is done
using Gibbs sampling, which iteratively samples from the full
conditional distributions of the unknown parameters and missing values.

In the following sections each of the three parts of the model, the
analysis model, the imputation part and the prior distributions, are
described in more in detail.

## Analysis model

The analysis model of interest is described by the probability density
function \\p(\mathbf y \mid \mathbf X, \boldsymbol\theta\_{y\mid x})\\.

The R package **JointAI** can currently handle analysis models that are

- generalized linear regression models (GLM),
- generalized linear mixed models (GLMM),
- cumulative logit (mixed) models,
- multinomial (mixed) models,
- beta (mixed) models,
- log-normal (mixed) models,
- parametric (Weibull) survival models, or
- proportional hazards models.

Moreover, it is possible to fit joint models of longitudinal and
survival data, where the survival model is a proportional hazards model
and the longitudinal variables are modelled using generalized, ordinal,
beta or log-normal mixed models.

### Generalized linear (mixed) models

For a GLM the probability density function is chosen from the
exponential family and has the linear predictor \\g\\E(y_i\mid \mathbf
X, \boldsymbol\theta\_{y\mid x})\\ = \mathbf x_i^\top\boldsymbol\beta,\\
where \\g(\cdot)\\ is a link function, \\y_i\\ the value of the outcome
variable for subject \\i\\, and \\\mathbf x_i\\ is a column vector
containing the row of \\\mathbf X\\ that contains the covariate
information for \\i\\.

For a GLMM the linear predictor is of the form \\g\\E(y\_{ij}\mid
\mathbf X, \mathbf b_i, \boldsymbol\theta\_{y\mid x})\\ = \mathbf
x\_{ij}^\top\boldsymbol\beta + \mathbf z\_{ij}^\top\mathbf b_i,\\ where
\\y\_{ij}\\ is the \\j\\-th outcome of subject \\i\\, \\\mathbf
x\_{ij}\\ is the corresponding vector of covariate values, \\\mathbf
b_i\\ a vector of random effects pertaining to subject \\i\\, and
\\\mathbf z\_{ij}\\ a column vector containing the row of the design
matrix of the random effects, \\\mathbf Z\\, that corresponds to the
\\j\\-th measurement of subject \\i\\. \\\mathbf Z\\ typically contains
a subset of the variables in \\\mathbf X\\, and \\\mathbf b_i\\ follows
a normal distribution with mean zero and covariance matrix \\\mathbf
D\\.

In both cases the parameter vector \\\boldsymbol\theta\_{y\mid x}\\
contains the regression coefficients \\\boldsymbol\beta\\, and
potentially additional variance parameters (e.g., for linear (mixed)
models), for which prior distributions will be specified in the section
on [prior distributions](#sec:priors).

In **JointAI** most standard link functions are available (for details
see the documentation of
[glm_imp()](https://nerler.github.io/JointAI/reference/model_imp.html)).
One exception is the square-root link, which is not available since it
is not implemented as a link in
[JAGS](https://sourceforge.net/projects/mcmc-jags/files/Manuals/4.x/).

### Cumulative logit (mixed) models

Cumulative logit mixed models are of the form \\\begin{eqnarray\*}
y\_{ij} &\sim& \text{Mult}(\pi\_{ij,1}, \ldots, \pi\_{ij,K}),\\\[2ex\]
\pi\_{ij,1} &=& P(y\_{ij} \leq 1),\\ \pi\_{ij,k} &=& P(y\_{ij} \leq k) -
P(y\_{ij} \leq k-1), \quad k \in 2, \ldots, K-1,\\ \pi\_{ij,K} &=& 1 -
\sum\_{k = 1}^{K-1}\pi\_{ij,k},\\\[2ex\] \text{logit}(P(y\_{ij} \leq k))
&=& \gamma_k + \eta\_{ij}, \quad k \in 1,\ldots,K,\\ \eta\_{ij} &=&
\mathbf x\_{ij}^\top\boldsymbol\beta + \mathbf z\_{ij}^\top\mathbf
b_i,\\\[2ex\] \gamma_1,\delta_1,\ldots,\delta\_{K-1}
&\overset{iid}{\sim}& N(\mu\_\gamma, \sigma\_\gamma^2),\\ \gamma_k
&\sim& \gamma\_{k-1} + \exp(\delta\_{k-1}),\quad k = 2,\ldots,K,
\end{eqnarray\*}\\ where \\\pi\_{ij,k} = P(y\_{ij} = k)\\ and
\\\text{logit}(x) = \log\left(\frac{x}{1-x}\right)\\. A cumulative logit
regression model for a univariate outcome \\y_i\\ can be obtained by
dropping the index \\j\\ and omitting \\\mathbf z\_{ij}^\top\mathbf
b_i\\. In cumulative logit (mixed) models, the design matrix \\\mathbf
X\\ does not contain an intercept, since outcome category specific
intercepts \\\gamma_1,\ldots, \gamma_K\\ are specified. Here, the
parameter vector \\\boldsymbol \theta\_{y\mid x}\\ includes the
regression coefficients \\\boldsymbol\beta\\, the first intercept
\\\gamma_1\\ and increments \\\delta_1, \ldots, \delta\_{K-1}\\.

### Survival models

Survival data are typically characterized by the observed event or
censoring times, \\T_i\\, and the event indicator, \\D_i\\, which is one
if the event was observed and zero otherwise. **JointAI** provides two
types of models to analyse right censored survival data, a parametric
model which assumes a Weibull distribution for the true (but partially
unobserved) survival times \\T^\*\\, and a semi-parametric Cox
proportional hazards model.

The parametric survival model is implemented as \\\begin{eqnarray\*}
T_i^\* &\sim& \text{Weibull}(1, r_i, s),\\ D_i &\sim&
\unicode{x1D7D9}(T_i^\* \geq C_i),\\ \log(r_j) &=& - \mathbf
x_i^\top\boldsymbol\beta,\\ s &\sim& \text{Exp}(0.01),
\end{eqnarray\*}\\ where \\\unicode{x1D7D9}\\ is the indicator function
which is one if \\T_i^\*\geq C_i\\, and zero otherwise.

The Cox proportional hazards model can be written as \\h_i(t) =
h_0(t)\exp(\mathbf X_i \boldsymbol\beta),\\ where \\h_0(t)\\ is the
baseline hazard function, which, in **JointAI**, is model using a
B-spline approach, i.e., \\h_0(t) = \sum\_{q = 1}^{d} \gamma\_{Bq}
B_q(t),\\ where \\B_q\\ denotes the \\q\\-th basis function.

The survival function of the Cox model is \\S(t\mid \boldsymbol\theta) =
\exp\left\\-\int_0^th_0(s)\exp\left(\mathbf
X_i\boldsymbol\beta\right)ds\right\\ = \exp\left\\-\exp\left(\mathbf
X_i\boldsymbol\beta\right)\int_0^th_0(s)ds\right\\,\\ where
\\\boldsymbol\theta\\ includes the regression coefficients
\\\boldsymbol\beta\\ (which do not contain an intercept) and the
coefficients \\\boldsymbol \gamma\_{B}\\ used in the specification of
the baseline hazard. Since the integral over the baseline hazard does
not have a closed-form solution, in **JointAI** it is approximated using
Gauss-Kronrod quadrature with 15 evaluation points.

## Imputation / covariate part

A convenient way to specify the joint distribution of the incomplete
covariates \\\mathbf X\_{mis} = (\mathbf x\_{mis_1}, \ldots, \mathbf
x\_{mis_q})\\ is to use a sequence of conditional univariate
distributions (Ibrahim, Chen, and Lipsitz 2002; Erler et al. 2016)
\\\begin{eqnarray} p(\mathbf x\_{mis_1}, \ldots, \mathbf x\_{mis_q} \mid
\mathbf X\_{obs}, \boldsymbol\theta\_{x}) & = & p(\mathbf x\_{mis_1}
\mid \mathbf X\_{obs}, \boldsymbol\theta\_{x_1})\\ & & \prod\_{\ell=2}^q
p(\mathbf x\_{mis\_{\ell}} \mid \mathbf X\_{obs}, \mathbf x\_{mis_1},
\ldots, \mathbf x\_{mis\_{\ell-1}},
\boldsymbol\theta\_{x\_\ell}),\tag{1} \end{eqnarray}\\ with
\\\boldsymbol\theta\_{x} = (\boldsymbol\theta\_{x_1}^\top, \ldots,
\boldsymbol\theta\_{x_q}^\top)^\top\\.

Each of the conditional distributions is a member of the exponential
family, extended with distributions for ordinal categorical variables,
and chosen according to the type of the respective variable. Its linear
predictor is \\ g\_\ell\left\\E\left(x\_{i,mis\_\ell} \mid \mathbf
x\_{i,obs}, \mathbf x\_{i, mis\_{\<\ell}},
\boldsymbol\theta\_{x\_\ell}\right) \right\\ = (\mathbf x\_{i,
obs}^\top, x\_{i, mis_1}, \ldots, x\_{i, mis\_{\ell-1}})
\boldsymbol\alpha\_{\ell}, \quad \ell=1,\ldots,q, \\ where \\\mathbf
x\_{i,mis\_{\<\ell}} = (x\_{i,mis_1}, \ldots,
x\_{i,mis\_{\ell-1}})^\top\\ and \\\mathbf x\_{i,obs}\\ is the vector of
values for subject \\i\\ of those covariates that are observed for all
subjects.

Factorization of the joint distribution of the covariates in such a
sequence yields a straightforward specification of the joint
distribution, even when the covariates are of mixed type.

Missing values in the covariates are sampled from their full-conditional
distribution that can be derived from the full joint distribution of
outcome and covariates.

When, for instance, the analysis model is a GLM, the full conditional
distribution of an incomplete covariate \\x\_{i, mis\_{\ell}}\\ can be
written as \\\begin{eqnarray} \nonumber p(x\_{i, mis\_{\ell}} \mid
\mathbf y_i, \mathbf x\_{i,obs}, \mathbf x\_{i,mis\_{-\ell}},
\boldsymbol\theta) &\propto& p \left(y_i \mid \mathbf x\_{i, obs},
\mathbf x\_{i, mis}, \boldsymbol\theta\_{y\mid x} \right) p(\mathbf
x\_{i, mis}\mid \mathbf x\_{i, obs}, \boldsymbol\theta\_{x})\\
p(\boldsymbol\theta\_{y\mid x})\\ p(\boldsymbol\theta\_{x})\\\nonumber
&\propto& p \left(y_i \mid \mathbf x\_{i, obs}, \mathbf x\_{i, mis},
\boldsymbol\theta\_{y\mid x} \right)\\\nonumber & & p(x\_{i, mis\_\ell}
\mid \mathbf x\_{i, obs}, \mathbf x\_{i, mis\_{\<\ell}},
\boldsymbol\theta\_{x\_\ell})\\\nonumber & & \left\\ \prod\_{k=\ell+1}^q
p(x\_{i,mis_k}\mid \mathbf x\_{i, obs}, \mathbf x\_{i, mis\_{\<k}},
\boldsymbol\theta\_{x_k}) \right\\\\ & & p(\boldsymbol\theta\_{y\mid x})
p(\boldsymbol\theta\_{x\_\ell}) \prod\_{k=\ell+1}^p
p(\boldsymbol\theta\_{x_k}), \tag{2} \end{eqnarray}\\ where
\\\boldsymbol\theta\_{x\_{\ell}}\\ is the vector of parameters
describing the model for the \\\ell\\-th covariate, and contains the
vector of regression coefficients \\\boldsymbol\alpha\_\ell\\ and
potentially additional (variance) parameters. The product of
distributions enclosed by curly brackets represents the distributions of
those covariates that have \\x\_{mis\_\ell}\\ as a predictive variable
in the specification of the sequence in [(1)](#eq:factorization).

Note that [(2)](#eq:fullcond) describes the actual imputation model,
i.e., the distribution the imputed values for \\x\_{i, mis\_{\ell}}\\
are sampled from, but the sequence of covariates models
[(1)](#eq:factorization) is used to describe the joint distribution.
[(2)](#eq:fullcond) is derived from that joint distribution.

### Imputation in settings with longitudinal outcomes

Factorizing the joint distribution into analysis model and imputation
part also facilitates extensions to settings with more complex outcomes,
such as repeatedly measured outcomes. In the case where the analysis
model is a GLMM or ordinal mixed model, the conditional distribution of
the outcome in [(2)](#eq:fullcond), \\p\left(y_i \mid \mathbf x\_{i,
obs}, \mathbf x\_{i, mis}, \boldsymbol\theta\_{y\mid x} \right),\\ has
to be replaced by \\\begin{eqnarray} \left\\\prod\_{j=1}^{n_i} p
\left(y\_{ij} \mid \mathbf x\_{i, obs}, \mathbf x\_{i, mis}, \mathbf
b_i, \boldsymbol\theta\_{y\mid x}\right) \right\\. \tag{3}
\end{eqnarray}\\ Since \\\mathbf y\\ does not appear in any of the other
terms in [(2)](#eq:fullcond), and [(3)](#eq:lmmpartfullcond) can be
chosen to be a model that is appropriate for the outcome at hand, the
thereby specified full conditional distribution of \\x\_{i, mis\_\ell}\\
allows us to draw valid imputations that use all available information
on the outcome.

This is an important difference to multiple imputation using a fully
conditional specification (FCS, a.k.a. MICE), where the full conditional
distributions used to impute missing values are specified directly,
usually as regression models, and require the outcome to be explicitly
included in the linear predictor of each imputation model. In settings
with complex outcomes it is not clear how this should be done and
simplifications may lead to biased results (Erler et al. 2016). The
joint model specification utilized in **JointAI** overcomes this
difficulty.

When some of the covariates are time-varying, it is convenient to
specify models for these variables in the beginning of the sequence of
covariate models, so that models for longitudinal variables have other
longitudinal and baseline covariates in their linear predictor, but
longitudinal covariates do not enter the predictors of baseline
covariates.

Note that, whenever there are incomplete baseline covariates it is
necessary to specify models for all longitudinal variables, even
completely observed ones, while models for completely observed baseline
covariates can be omitted. This becomes clear when we extend the
factorized joint distribution from above with completely and
incompletely observed longitudinal (level-1) covariates \\\mathbf
s\_{obs}\\ and \\\mathbf s\_{mis}\\: \\\begin{multline\*} p
\left(y\_{ij} \mid \mathbf s\_{ij, obs}, \mathbf s\_{ij, mis}, \mathbf
x\_{i, obs}, \mathbf x\_{i, mis}, \boldsymbol\theta\_{y\mid x} \right)\\
p(\mathbf s\_{ij, mis}\mid \mathbf s\_{ij, obs}, \mathbf x\_{i, obs},
\mathbf x\_{i, mis}, \boldsymbol\theta\_{s\_{mis}})\\ p(\mathbf s\_{ij,
obs}\mid \mathbf x\_{i, obs}, \mathbf x\_{i, mis},
\boldsymbol\theta\_{s\_{obs}})\\ p(\mathbf x\_{i, mis}\mid \mathbf
x\_{i, obs}, \boldsymbol\theta\_{x\_{mis}})\\ p(\mathbf x\_{i, obs} \mid
\boldsymbol\theta\_{x\_{obs}})\\ p(\boldsymbol\theta\_{y\mid x})\\
p(\boldsymbol\theta\_{s\_{mis}}) \\ p(\boldsymbol\theta\_{s\_{obs}})\\
p(\boldsymbol\theta\_{x\_{mis}}) \\ p(\boldsymbol\theta\_{x\_{obs}})
\end{multline\*}\\ Given that the parameter vectors
\\\theta\_{x\_{obs}}\\, \\\theta\_{x\_{mis}}\\, \\\theta\_{s\_{obs}}\\
and \\\theta\_{s\_{mis}}\\ are a priori independent, and \\p(\mathbf
x\_{i, obs} \mid \boldsymbol\theta\_{x\_{obs}})\\ is independent of both
\\x\_{mis}\\ and \\s\_{mis}\\, it can be omitted.

Since \\p(\mathbf s\_{ij, obs}\mid \mathbf x\_{i, obs}, \mathbf x\_{i,
mis}, \boldsymbol\theta\_{s\_{obs}})\\, however, has \\\mathbf x\_{i,
mis}\\ in its linear predictor and will, hence, be part of the full
conditional distribution of \\\mathbf x\_{i, mis}\\, it cannot be
omitted from the model.

### Non-linear associations and interactions

Other settings in which the fully Bayesian approach employed in
**JointAI** has an advantage over standard FCS are settings with
interaction terms that involve incomplete covariates or when the
association of the outcome with an incomplete covariate is non-linear.
In standard FCS such settings lead to incompatible imputation models
(White, Royston, and Wood 2011; Bartlett et al. 2015). This becomes
clear when considering the following simple example where the analysis
model of interest is the linear regression \\y_i = \beta_0 + \beta_1
x_i + \beta_2 x_i^2 + \varepsilon_i\\ and \\x_i\\ is imputed using \\x_i
= \alpha_0 + \alpha_1 y_i + \tilde\varepsilon_i\\. While the analysis
model assumes a quadratic relationship, the imputation model assumes a
linear association between \\\mathbf x\\ and \\\mathbf y\\ and there
cannot be a joint distribution that has the imputation and analysis
model as its full conditional distributions.

Because, in **JointAI**, the analysis model is a factor in the full
conditional distribution that is used to impute \\x_i\\, the non-linear
association is taken into account. Furthermore, since it is the joint
distribution that is specified, and the full conditional then derived
from it, the joint distribution is ensured to exist.

## Prior distributions

Prior distributions have to be specified for all (hyper)parameters. A
common prior choice for the regression coefficients is the normal
distribution with mean zero and large variance. In **JointAI** variance
parameters in models for normally distributed variables are specified
as, by default vague, inverse-gamma distributions.

The covariance matrix of the random effects in a mixed model, \\\mathbf
D\\, is assumed to follow an inverse Wishart distribution where the
degrees of freedom are usually chosen to be equal to the dimension of
the random effects, and the scale matrix is diagonal. Since the
magnitude of the diagonal elements relates to the variance of the random
effects, the choice of suitable values depends on the scale of the
variable the random effect is associated with. Therefore, **JointAI**
uses independent gamma hyper-priors for each of the diagonal elements.
More details about the default hyper-parameters and how to change them
are given in the section on [hyper-parameters in the vignette about
Model
Specification](https://nerler.github.io/JointAI/articles/ModelSpecification.html#hyperparameters).

## References

Bartlett, JW, SR Seaman, IR White, and JR Carpenter. 2015. “Multiple
Imputation of Covariates by Fully Conditional Specification:
Accommodating the Substantive Model.” *Statistical Methods in Medical
Research*. <https://doi.org/10.1177/0962280214521348>.

Erler, NS, D Rizopoulos, J van Rosmalen, VWV Jaddoe, OH Franco, and EMEH
Lesaffre. 2016. “Dealing with Missing Covariates in Epidemiologic
Studies: A Comparison Between Multiple Imputation and a Full Bayesian
Approach.” *Statistics in Medicine* 35 (17): 2955–74.
<https://doi.org/10.1002/sim.6944>.

Ibrahim, JG, MH Chen, and SR Lipsitz. 2002. “Bayesian Methods for
Generalized Linear Models with Covariates Missing At Random.” *Canadian
Journal of Statistics*. <https://doi.org/10.2307/3315865>.

White, IR, P Royston, and AM Wood. 2011. “Multiple Imputation Using
Chained Equations: Issues and Guidance for Practice.” *Statistics in
Medicine*. <https://doi.org/10.1002/sim.4067>.
