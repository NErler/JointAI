# GRcrit and MCerror give same result

    $m0a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M12: (Intercept)       1.05       1.27
    M13: (Intercept)       1.11       1.44
    M14: (Intercept)       1.05       1.27
    
    
    $m0b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M22: (Intercept)       1.25       1.77
    M23: (Intercept)       1.76       3.15
    M24: (Intercept)       1.42       2.45
    
    
    $m1a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M12: (Intercept)       1.22       1.77
    M12: C1                1.22       1.77
    M13: (Intercept)       1.03       1.24
    M13: C1                1.03       1.24
    M14: (Intercept)       1.03       1.18
    M14: C1                1.03       1.17
    
    
    $m1b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M22: (Intercept)       1.55       2.54
    M22: C1                1.56       2.57
    M23: (Intercept)       1.83       4.36
    M23: C1                1.84       4.42
    M24: (Intercept)       2.09       4.39
    M24: C1                2.09       4.39
    
    
    $m2a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M12: (Intercept)      0.997       1.01
    M12: C2               0.963       1.05
    M13: (Intercept)      1.347       2.02
    M13: C2               1.006       1.10
    M14: (Intercept)      1.351       2.12
    M14: C2               1.539       2.90
    
    
    $m2b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M22: (Intercept)       1.16       1.84
    M22: C2                1.11       1.58
    M23: (Intercept)       1.59       2.65
    M23: C2                1.03       1.26
    M24: (Intercept)       1.38       2.36
    M24: C2                1.07       1.11
    
    
    $m3a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    (Intercept)      1.039      1.346
    M12              0.927      0.948
    M13              0.995      1.200
    M14              1.026      1.304
    sigma_C1         0.996      1.201
    
    
    $m3b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    (Intercept)       1.06       1.31
    M22               1.02       1.19
    M23               1.06       1.33
    M24               1.19       1.75
    sigma_C1          1.11       1.48
    
    
    $m4a
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    M12: (Intercept)            1.05       1.31
    M12: M22                    1.26       1.80
    M12: M23                    1.88       3.39
    M12: M24                    1.66       4.30
    M12: O22                    3.95       8.33
    M12: O23                    1.88       6.27
    M12: O24                    3.18       5.97
    M12: abs(C1 - C2)           2.17       3.81
    M12: log(C1)                1.13       1.50
    M12: O22:abs(C1 - C2)       4.65       8.74
    M12: O23:abs(C1 - C2)       1.93       4.15
    M12: O24:abs(C1 - C2)       3.56       7.50
    M13: (Intercept)            1.01       1.12
    M13: M22                    1.04       1.27
    M13: M23                    1.12       1.57
    M13: M24                    1.06       1.31
    M13: O22                    6.25      12.57
    M13: O23                    3.57       7.66
    M13: O24                    2.94      13.61
    M13: abs(C1 - C2)           1.96       3.63
    M13: log(C1)                1.04       1.27
    M13: O22:abs(C1 - C2)       4.21       7.86
    M13: O23:abs(C1 - C2)       4.12       8.04
    M13: O24:abs(C1 - C2)       3.24       9.53
    M14: (Intercept)            1.00       1.07
    M14: M22                    1.25       1.98
    M14: M23                    1.31       2.26
    M14: M24                    1.02       1.15
    M14: O22                    1.34       2.30
    M14: O23                    4.52      10.15
    M14: O24                    1.90       3.67
    M14: abs(C1 - C2)           4.86       9.60
    M14: log(C1)                1.03       1.19
    M14: O22:abs(C1 - C2)       1.60       2.80
    M14: O23:abs(C1 - C2)       4.22       9.29
    M14: O24:abs(C1 - C2)       1.29       1.96
    
    
    $m4b
    Potential scale reduction factors:
    
                                                                    Point est.
    M12: (Intercept)                                                      1.37
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                    3.26
    M12: abs(C1 - C2)                                                     1.79
    M12: log(C1)                                                          1.39
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)       3.40
    M13: (Intercept)                                                      1.04
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                   12.51
    M13: abs(C1 - C2)                                                     1.89
    M13: log(C1)                                                          1.04
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)      10.61
    M14: (Intercept)                                                      1.15
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                    5.07
    M14: abs(C1 - C2)                                                     1.63
    M14: log(C1)                                                          1.12
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)       5.29
                                                                    Upper C.I.
    M12: (Intercept)                                                      2.23
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                    8.24
    M12: abs(C1 - C2)                                                     3.78
    M12: log(C1)                                                          2.30
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)       6.83
    M13: (Intercept)                                                      1.18
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                   26.07
    M13: abs(C1 - C2)                                                     3.48
    M13: log(C1)                                                          1.21
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)      35.15
    M14: (Intercept)                                                      1.54
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                   13.12
    M14: abs(C1 - C2)                                                     2.74
    M14: log(C1)                                                          1.47
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)      12.43
    
    

---

    $m0a
                       est  MCSE   SD MCSE/SD
    M12: (Intercept) -0.20 0.061 0.35    0.18
    M13: (Intercept) -0.46 0.049 0.27    0.18
    M14: (Intercept) -0.54 0.054 0.29    0.18
    
    $m0b
                       est  MCSE   SD MCSE/SD
    M22: (Intercept) 0.082 0.044 0.22    0.20
    M23: (Intercept) 0.167 0.067 0.28    0.24
    M24: (Intercept) 0.107 0.082 0.26    0.31
    
    $m1a
                     est MCSE SD MCSE/SD
    M12: (Intercept) -48  4.7 26    0.18
    M12: C1           33  3.3 18    0.18
    M13: (Intercept) -25  4.9 27    0.18
    M13: C1           17  3.4 19    0.18
    M14: (Intercept) -44  5.3 29    0.18
    M14: C1           30  3.7 20    0.18
    
    $m1b
                       est MCSE SD MCSE/SD
    M22: (Intercept)  -1.6  8.1 38    0.22
    M22: C1            1.2  5.7 26    0.22
    M23: (Intercept)  -1.3 12.7 37    0.34
    M23: C1            1.0  8.8 26    0.34
    M24: (Intercept) -29.0 12.0 33    0.36
    M24: C1           20.4  8.4 23    0.36
    
    $m2a
                        est  MCSE   SD MCSE/SD
    M12: (Intercept) -0.331 0.026 0.23    0.11
    M12: C2          -0.099 0.098 0.54    0.18
    M13: (Intercept) -0.685 0.132 0.31    0.43
    M13: C2          -0.844 0.147 0.69    0.21
    M14: (Intercept) -0.675 0.091 0.29    0.31
    M14: C2          -0.414 0.133 0.60    0.22
    
    $m2b
                        est  MCSE   SD MCSE/SD
    M22: (Intercept)  0.462 0.089 0.38   0.230
    M22: C2          -0.826 0.125 1.09   0.114
    M23: (Intercept)  0.525 0.117 0.42   0.278
    M23: C2           0.264 0.117 0.84   0.139
    M24: (Intercept)  0.551 0.131 0.49   0.268
    M24: C2           0.023 0.084 0.88   0.095
    
    $m3a
                   est  MCSE    SD MCSE/SD
    (Intercept) 1.4117 0.017 0.095    0.18
    M12         0.0435 0.026 0.141    0.18
    M13         0.0093 0.028 0.152    0.18
    M14         0.0355 0.017 0.093    0.18
    sigma_C1    0.0440 0.013 0.069    0.18
    
    $m3b
                   est    MCSE     SD MCSE/SD
    (Intercept) 1.4324 0.00069 0.0038    0.18
    M22         0.0013 0.00080 0.0044    0.18
    M23         0.0017 0.00087 0.0047    0.18
    M24         0.0052 0.00107 0.0053    0.20
    sigma_C1    0.0201 0.00033 0.0014    0.23
    
    $m4a
                              est    MCSE    SD MCSE/SD
    M12: (Intercept)      -22.756  2.1937 12.02   0.183
    M12: M22               -0.724  0.2627  0.68   0.387
    M12: M23                0.683  0.2880  0.54   0.538
    M12: M24               -0.246  0.2998  0.84   0.357
    M12: O22               -2.166  0.7493  1.53   0.490
    M12: O23               -2.054  0.3178  1.12   0.283
    M12: O24                0.450  0.6784  1.25   0.542
    M12: abs(C1 - C2)       0.068  0.4034  1.01   0.400
    M12: log(C1)           63.347  6.2287 34.12   0.183
    M12: O22:abs(C1 - C2)   1.391  0.6938  0.97   0.713
    M12: O23:abs(C1 - C2)   0.519  0.2267  0.74   0.307
    M12: O24:abs(C1 - C2)  -0.474  0.3946  0.85   0.465
    M13: (Intercept)       -8.200  2.2865 12.52   0.183
    M13: M22               -1.899  0.1233  0.60   0.207
    M13: M23               -1.132  0.1231  0.57   0.217
    M13: M24                0.289  0.1583  0.44   0.360
    M13: O22               -1.117  1.7057  1.99   0.857
    M13: O23                1.071  0.4717  1.09   0.432
    M13: O24                0.116  0.7165  1.88   0.382
    M13: abs(C1 - C2)       0.584  0.6356  1.15   0.552
    M13: log(C1)           17.950  6.6081 36.19   0.183
    M13: O22:abs(C1 - C2)   1.763  1.2904  1.53   0.843
    M13: O23:abs(C1 - C2)  -0.197  0.4731  0.99   0.477
    M13: O24:abs(C1 - C2)   0.663  0.5075  1.17   0.434
    M14: (Intercept)      -19.518  1.8632 15.90   0.117
    M14: M22               -0.752  0.1270  0.70   0.183
    M14: M23               -0.664  0.0095  0.71   0.013
    M14: M24               -1.386  0.1191  0.65   0.183
    M14: O22                   NA      NA  1.18      NA
    M14: O23               -1.008  1.1474  1.79   0.642
    M14: O24                2.257  0.1843  0.75   0.245
    M14: abs(C1 - C2)       0.220  1.0267  1.55   0.663
    M14: log(C1)           53.200 14.6498 45.83   0.320
    M14: O22:abs(C1 - C2)   1.153  0.5193  1.02   0.511
    M14: O23:abs(C1 - C2)   0.605  0.6722  1.24   0.544
    M14: O24:abs(C1 - C2)  -1.904  0.1146  0.63   0.183
    
    $m4b
                                                                        est MCSE
    M12: (Intercept)                                                -22.095 3.40
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                0.061 0.70
    M12: abs(C1 - C2)                                                -0.196 0.13
    M12: log(C1)                                                     61.445 9.46
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -0.064 0.43
    M13: (Intercept)                                                -13.614 2.69
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -0.283 3.06
    M13: abs(C1 - C2)                                                 0.466 0.27
    M13: log(C1)                                                     34.320 7.39
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   0.368 1.90
    M14: (Intercept)                                                -20.310 2.24
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -0.016 1.77
    M14: abs(C1 - C2)                                                 0.238 0.56
    M14: log(C1)                                                     54.350 6.34
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -0.219 1.38
                                                                       SD MCSE/SD
    M12: (Intercept)                                                12.64    0.27
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               1.17    0.60
    M12: abs(C1 - C2)                                                0.73    0.18
    M12: log(C1)                                                    34.75    0.27
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  0.76    0.56
    M13: (Intercept)                                                14.71    0.18
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               2.94    1.04
    M13: abs(C1 - C2)                                                1.10    0.24
    M13: log(C1)                                                    40.49    0.18
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  1.78    1.07
    M14: (Intercept)                                                12.29    0.18
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               1.94    0.91
    M14: abs(C1 - C2)                                                0.99    0.56
    M14: log(C1)                                                    34.74    0.18
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  1.27    1.08
    

# summary output remained the same

    
    Call:
    mlogit_imp(formula = M1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
    (Intercept) (Intercept) (Intercept) 
        -0.1991     -0.4567     -0.5357 
    
    Call:
    mlogit_imp(formula = M2 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M2" 
    
    
    Coefficients:
    (Intercept) (Intercept) (Intercept) 
        0.08186     0.16715     0.10684 
    
    Call:
    mlogit_imp(formula = M1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
    (Intercept)          C1 (Intercept)          C1 (Intercept)          C1 
         -47.76       33.10      -25.48       17.39      -44.13       30.35 
    
    Call:
    mlogit_imp(formula = M2 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M2" 
    
    
    Coefficients:
    (Intercept)          C1 (Intercept)          C1 (Intercept)          C1 
         -1.587       1.247      -1.318       1.049     -28.989      20.380 
    
    Call:
    mlogit_imp(formula = M1 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
    (Intercept)          C2 (Intercept)          C2 (Intercept)          C2 
       -0.33100    -0.09861    -0.68494    -0.84368    -0.67534    -0.41395 
    
    Call:
    mlogit_imp(formula = M2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M2" 
    
    
    Coefficients:
    (Intercept)          C2 (Intercept)          C2 (Intercept)          C2 
        0.46176    -0.82597     0.52472     0.26357     0.55114     0.02251 
    
    Call:
    lm_imp(formula = C1 ~ M1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)         M12         M13         M14 
       1.411723    0.043502    0.009345    0.035515 
    
    
    Residual standard deviation:
    sigma_C1 
     0.04403 
    
    Call:
    lm_imp(formula = C1 ~ M2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)         M22         M23         M24 
       1.432391    0.001332    0.001738    0.005221 
    
    
    Residual standard deviation:
    sigma_C1 
     0.02008 
    
    Call:
    mlogit_imp(formula = M1 ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_M1"), 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
         (Intercept)              M22              M23              M24 
           -22.75606         -0.72351          0.68348         -0.24620 
                 O22              O23              O24     abs(C1 - C2) 
            -2.16613         -2.05393          0.45003          0.06833 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
            63.34657          1.39089          0.51940         -0.47409 
         (Intercept)              M22              M23              M24 
            -8.20000         -1.89937         -1.13170          0.28929 
                 O22              O23              O24     abs(C1 - C2) 
            -1.11717          1.07066          0.11551          0.58356 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
            17.95009          1.76265         -0.19750          0.66281 
         (Intercept)              M22              M23              M24 
           -19.51844         -0.75220         -0.66377         -1.38639 
                 O22              O23              O24     abs(C1 - C2) 
            -0.70776         -1.00765          2.25721          0.22009 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
            53.19957          1.15337          0.60476         -1.90401 
    
    Call:
    mlogit_imp(formula = M1 ~ ifelse(as.numeric(M2) > as.numeric(O1), 
        1, 0) * abs(C1 - C2) + log(C1), data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_M1"), seed = 2020, 
        warn = FALSE)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
                                                   (Intercept) 
                                                     -22.09524 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                       0.06126 
                                                  abs(C1 - C2) 
                                                      -0.19563 
                                                       log(C1) 
                                                      61.44513 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                      -0.06422 
                                                   (Intercept) 
                                                     -13.61386 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                      -0.28306 
                                                  abs(C1 - C2) 
                                                       0.46615 
                                                       log(C1) 
                                                      34.32018 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                       0.36806 
                                                   (Intercept) 
                                                     -20.30981 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                      -0.01631 
                                                  abs(C1 - C2) 
                                                       0.23825 
                                                       log(C1) 
                                                      54.35013 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                      -0.21946 
    $m0a
    
    Call:
    mlogit_imp(formula = M1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
    (Intercept) (Intercept) (Intercept) 
        -0.1991     -0.4567     -0.5357 
    
    $m0b
    
    Call:
    mlogit_imp(formula = M2 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M2" 
    
    
    Coefficients:
    (Intercept) (Intercept) (Intercept) 
        0.08186     0.16715     0.10684 
    
    $m1a
    
    Call:
    mlogit_imp(formula = M1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
    (Intercept)          C1 (Intercept)          C1 (Intercept)          C1 
         -47.76       33.10      -25.48       17.39      -44.13       30.35 
    
    $m1b
    
    Call:
    mlogit_imp(formula = M2 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M2" 
    
    
    Coefficients:
    (Intercept)          C1 (Intercept)          C1 (Intercept)          C1 
         -1.587       1.247      -1.318       1.049     -28.989      20.380 
    
    $m2a
    
    Call:
    mlogit_imp(formula = M1 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
    (Intercept)          C2 (Intercept)          C2 (Intercept)          C2 
       -0.33100    -0.09861    -0.68494    -0.84368    -0.67534    -0.41395 
    
    $m2b
    
    Call:
    mlogit_imp(formula = M2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian multinomial logit model for "M2" 
    
    
    Coefficients:
    (Intercept)          C2 (Intercept)          C2 (Intercept)          C2 
        0.46176    -0.82597     0.52472     0.26357     0.55114     0.02251 
    
    $m3a
    
    Call:
    lm_imp(formula = C1 ~ M1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)         M12         M13         M14 
       1.411723    0.043502    0.009345    0.035515 
    
    
    Residual standard deviation:
    sigma_C1 
     0.04403 
    
    $m3b
    
    Call:
    lm_imp(formula = C1 ~ M2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)         M22         M23         M24 
       1.432391    0.001332    0.001738    0.005221 
    
    
    Residual standard deviation:
    sigma_C1 
     0.02008 
    
    $m4a
    
    Call:
    mlogit_imp(formula = M1 ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_M1"), 
        seed = 2020)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
         (Intercept)              M22              M23              M24 
           -22.75606         -0.72351          0.68348         -0.24620 
                 O22              O23              O24     abs(C1 - C2) 
            -2.16613         -2.05393          0.45003          0.06833 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
            63.34657          1.39089          0.51940         -0.47409 
         (Intercept)              M22              M23              M24 
            -8.20000         -1.89937         -1.13170          0.28929 
                 O22              O23              O24     abs(C1 - C2) 
            -1.11717          1.07066          0.11551          0.58356 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
            17.95009          1.76265         -0.19750          0.66281 
         (Intercept)              M22              M23              M24 
           -19.51844         -0.75220         -0.66377         -1.38639 
                 O22              O23              O24     abs(C1 - C2) 
            -0.70776         -1.00765          2.25721          0.22009 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
            53.19957          1.15337          0.60476         -1.90401 
    
    $m4b
    
    Call:
    mlogit_imp(formula = M1 ~ ifelse(as.numeric(M2) > as.numeric(O1), 
        1, 0) * abs(C1 - C2) + log(C1), data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_M1"), seed = 2020, 
        warn = FALSE)
    
     Bayesian multinomial logit model for "M1" 
    
    
    Coefficients:
                                                   (Intercept) 
                                                     -22.09524 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                       0.06126 
                                                  abs(C1 - C2) 
                                                      -0.19563 
                                                       log(C1) 
                                                      61.44513 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                      -0.06422 
                                                   (Intercept) 
                                                     -13.61386 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                      -0.28306 
                                                  abs(C1 - C2) 
                                                       0.46615 
                                                       log(C1) 
                                                      34.32018 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                       0.36806 
                                                   (Intercept) 
                                                     -20.30981 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                      -0.01631 
                                                  abs(C1 - C2) 
                                                       0.23825 
                                                       log(C1) 
                                                      54.35013 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                      -0.21946 
    

---

    $m0a
    $m0a$M1
    (Intercept) (Intercept) (Intercept) 
     -0.1991333  -0.4567400  -0.5356710 
    
    
    $m0b
    $m0b$M2
    (Intercept) (Intercept) (Intercept) 
     0.08186288  0.16714627  0.10683517 
    
    
    $m1a
    $m1a$M1
    (Intercept)          C1 (Intercept)          C1 (Intercept)          C1 
      -47.75541    33.09711   -25.47627    17.39445   -44.12530    30.34907 
    
    
    $m1b
    $m1b$M2
    (Intercept)          C1 (Intercept)          C1 (Intercept)          C1 
      -1.586682    1.246525   -1.318285    1.049466  -28.989424   20.379509 
    
    
    $m2a
    $m2a$M1
    (Intercept)          C2 (Intercept)          C2 (Intercept)          C2 
     -0.3310000  -0.0986074  -0.6849389  -0.8436799  -0.6753447  -0.4139463 
    
    
    $m2b
    $m2b$M2
    (Intercept)          C2 (Intercept)          C2 (Intercept)          C2 
     0.46176262 -0.82597475  0.52471709  0.26357204  0.55114456  0.02251215 
    
    
    $m3a
    $m3a$C1
    (Intercept)         M12         M13         M14 
    1.411723231 0.043502417 0.009345015 0.035515397 
    
    
    $m3b
    $m3b$C1
    (Intercept)         M22         M23         M24 
    1.432391389 0.001331535 0.001738037 0.005220603 
    
    
    $m4a
    $m4a$M1
         (Intercept)              M22              M23              M24 
        -22.75605951      -0.72351192       0.68347526      -0.24619879 
                 O22              O23              O24     abs(C1 - C2) 
         -2.16612577      -2.05392803       0.45002856       0.06833179 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
         63.34657009       1.39089367       0.51940429      -0.47408950 
         (Intercept)              M22              M23              M24 
         -8.19999754      -1.89936512      -1.13170291       0.28929255 
                 O22              O23              O24     abs(C1 - C2) 
         -1.11716614       1.07066200       0.11550796       0.58356257 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
         17.95008602       1.76265342      -0.19749891       0.66280587 
         (Intercept)              M22              M23              M24 
        -19.51843802      -0.75219766      -0.66376821      -1.38638927 
                 O22              O23              O24     abs(C1 - C2) 
         -0.70775928      -1.00765310       2.25720918       0.22008638 
             log(C1) O22:abs(C1 - C2) O23:abs(C1 - C2) O24:abs(C1 - C2) 
         53.19956745       1.15337231       0.60476130      -1.90400993 
    
    
    $m4b
    $m4b$M1
                                                   (Intercept) 
                                                  -22.09524153 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                    0.06125530 
                                                  abs(C1 - C2) 
                                                   -0.19562932 
                                                       log(C1) 
                                                   61.44513454 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                   -0.06421625 
                                                   (Intercept) 
                                                  -13.61385657 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                   -0.28306044 
                                                  abs(C1 - C2) 
                                                    0.46615341 
                                                       log(C1) 
                                                   34.32017835 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                    0.36805757 
                                                   (Intercept) 
                                                  -20.30981490 
                 ifelse(as.numeric(M2) > as.numeric(O1), 1, 0) 
                                                   -0.01631328 
                                                  abs(C1 - C2) 
                                                    0.23825387 
                                                       log(C1) 
                                                   54.35012696 
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 
                                                   -0.21945670 
    
    

---

    $m0a
    $m0a$M1
                      2.5%        97.5%
    (Intercept) -0.8729574  0.347971764
    (Intercept) -0.8513739  0.009762801
    (Intercept) -1.0263750 -0.053592982
    
    
    $m0b
    $m0b$M2
                      2.5%     97.5%
    (Intercept) -0.2316991 0.5324284
    (Intercept) -0.2892109 0.6804126
    (Intercept) -0.3992651 0.4542914
    
    
    $m1a
    $m1a$M1
                       2.5%     97.5%
    (Intercept)  -88.565888 -2.166742
    C1             1.332604 61.409204
    (Intercept)  -70.634454 18.691091
    C1           -13.459041 48.859971
    (Intercept) -107.603635  4.123719
    C1            -3.192869 74.228367
    
    
    $m1b
    $m1b$M2
                     2.5%    97.5%
    (Intercept) -74.06780 54.88543
    C1          -37.83915 52.06109
    (Intercept) -69.19055 48.77976
    C1          -33.70314 48.70010
    (Intercept) -89.02588 22.33684
    C1          -15.60195 62.28285
    
    
    $m2a
    $m2a$M1
                     2.5%       97.5%
    (Intercept) -0.668291  0.10488060
    C2          -1.115257  0.82074938
    (Intercept) -1.356694 -0.29074657
    C2          -2.395135  0.04600474
    (Intercept) -1.152760 -0.18889646
    C2          -1.341112  0.73512350
    
    
    $m2b
    $m2b$M2
                      2.5%     97.5%
    (Intercept) -0.4600186 0.9975725
    C2          -2.3545707 1.1171074
    (Intercept) -0.2511362 1.1089049
    C2          -1.2117769 1.7286554
    (Intercept) -0.3555959 1.2314532
    C2          -1.5178227 1.4792984
    
    
    $m3a
    $m3a$C1
                        2.5%     97.5%
    (Intercept)  1.211601066 1.4599402
    M12         -0.031393839 0.4497941
    M13         -0.270780945 0.2520779
    M14         -0.009377649 0.2916742
    
    
    $m3b
    $m3b$C1
                        2.5%       97.5%
    (Intercept)  1.425861243 1.438745087
    M22         -0.006612062 0.009837361
    M23         -0.006470470 0.010927718
    M24         -0.003108196 0.014837976
    
    
    $m4a
    $m4a$M1
                             2.5%        97.5%
    (Intercept)      -44.39899903  -4.08297194
    M22               -1.92846081   0.38444053
    M23               -0.17770960   1.70164526
    M24               -2.30613234   0.80116955
    O22               -4.24500421   0.26603402
    O23               -4.16237689  -0.51392114
    O24               -1.64735125   2.50351111
    abs(C1 - C2)      -1.69659759   1.95834541
    log(C1)           13.88544645 126.64478274
    O22:abs(C1 - C2)   0.01559889   3.02244783
    O23:abs(C1 - C2)  -0.80168553   1.74973918
    O24:abs(C1 - C2)  -1.85999489   1.02037119
    (Intercept)      -35.57309224  10.16405130
    M22               -2.85055806  -0.81533749
    M23               -2.35514144  -0.21871046
    M24               -0.22953015   1.18276173
    O22               -4.27868368   1.26656246
    O23               -0.40328440   3.53369784
    O24               -2.02724260   4.55875064
    abs(C1 - C2)      -1.33836682   2.78379706
    log(C1)          -35.81426257  94.26833801
    O22:abs(C1 - C2)  -0.17814390   4.31814673
    O23:abs(C1 - C2)  -1.85834206   1.36261255
    O24:abs(C1 - C2)  -1.99627282   2.00934913
    (Intercept)      -44.90696015  17.67679644
    M22               -2.15507082   0.06841692
    M23               -2.03483943   0.40675977
    M24               -2.44982156  -0.48946233
    O22               -2.68012184   1.56346455
    O23               -3.24433880   1.68130791
    O24                1.10777257   3.63248379
    abs(C1 - C2)      -2.51633519   2.20399079
    log(C1)          -52.45332528 125.01652918
    O22:abs(C1 - C2)  -1.19752102   2.55262650
    O23:abs(C1 - C2)  -1.46420921   2.46596164
    O24:abs(C1 - C2)  -3.02685649  -0.75327196
    
    
    $m4b
    $m4b$M1
                                                                     2.5%
    (Intercept)                                                -47.023626
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -2.176296
    abs(C1 - C2)                                                -1.399176
    log(C1)                                                     -3.592702
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -1.317628
    (Intercept)                                                -43.457165
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -3.679506
    abs(C1 - C2)                                                -1.375353
    log(C1)                                                    -14.675154
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -2.557767
    (Intercept)                                                -41.017133
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -2.859442
    abs(C1 - C2)                                                -1.855139
    log(C1)                                                    -13.374327
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -1.689889
                                                                     97.5%
    (Intercept)                                                  0.8370506
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                1.9941190
    abs(C1 - C2)                                                 1.2785425
    log(C1)                                                    132.2114856
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   1.2683075
    (Intercept)                                                  3.1452971
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                4.3453034
    abs(C1 - C2)                                                 2.7990898
    log(C1)                                                    115.7492231
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   2.4683213
    (Intercept)                                                  4.0883466
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                2.2099937
    abs(C1 - C2)                                                 2.1009215
    log(C1)                                                    109.5992574
    ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   1.7876031
    
    

---

    $m0a
    
    Bayesian multinomial logit model fitted with JointAI
    
    Call:
    mlogit_imp(formula = M1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
                       Mean    SD   2.5%    97.5% tail-prob. GR-crit MCE/SD
    M12: (Intercept) -0.199 0.346 -0.873  0.34797     0.6667    1.39  0.177
    M13: (Intercept) -0.457 0.267 -0.851  0.00976     0.0667    1.41  0.183
    M14: (Intercept) -0.536 0.294 -1.026 -0.05359     0.0667    1.34  0.183
    
    
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
                       Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    M22: (Intercept) 0.0819 0.219 -0.232 0.532      0.800    1.51  0.199
    M23: (Intercept) 0.1671 0.279 -0.289 0.680      0.533    2.12  0.242
    M24: (Intercept) 0.1068 0.260 -0.399 0.454      0.600    1.55  0.314
    
    
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
    M12: (Intercept) -47.8 26.0  -88.57 -2.17     0.0667    1.17  0.183
    M12: C1           33.1 18.1    1.33 61.41     0.0667    1.17  0.183
    M13: (Intercept) -25.5 26.6  -70.63 18.69     0.4667    1.02  0.183
    M13: C1           17.4 18.6  -13.46 48.86     0.4667    1.02  0.183
    M14: (Intercept) -44.1 29.3 -107.60  4.12     0.1333    1.14  0.183
    M14: C1           30.3 20.4   -3.19 74.23     0.1333    1.14  0.183
    
    
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
    M22: (Intercept)  -1.59 37.8 -74.1  54.9      0.933    2.58  0.216
    M22: C1            1.25 26.4 -37.8  52.1      0.933    2.61  0.216
    M23: (Intercept)  -1.32 37.0 -69.2  48.8      1.000    5.75  0.342
    M23: C1            1.05 25.8 -33.7  48.7      1.000    5.83  0.342
    M24: (Intercept) -28.99 33.2 -89.0  22.3      0.400    3.40  0.361
    M24: C1           20.38 23.2 -15.6  62.3      0.400    3.42  0.360
    
    
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
                        Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    M12: (Intercept) -0.3310 0.230 -0.668  0.105        0.2   1.219  0.112
    M12: C2          -0.0986 0.535 -1.115  0.821        1.0   0.993  0.183
    M13: (Intercept) -0.6849 0.308 -1.357 -0.291        0.0   1.399  0.429
    M13: C2          -0.8437 0.694 -2.395  0.046        0.2   1.012  0.211
    M14: (Intercept) -0.6753 0.291 -1.153 -0.189        0.0   1.248  0.312
    M14: C2          -0.4139 0.596 -1.341  0.735        0.4   1.855  0.223
    
    
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
    M22: (Intercept)  0.4618 0.385 -0.460 0.998      0.267    2.04  0.230
    M22: C2          -0.8260 1.093 -2.355 1.117      0.600    1.35  0.114
    M23: (Intercept)  0.5247 0.421 -0.251 1.109      0.333    3.52  0.278
    M23: C2           0.2636 0.841 -1.212 1.729      0.867    1.25  0.139
    M24: (Intercept)  0.5511 0.487 -0.356 1.231      0.267    2.67  0.268
    M24: C2           0.0225 0.882 -1.518 1.479      0.933    1.32  0.095
    
    
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
                   Mean     SD     2.5% 97.5% tail-prob. GR-crit MCE/SD
    (Intercept) 1.41172 0.0953  1.21160 1.460      0.000    2.36  0.183
    M12         0.04350 0.1406 -0.03139 0.450      0.133    1.32  0.183
    M13         0.00935 0.1518 -0.27078 0.252      0.600    1.77  0.183
    M14         0.03552 0.0934 -0.00938 0.292      0.333    1.12  0.183
    
    Posterior summary of residual std. deviation:
              Mean     SD   2.5% 97.5% GR-crit MCE/SD
    sigma_C1 0.044 0.0685 0.0171 0.241    1.01  0.183
    
    
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
    (Intercept) 1.43239 0.00376  1.42586 1.43875        0.0    1.44  0.183
    M22         0.00133 0.00439 -0.00661 0.00984        0.6    1.22  0.183
    M23         0.00174 0.00475 -0.00647 0.01093        0.6    1.21  0.182
    M24         0.00522 0.00535 -0.00311 0.01484        0.4    1.64  0.200
    
    Posterior summary of residual std. deviation:
               Mean      SD   2.5%  97.5% GR-crit MCE/SD
    sigma_C1 0.0201 0.00144 0.0176 0.0231    1.44  0.232
    
    
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
    M12: (Intercept)      -22.7561 12.015 -44.3990  -4.0830     0.0000    1.32
    M12: M22               -0.7235  0.679  -1.9285   0.3844     0.2667    2.17
    M12: M23                0.6835  0.535  -0.1777   1.7016     0.1333    3.44
    M12: M24               -0.2462  0.840  -2.3061   0.8012     0.8667    3.74
    M12: O22               -2.1661  1.530  -4.2450   0.2660     0.2000    9.95
    M12: O23               -2.0539  1.121  -4.1624  -0.5139     0.0000    5.00
    M12: O24                0.4500  1.252  -1.6474   2.5035     0.6667    6.48
    M12: abs(C1 - C2)       0.0683  1.009  -1.6966   1.9583     0.9333    2.79
    M12: log(C1)           63.3466 34.116  13.8854 126.6448     0.0667    1.41
    M12: O22:abs(C1 - C2)   1.3909  0.973   0.0156   3.0224     0.0000    7.98
    M12: O23:abs(C1 - C2)   0.5194  0.738  -0.8017   1.7497     0.5333    2.17
    M12: O24:abs(C1 - C2)  -0.4741  0.849  -1.8600   1.0204     0.5333    6.49
    M13: (Intercept)       -8.2000 12.524 -35.5731  10.1641     0.5333    1.04
    M13: M22               -1.8994  0.597  -2.8506  -0.8153     0.0000    1.07
    M13: M23               -1.1317  0.566  -2.3551  -0.2187     0.0667    1.28
    M13: M24                0.2893  0.440  -0.2295   1.1828     0.8000    1.57
    M13: O22               -1.1172  1.991  -4.2787   1.2666     0.9333   11.96
    M13: O23                1.0707  1.092  -0.4033   3.5337     0.3333    5.95
    M13: O24                0.1155  1.876  -2.0272   4.5588     0.8000   10.50
    M13: abs(C1 - C2)       0.5836  1.151  -1.3384   2.7838     0.7333    3.56
    M13: log(C1)           17.9501 36.194 -35.8143  94.2683     0.6667    1.08
    M13: O22:abs(C1 - C2)   1.7627  1.531  -0.1781   4.3181     0.1333    7.71
    M13: O23:abs(C1 - C2)  -0.1975  0.991  -1.8583   1.3626     0.9333    6.78
    M13: O24:abs(C1 - C2)   0.6628  1.170  -1.9963   2.0093     0.3333    7.43
    M14: (Intercept)      -19.5184 15.899 -44.9070  17.6768     0.1333    1.14
    M14: M22               -0.7522  0.696  -2.1551   0.0684     0.2667    1.21
    M14: M23               -0.6638  0.707  -2.0348   0.4068     0.4000    1.35
    M14: M24               -1.3864  0.652  -2.4498  -0.4895     0.0000    1.09
    M14: O22               -0.7078  1.180  -2.6801   1.5635     0.6667    3.00
    M14: O23               -1.0077  1.787  -3.2443   1.6813     0.6667   10.80
    M14: O24                2.2572  0.752   1.1078   3.6325     0.0000    2.87
    M14: abs(C1 - C2)       0.2201  1.549  -2.5163   2.2040     0.8000    7.24
    M14: log(C1)           53.1996 45.833 -52.4533 125.0165     0.2000    1.27
    M14: O22:abs(C1 - C2)   1.1534  1.016  -1.1975   2.5526     0.2000    3.75
    M14: O23:abs(C1 - C2)   0.6048  1.236  -1.4642   2.4660     0.6667    9.67
    M14: O24:abs(C1 - C2)  -1.9040  0.628  -3.0269  -0.7533     0.0000    1.68
                          MCE/SD
    M12: (Intercept)      0.1826
    M12: M22              0.3868
    M12: M23              0.5381
    M12: M24              0.3570
    M12: O22              0.4898
    M12: O23              0.2834
    M12: O24              0.5419
    M12: abs(C1 - C2)     0.4000
    M12: log(C1)          0.1826
    M12: O22:abs(C1 - C2) 0.7130
    M12: O23:abs(C1 - C2) 0.3074
    M12: O24:abs(C1 - C2) 0.4649
    M13: (Intercept)      0.1826
    M13: M22              0.2065
    M13: M23              0.2174
    M13: M24              0.3602
    M13: O22              0.8568
    M13: O23              0.4320
    M13: O24              0.3820
    M13: abs(C1 - C2)     0.5523
    M13: log(C1)          0.1826
    M13: O22:abs(C1 - C2) 0.8426
    M13: O23:abs(C1 - C2) 0.4772
    M13: O24:abs(C1 - C2) 0.4338
    M14: (Intercept)      0.1172
    M14: M22              0.1826
    M14: M23              0.0134
    M14: M24              0.1826
    M14: O22                    
    M14: O23              0.6420
    M14: O24              0.2449
    M14: abs(C1 - C2)     0.6629
    M14: log(C1)          0.3196
    M14: O22:abs(C1 - C2) 0.5110
    M14: O23:abs(C1 - C2) 0.5440
    M14: O24:abs(C1 - C2) 0.1826
    
    
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
    M12: (Intercept)                                                -22.0952 12.641
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                0.0613  1.168
    M12: abs(C1 - C2)                                                -0.1956  0.732
    M12: log(C1)                                                     61.4451 34.749
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -0.0642  0.762
    M13: (Intercept)                                                -13.6139 14.709
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -0.2831  2.941
    M13: abs(C1 - C2)                                                 0.4662  1.098
    M13: log(C1)                                                     34.3202 40.488
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   0.3681  1.784
    M14: (Intercept)                                                -20.3098 12.289
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -0.0163  1.938
    M14: abs(C1 - C2)                                                 0.2383  0.994
    M14: log(C1)                                                     54.3501 34.744
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -0.2195  1.274
                                                                      2.5%   97.5%
    M12: (Intercept)                                                -47.02   0.837
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -2.18   1.994
    M12: abs(C1 - C2)                                                -1.40   1.279
    M12: log(C1)                                                     -3.59 132.211
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -1.32   1.268
    M13: (Intercept)                                                -43.46   3.145
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -3.68   4.345
    M13: abs(C1 - C2)                                                -1.38   2.799
    M13: log(C1)                                                    -14.68 115.749
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -2.56   2.468
    M14: (Intercept)                                                -41.02   4.088
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -2.86   2.210
    M14: abs(C1 - C2)                                                -1.86   2.101
    M14: log(C1)                                                    -13.37 109.599
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -1.69   1.788
                                                                    tail-prob.
    M12: (Intercept)                                                     0.133
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                   0.933
    M12: abs(C1 - C2)                                                    0.733
    M12: log(C1)                                                         0.133
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)      0.800
    M13: (Intercept)                                                     0.333
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                   0.667
    M13: abs(C1 - C2)                                                    0.667
    M13: log(C1)                                                         0.333
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)      0.667
    M14: (Intercept)                                                     0.133
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                   0.800
    M14: abs(C1 - C2)                                                    0.733
    M14: log(C1)                                                         0.200
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)      0.800
                                                                    GR-crit MCE/SD
    M12: (Intercept)                                                   1.85  0.269
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                 6.15  0.598
    M12: abs(C1 - C2)                                                  1.99  0.183
    M12: log(C1)                                                       1.90  0.272
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)    7.13  0.563
    M13: (Intercept)                                                   1.89  0.183
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                16.99  1.041
    M13: abs(C1 - C2)                                                  3.00  0.241
    M13: log(C1)                                                       2.04  0.183
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   16.73  1.066
    M14: (Intercept)                                                   1.94  0.183
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                12.38  0.912
    M14: abs(C1 - C2)                                                  3.19  0.561
    M14: log(C1)                                                       1.83  0.183
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)    8.58  1.081
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    

---

    $m0a
    $m0a$M1
                           Mean        SD       2.5%        97.5% tail-prob.
    M12: (Intercept) -0.1991333 0.3461909 -0.8729574  0.347971764 0.66666667
    M13: (Intercept) -0.4567400 0.2671126 -0.8513739  0.009762801 0.06666667
    M14: (Intercept) -0.5356710 0.2939147 -1.0263750 -0.053592982 0.06666667
                      GR-crit    MCE/SD
    M12: (Intercept) 1.386778 0.1769101
    M13: (Intercept) 1.411614 0.1825742
    M14: (Intercept) 1.339933 0.1825742
    
    
    $m0b
    $m0b$M2
                           Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    M22: (Intercept) 0.08186288 0.2191761 -0.2316991 0.5324284  0.8000000 1.508439
    M23: (Intercept) 0.16714627 0.2787948 -0.2892109 0.6804126  0.5333333 2.115579
    M24: (Intercept) 0.10683517 0.2598145 -0.3992651 0.4542914  0.6000000 1.549388
                        MCE/SD
    M22: (Intercept) 0.1988002
    M23: (Intercept) 0.2419915
    M24: (Intercept) 0.3143237
    
    
    $m1a
    $m1a$M1
                          Mean       SD        2.5%     97.5% tail-prob.  GR-crit
    M12: (Intercept) -47.75541 26.01103  -88.565888 -2.166742 0.06666667 1.171947
    M12: C1           33.09711 18.12706    1.332604 61.409204 0.06666667 1.169748
    M13: (Intercept) -25.47627 26.58753  -70.634454 18.691091 0.46666667 1.020608
    M13: C1           17.39445 18.56584  -13.459041 48.859971 0.46666667 1.021487
    M14: (Intercept) -44.12530 29.29487 -107.603635  4.123719 0.13333333 1.142683
    M14: C1           30.34907 20.41575   -3.192869 74.228367 0.13333333 1.135301
                        MCE/SD
    M12: (Intercept) 0.1825742
    M12: C1          0.1825742
    M13: (Intercept) 0.1825742
    M13: C1          0.1825742
    M14: (Intercept) 0.1825742
    M14: C1          0.1825742
    
    
    $m1b
    $m1b$M2
                           Mean       SD      2.5%    97.5% tail-prob.  GR-crit
    M22: (Intercept)  -1.586682 37.75412 -74.06780 54.88543  0.9333333 2.584558
    M22: C1            1.246525 26.35230 -37.83915 52.06109  0.9333333 2.608079
    M23: (Intercept)  -1.318285 36.95605 -69.19055 48.77976  1.0000000 5.751605
    M23: C1            1.049466 25.83369 -33.70314 48.70010  1.0000000 5.827310
    M24: (Intercept) -28.989424 33.20016 -89.02588 22.33684  0.4000000 3.398998
    M24: C1           20.379509 23.22558 -15.60195 62.28285  0.4000000 3.421078
                        MCE/SD
    M22: (Intercept) 0.2155433
    M22: C1          0.2158194
    M23: (Intercept) 0.3423800
    M23: C1          0.3418280
    M24: (Intercept) 0.3610240
    M24: C1          0.3603038
    
    
    $m2a
    $m2a$M1
                           Mean        SD      2.5%       97.5% tail-prob.
    M12: (Intercept) -0.3310000 0.2303991 -0.668291  0.10488060        0.2
    M12: C2          -0.0986074 0.5350601 -1.115257  0.82074938        1.0
    M13: (Intercept) -0.6849389 0.3077664 -1.356694 -0.29074657        0.0
    M13: C2          -0.8436799 0.6941419 -2.395135  0.04600474        0.2
    M14: (Intercept) -0.6753447 0.2914226 -1.152760 -0.18889646        0.0
    M14: C2          -0.4139463 0.5958675 -1.341112  0.73512350        0.4
                       GR-crit    MCE/SD
    M12: (Intercept) 1.2189809 0.1119633
    M12: C2          0.9931291 0.1825742
    M13: (Intercept) 1.3987585 0.4290333
    M13: C2          1.0123093 0.2113422
    M14: (Intercept) 1.2480788 0.3122590
    M14: C2          1.8550057 0.2225874
    
    
    $m2b
    $m2b$M2
                            Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    M22: (Intercept)  0.46176262 0.3848844 -0.4600186 0.9975725  0.2666667 2.044113
    M22: C2          -0.82597475 1.0931475 -2.3545707 1.1171074  0.6000000 1.345627
    M23: (Intercept)  0.52471709 0.4208004 -0.2511362 1.1089049  0.3333333 3.515887
    M23: C2           0.26357204 0.8407769 -1.2117769 1.7286554  0.8666667 1.252077
    M24: (Intercept)  0.55114456 0.4874599 -0.3555959 1.2314532  0.2666667 2.665144
    M24: C2           0.02251215 0.8822720 -1.5178227 1.4792984  0.9333333 1.317799
                         MCE/SD
    M22: (Intercept) 0.22997106
    M22: C2          0.11408044
    M23: (Intercept) 0.27846512
    M23: C2          0.13935137
    M24: (Intercept) 0.26805584
    M24: C2          0.09500505
    
    
    $m3a
    $m3a$C1
                       Mean         SD         2.5%     97.5% tail-prob.  GR-crit
    (Intercept) 1.411723231 0.09534028  1.211601066 1.4599402  0.0000000 2.360744
    M12         0.043502417 0.14064667 -0.031393839 0.4497941  0.1333333 1.315768
    M13         0.009345015 0.15183204 -0.270780945 0.2520779  0.6000000 1.774621
    M14         0.035515397 0.09336101 -0.009377649 0.2916742  0.3333333 1.120389
                   MCE/SD
    (Intercept) 0.1825742
    M12         0.1825742
    M13         0.1825742
    M14         0.1825742
    
    
    $m3b
    $m3b$C1
                       Mean          SD         2.5%       97.5% tail-prob.
    (Intercept) 1.432391389 0.003761970  1.425861243 1.438745087        0.0
    M22         0.001331535 0.004385657 -0.006612062 0.009837361        0.6
    M23         0.001738037 0.004747052 -0.006470470 0.010927718        0.6
    M24         0.005220603 0.005349547 -0.003108196 0.014837976        0.4
                 GR-crit    MCE/SD
    (Intercept) 1.443346 0.1825742
    M22         1.222469 0.1825742
    M23         1.213642 0.1822581
    M24         1.635539 0.1999533
    
    
    $m4a
    $m4a$M1
                                  Mean         SD         2.5%        97.5%
    M12: (Intercept)      -22.75605951 12.0152198 -44.39899903  -4.08297194
    M12: M22               -0.72351192  0.6790780  -1.92846081   0.38444053
    M12: M23                0.68347526  0.5351828  -0.17770960   1.70164526
    M12: M24               -0.24619879  0.8399363  -2.30613234   0.80116955
    M12: O22               -2.16612577  1.5298873  -4.24500421   0.26603402
    M12: O23               -2.05392803  1.1213553  -4.16237689  -0.51392114
    M12: O24                0.45002856  1.2518838  -1.64735125   2.50351111
    M12: abs(C1 - C2)       0.06833179  1.0085016  -1.69659759   1.95834541
    M12: log(C1)           63.34657009 34.1159940  13.88544645 126.64478274
    M12: O22:abs(C1 - C2)   1.39089367  0.9731263   0.01559889   3.02244783
    M12: O23:abs(C1 - C2)   0.51940429  0.7375629  -0.80168553   1.74973918
    M12: O24:abs(C1 - C2)  -0.47408950  0.8486405  -1.85999489   1.02037119
    M13: (Intercept)       -8.19999754 12.5235021 -35.57309224  10.16405130
    M13: M22               -1.89936512  0.5968603  -2.85055806  -0.81533749
    M13: M23               -1.13170291  0.5663066  -2.35514144  -0.21871046
    M13: M24                0.28929255  0.4395466  -0.22953015   1.18276173
    M13: O22               -1.11716614  1.9906733  -4.27868368   1.26656246
    M13: O23                1.07066200  1.0918823  -0.40328440   3.53369784
    M13: O24                0.11550796  1.8758321  -2.02724260   4.55875064
    M13: abs(C1 - C2)       0.58356257  1.1506379  -1.33836682   2.78379706
    M13: log(C1)           17.95008602 36.1938617 -35.81426257  94.26833801
    M13: O22:abs(C1 - C2)   1.76265342  1.5314388  -0.17814390   4.31814673
    M13: O23:abs(C1 - C2)  -0.19749891  0.9914136  -1.85834206   1.36261255
    M13: O24:abs(C1 - C2)   0.66280587  1.1700101  -1.99627282   2.00934913
    M14: (Intercept)      -19.51843802 15.8990604 -44.90696015  17.67679644
    M14: M22               -0.75219766  0.6957406  -2.15507082   0.06841692
    M14: M23               -0.66376821  0.7066731  -2.03483943   0.40675977
    M14: M24               -1.38638927  0.6521088  -2.44982156  -0.48946233
    M14: O22               -0.70775928  1.1801912  -2.68012184   1.56346455
    M14: O23               -1.00765310  1.7871800  -3.24433880   1.68130791
    M14: O24                2.25720918  0.7523809   1.10777257   3.63248379
    M14: abs(C1 - C2)       0.22008638  1.5487648  -2.51633519   2.20399079
    M14: log(C1)           53.19956745 45.8326976 -52.45332528 125.01652918
    M14: O22:abs(C1 - C2)   1.15337231  1.0163753  -1.19752102   2.55262650
    M14: O23:abs(C1 - C2)   0.60476130  1.2355962  -1.46420921   2.46596164
    M14: O24:abs(C1 - C2)  -1.90400993  0.6278476  -3.02685649  -0.75327196
                          tail-prob.   GR-crit     MCE/SD
    M12: (Intercept)      0.00000000  1.322673 0.18257419
    M12: M22              0.26666667  2.168955 0.38684986
    M12: M23              0.13333333  3.443643 0.53814326
    M12: M24              0.86666667  3.744169 0.35695116
    M12: O22              0.20000000  9.952074 0.48978755
    M12: O23              0.00000000  4.999275 0.28339958
    M12: O24              0.66666667  6.479507 0.54186617
    M12: abs(C1 - C2)     0.93333333  2.793088 0.40000054
    M12: log(C1)          0.06666667  1.405118 0.18257419
    M12: O22:abs(C1 - C2) 0.00000000  7.982190 0.71300957
    M12: O23:abs(C1 - C2) 0.53333333  2.172284 0.30737976
    M12: O24:abs(C1 - C2) 0.53333333  6.493079 0.46493067
    M13: (Intercept)      0.53333333  1.038756 0.18257419
    M13: M22              0.00000000  1.066007 0.20654629
    M13: M23              0.06666667  1.284318 0.21743523
    M13: M24              0.80000000  1.569617 0.36024932
    M13: O22              0.93333333 11.964092 0.85684625
    M13: O23              0.33333333  5.945868 0.43201418
    M13: O24              0.80000000 10.501443 0.38197357
    M13: abs(C1 - C2)     0.73333333  3.555489 0.55234873
    M13: log(C1)          0.66666667  1.079058 0.18257419
    M13: O22:abs(C1 - C2) 0.13333333  7.713585 0.84263391
    M13: O23:abs(C1 - C2) 0.93333333  6.776591 0.47720008
    M13: O24:abs(C1 - C2) 0.33333333  7.425203 0.43375932
    M14: (Intercept)      0.13333333  1.136720 0.11718853
    M14: M22              0.26666667  1.207036 0.18257419
    M14: M23              0.40000000  1.345356 0.01344461
    M14: M24              0.00000000  1.086096 0.18257419
    M14: O22              0.66666667  3.003594         NA
    M14: O23              0.66666667 10.797183 0.64204124
    M14: O24              0.00000000  2.874967 0.24491961
    M14: abs(C1 - C2)     0.80000000  7.238403 0.66292910
    M14: log(C1)          0.20000000  1.273801 0.31963550
    M14: O22:abs(C1 - C2) 0.20000000  3.752860 0.51097579
    M14: O23:abs(C1 - C2) 0.66666667  9.665714 0.54403404
    M14: O24:abs(C1 - C2) 0.00000000  1.676271 0.18257419
    
    
    $m4b
    $m4b$M1
                                                                            Mean
    M12: (Intercept)                                                -22.09524153
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                0.06125530
    M12: abs(C1 - C2)                                                -0.19562932
    M12: log(C1)                                                     61.44513454
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -0.06421625
    M13: (Intercept)                                                -13.61385657
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -0.28306044
    M13: abs(C1 - C2)                                                 0.46615341
    M13: log(C1)                                                     34.32017835
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   0.36805757
    M14: (Intercept)                                                -20.30981490
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -0.01631328
    M14: abs(C1 - C2)                                                 0.23825387
    M14: log(C1)                                                     54.35012696
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -0.21945670
                                                                            SD
    M12: (Intercept)                                                12.6412719
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               1.1676990
    M12: abs(C1 - C2)                                                0.7323947
    M12: log(C1)                                                    34.7489528
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  0.7622403
    M13: (Intercept)                                                14.7087117
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               2.9411394
    M13: abs(C1 - C2)                                                1.0982616
    M13: log(C1)                                                    40.4881784
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  1.7843237
    M14: (Intercept)                                                12.2887964
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               1.9380103
    M14: abs(C1 - C2)                                                0.9937627
    M14: log(C1)                                                    34.7440692
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  1.2744197
                                                                          2.5%
    M12: (Intercept)                                                -47.023626
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -2.176296
    M12: abs(C1 - C2)                                                -1.399176
    M12: log(C1)                                                     -3.592702
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -1.317628
    M13: (Intercept)                                                -43.457165
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -3.679506
    M13: abs(C1 - C2)                                                -1.375353
    M13: log(C1)                                                    -14.675154
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -2.557767
    M14: (Intercept)                                                -41.017133
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               -2.859442
    M14: abs(C1 - C2)                                                -1.855139
    M14: log(C1)                                                    -13.374327
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  -1.689889
                                                                          97.5%
    M12: (Intercept)                                                  0.8370506
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                1.9941190
    M12: abs(C1 - C2)                                                 1.2785425
    M12: log(C1)                                                    132.2114856
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   1.2683075
    M13: (Intercept)                                                  3.1452971
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                4.3453034
    M13: abs(C1 - C2)                                                 2.7990898
    M13: log(C1)                                                    115.7492231
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   2.4683213
    M14: (Intercept)                                                  4.0883466
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)                2.2099937
    M14: abs(C1 - C2)                                                 2.1009215
    M14: log(C1)                                                    109.5992574
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)   1.7876031
                                                                    tail-prob.
    M12: (Intercept)                                                 0.1333333
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               0.9333333
    M12: abs(C1 - C2)                                                0.7333333
    M12: log(C1)                                                     0.1333333
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  0.8000000
    M13: (Intercept)                                                 0.3333333
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               0.6666667
    M13: abs(C1 - C2)                                                0.6666667
    M13: log(C1)                                                     0.3333333
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  0.6666667
    M14: (Intercept)                                                 0.1333333
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               0.8000000
    M14: abs(C1 - C2)                                                0.7333333
    M14: log(C1)                                                     0.2000000
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  0.8000000
                                                                      GR-crit
    M12: (Intercept)                                                 1.847270
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)               6.150186
    M12: abs(C1 - C2)                                                1.993053
    M12: log(C1)                                                     1.897443
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  7.126056
    M13: (Intercept)                                                 1.893915
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)              16.987207
    M13: abs(C1 - C2)                                                3.002665
    M13: log(C1)                                                     2.042686
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 16.728065
    M14: (Intercept)                                                 1.943806
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)              12.382896
    M14: abs(C1 - C2)                                                3.185968
    M14: log(C1)                                                     1.827031
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2)  8.579698
                                                                       MCE/SD
    M12: (Intercept)                                                0.2689255
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)              0.5982204
    M12: abs(C1 - C2)                                               0.1825742
    M12: log(C1)                                                    0.2721714
    M12: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 0.5632222
    M13: (Intercept)                                                0.1825742
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)              1.0413550
    M13: abs(C1 - C2)                                               0.2413320
    M13: log(C1)                                                    0.1825742
    M13: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 1.0661362
    M14: (Intercept)                                                0.1825742
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0)              0.9122230
    M14: abs(C1 - C2)                                               0.5606580
    M14: log(C1)                                                    0.1825742
    M14: ifelse(as.numeric(M2) > as.numeric(O1), 1, 0):abs(C1 - C2) 1.0809518
    
    

