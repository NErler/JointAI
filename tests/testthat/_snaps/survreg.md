# GRcrit and MCerror give same result

    $m0a
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    (Intercept)                 2.18       7.96
    shape_Srv_ftm_stts_cn       3.45      11.27
    
    
    $m1a
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    (Intercept)                 2.58      10.69
    age                         2.85       7.57
    sexfemale                   2.60       8.48
    shape_Srv_ftm_stts_cn       5.41      11.66
    
    
    $m1b
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    (Intercept)                 2.58      10.69
    age                         2.85       7.57
    sexfemale                   2.60       8.48
    shape_Srv_ftm_stts_cn       5.41      11.66
    
    
    $m2a
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    (Intercept)                 1.35       2.16
    copper                      1.88       3.25
    shape_Srv_ftm_stts_cn       1.96       4.42
    
    
    $m3a
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    (Intercept)                 3.32      13.97
    copper                      1.49       3.48
    sexfemale                   2.99      15.12
    age                         1.17       2.02
    abs(age - copper)           2.27       5.44
    log(trig)                   2.49       7.18
    shape_Srv_ftm_stts_cn       5.74      12.20
    
    
    $m3b
    Potential scale reduction factors:
    
                                  Point est. Upper C.I.
    (Intercept)                         1.97       5.05
    copper                              2.10       5.73
    sexfemale                           2.60      10.77
    age                                 1.67       4.12
    abs(age - copper)                   1.59       5.17
    log(trig)                           1.42       3.12
    shape_Srv_ftm_stts_cn               2.09       7.19
    D_Srv_ftm_stts_cn_center[1,1]       1.31       2.70
    
    

---

    $m0a
                           est MCSE   SD MCSE/SD
    (Intercept)           8.58 0.25 0.70    0.35
    shape_Srv_ftm_stts_cn 0.97 0.15 0.24    0.64
    
    $m1a
                             est   MCSE    SD MCSE/SD
    (Intercept)            7.754 0.3268 0.671    0.49
    age                   -0.033 0.0098 0.024    0.41
    sexfemale              2.251 1.1218 2.018    0.56
    shape_Srv_ftm_stts_cn  0.672 0.1462 0.279    0.52
    
    $m1b
                             est   MCSE    SD MCSE/SD
    (Intercept)            7.754 0.3268 0.671    0.49
    age                   -0.033 0.0098 0.024    0.41
    sexfemale              2.251 1.1218 2.018    0.56
    shape_Srv_ftm_stts_cn  0.672 0.1462 0.279    0.52
    
    $m2a
                              est    MCSE     SD MCSE/SD
    (Intercept)            8.3022 0.05153 0.0997    0.52
    copper                -0.0047 0.00043 0.0012    0.37
    shape_Srv_ftm_stts_cn  1.2754 0.10966 0.2093    0.52
    
    $m3a
                              est   MCSE     SD MCSE/SD
    (Intercept)            8.7681 0.3359 0.7388    0.45
    copper                -0.0033 0.0009 0.0032    0.28
    sexfemale              1.2021 0.5469 1.5135    0.36
    age                   -0.0120 0.0031 0.0172    0.18
    abs(age - copper)     -0.0051 0.0012 0.0035    0.34
    log(trig)              0.1907 0.1057 0.2878    0.37
    shape_Srv_ftm_stts_cn  0.9114 0.1276 0.4747    0.27
    
    $m3b
                                      est   MCSE    SD MCSE/SD
    (Intercept)                    7.5999 0.6223 1.280    0.49
    copper                        -0.0058 0.0077 0.014    0.56
    sexfemale                      6.5814 1.7222 2.434    0.71
    age                           -0.0184 0.0190 0.045    0.42
    abs(age - copper)             -0.0074 0.0056 0.013    0.43
    log(trig)                      0.4048 0.3662 0.775    0.47
    shape_Srv_ftm_stts_cn              NA     NA 0.458      NA
    D_Srv_ftm_stts_cn_center[1,1]  2.8350 0.5230 2.250    0.23
    

# summary output remained the same

    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ 1, 
        data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
    (Intercept) 
          8.577 
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ age + 
        sex, data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
    (Intercept)         age   sexfemale 
        7.75403    -0.03342     2.25126 
    
    Call:
    survreg_imp(formula = Surv(futime, I(status != "censored")) ~ 
        age + sex, data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, I(status != "censored"))" 
    
    
    Coefficients:
    (Intercept)         age   sexfemale 
        7.75403    -0.03342     2.25126 
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper, 
        data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
    (Intercept)      copper 
       8.302183   -0.004669 
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper + 
        sex + age + abs(age - copper) + log(trig), data = PBC2, n.adapt = 5, 
        n.iter = 10, trunc = list(trig = c(1e-04, NA)), seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
          (Intercept)            copper         sexfemale               age 
             8.768086         -0.003336          1.202081         -0.011995 
    abs(age - copper)         log(trig) 
            -0.005132          0.190719 
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper + 
        sex + age + abs(age - copper) + log(trig) + (1 | center), 
        data = PBC2, n.adapt = 5, n.iter = 10, trunc = list(trig = c(1e-04, 
            NA)), seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
          (Intercept)            copper         sexfemale               age 
             7.599867         -0.005812          6.581364         -0.018355 
    abs(age - copper)         log(trig) 
            -0.007409          0.404835 
    $m0a
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ 1, 
        data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
    (Intercept) 
          8.577 
    
    $m1a
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ age + 
        sex, data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
    (Intercept)         age   sexfemale 
        7.75403    -0.03342     2.25126 
    
    $m1b
    
    Call:
    survreg_imp(formula = Surv(futime, I(status != "censored")) ~ 
        age + sex, data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, I(status != "censored"))" 
    
    
    Coefficients:
    (Intercept)         age   sexfemale 
        7.75403    -0.03342     2.25126 
    
    $m2a
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper, 
        data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
    (Intercept)      copper 
       8.302183   -0.004669 
    
    $m3a
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper + 
        sex + age + abs(age - copper) + log(trig), data = PBC2, n.adapt = 5, 
        n.iter = 10, trunc = list(trig = c(1e-04, NA)), seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
          (Intercept)            copper         sexfemale               age 
             8.768086         -0.003336          1.202081         -0.011995 
    abs(age - copper)         log(trig) 
            -0.005132          0.190719 
    
    $m3b
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ copper + 
        sex + age + abs(age - copper) + log(trig) + (1 | center), 
        data = PBC2, n.adapt = 5, n.iter = 10, trunc = list(trig = c(1e-04, 
            NA)), seed = 2020)
    
     Bayesian weibull survival model for "Surv(futime, status != "censored")" 
    
    
    Coefficients:
          (Intercept)            copper         sexfemale               age 
             7.599867         -0.005812          6.581364         -0.018355 
    abs(age - copper)         log(trig) 
            -0.007409          0.404835 
    

---

    $m0a
    $m0a$`Surv(futime, status != "censored")`
    (Intercept) 
       8.576968 
    
    
    $m1a
    $m1a$`Surv(futime, status != "censored")`
    (Intercept)         age   sexfemale 
     7.75402552 -0.03341543  2.25126083 
    
    
    $m1b
    $m1b$`Surv(futime, I(status != "censored"))`
    (Intercept)         age   sexfemale 
     7.75402552 -0.03341543  2.25126083 
    
    
    $m2a
    $m2a$`Surv(futime, status != "censored")`
     (Intercept)       copper 
     8.302182684 -0.004669059 
    
    
    $m3a
    $m3a$`Surv(futime, status != "censored")`
          (Intercept)            copper         sexfemale               age 
          8.768085750      -0.003336453       1.202080789      -0.011995110 
    abs(age - copper)         log(trig) 
         -0.005132365       0.190719127 
    
    
    $m3b
    $m3b$`Surv(futime, status != "censored")`
          (Intercept)            copper         sexfemale               age 
          7.599866676      -0.005811516       6.581363856      -0.018355030 
    abs(age - copper)         log(trig) 
         -0.007409157       0.404835349 
    
    

---

    $m0a
    $m0a$`Surv(futime, status != "censored")`
                   2.5%    97.5%
    (Intercept) 7.76067 10.11905
    
    
    $m1a
    $m1a$`Surv(futime, status != "censored")`
                       2.5%        97.5%
    (Intercept)  6.08625118 8.5316282849
    age         -0.08859325 0.0009502609
    sexfemale    0.12846086 7.0000902406
    
    
    $m1b
    $m1b$`Surv(futime, I(status != "censored"))`
                       2.5%        97.5%
    (Intercept)  6.08625118 8.5316282849
    age         -0.08859325 0.0009502609
    sexfemale    0.12846086 7.0000902406
    
    
    $m2a
    $m2a$`Surv(futime, status != "censored")`
                        2.5%        97.5%
    (Intercept)  8.148170054  8.494817962
    copper      -0.006467309 -0.002072201
    
    
    $m3a
    $m3a$`Surv(futime, status != "censored")`
                             2.5%         97.5%
    (Intercept)        8.11031444 10.4829993599
    copper            -0.01079280 -0.0001568012
    sexfemale         -0.17076532  5.1088442056
    age               -0.04935764  0.0161092947
    abs(age - copper) -0.01260420  0.0016366364
    log(trig)         -0.19422862  0.8251377222
    
    
    $m3b
    $m3b$`Surv(futime, status != "censored")`
                             2.5%        97.5%
    (Intercept)        5.49590788  9.478000262
    copper            -0.03039247  0.009489533
    sexfemale          3.50818639 10.863735470
    age               -0.13708050  0.032683805
    abs(age - copper) -0.03175597  0.015448816
    log(trig)         -1.25535151  1.337299871
    
    

---

    $m0a
    
    Bayesian weibull survival model fitted with JointAI
    
    Call:
    survreg_imp(formula = Surv(futime, status != "censored") ~ 1, 
        data = PBC2, n.adapt = 5, n.iter = 10, seed = 2020)
    
    
    Number of events: 169 
    
    Posterior summary:
                Mean  SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    (Intercept) 8.58 0.7 7.76  10.1          0    4.27  0.351
    
    Posterior summary of the shape of the Weibull distribution:
                           Mean   SD  2.5% 97.5% GR-crit MCE/SD
    shape_Srv_ftm_stts_cn 0.974 0.24 0.583  1.43    4.64  0.642
    
    
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
                   Mean     SD    2.5%   97.5% tail-prob. GR-crit MCE/SD
    (Intercept)  7.7540 0.6707  6.0863 8.53163     0.0000    5.41  0.487
    age         -0.0334 0.0237 -0.0886 0.00095     0.0667    4.87  0.414
    sexfemale    2.2513 2.0183  0.1285 7.00009     0.0000    6.32  0.556
    
    Posterior summary of the shape of the Weibull distribution:
                           Mean    SD  2.5% 97.5% GR-crit MCE/SD
    shape_Srv_ftm_stts_cn 0.672 0.279 0.281  1.08    9.88  0.524
    
    
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
                   Mean     SD    2.5%   97.5% tail-prob. GR-crit MCE/SD
    (Intercept)  7.7540 0.6707  6.0863 8.53163     0.0000    5.41  0.487
    age         -0.0334 0.0237 -0.0886 0.00095     0.0667    4.87  0.414
    sexfemale    2.2513 2.0183  0.1285 7.00009     0.0000    6.32  0.556
    
    Posterior summary of the shape of the Weibull distribution:
                           Mean    SD  2.5% 97.5% GR-crit MCE/SD
    shape_Srv_ftm_stts_cn 0.672 0.279 0.281  1.08    9.88  0.524
    
    
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
                    Mean      SD     2.5%    97.5% tail-prob. GR-crit MCE/SD
    (Intercept)  8.30218 0.09974  8.14817  8.49482          0    2.43  0.517
    copper      -0.00467 0.00115 -0.00647 -0.00207          0    4.53  0.370
    
    Posterior summary of the shape of the Weibull distribution:
                          Mean    SD 2.5% 97.5% GR-crit MCE/SD
    shape_Srv_ftm_stts_cn 1.28 0.209 1.06  1.78    4.14  0.524
    
    
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
                          Mean      SD    2.5%     97.5% tail-prob. GR-crit MCE/SD
    (Intercept)        8.76809 0.73876  8.1103 10.482999     0.0000   15.39  0.455
    copper            -0.00334 0.00318 -0.0108 -0.000157     0.0667    2.50  0.282
    sexfemale          1.20208 1.51346 -0.1708  5.108844     0.4000    9.19  0.361
    age               -0.01200 0.01724 -0.0494  0.016109     0.4000    1.44  0.183
    abs(age - copper) -0.00513 0.00352 -0.0126  0.001637     0.1333    5.04  0.337
    log(trig)          0.19072 0.28781 -0.1942  0.825138     0.5333    4.11  0.367
    
    Posterior summary of the shape of the Weibull distribution:
                           Mean    SD 2.5% 97.5% GR-crit MCE/SD
    shape_Srv_ftm_stts_cn 0.911 0.475 0.25  2.09    2.32  0.269
    
    
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
                          Mean     SD    2.5%    97.5% tail-prob. GR-crit MCE/SD
    (Intercept)        7.59987 1.2799  5.4959  9.47800      0.000    2.07  0.486
    copper            -0.00581 0.0137 -0.0304  0.00949      0.933    5.08  0.558
    sexfemale          6.58136 2.4342  3.5082 10.86374      0.000    8.06  0.707
    age               -0.01836 0.0448 -0.1371  0.03268      0.600    2.91  0.424
    abs(age - copper) -0.00741 0.0128 -0.0318  0.01545      0.467    4.69  0.435
    log(trig)          0.40484 0.7754 -1.2554  1.33730      0.600    4.10  0.472
    
    Posterior summary of random effects covariance matrix:
                                  Mean   SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_Srv_ftm_stts_cn_center[1,1] 2.83 2.25 0.0848  7.72               1.45  0.232
    
    Posterior summary of the shape of the Weibull distribution:
                           Mean    SD   2.5% 97.5% GR-crit MCE/SD
    shape_Srv_ftm_stts_cn 0.491 0.458 0.0655  1.59    1.45       
    
    
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
                    Mean        SD    2.5%    97.5% tail-prob.  GR-crit    MCE/SD
    (Intercept) 8.576968 0.6999852 7.76067 10.11905          0 4.268363 0.3508166
    
    
    $m1a
    $m1a$`Surv(futime, status != "censored")`
                       Mean         SD        2.5%        97.5% tail-prob.  GR-crit
    (Intercept)  7.75402552 0.67073711  6.08625118 8.5316282849 0.00000000 5.414238
    age         -0.03341543 0.02373507 -0.08859325 0.0009502609 0.06666667 4.872822
    sexfemale    2.25126083 2.01826352  0.12846086 7.0000902406 0.00000000 6.323336
                   MCE/SD
    (Intercept) 0.4872748
    age         0.4139970
    sexfemale   0.5558004
    
    
    $m1b
    $m1b$`Surv(futime, I(status != "censored"))`
                       Mean         SD        2.5%        97.5% tail-prob.  GR-crit
    (Intercept)  7.75402552 0.67073711  6.08625118 8.5316282849 0.00000000 5.414238
    age         -0.03341543 0.02373507 -0.08859325 0.0009502609 0.06666667 4.872822
    sexfemale    2.25126083 2.01826352  0.12846086 7.0000902406 0.00000000 6.323336
                   MCE/SD
    (Intercept) 0.4872748
    age         0.4139970
    sexfemale   0.5558004
    
    
    $m2a
    $m2a$`Surv(futime, status != "censored")`
                        Mean          SD         2.5%        97.5% tail-prob.
    (Intercept)  8.302182684 0.099736359  8.148170054  8.494817962          0
    copper      -0.004669059 0.001152257 -0.006467309 -0.002072201          0
                 GR-crit    MCE/SD
    (Intercept) 2.430737 0.5166593
    copper      4.531965 0.3701408
    
    
    $m3a
    $m3a$`Surv(futime, status != "censored")`
                              Mean          SD        2.5%         97.5% tail-prob.
    (Intercept)        8.768085750 0.738757507  8.11031444 10.4829993599 0.00000000
    copper            -0.003336453 0.003182426 -0.01079280 -0.0001568012 0.06666667
    sexfemale          1.202080789 1.513457342 -0.17076532  5.1088442056 0.40000000
    age               -0.011995110 0.017235723 -0.04935764  0.0161092947 0.40000000
    abs(age - copper) -0.005132365 0.003515916 -0.01260420  0.0016366364 0.13333333
    log(trig)          0.190719127 0.287813358 -0.19422862  0.8251377222 0.53333333
                        GR-crit    MCE/SD
    (Intercept)       15.387831 0.4547150
    copper             2.496890 0.2822852
    sexfemale          9.190864 0.3613601
    age                1.443521 0.1825742
    abs(age - copper)  5.044116 0.3368934
    log(trig)          4.108515 0.3673100
    
    
    $m3b
    $m3b$`Surv(futime, status != "censored")`
                              Mean         SD        2.5%        97.5% tail-prob.
    (Intercept)        7.599866676 1.27985095  5.49590788  9.478000262  0.0000000
    copper            -0.005811516 0.01374986 -0.03039247  0.009489533  0.9333333
    sexfemale          6.581363856 2.43417538  3.50818639 10.863735470  0.0000000
    age               -0.018355030 0.04481398 -0.13708050  0.032683805  0.6000000
    abs(age - copper) -0.007409157 0.01284329 -0.03175597  0.015448816  0.4666667
    log(trig)          0.404835349 0.77543574 -1.25535151  1.337299871  0.6000000
                       GR-crit    MCE/SD
    (Intercept)       2.073492 0.4861930
    copper            5.077397 0.5578735
    sexfemale         8.063729 0.7074941
    age               2.913685 0.4241797
    abs(age - copper) 4.685845 0.4349240
    log(trig)         4.095126 0.4723151
    
    

