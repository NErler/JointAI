# GRcrit and MCerror give same result

    $m0a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M12: (Intercept)      0.962       0.99
    M13: (Intercept)      1.071       1.36
    M14: (Intercept)      1.050       1.29
    
    
    $m0b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M22: (Intercept)       2.28       4.01
    M23: (Intercept)       1.89       4.90
    M24: (Intercept)       1.40       2.14
    
    
    $m1a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M12: (Intercept)       1.90       3.35
    M12: C1                1.91       3.36
    M13: (Intercept)       1.51       2.66
    M13: C1                1.51       2.66
    M14: (Intercept)       1.79       3.96
    M14: C1                1.79       3.99
    
    
    $m1b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M22: (Intercept)       1.41       3.00
    M22: C1                1.41       3.00
    M23: (Intercept)       1.13       1.48
    M23: C1                1.12       1.47
    M24: (Intercept)       1.41       3.04
    M24: C1                1.41       3.04
    
    
    $m2a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M12: (Intercept)       1.19       1.64
    M12: C2                1.13       1.59
    M13: (Intercept)       1.17       1.70
    M13: C2                1.41       2.19
    M14: (Intercept)       1.03       1.24
    M14: C2                1.62       2.71
    
    
    $m2b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M22: (Intercept)       1.06       1.28
    M22: C2                1.05       1.28
    M23: (Intercept)       1.10       1.47
    M23: C2                1.07       1.36
    M24: (Intercept)       1.10       1.45
    M24: C2                1.25       1.81
    
    
    $m3a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    (Intercept)      0.927      0.945
    M12              0.924      0.948
    M13              0.938      0.985
    M14              1.015      1.275
    sigma_C1         1.060      1.386
    
    
    $m3b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    (Intercept)       1.46       2.35
    M22               1.23       1.83
    M23               1.26       1.98
    M24               1.27       2.06
    sigma_C1          1.21       1.73
    
    
    $m4a
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    M12: (Intercept)           1.171      1.615
    M12: M22                   1.309      2.156
    M12: M23                   1.034      1.120
    M12: M24                   1.018      1.031
    M12: O22                   4.309      8.558
    M12: O23                  11.340     24.184
    M12: O24                   0.933      0.952
    M12: abs(C1 - C2)          1.543      2.463
    M12: log(C1)               1.104      1.434
    M12: O22:abs(C1 - C2)      3.627      8.480
    M12: O23:abs(C1 - C2)      8.203     16.160
    M12: O24:abs(C1 - C2)      1.075      1.399
    M13: (Intercept)           1.009      1.185
    M13: M22                   1.713      3.600
    M13: M23                   0.932      0.937
    M13: M24                   1.452      2.327
    M13: O22                   3.355      6.862
    M13: O23                   5.120     11.546
    M13: O24                   2.478      5.345
    M13: abs(C1 - C2)          1.112      1.481
    M13: log(C1)               0.976      1.090
    M13: O22:abs(C1 - C2)      1.733      3.107
    M13: O23:abs(C1 - C2)      4.304     10.597
    M13: O24:abs(C1 - C2)      1.898      4.392
    M14: (Intercept)           1.002      1.155
    M14: M22                   1.841      4.442
    M14: M23                   1.129      1.676
    M14: M24                   1.346      2.831
    M14: O22                   3.274      8.946
    M14: O23                   2.146      3.731
    M14: O24                   3.569      7.399
    M14: abs(C1 - C2)          1.220      2.024
    M14: log(C1)               0.997      1.139
    M14: O22:abs(C1 - C2)      1.232      1.781
    M14: O23:abs(C1 - C2)      3.394      6.407
    M14: O24:abs(C1 - C2)      5.035     12.291
    
    
    $m4b
    Potential scale reduction factors:
    
                                                                    Point est.
    M12: (Intercept)                                                     1.040
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                   6.196
    M12: abs(C1 - C2)                                                    1.472
    M12: log(C1)                                                         1.056
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)      8.441
    M13: (Intercept)                                                     1.156
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                   5.083
    M13: abs(C1 - C2)                                                    1.224
    M13: log(C1)                                                         1.143
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)      6.740
    M14: (Intercept)                                                     0.992
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                   2.481
    M14: abs(C1 - C2)                                                    1.041
    M14: log(C1)                                                         1.013
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)      3.766
                                                                    Upper C.I.
    M12: (Intercept)                                                      1.26
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                   17.14
    M12: abs(C1 - C2)                                                     2.48
    M12: log(C1)                                                          1.32
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)      28.81
    M13: (Intercept)                                                      1.75
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                   10.79
    M13: abs(C1 - C2)                                                     1.80
    M13: log(C1)                                                          1.71
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)      15.93
    M14: (Intercept)                                                      1.14
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                    8.34
    M14: abs(C1 - C2)                                                     1.20
    M14: log(C1)                                                          1.19
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)       9.85
    
    

---

    $m0a
                       est  MCSE   SD MCSE/SD
    M12: (Intercept) -0.15 0.031 0.17    0.18
    M13: (Intercept) -0.41 0.044 0.24    0.18
    M14: (Intercept) -0.51 0.061 0.34    0.18
    
    $m0b
                      est  MCSE   SD MCSE/SD
    M22: (Intercept) 0.41 0.114 0.31    0.36
    M23: (Intercept) 0.45 0.115 0.26    0.45
    M24: (Intercept) 0.46 0.057 0.31    0.18
    
    $m1a
                     est MCSE SD MCSE/SD
    M12: (Intercept) -69 11.7 36    0.33
    M12: C1           48  8.1 25    0.33
    M13: (Intercept) -49 11.0 41    0.27
    M13: C1           34  7.7 28    0.27
    M14: (Intercept) -59  9.0 35    0.26
    M14: C1           41  6.3 24    0.26
    
    $m1b
                     est MCSE SD MCSE/SD
    M22: (Intercept) -17  7.6 36    0.21
    M22: C1           12  5.3 25    0.21
    M23: (Intercept) -20  8.9 34    0.26
    M23: C1           14  6.2 24    0.26
    M24: (Intercept)  NA   NA 34      NA
    M24: C1           NA   NA 24      NA
    
    $m2a
                       est  MCSE   SD MCSE/SD
    M12: (Intercept) -0.32 0.052 0.26    0.20
    M12: C2          -0.15 0.246 0.69    0.36
    M13: (Intercept) -0.61 0.060 0.33    0.18
    M13: C2          -1.11 0.189 1.04    0.18
    M14: (Intercept) -0.53 0.041 0.23    0.18
    M14: C2          -0.46 0.349 1.05    0.33
    
    $m2b
                       est MCSE   SD MCSE/SD
    M22: (Intercept)  0.22 0.23 0.45    0.50
    M22: C2          -0.94 0.62 1.32    0.47
    M23: (Intercept)  0.47 0.19 0.40    0.49
    M23: C2           0.14 0.39 1.30    0.30
    M24: (Intercept)  0.39 0.12 0.37    0.33
    M24: C2           0.30 0.46 1.02    0.45
    
    $m3a
                  est   MCSE    SD MCSE/SD
    (Intercept) 1.422 0.0065 0.036    0.18
    M12         0.021 0.0103 0.057    0.18
    M13         0.023 0.0165 0.090    0.18
    M14         0.018 0.0066 0.036    0.18
    sigma_C1    0.029 0.0055 0.030    0.18
    
    $m3b
                    est    MCSE     SD MCSE/SD
    (Intercept) 1.43268 0.00072 0.0039    0.18
    M22         0.00015 0.00097 0.0053    0.18
    M23         0.00181 0.00106 0.0058    0.18
    M24         0.00267 0.00099 0.0054    0.18
    sigma_C1    0.01925 0.00021 0.0012    0.18
    
    $m4a
                              est MCSE    SD MCSE/SD
    M12: (Intercept)      -25.419 3.48 12.24    0.28
    M12: M22               -1.104 0.28  0.64    0.44
    M12: M23                0.239 0.37  0.79    0.47
    M12: M24               -0.562 0.31  0.99    0.31
    M12: O22               -2.181 2.29  2.89    0.79
    M12: O23                0.903 3.72  4.04    0.92
    M12: O24               -0.207 0.50  1.02    0.49
    M12: abs(C1 - C2)       0.839 0.41  1.13    0.36
    M12: log(C1)           69.161 7.91 33.11    0.24
    M12: O22:abs(C1 - C2)   0.953 0.35  1.82    0.19
    M12: O23:abs(C1 - C2)  -1.661 1.79  2.72    0.66
    M12: O24:abs(C1 - C2)  -0.275 0.37  0.84    0.44
    M13: (Intercept)       -9.619 2.56 14.01    0.18
    M13: M22               -2.107 0.28  0.95    0.30
    M13: M23               -1.297 0.17  0.91    0.18
    M13: M24                0.150 0.16  0.56    0.29
    M13: O22               -3.110 0.34  1.33    0.26
    M13: O23                1.194 1.09  1.94    0.56
    M13: O24                0.295 0.41  1.19    0.34
    M13: abs(C1 - C2)      -0.013 0.39  1.00    0.39
    M13: log(C1)           24.496 6.78 37.15    0.18
    M13: O22:abs(C1 - C2)      NA   NA  1.12      NA
    M13: O23:abs(C1 - C2)  -0.110 0.63  1.04    0.60
    M13: O24:abs(C1 - C2)   0.594 0.61  1.14    0.53
    M14: (Intercept)      -26.690 2.73 14.96    0.18
    M14: M22               -0.747 0.20  0.60    0.33
    M14: M23               -0.970 0.22  0.85    0.26
    M14: M24               -1.639 0.11  0.58    0.18
    M14: O22                0.307 0.76  1.07    0.71
    M14: O23               -1.687 0.73  1.08    0.68
    M14: O24                2.987 1.32  2.36    0.56
    M14: abs(C1 - C2)       0.233 0.15  0.65    0.23
    M14: log(C1)           73.768 7.60 41.63    0.18
    M14: O22:abs(C1 - C2)   0.269 0.37  0.84    0.44
    M14: O23:abs(C1 - C2)   0.937 0.36  0.70    0.52
    M14: O24:abs(C1 - C2)  -2.590 0.58  1.32    0.44
    
    $m4b
                                                                        est MCSE
    M12: (Intercept)                                                -22.539 1.62
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -0.105 1.17
    M12: abs(C1 - C2)                                                -0.075 0.60
    M12: log(C1)                                                     62.278 4.31
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   0.024 1.27
    M13: (Intercept)                                                -11.074 1.55
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -2.571 1.04
    M13: abs(C1 - C2)                                                 0.033 0.52
    M13: log(C1)                                                     29.277 4.23
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   1.853 0.61
    M14: (Intercept)                                                -20.686 0.81
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -1.088 0.93
    M14: abs(C1 - C2)                                                 0.201 0.21
    M14: log(C1)                                                     55.605 3.32
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   0.500 0.41
                                                                       SD MCSE/SD
    M12: (Intercept)                                                 8.85   0.183
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               2.25   0.519
    M12: abs(C1 - C2)                                                0.90   0.664
    M12: log(C1)                                                    23.59   0.183
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  1.43   0.889
    M13: (Intercept)                                                 8.48   0.183
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               1.84   0.567
    M13: abs(C1 - C2)                                                1.14   0.452
    M13: log(C1)                                                    23.14   0.183
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  1.20   0.507
    M14: (Intercept)                                                10.70   0.076
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               1.57   0.593
    M14: abs(C1 - C2)                                                0.97   0.213
    M14: log(C1)                                                    29.25   0.114
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  0.93   0.437
    

# summary output remained the same

    
    Call:
    mlogit_imp(formula = M1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
    (Intercept) (Intercept) (Intercept) 
        -0.1500     -0.4060     -0.5149 
    
    Call:
    mlogit_imp(formula = M2 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M2" 
    
    
    Coefficients:
    (Intercept) (Intercept) (Intercept) 
         0.4141      0.4523      0.4628 
    
    Call:
    mlogit_imp(formula = M1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
    (Intercept)          C1 (Intercept)          C1 (Intercept)          C1 
         -68.63       47.75      -49.19       34.01      -59.47       41.17 
    
    Call:
    mlogit_imp(formula = M2 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M2" 
    
    
    Coefficients:
    (Intercept)          C1 (Intercept)          C1 (Intercept)          C1 
         -16.53       11.84      -19.84       14.13      -46.83       33.04 
    
    Call:
    mlogit_imp(formula = M1 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
    (Intercept)          C2 (Intercept)          C2 (Intercept)          C2 
        -0.3195     -0.1528     -0.6086     -1.1051     -0.5301     -0.4630 
    
    Call:
    mlogit_imp(formula = M2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M2" 
    
    
    Coefficients:
    (Intercept)          C2 (Intercept)          C2 (Intercept)          C2 
         0.2216     -0.9384      0.4727      0.1383      0.3946      0.2962 
    
    Call:
    lm_imp(formula = C1 ~ M1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)         M12         M13         M14 
        1.42191     0.02093     0.02302     0.01799 
    
    
    Residual standard deviation:
    sigma_C1 
     0.02862 
    
    Call:
    lm_imp(formula = C1 ~ M2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)         M22         M23         M24 
      1.4326805   0.0001536   0.0018059   0.0026721 
    
    
    Residual standard deviation:
    sigma_C1 
     0.01925 
    
    Call:
    mlogit_imp(formula = M1 ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_M1"), 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
         (Intercept)              M22              M23              M24 
           -25.41883         -1.10407          0.23919         -0.56248 
                 O22              O23              O24     abs(C1 - C2) 
            -2.18080          0.90289         -0.20670          0.83884 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
            69.16121          0.95350         -1.66100         -0.27495 
         (Intercept)              M22              M23              M24 
            -9.61891         -2.10675         -1.29748          0.14980 
                 O22              O23              O24     abs(C1 - C2) 
            -3.10952          1.19358          0.29477         -0.01283 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
            24.49608          2.87800         -0.10998          0.59378 
         (Intercept)              M22              M23              M24 
           -26.68971         -0.74704         -0.97010         -1.63888 
                 O22              O23              O24     abs(C1 - C2) 
             0.30676         -1.68665          2.98714          0.23297 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
            73.76760          0.26854          0.93732         -2.59000 
    
    Call:
    mlogit_imp(formula = M1 ~ ifelse(as.numeric(M2) > as.numeric(O1), 
        1, 0) * abs(C1 - C2) + log(C1), data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_M1"), seed = 2020, 
        warn = FALSE)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
                                                   (Intercept) 
                                                     -22.53908 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                      -0.10524 
                                                  abs(C1 - C2) 
                                                      -0.07471 
                                                       log(C1) 
                                                      62.27821 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                       0.02377 
                                                   (Intercept) 
                                                     -11.07413 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                      -2.57137 
                                                  abs(C1 - C2) 
                                                       0.03348 
                                                       log(C1) 
                                                      29.27694 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                       1.85307 
                                                   (Intercept) 
                                                     -20.68562 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                      -1.08794 
                                                  abs(C1 - C2) 
                                                       0.20118 
                                                       log(C1) 
                                                      55.60501 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                       0.49991 
    $m0a
    
    Call:
    mlogit_imp(formula = M1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
    (Intercept) (Intercept) (Intercept) 
        -0.1500     -0.4060     -0.5149 
    
    $m0b
    
    Call:
    mlogit_imp(formula = M2 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M2" 
    
    
    Coefficients:
    (Intercept) (Intercept) (Intercept) 
         0.4141      0.4523      0.4628 
    
    $m1a
    
    Call:
    mlogit_imp(formula = M1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
    (Intercept)          C1 (Intercept)          C1 (Intercept)          C1 
         -68.63       47.75      -49.19       34.01      -59.47       41.17 
    
    $m1b
    
    Call:
    mlogit_imp(formula = M2 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M2" 
    
    
    Coefficients:
    (Intercept)          C1 (Intercept)          C1 (Intercept)          C1 
         -16.53       11.84      -19.84       14.13      -46.83       33.04 
    
    $m2a
    
    Call:
    mlogit_imp(formula = M1 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
    (Intercept)          C2 (Intercept)          C2 (Intercept)          C2 
        -0.3195     -0.1528     -0.6086     -1.1051     -0.5301     -0.4630 
    
    $m2b
    
    Call:
    mlogit_imp(formula = M2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M2" 
    
    
    Coefficients:
    (Intercept)          C2 (Intercept)          C2 (Intercept)          C2 
         0.2216     -0.9384      0.4727      0.1383      0.3946      0.2962 
    
    $m3a
    
    Call:
    lm_imp(formula = C1 ~ M1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)         M12         M13         M14 
        1.42191     0.02093     0.02302     0.01799 
    
    
    Residual standard deviation:
    sigma_C1 
     0.02862 
    
    $m3b
    
    Call:
    lm_imp(formula = C1 ~ M2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)         M22         M23         M24 
      1.4326805   0.0001536   0.0018059   0.0026721 
    
    
    Residual standard deviation:
    sigma_C1 
     0.01925 
    
    $m4a
    
    Call:
    mlogit_imp(formula = M1 ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_M1"), 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
         (Intercept)              M22              M23              M24 
           -25.41883         -1.10407          0.23919         -0.56248 
                 O22              O23              O24     abs(C1 - C2) 
            -2.18080          0.90289         -0.20670          0.83884 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
            69.16121          0.95350         -1.66100         -0.27495 
         (Intercept)              M22              M23              M24 
            -9.61891         -2.10675         -1.29748          0.14980 
                 O22              O23              O24     abs(C1 - C2) 
            -3.10952          1.19358          0.29477         -0.01283 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
            24.49608          2.87800         -0.10998          0.59378 
         (Intercept)              M22              M23              M24 
           -26.68971         -0.74704         -0.97010         -1.63888 
                 O22              O23              O24     abs(C1 - C2) 
             0.30676         -1.68665          2.98714          0.23297 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
            73.76760          0.26854          0.93732         -2.59000 
    
    $m4b
    
    Call:
    mlogit_imp(formula = M1 ~ ifelse(as.numeric(M2) > as.numeric(O1), 
        1, 0) * abs(C1 - C2) + log(C1), data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_M1"), seed = 2020, 
        warn = FALSE)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
                                                   (Intercept) 
                                                     -22.53908 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                      -0.10524 
                                                  abs(C1 - C2) 
                                                      -0.07471 
                                                       log(C1) 
                                                      62.27821 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                       0.02377 
                                                   (Intercept) 
                                                     -11.07413 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                      -2.57137 
                                                  abs(C1 - C2) 
                                                       0.03348 
                                                       log(C1) 
                                                      29.27694 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                       1.85307 
                                                   (Intercept) 
                                                     -20.68562 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                      -1.08794 
                                                  abs(C1 - C2) 
                                                       0.20118 
                                                       log(C1) 
                                                      55.60501 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                       0.49991 
    

---

    $m0a
    $m0a$M1
    (Intercept) (Intercept) (Intercept) 
     -0.1499755  -0.4059797  -0.5148550 
    
    
    $m0b
    $m0b$M2
    (Intercept) (Intercept) (Intercept) 
      0.4140770   0.4522598   0.4628141 
    
    
    $m1a
    $m1a$M1
    (Intercept)          C1 (Intercept)          C1 (Intercept)          C1 
      -68.62959    47.74971   -49.18668    34.00832   -59.47091    41.16637 
    
    
    $m1b
    $m1b$M2
    (Intercept)          C1 (Intercept)          C1 (Intercept)          C1 
      -16.52622    11.84197   -19.83742    14.12542   -46.82612    33.03615 
    
    
    $m2a
    $m2a$M1
    (Intercept)          C2 (Intercept)          C2 (Intercept)          C2 
     -0.3195433  -0.1528170  -0.6085633  -1.1051034  -0.5300736  -0.4629505 
    
    
    $m2b
    $m2b$M2
    (Intercept)          C2 (Intercept)          C2 (Intercept)          C2 
      0.2215760  -0.9383816   0.4726669   0.1382598   0.3945742   0.2962376 
    
    
    $m3a
    $m3a$C1
    (Intercept)         M12         M13         M14 
     1.42190809  0.02093337  0.02301766  0.01798810 
    
    
    $m3b
    $m3b$C1
     (Intercept)          M22          M23          M24 
    1.4326805486 0.0001535725 0.0018058632 0.0026721362 
    
    
    $m4a
    $m4a$M1
         (Intercept)              M22              M23              M24 
        -25.41883499      -1.10407151       0.23919063      -0.56247727 
                 O22              O23              O24     abs(C1 - C2) 
         -2.18079656       0.90289015      -0.20669961       0.83883705 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
         69.16121061       0.95349573      -1.66100392      -0.27494570 
         (Intercept)              M22              M23              M24 
         -9.61891399      -2.10674874      -1.29748053       0.14980482 
                 O22              O23              O24     abs(C1 - C2) 
         -3.10952029       1.19357817       0.29476505      -0.01282905 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
         24.49608310       2.87800130      -0.10998262       0.59377908 
         (Intercept)              M22              M23              M24 
        -26.68971405      -0.74704088      -0.97009566      -1.63888272 
                 O22              O23              O24     abs(C1 - C2) 
          0.30676263      -1.68665441       2.98713526       0.23296806 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
         73.76760445       0.26853660       0.93731536      -2.58999583 
    
    
    $m4b
    $m4b$M1
                                                   (Intercept) 
                                                  -22.53907646 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                   -0.10523577 
                                                  abs(C1 - C2) 
                                                   -0.07470987 
                                                       log(C1) 
                                                   62.27820635 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                    0.02377362 
                                                   (Intercept) 
                                                  -11.07412937 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                   -2.57136519 
                                                  abs(C1 - C2) 
                                                    0.03347797 
                                                       log(C1) 
                                                   29.27693848 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                    1.85307040 
                                                   (Intercept) 
                                                  -20.68562171 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                   -1.08794022 
                                                  abs(C1 - C2) 
                                                    0.20118313 
                                                       log(C1) 
                                                   55.60500754 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                    0.49990928 
    
    

---

    $m0a
    $m0a$M1
                      2.5%      97.5%
    (Intercept) -0.4593546 0.12824517
    (Intercept) -0.8124883 0.02955525
    (Intercept) -1.0366750 0.10893793
    
    
    $m0b
    $m0b$M2
                      2.5%     97.5%
    (Intercept) -0.1687334 0.8626433
    (Intercept)  0.0657990 1.0384481
    (Intercept) -0.1264455 0.9056792
    
    
    $m1a
    $m1a$M1
                       2.5%     97.5%
    (Intercept) -134.713545  5.915196
    C1            -4.236512 93.768876
    (Intercept) -133.253703 10.263694
    C1            -7.518452 92.579977
    (Intercept) -114.223576  8.524604
    C1            -6.247022 79.094721
    
    
    $m1b
    $m1b$M2
                     2.5%    97.5%
    (Intercept) -74.84385 55.15486
    C1          -38.46172 52.67909
    (Intercept) -64.41356 44.02551
    C1          -30.61965 45.37486
    (Intercept) -91.77463 32.40030
    C1          -22.32979 64.18395
    
    
    $m2a
    $m2a$M1
                      2.5%       97.5%
    (Intercept) -0.8093345  0.14167651
    C2          -1.2232464  1.26253130
    (Intercept) -1.1644625 -0.05893472
    C2          -3.1486496  0.78370038
    (Intercept) -0.8763821 -0.07794868
    C2          -2.5024329  1.50771877
    
    
    $m2b
    $m2b$M2
                      2.5%    97.5%
    (Intercept) -0.3796428 1.200149
    C2          -2.9726900 2.096730
    (Intercept) -0.1023854 1.400964
    C2          -1.9978921 1.929803
    (Intercept) -0.1256262 1.023317
    C2          -1.3793278 2.109527
    
    
    $m3a
    $m3a$C1
                         2.5%     97.5%
    (Intercept)  1.3033614093 1.4473908
    M12         -0.0084195907 0.2202639
    M13         -0.0186640638 0.2667330
    M14         -0.0006984241 0.1393043
    
    
    $m3b
    $m3b$C1
                        2.5%      97.5%
    (Intercept)  1.427465556 1.44079861
    M22         -0.010387874 0.00858564
    M23         -0.007846449 0.01182050
    M24         -0.009149998 0.01159916
    
    
    $m4a
    $m4a$M1
                             2.5%        97.5%
    (Intercept)      -49.01289764  -8.56225848
    M22               -2.22057452   0.03485964
    M23               -1.18958355   1.85982954
    M24               -2.89064678   0.75731479
    O22               -6.10504731   2.02965470
    O23               -2.73209029   7.47850873
    O24               -1.95177371   1.24159122
    abs(C1 - C2)      -1.39015054   2.65479328
    log(C1)           21.53551386 132.24647562
    O22:abs(C1 - C2)  -1.62350883   3.97977969
    O23:abs(C1 - C2)  -6.39975724   0.98953105
    O24:abs(C1 - C2)  -1.71054496   1.23045323
    (Intercept)      -31.63245148  10.47322938
    M22               -4.33200670  -0.65846809
    M23               -2.99639484  -0.20169649
    M24               -0.64615578   1.21635281
    O22               -5.01573763  -1.07905551
    O23               -1.07632839   4.69299668
    O24               -2.35004203   1.86170194
    abs(C1 - C2)      -1.41211194   1.80717277
    log(C1)          -30.88854077  83.63077006
    O22:abs(C1 - C2)   1.13258779   4.77793067
    O23:abs(C1 - C2)  -2.01728360   1.00421744
    O24:abs(C1 - C2)  -0.83118185   3.08631634
    (Intercept)      -51.54024473  -1.08424298
    M22               -1.69115388   0.08411753
    M23               -2.70907090   0.37027558
    M24               -2.66430129  -0.71770420
    O22               -0.98267229   2.34191196
    O23               -3.49739013  -0.02485139
    O24               -0.84599721   7.01016466
    abs(C1 - C2)      -0.76360144   1.23349851
    log(C1)            4.58988960 148.13662264
    O22:abs(C1 - C2)  -1.75141057   1.42832213
    O23:abs(C1 - C2)  -0.06823752   1.97890045
    O24:abs(C1 - C2)  -4.78740928  -0.52325428
    
    
    $m4b
    $m4b$M1
                                                                      2.5%
    (Intercept)                                                -38.8397077
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -3.3249186
    abs(C1 - C2)                                                -1.7092604
    log(C1)                                                     28.2209057
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -1.7032701
    (Intercept)                                                -26.1059198
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -5.6090827
    abs(C1 - C2)                                                -1.9283175
    log(C1)                                                    -14.3925900
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   0.3703952
    (Intercept)                                                -36.6482691
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -4.1299778
    abs(C1 - C2)                                                -1.4725941
    log(C1)                                                      8.5026011
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -0.8327012
                                                                    97.5%
    (Intercept)                                                 -7.940490
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                2.578032
    abs(C1 - C2)                                                 1.443114
    log(C1)                                                    103.527683
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   2.142452
    (Intercept)                                                  5.711713
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -0.204273
    abs(C1 - C2)                                                 2.403744
    log(C1)                                                     66.522255
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   3.767392
    (Intercept)                                                 -3.793041
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                1.150053
    abs(C1 - C2)                                                 1.787078
    log(C1)                                                    102.640628
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   2.174837
    
    

---

    $m0a
    
    Bayesian multinomial logit model fitted with JointAI
    
    Call:
    mlogit_imp(formula = M1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
                       Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    M12: (Intercept) -0.150 0.169 -0.459 0.1282      0.333   0.993  0.183
    M13: (Intercept) -0.406 0.240 -0.812 0.0296      0.133   1.130  0.183
    M14: (Intercept) -0.515 0.337 -1.037 0.1089      0.133   1.260  0.183
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m0b
    
    Bayesian multinomial logit model fitted with JointAI
    
    Call:
    mlogit_imp(formula = M2 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
                      Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    M22: (Intercept) 0.414 0.314 -0.1687 0.863      0.333    2.86  0.364
    M23: (Intercept) 0.452 0.258  0.0658 1.038      0.000    3.29  0.446
    M24: (Intercept) 0.463 0.314 -0.1264 0.906      0.200    1.88  0.183
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m1a
    
    Bayesian multinomial logit model fitted with JointAI
    
    Call:
    mlogit_imp(formula = M1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
                      Mean   SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    M12: (Intercept) -68.6 35.7 -134.71  5.92      0.133    2.37  0.327
    M12: C1           47.7 24.9   -4.24 93.77      0.133    2.38  0.327
    M13: (Intercept) -49.2 40.7 -133.25 10.26      0.200    1.93  0.271
    M13: C1           34.0 28.4   -7.52 92.58      0.200    1.94  0.272
    M14: (Intercept) -59.5 34.7 -114.22  8.52      0.133    1.92  0.260
    M14: C1           41.2 24.2   -6.25 79.09      0.133    1.92  0.260
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m1b
    
    Bayesian multinomial logit model fitted with JointAI
    
    Call:
    mlogit_imp(formula = M2 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
                      Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    M22: (Intercept) -16.5 35.8 -74.8  55.2        0.6    1.43  0.214
    M22: C1           11.8 24.9 -38.5  52.7        0.6    1.43  0.214
    M23: (Intercept) -19.8 34.3 -64.4  44.0        0.6    1.22  0.260
    M23: C1           14.1 24.0 -30.6  45.4        0.6    1.23  0.261
    M24: (Intercept) -46.8 34.2 -91.8  32.4        0.2    1.86       
    M24: C1           33.0 23.8 -22.3  64.2        0.2    1.88       
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m2a
    
    Bayesian multinomial logit model fitted with JointAI
    
    Call:
    mlogit_imp(formula = M1 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
                       Mean    SD   2.5%   97.5% tail-prob. GR-crit MCE/SD
    M12: (Intercept) -0.320 0.260 -0.809  0.1417      0.267    1.33  0.200
    M12: C2          -0.153 0.692 -1.223  1.2625      0.533    1.56  0.356
    M13: (Intercept) -0.609 0.331 -1.164 -0.0589      0.000    1.39  0.183
    M13: C2          -1.105 1.038 -3.149  0.7837      0.267    1.67  0.183
    M14: (Intercept) -0.530 0.227 -0.876 -0.0779      0.000    1.06  0.183
    M14: C2          -0.463 1.050 -2.502  1.5077      0.533    1.20  0.333
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m2b
    
    Bayesian multinomial logit model fitted with JointAI
    
    Call:
    mlogit_imp(formula = M2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
                       Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    M22: (Intercept)  0.222 0.450 -0.380  1.20      0.800    1.61  0.505
    M22: C2          -0.938 1.321 -2.973  2.10      0.467    1.88  0.466
    M23: (Intercept)  0.473 0.399 -0.102  1.40      0.133    2.73  0.487
    M23: C2           0.138 1.301 -1.998  1.93      0.733    1.55  0.304
    M24: (Intercept)  0.395 0.367 -0.126  1.02      0.400    1.79  0.326
    M24: C2           0.296 1.024 -1.379  2.11      0.800    2.20  0.449
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m3a
    
    Bayesian linear model fitted with JointAI
    
    Call:
    lm_imp(formula = C1 ~ M1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
                  Mean     SD      2.5% 97.5% tail-prob. GR-crit MCE/SD
    (Intercept) 1.4219 0.0356  1.303361 1.447      0.000    1.33  0.183
    M12         0.0209 0.0567 -0.008420 0.220      0.400    1.20  0.183
    M13         0.0230 0.0902 -0.018664 0.267      0.533    1.74  0.183
    M14         0.0180 0.0360 -0.000698 0.139      0.133    1.20  0.183
    
    Posterior summary of residual std. deviation:
               Mean     SD   2.5% 97.5% GR-crit MCE/SD
    sigma_C1 0.0286 0.0303 0.0163 0.113    1.42  0.183
    
    
    MCMC settings:
    Iterations = 1:10
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m3b
    
    Bayesian linear model fitted with JointAI
    
    Call:
    lm_imp(formula = C1 ~ M2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
                    Mean      SD     2.5%   97.5% tail-prob. GR-crit MCE/SD
    (Intercept) 1.432681 0.00392  1.42747 1.44080      0.000    1.29  0.183
    M22         0.000154 0.00529 -0.01039 0.00859      0.867    1.30  0.183
    M23         0.001806 0.00580 -0.00785 0.01182      0.867    1.14  0.183
    M24         0.002672 0.00542 -0.00915 0.01160      0.467    1.44  0.183
    
    Posterior summary of residual std. deviation:
               Mean      SD  2.5%  97.5% GR-crit MCE/SD
    sigma_C1 0.0192 0.00118 0.017 0.0215    1.56  0.183
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m4a
    
    Bayesian multinomial logit model fitted with JointAI
    
    Call:
    mlogit_imp(formula = M1 ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_M1"), 
        seed = 2020)
    
    
    Posterior summary:
                              Mean     SD     2.5%    97.5% tail-prob. GR-crit
    M12: (Intercept)      -25.4188 12.237 -49.0129  -8.5623     0.0000   1.624
    M12: M22               -1.1041  0.639  -2.2206   0.0349     0.1333   2.549
    M12: M23                0.2392  0.794  -1.1896   1.8598     0.8000   1.806
    M12: M24               -0.5625  0.994  -2.8906   0.7573     0.6667   1.304
    M12: O22               -2.1808  2.895  -6.1050   2.0297     0.6000   6.537
    M12: O23                0.9029  4.040  -2.7321   7.4785     0.6667  20.589
    M12: O24               -0.2067  1.020  -1.9518   1.2416     0.9333   1.281
    M12: abs(C1 - C2)       0.8388  1.131  -1.3902   2.6548     0.5333   3.350
    M12: log(C1)           69.1612 33.113  21.5355 132.2465     0.0000   1.441
    M12: O22:abs(C1 - C2)   0.9535  1.821  -1.6235   3.9798     0.7333   6.701
    M12: O23:abs(C1 - C2)  -1.6610  2.716  -6.3998   0.9895     0.7333  16.810
    M12: O24:abs(C1 - C2)  -0.2749  0.837  -1.7105   1.2305     0.7333   2.358
    M13: (Intercept)       -9.6189 14.010 -31.6325  10.4732     0.6667   1.446
    M13: M22               -2.1067  0.952  -4.3320  -0.6585     0.0000   2.333
    M13: M23               -1.2975  0.907  -2.9964  -0.2017     0.0000   0.961
    M13: M24                0.1498  0.557  -0.6462   1.2164     0.9333   2.490
    M13: O22               -3.1095  1.333  -5.0157  -1.0791     0.0000   3.615
    M13: O23                1.1936  1.940  -1.0763   4.6930     0.7333  10.182
    M13: O24                0.2948  1.188  -2.3500   1.8617     0.4667   4.142
    M13: abs(C1 - C2)      -0.0128  0.995  -1.4121   1.8072     1.0000   2.237
    M13: log(C1)           24.4961 37.147 -30.8885  83.6308     0.7333   1.269
    M13: O22:abs(C1 - C2)   2.8780  1.118   1.1326   4.7779     0.0000   1.848
    M13: O23:abs(C1 - C2)  -0.1100  1.043  -2.0173   1.0042     0.7333  10.569
    M13: O24:abs(C1 - C2)   0.5938  1.136  -0.8312   3.0863     0.5333   3.238
    M14: (Intercept)      -26.6897 14.960 -51.5402  -1.0842     0.0667   1.384
    M14: M22               -0.7470  0.597  -1.6912   0.0841     0.2000   1.597
    M14: M23               -0.9701  0.849  -2.7091   0.3703     0.2667   1.759
    M14: M24               -1.6389  0.578  -2.6643  -0.7177     0.0000   1.215
    M14: O22                0.3068  1.067  -0.9827   2.3419     0.8000   7.655
    M14: O23               -1.6867  1.080  -3.4974  -0.0249     0.0667   2.704
    M14: O24                2.9871  2.355  -0.8460   7.0102     0.2667   4.668
    M14: abs(C1 - C2)       0.2330  0.654  -0.7636   1.2335     0.7333   1.413
    M14: log(C1)           73.7676 41.629   4.5899 148.1366     0.0667   1.431
    M14: O22:abs(C1 - C2)   0.2685  0.844  -1.7514   1.4283     0.6667   2.544
    M14: O23:abs(C1 - C2)   0.9373  0.697  -0.0682   1.9789     0.2000   4.322
    M14: O24:abs(C1 - C2)  -2.5900  1.316  -4.7874  -0.5233     0.0000   6.539
                          MCE/SD
    M12: (Intercept)       0.285
    M12: M22               0.438
    M12: M23               0.470
    M12: M24               0.314
    M12: O22               0.791
    M12: O23               0.921
    M12: O24               0.491
    M12: abs(C1 - C2)      0.361
    M12: log(C1)           0.239
    M12: O22:abs(C1 - C2)  0.193
    M12: O23:abs(C1 - C2)  0.659
    M12: O24:abs(C1 - C2)  0.442
    M13: (Intercept)       0.183
    M13: M22               0.297
    M13: M23               0.183
    M13: M24               0.287
    M13: O22               0.256
    M13: O23               0.563
    M13: O24               0.343
    M13: abs(C1 - C2)      0.388
    M13: log(C1)           0.183
    M13: O22:abs(C1 - C2)       
    M13: O23:abs(C1 - C2)  0.605
    M13: O24:abs(C1 - C2)  0.535
    M14: (Intercept)       0.183
    M14: M22               0.330
    M14: M23               0.257
    M14: M24               0.183
    M14: O22               0.715
    M14: O23               0.680
    M14: O24               0.560
    M14: abs(C1 - C2)      0.233
    M14: log(C1)           0.183
    M14: O22:abs(C1 - C2)  0.437
    M14: O23:abs(C1 - C2)  0.515
    M14: O24:abs(C1 - C2)  0.444
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m4b
    
    Bayesian multinomial logit model fitted with JointAI
    
    Call:
    mlogit_imp(formula = M1 ~ ifelse(as.numeric(M2) > as.numeric(O1), 
        1, 0) * abs(C1 - C2) + log(C1), data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_M1"), seed = 2020, 
        warn = FALSE)
    
    
    Posterior summary:
                                                                        Mean     SD
    M12: (Intercept)                                                -22.5391  8.847
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -0.1052  2.249
    M12: abs(C1 - C2)                                                -0.0747  0.904
    M12: log(C1)                                                     62.2782 23.590
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   0.0238  1.432
    M13: (Intercept)                                                -11.0741  8.482
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -2.5714  1.837
    M13: abs(C1 - C2)                                                 0.0335  1.141
    M13: log(C1)                                                     29.2769 23.143
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   1.8531  1.200
    M14: (Intercept)                                                -20.6856 10.699
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -1.0879  1.571
    M14: abs(C1 - C2)                                                 0.2012  0.967
    M14: log(C1)                                                     55.6050 29.253
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   0.4999  0.935
                                                                       2.5%   97.5%
    M12: (Intercept)                                                -38.840  -7.940
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -3.325   2.578
    M12: abs(C1 - C2)                                                -1.709   1.443
    M12: log(C1)                                                     28.221 103.528
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -1.703   2.142
    M13: (Intercept)                                                -26.106   5.712
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -5.609  -0.204
    M13: abs(C1 - C2)                                                -1.928   2.404
    M13: log(C1)                                                    -14.393  66.522
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   0.370   3.767
    M14: (Intercept)                                                -36.648  -3.793
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -4.130   1.150
    M14: abs(C1 - C2)                                                -1.473   1.787
    M14: log(C1)                                                      8.503 102.641
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -0.833   2.175
                                                                    tail-prob.
    M12: (Intercept)                                                     0.000
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                   0.800
    M12: abs(C1 - C2)                                                    0.867
    M12: log(C1)                                                         0.000
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)      0.733
    M13: (Intercept)                                                     0.133
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                   0.000
    M13: abs(C1 - C2)                                                    0.867
    M13: log(C1)                                                         0.267
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)      0.000
    M14: (Intercept)                                                     0.000
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                   0.467
    M14: abs(C1 - C2)                                                    0.867
    M14: log(C1)                                                         0.000
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)      0.600
                                                                    GR-crit MCE/SD
    M12: (Intercept)                                                   1.14 0.1826
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                18.71 0.5188
    M12: abs(C1 - C2)                                                  2.52 0.6639
    M12: log(C1)                                                       1.27 0.1826
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   20.34 0.8888
    M13: (Intercept)                                                   1.63 0.1826
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                10.34 0.5675
    M13: abs(C1 - C2)                                                  2.44 0.4518
    M13: log(C1)                                                       1.58 0.1826
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   17.91 0.5069
    M14: (Intercept)                                                   1.05 0.0759
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                 9.14 0.5934
    M14: abs(C1 - C2)                                                  1.01 0.2131
    M14: log(C1)                                                       1.04 0.1136
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)    7.56 0.4371
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    

---

    $m0a
    $m0a$M1
                           Mean        SD       2.5%      97.5% tail-prob.
    M12: (Intercept) -0.1499755 0.1694147 -0.4593546 0.12824517  0.3333333
    M13: (Intercept) -0.4059797 0.2402434 -0.8124883 0.02955525  0.1333333
    M14: (Intercept) -0.5148550 0.3366004 -1.0366750 0.10893793  0.1333333
                       GR-crit    MCE/SD
    M12: (Intercept) 0.9932978 0.1825742
    M13: (Intercept) 1.1300108 0.1825742
    M14: (Intercept) 1.2596380 0.1825742
    
    
    $m0b
    $m0b$M2
                          Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    M22: (Intercept) 0.4140770 0.3138272 -0.1687334 0.8626433  0.3333333 2.856326
    M23: (Intercept) 0.4522598 0.2580566  0.0657990 1.0384481  0.0000000 3.293908
    M24: (Intercept) 0.4628141 0.3143351 -0.1264455 0.9056792  0.2000000 1.877349
                        MCE/SD
    M22: (Intercept) 0.3639365
    M23: (Intercept) 0.4464233
    M24: (Intercept) 0.1825742
    
    
    $m1a
    $m1a$M1
                          Mean       SD        2.5%     97.5% tail-prob.  GR-crit
    M12: (Intercept) -68.62959 35.67808 -134.713545  5.915196  0.1333333 2.374020
    M12: C1           47.74971 24.88884   -4.236512 93.768876  0.1333333 2.383029
    M13: (Intercept) -49.18668 40.71067 -133.253703 10.263694  0.2000000 1.933152
    M13: C1           34.00832 28.39457   -7.518452 92.579977  0.2000000 1.937662
    M14: (Intercept) -59.47091 34.74079 -114.223576  8.524604  0.1333333 1.916760
    M14: C1           41.16637 24.24295   -6.247022 79.094721  0.1333333 1.923975
                        MCE/SD
    M12: (Intercept) 0.3268775
    M12: C1          0.3267498
    M13: (Intercept) 0.2713336
    M13: C1          0.2720021
    M14: (Intercept) 0.2602552
    M14: C1          0.2604883
    
    
    $m1b
    $m1b$M2
                          Mean       SD      2.5%    97.5% tail-prob.  GR-crit
    M22: (Intercept) -16.52622 35.78074 -74.84385 55.15486        0.6 1.427567
    M22: C1           11.84197 24.93609 -38.46172 52.67909        0.6 1.434887
    M23: (Intercept) -19.83742 34.33652 -64.41356 44.02551        0.6 1.224304
    M23: C1           14.12542 23.95689 -30.61965 45.37486        0.6 1.225643
    M24: (Intercept) -46.82612 34.20778 -91.77463 32.40030        0.2 1.859255
    M24: C1           33.03615 23.82624 -22.32979 64.18395        0.2 1.880389
                        MCE/SD
    M22: (Intercept) 0.2137828
    M22: C1          0.2138274
    M23: (Intercept) 0.2602778
    M23: C1          0.2605010
    M24: (Intercept)        NA
    M24: C1                 NA
    
    
    $m2a
    $m2a$M1
                           Mean        SD       2.5%       97.5% tail-prob.
    M12: (Intercept) -0.3195433 0.2597509 -0.8093345  0.14167651  0.2666667
    M12: C2          -0.1528170 0.6917391 -1.2232464  1.26253130  0.5333333
    M13: (Intercept) -0.6085633 0.3308407 -1.1644625 -0.05893472  0.0000000
    M13: C2          -1.1051034 1.0375456 -3.1486496  0.78370038  0.2666667
    M14: (Intercept) -0.5300736 0.2266948 -0.8763821 -0.07794868  0.0000000
    M14: C2          -0.4629505 1.0496587 -2.5024329  1.50771877  0.5333333
                      GR-crit    MCE/SD
    M12: (Intercept) 1.325314 0.1995703
    M12: C2          1.557039 0.3561627
    M13: (Intercept) 1.390644 0.1825742
    M13: C2          1.669298 0.1825742
    M14: (Intercept) 1.056025 0.1825742
    M14: C2          1.202366 0.3326650
    
    
    $m2b
    $m2b$M2
                           Mean        SD       2.5%    97.5% tail-prob.  GR-crit
    M22: (Intercept)  0.2215760 0.4501231 -0.3796428 1.200149  0.8000000 1.611322
    M22: C2          -0.9383816 1.3207894 -2.9726900 2.096730  0.4666667 1.882493
    M23: (Intercept)  0.4726669 0.3990591 -0.1023854 1.400964  0.1333333 2.728079
    M23: C2           0.1382598 1.3005391 -1.9978921 1.929803  0.7333333 1.552308
    M24: (Intercept)  0.3945742 0.3670787 -0.1256262 1.023317  0.4000000 1.791660
    M24: C2           0.2962376 1.0235997 -1.3793278 2.109527  0.8000000 2.197822
                        MCE/SD
    M22: (Intercept) 0.5048817
    M22: C2          0.4664196
    M23: (Intercept) 0.4867098
    M23: C2          0.3035802
    M24: (Intercept) 0.3261899
    M24: C2          0.4485243
    
    
    $m3a
    $m3a$C1
                      Mean         SD          2.5%     97.5% tail-prob.  GR-crit
    (Intercept) 1.42190809 0.03560534  1.3033614093 1.4473908  0.0000000 1.330161
    M12         0.02093337 0.05667585 -0.0084195907 0.2202639  0.4000000 1.202072
    M13         0.02301766 0.09017853 -0.0186640638 0.2667330  0.5333333 1.741121
    M14         0.01798810 0.03596424 -0.0006984241 0.1393043  0.1333333 1.202582
                   MCE/SD
    (Intercept) 0.1825742
    M12         0.1825742
    M13         0.1825742
    M14         0.1825742
    
    
    $m3b
    $m3b$C1
                        Mean          SD         2.5%      97.5% tail-prob.
    (Intercept) 1.4326805486 0.003921183  1.427465556 1.44079861  0.0000000
    M22         0.0001535725 0.005292122 -0.010387874 0.00858564  0.8666667
    M23         0.0018058632 0.005802248 -0.007846449 0.01182050  0.8666667
    M24         0.0026721362 0.005415436 -0.009149998 0.01159916  0.4666667
                 GR-crit    MCE/SD
    (Intercept) 1.293281 0.1825742
    M22         1.299293 0.1825742
    M23         1.136300 0.1825742
    M24         1.441052 0.1825742
    
    
    $m4a
    $m4a$M1
                                  Mean         SD         2.5%        97.5%
    M12: (Intercept)      -25.41883499 12.2368946 -49.01289764  -8.56225848
    M12: M22               -1.10407151  0.6394643  -2.22057452   0.03485964
    M12: M23                0.23919063  0.7943736  -1.18958355   1.85982954
    M12: M24               -0.56247727  0.9937426  -2.89064678   0.75731479
    M12: O22               -2.18079656  2.8946843  -6.10504731   2.02965470
    M12: O23                0.90289015  4.0404048  -2.73209029   7.47850873
    M12: O24               -0.20669961  1.0201707  -1.95177371   1.24159122
    M12: abs(C1 - C2)       0.83883705  1.1308317  -1.39015054   2.65479328
    M12: log(C1)           69.16121061 33.1128617  21.53551386 132.24647562
    M12: O22:abs(C1 - C2)   0.95349573  1.8208195  -1.62350883   3.97977969
    M12: O23:abs(C1 - C2)  -1.66100392  2.7160932  -6.39975724   0.98953105
    M12: O24:abs(C1 - C2)  -0.27494570  0.8365615  -1.71054496   1.23045323
    M13: (Intercept)       -9.61891399 14.0099160 -31.63245148  10.47322938
    M13: M22               -2.10674874  0.9521154  -4.33200670  -0.65846809
    M13: M23               -1.29748053  0.9065690  -2.99639484  -0.20169649
    M13: M24                0.14980482  0.5574832  -0.64615578   1.21635281
    M13: O22               -3.10952029  1.3325168  -5.01573763  -1.07905551
    M13: O23                1.19357817  1.9399462  -1.07632839   4.69299668
    M13: O24                0.29476505  1.1882306  -2.35004203   1.86170194
    M13: abs(C1 - C2)      -0.01282905  0.9952079  -1.41211194   1.80717277
    M13: log(C1)           24.49608310 37.1468217 -30.88854077  83.63077006
    M13: O22:abs(C1 - C2)   2.87800130  1.1183407   1.13258779   4.77793067
    M13: O23:abs(C1 - C2)  -0.10998262  1.0434894  -2.01728360   1.00421744
    M13: O24:abs(C1 - C2)   0.59377908  1.1364009  -0.83118185   3.08631634
    M14: (Intercept)      -26.68971405 14.9598095 -51.54024473  -1.08424298
    M14: M22               -0.74704088  0.5966858  -1.69115388   0.08411753
    M14: M23               -0.97009566  0.8486494  -2.70907090   0.37027558
    M14: M24               -1.63888272  0.5778424  -2.66430129  -0.71770420
    M14: O22                0.30676263  1.0672448  -0.98267229   2.34191196
    M14: O23               -1.68665441  1.0800120  -3.49739013  -0.02485139
    M14: O24                2.98713526  2.3552651  -0.84599721   7.01016466
    M14: abs(C1 - C2)       0.23296806  0.6535849  -0.76360144   1.23349851
    M14: log(C1)           73.76760445 41.6287893   4.58988960 148.13662264
    M14: O22:abs(C1 - C2)   0.26853660  0.8439742  -1.75141057   1.42832213
    M14: O23:abs(C1 - C2)   0.93731536  0.6968745  -0.06823752   1.97890045
    M14: O24:abs(C1 - C2)  -2.58999583  1.3162049  -4.78740928  -0.52325428
                          tail-prob.    GR-crit    MCE/SD
    M12: (Intercept)      0.00000000  1.6240967 0.2847445
    M12: M22              0.13333333  2.5492486 0.4384009
    M12: M23              0.80000000  1.8063812 0.4701172
    M12: M24              0.66666667  1.3041825 0.3142950
    M12: O22              0.60000000  6.5369393 0.7914078
    M12: O23              0.66666667 20.5889488 0.9210720
    M12: O24              0.93333333  1.2814833 0.4907845
    M12: abs(C1 - C2)     0.53333333  3.3497624 0.3611589
    M12: log(C1)          0.00000000  1.4410630 0.2389695
    M12: O22:abs(C1 - C2) 0.73333333  6.7010230 0.1930572
    M12: O23:abs(C1 - C2) 0.73333333 16.8103470 0.6588978
    M12: O24:abs(C1 - C2) 0.73333333  2.3582577 0.4420690
    M13: (Intercept)      0.66666667  1.4463834 0.1825742
    M13: M22              0.00000000  2.3332968 0.2974640
    M13: M23              0.00000000  0.9611207 0.1825742
    M13: M24              0.93333333  2.4901097 0.2867058
    M13: O22              0.00000000  3.6148813 0.2559585
    M13: O23              0.73333333 10.1821632 0.5628666
    M13: O24              0.46666667  4.1415919 0.3430746
    M13: abs(C1 - C2)     1.00000000  2.2372371 0.3878600
    M13: log(C1)          0.73333333  1.2694922 0.1825742
    M13: O22:abs(C1 - C2) 0.00000000  1.8484974        NA
    M13: O23:abs(C1 - C2) 0.73333333 10.5694990 0.6049138
    M13: O24:abs(C1 - C2) 0.53333333  3.2380666 0.5345199
    M14: (Intercept)      0.06666667  1.3836345 0.1825742
    M14: M22              0.20000000  1.5969686 0.3300896
    M14: M23              0.26666667  1.7592296 0.2567021
    M14: M24              0.00000000  1.2146868 0.1825742
    M14: O22              0.80000000  7.6552542 0.7149200
    M14: O23              0.06666667  2.7039806 0.6800551
    M14: O24              0.26666667  4.6678513 0.5595237
    M14: abs(C1 - C2)     0.73333333  1.4127898 0.2329005
    M14: log(C1)          0.06666667  1.4314139 0.1825742
    M14: O22:abs(C1 - C2) 0.66666667  2.5441695 0.4373424
    M14: O23:abs(C1 - C2) 0.20000000  4.3219944 0.5150709
    M14: O24:abs(C1 - C2) 0.00000000  6.5391789 0.4439383
    
    
    $m4b
    $m4b$M1
                                                                            Mean
    M12: (Intercept)                                                -22.53907646
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -0.10523577
    M12: abs(C1 - C2)                                                -0.07470987
    M12: log(C1)                                                     62.27820635
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   0.02377362
    M13: (Intercept)                                                -11.07412937
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -2.57136519
    M13: abs(C1 - C2)                                                 0.03347797
    M13: log(C1)                                                     29.27693848
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   1.85307040
    M14: (Intercept)                                                -20.68562171
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -1.08794022
    M14: abs(C1 - C2)                                                 0.20118313
    M14: log(C1)                                                     55.60500754
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   0.49990928
                                                                            SD
    M12: (Intercept)                                                 8.8472808
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               2.2488068
    M12: abs(C1 - C2)                                                0.9043762
    M12: log(C1)                                                    23.5896736
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  1.4322455
    M13: (Intercept)                                                 8.4822909
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               1.8372615
    M13: abs(C1 - C2)                                                1.1414992
    M13: log(C1)                                                    23.1431032
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  1.1998544
    M14: (Intercept)                                                10.6990182
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               1.5705425
    M14: abs(C1 - C2)                                                0.9670115
    M14: log(C1)                                                    29.2530679
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  0.9346769
                                                                           2.5%
    M12: (Intercept)                                                -38.8397077
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -3.3249186
    M12: abs(C1 - C2)                                                -1.7092604
    M12: log(C1)                                                     28.2209057
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -1.7032701
    M13: (Intercept)                                                -26.1059198
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -5.6090827
    M13: abs(C1 - C2)                                                -1.9283175
    M13: log(C1)                                                    -14.3925900
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   0.3703952
    M14: (Intercept)                                                -36.6482691
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -4.1299778
    M14: abs(C1 - C2)                                                -1.4725941
    M14: log(C1)                                                      8.5026011
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -0.8327012
                                                                         97.5%
    M12: (Intercept)                                                 -7.940490
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                2.578032
    M12: abs(C1 - C2)                                                 1.443114
    M12: log(C1)                                                    103.527683
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   2.142452
    M13: (Intercept)                                                  5.711713
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -0.204273
    M13: abs(C1 - C2)                                                 2.403744
    M13: log(C1)                                                     66.522255
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   3.767392
    M14: (Intercept)                                                 -3.793041
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                1.150053
    M14: abs(C1 - C2)                                                 1.787078
    M14: log(C1)                                                    102.640628
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   2.174837
                                                                    tail-prob.
    M12: (Intercept)                                                 0.0000000
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               0.8000000
    M12: abs(C1 - C2)                                                0.8666667
    M12: log(C1)                                                     0.0000000
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  0.7333333
    M13: (Intercept)                                                 0.1333333
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               0.0000000
    M13: abs(C1 - C2)                                                0.8666667
    M13: log(C1)                                                     0.2666667
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  0.0000000
    M14: (Intercept)                                                 0.0000000
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               0.4666667
    M14: abs(C1 - C2)                                                0.8666667
    M14: log(C1)                                                     0.0000000
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  0.6000000
                                                                      GR-crit
    M12: (Intercept)                                                 1.139539
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)              18.712066
    M12: abs(C1 - C2)                                                2.520000
    M12: log(C1)                                                     1.272897
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 20.337425
    M13: (Intercept)                                                 1.625384
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)              10.335413
    M13: abs(C1 - C2)                                                2.441857
    M13: log(C1)                                                     1.579611
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 17.908771
    M14: (Intercept)                                                 1.051927
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               9.135040
    M14: abs(C1 - C2)                                                1.013078
    M14: log(C1)                                                     1.043293
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  7.555883
                                                                       MCE/SD
    M12: (Intercept)                                                0.1825742
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)              0.5187946
    M12: abs(C1 - C2)                                               0.6639484
    M12: log(C1)                                                    0.1825742
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 0.8888170
    M13: (Intercept)                                                0.1825742
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)              0.5674710
    M13: abs(C1 - C2)                                               0.4518497
    M13: log(C1)                                                    0.1825742
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 0.5068755
    M14: (Intercept)                                                0.0759189
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)              0.5933684
    M14: abs(C1 - C2)                                               0.2131117
    M14: log(C1)                                                    0.1136399
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 0.4370537
    
    

