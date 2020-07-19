# GRcrit and MCerror give same result

    $m0a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)      0.983       1.11
    m1C: (Intercept)      1.198       1.76
    D_m1_id[1,1]          2.052       3.60
    
    
    $m0b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       2.77       5.08
    m2C: (Intercept)       1.58       3.00
    D_m2_id[1,1]           1.58       3.72
    
    
    $m1a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.18       1.62
    m1B: C1                1.16       1.58
    m1C: (Intercept)       1.01       1.13
    m1C: C1                1.01       1.10
    D_m1_id[1,1]           1.69       2.99
    
    
    $m1b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       2.10       3.86
    m2B: C1                2.12       3.93
    m2C: (Intercept)       1.83       3.08
    m2C: C1                1.85       3.13
    D_m2_id[1,1]           1.97       4.11
    
    
    $m1c
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.57       2.80
    m1C: (Intercept)       1.90       3.86
    m1B: c1                1.23       1.94
    m1C: c1                1.29       1.92
    D_m1_id[1,1]           2.30       9.12
    
    
    $m1d
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       1.52       2.38
    m2C: (Intercept)       1.38       2.26
    m2B: c1                1.50       2.51
    m2C: c1                1.28       2.16
    D_m2_id[1,1]           3.65       6.87
    
    
    $m2a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       2.19       4.10
    m1B: C2                1.44       2.31
    m1C: (Intercept)       1.33       1.99
    m1C: C2                1.29       2.30
    D_m1_id[1,1]           2.79       5.36
    
    
    $m2b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       1.73       3.02
    m2B: C2                1.60       2.92
    m2C: (Intercept)       1.73       2.82
    m2C: C2                1.61       2.87
    D_m2_id[1,1]           5.28      20.24
    
    
    $m2c
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.82       3.41
    m1C: (Intercept)       1.64       2.83
    m1B: c2                1.56       2.55
    m1C: c2                1.57       2.51
    D_m1_id[1,1]           2.50       7.52
    
    
    $m2d
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       2.60       5.02
    m2C: (Intercept)       2.45       6.41
    m2B: c2                1.61       3.43
    m2C: c2                1.81       3.43
    D_m2_id[1,1]           3.04       6.93
    
    
    $m3a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    (Intercept)        3.68       8.24
    m1B                1.42       3.09
    m1C                1.19       1.78
    sigma_c1           1.02       1.30
    D_c1_id[1,1]       1.24       1.84
    
    
    $m3b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    (Intercept)        6.17      14.23
    m2B                3.72       7.65
    m2C                2.55       5.08
    sigma_c1           1.24       1.90
    D_c1_id[1,1]       2.77       5.91
    
    
    $m4a
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    m1B: (Intercept)            1.72       3.08
    m1B: M22                    1.66       2.95
    m1B: M23                    1.65       2.74
    m1B: M24                    2.07       3.54
    m1B: abs(C1 - C2)           1.31       2.40
    m1B: log(C1)                1.82       3.36
    m1C: (Intercept)            1.50       2.47
    m1C: M22                    1.11       1.47
    m1C: M23                    1.69       3.47
    m1C: M24                    1.87       3.26
    m1C: abs(C1 - C2)           4.55      10.44
    m1C: log(C1)                1.78       3.19
    m1B: m2B                    2.87       5.73
    m1B: m2C                    1.67       3.16
    m1B: m2B:abs(C1 - C2)       1.21       2.06
    m1B: m2C:abs(C1 - C2)       1.74       4.12
    m1C: m2B                    1.33       2.72
    m1C: m2C                    1.30       1.98
    m1C: m2B:abs(C1 - C2)       1.99       4.10
    m1C: m2C:abs(C1 - C2)       1.82       5.22
    D_m1_id[1,1]                2.13       4.88
    
    
    $m4b
    Potential scale reduction factors:
    
                                                                    Point est.
    m1B: (Intercept)                                                      1.24
    m1B: abs(C1 - C2)                                                     1.17
    m1B: log(C1)                                                          1.28
    m1C: (Intercept)                                                      1.09
    m1C: abs(C1 - C2)                                                     1.77
    m1C: log(C1)                                                          1.07
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                    2.43
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)       3.56
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                    2.02
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)       4.36
    D_m1_id[1,1]                                                          1.92
                                                                    Upper C.I.
    m1B: (Intercept)                                                      1.79
    m1B: abs(C1 - C2)                                                     1.80
    m1B: log(C1)                                                          1.92
    m1C: (Intercept)                                                      1.41
    m1C: abs(C1 - C2)                                                     3.93
    m1C: log(C1)                                                          1.40
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                    4.71
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)       8.05
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                    3.66
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)      10.41
    D_m1_id[1,1]                                                          4.31
    
    
    $m4c
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       2.07       4.08
    m1B: C1                1.91       3.67
    m1B: B21               3.64       7.35
    m1C: (Intercept)       1.19       1.65
    m1C: C1                1.17       1.59
    m1C: B21               2.06       5.65
    m1B: time              1.24       1.79
    m1B: c1                1.19       1.71
    m1C: time              1.03       1.27
    m1C: c1                1.50       2.41
    D_m1_id[1,1]           2.84       6.10
    D_m1_id[1,2]           3.53       7.10
    D_m1_id[2,2]           4.76      10.42
    D_m1_id[1,3]           1.15       1.80
    D_m1_id[2,3]           2.32       4.76
    D_m1_id[3,3]           5.65      13.24
    D_m1_id[1,4]           3.65       8.79
    D_m1_id[2,4]           3.68       7.09
    D_m1_id[3,4]           2.91       7.33
    D_m1_id[4,4]           1.53       2.44
    
    
    $m4d
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)      1.305      2.013
    m1B: C1               1.279      1.944
    m1C: (Intercept)      1.063      1.342
    m1C: C1               1.078      1.377
    m1B: time             3.585      7.484
    m1B: I(time^2)        6.341     12.677
    m1B: b21              2.443      5.488
    m1B: c1               1.339      2.102
    m1B: C1:time          1.399      2.158
    m1B: b21:c1           0.981      1.013
    m1C: time             2.009      4.794
    m1C: I(time^2)        3.666      6.853
    m1C: b21              1.083      1.425
    m1C: c1               1.544      3.353
    m1C: C1:time          5.432     10.390
    m1C: b21:c1           0.981      0.985
    D_m1_id[1,1]          5.153     13.549
    D_m1_id[1,2]          2.522      5.457
    D_m1_id[2,2]          3.461      7.226
    
    
    $m4e
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)      0.946      0.995
    m1B: C1               0.944      0.989
    m1C: (Intercept)      1.047      1.292
    m1C: C1               1.059      1.352
    m1B: log(time)        1.473      4.601
    m1B: I(time^2)        1.477      2.492
    m1B: p1               1.418      2.157
    m1C: log(time)        0.991      1.055
    m1C: I(time^2)        1.183      1.870
    m1C: p1               1.419      2.410
    D_m1_id[1,1]          1.581      3.047
    
    

---

    $m0a
                       est  MCSE   SD MCSE/SD
    m1B: (Intercept) 0.078 0.043 0.19    0.23
    m1C: (Intercept) 0.192 0.040 0.17    0.23
    D_m1_id[1,1]     1.130 0.239 0.51    0.47
    
    $m0b
                      est  MCSE   SD MCSE/SD
    m2B: (Intercept) 0.15 0.031 0.17    0.18
    m2C: (Intercept) 0.16 0.036 0.16    0.23
    D_m2_id[1,1]     1.37 0.360 0.87    0.41
    
    $m1a
                       est MCSE   SD MCSE/SD
    m1B: (Intercept)   9.4 1.52 7.09    0.21
    m1B: C1          -12.6 2.06 9.56    0.22
    m1C: (Intercept)  12.0 1.09 5.98    0.18
    m1C: C1          -16.0 1.48 8.09    0.18
    D_m1_id[1,1]       1.0 0.13 0.56    0.24
    
    $m1b
                       est MCSE   SD MCSE/SD
    m2B: (Intercept)  0.68 5.00 11.2    0.44
    m2B: C1          -0.38 6.80 15.3    0.44
    m2C: (Intercept)  4.85 3.90  8.9    0.44
    m2C: C1          -6.02 5.35 12.1    0.44
    D_m2_id[1,1]      2.48 0.54  1.0    0.53
    
    $m1c
                       est  MCSE   SD MCSE/SD
    m1B: (Intercept) 0.022 0.046 0.14    0.34
    m1C: (Intercept) 0.040 0.032 0.15    0.21
    m1B: c1          0.370 0.045 0.25    0.18
    m1C: c1          0.693 0.039 0.18    0.22
    D_m1_id[1,1]     1.242 0.295 0.75    0.39
    
    $m1d
                      est  MCSE   SD MCSE/SD
    m2B: (Intercept) 0.13 0.038 0.17    0.23
    m2C: (Intercept) 0.14 0.037 0.20    0.18
    m2B: c1          0.18 0.038 0.17    0.22
    m2C: c1          0.20 0.033 0.18    0.18
    D_m2_id[1,1]     1.52 0.248 0.80    0.31
    
    $m2a
                        est  MCSE   SD MCSE/SD
    m1B: (Intercept)  0.042 0.133 0.28    0.47
    m1B: C2          -0.047 0.074 0.24    0.31
    m1C: (Intercept)  0.221 0.054 0.24    0.22
    m1C: C2           0.048 0.064 0.24    0.27
    D_m1_id[1,1]      1.233 0.121 0.42    0.29
    
    $m2b
                      est  MCSE   SD MCSE/SD
    m2B: (Intercept) 0.32 0.096 0.30    0.32
    m2B: C2          0.11 0.121 0.30    0.40
    m2C: (Intercept) 0.39 0.046 0.25    0.18
    m2C: C2          0.14 0.153 0.31    0.49
    D_m2_id[1,1]     1.86 0.742 1.05    0.70
    
    $m2c
                       est MCSE   SD MCSE/SD
    m1B: (Intercept) -0.69 0.19 0.42    0.45
    m1C: (Intercept) -0.17 0.19 0.41    0.47
    m1B: c2          -3.82 0.47 1.57    0.30
    m1C: c2          -2.30 0.45 1.45    0.31
    D_m1_id[1,1]      1.75 0.51 0.79    0.65
    
    $m2d
                      est MCSE   SD MCSE/SD
    m2B: (Intercept) 0.33 0.11 0.33    0.32
    m2C: (Intercept) 0.40 0.25 0.42    0.59
    m2B: c2          0.48 0.31 1.13    0.27
    m2C: c2          0.83 0.58 1.22    0.47
    D_m2_id[1,1]     2.00 0.51 0.78    0.65
    
    $m3a
                     est    MCSE      SD MCSE/SD
    (Intercept)   -7.733   5.263 2.9e+01    0.18
    m1B           -0.060   0.017 9.4e-02    0.18
    m1C            0.083   0.016 8.7e-02    0.18
    sigma_c1       0.650   0.010 4.6e-02    0.23
    D_c1_id[1,1] 863.159 583.895 3.2e+03    0.18
    
    $m3b
                   est   MCSE    SD MCSE/SD
    (Intercept)  0.229 0.0855 0.114    0.75
    m2B          0.067 0.0650 0.121    0.54
    m2C          0.041 0.0732 0.149    0.49
    sigma_c1     0.641 0.0053 0.029    0.18
    D_c1_id[1,1] 0.079 0.0184 0.034    0.54
    
    $m4a
                              est MCSE    SD MCSE/SD
    m1B: (Intercept)       -2.928 1.06  2.95    0.36
    m1B: M22                0.063 0.14  0.48    0.30
    m1B: M23               -0.887 0.45  0.91    0.50
    m1B: M24                0.597 0.17  0.40    0.42
    m1B: abs(C1 - C2)       0.286 0.11  0.36    0.32
    m1B: log(C1)           -8.834 4.71 10.39    0.45
    m1C: (Intercept)           NA   NA  3.30      NA
    m1C: M22                0.353 0.17  0.39    0.44
    m1C: M23                0.262 0.14  0.46    0.29
    m1C: M24                0.702 0.18  0.43    0.42
    m1C: abs(C1 - C2)       0.294 0.21  0.38    0.55
    m1C: log(C1)          -12.468 2.07 11.32    0.18
    m1B: m2B                0.750 0.23  0.51    0.45
    m1B: m2C               -1.354 0.09  0.49    0.18
    m1B: m2B:abs(C1 - C2)  -0.659 0.03  0.22    0.13
    m1B: m2C:abs(C1 - C2)   0.604 0.13  0.32    0.39
    m1C: m2B                0.199 0.12  0.40    0.31
    m1C: m2C               -0.385 0.21  0.49    0.43
    m1C: m2B:abs(C1 - C2)  -0.593 0.21  0.43    0.49
    m1C: m2C:abs(C1 - C2)  -0.137 0.15  0.40    0.36
    D_m1_id[1,1]            1.903 0.44  1.07    0.41
    
    $m4b
                                                                       est MCSE
    m1B: (Intercept)                                                -0.402 1.28
    m1B: abs(C1 - C2)                                                0.412 0.10
    m1B: log(C1)                                                     0.261 3.45
    m1C: (Intercept)                                                -0.523 0.76
    m1C: abs(C1 - C2)                                               -0.021 0.18
    m1C: log(C1)                                                    -2.804 2.37
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.486 0.55
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.393 0.38
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              -1.416 0.29
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.677 0.25
    D_m1_id[1,1]                                                     1.768 0.42
                                                                      SD MCSE/SD
    m1B: (Intercept)                                                3.14    0.41
    m1B: abs(C1 - C2)                                               0.27    0.38
    m1B: log(C1)                                                    9.89    0.35
    m1C: (Intercept)                                                2.59    0.30
    m1C: abs(C1 - C2)                                               0.28    0.64
    m1C: log(C1)                                                    8.31    0.28
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.75    0.73
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.47    0.81
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.83    0.35
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.47    0.54
    D_m1_id[1,1]                                                    0.78    0.53
    
    $m4c
                          est   MCSE    SD MCSE/SD
    m1B: (Intercept)   3.0058 1.9660 5.807    0.34
    m1B: C1           -4.6259 1.6066 7.551    0.21
    m1B: B21           0.0831 0.2200 0.406    0.54
    m1C: (Intercept)   8.5145 0.9409 5.153    0.18
    m1C: C1          -11.1739 1.2614 6.909    0.18
    m1C: B21               NA     NA 0.421      NA
    m1B: time          0.1337 0.0164 0.090    0.18
    m1B: c1            0.0824 0.0391 0.214    0.18
    m1C: time          0.0132 0.0194 0.106    0.18
    m1C: c1            0.3257 0.0450 0.246    0.18
    D_m1_id[1,1]       0.1950 0.0211 0.051    0.42
    D_m1_id[1,2]       0.0153 0.0155 0.039    0.40
    D_m1_id[2,2]       0.2603 0.0535 0.117    0.46
    D_m1_id[1,3]       0.0305 0.0070 0.032    0.22
    D_m1_id[2,3]       0.0262 0.0279 0.042    0.66
    D_m1_id[3,3]       0.2358 0.1021 0.133    0.77
    D_m1_id[1,4]      -0.0097 0.0454 0.043    1.05
    D_m1_id[2,4]      -0.0148 0.0268 0.051    0.53
    D_m1_id[3,4]      -0.0067 0.0099 0.030    0.33
    D_m1_id[4,4]       0.1533 0.0131 0.040    0.33
    
    $m4d
                         est  MCSE    SD MCSE/SD
    m1B: (Intercept)   4.937 1.283 7.026    0.18
    m1B: C1           -7.046 1.721 9.428    0.18
    m1C: (Intercept)   7.970 1.196 6.551    0.18
    m1C: C1          -10.118 1.628 8.916    0.18
    m1B: time         -0.122 0.153 0.284    0.54
    m1B: I(time^2)     0.018 0.059 0.067    0.88
    m1B: b21           0.278 0.157 0.559    0.28
    m1B: c1            0.100 0.042 0.201    0.21
    m1B: C1:time       0.194 0.084 0.264    0.32
    m1B: b21:c1        0.816 0.105 0.538    0.19
    m1C: time         -0.220 0.042 0.185    0.23
    m1C: I(time^2)     0.073 0.026 0.061    0.43
    m1C: b21          -0.979 0.081 0.438    0.18
    m1C: c1            0.476 0.065 0.215    0.30
    m1C: C1:time      -0.231 0.168 0.414    0.40
    m1C: b21:c1        0.520 0.131 0.716    0.18
    D_m1_id[1,1]       0.392 0.077 0.194    0.40
    D_m1_id[1,2]      -0.071 0.056 0.113    0.49
    D_m1_id[2,2]       0.469 0.117 0.181    0.64
    
    $m4e
                        est   MCSE    SD MCSE/SD
    m1B: (Intercept)  1.857 0.9924 5.435    0.18
    m1B: C1          -3.104 1.3409 7.345    0.18
    m1C: (Intercept)  4.716 1.0034 5.496    0.18
    m1C: C1          -6.638 1.3748 7.530    0.18
    m1B: log(time)       NA     NA 0.138      NA
    m1B: I(time^2)    0.022 0.0047 0.019    0.24
    m1B: p1           0.043 0.0152 0.075    0.20
    m1C: log(time)   -0.093 0.0277 0.152    0.18
    m1C: I(time^2)    0.015 0.0051 0.023    0.23
    m1C: p1           0.047 0.0363 0.093    0.39
    D_m1_id[1,1]      1.302 0.1003 0.426    0.24
    

# summary output remained the same

    
    Call:
    mlogitmm_imp(fixed = m1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept) 
        0.07752     0.19202 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.13
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept) 
         0.1489      0.1575 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.371
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
          9.365     -12.603      11.999     -16.027 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.036
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
         0.6842     -0.3815      4.8474     -6.0233 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.481
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
        0.02187     0.03951     0.36973     0.69344 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.242
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
         0.1349      0.1374      0.1792      0.2003 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.522
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
        0.04201    -0.04695     0.22086     0.04837 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.233
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
         0.3172      0.1134      0.3865      0.1393 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.86
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
        -0.6858     -0.1666     -3.8178     -2.2996 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.755
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
         0.3260      0.4045      0.4761      0.8307 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)           2
    
    
    Call:
    lme_imp(fixed = c1 ~ m1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m1B         m1C 
       -7.73262    -0.06040     0.08273 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       863.2
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6496 
    
    Call:
    lme_imp(fixed = c1 ~ m2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m2B         m2C 
        0.22870     0.06687     0.04117 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)     0.07924
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6408 
    
    Call:
    mlogitmm_imp(fixed = m1 ~ M2 + m2 * abs(C1 - C2) + log(C1) + 
        (1 | id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
         (Intercept)              M22              M23              M24 
            -2.92846          0.06272         -0.88662          0.59683 
        abs(C1 - C2)          log(C1)      (Intercept)              M22 
             0.28564         -8.83372         -4.04574          0.35296 
                 M23              M24     abs(C1 - C2)          log(C1) 
             0.26178          0.70223          0.29382        -12.46814 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
             0.75006         -1.35390         -0.65862          0.60393 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
             0.19884         -0.38485         -0.59348         -0.13731 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.903
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ ifelse(as.numeric(m2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1) + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
                                                   (Intercept) 
                                                       -0.4016 
                                                  abs(C1 - C2) 
                                                        0.4116 
                                                       log(C1) 
                                                        0.2611 
                                                   (Intercept) 
                                                       -0.5234 
                                                  abs(C1 - C2) 
                                                       -0.0212 
                                                       log(C1) 
                                                       -2.8043 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                        0.4861 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                       -0.3932 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                       -1.4160 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                        0.6769 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.768
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ time + c1 + C1 + B2 + (c1 * time | 
        id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020, 
        warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1         B21 (Intercept)          C1         B21 
        3.00576    -4.62587     0.08311     8.51448   -11.17389    -0.26657 
           time          c1        time          c1 
        0.13368     0.08236     0.01320     0.32575 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)       c1      time   c1:time
    (Intercept)    0.195008  0.01529  0.030453 -0.009666
    c1             0.015288  0.26029  0.026229 -0.014777
    time           0.030453  0.02623  0.235760 -0.006665
    c1:time       -0.009666 -0.01478 -0.006665  0.153258
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 * time + I(time^2) + b2 * c1, data = longDF, 
        random = ~time | id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1        time   I(time^2) 
         4.9374     -7.0457      7.9700    -10.1176     -0.1219      0.0179 
            b21          c1     C1:time      b21:c1        time   I(time^2) 
         0.2779      0.1004      0.1937      0.8160     -0.2198      0.0734 
            b21          c1     C1:time      b21:c1 
        -0.9795      0.4757     -0.2308      0.5200 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)     time
    (Intercept)     0.39153 -0.07065
    time           -0.07065  0.46878
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + log(time) + I(time^2) + p1, data = longDF, 
        random = ~1 | id, n.adapt = 5, n.iter = 10, shrinkage = "ridge", 
        seed = 2020, parallel = TRUE, n.cores = 2)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1   log(time)   I(time^2) 
        1.85705    -3.10354     4.71631    -6.63848     0.06467     0.02182 
             p1   log(time)   I(time^2)          p1 
        0.04318    -0.09326     0.01489     0.04736 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.302
    
    $m0a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept) 
        0.07752     0.19202 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.13
    
    
    $m0b
    
    Call:
    mlogitmm_imp(fixed = m2 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept) 
         0.1489      0.1575 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.371
    
    
    $m1a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
          9.365     -12.603      11.999     -16.027 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.036
    
    
    $m1b
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
         0.6842     -0.3815      4.8474     -6.0233 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.481
    
    
    $m1c
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
        0.02187     0.03951     0.36973     0.69344 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.242
    
    
    $m1d
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
         0.1349      0.1374      0.1792      0.2003 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.522
    
    
    $m2a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
        0.04201    -0.04695     0.22086     0.04837 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.233
    
    
    $m2b
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
         0.3172      0.1134      0.3865      0.1393 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.86
    
    
    $m2c
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
        -0.6858     -0.1666     -3.8178     -2.2996 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.755
    
    
    $m2d
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
         0.3260      0.4045      0.4761      0.8307 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)           2
    
    
    $m3a
    
    Call:
    lme_imp(fixed = c1 ~ m1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m1B         m1C 
       -7.73262    -0.06040     0.08273 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       863.2
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6496 
    
    $m3b
    
    Call:
    lme_imp(fixed = c1 ~ m2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m2B         m2C 
        0.22870     0.06687     0.04117 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)     0.07924
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6408 
    
    $m4a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ M2 + m2 * abs(C1 - C2) + log(C1) + 
        (1 | id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
         (Intercept)              M22              M23              M24 
            -2.92846          0.06272         -0.88662          0.59683 
        abs(C1 - C2)          log(C1)      (Intercept)              M22 
             0.28564         -8.83372         -4.04574          0.35296 
                 M23              M24     abs(C1 - C2)          log(C1) 
             0.26178          0.70223          0.29382        -12.46814 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
             0.75006         -1.35390         -0.65862          0.60393 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
             0.19884         -0.38485         -0.59348         -0.13731 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.903
    
    
    $m4b
    
    Call:
    mlogitmm_imp(fixed = m1 ~ ifelse(as.numeric(m2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1) + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
                                                   (Intercept) 
                                                       -0.4016 
                                                  abs(C1 - C2) 
                                                        0.4116 
                                                       log(C1) 
                                                        0.2611 
                                                   (Intercept) 
                                                       -0.5234 
                                                  abs(C1 - C2) 
                                                       -0.0212 
                                                       log(C1) 
                                                       -2.8043 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                        0.4861 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                       -0.3932 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                       -1.4160 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                        0.6769 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.768
    
    
    $m4c
    
    Call:
    mlogitmm_imp(fixed = m1 ~ time + c1 + C1 + B2 + (c1 * time | 
        id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020, 
        warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1         B21 (Intercept)          C1         B21 
        3.00576    -4.62587     0.08311     8.51448   -11.17389    -0.26657 
           time          c1        time          c1 
        0.13368     0.08236     0.01320     0.32575 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)       c1      time   c1:time
    (Intercept)    0.195008  0.01529  0.030453 -0.009666
    c1             0.015288  0.26029  0.026229 -0.014777
    time           0.030453  0.02623  0.235760 -0.006665
    c1:time       -0.009666 -0.01478 -0.006665  0.153258
    
    
    $m4d
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 * time + I(time^2) + b2 * c1, data = longDF, 
        random = ~time | id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1        time   I(time^2) 
         4.9374     -7.0457      7.9700    -10.1176     -0.1219      0.0179 
            b21          c1     C1:time      b21:c1        time   I(time^2) 
         0.2779      0.1004      0.1937      0.8160     -0.2198      0.0734 
            b21          c1     C1:time      b21:c1 
        -0.9795      0.4757     -0.2308      0.5200 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)     time
    (Intercept)     0.39153 -0.07065
    time           -0.07065  0.46878
    
    
    $m4e
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + log(time) + I(time^2) + p1, data = longDF, 
        random = ~1 | id, n.adapt = 5, n.iter = 10, shrinkage = "ridge", 
        seed = 2020, parallel = TRUE, n.cores = 2)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1   log(time)   I(time^2) 
        1.85705    -3.10354     4.71631    -6.63848     0.06467     0.02182 
             p1   log(time)   I(time^2)          p1 
        0.04318    -0.09326     0.01489     0.04736 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.302
    
    

---

    $m0a
    $m0a$m1
    (Intercept) (Intercept) 
     0.07752287  0.19201779 
    
    
    $m0b
    $m0b$m2
    (Intercept) (Intercept) 
      0.1488677   0.1575291 
    
    
    $m1a
    $m1a$m1
    (Intercept)          C1 (Intercept)          C1 
       9.364955  -12.603412   11.998772  -16.026911 
    
    
    $m1b
    $m1b$m2
    (Intercept)          C1 (Intercept)          C1 
      0.6841871  -0.3815302   4.8473575  -6.0233084 
    
    
    $m1c
    $m1c$m1
    (Intercept) (Intercept)          c1          c1 
     0.02186882  0.03951072  0.36973142  0.69344212 
    
    
    $m1d
    $m1d$m2
    (Intercept) (Intercept)          c1          c1 
      0.1348805   0.1373684   0.1791682   0.2003449 
    
    
    $m2a
    $m2a$m1
    (Intercept)          C2 (Intercept)          C2 
     0.04201446 -0.04694813  0.22085738  0.04836990 
    
    
    $m2b
    $m2b$m2
    (Intercept)          C2 (Intercept)          C2 
      0.3171750   0.1134449   0.3865278   0.1392547 
    
    
    $m2c
    $m2c$m1
    (Intercept) (Intercept)          c2          c2 
     -0.6858113  -0.1665573  -3.8177768  -2.2995559 
    
    
    $m2d
    $m2d$m2
    (Intercept) (Intercept)          c2          c2 
      0.3259772   0.4044743   0.4761134   0.8307182 
    
    
    $m3a
    $m3a$c1
    (Intercept)         m1B         m1C 
    -7.73262164 -0.06040007  0.08273420 
    
    
    $m3b
    $m3b$c1
    (Intercept)         m2B         m2C 
     0.22870212  0.06687013  0.04117191 
    
    
    $m4a
    $m4a$m1
         (Intercept)              M22              M23              M24 
         -2.92845900       0.06271824      -0.88661898       0.59682699 
        abs(C1 - C2)          log(C1)      (Intercept)              M22 
          0.28563583      -8.83371753      -4.04573643       0.35296115 
                 M23              M24     abs(C1 - C2)          log(C1) 
          0.26178344       0.70223473       0.29381940     -12.46814364 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
          0.75006106      -1.35390228      -0.65861898       0.60392774 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
          0.19884032      -0.38485026      -0.59347540      -0.13730896 
    
    
    $m4b
    $m4b$m1
                                                   (Intercept) 
                                                   -0.40160657 
                                                  abs(C1 - C2) 
                                                    0.41156376 
                                                       log(C1) 
                                                    0.26112192 
                                                   (Intercept) 
                                                   -0.52340503 
                                                  abs(C1 - C2) 
                                                   -0.02120198 
                                                       log(C1) 
                                                   -2.80434560 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                    0.48605064 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                   -0.39316130 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                   -1.41595176 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                    0.67688010 
    
    
    $m4c
    $m4c$m1
     (Intercept)           C1          B21  (Intercept)           C1          B21 
      3.00575618  -4.62587366   0.08311468   8.51447931 -11.17389024  -0.26657028 
            time           c1         time           c1 
      0.13368194   0.08236306   0.01319705   0.32574651 
    
    
    $m4d
    $m4d$m1
     (Intercept)           C1  (Intercept)           C1         time    I(time^2) 
      4.93741924  -7.04570659   7.97001563 -10.11764773  -0.12194427   0.01789676 
             b21           c1      C1:time       b21:c1         time    I(time^2) 
      0.27794367   0.10036496   0.19373069   0.81604649  -0.21975725   0.07339773 
             b21           c1      C1:time       b21:c1 
     -0.97947566   0.47574229  -0.23081764   0.52004099 
    
    
    $m4e
    $m4e$m1
    (Intercept)          C1 (Intercept)          C1   log(time)   I(time^2) 
     1.85705481 -3.10353967  4.71631324 -6.63848332  0.06467041  0.02181687 
             p1   log(time)   I(time^2)          p1 
     0.04318256 -0.09326448  0.01489069  0.04735752 
    
    

---

    $m0a
    $m0a$m1
                       2.5%     97.5%
    (Intercept) -0.21725673 0.4774263
    (Intercept) -0.08441678 0.4799758
    
    
    $m0b
    $m0b$m2
                      2.5%     97.5%
    (Intercept) -0.1428615 0.4933655
    (Intercept) -0.1545178 0.4580343
    
    
    $m1a
    $m1a$m1
                      2.5%     97.5%
    (Intercept)  -1.911451 20.048187
    C1          -26.905470  2.484909
    (Intercept)   2.260066 26.079175
    C1          -35.132713 -2.686804
    
    
    $m1b
    $m1b$m2
                     2.5%    97.5%
    (Intercept) -18.27010 24.21260
    C1          -32.34680 25.51033
    (Intercept) -10.04874 18.97084
    C1          -25.44833 13.95836
    
    
    $m1c
    $m1c$m1
                       2.5%     97.5%
    (Intercept) -0.25733378 0.1687312
    (Intercept) -0.22356244 0.2911191
    c1          -0.01764079 0.9394037
    c1           0.31663455 0.9643571
    
    
    $m1d
    $m1d$m2
                      2.5%     97.5%
    (Intercept) -0.1772478 0.5367385
    (Intercept) -0.1468774 0.4802431
    c1          -0.1001104 0.4806150
    c1          -0.1185982 0.5311340
    
    
    $m2a
    $m2a$m1
                      2.5%     97.5%
    (Intercept) -0.4645009 0.5435738
    C2          -0.5173366 0.3442466
    (Intercept) -0.2535238 0.6004320
    C2          -0.4288593 0.3875578
    
    
    $m2b
    $m2b$m2
                       2.5%     97.5%
    (Intercept) -0.34174217 0.8097462
    C2          -0.38352270 0.6010071
    (Intercept) -0.06596893 0.8284823
    C2          -0.39600887 0.6239464
    
    
    $m2c
    $m2c$m1
                      2.5%       97.5%
    (Intercept) -1.2532346  0.07323716
    (Intercept) -0.8757314  0.49985813
    c2          -6.5841611 -1.54805655
    c2          -4.8830204 -0.60422865
    
    
    $m2d
    $m2d$m2
                      2.5%     97.5%
    (Intercept) -0.1505952 0.9366264
    (Intercept) -0.5009367 1.0031163
    c2          -0.8122775 2.9727681
    c2          -1.5080869 2.7325126
    
    
    $m3a
    $m3a$c1
                        2.5%      97.5%
    (Intercept) -109.5248893 5.39605001
    m1B           -0.2360424 0.07303221
    m1C           -0.1029428 0.18760235
    
    
    $m3b
    $m3b$c1
                       2.5%     97.5%
    (Intercept)  0.03935837 0.3742134
    m2B         -0.11641995 0.2662192
    m2C         -0.17235194 0.3041556
    
    
    $m4a
    $m4a$m1
                             2.5%      97.5%
    (Intercept)       -7.77620021  3.4915515
    M22               -0.42473138  0.9591408
    M23               -2.12604609  0.8346796
    M24               -0.01779491  1.4422747
    abs(C1 - C2)      -0.30231916  1.0940736
    log(C1)          -23.81143688 13.5337994
    (Intercept)       -9.55053237  0.6384391
    M22               -0.39278514  0.9439861
    M23               -0.43156737  1.1259811
    M24                0.02371601  1.4525824
    abs(C1 - C2)      -0.18951895  0.9596131
    log(C1)          -29.49881166  5.6084011
    m2B                0.01521371  1.5905880
    m2C               -2.10293632 -0.6012294
    m2B:abs(C1 - C2)  -0.97621802 -0.2701707
    m2C:abs(C1 - C2)   0.07228270  1.1697839
    m2B               -0.70251604  0.6425866
    m2C               -1.28058133  0.5569329
    m2B:abs(C1 - C2)  -1.48873336  0.1185087
    m2C:abs(C1 - C2)  -0.64635029  0.7228442
    
    
    $m4b
    $m4b$m1
                                                                       2.5%
    (Intercept)                                                 -6.92066681
    abs(C1 - C2)                                                -0.10873502
    log(C1)                                                    -20.07127701
    (Intercept)                                                 -5.13053295
    abs(C1 - C2)                                                -0.40813735
    log(C1)                                                    -19.72679527
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.63346888
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -1.42992503
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -2.67463488
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)   0.01604039
                                                                    97.5%
    (Intercept)                                                 4.4338572
    abs(C1 - C2)                                                0.9475762
    log(C1)                                                    13.8555800
    (Intercept)                                                 3.6192169
    abs(C1 - C2)                                                0.4305868
    log(C1)                                                    10.5409958
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               1.7643777
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.2383610
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.1512910
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  1.3033574
    
    
    $m4c
    $m4c$m1
                        2.5%      97.5%
    (Intercept)  -4.52227265 16.6063418
    C1          -22.47901248  5.0758856
    B21          -0.60810689  0.7124634
    (Intercept)   0.86929575 16.9376319
    C1          -22.90931394 -0.6540646
    B21          -1.17423767  0.3728009
    time         -0.01366188  0.3006044
    c1           -0.33840960  0.4290945
    time         -0.23049714  0.1906386
    c1           -0.05842006  0.8174301
    
    
    $m4d
    $m4d$m1
                         2.5%       97.5%
    (Intercept)  -8.937370236 16.70658514
    C1          -22.233129256 11.56272446
    (Intercept)  -3.330173223 19.21949121
    C1          -25.761698677  5.45033190
    time         -0.566995414  0.34492603
    I(time^2)    -0.055069517  0.13057801
    b21          -0.429092586  1.34356534
    c1           -0.230978485  0.45130863
    C1:time      -0.218715844  0.62423470
    b21:c1       -0.054783689  1.86474427
    time         -0.517053048  0.06566410
    I(time^2)    -0.007937189  0.17682982
    b21          -1.651160447 -0.06736911
    c1            0.127202540  0.81251868
    C1:time      -0.995531142  0.20429802
    b21:c1       -0.775691629  1.67825118
    
    
    $m4e
    $m4e$m1
                        2.5%       97.5%
    (Intercept)  -6.71185011 11.70653885
    C1          -16.36120814  8.53403628
    (Intercept)  -5.43102990 15.43286105
    C1          -21.06911987  6.64342837
    log(time)    -0.09966105  0.40716431
    I(time^2)    -0.01254173  0.05317293
    p1           -0.08278251  0.16921938
    log(time)    -0.33005800  0.16151208
    I(time^2)    -0.01737322  0.05334990
    p1           -0.18179173  0.15860432
    
    

---

    $m0a
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                       Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept) 0.0775 0.187 -0.2173 0.477      0.600    1.57  0.229
    m1C: (Intercept) 0.1920 0.171 -0.0844 0.480      0.333    2.01  0.235
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.13 0.51 0.423  2.07               2.25  0.469
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m0b
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m2 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                      Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    m2B: (Intercept) 0.149 0.172 -0.143 0.493      0.467    1.90  0.183
    m2C: (Intercept) 0.158 0.158 -0.155 0.458      0.267    1.47  0.229
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 1.37 0.871 0.666  3.74               2.52  0.413
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m1a
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                       Mean   SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)   9.36 7.09  -1.91 20.05     0.2667    1.34  0.215
    m1B: C1          -12.60 9.56 -26.91  2.48     0.2667    1.32  0.215
    m1C: (Intercept)  12.00 5.98   2.26 26.08     0.0667    1.17  0.183
    m1C: C1          -16.03 8.09 -35.13 -2.69     0.0667    1.15  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.04 0.561 0.447  2.63               2.78  0.237
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m1b
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                       Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    m2B: (Intercept)  0.684 11.24 -18.3  24.2      0.800    3.37  0.445
    m2B: C1          -0.382 15.28 -32.3  25.5      0.933    3.39  0.445
    m2C: (Intercept)  4.847  8.93 -10.0  19.0      0.733    2.91  0.437
    m2C: C1          -6.023 12.13 -25.4  14.0      0.733    2.92  0.441
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 2.48 1.02 0.98  4.12               3.66  0.528
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m1c
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                       Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept) 0.0219 0.136 -0.2573 0.169     0.8000    1.95  0.339
    m1C: (Intercept) 0.0395 0.155 -0.2236 0.291     0.8667    2.23  0.209
    m1B: c1          0.3697 0.246 -0.0176 0.939     0.0667    1.23  0.183
    m1C: c1          0.6934 0.177  0.3166 0.964     0.0000    1.29  0.221
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.24 0.748 0.529  2.85               5.64  0.394
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m1d
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                      Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    m2B: (Intercept) 0.135 0.170 -0.177 0.537      0.267    2.07  0.226
    m2C: (Intercept) 0.137 0.201 -0.147 0.480      0.667    1.37  0.183
    m2B: c1          0.179 0.172 -0.100 0.481      0.333    1.96  0.221
    m2C: c1          0.200 0.178 -0.119 0.531      0.200    1.54  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 1.52 0.797 0.654  3.51               2.18  0.311
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m2a
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                        Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)  0.0420 0.282 -0.465 0.544      0.933    3.02  0.470
    m1B: C2          -0.0469 0.242 -0.517 0.344      0.867    1.84  0.307
    m1C: (Intercept)  0.2209 0.240 -0.254 0.600      0.333    2.34  0.224
    m1C: C2           0.0484 0.239 -0.429 0.388      0.800    2.44  0.267
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.23 0.424 0.496  1.88               3.36  0.286
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m2b
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                      Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    m2B: (Intercept) 0.317 0.300 -0.342 0.810      0.200    1.46  0.320
    m2B: C2          0.113 0.303 -0.384 0.601      0.800    2.16  0.399
    m2C: (Intercept) 0.387 0.251 -0.066 0.828      0.133    1.66  0.183
    m2C: C2          0.139 0.310 -0.396 0.624      0.667    2.85  0.495
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 1.86 1.05 0.866  3.83               11.7  0.705
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m2c
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                       Mean    SD   2.5%   97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept) -0.686 0.420 -1.253  0.0732      0.200    2.10  0.454
    m1C: (Intercept) -0.167 0.409 -0.876  0.4999      0.733    2.57  0.468
    m1B: c2          -3.818 1.569 -6.584 -1.5481      0.000    1.69  0.300
    m1C: c2          -2.300 1.451 -4.883 -0.6042      0.000    2.09  0.312
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.75 0.791 0.567  3.32               7.34  0.648
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m2d
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                      Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    m2B: (Intercept) 0.326 0.333 -0.151 0.937      0.467    4.29  0.322
    m2C: (Intercept) 0.404 0.424 -0.501 1.003      0.400    4.93  0.586
    m2B: c2          0.476 1.127 -0.812 2.973      0.933    3.10  0.271
    m2C: c2          0.831 1.219 -1.508 2.733      0.467    2.79  0.474
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1]    2 0.78  1.2  3.47               8.47  0.652
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m3a
    
    Bayesian linear mixed model fitted with JointAI
    
    Call:
    lme_imp(fixed = c1 ~ m1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                   Mean      SD     2.5% 97.5% tail-prob. GR-crit MCE/SD
    (Intercept) -7.7326 28.8253 -109.525 5.396      0.333    1.16  0.183
    m1B         -0.0604  0.0943   -0.236 0.073      0.600    2.29  0.183
    m1C          0.0827  0.0871   -0.103 0.188      0.400    2.02  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_c1_id[1,1]  863 3198 0.0661 12177               1.25  0.183
    
    Posterior summary of residual std. deviation:
             Mean     SD  2.5% 97.5% GR-crit MCE/SD
    sigma_c1 0.65 0.0455 0.601 0.768    1.08  0.225
    
    
    MCMC settings:
    Iterations = 1:10
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m3b
    
    Bayesian linear mixed model fitted with JointAI
    
    Call:
    lme_imp(fixed = c1 ~ m2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                  Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    (Intercept) 0.2287 0.114  0.0394 0.374      0.000   11.79  0.748
    m2B         0.0669 0.121 -0.1164 0.266      0.800    7.35  0.538
    m2C         0.0412 0.149 -0.1724 0.304      0.933    4.79  0.490
    
    Posterior summary of random effects covariance matrix:
                   Mean     SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_c1_id[1,1] 0.0792 0.0343 0.0291 0.141                  4  0.537
    
    Posterior summary of residual std. deviation:
              Mean     SD  2.5% 97.5% GR-crit MCE/SD
    sigma_c1 0.641 0.0288 0.596 0.697    1.97  0.183
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m4a
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m1 ~ M2 + m2 * abs(C1 - C2) + log(C1) + 
        (1 | id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                              Mean     SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)       -2.9285  2.954  -7.7762  3.492     0.3333    2.06  0.357
    m1B: M22                0.0627  0.477  -0.4247  0.959     0.9333    2.29  0.295
    m1B: M23               -0.8866  0.908  -2.1260  0.835     0.3333    3.65  0.496
    m1B: M24                0.5968  0.404  -0.0178  1.442     0.0667    2.36  0.419
    m1B: abs(C1 - C2)       0.2856  0.356  -0.3023  1.094     0.4000    2.66  0.322
    m1B: log(C1)           -8.8337 10.393 -23.8114 13.534     0.4000    2.25  0.454
    m1C: (Intercept)       -4.0457  3.302  -9.5505  0.638     0.2667    1.54       
    m1C: M22                0.3530  0.391  -0.3928  0.944     0.3333    2.09  0.439
    m1C: M23                0.2618  0.463  -0.4316  1.126     0.6000    2.15  0.294
    m1C: M24                0.7022  0.433   0.0237  1.453     0.0667    3.34  0.422
    m1C: abs(C1 - C2)       0.2938  0.382  -0.1895  0.960     0.5333    7.83  0.548
    m1C: log(C1)          -12.4681 11.322 -29.4988  5.608     0.3333    1.87  0.183
    m1B: m2B                0.7501  0.510   0.0152  1.591     0.0667    3.78  0.446
    m1B: m2C               -1.3539  0.494  -2.1029 -0.601     0.0000    1.80  0.183
    m1B: m2B:abs(C1 - C2)  -0.6586  0.222  -0.9762 -0.270     0.0000    1.68  0.135
    m1B: m2C:abs(C1 - C2)   0.6039  0.322   0.0723  1.170     0.0667    2.40  0.390
    m1C: m2B                0.1988  0.400  -0.7025  0.643     0.4667    3.27  0.306
    m1C: m2C               -0.3849  0.494  -1.2806  0.557     0.2667    1.96  0.432
    m1C: m2B:abs(C1 - C2)  -0.5935  0.434  -1.4887  0.119     0.1333    3.29  0.489
    m1C: m2C:abs(C1 - C2)  -0.1373  0.402  -0.6464  0.723     0.7333    4.65  0.364
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1]  1.9 1.07 0.919  4.25               6.55  0.414
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m4b
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m1 ~ ifelse(as.numeric(m2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1) + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
    
    Posterior summary:
                                                                       Mean    SD
    m1B: (Intercept)                                                -0.4016 3.138
    m1B: abs(C1 - C2)                                                0.4116 0.273
    m1B: log(C1)                                                     0.2611 9.894
    m1C: (Intercept)                                                -0.5234 2.586
    m1C: abs(C1 - C2)                                               -0.0212 0.281
    m1C: log(C1)                                                    -2.8043 8.306
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.4861 0.753
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.3932 0.467
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              -1.4160 0.830
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.6769 0.466
                                                                       2.5%  97.5%
    m1B: (Intercept)                                                 -6.921  4.434
    m1B: abs(C1 - C2)                                                -0.109  0.948
    m1B: log(C1)                                                    -20.071 13.856
    m1C: (Intercept)                                                 -5.131  3.619
    m1C: abs(C1 - C2)                                                -0.408  0.431
    m1C: log(C1)                                                    -19.727 10.541
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.633  1.764
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -1.430  0.238
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -2.675  0.151
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)   0.016  1.303
                                                                    tail-prob.
    m1B: (Intercept)                                                    0.9333
    m1B: abs(C1 - C2)                                                   0.1333
    m1B: log(C1)                                                        0.8667
    m1C: (Intercept)                                                    0.9333
    m1C: abs(C1 - C2)                                                   0.8667
    m1C: log(C1)                                                        0.7333
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                  0.5333
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)     0.2000
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                  0.2000
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)     0.0667
                                                                    GR-crit MCE/SD
    m1B: (Intercept)                                                   2.15  0.408
    m1B: abs(C1 - C2)                                                  1.64  0.375
    m1B: log(C1)                                                       2.20  0.349
    m1C: (Intercept)                                                   1.66  0.295
    m1C: abs(C1 - C2)                                                  4.13  0.637
    m1C: log(C1)                                                       1.61  0.285
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                 5.13  0.729
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)    7.44  0.805
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                 3.87  0.347
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)   11.01  0.544
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.77 0.782 0.775   3.3               4.05  0.533
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m4c
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m1 ~ time + c1 + C1 + B2 + (c1 * time | 
        id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020, 
        warn = FALSE)
    
    
    Posterior summary:
                         Mean     SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)   3.0058 5.8070  -4.5223 16.606     0.7333    3.14  0.339
    m1B: C1           -4.6259 7.5506 -22.4790  5.076     0.6000    2.84  0.213
    m1B: B21           0.0831 0.4059  -0.6081  0.712     0.8000    6.38  0.542
    m1C: (Intercept)   8.5145 5.1533   0.8693 16.938     0.0667    1.43  0.183
    m1C: C1          -11.1739 6.9089 -22.9093 -0.654     0.0667    1.33  0.183
    m1C: B21          -0.2666 0.4207  -1.1742  0.373     0.4000    3.72       
    m1B: time          0.1337 0.0897  -0.0137  0.301     0.0667    1.62  0.183
    m1B: c1            0.0824 0.2144  -0.3384  0.429     0.7333    1.02  0.183
    m1C: time          0.0132 0.1063  -0.2305  0.191     0.7333    1.26  0.183
    m1C: c1            0.3257 0.2465  -0.0584  0.817     0.2000    1.37  0.183
    
    Posterior summary of random effects covariance matrix:
                     Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1]  0.19501 0.0508  0.1079 0.2755               2.85  0.416
    D_m1_id[1,2]  0.01529 0.0386 -0.0583 0.0704      0.600    6.41  0.401
    D_m1_id[2,2]  0.26029 0.1172  0.1255 0.4599               8.80  0.457
    D_m1_id[1,3]  0.03045 0.0320 -0.0280 0.0992      0.200    1.61  0.219
    D_m1_id[2,3]  0.02623 0.0421 -0.0505 0.1069      0.400    5.17  0.664
    D_m1_id[3,3]  0.23576 0.1326  0.0718 0.4567              14.02  0.770
    D_m1_id[1,4] -0.00967 0.0432 -0.0814 0.0446      1.000    6.32  1.051
    D_m1_id[2,4] -0.01478 0.0507 -0.0916 0.0642      0.933    7.63  0.529
    D_m1_id[3,4] -0.00666 0.0297 -0.0474 0.0465      0.733    2.59  0.332
    D_m1_id[4,4]  0.15326 0.0402  0.0934 0.2401               1.81  0.325
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m4d
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 * time + I(time^2) + b2 * c1, data = longDF, 
        random = ~time | id, n.adapt = 5, n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                         Mean     SD      2.5%   97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)   4.9374 7.0259  -8.93737 16.7066     0.3333    1.34  0.183
    m1B: C1           -7.0457 9.4280 -22.23313 11.5627     0.3333    1.25  0.183
    m1C: (Intercept)   7.9700 6.5510  -3.33017 19.2195     0.1333    1.05  0.183
    m1C: C1          -10.1176 8.9158 -25.76170  5.4503     0.1333    1.05  0.183
    m1B: time         -0.1219 0.2844  -0.56700  0.3449     0.6667    6.72  0.539
    m1B: I(time^2)     0.0179 0.0667  -0.05507  0.1306     0.9333   11.19  0.882
    m1B: b21           0.2779 0.5594  -0.42909  1.3436     0.9333    2.89  0.281
    m1B: c1            0.1004 0.2011  -0.23098  0.4513     0.6000    1.74  0.211
    m1B: C1:time       0.1937 0.2636  -0.21872  0.6242     0.5333    1.38  0.317
    m1B: b21:c1        0.8160 0.5382  -0.05478  1.8647     0.0667    1.01  0.194
    m1C: time         -0.2198 0.1848  -0.51705  0.0657     0.2667    2.21  0.229
    m1C: I(time^2)     0.0734 0.0606  -0.00794  0.1768     0.2667    5.75  0.431
    m1C: b21          -0.9795 0.4379  -1.65116 -0.0674     0.0667    1.08  0.184
    m1C: c1            0.4757 0.2153   0.12720  0.8125     0.0000    2.34  0.300
    m1C: C1:time      -0.2308 0.4144  -0.99553  0.2043     0.9333   10.94  0.404
    m1C: b21:c1        0.5200 0.7156  -0.77569  1.6783     0.4667    1.19  0.183
    
    Posterior summary of random effects covariance matrix:
                    Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1]  0.3915 0.194  0.161 0.7804               8.93  0.397
    D_m1_id[1,2] -0.0707 0.113 -0.291 0.0959      0.467    3.55  0.495
    D_m1_id[2,2]  0.4688 0.181  0.188 0.7754               5.27  0.645
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m4e
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + log(time) + I(time^2) + p1, data = longDF, 
        random = ~1 | id, n.adapt = 5, n.iter = 10, shrinkage = "ridge", 
        seed = 2020, parallel = TRUE, n.cores = 2)
    
    
    Posterior summary:
                        Mean     SD     2.5%   97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)  1.8571 5.4354  -6.7119 11.7065      0.733    1.38  0.183
    m1B: C1          -3.1035 7.3445 -16.3612  8.5340      0.733    1.36  0.183
    m1C: (Intercept)  4.7163 5.4960  -5.4310 15.4329      0.267    1.00  0.183
    m1C: C1          -6.6385 7.5303 -21.0691  6.6434      0.400    1.00  0.183
    m1B: log(time)    0.0647 0.1377  -0.0997  0.4072      0.733    1.28       
    m1B: I(time^2)    0.0218 0.0193  -0.0125  0.0532      0.333    1.78  0.244
    m1B: p1           0.0432 0.0752  -0.0828  0.1692      0.600    1.43  0.202
    m1C: log(time)   -0.0933 0.1518  -0.3301  0.1615      0.667    1.18  0.183
    m1C: I(time^2)    0.0149 0.0227  -0.0174  0.0533      0.733    1.08  0.226
    m1C: p1           0.0474 0.0928  -0.1818  0.1586      0.467    1.83  0.392
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1]  1.3 0.426 0.576  1.96               1.62  0.235
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    

---

    $m0a
    $m0a$m1
                           Mean        SD        2.5%     97.5% tail-prob.  GR-crit
    m1B: (Intercept) 0.07752287 0.1869344 -0.21725673 0.4774263  0.6000000 1.573960
    m1C: (Intercept) 0.19201779 0.1709501 -0.08441678 0.4799758  0.3333333 2.013739
                        MCE/SD
    m1B: (Intercept) 0.2291616
    m1C: (Intercept) 0.2346531
    
    
    $m0b
    $m0b$m2
                          Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    m2B: (Intercept) 0.1488677 0.1722441 -0.1428615 0.4933655  0.4666667 1.899752
    m2C: (Intercept) 0.1575291 0.1580806 -0.1545178 0.4580343  0.2666667 1.468485
                        MCE/SD
    m2B: (Intercept) 0.1825742
    m2C: (Intercept) 0.2289428
    
    
    $m1a
    $m1a$m1
                           Mean       SD       2.5%     97.5% tail-prob.  GR-crit
    m1B: (Intercept)   9.364955 7.093842  -1.911451 20.048187 0.26666667 1.342978
    m1B: C1          -12.603412 9.564427 -26.905470  2.484909 0.26666667 1.319992
    m1C: (Intercept)  11.998772 5.981998   2.260066 26.079175 0.06666667 1.169105
    m1C: C1          -16.026911 8.090840 -35.132713 -2.686804 0.06666667 1.146591
                        MCE/SD
    m1B: (Intercept) 0.2149369
    m1B: C1          0.2151855
    m1C: (Intercept) 0.1825742
    m1C: C1          0.1825742
    
    
    $m1b
    $m1b$m2
                           Mean        SD      2.5%    97.5% tail-prob.  GR-crit
    m2B: (Intercept)  0.6841871 11.241467 -18.27010 24.21260  0.8000000 3.365264
    m2B: C1          -0.3815302 15.283328 -32.34680 25.51033  0.9333333 3.391486
    m2C: (Intercept)  4.8473575  8.929356 -10.04874 18.97084  0.7333333 2.906228
    m2C: C1          -6.0233084 12.127179 -25.44833 13.95836  0.7333333 2.918592
                        MCE/SD
    m2B: (Intercept) 0.4446481
    m2B: C1          0.4448405
    m2C: (Intercept) 0.4366038
    m2C: C1          0.4410298
    
    
    $m1c
    $m1c$m1
                           Mean        SD        2.5%     97.5% tail-prob.  GR-crit
    m1B: (Intercept) 0.02186882 0.1364108 -0.25733378 0.1687312 0.80000000 1.945133
    m1C: (Intercept) 0.03951072 0.1548759 -0.22356244 0.2911191 0.86666667 2.225664
    m1B: c1          0.36973142 0.2463704 -0.01764079 0.9394037 0.06666667 1.226697
    m1C: c1          0.69344212 0.1767438  0.31663455 0.9643571 0.00000000 1.291277
                        MCE/SD
    m1B: (Intercept) 0.3387845
    m1C: (Intercept) 0.2090032
    m1B: c1          0.1825742
    m1C: c1          0.2206074
    
    
    $m1d
    $m1d$m2
                          Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    m2B: (Intercept) 0.1348805 0.1703809 -0.1772478 0.5367385  0.2666667 2.067794
    m2C: (Intercept) 0.1373684 0.2014477 -0.1468774 0.4802431  0.6666667 1.366324
    m2B: c1          0.1791682 0.1721695 -0.1001104 0.4806150  0.3333333 1.958268
    m2C: c1          0.2003449 0.1781285 -0.1185982 0.5311340  0.2000000 1.540413
                        MCE/SD
    m2B: (Intercept) 0.2255254
    m2C: (Intercept) 0.1825742
    m2B: c1          0.2208212
    m2C: c1          0.1825742
    
    
    $m2a
    $m2a$m1
                            Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    m1B: (Intercept)  0.04201446 0.2824637 -0.4645009 0.5435738  0.9333333 3.015622
    m1B: C2          -0.04694813 0.2420288 -0.5173366 0.3442466  0.8666667 1.838006
    m1C: (Intercept)  0.22085738 0.2401278 -0.2535238 0.6004320  0.3333333 2.336051
    m1C: C2           0.04836990 0.2390335 -0.4288593 0.3875578  0.8000000 2.439146
                        MCE/SD
    m1B: (Intercept) 0.4703798
    m1B: C2          0.3073951
    m1C: (Intercept) 0.2238366
    m1C: C2          0.2670835
    
    
    $m2b
    $m2b$m2
                          Mean        SD        2.5%     97.5% tail-prob.  GR-crit
    m2B: (Intercept) 0.3171750 0.2999975 -0.34174217 0.8097462  0.2000000 1.462567
    m2B: C2          0.1134449 0.3027903 -0.38352270 0.6010071  0.8000000 2.157849
    m2C: (Intercept) 0.3865278 0.2514748 -0.06596893 0.8284823  0.1333333 1.662732
    m2C: C2          0.1392547 0.3095189 -0.39600887 0.6239464  0.6666667 2.853836
                        MCE/SD
    m2B: (Intercept) 0.3204529
    m2B: C2          0.3990568
    m2C: (Intercept) 0.1825742
    m2C: C2          0.4946734
    
    
    $m2c
    $m2c$m1
                           Mean        SD       2.5%       97.5% tail-prob.
    m1B: (Intercept) -0.6858113 0.4204170 -1.2532346  0.07323716  0.2000000
    m1C: (Intercept) -0.1665573 0.4089271 -0.8757314  0.49985813  0.7333333
    m1B: c2          -3.8177768 1.5689357 -6.5841611 -1.54805655  0.0000000
    m1C: c2          -2.2995559 1.4510134 -4.8830204 -0.60422865  0.0000000
                      GR-crit    MCE/SD
    m1B: (Intercept) 2.097183 0.4537401
    m1C: (Intercept) 2.574487 0.4682802
    m1B: c2          1.693181 0.3000903
    m1C: c2          2.086592 0.3122656
    
    
    $m2d
    $m2d$m2
                          Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    m2B: (Intercept) 0.3259772 0.3333864 -0.1505952 0.9366264  0.4666667 4.286149
    m2C: (Intercept) 0.4044743 0.4236772 -0.5009367 1.0031163  0.4000000 4.929631
    m2B: c2          0.4761134 1.1273834 -0.8122775 2.9727681  0.9333333 3.104377
    m2C: c2          0.8307182 1.2189926 -1.5080869 2.7325126  0.4666667 2.786962
                        MCE/SD
    m2B: (Intercept) 0.3216186
    m2C: (Intercept) 0.5862511
    m2B: c2          0.2705735
    m2C: c2          0.4735191
    
    
    $m3a
    $m3a$c1
                       Mean          SD         2.5%      97.5% tail-prob.  GR-crit
    (Intercept) -7.73262164 28.82533457 -109.5248893 5.39605001  0.3333333 1.160457
    m1B         -0.06040007  0.09429753   -0.2360424 0.07303221  0.6000000 2.285011
    m1C          0.08273420  0.08709346   -0.1029428 0.18760235  0.4000000 2.016284
                   MCE/SD
    (Intercept) 0.1825742
    m1B         0.1825742
    m1C         0.1825742
    
    
    $m3b
    $m3b$c1
                      Mean        SD        2.5%     97.5% tail-prob.   GR-crit
    (Intercept) 0.22870212 0.1143952  0.03935837 0.3742134  0.0000000 11.787272
    m2B         0.06687013 0.1208311 -0.11641995 0.2662192  0.8000000  7.350207
    m2C         0.04117191 0.1493510 -0.17235194 0.3041556  0.9333333  4.785850
                   MCE/SD
    (Intercept) 0.7477058
    m2B         0.5377122
    m2C         0.4898366
    
    
    $m4a
    $m4a$m1
                                  Mean         SD         2.5%      97.5%
    m1B: (Intercept)       -2.92845900  2.9544374  -7.77620021  3.4915515
    m1B: M22                0.06271824  0.4766916  -0.42473138  0.9591408
    m1B: M23               -0.88661898  0.9079054  -2.12604609  0.8346796
    m1B: M24                0.59682699  0.4042386  -0.01779491  1.4422747
    m1B: abs(C1 - C2)       0.28563583  0.3560018  -0.30231916  1.0940736
    m1B: log(C1)           -8.83371753 10.3929112 -23.81143688 13.5337994
    m1C: (Intercept)       -4.04573643  3.3021895  -9.55053237  0.6384391
    m1C: M22                0.35296115  0.3906214  -0.39278514  0.9439861
    m1C: M23                0.26178344  0.4630534  -0.43156737  1.1259811
    m1C: M24                0.70223473  0.4325362   0.02371601  1.4525824
    m1C: abs(C1 - C2)       0.29381940  0.3820864  -0.18951895  0.9596131
    m1C: log(C1)          -12.46814364 11.3223590 -29.49881166  5.6084011
    m1B: m2B                0.75006106  0.5103214   0.01521371  1.5905880
    m1B: m2C               -1.35390228  0.4935539  -2.10293632 -0.6012294
    m1B: m2B:abs(C1 - C2)  -0.65861898  0.2224863  -0.97621802 -0.2701707
    m1B: m2C:abs(C1 - C2)   0.60392774  0.3218326   0.07228270  1.1697839
    m1C: m2B                0.19884032  0.4000661  -0.70251604  0.6425866
    m1C: m2C               -0.38485026  0.4936560  -1.28058133  0.5569329
    m1C: m2B:abs(C1 - C2)  -0.59347540  0.4344817  -1.48873336  0.1185087
    m1C: m2C:abs(C1 - C2)  -0.13730896  0.4023732  -0.64635029  0.7228442
                          tail-prob.  GR-crit    MCE/SD
    m1B: (Intercept)      0.33333333 2.063846 0.3574459
    m1B: M22              0.93333333 2.291913 0.2953135
    m1B: M23              0.33333333 3.651378 0.4959195
    m1B: M24              0.06666667 2.363120 0.4193421
    m1B: abs(C1 - C2)     0.40000000 2.656190 0.3219175
    m1B: log(C1)          0.40000000 2.254046 0.4535232
    m1C: (Intercept)      0.26666667 1.538239        NA
    m1C: M22              0.33333333 2.085945 0.4389164
    m1C: M23              0.60000000 2.147265 0.2939239
    m1C: M24              0.06666667 3.342437 0.4216350
    m1C: abs(C1 - C2)     0.53333333 7.832791 0.5484198
    m1C: log(C1)          0.33333333 1.867747 0.1825742
    m1B: m2B              0.06666667 3.783612 0.4464990
    m1B: m2C              0.00000000 1.795296 0.1825742
    m1B: m2B:abs(C1 - C2) 0.00000000 1.680282 0.1345822
    m1B: m2C:abs(C1 - C2) 0.06666667 2.395091 0.3897202
    m1C: m2B              0.46666667 3.270737 0.3059152
    m1C: m2C              0.26666667 1.958679 0.4324668
    m1C: m2B:abs(C1 - C2) 0.13333333 3.288856 0.4893208
    m1C: m2C:abs(C1 - C2) 0.73333333 4.648245 0.3643190
    
    
    $m4b
    $m4b$m1
                                                                           Mean
    m1B: (Intercept)                                                -0.40160657
    m1B: abs(C1 - C2)                                                0.41156376
    m1B: log(C1)                                                     0.26112192
    m1C: (Intercept)                                                -0.52340503
    m1C: abs(C1 - C2)                                               -0.02120198
    m1C: log(C1)                                                    -2.80434560
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.48605064
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.39316130
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              -1.41595176
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.67688010
                                                                           SD
    m1B: (Intercept)                                                3.1384544
    m1B: abs(C1 - C2)                                               0.2727259
    m1B: log(C1)                                                    9.8935114
    m1C: (Intercept)                                                2.5861412
    m1C: abs(C1 - C2)                                               0.2812661
    m1C: log(C1)                                                    8.3055561
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.7534345
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.4671639
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.8300074
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.4661788
                                                                            2.5%
    m1B: (Intercept)                                                 -6.92066681
    m1B: abs(C1 - C2)                                                -0.10873502
    m1B: log(C1)                                                    -20.07127701
    m1C: (Intercept)                                                 -5.13053295
    m1C: abs(C1 - C2)                                                -0.40813735
    m1C: log(C1)                                                    -19.72679527
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.63346888
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -1.42992503
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -2.67463488
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)   0.01604039
                                                                         97.5%
    m1B: (Intercept)                                                 4.4338572
    m1B: abs(C1 - C2)                                                0.9475762
    m1B: log(C1)                                                    13.8555800
    m1C: (Intercept)                                                 3.6192169
    m1C: abs(C1 - C2)                                                0.4305868
    m1C: log(C1)                                                    10.5409958
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               1.7643777
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.2383610
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.1512910
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  1.3033574
                                                                    tail-prob.
    m1B: (Intercept)                                                0.93333333
    m1B: abs(C1 - C2)                                               0.13333333
    m1B: log(C1)                                                    0.86666667
    m1C: (Intercept)                                                0.93333333
    m1C: abs(C1 - C2)                                               0.86666667
    m1C: log(C1)                                                    0.73333333
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.53333333
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.20000000
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.20000000
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.06666667
                                                                      GR-crit
    m1B: (Intercept)                                                 2.145190
    m1B: abs(C1 - C2)                                                1.636072
    m1B: log(C1)                                                     2.195547
    m1C: (Intercept)                                                 1.659299
    m1C: abs(C1 - C2)                                                4.134504
    m1C: log(C1)                                                     1.605391
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               5.131510
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  7.435826
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               3.871514
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 11.005653
                                                                       MCE/SD
    m1B: (Intercept)                                                0.4075612
    m1B: abs(C1 - C2)                                               0.3751615
    m1B: log(C1)                                                    0.3488142
    m1C: (Intercept)                                                0.2954384
    m1C: abs(C1 - C2)                                               0.6373265
    m1C: log(C1)                                                    0.2849521
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.7291191
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.8050187
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.3473643
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.5436065
    
    
    $m4c
    $m4c$m1
                             Mean         SD         2.5%      97.5% tail-prob.
    m1B: (Intercept)   3.00575618 5.80702187  -4.52227265 16.6063418 0.73333333
    m1B: C1           -4.62587366 7.55056398 -22.47901248  5.0758856 0.60000000
    m1B: B21           0.08311468 0.40589492  -0.60810689  0.7124634 0.80000000
    m1C: (Intercept)   8.51447931 5.15328383   0.86929575 16.9376319 0.06666667
    m1C: C1          -11.17389024 6.90887086 -22.90931394 -0.6540646 0.06666667
    m1C: B21          -0.26657028 0.42069372  -1.17423767  0.3728009 0.40000000
    m1B: time          0.13368194 0.08971235  -0.01366188  0.3006044 0.06666667
    m1B: c1            0.08236306 0.21439328  -0.33840960  0.4290945 0.73333333
    m1C: time          0.01319705 0.10633851  -0.23049714  0.1906386 0.73333333
    m1C: c1            0.32574651 0.24648199  -0.05842006  0.8174301 0.20000000
                      GR-crit    MCE/SD
    m1B: (Intercept) 3.142131 0.3385517
    m1B: C1          2.838511 0.2127806
    m1B: B21         6.378046 0.5419444
    m1C: (Intercept) 1.426090 0.1825742
    m1C: C1          1.328826 0.1825742
    m1C: B21         3.717614        NA
    m1B: time        1.622047 0.1825742
    m1B: c1          1.020361 0.1825742
    m1C: time        1.263412 0.1825742
    m1C: c1          1.367357 0.1825742
    
    
    $m4d
    $m4d$m1
                             Mean         SD          2.5%       97.5% tail-prob.
    m1B: (Intercept)   4.93741924 7.02591813  -8.937370236 16.70658514 0.33333333
    m1B: C1           -7.04570659 9.42804502 -22.233129256 11.56272446 0.33333333
    m1C: (Intercept)   7.97001563 6.55096222  -3.330173223 19.21949121 0.13333333
    m1C: C1          -10.11764773 8.91580887 -25.761698677  5.45033190 0.13333333
    m1B: time         -0.12194427 0.28438493  -0.566995414  0.34492603 0.66666667
    m1B: I(time^2)     0.01789676 0.06674384  -0.055069517  0.13057801 0.93333333
    m1B: b21           0.27794367 0.55936790  -0.429092586  1.34356534 0.93333333
    m1B: c1            0.10036496 0.20111979  -0.230978485  0.45130863 0.60000000
    m1B: C1:time       0.19373069 0.26361311  -0.218715844  0.62423470 0.53333333
    m1B: b21:c1        0.81604649 0.53818355  -0.054783689  1.86474427 0.06666667
    m1C: time         -0.21975725 0.18475559  -0.517053048  0.06566410 0.26666667
    m1C: I(time^2)     0.07339773 0.06059251  -0.007937189  0.17682982 0.26666667
    m1C: b21          -0.97947566 0.43787679  -1.651160447 -0.06736911 0.06666667
    m1C: c1            0.47574229 0.21528389   0.127202540  0.81251868 0.00000000
    m1C: C1:time      -0.23081764 0.41439977  -0.995531142  0.20429802 0.93333333
    m1C: b21:c1        0.52004099 0.71564492  -0.775691629  1.67825118 0.46666667
                       GR-crit    MCE/SD
    m1B: (Intercept)  1.344874 0.1825742
    m1B: C1           1.246307 0.1825742
    m1C: (Intercept)  1.052089 0.1825742
    m1C: C1           1.053645 0.1825742
    m1B: time         6.718015 0.5394555
    m1B: I(time^2)   11.185255 0.8817643
    m1B: b21          2.892301 0.2805670
    m1B: c1           1.744924 0.2111872
    m1B: C1:time      1.379226 0.3173408
    m1B: b21:c1       1.013935 0.1944672
    m1C: time         2.212130 0.2294269
    m1C: I(time^2)    5.746522 0.4312902
    m1C: b21          1.080008 0.1840792
    m1C: c1           2.337200 0.2997764
    m1C: C1:time     10.939257 0.4044518
    m1C: b21:c1       1.185338 0.1825742
    
    
    $m4e
    $m4e$m1
                            Mean         SD         2.5%       97.5% tail-prob.
    m1B: (Intercept)  1.85705481 5.43543576  -6.71185011 11.70653885  0.7333333
    m1B: C1          -3.10353967 7.34450765 -16.36120814  8.53403628  0.7333333
    m1C: (Intercept)  4.71631324 5.49595912  -5.43102990 15.43286105  0.2666667
    m1C: C1          -6.63848332 7.53033590 -21.06911987  6.64342837  0.4000000
    m1B: log(time)    0.06467041 0.13768544  -0.09966105  0.40716431  0.7333333
    m1B: I(time^2)    0.02181687 0.01932204  -0.01254173  0.05317293  0.3333333
    m1B: p1           0.04318256 0.07515345  -0.08278251  0.16921938  0.6000000
    m1C: log(time)   -0.09326448 0.15179094  -0.33005800  0.16151208  0.6666667
    m1C: I(time^2)    0.01489069 0.02271850  -0.01737322  0.05334990  0.7333333
    m1C: p1           0.04735752 0.09280461  -0.18179173  0.15860432  0.4666667
                      GR-crit    MCE/SD
    m1B: (Intercept) 1.381249 0.1825742
    m1B: C1          1.362057 0.1825742
    m1C: (Intercept) 1.002086 0.1825742
    m1C: C1          1.004279 0.1825742
    m1B: log(time)   1.278779        NA
    m1B: I(time^2)   1.775294 0.2438765
    m1B: p1          1.433475 0.2022209
    m1C: log(time)   1.180656 0.1825742
    m1C: I(time^2)   1.081669 0.2255757
    m1C: p1          1.830484 0.3915003
    
    

