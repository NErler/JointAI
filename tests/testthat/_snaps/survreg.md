# GRcrit and MCerror give same result

    $m0a
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    (Intercept)                 2.32      11.10
    shape_Srv_ftm_stts_cn       4.05       8.55
    
    
    $m1a
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    (Intercept)                 8.71      22.63
    age                         2.73       6.27
    sexfemale                   2.99       5.84
    shape_Srv_ftm_stts_cn       1.53       2.44
    
    
    $m1b
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    (Intercept)                 8.71      22.63
    age                         2.73       6.27
    sexfemale                   2.99       5.84
    shape_Srv_ftm_stts_cn       1.53       2.44
    
    
    $m2a
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    (Intercept)                 1.55       2.47
    copper                      1.71       2.97
    shape_Srv_ftm_stts_cn       1.72       3.27
    
    
    $m3a
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    (Intercept)                 2.78       5.41
    copper                      8.82      23.68
    sexfemale                   3.03       5.58
    age                         1.18       1.83
    abs(age - copper)           6.90      14.32
    log(trig)                   1.14       1.84
    shape_Srv_ftm_stts_cn       2.59       8.86
    
    
    $m3b
    Potential scale reduction factors:
    
                                  Point est. Upper C.I.
    (Intercept)                         1.72       3.92
    copper                              7.20      14.70
    sexfemale                           1.54       2.47
    age                                 1.44       3.41
    abs(age - copper)                   6.88      17.77
    log(trig)                           1.29       1.92
    shape_Srv_ftm_stts_cn               1.38       2.12
    D_Srv_ftm_stts_cn_center[1,1]       1.86       3.92
    
    

---

    $m0a
                           est MCSE   SD MCSE/SD
    (Intercept)           8.92 0.32 0.99    0.32
    shape_Srv_ftm_stts_cn 0.93 0.17 0.26    0.64
    
    $m1a
                             est   MCSE    SD MCSE/SD
    (Intercept)            9.616 0.8453 1.571    0.54
    age                   -0.055 0.0053 0.029    0.18
    sexfemale              0.971 0.7895 1.422    0.56
    shape_Srv_ftm_stts_cn  0.582 0.1013 0.555    0.18
    
    $m1b
                             est   MCSE    SD MCSE/SD
    (Intercept)            9.616 0.8453 1.571    0.54
    age                   -0.055 0.0053 0.029    0.18
    sexfemale              0.971 0.7895 1.422    0.56
    shape_Srv_ftm_stts_cn  0.582 0.1013 0.555    0.18
    
    $m2a
                              est    MCSE     SD MCSE/SD
    (Intercept)            8.7367 0.11431 0.6261    0.18
    copper                -0.0078 0.00055 0.0017    0.32
    shape_Srv_ftm_stts_cn  0.7949 0.11803 0.2588    0.46
    
    $m3a
                              est   MCSE    SD MCSE/SD
    (Intercept)            6.9217 0.7679 1.396   0.550
    copper                -0.0053 0.0122 0.014   0.854
    sexfemale              4.2978 1.3061 2.374   0.550
    age                   -0.0081 0.0011 0.024   0.048
    abs(age - copper)     -0.0015 0.0120 0.014   0.871
    log(trig)              0.3262 0.1011 0.315   0.321
    shape_Srv_ftm_stts_cn      NA     NA 0.206      NA
    
    $m3b
                                      est   MCSE    SD MCSE/SD
    (Intercept)                        NA     NA 0.651      NA
    copper                        -0.0025 0.0115 0.021    0.54
    sexfemale                      3.7800 0.3451 1.205    0.29
    age                           -0.0343 0.0095 0.049    0.20
    abs(age - copper)             -0.0069 0.0138 0.026    0.53
    log(trig)                      0.0048 0.1947 0.381    0.51
    shape_Srv_ftm_stts_cn          0.2856 0.0618 0.119    0.52
    D_Srv_ftm_stts_cn_center[1,1]  2.0625 1.2909 2.106    0.61
    

# summary output remained the same

    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ 1, 
        data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
    (Intercept) 
           8.92 
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ age + 
        sex, data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
    (Intercept)         age   sexfemale 
        9.61568    -0.05494     0.97102 
    
    Call:
    survreg_imp(formula = Surv(futime, I(status != "censored")) ~ 
        age + sex, data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, I(status != "censored"))" 
    
    
    Coefficients:
    (Intercept)         age   sexfemale 
        9.61568    -0.05494     0.97102 
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper, 
        data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
    (Intercept)      copper 
       8.736723   -0.007793 
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper + 
        sex + age + abs(age - copper) + log(trig), data = PBC2, n.adapt = 5, 
        n.iter = 10, trunc = list(trig = c(1e-04, NA)), seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
          (Intercept)            copper         sexfemale               age 
             6.921706         -0.005326          4.297754         -0.008066 
    abs(age - copper)         log(trig) 
            -0.001513          0.326235 
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper + 
        sex + age + abs(age - copper) + log(trig) + (1 | center), 
        data = PBC2, n.adapt = 5, n.iter = 10, trunc = list(trig = c(1e-04, 
            NA)), seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
          (Intercept)            copper         sexfemale               age 
             7.344525         -0.002483          3.779971         -0.034337 
    abs(age - copper)         log(trig) 
            -0.006899          0.004765 
    $m0a
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ 1, 
        data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
    (Intercept) 
           8.92 
    
    $m1a
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ age + 
        sex, data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
    (Intercept)         age   sexfemale 
        9.61568    -0.05494     0.97102 
    
    $m1b
    
    Call:
    survreg_imp(formula = Surv(futime, I(status != "censored")) ~ 
        age + sex, data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, I(status != "censored"))" 
    
    
    Coefficients:
    (Intercept)         age   sexfemale 
        9.61568    -0.05494     0.97102 
    
    $m2a
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper, 
        data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
    (Intercept)      copper 
       8.736723   -0.007793 
    
    $m3a
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper + 
        sex + age + abs(age - copper) + log(trig), data = PBC2, n.adapt = 5, 
        n.iter = 10, trunc = list(trig = c(1e-04, NA)), seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
          (Intercept)            copper         sexfemale               age 
             6.921706         -0.005326          4.297754         -0.008066 
    abs(age - copper)         log(trig) 
            -0.001513          0.326235 
    
    $m3b
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper + 
        sex + age + abs(age - copper) + log(trig) + (1 | center), 
        data = PBC2, n.adapt = 5, n.iter = 10, trunc = list(trig = c(1e-04, 
            NA)), seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
          (Intercept)            copper         sexfemale               age 
             7.344525         -0.002483          3.779971         -0.034337 
    abs(age - copper)         log(trig) 
            -0.006899          0.004765 
    

---

    $m0a
    $m0a$`Surv(futime, status != "censored")`
    (Intercept) 
       8.920167 
    
    
    $m1a
    $m1a$`Surv(futime, status != "censored")`
    (Intercept)         age   sexfemale 
     9.61567776 -0.05493708  0.97102383 
    
    
    $m1b
    $m1b$`Surv(futime, I(status != "censored"))`
    (Intercept)         age   sexfemale 
     9.61567776 -0.05493708  0.97102383 
    
    
    $m2a
    $m2a$`Surv(futime, status != "censored")`
     (Intercept)       copper 
     8.736722638 -0.007793056 
    
    
    $m3a
    $m3a$`Surv(futime, status != "censored")`
          (Intercept)            copper         sexfemale               age 
          6.921706418      -0.005325644       4.297754205      -0.008065518 
    abs(age - copper)         log(trig) 
         -0.001512599       0.326235131 
    
    
    $m3b
    $m3b$`Surv(futime, status != "censored")`
          (Intercept)            copper         sexfemale               age 
          7.344524586      -0.002482514       3.779970588      -0.034336967 
    abs(age - copper)         log(trig) 
         -0.006898518       0.004764755 
    
    

---

    $m0a
    $m0a$`Surv(futime, status != "censored")`
                    2.5%    97.5%
    (Intercept) 8.191309 11.72205
    
    
    $m1a
    $m1a$`Surv(futime, status != "censored")`
                      2.5%       97.5%
    (Intercept)  8.0563136 13.89016833
    age         -0.1186986 -0.01229382
    sexfemale   -1.2807896  4.16901423
    
    
    $m1b
    $m1b$`Surv(futime, I(status != "censored"))`
                      2.5%       97.5%
    (Intercept)  8.0563136 13.89016833
    age         -0.1186986 -0.01229382
    sexfemale   -1.2807896  4.16901423
    
    
    $m2a
    $m2a$`Surv(futime, status != "censored")`
                       2.5%        97.5%
    (Intercept)  7.71204705  9.655883466
    copper      -0.01086081 -0.004823294
    
    
    $m3a
    $m3a$`Surv(futime, status != "censored")`
                             2.5%      97.5%
    (Intercept)        4.32207013 9.35677718
    copper            -0.02510163 0.01620712
    sexfemale         -0.23532143 8.60849978
    age               -0.05427373 0.03173331
    abs(age - copper) -0.02297363 0.01850717
    log(trig)         -0.25705076 0.96361285
    
    
    $m3b
    $m3b$`Surv(futime, status != "censored")`
                             2.5%      97.5%
    (Intercept)        6.45865995 8.52092785
    copper            -0.04098652 0.02390099
    sexfemale          2.12993733 6.33321114
    age               -0.13617834 0.04799307
    abs(age - copper) -0.03605017 0.03531677
    log(trig)         -0.60099587 0.81400637
    
    

---

    $m0a
    
    Bayesian weibull survival model fitted with JointAI
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ 1, 
        data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
    
    Number of events: 169 
    
    Posterior summary:
                Mean    SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    (Intercept) 8.92 0.994 8.19  11.7          0    6.52  0.317
    
    Posterior summary of the shape of the Weibull distribution:
                           Mean    SD  2.5% 97.5% GR-crit MCE/SD
    shape_Srv_ftm_stts_cn 0.927 0.261 0.505  1.37    4.03   0.64
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 312 
    
    $m1a
    
    Bayesian weibull survival model fitted with JointAI
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ age + 
        sex, data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
    
    Number of events: 169 
    
    Posterior summary:
                   Mean     SD   2.5%   97.5% tail-prob. GR-crit MCE/SD
    (Intercept)  9.6157 1.5707  8.056 13.8902      0.000    9.59  0.538
    age         -0.0549 0.0288 -0.119 -0.0123      0.000    4.12  0.183
    sexfemale    0.9710 1.4224 -1.281  4.1690      0.333    4.14  0.555
    
    Posterior summary of the shape of the Weibull distribution:
                           Mean    SD  2.5% 97.5% GR-crit MCE/SD
    shape_Srv_ftm_stts_cn 0.582 0.555 0.298  1.49    2.82  0.183
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 312 
    
    $m1b
    
    Bayesian weibull survival model fitted with JointAI
    
    Call:
    survreg_imp(formula = Surv(futime, I(status != "censored")) ~ 
        age + sex, data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
    
    Number of events: 169 
    
    Posterior summary:
                   Mean     SD   2.5%   97.5% tail-prob. GR-crit MCE/SD
    (Intercept)  9.6157 1.5707  8.056 13.8902      0.000    9.59  0.538
    age         -0.0549 0.0288 -0.119 -0.0123      0.000    4.12  0.183
    sexfemale    0.9710 1.4224 -1.281  4.1690      0.333    4.14  0.555
    
    Posterior summary of the shape of the Weibull distribution:
                           Mean    SD  2.5% 97.5% GR-crit MCE/SD
    shape_Srv_ftm_stts_cn 0.582 0.555 0.298  1.49    2.82  0.183
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 312 
    
    $m2a
    
    Bayesian weibull survival model fitted with JointAI
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper, 
        data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
    
    Number of events: 169 
    
    Posterior summary:
                    Mean      SD    2.5%    97.5% tail-prob. GR-crit MCE/SD
    (Intercept)  8.73672 0.62608  7.7120  9.65588          0    2.63  0.183
    copper      -0.00779 0.00172 -0.0109 -0.00482          0    1.59  0.321
    
    Posterior summary of the shape of the Weibull distribution:
                           Mean    SD  2.5% 97.5% GR-crit MCE/SD
    shape_Srv_ftm_stts_cn 0.795 0.259 0.454  1.35       1  0.456
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 312 
    
    $m3a
    
    Bayesian weibull survival model fitted with JointAI
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper + 
        sex + age + abs(age - copper) + log(trig), data = PBC2, n.adapt = 5, 
        n.iter = 10, trunc = list(trig = c(1e-04, NA)), seed = 2020)
    
    
    Number of events: 169 
    
    Posterior summary:
                          Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    (Intercept)        6.92171 1.3959  4.3221 9.3568      0.000    6.88 0.5501
    copper            -0.00533 0.0143 -0.0251 0.0162      0.667   13.38 0.8539
    sexfemale          4.29775 2.3745 -0.2353 8.6085      0.133    3.96 0.5501
    age               -0.00807 0.0235 -0.0543 0.0317      0.800    1.83 0.0481
    abs(age - copper) -0.00151 0.0137 -0.0230 0.0185      0.933    9.89 0.8707
    log(trig)          0.32624 0.3154 -0.2571 0.9636      0.267    2.01 0.3207
    
    Posterior summary of the shape of the Weibull distribution:
                           Mean    SD  2.5% 97.5% GR-crit MCE/SD
    shape_Srv_ftm_stts_cn 0.485 0.206 0.254 0.891    3.38       
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 312 
    
    $m3b
    
    Bayesian weibull survival model fitted with JointAI
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper + 
        sex + age + abs(age - copper) + log(trig) + (1 | center), 
        data = PBC2, n.adapt = 5, n.iter = 10, trunc = list(trig = c(1e-04, 
            NA)), seed = 2020)
    
    
    Number of events: 169 
    
    Posterior summary:
                          Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    (Intercept)        7.34452 0.6507  6.4587 8.5209      0.000    2.90       
    copper            -0.00248 0.0213 -0.0410 0.0239      0.667    9.76  0.540
    sexfemale          3.77997 1.2049  2.1299 6.3332      0.000    1.87  0.286
    age               -0.03434 0.0486 -0.1362 0.0480      0.267    1.66  0.196
    abs(age - copper) -0.00690 0.0260 -0.0361 0.0353      0.667   17.68  0.530
    log(trig)          0.00476 0.3808 -0.6010 0.8140      0.800    2.85  0.511
    
    Posterior summary of random effects covariance matrix:
                                  Mean   SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_Srv_ftm_stts_cn_center[1,1] 2.06 2.11 0.0841  6.48               4.16  0.613
    
    Posterior summary of the shape of the Weibull distribution:
                           Mean    SD   2.5% 97.5% GR-crit MCE/SD
    shape_Srv_ftm_stts_cn 0.286 0.119 0.0983 0.504     1.6  0.521
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 312 
    Number of groups:
     - center: 10
    

---

    $m0a
    $m0a$`Surv(futime, status != "censored")`
                    Mean        SD     2.5%    97.5% tail-prob.  GR-crit    MCE/SD
    (Intercept) 8.920167 0.9939183 8.191309 11.72205          0 6.523569 0.3174352
    
    
    $m1a
    $m1a$`Surv(futime, status != "censored")`
                       Mean         SD       2.5%       97.5% tail-prob.  GR-crit
    (Intercept)  9.61567776 1.57065526  8.0563136 13.89016833  0.0000000 9.588740
    age         -0.05493708 0.02879581 -0.1186986 -0.01229382  0.0000000 4.117418
    sexfemale    0.97102383 1.42235492 -1.2807896  4.16901423  0.3333333 4.142224
                   MCE/SD
    (Intercept) 0.5381789
    age         0.1825742
    sexfemale   0.5550906
    
    
    $m1b
    $m1b$`Surv(futime, I(status != "censored"))`
                       Mean         SD       2.5%       97.5% tail-prob.  GR-crit
    (Intercept)  9.61567776 1.57065526  8.0563136 13.89016833  0.0000000 9.588740
    age         -0.05493708 0.02879581 -0.1186986 -0.01229382  0.0000000 4.117418
    sexfemale    0.97102383 1.42235492 -1.2807896  4.16901423  0.3333333 4.142224
                   MCE/SD
    (Intercept) 0.5381789
    age         0.1825742
    sexfemale   0.5550906
    
    
    $m2a
    $m2a$`Surv(futime, status != "censored")`
                        Mean          SD        2.5%        97.5% tail-prob.
    (Intercept)  8.736722638 0.626075900  7.71204705  9.655883466          0
    copper      -0.007793056 0.001720985 -0.01086081 -0.004823294          0
                 GR-crit    MCE/SD
    (Intercept) 2.627220 0.1825742
    copper      1.589019 0.3212012
    
    
    $m3a
    $m3a$`Surv(futime, status != "censored")`
                              Mean         SD        2.5%      97.5% tail-prob.
    (Intercept)        6.921706418 1.39586784  4.32207013 9.35677718  0.0000000
    copper            -0.005325644 0.01433883 -0.02510163 0.01620712  0.6666667
    sexfemale          4.297754205 2.37445749 -0.23532143 8.60849978  0.1333333
    age               -0.008065518 0.02352026 -0.05427373 0.03173331  0.8000000
    abs(age - copper) -0.001512599 0.01372865 -0.02297363 0.01850717  0.9333333
    log(trig)          0.326235131 0.31537838 -0.25705076 0.96361285  0.2666667
                        GR-crit     MCE/SD
    (Intercept)        6.875252 0.55013612
    copper            13.376930 0.85394891
    sexfemale          3.956863 0.55005569
    age                1.826583 0.04813287
    abs(age - copper)  9.889592 0.87066331
    log(trig)          2.007854 0.32072480
    
    
    $m3b
    $m3b$`Surv(futime, status != "censored")`
                              Mean         SD        2.5%      97.5% tail-prob.
    (Intercept)        7.344524586 0.65073152  6.45865995 8.52092785  0.0000000
    copper            -0.002482514 0.02128534 -0.04098652 0.02390099  0.6666667
    sexfemale          3.779970588 1.20488747  2.12993733 6.33321114  0.0000000
    age               -0.034336967 0.04857712 -0.13617834 0.04799307  0.2666667
    abs(age - copper) -0.006898518 0.02604593 -0.03605017 0.03531677  0.6666667
    log(trig)          0.004764755 0.38076233 -0.60099587 0.81400637  0.8000000
                        GR-crit    MCE/SD
    (Intercept)        2.897979        NA
    copper             9.760845 0.5400432
    sexfemale          1.868427 0.2863980
    age                1.656826 0.1961632
    abs(age - copper) 17.682321 0.5304992
    log(trig)          2.853541 0.5113992
    
    

