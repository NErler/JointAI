# lme model

    Code
      list_models(mymod)
    Output
      Linear mixed model for "y" 
         family: gaussian 
         link: identity 
      * Predictor variables:
        (Intercept), C1, B21, O22, O23, c1, c2, time 
      * Regression coefficients:
        beta[1:8] (normal prior(s) with mean 0 and precision 1e-04) 
      * Precision of  "y" :
        tau_y (Gamma prior with shape parameter 0.01 and rate parameter 0.01)
      
      
      Linear mixed model for "c2" 
         family: gaussian 
         link: identity 
      * Predictor variables:
        (Intercept), C1, B21, O22, O23, c1, time 
      * Regression coefficients:
        alpha[1:7] (normal prior(s) with mean 0 and precision 1e-04) 
      * Precision of  "c2" :
        tau_c2 (Gamma prior with shape parameter 0.01 and rate parameter 0.01)
      
      
      Linear mixed model for "c1" 
         family: gaussian 
         link: identity 
      * Predictor variables:
        (Intercept), C1, B21, O22, O23, time 
      * Regression coefficients:
        alpha[8:13] (normal prior(s) with mean 0 and precision 1e-04) 
      * Precision of  "c1" :
        tau_c1 (Gamma prior with shape parameter 0.01 and rate parameter 0.01)
      
      
      Linear mixed model for "time" 
         family: gaussian 
         link: identity 
      * Predictor variables:
        (Intercept), C1, B21, O22, O23 
      * Regression coefficients:
        alpha[14:18] (normal prior(s) with mean 0 and precision 1e-04) 
      * Precision of  "time" :
        tau_time (Gamma prior with shape parameter 0.01 and rate parameter 0.01)
      
      
      Cumulative logit model for "O2" 
      * Reference category: "1"
      * Predictor variables:
        C1, B21 
      * Regression coefficients:
        alpha[19:20] (normal prior(s) with mean 0 and precision 1e-04) 
      * Intercepts:
        - 1: gamma_O2[1] (normal prior with mean 0 and precision 1e-04)
        - 2: gamma_O2[2] = gamma_O2[1] + exp(delta_O2[1])
      * Increments:
        delta_O2[1] (normal prior(s) with mean 0 and precision 1e-04)
      
      
      Binomial model for "B2" 
         family: binomial 
         link: logit 
      * Reference category: "0"
      * Predictor variables:
        (Intercept), C1 
      * Regression coefficients:
        alpha[21:22] (normal prior(s) with mean 0 and precision 1e-04) 
      
      

---

    Code
      parameters(mymod)
    Output
         outcome outcat     varname        coef
      1        y   <NA> (Intercept)     beta[1]
      2        y   <NA>          C1     beta[2]
      3        y   <NA>         B21     beta[3]
      4        y   <NA>         O22     beta[4]
      5        y   <NA>         O23     beta[5]
      6        y   <NA>          c1     beta[6]
      7        y   <NA>          c2     beta[7]
      8        y   <NA>        time     beta[8]
      9        y   <NA>        <NA>     sigma_y
      10       y   <NA>        <NA> D_y_id[1,1]
      11       y   <NA>        <NA> D_y_id[1,2]
      12       y   <NA>        <NA> D_y_id[2,2]

# mlogitmm

    Code
      list_models(mmod)
    Output
      Multinomial logit mixed model for "x" 
      * Reference category: "1"
      * Predictor variables:
        (Intercept), C1, B21, O21, O22, p1, c2, y, time, y:time 
      * Regression coefficients:
        x2: beta[1:5]
        x3: beta[6:10]
        x2: beta[11:15]
        x3: beta[16:20] (normal prior(s) with mean 0 and precision 1e-04) 
      
      
      Linear mixed model for "c2" 
         family: gaussian 
         link: identity 
      * Predictor variables:
        (Intercept), C1, B21, O21, O22, p1, y, time 
      * Regression coefficients:
        alpha[1:8] (normal prior(s) with mean 0 and precision 1e-04) 
      * Precision of  "c2" :
        tau_c2 (Gamma prior with shape parameter 0.01 and rate parameter 0.01)
      
      
      Poisson mixed model for "p1" 
         family: poisson 
         link: log 
      * Predictor variables:
        (Intercept), C1, B21, O21, O22, y, time 
      * Regression coefficients:
        alpha[9:15] (normal prior(s) with mean 0 and precision 1e-04) 
      
      
      Linear mixed model for "y" 
         family: gaussian 
         link: identity 
      * Predictor variables:
        (Intercept), C1, B21, O21, O22, time 
      * Regression coefficients:
        alpha[16:21] (normal prior(s) with mean 0 and precision 1e-04) 
      * Precision of  "y" :
        tau_y (Gamma prior with shape parameter 0.01 and rate parameter 0.01)
      
      
      Linear mixed model for "time" 
         family: gaussian 
         link: identity 
      * Predictor variables:
        (Intercept), C1, B21, O21, O22 
      * Regression coefficients:
        alpha[22:26] (normal prior(s) with mean 0 and precision 1e-04) 
      * Precision of  "time" :
        tau_time (Gamma prior with shape parameter 0.01 and rate parameter 0.01)
      
      
      Cumulative logit model for "O2" 
      * Reference category: "3"
      * Predictor variables:
        C1, B21 
      * Regression coefficients:
        alpha[27:28] (normal prior(s) with mean 0 and precision 1e-04) 
      * Intercepts:
        - 1: gamma_O2[1] (normal prior with mean 0 and precision 1e-04)
        - 2: gamma_O2[2] = gamma_O2[1] + exp(delta_O2[1])
      * Increments:
        delta_O2[1] (normal prior(s) with mean 0 and precision 1e-04)
      
      
      Binomial model for "B2" 
         family: binomial 
         link: logit 
      * Reference category: "0"
      * Predictor variables:
        (Intercept), C1 
      * Regression coefficients:
        alpha[29:30] (normal prior(s) with mean 0 and precision 1e-04) 
      
      

---

    Code
      parameters(mmod)
    Output
         outcome outcat     varname        coef
      1        x     x2 (Intercept)     beta[1]
      2        x     x2          C1     beta[2]
      3        x     x2         B21     beta[3]
      4        x     x2         O21     beta[4]
      5        x     x2         O22     beta[5]
      6        x     x3 (Intercept)     beta[6]
      7        x     x3          C1     beta[7]
      8        x     x3         B21     beta[8]
      9        x     x3         O21     beta[9]
      10       x     x3         O22    beta[10]
      11       x     x2          p1    beta[11]
      12       x     x2          c2    beta[12]
      13       x     x2           y    beta[13]
      14       x     x2        time    beta[14]
      15       x     x2      y:time    beta[15]
      16       x     x3          p1    beta[16]
      17       x     x3          c2    beta[17]
      18       x     x3           y    beta[18]
      19       x     x3        time    beta[19]
      20       x     x3      y:time    beta[20]
      21       x   <NA>        <NA> D_x_id[1,1]
      22       x   <NA>        <NA> D_x_id[1,2]
      23       x   <NA>        <NA> D_x_id[2,2]

