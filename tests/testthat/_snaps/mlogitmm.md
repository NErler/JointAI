# GRcrit and MCerror give same result

    $m0a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.16       1.62
    m1C: (Intercept)       1.35       2.19
    D_m1_id[1,1]           1.66       3.84
    
    
    $m0b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)      1.664       3.31
    m2C: (Intercept)      1.516       2.84
    D_m2_id[1,1]          0.984       1.08
    
    
    $m1a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.59       2.59
    m1B: C1                1.59       2.58
    m1C: (Intercept)       1.44       2.26
    m1C: C1                1.44       2.25
    D_m1_id[1,1]           4.74       9.82
    
    
    $m1b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       1.96       3.81
    m2B: C1                1.96       3.80
    m2C: (Intercept)       1.97       4.09
    m2C: C1                1.97       4.09
    D_m2_id[1,1]           3.14       6.09
    
    
    $m1c
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)      1.090       1.48
    m1C: (Intercept)      1.217       1.86
    m1B: c1               0.961       1.03
    m1C: c1               0.978       1.01
    D_m1_id[1,1]          2.731       5.22
    
    
    $m1d
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)      1.008       1.13
    m2C: (Intercept)      0.992       1.05
    m2B: c1               0.970       1.04
    m2C: c1               0.991       1.13
    D_m2_id[1,1]          1.140       1.63
    
    
    $m2a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.95       3.48
    m1B: C2                1.95       3.34
    m1C: (Intercept)       1.39       2.28
    m1C: C2                1.16       1.58
    D_m1_id[1,1]           2.32       4.25
    
    
    $m2b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       1.93       4.31
    m2B: C2                1.72       3.13
    m2C: (Intercept)       2.74       5.33
    m2C: C2                2.28       4.26
    D_m2_id[1,1]           2.81       6.12
    
    
    $m2c
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.17       1.70
    m1C: (Intercept)       1.10       1.43
    m1B: c2                1.56       2.78
    m1C: c2                1.52       2.38
    D_m1_id[1,1]           1.64       3.07
    
    
    $m2d
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       1.31       1.93
    m2C: (Intercept)       1.11       1.45
    m2B: c2                1.77       3.03
    m2C: c2                2.36       4.69
    D_m2_id[1,1]           2.50       7.02
    
    
    $m3a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    (Intercept)        4.53      14.45
    m1B                1.48       3.55
    m1C                1.03       1.32
    sigma_c1           1.01       1.26
    D_c1_id[1,1]       1.35       2.09
    
    
    $m3b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    (Intercept)        1.10       1.48
    m2B                1.27       1.88
    m2C                1.92       4.13
    sigma_c1           1.23       1.73
    D_c1_id[1,1]       1.14       1.59
    
    
    $m4a
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    m1B: (Intercept)            1.60       2.81
    m1B: M22                    1.72       3.27
    m1B: M23                    4.30       8.31
    m1B: M24                    2.53       4.69
    m1B: abs(C1 - C2)           1.58       2.72
    m1B: log(C1)                1.72       3.23
    m1C: (Intercept)            1.84       3.31
    m1C: M22                    1.78       6.75
    m1C: M23                    4.63      10.23
    m1C: M24                    1.32       2.31
    m1C: abs(C1 - C2)           2.01       4.24
    m1C: log(C1)                2.22       4.87
    m1B: m2B                    2.69       5.00
    m1B: m2C                    1.67       2.77
    m1B: m2B:abs(C1 - C2)       1.07       1.34
    m1B: m2C:abs(C1 - C2)       1.85       3.41
    m1C: m2B                    2.25       4.37
    m1C: m2C                    4.17       8.80
    m1C: m2B:abs(C1 - C2)       2.56       4.91
    m1C: m2C:abs(C1 - C2)       3.08       6.02
    D_m1_id[1,1]                3.24       6.39
    
    
    $m4b
    Potential scale reduction factors:
    
                                                                    Point est.
    m1B: (Intercept)                                                      2.04
    m1B: abs(C1 - C2)                                                     5.32
    m1B: log(C1)                                                          1.92
    m1C: (Intercept)                                                      1.85
    m1C: abs(C1 - C2)                                                     5.47
    m1C: log(C1)                                                          1.65
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                    5.32
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)       4.45
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                    3.07
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)       2.88
    D_m1_id[1,1]                                                          1.46
                                                                    Upper C.I.
    m1B: (Intercept)                                                      3.58
    m1B: abs(C1 - C2)                                                    10.19
    m1B: log(C1)                                                          3.42
    m1C: (Intercept)                                                      3.54
    m1C: abs(C1 - C2)                                                    12.03
    m1C: log(C1)                                                          3.02
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                   15.14
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)      11.57
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                    5.82
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)       5.52
    D_m1_id[1,1]                                                          2.87
    
    
    $m4c
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.86       3.58
    m1B: C1                1.93       3.82
    m1B: B21               1.30       2.27
    m1C: (Intercept)       2.46       4.49
    m1C: C1                2.39       4.34
    m1C: B21               1.97       4.01
    m1B: time              0.99       1.11
    m1B: c1                1.04       1.27
    m1C: time              0.98       0.99
    m1C: c1                1.06       1.32
    D_m1_id[1,1]           2.94       6.30
    D_m1_id[1,2]           4.07       8.17
    D_m1_id[2,2]           1.90       4.00
    D_m1_id[1,3]           1.81       3.31
    D_m1_id[2,3]           1.32       2.13
    D_m1_id[3,3]           1.08       1.40
    D_m1_id[1,4]           2.99       6.84
    D_m1_id[2,4]           3.03       6.44
    D_m1_id[3,4]           3.42       7.40
    D_m1_id[4,4]           4.28      10.55
    
    
    $m4d
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)      1.391       2.37
    m1B: C1               1.367       2.30
    m1C: (Intercept)      2.175       4.59
    m1C: C1               2.176       4.57
    m1B: time             1.540       3.33
    m1B: I(time^2)        3.003       7.17
    m1B: b21              2.123       5.35
    m1B: c1               0.957       1.03
    m1B: C1:time          3.562      10.09
    m1B: b21:c1           2.537       6.04
    m1C: time             4.927       9.51
    m1C: I(time^2)        1.034       1.23
    m1C: b21              1.504       3.03
    m1C: c1               1.153       1.72
    m1C: C1:time          4.662       9.39
    m1C: b21:c1           2.366       4.75
    D_m1_id[1,1]          2.659       5.13
    D_m1_id[1,2]          2.026       4.26
    D_m1_id[2,2]          1.012       1.14
    
    
    $m4e
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.23       1.77
    m1B: C1                1.20       1.71
    m1C: (Intercept)       1.27       2.19
    m1C: C1                1.23       2.00
    m1B: log(time)         1.21       1.74
    m1B: I(time^2)         1.45       2.39
    m1B: p1                1.08       1.45
    m1C: log(time)         1.13       1.60
    m1C: I(time^2)         1.25       2.14
    m1C: p1                1.10       1.39
    D_m1_id[1,1]           1.35       2.91
    
    

---

    $m0a
                      est  MCSE   SD MCSE/SD
    m1B: (Intercept) 0.21 0.026 0.14    0.18
    m1C: (Intercept) 0.19 0.046 0.16    0.29
    D_m1_id[1,1]     1.22 0.131 0.45    0.29
    
    $m0b
                      est  MCSE   SD MCSE/SD
    m2B: (Intercept) 0.48 0.044 0.24    0.18
    m2C: (Intercept) 0.28 0.074 0.24    0.31
    D_m2_id[1,1]     2.66 0.103 0.56    0.18
    
    $m1a
                      est MCSE   SD MCSE/SD
    m1B: (Intercept) -4.5 2.47  7.9    0.31
    m1B: C1           6.3 3.37 10.8    0.31
    m1C: (Intercept)  2.5 2.03  8.6    0.24
    m1C: C1          -3.3 2.78 11.7    0.24
    D_m1_id[1,1]      1.2 0.34  0.8    0.42
    
    $m1b
                        est  MCSE   SD MCSE/SD
    m2B: (Intercept)  11.41 11.93 19.7    0.60
    m2B: C1          -15.05 16.00 26.6    0.60
    m2C: (Intercept)   0.72 12.61 22.3    0.57
    m2C: C1           -0.82 16.97 30.0    0.56
    D_m2_id[1,1]       1.94  0.46  1.1    0.43
    
    $m1c
                       est  MCSE   SD MCSE/SD
    m1B: (Intercept)  0.39 0.028 0.19    0.15
    m1C: (Intercept)  0.28 0.041 0.23    0.18
    m1B: c1          -0.43 0.052 0.23    0.23
    m1C: c1          -0.19 0.039 0.22    0.18
    D_m1_id[1,1]      1.49 0.318 0.70    0.46
    
    $m1d
                       est  MCSE   SD MCSE/SD
    m2B: (Intercept) 0.287 0.062 0.23   0.270
    m2C: (Intercept)    NA    NA 0.24      NA
    m2B: c1          0.133 0.013 0.24   0.055
    m2C: c1          0.053 0.044 0.24   0.183
    D_m2_id[1,1]     1.740 0.220 0.85   0.259
    
    $m2a
                       est  MCSE   SD MCSE/SD
    m1B: (Intercept) -0.14 0.056 0.27    0.21
    m1B: C2          -0.54 0.057 0.25    0.23
    m1C: (Intercept) -0.36 0.072 0.23    0.31
    m1C: C2          -0.85 0.061 0.25    0.25
    D_m1_id[1,1]      1.41 0.141 0.53    0.27
    
    $m2b
                      est MCSE   SD MCSE/SD
    m2B: (Intercept) 0.70 0.14 0.27    0.52
    m2B: C2          0.30 0.21 0.40    0.52
    m2C: (Intercept) 0.55 0.14 0.29    0.47
    m2C: C2          0.39 0.21 0.40    0.51
    D_m2_id[1,1]     2.85 0.75 1.42    0.53
    
    $m2c
                       est MCSE   SD MCSE/SD
    m1B: (Intercept) -0.26 0.12 0.35    0.35
    m1C: (Intercept) -0.17 0.12 0.50    0.25
    m1B: c2          -2.12 0.26 0.78    0.33
    m1C: c2          -1.78 0.28 1.54    0.18
    D_m1_id[1,1]      1.55 0.20 0.61    0.33
    
    $m2d
                       est  MCSE   SD MCSE/SD
    m2B: (Intercept)  0.13 0.113 0.37    0.31
    m2C: (Intercept)  0.23 0.099 0.34    0.29
    m2B: c2          -2.20 0.809 1.56    0.52
    m2C: c2          -0.91 0.593 1.83    0.32
    D_m2_id[1,1]      3.36 0.491 1.26    0.39
    
    $m3a
                     est    MCSE      SD MCSE/SD
    (Intercept)   -7.651   5.267 2.9e+01    0.18
    m1B           -0.192   0.027 1.2e-01    0.23
    m1C           -0.084   0.014 7.9e-02    0.18
    sigma_c1       0.652   0.010 4.5e-02    0.23
    D_c1_id[1,1] 863.157 583.895 3.2e+03    0.18
    
    $m3b
                     est   MCSE    SD MCSE/SD
    (Intercept)   0.2563 0.0342 0.075    0.46
    m2B          -0.0057 0.0244 0.074    0.33
    m2C          -0.0084 0.0584 0.110    0.53
    sigma_c1      0.6231 0.0049 0.027    0.18
    D_c1_id[1,1]  0.0925 0.0064 0.024    0.27
    
    $m4a
                              est  MCSE   SD MCSE/SD
    m1B: (Intercept)       -2.693 1.033 3.08    0.34
    m1B: M22                0.278 0.193 0.38    0.51
    m1B: M23                0.139 0.233 0.77    0.30
    m1B: M24               -0.147 0.302 0.75    0.40
    m1B: abs(C1 - C2)       0.556 0.135 0.43    0.31
    m1B: log(C1)           -5.849 3.927 9.71    0.40
    m1C: (Intercept)       -4.393 1.198 3.05    0.39
    m1C: M22                0.169 0.196 0.47    0.42
    m1C: M23               -0.277 0.258 0.67    0.39
    m1C: M24               -0.108 0.192 0.54    0.35
    m1C: abs(C1 - C2)       0.656 0.260 0.53    0.49
    m1C: log(C1)          -11.485 3.842 9.30    0.41
    m1B: m2B                0.866 0.197 0.34    0.58
    m1B: m2C                0.154 0.233 0.58    0.40
    m1B: m2B:abs(C1 - C2)  -0.242 0.095 0.25    0.38
    m1B: m2C:abs(C1 - C2)   0.144 0.267 0.45    0.59
    m1C: m2B               -0.075 0.179 0.38    0.47
    m1C: m2C               -0.076 0.403 1.03    0.39
    m1C: m2B:abs(C1 - C2)   0.254 0.209 0.42    0.50
    m1C: m2C:abs(C1 - C2)   0.409 0.382 0.53    0.73
    D_m1_id[1,1]            1.448 0.342 0.61    0.56
    
    $m4b
                                                                       est  MCSE
    m1B: (Intercept)                                                 -2.32 0.610
    m1B: abs(C1 - C2)                                                 0.69 0.355
    m1B: log(C1)                                                     -5.52 4.105
    m1C: (Intercept)                                                 -4.97 1.348
    m1C: abs(C1 - C2)                                                 0.90 0.249
    m1C: log(C1)                                                    -12.92 3.018
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.45 0.588
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)   0.39 0.494
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.23 0.455
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)   0.37 0.431
    D_m1_id[1,1]                                                      1.35 0.095
                                                                       SD MCSE/SD
    m1B: (Intercept)                                                 3.34    0.18
    m1B: abs(C1 - C2)                                                0.63    0.56
    m1B: log(C1)                                                    10.46    0.39
    m1C: (Intercept)                                                 3.00    0.45
    m1C: abs(C1 - C2)                                                0.56    0.45
    m1C: log(C1)                                                     9.04    0.33
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.91    0.64
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.57    0.87
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.86    0.53
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.74    0.59
    D_m1_id[1,1]                                                     0.40    0.24
    
    $m4c
                        est   MCSE     SD MCSE/SD
    m1B: (Intercept) -1.567 1.2681  6.945    0.18
    m1B: C1           2.976 3.3013  9.433    0.35
    m1B: B21         -0.273 0.0536  0.145    0.37
    m1C: (Intercept)  1.076 1.5579  7.444    0.21
    m1C: C1          -0.743 2.1213 10.121    0.21
    m1C: B21          0.159 0.1397  0.246    0.57
    m1B: time        -0.065 0.0181  0.099    0.18
    m1B: c1          -0.381 0.0380  0.198    0.19
    m1C: time        -0.222 0.0163  0.089    0.18
    m1C: c1          -0.135 0.0523  0.245    0.21
    D_m1_id[1,1]      0.259 0.0618  0.079    0.78
    D_m1_id[1,2]     -0.013 0.0256  0.054    0.47
    D_m1_id[2,2]      0.207 0.0206  0.047    0.44
    D_m1_id[1,3]      0.032 0.0131  0.042    0.31
    D_m1_id[2,3]      0.023 0.0066  0.036    0.18
    D_m1_id[3,3]      0.205 0.0066  0.036    0.18
    D_m1_id[1,4]      0.012 0.0312  0.059    0.53
    D_m1_id[2,4]     -0.029 0.0140  0.036    0.39
    D_m1_id[3,4]     -0.014 0.0235  0.044    0.54
    D_m1_id[4,4]      0.150 0.0240  0.058    0.41
    
    $m4d
                        est   MCSE     SD MCSE/SD
    m1B: (Intercept) -0.089 1.9324  7.162    0.27
    m1B: C1           0.327 2.5398  9.500    0.27
    m1C: (Intercept)  6.608 2.6109  8.305    0.31
    m1C: C1          -7.778 3.5160 11.186    0.31
    m1B: time         0.043 0.0841  0.172    0.49
    m1B: I(time^2)   -0.058 0.0302  0.070    0.43
    m1B: b21          1.530 0.2965  0.615    0.48
    m1B: c1          -0.550 0.0413  0.226    0.18
    m1B: C1:time      0.154 0.2517  0.460    0.55
    m1B: b21:c1       1.768 0.6075  1.143    0.53
    m1C: time        -0.271 0.1799  0.375    0.48
    m1C: I(time^2)    0.044 0.0065  0.036    0.18
    m1C: b21          1.699 0.3566  0.720    0.50
    m1C: c1          -0.279 0.0407  0.223    0.18
    m1C: C1:time     -0.331 0.2276  0.427    0.53
    m1C: b21:c1       1.402 0.4460  1.229    0.36
    D_m1_id[1,1]      0.462 0.0653  0.133    0.49
    D_m1_id[1,2]     -0.061 0.0144  0.067    0.22
    D_m1_id[2,2]      0.418 0.0146  0.080    0.18
    
    $m4e
                         est   MCSE     SD MCSE/SD
    m1B: (Intercept)  1.3799 1.7601  7.801   0.226
    m1B: C1          -1.7584 2.3916 10.604   0.226
    m1C: (Intercept)  6.9285 0.9233  5.057   0.183
    m1C: C1          -9.3141 1.2703  6.958   0.183
    m1B: log(time)    0.0226 0.0140  0.077   0.183
    m1B: I(time^2)   -0.0026 0.0042  0.015   0.273
    m1B: p1           0.0055 0.0121  0.067   0.183
    m1C: log(time)   -0.0468 0.0155  0.085   0.183
    m1C: I(time^2)   -0.0125 0.0080  0.022   0.367
    m1C: p1           0.0418 0.0030  0.051   0.059
    D_m1_id[1,1]      1.1586 0.2410  0.461   0.523
    

# summary output remained the same

    
    Call:
    mlogitmm_imp(fixed = m1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept) 
         0.2135      0.1915 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.225
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept) 
         0.4804      0.2807 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.657
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
         -4.460       6.296       2.548      -3.293 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.229
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
        11.4091    -15.0473      0.7236     -0.8215 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.938
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
         0.3943      0.2836     -0.4329     -0.1852 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.486
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
        0.28702     0.06600     0.13349     0.05274 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.74
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
        -0.1379     -0.5446     -0.3634     -0.8471 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.414
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
         0.6954      0.3026      0.5504      0.3868 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.848
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
        -0.2648     -0.1749     -2.1155     -1.7804 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.548
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
         0.1283      0.2277     -2.2044     -0.9083 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.358
    
    
    Call:
    lme_imp(fixed = c1 ~ m1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m1B         m1C 
       -7.65134    -0.19155    -0.08385 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       863.2
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6516 
    
    Call:
    lme_imp(fixed = c1 ~ m2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m2B         m2C 
       0.256268   -0.005718   -0.008381 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)      0.0925
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6231 
    
    Call:
    mlogitmm_imp(fixed = m1 ~ M2 + m2 * abs(C1 - C2) + log(C1) + 
        (1 | id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
         (Intercept)              M22              M23              M24 
            -2.69328          0.27790          0.13891         -0.14663 
        abs(C1 - C2)          log(C1)      (Intercept)              M22 
             0.55587         -5.84857         -4.39333          0.16949 
                 M23              M24     abs(C1 - C2)          log(C1) 
            -0.27709         -0.10820          0.65570        -11.48459 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
             0.86631          0.15429         -0.24243          0.14384 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
            -0.07526         -0.07606          0.25414          0.40935 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.448
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ ifelse(as.numeric(m2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1) + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
                                                   (Intercept) 
                                                       -2.3216 
                                                  abs(C1 - C2) 
                                                        0.6864 
                                                       log(C1) 
                                                       -5.5183 
                                                   (Intercept) 
                                                       -4.9699 
                                                  abs(C1 - C2) 
                                                        0.8988 
                                                       log(C1) 
                                                      -12.9193 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                       -0.4527 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                        0.3856 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                       -0.2314 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                        0.3734 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.352
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ time + c1 + C1 + B2 + (c1 * time | 
        id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020, 
        warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1         B21 (Intercept)          C1         B21 
       -1.56662     2.97615    -0.27324     1.07599    -0.74338     0.15888 
           time          c1        time          c1 
       -0.06532    -0.38077    -0.22156    -0.13524 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)       c1     time  c1:time
    (Intercept)     0.25885 -0.01276  0.03201  0.01176
    c1             -0.01276  0.20713  0.02254 -0.02855
    time            0.03201  0.02254  0.20463 -0.01403
    c1:time         0.01176 -0.02855 -0.01403  0.15043
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 * time + I(time^2) + b2 * c1, data = longDF, 
        random = ~time | id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1        time   I(time^2) 
       -0.08893     0.32658     6.60840    -7.77770     0.04346    -0.05803 
            b21          c1     C1:time      b21:c1        time   I(time^2) 
        1.52982    -0.55002     0.15403     1.76801    -0.27112     0.04369 
            b21          c1     C1:time      b21:c1 
        1.69899    -0.27892    -0.33053     1.40209 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)     time
    (Intercept)     0.46234 -0.06084
    time           -0.06084  0.41820
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + log(time) + I(time^2) + p1, data = longDF, 
        random = ~1 | id, n.adapt = 5, n.iter = 10, shrinkage = "ridge", 
        seed = 2020, parallel = TRUE, n.cores = 2)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1   log(time)   I(time^2) 
       1.379913   -1.758428    6.928516   -9.314070    0.022578   -0.002576 
             p1   log(time)   I(time^2)          p1 
       0.005513   -0.046788   -0.012531    0.041755 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.159
    
    $m0a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept) 
         0.2135      0.1915 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.225
    
    
    $m0b
    
    Call:
    mlogitmm_imp(fixed = m2 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept) 
         0.4804      0.2807 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.657
    
    
    $m1a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
         -4.460       6.296       2.548      -3.293 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.229
    
    
    $m1b
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
        11.4091    -15.0473      0.7236     -0.8215 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.938
    
    
    $m1c
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
         0.3943      0.2836     -0.4329     -0.1852 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.486
    
    
    $m1d
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
        0.28702     0.06600     0.13349     0.05274 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.74
    
    
    $m2a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
        -0.1379     -0.5446     -0.3634     -0.8471 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.414
    
    
    $m2b
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
         0.6954      0.3026      0.5504      0.3868 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.848
    
    
    $m2c
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
        -0.2648     -0.1749     -2.1155     -1.7804 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.548
    
    
    $m2d
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
         0.1283      0.2277     -2.2044     -0.9083 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.358
    
    
    $m3a
    
    Call:
    lme_imp(fixed = c1 ~ m1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m1B         m1C 
       -7.65134    -0.19155    -0.08385 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       863.2
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6516 
    
    $m3b
    
    Call:
    lme_imp(fixed = c1 ~ m2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m2B         m2C 
       0.256268   -0.005718   -0.008381 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)      0.0925
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6231 
    
    $m4a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ M2 + m2 * abs(C1 - C2) + log(C1) + 
        (1 | id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
         (Intercept)              M22              M23              M24 
            -2.69328          0.27790          0.13891         -0.14663 
        abs(C1 - C2)          log(C1)      (Intercept)              M22 
             0.55587         -5.84857         -4.39333          0.16949 
                 M23              M24     abs(C1 - C2)          log(C1) 
            -0.27709         -0.10820          0.65570        -11.48459 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
             0.86631          0.15429         -0.24243          0.14384 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
            -0.07526         -0.07606          0.25414          0.40935 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.448
    
    
    $m4b
    
    Call:
    mlogitmm_imp(fixed = m1 ~ ifelse(as.numeric(m2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1) + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
                                                   (Intercept) 
                                                       -2.3216 
                                                  abs(C1 - C2) 
                                                        0.6864 
                                                       log(C1) 
                                                       -5.5183 
                                                   (Intercept) 
                                                       -4.9699 
                                                  abs(C1 - C2) 
                                                        0.8988 
                                                       log(C1) 
                                                      -12.9193 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                       -0.4527 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                        0.3856 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                       -0.2314 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                        0.3734 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.352
    
    
    $m4c
    
    Call:
    mlogitmm_imp(fixed = m1 ~ time + c1 + C1 + B2 + (c1 * time | 
        id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020, 
        warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1         B21 (Intercept)          C1         B21 
       -1.56662     2.97615    -0.27324     1.07599    -0.74338     0.15888 
           time          c1        time          c1 
       -0.06532    -0.38077    -0.22156    -0.13524 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)       c1     time  c1:time
    (Intercept)     0.25885 -0.01276  0.03201  0.01176
    c1             -0.01276  0.20713  0.02254 -0.02855
    time            0.03201  0.02254  0.20463 -0.01403
    c1:time         0.01176 -0.02855 -0.01403  0.15043
    
    
    $m4d
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 * time + I(time^2) + b2 * c1, data = longDF, 
        random = ~time | id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1        time   I(time^2) 
       -0.08893     0.32658     6.60840    -7.77770     0.04346    -0.05803 
            b21          c1     C1:time      b21:c1        time   I(time^2) 
        1.52982    -0.55002     0.15403     1.76801    -0.27112     0.04369 
            b21          c1     C1:time      b21:c1 
        1.69899    -0.27892    -0.33053     1.40209 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)     time
    (Intercept)     0.46234 -0.06084
    time           -0.06084  0.41820
    
    
    $m4e
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + log(time) + I(time^2) + p1, data = longDF, 
        random = ~1 | id, n.adapt = 5, n.iter = 10, shrinkage = "ridge", 
        seed = 2020, parallel = TRUE, n.cores = 2)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1   log(time)   I(time^2) 
       1.379913   -1.758428    6.928516   -9.314070    0.022578   -0.002576 
             p1   log(time)   I(time^2)          p1 
       0.005513   -0.046788   -0.012531    0.041755 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.159
    
    

---

    $m0a
    $m0a$m1
    (Intercept) (Intercept) 
      0.2134568   0.1915382 
    
    
    $m0b
    $m0b$m2
    (Intercept) (Intercept) 
      0.4803793   0.2806805 
    
    
    $m1a
    $m1a$m1
    (Intercept)          C1 (Intercept)          C1 
      -4.460411    6.295780    2.548215   -3.292802 
    
    
    $m1b
    $m1b$m2
    (Intercept)          C1 (Intercept)          C1 
     11.4091472 -15.0472987   0.7236093  -0.8215340 
    
    
    $m1c
    $m1c$m1
    (Intercept) (Intercept)          c1          c1 
      0.3943436   0.2836212  -0.4328542  -0.1852188 
    
    
    $m1d
    $m1d$m2
    (Intercept) (Intercept)          c1          c1 
     0.28702380  0.06599654  0.13348918  0.05273593 
    
    
    $m2a
    $m2a$m1
    (Intercept)          C2 (Intercept)          C2 
     -0.1378920  -0.5446117  -0.3633568  -0.8471287 
    
    
    $m2b
    $m2b$m2
    (Intercept)          C2 (Intercept)          C2 
      0.6954069   0.3026038   0.5504035   0.3867606 
    
    
    $m2c
    $m2c$m1
    (Intercept) (Intercept)          c2          c2 
     -0.2648247  -0.1748987  -2.1154723  -1.7803501 
    
    
    $m2d
    $m2d$m2
    (Intercept) (Intercept)          c2          c2 
      0.1283168   0.2276781  -2.2043560  -0.9082660 
    
    
    $m3a
    $m3a$c1
    (Intercept)         m1B         m1C 
    -7.65134105 -0.19155102 -0.08385104 
    
    
    $m3b
    $m3b$c1
     (Intercept)          m2B          m2C 
     0.256268417 -0.005718371 -0.008381051 
    
    
    $m4a
    $m4a$m1
         (Intercept)              M22              M23              M24 
         -2.69328178       0.27790225       0.13890779      -0.14662896 
        abs(C1 - C2)          log(C1)      (Intercept)              M22 
          0.55586893      -5.84856927      -4.39333003       0.16949385 
                 M23              M24     abs(C1 - C2)          log(C1) 
         -0.27709030      -0.10819650       0.65570101     -11.48458815 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
          0.86631046       0.15429005      -0.24242649       0.14384443 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
         -0.07526408      -0.07605866       0.25414451       0.40934592 
    
    
    $m4b
    $m4b$m1
                                                   (Intercept) 
                                                    -2.3215556 
                                                  abs(C1 - C2) 
                                                     0.6863851 
                                                       log(C1) 
                                                    -5.5182719 
                                                   (Intercept) 
                                                    -4.9699163 
                                                  abs(C1 - C2) 
                                                     0.8988009 
                                                       log(C1) 
                                                   -12.9193269 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                    -0.4526902 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                     0.3855537 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                    -0.2313924 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                     0.3734426 
    
    
    $m4c
    $m4c$m1
    (Intercept)          C1         B21 (Intercept)          C1         B21 
    -1.56662425  2.97615072 -0.27324468  1.07598828 -0.74338257  0.15888014 
           time          c1        time          c1 
    -0.06532383 -0.38076701 -0.22156015 -0.13524329 
    
    
    $m4d
    $m4d$m1
    (Intercept)          C1 (Intercept)          C1        time   I(time^2) 
    -0.08892778  0.32658039  6.60840429 -7.77770444  0.04346155 -0.05803078 
            b21          c1     C1:time      b21:c1        time   I(time^2) 
     1.52982311 -0.55002396  0.15402668  1.76800932 -0.27112268  0.04368937 
            b21          c1     C1:time      b21:c1 
     1.69899451 -0.27892360 -0.33053091  1.40209203 
    
    
    $m4e
    $m4e$m1
     (Intercept)           C1  (Intercept)           C1    log(time)    I(time^2) 
     1.379913136 -1.758428429  6.928515554 -9.314069664  0.022577737 -0.002576087 
              p1    log(time)    I(time^2)           p1 
     0.005513385 -0.046787732 -0.012530934  0.041754594 
    
    

---

    $m0a
    $m0a$m1
                       2.5%     97.5%
    (Intercept) -0.05883779 0.4226392
    (Intercept) -0.08551998 0.5055687
    
    
    $m0b
    $m0b$m2
                       2.5%     97.5%
    (Intercept) -0.08625171 0.8316464
    (Intercept) -0.19079819 0.6788190
    
    
    $m1a
    $m1a$m1
                     2.5%     97.5%
    (Intercept) -18.89065  9.200931
    C1          -12.58078 25.820860
    (Intercept) -14.89309 18.153729
    C1          -24.57747 20.461066
    
    
    $m1b
    $m1b$m2
                     2.5%    97.5%
    (Intercept) -33.31016 34.54844
    C1          -46.05799 45.20189
    (Intercept) -43.14191 32.64828
    C1          -43.93039 58.29021
    
    
    $m1c
    $m1c$m1
                      2.5%       97.5%
    (Intercept)  0.0666733  0.71368955
    (Intercept) -0.1473671  0.61752567
    c1          -0.8076548 -0.07302861
    c1          -0.5407608  0.24302367
    
    
    $m1d
    $m1d$m2
                       2.5%     97.5%
    (Intercept) -0.04555777 0.6759814
    (Intercept) -0.26958738 0.5537672
    c1          -0.32192147 0.5661100
    c1          -0.40457429 0.4149541
    
    
    $m2a
    $m2a$m1
                      2.5%      97.5%
    (Intercept) -0.5888443  0.4137167
    C2          -0.9418972 -0.1556413
    (Intercept) -0.7542115  0.1085512
    C2          -1.2354564 -0.3765900
    
    
    $m2b
    $m2b$m2
                      2.5%     97.5%
    (Intercept)  0.3139296 1.1484155
    C2          -0.3094379 0.9550367
    (Intercept)  0.1025895 0.9953817
    C2          -0.2260534 1.0448086
    
    
    $m2c
    $m2c$m1
                      2.5%      97.5%
    (Intercept) -0.7177495  0.5376011
    (Intercept) -1.1671227  0.7433323
    c2          -3.1694752 -0.6781467
    c2          -4.8036637  0.4169312
    
    
    $m2d
    $m2d$m2
                      2.5%     97.5%
    (Intercept) -0.6377134 0.7269308
    (Intercept) -0.3685870 0.7527052
    c2          -4.7816579 0.3845351
    c2          -4.2400328 1.6871222
    
    
    $m3a
    $m3a$c1
                        2.5%      97.5%
    (Intercept) -109.5248893 5.44977184
    m1B           -0.3774982 0.05359981
    m1C           -0.2645915 0.02634624
    
    
    $m3b
    $m3b$c1
                      2.5%     97.5%
    (Intercept)  0.1140349 0.3996927
    m2B         -0.1288669 0.1270185
    m2C         -0.1722801 0.1625559
    
    
    $m4a
    $m4a$m1
                             2.5%      97.5%
    (Intercept)       -7.24364598  3.3548663
    M22               -0.42087360  1.0532547
    M23               -0.72833739  1.8564907
    M24               -1.57922507  0.9033199
    abs(C1 - C2)       0.03671169  1.3736111
    log(C1)          -22.01178417 11.5188902
    (Intercept)       -8.83565014  1.2440537
    M22               -0.79050352  0.8559679
    M23               -1.32692391  0.7307407
    M24               -0.95725060  0.8222153
    abs(C1 - C2)      -0.15556024  1.4555158
    log(C1)          -26.87520707  3.4550832
    m2B                0.30887908  1.4287173
    m2C               -0.87488552  1.1415080
    m2B:abs(C1 - C2)  -0.58182175  0.2862264
    m2C:abs(C1 - C2)  -0.67231386  0.7580777
    m2B               -0.55863376  0.6519168
    m2C               -2.02687355  1.4017999
    m2B:abs(C1 - C2)  -0.36852040  0.8924479
    m2C:abs(C1 - C2)  -0.17034063  1.5241583
    
    
    $m4b
    $m4b$m1
                                                                      2.5%
    (Intercept)                                                 -7.5974270
    abs(C1 - C2)                                                -0.1391450
    log(C1)                                                    -24.6170293
    (Intercept)                                                 -9.4629073
    abs(C1 - C2)                                                 0.1606495
    log(C1)                                                    -26.2078596
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -2.1141114
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.3031152
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -1.3268226
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -1.3754496
                                                                    97.5%
    (Intercept)                                                 5.1281346
    abs(C1 - C2)                                                1.8252259
    log(C1)                                                    15.5380685
    (Intercept)                                                 0.2677391
    abs(C1 - C2)                                                1.7946637
    log(C1)                                                     2.0906564
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.7558092
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  1.5959033
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               1.6676514
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  1.2400258
    
    
    $m4c
    $m4c$m1
                       2.5%       97.5%
    (Intercept) -11.7415999 10.05920199
    C1          -13.1022359 16.21791928
    B21          -0.5065424  0.01855280
    (Intercept) -11.6730749 13.54546944
    C1          -18.3029556 16.73805806
    B21          -0.3594743  0.49451182
    time         -0.2419525  0.08899085
    c1           -0.6767125 -0.02919670
    time         -0.3533923 -0.06003064
    c1           -0.5334953  0.36467164
    
    
    $m4d
    $m4d$m1
                        2.5%       97.5%
    (Intercept) -16.57079950  9.92269421
    C1          -13.26953395 22.04056754
    (Intercept) -13.32861641 17.95646232
    C1          -22.86452398 18.96194383
    time         -0.22665752  0.32261305
    I(time^2)    -0.22947855  0.02538569
    b21           0.83801420  2.53054953
    c1           -0.92463401 -0.17421097
    C1:time      -0.33031099  1.14005595
    b21:c1       -0.83198652  3.37046977
    time         -0.85730489  0.30598963
    I(time^2)    -0.01782382  0.11780504
    b21           0.40641490  2.73871289
    c1           -0.60828182  0.06993293
    C1:time      -1.00262101  0.33387150
    b21:c1       -1.06235770  3.08345854
    
    
    $m4e
    $m4e$m1
                        2.5%       97.5%
    (Intercept) -12.40096601 15.17490204
    C1          -20.64386081 16.28718431
    (Intercept)  -2.38499933 13.44472460
    C1          -18.42554483  3.48805177
    log(time)    -0.08541225  0.17385232
    I(time^2)    -0.02908535  0.02914760
    p1           -0.09950188  0.13494468
    log(time)    -0.20311064  0.08942260
    I(time^2)    -0.06482137  0.01681061
    p1           -0.03176287  0.13733615
    
    

---

    $m0a
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                      Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept) 0.213 0.143 -0.0588 0.423      0.200    1.46  0.183
    m1C: (Intercept) 0.192 0.160 -0.0855 0.506      0.267    2.00  0.287
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.22 0.446 0.707  2.24               2.43  0.295
    
    
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
                      Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    m2B: (Intercept) 0.480 0.244 -0.0863 0.832      0.133    2.43  0.183
    m2C: (Intercept) 0.281 0.243 -0.1908 0.679      0.333    2.06  0.306
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 2.66 0.562 1.88  3.68               1.08  0.183
    
    
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
                      Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept) -4.46  7.91 -18.9   9.2      0.533    1.83  0.312
    m1B: C1           6.30 10.78 -12.6  25.8      0.533    1.82  0.313
    m1C: (Intercept)  2.55  8.60 -14.9  18.2      0.600    1.26  0.236
    m1C: C1          -3.29 11.74 -24.6  20.5      0.600    1.26  0.237
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.23 0.796 0.506  3.12               4.58  0.422
    
    
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
                        Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    m2B: (Intercept)  11.409 19.7 -33.3  34.5      0.400    4.23  0.605
    m2B: C1          -15.047 26.6 -46.1  45.2      0.400    4.18  0.602
    m2C: (Intercept)   0.724 22.3 -43.1  32.6      0.667    4.00  0.566
    m2C: C1           -0.822 30.0 -43.9  58.3      0.667    3.99  0.565
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 1.94 1.07 0.893  4.14               3.63  0.427
    
    
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
                       Mean    SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)  0.394 0.188  0.0667  0.714     0.0667   1.245  0.148
    m1C: (Intercept)  0.284 0.226 -0.1474  0.618     0.2000   1.283  0.183
    m1B: c1          -0.433 0.230 -0.8077 -0.073     0.0000   1.073  0.228
    m1C: c1          -0.185 0.216 -0.5408  0.243     0.4667   0.982  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.49 0.696 0.592  2.66                4.5  0.457
    
    
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
                       Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    m2B: (Intercept) 0.2870 0.229 -0.0456 0.676      0.200    1.33 0.2696
    m2C: (Intercept) 0.0660 0.238 -0.2696 0.554      0.800    1.50       
    m2B: c1          0.1335 0.243 -0.3219 0.566      0.533    1.34 0.0548
    m2C: c1          0.0527 0.243 -0.4046 0.415      0.933    1.20 0.1826
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 1.74 0.851 0.917  3.81               1.82  0.259
    
    
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
                       Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept) -0.138 0.272 -0.589  0.414      0.400    2.08  0.207
    m1B: C2          -0.545 0.253 -0.942 -0.156      0.000    1.82  0.226
    m1C: (Intercept) -0.363 0.234 -0.754  0.109      0.133    2.28  0.307
    m1C: C2          -0.847 0.246 -1.235 -0.377      0.000    1.42  0.249
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.41 0.53 0.727  2.64               1.92  0.267
    
    
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
    m2B: (Intercept) 0.695 0.269  0.314 1.148      0.000    4.64  0.524
    m2B: C2          0.303 0.401 -0.309 0.955      0.533    3.12  0.522
    m2C: (Intercept) 0.550 0.293  0.103 0.995      0.000    4.89  0.475
    m2C: C2          0.387 0.402 -0.226 1.045      0.467    3.81  0.513
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 2.85 1.42 1.21  5.77               4.43  0.528
    
    
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
                       Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept) -0.265 0.346 -0.718  0.538      0.400    1.39  0.345
    m1C: (Intercept) -0.175 0.496 -1.167  0.743      0.667    1.23  0.250
    m1B: c2          -2.115 0.783 -3.169 -0.678      0.000    1.29  0.329
    m1C: c2          -1.780 1.538 -4.804  0.417      0.200    2.00  0.184
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.55 0.608 0.702  2.43               1.46  0.331
    
    
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
    m2B: (Intercept)  0.128 0.365 -0.638 0.727      0.667    2.85  0.309
    m2C: (Intercept)  0.228 0.342 -0.369 0.753      0.467    1.72  0.288
    m2B: c2          -2.204 1.564 -4.782 0.385      0.200    3.42  0.518
    m2C: c2          -0.908 1.829 -4.240 1.687      0.800    5.23  0.324
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 3.36 1.26 1.89  6.01               2.84  0.389
    
    
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
                   Mean     SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    (Intercept) -7.6513 28.849 -109.525 5.4498      0.333    1.16  0.183
    m1B         -0.1916  0.118   -0.377 0.0536      0.133    1.89  0.229
    m1C         -0.0839  0.079   -0.265 0.0263      0.267    1.63  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_c1_id[1,1]  863 3198 0.0638 12177               1.25  0.183
    
    Posterior summary of residual std. deviation:
              Mean     SD  2.5% 97.5% GR-crit MCE/SD
    sigma_c1 0.652 0.0451 0.603 0.769    1.05  0.226
    
    
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
                    Mean     SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    (Intercept)  0.25627 0.0746  0.114 0.400      0.000    2.30  0.458
    m2B         -0.00572 0.0741 -0.129 0.127      0.867    1.42  0.329
    m2C         -0.00838 0.1099 -0.172 0.163      1.000    4.97  0.531
    
    Posterior summary of random effects covariance matrix:
                   Mean     SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_c1_id[1,1] 0.0925 0.0238 0.0573  0.14               1.46  0.271
    
    Posterior summary of residual std. deviation:
              Mean     SD  2.5% 97.5% GR-crit MCE/SD
    sigma_c1 0.623 0.0268 0.578 0.667    1.02  0.183
    
    
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
                              Mean    SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)       -2.6933 3.081  -7.2436  3.355      0.400    1.60  0.335
    m1B: M22                0.2779 0.378  -0.4209  1.053      0.333    3.47  0.510
    m1B: M23                0.1389 0.765  -0.7283  1.856      0.733    6.16  0.305
    m1B: M24               -0.1466 0.754  -1.5792  0.903      0.800    3.37  0.401
    m1B: abs(C1 - C2)       0.5559 0.430   0.0367  1.374      0.000    2.06  0.314
    m1B: log(C1)           -5.8486 9.706 -22.0118 11.519      0.533    2.06  0.405
    m1C: (Intercept)       -4.3933 3.048  -8.8357  1.244      0.200    2.42  0.393
    m1C: M22                0.1695 0.470  -0.7905  0.856      0.733    3.32  0.418
    m1C: M23               -0.2771 0.666  -1.3269  0.731      0.867    8.23  0.387
    m1C: M24               -0.1082 0.540  -0.9573  0.822      0.867    2.69  0.355
    m1C: abs(C1 - C2)       0.6557 0.532  -0.1556  1.456      0.200    2.81  0.489
    m1C: log(C1)          -11.4846 9.302 -26.8752  3.455      0.200    2.87  0.413
    m1B: m2B                0.8663 0.340   0.3089  1.429      0.000    4.48  0.579
    m1B: m2C                0.1543 0.583  -0.8749  1.142      0.867    2.53  0.399
    m1B: m2B:abs(C1 - C2)  -0.2424 0.250  -0.5818  0.286      0.267    2.07  0.381
    m1B: m2C:abs(C1 - C2)   0.1438 0.453  -0.6723  0.758      0.733    3.25  0.589
    m1C: m2B               -0.0753 0.377  -0.5586  0.652      0.733    3.43  0.475
    m1C: m2C               -0.0761 1.027  -2.0269  1.402      0.733    8.66  0.392
    m1C: m2B:abs(C1 - C2)   0.2541 0.420  -0.3685  0.892      0.600    3.72  0.497
    m1C: m2C:abs(C1 - C2)   0.4093 0.526  -0.1703  1.524      0.533    5.29  0.727
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.45 0.608 0.524  2.62               5.46  0.562
    
    
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
                                                                       Mean     SD
    m1B: (Intercept)                                                 -2.322  3.340
    m1B: abs(C1 - C2)                                                 0.686  0.628
    m1B: log(C1)                                                     -5.518 10.460
    m1C: (Intercept)                                                 -4.970  3.005
    m1C: abs(C1 - C2)                                                 0.899  0.559
    m1C: log(C1)                                                    -12.919  9.043
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.453  0.915
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)   0.386  0.570
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.231  0.861
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)   0.373  0.735
                                                                       2.5%  97.5%
    m1B: (Intercept)                                                 -7.597  5.128
    m1B: abs(C1 - C2)                                                -0.139  1.825
    m1B: log(C1)                                                    -24.617 15.538
    m1C: (Intercept)                                                 -9.463  0.268
    m1C: abs(C1 - C2)                                                 0.161  1.795
    m1C: log(C1)                                                    -26.208  2.091
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -2.114  0.756
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.303  1.596
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -1.327  1.668
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -1.375  1.240
                                                                    tail-prob.
    m1B: (Intercept)                                                     0.467
    m1B: abs(C1 - C2)                                                    0.133
    m1B: log(C1)                                                         0.667
    m1C: (Intercept)                                                     0.133
    m1C: abs(C1 - C2)                                                    0.000
    m1C: log(C1)                                                         0.200
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                   0.733
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)      0.467
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                   0.667
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)      0.600
                                                                    GR-crit MCE/SD
    m1B: (Intercept)                                                   2.74  0.183
    m1B: abs(C1 - C2)                                                  8.17  0.565
    m1B: log(C1)                                                       2.41  0.392
    m1C: (Intercept)                                                   3.18  0.449
    m1C: abs(C1 - C2)                                                  5.36  0.446
    m1C: log(C1)                                                       2.78  0.334
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                 8.60  0.643
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)    7.08  0.866
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                 4.95  0.528
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)    5.77  0.587
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.35 0.401 0.897  2.21               1.07  0.236
    
    
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
                        Mean      SD    2.5%   97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept) -1.5666  6.9455 -11.742 10.0592     0.7333   2.528  0.183
    m1B: C1           2.9762  9.4327 -13.102 16.2179     0.6667   2.615  0.350
    m1B: B21         -0.2732  0.1447  -0.507  0.0186     0.1333   1.598  0.370
    m1C: (Intercept)  1.0760  7.4443 -11.673 13.5455     0.8667   2.478  0.209
    m1C: C1          -0.7434 10.1205 -18.303 16.7381     1.0000   2.435  0.210
    m1C: B21          0.1589  0.2462  -0.359  0.4945     0.4667   3.295  0.568
    m1B: time        -0.0653  0.0993  -0.242  0.0890     0.4667   0.982  0.183
    m1B: c1          -0.3808  0.1978  -0.677 -0.0292     0.0667   1.477  0.192
    m1C: time        -0.2216  0.0893  -0.353 -0.0600     0.0000   1.068  0.183
    m1C: c1          -0.1352  0.2455  -0.533  0.3647     0.6000   1.565  0.213
    
    Posterior summary of random effects covariance matrix:
                    Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1]  0.2588 0.0793  0.1643 0.4066               6.98  0.779
    D_m1_id[1,2] -0.0128 0.0543 -0.1294 0.0557      0.933    4.44  0.471
    D_m1_id[2,2]  0.2071 0.0468  0.1380 0.2859               3.07  0.440
    D_m1_id[1,3]  0.0320 0.0424 -0.0335 0.1036      0.533    3.10  0.310
    D_m1_id[2,3]  0.0225 0.0363 -0.0425 0.0931      0.467    1.70  0.183
    D_m1_id[3,3]  0.2046 0.0362  0.1514 0.2748               1.07  0.183
    D_m1_id[1,4]  0.0118 0.0593 -0.0723 0.1316      0.933    6.00  0.526
    D_m1_id[2,4] -0.0286 0.0356 -0.0876 0.0317      0.467    5.12  0.393
    D_m1_id[3,4] -0.0140 0.0437 -0.0809 0.0564      0.733    5.56  0.538
    D_m1_id[4,4]  0.1504 0.0585  0.0851 0.2653               6.76  0.410
    
    
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
                        Mean      SD     2.5%   97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept) -0.0889  7.1622 -16.5708  9.9227      0.733    3.04  0.270
    m1B: C1           0.3266  9.5003 -13.2695 22.0406      0.733    2.90  0.267
    m1C: (Intercept)  6.6084  8.3050 -13.3286 17.9565      0.400    5.42  0.314
    m1C: C1          -7.7777 11.1859 -22.8645 18.9619      0.400    5.39  0.314
    m1B: time         0.0435  0.1724  -0.2267  0.3226      0.667    2.23  0.488
    m1B: I(time^2)   -0.0580  0.0699  -0.2295  0.0254      0.267    5.16  0.431
    m1B: b21          1.5298  0.6148   0.8380  2.5305      0.000    2.24  0.482
    m1B: c1          -0.5500  0.2260  -0.9246 -0.1742      0.000    1.02  0.183
    m1B: C1:time      0.1540  0.4601  -0.3303  1.1401      0.933    8.76  0.547
    m1B: b21:c1       1.7680  1.1429  -0.8320  3.3705      0.267    4.39  0.532
    m1C: time        -0.2711  0.3749  -0.8573  0.3060      0.667    6.59  0.480
    m1C: I(time^2)    0.0437  0.0356  -0.0178  0.1178      0.200    1.50  0.183
    m1C: b21          1.6990  0.7201   0.4064  2.7387      0.000    2.33  0.495
    m1C: c1          -0.2789  0.2230  -0.6083  0.0699      0.333    2.13  0.183
    m1C: C1:time     -0.3305  0.4269  -1.0026  0.3339      0.600    3.66  0.533
    m1C: b21:c1       1.4021  1.2293  -1.0624  3.0835      0.267    4.44  0.363
    
    Posterior summary of random effects covariance matrix:
                    Mean     SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1]  0.4623 0.1330  0.242 0.717               4.48  0.491
    D_m1_id[1,2] -0.0608 0.0668 -0.202 0.046      0.333    2.66  0.216
    D_m1_id[2,2]  0.4182 0.0799  0.302 0.576               1.15  0.183
    
    
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
                         Mean      SD     2.5%   97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)  1.37991  7.8007 -12.4010 15.1749      1.000   1.615 0.2256
    m1B: C1          -1.75843 10.6043 -20.6439 16.2872      0.933   1.568 0.2255
    m1C: (Intercept)  6.92852  5.0573  -2.3850 13.4447      0.267   2.214 0.1826
    m1C: C1          -9.31407  6.9575 -18.4255  3.4881      0.267   2.081 0.1826
    m1B: log(time)    0.02258  0.0768  -0.0854  0.1739      0.733   1.303 0.1826
    m1B: I(time^2)   -0.00258  0.0153  -0.0291  0.0291      0.800   2.467 0.2734
    m1B: p1           0.00551  0.0665  -0.0995  0.1349      1.000   0.996 0.1826
    m1C: log(time)   -0.04679  0.0851  -0.2031  0.0894      0.533   1.859 0.1826
    m1C: I(time^2)   -0.01253  0.0218  -0.0648  0.0168      0.600   1.879 0.3672
    m1C: p1           0.04175  0.0509  -0.0318  0.1373      0.267   1.511 0.0585
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.16 0.461 0.612  2.05               2.15  0.523
    
    
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
    m1B: (Intercept) 0.2134568 0.1428730 -0.05883779 0.4226392  0.2000000 1.457053
    m1C: (Intercept) 0.1915382 0.1598559 -0.08551998 0.5055687  0.2666667 2.003934
                        MCE/SD
    m1B: (Intercept) 0.1825742
    m1C: (Intercept) 0.2866655
    
    
    $m0b
    $m0b$m2
                          Mean        SD        2.5%     97.5% tail-prob.  GR-crit
    m2B: (Intercept) 0.4803793 0.2435657 -0.08625171 0.8316464  0.1333333 2.428004
    m2C: (Intercept) 0.2806805 0.2427005 -0.19079819 0.6788190  0.3333333 2.057479
                        MCE/SD
    m2B: (Intercept) 0.1825742
    m2C: (Intercept) 0.3062507
    
    
    $m1a
    $m1a$m1
                          Mean        SD      2.5%     97.5% tail-prob.  GR-crit
    m1B: (Intercept) -4.460411  7.910673 -18.89065  9.200931  0.5333333 1.831294
    m1B: C1           6.295780 10.781186 -12.58078 25.820860  0.5333333 1.819001
    m1C: (Intercept)  2.548215  8.597971 -14.89309 18.153729  0.6000000 1.263724
    m1C: C1          -3.292802 11.744454 -24.57747 20.461066  0.6000000 1.261771
                        MCE/SD
    m1B: (Intercept) 0.3119004
    m1B: C1          0.3129319
    m1C: (Intercept) 0.2362497
    m1C: C1          0.2368311
    
    
    $m1b
    $m1b$m2
                            Mean       SD      2.5%    97.5% tail-prob.  GR-crit
    m2B: (Intercept)  11.4091472 19.72012 -33.31016 34.54844  0.4000000 4.226908
    m2B: C1          -15.0472987 26.55602 -46.05799 45.20189  0.4000000 4.184453
    m2C: (Intercept)   0.7236093 22.28488 -43.14191 32.64828  0.6666667 4.002013
    m2C: C1           -0.8215340 30.04908 -43.93039 58.29021  0.6666667 3.986458
                        MCE/SD
    m2B: (Intercept) 0.6048319
    m2B: C1          0.6023127
    m2C: (Intercept) 0.5656667
    m2C: C1          0.5646649
    
    
    $m1c
    $m1c$m1
                           Mean        SD       2.5%       97.5% tail-prob.
    m1B: (Intercept)  0.3943436 0.1880474  0.0666733  0.71368955 0.06666667
    m1C: (Intercept)  0.2836212 0.2256643 -0.1473671  0.61752567 0.20000000
    m1B: c1          -0.4328542 0.2299830 -0.8076548 -0.07302861 0.00000000
    m1C: c1          -0.1852188 0.2162430 -0.5407608  0.24302367 0.46666667
                       GR-crit    MCE/SD
    m1B: (Intercept) 1.2454316 0.1476000
    m1C: (Intercept) 1.2828622 0.1825742
    m1B: c1          1.0733774 0.2275812
    m1C: c1          0.9816212 0.1825742
    
    
    $m1d
    $m1d$m2
                           Mean        SD        2.5%     97.5% tail-prob.  GR-crit
    m2B: (Intercept) 0.28702380 0.2294196 -0.04555777 0.6759814  0.2000000 1.334335
    m2C: (Intercept) 0.06599654 0.2376032 -0.26958738 0.5537672  0.8000000 1.500449
    m2B: c1          0.13348918 0.2425540 -0.32192147 0.5661100  0.5333333 1.337400
    m2C: c1          0.05273593 0.2431617 -0.40457429 0.4149541  0.9333333 1.200776
                         MCE/SD
    m2B: (Intercept) 0.26964227
    m2C: (Intercept)         NA
    m2B: c1          0.05483638
    m2C: c1          0.18257419
    
    
    $m2a
    $m2a$m1
                           Mean        SD       2.5%      97.5% tail-prob.  GR-crit
    m1B: (Intercept) -0.1378920 0.2715344 -0.5888443  0.4137167  0.4000000 2.082574
    m1B: C2          -0.5446117 0.2528553 -0.9418972 -0.1556413  0.0000000 1.821298
    m1C: (Intercept) -0.3633568 0.2339067 -0.7542115  0.1085512  0.1333333 2.282468
    m1C: C2          -0.8471287 0.2463876 -1.2354564 -0.3765900  0.0000000 1.421205
                        MCE/SD
    m1B: (Intercept) 0.2068680
    m1B: C2          0.2260827
    m1C: (Intercept) 0.3068264
    m1C: C2          0.2491826
    
    
    $m2b
    $m2b$m2
                          Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    m2B: (Intercept) 0.6954069 0.2691517  0.3139296 1.1484155  0.0000000 4.641735
    m2B: C2          0.3026038 0.4005369 -0.3094379 0.9550367  0.5333333 3.123778
    m2C: (Intercept) 0.5504035 0.2929517  0.1025895 0.9953817  0.0000000 4.885989
    m2C: C2          0.3867606 0.4018054 -0.2260534 1.0448086  0.4666667 3.807970
                        MCE/SD
    m2B: (Intercept) 0.5238946
    m2B: C2          0.5220463
    m2C: (Intercept) 0.4748737
    m2C: C2          0.5125329
    
    
    $m2c
    $m2c$m1
                           Mean        SD       2.5%      97.5% tail-prob.  GR-crit
    m1B: (Intercept) -0.2648247 0.3461285 -0.7177495  0.5376011  0.4000000 1.392967
    m1C: (Intercept) -0.1748987 0.4959628 -1.1671227  0.7433323  0.6666667 1.229592
    m1B: c2          -2.1154723 0.7825846 -3.1694752 -0.6781467  0.0000000 1.289536
    m1C: c2          -1.7803501 1.5378894 -4.8036637  0.4169312  0.2000000 2.001003
                        MCE/SD
    m1B: (Intercept) 0.3454386
    m1C: (Intercept) 0.2496251
    m1B: c2          0.3288860
    m1C: c2          0.1843788
    
    
    $m2d
    $m2d$m2
                           Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    m2B: (Intercept)  0.1283168 0.3651912 -0.6377134 0.7269308  0.6666667 2.845362
    m2C: (Intercept)  0.2276781 0.3424977 -0.3685870 0.7527052  0.4666667 1.717969
    m2B: c2          -2.2043560 1.5635941 -4.7816579 0.3845351  0.2000000 3.418224
    m2C: c2          -0.9082660 1.8288109 -4.2400328 1.6871222  0.8000000 5.225535
                        MCE/SD
    m2B: (Intercept) 0.3086043
    m2C: (Intercept) 0.2876351
    m2B: c2          0.5176054
    m2C: c2          0.3243675
    
    
    $m3a
    $m3a$c1
                       Mean          SD         2.5%      97.5% tail-prob.  GR-crit
    (Intercept) -7.65134105 28.84935570 -109.5248893 5.44977184  0.3333333 1.160405
    m1B         -0.19155102  0.11754870   -0.3774982 0.05359981  0.1333333 1.891585
    m1C         -0.08385104  0.07902884   -0.2645915 0.02634624  0.2666667 1.626106
                   MCE/SD
    (Intercept) 0.1825742
    m1B         0.2285854
    m1C         0.1825742
    
    
    $m3b
    $m3b$c1
                        Mean         SD       2.5%     97.5% tail-prob.  GR-crit
    (Intercept)  0.256268417 0.07464901  0.1140349 0.3996927  0.0000000 2.303621
    m2B         -0.005718371 0.07414596 -0.1288669 0.1270185  0.8666667 1.424602
    m2C         -0.008381051 0.10994441 -0.1722801 0.1625559  1.0000000 4.973207
                   MCE/SD
    (Intercept) 0.4575737
    m2B         0.3291948
    m2C         0.5309403
    
    
    $m4a
    $m4a$m1
                                  Mean        SD         2.5%      97.5% tail-prob.
    m1B: (Intercept)       -2.69328178 3.0806805  -7.24364598  3.3548663  0.4000000
    m1B: M22                0.27790225 0.3777826  -0.42087360  1.0532547  0.3333333
    m1B: M23                0.13890779 0.7651724  -0.72833739  1.8564907  0.7333333
    m1B: M24               -0.14662896 0.7540614  -1.57922507  0.9033199  0.8000000
    m1B: abs(C1 - C2)       0.55586893 0.4302122   0.03671169  1.3736111  0.0000000
    m1B: log(C1)           -5.84856927 9.7057003 -22.01178417 11.5188902  0.5333333
    m1C: (Intercept)       -4.39333003 3.0479902  -8.83565014  1.2440537  0.2000000
    m1C: M22                0.16949385 0.4700587  -0.79050352  0.8559679  0.7333333
    m1C: M23               -0.27709030 0.6663633  -1.32692391  0.7307407  0.8666667
    m1C: M24               -0.10819650 0.5402415  -0.95725060  0.8222153  0.8666667
    m1C: abs(C1 - C2)       0.65570101 0.5316238  -0.15556024  1.4555158  0.2000000
    m1C: log(C1)          -11.48458815 9.3016699 -26.87520707  3.4550832  0.2000000
    m1B: m2B                0.86631046 0.3403210   0.30887908  1.4287173  0.0000000
    m1B: m2C                0.15429005 0.5828779  -0.87488552  1.1415080  0.8666667
    m1B: m2B:abs(C1 - C2)  -0.24242649 0.2503049  -0.58182175  0.2862264  0.2666667
    m1B: m2C:abs(C1 - C2)   0.14384443 0.4530230  -0.67231386  0.7580777  0.7333333
    m1C: m2B               -0.07526408 0.3771756  -0.55863376  0.6519168  0.7333333
    m1C: m2C               -0.07605866 1.0273183  -2.02687355  1.4017999  0.7333333
    m1C: m2B:abs(C1 - C2)   0.25414451 0.4203616  -0.36852040  0.8924479  0.6000000
    m1C: m2C:abs(C1 - C2)   0.40934592 0.5260004  -0.17034063  1.5241583  0.5333333
                           GR-crit    MCE/SD
    m1B: (Intercept)      1.599770 0.3353466
    m1B: M22              3.469084 0.5096380
    m1B: M23              6.157970 0.3049130
    m1B: M24              3.365807 0.4006419
    m1B: abs(C1 - C2)     2.056214 0.3138557
    m1B: log(C1)          2.061041 0.4046517
    m1C: (Intercept)      2.417626 0.3930447
    m1C: M22              3.324196 0.4178940
    m1C: M23              8.232233 0.3865132
    m1C: M24              2.686644 0.3549840
    m1C: abs(C1 - C2)     2.813626 0.4888564
    m1C: log(C1)          2.868874 0.4130943
    m1B: m2B              4.475368 0.5787679
    m1B: m2C              2.530253 0.3991178
    m1B: m2B:abs(C1 - C2) 2.068491 0.3814064
    m1B: m2C:abs(C1 - C2) 3.250685 0.5893527
    m1C: m2B              3.427370 0.4749402
    m1C: m2C              8.664997 0.3924660
    m1C: m2B:abs(C1 - C2) 3.715774 0.4969286
    m1C: m2C:abs(C1 - C2) 5.286565 0.7268753
    
    
    $m4b
    $m4b$m1
                                                                           Mean
    m1B: (Intercept)                                                 -2.3215556
    m1B: abs(C1 - C2)                                                 0.6863851
    m1B: log(C1)                                                     -5.5182719
    m1C: (Intercept)                                                 -4.9699163
    m1C: abs(C1 - C2)                                                 0.8988009
    m1C: log(C1)                                                    -12.9193269
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.4526902
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)   0.3855537
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.2313924
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)   0.3734426
                                                                            SD
    m1B: (Intercept)                                                 3.3403967
    m1B: abs(C1 - C2)                                                0.6281151
    m1B: log(C1)                                                    10.4600533
    m1C: (Intercept)                                                 3.0046142
    m1C: abs(C1 - C2)                                                0.5589637
    m1C: log(C1)                                                     9.0425112
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.9148654
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.5704674
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.8611440
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.7354362
                                                                           2.5%
    m1B: (Intercept)                                                 -7.5974270
    m1B: abs(C1 - C2)                                                -0.1391450
    m1B: log(C1)                                                    -24.6170293
    m1C: (Intercept)                                                 -9.4629073
    m1C: abs(C1 - C2)                                                 0.1606495
    m1C: log(C1)                                                    -26.2078596
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -2.1141114
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.3031152
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -1.3268226
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -1.3754496
                                                                         97.5%
    m1B: (Intercept)                                                 5.1281346
    m1B: abs(C1 - C2)                                                1.8252259
    m1B: log(C1)                                                    15.5380685
    m1C: (Intercept)                                                 0.2677391
    m1C: abs(C1 - C2)                                                1.7946637
    m1C: log(C1)                                                     2.0906564
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.7558092
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  1.5959033
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               1.6676514
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  1.2400258
                                                                    tail-prob.
    m1B: (Intercept)                                                 0.4666667
    m1B: abs(C1 - C2)                                                0.1333333
    m1B: log(C1)                                                     0.6666667
    m1C: (Intercept)                                                 0.1333333
    m1C: abs(C1 - C2)                                                0.0000000
    m1C: log(C1)                                                     0.2000000
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.7333333
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.4666667
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.6666667
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.6000000
                                                                     GR-crit
    m1B: (Intercept)                                                2.737225
    m1B: abs(C1 - C2)                                               8.166169
    m1B: log(C1)                                                    2.414324
    m1C: (Intercept)                                                3.184689
    m1C: abs(C1 - C2)                                               5.355492
    m1C: log(C1)                                                    2.781629
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              8.595361
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 7.076182
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              4.950592
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 5.774167
                                                                       MCE/SD
    m1B: (Intercept)                                                0.1825742
    m1B: abs(C1 - C2)                                               0.5645171
    m1B: log(C1)                                                    0.3924501
    m1C: (Intercept)                                                0.4488021
    m1C: abs(C1 - C2)                                               0.4459135
    m1C: log(C1)                                                    0.3337538
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.6432505
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.8660430
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.5281793
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.5865974
    
    
    $m4c
    $m4c$m1
                            Mean          SD        2.5%       97.5% tail-prob.
    m1B: (Intercept) -1.56662425  6.94549756 -11.7415999 10.05920199 0.73333333
    m1B: C1           2.97615072  9.43265728 -13.1022359 16.21791928 0.66666667
    m1B: B21         -0.27324468  0.14472238  -0.5065424  0.01855280 0.13333333
    m1C: (Intercept)  1.07598828  7.44426508 -11.6730749 13.54546944 0.86666667
    m1C: C1          -0.74338257 10.12050897 -18.3029556 16.73805806 1.00000000
    m1C: B21          0.15888014  0.24615964  -0.3594743  0.49451182 0.46666667
    m1B: time        -0.06532383  0.09927709  -0.2419525  0.08899085 0.46666667
    m1B: c1          -0.38076701  0.19784584  -0.6767125 -0.02919670 0.06666667
    m1C: time        -0.22156015  0.08928132  -0.3533923 -0.06003064 0.00000000
    m1C: c1          -0.13524329  0.24546672  -0.5334953  0.36467164 0.60000000
                       GR-crit    MCE/SD
    m1B: (Intercept) 2.5282935 0.1825742
    m1B: C1          2.6151619 0.3499912
    m1B: B21         1.5977606 0.3701273
    m1C: (Intercept) 2.4776194 0.2092788
    m1C: C1          2.4345771 0.2096040
    m1C: B21         3.2947157 0.5676426
    m1B: time        0.9820564 0.1825742
    m1B: c1          1.4773251 0.1921727
    m1C: time        1.0684164 0.1825742
    m1C: c1          1.5653186 0.2132290
    
    
    $m4d
    $m4d$m1
                            Mean          SD         2.5%       97.5% tail-prob.
    m1B: (Intercept) -0.08892778  7.16216069 -16.57079950  9.92269421  0.7333333
    m1B: C1           0.32658039  9.50034209 -13.26953395 22.04056754  0.7333333
    m1C: (Intercept)  6.60840429  8.30496933 -13.32861641 17.95646232  0.4000000
    m1C: C1          -7.77770444 11.18591663 -22.86452398 18.96194383  0.4000000
    m1B: time         0.04346155  0.17244568  -0.22665752  0.32261305  0.6666667
    m1B: I(time^2)   -0.05803078  0.06993815  -0.22947855  0.02538569  0.2666667
    m1B: b21          1.52982311  0.61478276   0.83801420  2.53054953  0.0000000
    m1B: c1          -0.55002396  0.22599749  -0.92463401 -0.17421097  0.0000000
    m1B: C1:time      0.15402668  0.46010932  -0.33031099  1.14005595  0.9333333
    m1B: b21:c1       1.76800932  1.14289949  -0.83198652  3.37046977  0.2666667
    m1C: time        -0.27112268  0.37494696  -0.85730489  0.30598963  0.6666667
    m1C: I(time^2)    0.04368937  0.03561643  -0.01782382  0.11780504  0.2000000
    m1C: b21          1.69899451  0.72009361   0.40641490  2.73871289  0.0000000
    m1C: c1          -0.27892360  0.22298412  -0.60828182  0.06993293  0.3333333
    m1C: C1:time     -0.33053091  0.42691812  -1.00262101  0.33387150  0.6000000
    m1C: b21:c1       1.40209203  1.22931926  -1.06235770  3.08345854  0.2666667
                      GR-crit    MCE/SD
    m1B: (Intercept) 3.035584 0.2698111
    m1B: C1          2.897871 0.2673387
    m1C: (Intercept) 5.416737 0.3143725
    m1C: C1          5.394997 0.3143258
    m1B: time        2.233023 0.4876410
    m1B: I(time^2)   5.161997 0.4311089
    m1B: b21         2.241633 0.4822868
    m1B: c1          1.018532 0.1825742
    m1B: C1:time     8.757586 0.5470045
    m1B: b21:c1      4.393649 0.5315237
    m1C: time        6.589018 0.4798151
    m1C: I(time^2)   1.497486 0.1825742
    m1C: b21         2.332789 0.4951648
    m1C: c1          2.129445 0.1825742
    m1C: C1:time     3.662748 0.5330429
    m1C: b21:c1      4.437777 0.3628411
    
    
    $m4e
    $m4e$m1
                             Mean          SD         2.5%       97.5% tail-prob.
    m1B: (Intercept)  1.379913136  7.80067487 -12.40096601 15.17490204  1.0000000
    m1B: C1          -1.758428429 10.60430301 -20.64386081 16.28718431  0.9333333
    m1C: (Intercept)  6.928515554  5.05726945  -2.38499933 13.44472460  0.2666667
    m1C: C1          -9.314069664  6.95753062 -18.42554483  3.48805177  0.2666667
    m1B: log(time)    0.022577737  0.07684870  -0.08541225  0.17385232  0.7333333
    m1B: I(time^2)   -0.002576087  0.01533586  -0.02908535  0.02914760  0.8000000
    m1B: p1           0.005513385  0.06650508  -0.09950188  0.13494468  1.0000000
    m1C: log(time)   -0.046787732  0.08509822  -0.20311064  0.08942260  0.5333333
    m1C: I(time^2)   -0.012530934  0.02178244  -0.06482137  0.01681061  0.6000000
    m1C: p1           0.041754594  0.05085587  -0.03176287  0.13733615  0.2666667
                       GR-crit     MCE/SD
    m1B: (Intercept) 1.6147473 0.22563994
    m1B: C1          1.5676335 0.22553560
    m1C: (Intercept) 2.2135310 0.18257419
    m1C: C1          2.0810579 0.18257419
    m1B: log(time)   1.3031612 0.18257419
    m1B: I(time^2)   2.4671040 0.27339122
    m1B: p1          0.9961837 0.18257419
    m1C: log(time)   1.8588938 0.18257419
    m1C: I(time^2)   1.8788699 0.36721051
    m1C: p1          1.5110847 0.05851246
    
    

