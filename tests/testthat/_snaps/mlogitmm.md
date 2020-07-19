# GRcrit and MCerror give same result

    $m0a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)      1.080       1.38
    m1C: (Intercept)      0.972       1.05
    D_m1_id[1,1]          1.715       2.82
    
    
    $m0b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       1.17       1.72
    m2C: (Intercept)       1.05       1.30
    D_m2_id[1,1]           1.37       3.33
    
    
    $m1a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.98       3.58
    m1B: C1                1.90       3.40
    m1C: (Intercept)       1.31       2.09
    m1C: C1                1.27       1.98
    D_m1_id[1,1]           3.62       9.20
    
    
    $m1b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       2.09       5.31
    m2B: C1                2.07       5.22
    m2C: (Intercept)       1.89       3.34
    m2C: C1                1.85       3.26
    D_m2_id[1,1]           1.10       1.40
    
    
    $m1c
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.14       1.54
    m1C: (Intercept)       1.22       1.77
    m1B: c1                1.12       1.50
    m1C: c1                1.37       2.25
    D_m1_id[1,1]           3.55       9.70
    
    
    $m1d
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       1.65       2.78
    m2C: (Intercept)       1.35       2.16
    m2B: c1                1.08       1.37
    m2C: c1                1.01       1.15
    D_m2_id[1,1]           1.08       1.41
    
    
    $m2a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)      0.984       1.08
    m1B: C2               2.284       4.22
    m1C: (Intercept)      1.113       1.54
    m1C: C2               2.659       8.21
    D_m1_id[1,1]          1.286       2.46
    
    
    $m2b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)      0.981       1.10
    m2B: C2               2.866       5.33
    m2C: (Intercept)      1.233       2.05
    m2C: C2               4.015       9.24
    D_m2_id[1,1]          2.893       6.70
    
    
    $m2c
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.18       1.88
    m1C: (Intercept)       1.26       2.08
    m1B: c2                1.26       2.35
    m1C: c2                1.33       2.15
    D_m1_id[1,1]           1.26       1.93
    
    
    $m2d
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       3.86       8.59
    m2C: (Intercept)       3.49       6.57
    m2B: c2                4.61      11.59
    m2C: c2                3.42       6.94
    D_m2_id[1,1]           2.97       5.44
    
    
    $m3a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    (Intercept)        4.80      11.81
    m1B                1.64       4.26
    m1C                1.26       2.13
    sigma_c1           1.02       1.30
    D_c1_id[1,1]       1.28       1.92
    
    
    $m3b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    (Intercept)        1.46       2.59
    m2B                1.31       1.95
    m2C                2.28       3.99
    sigma_c1           1.29       1.95
    D_c1_id[1,1]       1.44       2.32
    
    
    $m4a
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    m1B: (Intercept)            1.40       2.94
    m1B: M22                    3.62       9.18
    m1B: M23                    1.06       1.36
    m1B: M24                    1.33       2.31
    m1B: abs(C1 - C2)           2.40       4.44
    m1B: log(C1)                1.17       1.99
    m1C: (Intercept)            2.26       4.20
    m1C: M22                    4.78       9.51
    m1C: M23                    2.14       4.17
    m1C: M24                    2.29       4.62
    m1C: abs(C1 - C2)           1.65       2.80
    m1C: log(C1)                1.54       2.59
    m1B: m2B                    4.48       8.48
    m1B: m2C                    1.60       2.59
    m1B: m2B:abs(C1 - C2)       4.03      10.53
    m1B: m2C:abs(C1 - C2)       1.37       2.14
    m1C: m2B                    3.13       5.94
    m1C: m2C                    1.27       1.83
    m1C: m2B:abs(C1 - C2)       3.19       6.16
    m1C: m2C:abs(C1 - C2)       2.35       6.68
    D_m1_id[1,1]                2.02       3.94
    
    
    $m4b
    Potential scale reduction factors:
    
                                                                    Point est.
    m1B: (Intercept)                                                      4.05
    m1B: abs(C1 - C2)                                                     2.55
    m1B: log(C1)                                                          4.56
    m1C: (Intercept)                                                      3.83
    m1C: abs(C1 - C2)                                                     2.74
    m1C: log(C1)                                                          3.55
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                    3.78
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)       4.76
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                    5.49
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)       2.62
    D_m1_id[1,1]                                                          2.50
                                                                    Upper C.I.
    m1B: (Intercept)                                                      8.42
    m1B: abs(C1 - C2)                                                     5.67
    m1B: log(C1)                                                          9.65
    m1C: (Intercept)                                                      9.44
    m1C: abs(C1 - C2)                                                     4.98
    m1C: log(C1)                                                          7.40
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                    7.96
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)      10.16
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                   11.12
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)       4.86
    D_m1_id[1,1]                                                          6.19
    
    
    $m4c
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.51       2.53
    m1B: C1                1.47       2.46
    m1B: B21               5.68      11.43
    m1C: (Intercept)       1.17       1.88
    m1C: C1                1.15       1.74
    m1C: B21               2.58       4.79
    m1B: time              1.39       2.20
    m1B: c1                1.12       1.54
    m1C: time              1.59       2.69
    m1C: c1                1.08       1.36
    D_m1_id[1,1]           2.25       4.58
    D_m1_id[1,2]           1.29       2.30
    D_m1_id[2,2]           4.58      11.17
    D_m1_id[1,3]           4.20      13.14
    D_m1_id[2,3]           1.39       3.05
    D_m1_id[3,3]           5.82      18.48
    D_m1_id[1,4]           3.69       7.79
    D_m1_id[2,4]           2.25       4.20
    D_m1_id[3,4]           5.26      15.40
    D_m1_id[4,4]           3.58       7.07
    
    
    $m4d
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       2.25       4.03
    m1B: C1                2.21       3.94
    m1C: (Intercept)       1.89       3.39
    m1C: C1                1.78       3.18
    m1B: time              2.64       5.08
    m1B: I(time^2)         4.65      14.18
    m1B: b21               1.49       2.52
    m1B: c1                1.03       1.25
    m1B: C1:time           4.02       9.48
    m1B: b21:c1            1.34       2.29
    m1C: time              2.74       6.90
    m1C: I(time^2)         3.83       8.08
    m1C: b21               2.13       4.24
    m1C: c1                1.08       1.36
    m1C: C1:time           2.75       5.26
    m1C: b21:c1            1.05       1.26
    D_m1_id[1,1]           1.69       5.02
    D_m1_id[1,2]           3.62       9.75
    D_m1_id[2,2]           3.80       7.50
    
    
    $m4e
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.55       2.69
    m1B: C1                1.56       2.73
    m1C: (Intercept)       1.53       2.60
    m1C: C1                1.55       2.61
    m1B: log(time)         1.02       1.19
    m1B: I(time^2)         1.25       2.11
    m1B: p1                1.01       1.16
    m1C: log(time)         1.05       1.20
    m1C: I(time^2)         1.02       1.22
    m1C: p1                1.01       1.09
    D_m1_id[1,1]           3.83       8.79
    
    

---

    $m0a
                      est  MCSE   SD MCSE/SD
    m1B: (Intercept) 0.41 0.044 0.19    0.23
    m1C: (Intercept) 0.39 0.051 0.16    0.33
    D_m1_id[1,1]     1.93 0.244 0.74    0.33
    
    $m0b
                         est  MCSE   SD MCSE/SD
    m2B: (Intercept) -0.0017 0.039 0.21    0.18
    m2C: (Intercept) -0.0040 0.035 0.16    0.22
    D_m2_id[1,1]      1.4341 0.160 0.55    0.29
    
    $m1a
                      est MCSE   SD MCSE/SD
    m1B: (Intercept) -7.0 2.95  7.5    0.39
    m1B: C1           9.8 3.89 10.0    0.39
    m1C: (Intercept) -3.4 2.74  7.8    0.35
    m1C: C1           5.0 3.63 10.5    0.35
    D_m1_id[1,1]      1.6 0.46  1.0    0.46
    
    $m1b
                      est MCSE    SD MCSE/SD
    m2B: (Intercept)  4.2 4.87 12.52    0.39
    m2B: C1          -5.6 6.49 16.80    0.39
    m2C: (Intercept) -2.6 3.51 10.43    0.34
    m2C: C1           3.6 4.66 13.98    0.33
    D_m2_id[1,1]      1.7 0.11  0.48    0.24
    
    $m1c
                       est  MCSE   SD MCSE/SD
    m1B: (Intercept)  0.33 0.047 0.17    0.27
    m1C: (Intercept)  0.40 0.030 0.21    0.15
    m1B: c1           0.20 0.034 0.19    0.18
    m1C: c1          -0.07 0.045 0.25    0.18
    D_m1_id[1,1]      1.65 0.313 0.95    0.33
    
    $m1d
                        est  MCSE   SD MCSE/SD
    m2B: (Intercept)  0.174 0.070 0.20    0.36
    m2C: (Intercept)  0.071 0.035 0.17    0.21
    m2B: c1          -0.402 0.039 0.18    0.22
    m2C: c1          -0.144 0.040 0.22    0.18
    D_m2_id[1,1]      1.714 0.183 0.59    0.31
    
    $m2a
                      est MCSE   SD MCSE/SD
    m1B: (Intercept) 0.45 0.11 0.25    0.44
    m1B: C2          0.31 0.12 0.29    0.41
    m1C: (Intercept) 0.54 0.13 0.27    0.49
    m1C: C2          0.54 0.12 0.27    0.46
    D_m1_id[1,1]     1.87 0.20 0.67    0.30
    
    $m2b
                        est  MCSE   SD MCSE/SD
    m2B: (Intercept)  0.185 0.048 0.23    0.21
    m2B: C2           0.068 0.122 0.33    0.37
    m2C: (Intercept)  0.018 0.112 0.26    0.43
    m2C: C2          -0.136 0.216 0.45    0.49
    D_m2_id[1,1]      1.788 0.434 0.88    0.50
    
    $m2c
                        est  MCSE   SD MCSE/SD
    m1B: (Intercept)  0.055 0.140 0.36    0.39
    m1C: (Intercept) -0.024 0.082 0.35    0.23
    m1B: c2          -1.189 0.240 1.31    0.18
    m1C: c2          -1.480 0.339 1.31    0.26
    D_m1_id[1,1]      1.869 0.114 0.47    0.24
    
    $m2d
                        est MCSE   SD MCSE/SD
    m2B: (Intercept)  0.069 0.25 0.67    0.38
    m2C: (Intercept)  0.095 0.22 0.58    0.37
    m2B: c2          -0.504 1.36 2.58    0.53
    m2C: c2          -0.200 1.18 2.36    0.50
    D_m2_id[1,1]      2.408 0.55 1.00    0.54
    
    $m3a
                     est    MCSE      SD MCSE/SD
    (Intercept)   -7.661 5.3e+00 2.9e+01    0.18
    m1B           -0.073 2.0e-02 9.5e-02    0.21
    m1C           -0.142 3.2e-02 9.7e-02    0.33
    sigma_c1       0.654 9.8e-03 4.4e-02    0.22
    D_c1_id[1,1] 863.159 5.8e+02 3.2e+03    0.18
    
    $m3b
                    est   MCSE    SD MCSE/SD
    (Intercept)   0.307 0.0287 0.064    0.45
    m2B          -0.150 0.0140 0.077    0.18
    m2C          -0.052 0.0309 0.095    0.33
    sigma_c1      0.618 0.0051 0.028    0.18
    D_c1_id[1,1]  0.092 0.0086 0.032    0.27
    
    $m4a
                             est  MCSE   SD MCSE/SD
    m1B: (Intercept)      -0.350 0.357 2.23    0.16
    m1B: M22               0.075 0.190 0.55    0.35
    m1B: M23              -0.334 0.198 0.47    0.42
    m1B: M24               0.811 0.099 0.33    0.30
    m1B: abs(C1 - C2)      0.276 0.102 0.35    0.29
    m1B: log(C1)          -1.658 2.013 6.51    0.31
    m1C: (Intercept)      -1.370 0.503 2.22    0.23
    m1C: M22               0.130 0.301 0.63    0.48
    m1C: M23              -0.301 0.163 0.52    0.31
    m1C: M24               0.485 0.266 0.49    0.54
    m1C: abs(C1 - C2)     -0.092 0.149 0.36    0.41
    m1C: log(C1)          -6.431 1.217 6.67    0.18
    m1B: m2B               0.330 0.568 0.69    0.83
    m1B: m2C              -0.343 0.161 0.34    0.47
    m1B: m2B:abs(C1 - C2) -0.614 0.343 0.51    0.68
    m1B: m2C:abs(C1 - C2) -0.066 0.053 0.23    0.23
    m1C: m2B               0.561 0.255 0.47    0.54
    m1C: m2C              -0.635 0.142 0.49    0.29
    m1C: m2B:abs(C1 - C2) -0.745 0.195 0.43    0.46
    m1C: m2C:abs(C1 - C2)  0.309 0.130 0.32    0.40
    D_m1_id[1,1]           2.564 0.487 0.96    0.51
    
    $m4b
                                                                       est MCSE
    m1B: (Intercept)                                                 5.312 2.42
    m1B: abs(C1 - C2)                                               -0.266 0.28
    m1B: log(C1)                                                    14.898 6.45
    m1C: (Intercept)                                                 3.955 0.71
    m1C: abs(C1 - C2)                                               -0.263 0.21
    m1C: log(C1)                                                    10.669 4.36
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.032 0.37
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.140 0.23
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.019 0.56
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.029 0.42
    D_m1_id[1,1]                                                     1.960 0.28
                                                                       SD MCSE/SD
    m1B: (Intercept)                                                 4.26    0.57
    m1B: abs(C1 - C2)                                                0.56    0.51
    m1B: log(C1)                                                    12.33    0.52
    m1C: (Intercept)                                                 3.86    0.18
    m1C: abs(C1 - C2)                                                0.45    0.46
    m1C: log(C1)                                                    11.50    0.38
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.85    0.44
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.47    0.49
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.98    0.57
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.60    0.70
    D_m1_id[1,1]                                                     0.65    0.44
    
    $m4c
                         est   MCSE     SD MCSE/SD
    m1B: (Intercept) -3.5789 1.8732  7.839   0.239
    m1B: C1           4.8860 1.9180 10.505   0.183
    m1B: B21          0.4280 0.2405  0.386   0.624
    m1C: (Intercept)  0.7666 0.6274  7.505   0.084
    m1C: C1          -1.4208 0.8731 10.045   0.087
    m1C: B21          0.3878 0.1721  0.324   0.531
    m1B: time        -0.0919 0.0285  0.097   0.293
    m1B: c1           0.2524 0.0340  0.176   0.193
    m1C: time         0.0500 0.0228  0.105   0.218
    m1C: c1          -0.0057 0.0304  0.167   0.183
    D_m1_id[1,1]      0.2395 0.0195  0.107   0.183
    D_m1_id[1,2]     -0.0187 0.0057  0.031   0.183
    D_m1_id[2,2]      0.1928 0.0824  0.096   0.859
    D_m1_id[1,3]     -0.0497 0.0813  0.093   0.872
    D_m1_id[2,3]      0.0531 0.0248  0.049   0.508
    D_m1_id[3,3]      0.2693 0.1239  0.172   0.722
    D_m1_id[1,4]     -0.0154 0.0418  0.079   0.530
    D_m1_id[2,4]      0.0242 0.0137  0.039   0.352
    D_m1_id[3,4]      0.0813 0.0597  0.123   0.487
    D_m1_id[4,4]      0.3134 0.0361  0.095   0.379
    
    $m4d
                        est  MCSE     SD MCSE/SD
    m1B: (Intercept) -4.412   Inf  8.041     Inf
    m1B: C1           6.773   Inf 10.707     Inf
    m1C: (Intercept)  0.859 4.538 10.885    0.42
    m1C: C1          -0.712 6.019 14.600    0.41
    m1B: time        -0.177 0.151  0.322    0.47
    m1B: I(time^2)    0.027 0.036  0.044    0.81
    m1B: b21         -0.886 0.091  0.385    0.24
    m1B: c1          -0.141 0.039  0.212    0.18
    m1B: C1:time     -0.060 0.148  0.501    0.29
    m1B: b21:c1       2.695 0.278  0.859    0.32
    m1C: time         0.067 0.075  0.211    0.36
    m1C: I(time^2)    0.045 0.037  0.073    0.50
    m1C: b21         -0.621 0.226  0.520    0.44
    m1C: c1          -0.242 0.054  0.248    0.22
    m1C: C1:time     -0.318 0.232  0.357    0.65
    m1C: b21:c1       1.051 0.312  0.981    0.32
    D_m1_id[1,1]      0.624 0.043  0.183    0.23
    D_m1_id[1,2]     -0.091 0.082  0.156    0.53
    D_m1_id[2,2]      0.326 0.056  0.112    0.50
    
    $m4e
                         est   MCSE     SD MCSE/SD
    m1B: (Intercept) -7.4621 4.1308  9.609    0.43
    m1B: C1          10.3895 5.5815 12.974    0.43
    m1C: (Intercept) -4.8724 3.9836  9.346    0.43
    m1C: C1           6.8285 5.4321 12.719    0.43
    m1B: log(time)   -0.0451 0.0200  0.110    0.18
    m1B: I(time^2)   -0.0082 0.0033  0.018    0.18
    m1B: p1           0.0020 0.0143  0.067    0.22
    m1C: log(time)   -0.0156 0.0199  0.109    0.18
    m1C: I(time^2)    0.0139 0.0037  0.018    0.21
    m1C: p1          -0.0480 0.0114  0.063    0.18
    D_m1_id[1,1]      1.4317 0.3755  0.673    0.56
    

# summary output remained the same

    
    Call:
    mlogitmm_imp(fixed = m1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept) 
         0.4112      0.3916 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.931
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept) 
      -0.001691   -0.003984 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.434
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
         -6.964       9.837      -3.436       5.026 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.618
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
          4.239      -5.601      -2.573       3.585 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.683
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
        0.33231     0.39789     0.20459    -0.06978 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.653
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
        0.17448     0.07111    -0.40222    -0.14396 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.714
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
         0.4523      0.3104      0.5432      0.5430 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.873
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
        0.18546     0.06752     0.01784    -0.13621 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.788
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
        0.05469    -0.02392    -1.18889    -1.48018 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.869
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
        0.06884     0.09450    -0.50378    -0.20030 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.408
    
    
    Call:
    lme_imp(fixed = c1 ~ m1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m1B         m1C 
       -7.66092    -0.07303    -0.14191 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       863.2
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6542 
    
    Call:
    lme_imp(fixed = c1 ~ m2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m2B         m2C 
         0.3072     -0.1499     -0.0517 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)     0.09176
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6184 
    
    Call:
    mlogitmm_imp(fixed = m1 ~ M2 + m2 * abs(C1 - C2) + log(C1) + 
        (1 | id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
         (Intercept)              M22              M23              M24 
            -0.34955          0.07482         -0.33448          0.81111 
        abs(C1 - C2)          log(C1)      (Intercept)              M22 
             0.27617         -1.65764         -1.36972          0.13040 
                 M23              M24     abs(C1 - C2)          log(C1) 
            -0.30067          0.48533         -0.09221         -6.43062 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
             0.32952         -0.34274         -0.61410         -0.06559 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
             0.56092         -0.63467         -0.74509          0.30918 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.564
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ ifelse(as.numeric(m2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1) + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
                                                   (Intercept) 
                                                       5.31180 
                                                  abs(C1 - C2) 
                                                      -0.26596 
                                                       log(C1) 
                                                      14.89783 
                                                   (Intercept) 
                                                       3.95502 
                                                  abs(C1 - C2) 
                                                      -0.26296 
                                                       log(C1) 
                                                      10.66928 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                       0.03222 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                      -0.14033 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                       0.01904 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                      -0.02876 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.96
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ time + c1 + C1 + B2 + (c1 * time | 
        id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020, 
        warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1         B21 (Intercept)          C1         B21 
      -3.578941    4.885997    0.428013    0.766630   -1.420775    0.387762 
           time          c1        time          c1 
      -0.091861    0.252423    0.050009   -0.005713 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)       c1     time  c1:time
    (Intercept)     0.23949 -0.01869 -0.04974 -0.01538
    c1             -0.01869  0.19278  0.05309  0.02420
    time           -0.04974  0.05309  0.26929  0.08132
    c1:time        -0.01538  0.02420  0.08132  0.31340
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 * time + I(time^2) + b2 * c1, data = longDF, 
        random = ~time | id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1        time   I(time^2) 
       -4.41246     6.77314     0.85852    -0.71169    -0.17686     0.02696 
            b21          c1     C1:time      b21:c1        time   I(time^2) 
       -0.88637    -0.14071    -0.05982     2.69479     0.06687     0.04460 
            b21          c1     C1:time      b21:c1 
       -0.62092    -0.24204    -0.31767     1.05088 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)     time
    (Intercept)     0.62371 -0.09112
    time           -0.09112  0.32555
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + log(time) + I(time^2) + p1, data = longDF, 
        random = ~1 | id, n.adapt = 5, n.iter = 10, shrinkage = "ridge", 
        seed = 2020, parallel = TRUE, n.cores = 2)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1   log(time)   I(time^2) 
      -7.462067   10.389508   -4.872382    6.828512   -0.045068   -0.008174 
             p1   log(time)   I(time^2)          p1 
       0.002008   -0.015644    0.013875   -0.047965 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.432
    
    $m0a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept) 
         0.4112      0.3916 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.931
    
    
    $m0b
    
    Call:
    mlogitmm_imp(fixed = m2 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept) 
      -0.001691   -0.003984 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.434
    
    
    $m1a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
         -6.964       9.837      -3.436       5.026 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.618
    
    
    $m1b
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
          4.239      -5.601      -2.573       3.585 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.683
    
    
    $m1c
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
        0.33231     0.39789     0.20459    -0.06978 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.653
    
    
    $m1d
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
        0.17448     0.07111    -0.40222    -0.14396 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.714
    
    
    $m2a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
         0.4523      0.3104      0.5432      0.5430 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.873
    
    
    $m2b
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
        0.18546     0.06752     0.01784    -0.13621 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.788
    
    
    $m2c
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
        0.05469    -0.02392    -1.18889    -1.48018 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.869
    
    
    $m2d
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
        0.06884     0.09450    -0.50378    -0.20030 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.408
    
    
    $m3a
    
    Call:
    lme_imp(fixed = c1 ~ m1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m1B         m1C 
       -7.66092    -0.07303    -0.14191 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       863.2
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6542 
    
    $m3b
    
    Call:
    lme_imp(fixed = c1 ~ m2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m2B         m2C 
         0.3072     -0.1499     -0.0517 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)     0.09176
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6184 
    
    $m4a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ M2 + m2 * abs(C1 - C2) + log(C1) + 
        (1 | id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
         (Intercept)              M22              M23              M24 
            -0.34955          0.07482         -0.33448          0.81111 
        abs(C1 - C2)          log(C1)      (Intercept)              M22 
             0.27617         -1.65764         -1.36972          0.13040 
                 M23              M24     abs(C1 - C2)          log(C1) 
            -0.30067          0.48533         -0.09221         -6.43062 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
             0.32952         -0.34274         -0.61410         -0.06559 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
             0.56092         -0.63467         -0.74509          0.30918 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.564
    
    
    $m4b
    
    Call:
    mlogitmm_imp(fixed = m1 ~ ifelse(as.numeric(m2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1) + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
                                                   (Intercept) 
                                                       5.31180 
                                                  abs(C1 - C2) 
                                                      -0.26596 
                                                       log(C1) 
                                                      14.89783 
                                                   (Intercept) 
                                                       3.95502 
                                                  abs(C1 - C2) 
                                                      -0.26296 
                                                       log(C1) 
                                                      10.66928 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                       0.03222 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                      -0.14033 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                       0.01904 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                      -0.02876 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.96
    
    
    $m4c
    
    Call:
    mlogitmm_imp(fixed = m1 ~ time + c1 + C1 + B2 + (c1 * time | 
        id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020, 
        warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1         B21 (Intercept)          C1         B21 
      -3.578941    4.885997    0.428013    0.766630   -1.420775    0.387762 
           time          c1        time          c1 
      -0.091861    0.252423    0.050009   -0.005713 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)       c1     time  c1:time
    (Intercept)     0.23949 -0.01869 -0.04974 -0.01538
    c1             -0.01869  0.19278  0.05309  0.02420
    time           -0.04974  0.05309  0.26929  0.08132
    c1:time        -0.01538  0.02420  0.08132  0.31340
    
    
    $m4d
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 * time + I(time^2) + b2 * c1, data = longDF, 
        random = ~time | id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1        time   I(time^2) 
       -4.41246     6.77314     0.85852    -0.71169    -0.17686     0.02696 
            b21          c1     C1:time      b21:c1        time   I(time^2) 
       -0.88637    -0.14071    -0.05982     2.69479     0.06687     0.04460 
            b21          c1     C1:time      b21:c1 
       -0.62092    -0.24204    -0.31767     1.05088 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)     time
    (Intercept)     0.62371 -0.09112
    time           -0.09112  0.32555
    
    
    $m4e
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + log(time) + I(time^2) + p1, data = longDF, 
        random = ~1 | id, n.adapt = 5, n.iter = 10, shrinkage = "ridge", 
        seed = 2020, parallel = TRUE, n.cores = 2)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1   log(time)   I(time^2) 
      -7.462067   10.389508   -4.872382    6.828512   -0.045068   -0.008174 
             p1   log(time)   I(time^2)          p1 
       0.002008   -0.015644    0.013875   -0.047965 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.432
    
    

---

    $m0a
    $m0a$m1
    (Intercept) (Intercept) 
      0.4111954   0.3916108 
    
    
    $m0b
    $m0b$m2
     (Intercept)  (Intercept) 
    -0.001691199 -0.003984227 
    
    
    $m1a
    $m1a$m1
    (Intercept)          C1 (Intercept)          C1 
      -6.964242    9.837394   -3.436172    5.026033 
    
    
    $m1b
    $m1b$m2
    (Intercept)          C1 (Intercept)          C1 
       4.239143   -5.601100   -2.573461    3.584569 
    
    
    $m1c
    $m1c$m1
    (Intercept) (Intercept)          c1          c1 
     0.33230787  0.39788965  0.20459377 -0.06977906 
    
    
    $m1d
    $m1d$m2
    (Intercept) (Intercept)          c1          c1 
     0.17447649  0.07111141 -0.40222150 -0.14396465 
    
    
    $m2a
    $m2a$m1
    (Intercept)          C2 (Intercept)          C2 
      0.4523332   0.3104303   0.5431882   0.5430399 
    
    
    $m2b
    $m2b$m2
    (Intercept)          C2 (Intercept)          C2 
     0.18545716  0.06751862  0.01783536 -0.13620709 
    
    
    $m2c
    $m2c$m1
    (Intercept) (Intercept)          c2          c2 
     0.05469462 -0.02391887 -1.18889343 -1.48017716 
    
    
    $m2d
    $m2d$m2
    (Intercept) (Intercept)          c2          c2 
     0.06884005  0.09450104 -0.50377781 -0.20029846 
    
    
    $m3a
    $m3a$c1
    (Intercept)         m1B         m1C 
    -7.66092103 -0.07303115 -0.14191406 
    
    
    $m3b
    $m3b$c1
    (Intercept)         m2B         m2C 
     0.30716619 -0.14989608 -0.05170018 
    
    
    $m4a
    $m4a$m1
         (Intercept)              M22              M23              M24 
         -0.34954956       0.07482196      -0.33448067       0.81111205 
        abs(C1 - C2)          log(C1)      (Intercept)              M22 
          0.27616703      -1.65763805      -1.36972364       0.13039559 
                 M23              M24     abs(C1 - C2)          log(C1) 
         -0.30067311       0.48533037      -0.09221467      -6.43062118 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
          0.32952211      -0.34273626      -0.61410352      -0.06559019 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
          0.56092013      -0.63467112      -0.74508797       0.30918445 
    
    
    $m4b
    $m4b$m1
                                                   (Intercept) 
                                                    5.31179862 
                                                  abs(C1 - C2) 
                                                   -0.26595715 
                                                       log(C1) 
                                                   14.89783235 
                                                   (Intercept) 
                                                    3.95501617 
                                                  abs(C1 - C2) 
                                                   -0.26296191 
                                                       log(C1) 
                                                   10.66927517 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                    0.03222199 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                   -0.14032670 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                    0.01904377 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                   -0.02875664 
    
    
    $m4c
    $m4c$m1
     (Intercept)           C1          B21  (Intercept)           C1          B21 
    -3.578941344  4.885996667  0.428013031  0.766630087 -1.420775453  0.387761993 
            time           c1         time           c1 
    -0.091861282  0.252422896  0.050008987 -0.005712537 
    
    
    $m4d
    $m4d$m1
    (Intercept)          C1 (Intercept)          C1        time   I(time^2) 
    -4.41245997  6.77313979  0.85851665 -0.71169465 -0.17685615  0.02695698 
            b21          c1     C1:time      b21:c1        time   I(time^2) 
    -0.88637246 -0.14070716 -0.05982384  2.69479054  0.06687124  0.04459811 
            b21          c1     C1:time      b21:c1 
    -0.62091633 -0.24204281 -0.31766766  1.05088231 
    
    
    $m4e
    $m4e$m1
     (Intercept)           C1  (Intercept)           C1    log(time)    I(time^2) 
    -7.462067327 10.389507537 -4.872381875  6.828512025 -0.045067978 -0.008173988 
              p1    log(time)    I(time^2)           p1 
     0.002008155 -0.015643543  0.013875224 -0.047964634 
    
    

---

    $m0a
    $m0a$m1
                     2.5%     97.5%
    (Intercept) 0.1575538 0.7901177
    (Intercept) 0.1832600 0.7131482
    
    
    $m0b
    $m0b$m2
                      2.5%     97.5%
    (Intercept) -0.2845762 0.3882949
    (Intercept) -0.2664229 0.2385682
    
    
    $m1a
    $m1a$m1
                      2.5%     97.5%
    (Intercept) -20.044996  6.959249
    C1           -8.711134 27.471707
    (Intercept) -16.218129  9.520677
    C1          -12.300511 22.283711
    
    
    $m1b
    $m1b$m2
                     2.5%    97.5%
    (Intercept) -18.21811 26.92098
    C1          -36.12706 24.67062
    (Intercept) -16.16937 19.15139
    C1          -25.24325 21.63304
    
    
    $m1c
    $m1c$m1
                       2.5%     97.5%
    (Intercept)  0.03538584 0.6380535
    (Intercept) -0.03257627 0.7057324
    c1          -0.14172023 0.4692660
    c1          -0.56902964 0.2104772
    
    
    $m1d
    $m1d$m2
                      2.5%       97.5%
    (Intercept) -0.1365398  0.48314542
    (Intercept) -0.2017219  0.44191772
    c1          -0.6701518 -0.06482932
    c1          -0.5021135  0.23274726
    
    
    $m2a
    $m2a$m1
                       2.5%     97.5%
    (Intercept) -0.01725488 0.7708970
    C2          -0.13767688 0.9395541
    (Intercept)  0.06573077 0.8858686
    C2           0.19411106 1.2593429
    
    
    $m2b
    $m2b$m2
                      2.5%     97.5%
    (Intercept) -0.2716948 0.5480528
    C2          -0.5049670 0.6582114
    (Intercept) -0.4346457 0.4360783
    C2          -0.7662834 0.5818352
    
    
    $m2c
    $m2c$m1
                      2.5%     97.5%
    (Intercept) -0.5726995 0.7775530
    (Intercept) -0.7526038 0.6038130
    c2          -3.6099514 1.1487779
    c2          -4.3967736 0.7220399
    
    
    $m2d
    $m2d$m2
                      2.5%     97.5%
    (Intercept) -1.0340878 0.9299347
    (Intercept) -0.9534779 0.9107729
    c2          -4.6334016 2.8366573
    c2          -4.4991855 3.5945898
    
    
    $m3a
    $m3a$c1
                        2.5%      97.5%
    (Intercept) -109.5248893 5.45017428
    m1B           -0.2356213 0.07679157
    m1C           -0.3257532 0.01857038
    
    
    $m3b
    $m3b$c1
                      2.5%       97.5%
    (Intercept)  0.1823431  0.41252372
    m2B         -0.3087688 -0.01202926
    m2C         -0.2099551  0.12049474
    
    
    $m4a
    $m4a$m1
                            2.5%      97.5%
    (Intercept)       -3.7068244  4.0787253
    M22               -0.9881366  0.6901861
    M23               -0.9959813  0.6207413
    M24                0.2871981  1.3272468
    abs(C1 - C2)      -0.3537993  0.7731129
    log(C1)          -12.1973853 11.5728646
    (Intercept)       -5.3864371  3.4939971
    M22               -0.9349368  1.1277043
    M23               -1.1753851  0.6170950
    M24               -0.2313747  1.4124154
    abs(C1 - C2)      -0.8009995  0.4299194
    log(C1)          -19.0396822  8.2371714
    m2B               -1.0065126  1.2363166
    m2C               -0.8290328  0.3859447
    m2B:abs(C1 - C2)  -1.4124197  0.2167723
    m2C:abs(C1 - C2)  -0.4271897  0.3331745
    m2B               -0.3194328  1.2529526
    m2C               -1.4621602  0.1697779
    m2B:abs(C1 - C2)  -1.5212777 -0.1298321
    m2C:abs(C1 - C2)  -0.1048224  0.9928746
    
    
    $m4b
    $m4b$m1
                                                                      2.5%
    (Intercept)                                                 -0.7150209
    abs(C1 - C2)                                                -1.0630861
    log(C1)                                                     -1.4217657
    (Intercept)                                                 -3.6569071
    abs(C1 - C2)                                                -0.8846438
    log(C1)                                                    -10.9308224
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -1.4664628
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.7900474
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -1.6241086
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.8335321
                                                                    97.5%
    (Intercept)                                                12.0737911
    abs(C1 - C2)                                                0.5350756
    log(C1)                                                    35.5100167
    (Intercept)                                                 9.0172643
    abs(C1 - C2)                                                0.6372715
    log(C1)                                                    29.1284389
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               1.0845985
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.6435259
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               1.2829513
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  1.0234230
    
    
    $m4c
    $m4c$m1
                        2.5%       97.5%
    (Intercept) -20.12365002 10.45943573
    C1          -14.19219952 27.50485229
    B21          -0.10004235  1.14920004
    (Intercept) -12.15098065 14.48955134
    C1          -19.67414841 15.88297215
    B21          -0.11843946  1.04199063
    time         -0.27266520  0.07184214
    c1           -0.03440799  0.55539471
    time         -0.09346187  0.28167730
    c1           -0.27096364  0.31143651
    
    
    $m4d
    $m4d$m1
                        2.5%       97.5%
    (Intercept) -19.52140538  8.36403961
    C1          -10.44127577 27.00171031
    (Intercept) -16.54629680 19.16795737
    C1          -25.78691976 22.55994973
    time         -0.71415484  0.24140595
    I(time^2)    -0.07073487  0.08641906
    b21          -1.60114042 -0.33743226
    c1           -0.54349737  0.25282436
    C1:time      -0.88924076  0.71283372
    b21:c1        1.36278291  4.27597815
    time         -0.33414582  0.34437084
    I(time^2)    -0.05998728  0.18318428
    b21          -1.63159757  0.08295620
    c1           -0.73684946  0.11464174
    C1:time      -0.92139481  0.27000330
    b21:c1       -0.40557215  2.96148650
    
    
    $m4e
    $m4e$m1
                        2.5%       97.5%
    (Intercept) -24.70181438  8.39066400
    C1          -11.29678628 33.50764992
    (Intercept) -23.99916709  6.81924749
    C1           -9.13669017 32.66051454
    log(time)    -0.26663200  0.11312051
    I(time^2)    -0.03215524  0.02502058
    p1           -0.08698579  0.12938583
    log(time)    -0.20411754  0.18264706
    I(time^2)    -0.01349538  0.04653946
    p1           -0.14915098  0.07147995
    
    

---

    $m0a
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                      Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept) 0.411 0.191 0.158 0.790          0    2.00  0.233
    m1C: (Intercept) 0.392 0.157 0.183 0.713          0    1.67  0.325
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.93 0.735 1.03  3.45               2.54  0.332
    
    
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
    m2B: (Intercept) -0.00169 0.212 -0.285 0.388      0.867    1.17  0.183
    m2C: (Intercept) -0.00398 0.159 -0.266 0.239      1.000    1.19  0.224
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 1.43 0.545 0.718  2.76               1.99  0.294
    
    
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
                      Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept) -6.96  7.48 -20.04  6.96      0.400    3.71  0.394
    m1B: C1           9.84 10.01  -8.71 27.47      0.400    3.57  0.388
    m1C: (Intercept) -3.44  7.77 -16.22  9.52      0.533    2.54  0.352
    m1C: C1           5.03 10.50 -12.30 22.28      0.533    2.44  0.346
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.62 0.998 0.714  4.32               9.65  0.456
    
    
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
    m2B: (Intercept)  4.24 12.5 -18.2  26.9      0.667    4.25  0.389
    m2B: C1          -5.60 16.8 -36.1  24.7      0.733    4.18  0.386
    m2C: (Intercept) -2.57 10.4 -16.2  19.2      0.867    3.43  0.336
    m2C: C1           3.58 14.0 -25.2  21.6      0.867    3.38  0.334
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 1.68 0.483 0.95  2.57               1.41  0.236
    
    
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
    m1B: (Intercept)  0.3323 0.174  0.0354 0.638     0.0667   0.995  0.271
    m1C: (Intercept)  0.3979 0.205 -0.0326 0.706     0.1333   1.016  0.148
    m1B: c1           0.2046 0.188 -0.1417 0.469     0.2667   1.416  0.183
    m1C: c1          -0.0698 0.247 -0.5690 0.210     1.0000   1.646  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.65 0.945 0.444  3.46               5.17  0.331
    
    
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
                        Mean    SD   2.5%   97.5% tail-prob. GR-crit MCE/SD
    m2B: (Intercept)  0.1745 0.196 -0.137  0.4831      0.467    2.79  0.355
    m2C: (Intercept)  0.0711 0.167 -0.202  0.4419      0.533    1.89  0.210
    m2B: c1          -0.4022 0.180 -0.670 -0.0648      0.000    1.28  0.217
    m2C: c1          -0.1440 0.217 -0.502  0.2327      0.600    1.16  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 1.71 0.593 0.956  2.73               1.62  0.309
    
    
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
                      Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept) 0.452 0.253 -0.0173 0.771     0.0667    1.38  0.437
    m1B: C2          0.310 0.295 -0.1377 0.940     0.2667    3.31  0.406
    m1C: (Intercept) 0.543 0.269  0.0657 0.886     0.0000    2.17  0.486
    m1C: C2          0.543 0.270  0.1941 1.259     0.0000    4.92  0.461
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.87 0.668 1.07  3.41               1.15  0.301
    
    
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
    m2B: (Intercept)  0.1855 0.232 -0.272 0.548      0.400    1.33  0.208
    m2B: C2           0.0675 0.330 -0.505 0.658      1.000    4.60  0.371
    m2C: (Intercept)  0.0178 0.261 -0.435 0.436      0.933    2.39  0.430
    m2C: C2          -0.1362 0.445 -0.766 0.582      0.667   10.48  0.486
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 1.79 0.877 0.691  4.11                4.2  0.496
    
    
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
                        Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)  0.0547 0.358 -0.573 0.778      0.933    2.14  0.392
    m1C: (Intercept) -0.0239 0.350 -0.753 0.604      0.933    2.28  0.233
    m1B: c2          -1.1889 1.314 -3.610 1.149      0.267    2.42  0.183
    m1C: c2          -1.4802 1.311 -4.397 0.722      0.267    2.32  0.258
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.87 0.465 1.13  2.81                1.2  0.244
    
    
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
    m2B: (Intercept)  0.0688 0.666 -1.034 0.930      0.800    4.21  0.379
    m2C: (Intercept)  0.0945 0.579 -0.953 0.911      0.733    4.63  0.372
    m2B: c2          -0.5038 2.577 -4.633 2.837      1.000    5.39  0.528
    m2C: c2          -0.2003 2.356 -4.499 3.595      0.933    4.54  0.502
    
    Posterior summary of random effects covariance matrix:
                 Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 2.41  1 0.75  4.31               3.47  0.544
    
    
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
                  Mean      SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    (Intercept) -7.661 28.8465 -109.525 5.4502      0.333    1.16  0.183
    m1B         -0.073  0.0947   -0.236 0.0768      0.600    2.89  0.210
    m1C         -0.142  0.0969   -0.326 0.0186      0.133    2.27  0.327
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_c1_id[1,1]  863 3198 0.0643 12177               1.25  0.183
    
    Posterior summary of residual std. deviation:
              Mean     SD  2.5% 97.5% GR-crit MCE/SD
    sigma_c1 0.654 0.0438 0.608 0.768    1.07  0.224
    
    
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
                   Mean     SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    (Intercept)  0.3072 0.0642  0.182  0.413        0.0    3.10  0.447
    m2B         -0.1499 0.0767 -0.309 -0.012        0.0    2.10  0.183
    m2C         -0.0517 0.0946 -0.210  0.120        0.6    4.16  0.326
    
    Posterior summary of random effects covariance matrix:
                   Mean     SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_c1_id[1,1] 0.0918 0.0318 0.0526  0.15               1.24  0.271
    
    Posterior summary of residual std. deviation:
              Mean     SD  2.5% 97.5% GR-crit MCE/SD
    sigma_c1 0.618 0.0277 0.567 0.663    2.25  0.183
    
    
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
                             Mean    SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)      -0.3495 2.232  -3.707  4.079      0.933    1.42  0.160
    m1B: M22               0.0748 0.547  -0.988  0.690      0.733    7.72  0.348
    m1B: M23              -0.3345 0.469  -0.996  0.621      0.467    1.09  0.423
    m1B: M24               0.8111 0.326   0.287  1.327      0.000    2.83  0.304
    m1B: abs(C1 - C2)      0.2762 0.348  -0.354  0.773      0.467    1.85  0.294
    m1B: log(C1)          -1.6576 6.512 -12.197 11.573      0.867    1.32  0.309
    m1C: (Intercept)      -1.3697 2.215  -5.386  3.494      0.267    2.35  0.227
    m1C: M22               0.1304 0.627  -0.935  1.128      0.667    7.14  0.481
    m1C: M23              -0.3007 0.524  -1.175  0.617      0.533    1.61  0.310
    m1C: M24               0.4853 0.489  -0.231  1.412      0.400    3.36  0.543
    m1C: abs(C1 - C2)     -0.0922 0.364  -0.801  0.430      0.933    2.16  0.410
    m1C: log(C1)          -6.4306 6.665 -19.040  8.237      0.200    1.89  0.183
    m1B: m2B               0.3295 0.688  -1.007  1.236      0.667    7.25  0.826
    m1B: m2C              -0.3427 0.340  -0.829  0.386      0.400    1.77  0.473
    m1B: m2B:abs(C1 - C2) -0.6141 0.507  -1.412  0.217      0.333    6.60  0.677
    m1B: m2C:abs(C1 - C2) -0.0656 0.226  -0.427  0.333      0.733    2.75  0.234
    m1C: m2B               0.5609 0.471  -0.319  1.253      0.267    5.48  0.541
    m1C: m2C              -0.6347 0.491  -1.462  0.170      0.133    1.30  0.289
    m1C: m2B:abs(C1 - C2) -0.7451 0.428  -1.521 -0.130      0.000    4.09  0.457
    m1C: m2C:abs(C1 - C2)  0.3092 0.323  -0.105  0.993      0.400    2.49  0.404
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 2.56 0.96 1.25   4.6               3.21  0.507
    
    
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
    m1B: (Intercept)                                                 5.3118  4.257
    m1B: abs(C1 - C2)                                               -0.2660  0.556
    m1B: log(C1)                                                    14.8978 12.327
    m1C: (Intercept)                                                 3.9550  3.864
    m1C: abs(C1 - C2)                                               -0.2630  0.452
    m1C: log(C1)                                                    10.6693 11.505
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.0322  0.853
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.1403  0.472
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.0190  0.978
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.0288  0.603
                                                                       2.5%  97.5%
    m1B: (Intercept)                                                 -0.715 12.074
    m1B: abs(C1 - C2)                                                -1.063  0.535
    m1B: log(C1)                                                     -1.422 35.510
    m1C: (Intercept)                                                 -3.657  9.017
    m1C: abs(C1 - C2)                                                -0.885  0.637
    m1C: log(C1)                                                    -10.931 29.128
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -1.466  1.085
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.790  0.644
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -1.624  1.283
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.834  1.023
                                                                    tail-prob.
    m1B: (Intercept)                                                     0.333
    m1B: abs(C1 - C2)                                                    0.867
    m1B: log(C1)                                                         0.267
    m1C: (Intercept)                                                     0.333
    m1C: abs(C1 - C2)                                                    0.600
    m1C: log(C1)                                                         0.400
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                   0.733
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)      0.733
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                   0.867
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)      0.933
                                                                    GR-crit MCE/SD
    m1B: (Intercept)                                                   6.66  0.568
    m1B: abs(C1 - C2)                                                  7.04  0.509
    m1B: log(C1)                                                       6.78  0.523
    m1C: (Intercept)                                                   7.32  0.183
    m1C: abs(C1 - C2)                                                  4.94  0.457
    m1C: log(C1)                                                       6.38  0.379
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                 8.42  0.438
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)    6.88  0.486
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                 7.15  0.569
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)    3.65  0.702
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.96 0.648 1.16  3.22               1.92  0.436
    
    
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
                         Mean      SD     2.5%   97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept) -3.57894  7.8391 -20.1237 10.4594      0.600    1.70 0.2390
    m1B: C1           4.88600 10.5055 -14.1922 27.5049      0.600    1.65 0.1826
    m1B: B21          0.42801  0.3856  -0.1000  1.1492      0.200    8.00 0.6237
    m1C: (Intercept)  0.76663  7.5046 -12.1510 14.4896      1.000    1.83 0.0836
    m1C: C1          -1.42078 10.0446 -19.6741 15.8830      1.000    1.79 0.0869
    m1C: B21          0.38776  0.3243  -0.1184  1.0420      0.200    3.64 0.5309
    m1B: time        -0.09186  0.0974  -0.2727  0.0718      0.267    1.78 0.2926
    m1B: c1           0.25242  0.1757  -0.0344  0.5554      0.200    1.50 0.1934
    m1C: time         0.05001  0.1047  -0.0935  0.2817      0.533    1.67 0.2177
    m1C: c1          -0.00571  0.1665  -0.2710  0.3114      0.933    1.22 0.1826
    
    Posterior summary of random effects covariance matrix:
                    Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1]  0.2395 0.1067  0.1207 0.4539               4.57  0.183
    D_m1_id[1,2] -0.0187 0.0311 -0.0924 0.0439      0.400    2.40  0.183
    D_m1_id[2,2]  0.1928 0.0959  0.0667 0.3344              10.11  0.859
    D_m1_id[1,3] -0.0497 0.0932 -0.2240 0.0764      0.533   12.20  0.872
    D_m1_id[2,3]  0.0531 0.0488 -0.0072 0.1642      0.133    3.11  0.508
    D_m1_id[3,3]  0.2693 0.1717  0.0589 0.5744              12.07  0.722
    D_m1_id[1,4] -0.0154 0.0790 -0.1436 0.0958      1.000    5.97  0.530
    D_m1_id[2,4]  0.0242 0.0390 -0.0410 0.0899      0.400    2.40  0.352
    D_m1_id[3,4]  0.0813 0.1227 -0.0374 0.3319      0.600   12.03  0.487
    D_m1_id[4,4]  0.3134 0.0950  0.1694 0.4726               4.00  0.379
    
    
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
    m1B: (Intercept) -4.4125  8.0411 -19.5214  8.3640      0.667   3.963    Inf
    m1B: C1           6.7731 10.7070 -10.4413 27.0017      0.667   3.917    Inf
    m1C: (Intercept)  0.8585 10.8849 -16.5463 19.1680      0.867   2.518  0.417
    m1C: C1          -0.7117 14.6003 -25.7869 22.5599      0.933   2.460  0.412
    m1B: time        -0.1769  0.3220  -0.7142  0.2414      0.800   5.946  0.467
    m1B: I(time^2)    0.0270  0.0443  -0.0707  0.0864      0.533   7.784  0.810
    m1B: b21         -0.8864  0.3848  -1.6011 -0.3374      0.000   1.943  0.236
    m1B: c1          -0.1407  0.2122  -0.5435  0.2528      0.400   0.961  0.183
    m1B: C1:time     -0.0598  0.5006  -0.8892  0.7128      0.800   8.124  0.295
    m1B: b21:c1       2.6948  0.8586   1.3628  4.2760      0.000   1.490  0.324
    m1C: time         0.0669  0.2110  -0.3341  0.3444      0.733   2.720  0.356
    m1C: I(time^2)    0.0446  0.0727  -0.0600  0.1832      0.600   7.479  0.503
    m1C: b21         -0.6209  0.5201  -1.6316  0.0830      0.133   1.707  0.435
    m1C: c1          -0.2420  0.2485  -0.7368  0.1146      0.467   1.030  0.217
    m1C: C1:time     -0.3177  0.3567  -0.9214  0.2700      0.400   3.554  0.651
    m1C: b21:c1       1.0509  0.9811  -0.4056  2.9615      0.400   1.074  0.318
    
    Posterior summary of random effects covariance matrix:
                    Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1]  0.6237 0.183  0.399 1.0652               3.19  0.235
    D_m1_id[1,2] -0.0911 0.156 -0.437 0.0675      0.733    8.13  0.526
    D_m1_id[2,2]  0.3256 0.112  0.131 0.4942               6.00  0.495
    
    
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
    m1B: (Intercept) -7.46207  9.6087 -24.7018  8.3907      0.333   3.340  0.430
    m1B: C1          10.38951 12.9743 -11.2968 33.5076      0.333   3.384  0.430
    m1C: (Intercept) -4.87238  9.3460 -23.9992  6.8192      0.733   3.543  0.426
    m1C: C1           6.82851 12.7190  -9.1367 32.6605      0.733   3.555  0.427
    m1B: log(time)   -0.04507  0.1097  -0.2666  0.1131      0.800   1.223  0.183
    m1B: I(time^2)   -0.00817  0.0182  -0.0322  0.0250      0.600   1.995  0.183
    m1B: p1           0.00201  0.0665  -0.0870  0.1294      0.867   1.511  0.216
    m1C: log(time)   -0.01564  0.1090  -0.2041  0.1826      0.933   0.993  0.183
    m1C: I(time^2)    0.01388  0.0180  -0.0135  0.0465      0.533   1.444  0.206
    m1C: p1          -0.04796  0.0625  -0.1492  0.0715      0.333   1.412  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.43 0.673 0.473  2.91               6.64  0.558
    
    
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
                          Mean        SD      2.5%     97.5% tail-prob.  GR-crit
    m1B: (Intercept) 0.4111954 0.1908804 0.1575538 0.7901177          0 1.995328
    m1C: (Intercept) 0.3916108 0.1570900 0.1832600 0.7131482          0 1.673623
                        MCE/SD
    m1B: (Intercept) 0.2327255
    m1C: (Intercept) 0.3251097
    
    
    $m0b
    $m0b$m2
                             Mean        SD       2.5%     97.5% tail-prob.
    m2B: (Intercept) -0.001691199 0.2116387 -0.2845762 0.3882949  0.8666667
    m2C: (Intercept) -0.003984227 0.1585109 -0.2664229 0.2385682  1.0000000
                      GR-crit    MCE/SD
    m2B: (Intercept) 1.169999 0.1825742
    m2C: (Intercept) 1.189016 0.2236091
    
    
    $m1a
    $m1a$m1
                          Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    m1B: (Intercept) -6.964242  7.484122 -20.044996  6.959249  0.4000000 3.712156
    m1B: C1           9.837394 10.014557  -8.711134 27.471707  0.4000000 3.572426
    m1C: (Intercept) -3.436172  7.774117 -16.218129  9.520677  0.5333333 2.536242
    m1C: C1           5.026033 10.500016 -12.300511 22.283711  0.5333333 2.444180
                        MCE/SD
    m1B: (Intercept) 0.3938656
    m1B: C1          0.3883897
    m1C: (Intercept) 0.3520077
    m1C: C1          0.3458424
    
    
    $m1b
    $m1b$m2
                          Mean       SD      2.5%    97.5% tail-prob.  GR-crit
    m2B: (Intercept)  4.239143 12.51542 -18.21811 26.92098  0.6666667 4.249084
    m2B: C1          -5.601100 16.80333 -36.12706 24.67062  0.7333333 4.179420
    m2C: (Intercept) -2.573461 10.43405 -16.16937 19.15139  0.8666667 3.429411
    m2C: C1           3.584569 13.97812 -25.24325 21.63304  0.8666667 3.376649
                        MCE/SD
    m2B: (Intercept) 0.3891265
    m2B: C1          0.3859435
    m2C: (Intercept) 0.3363870
    m2C: C1          0.3336166
    
    
    $m1c
    $m1c$m1
                            Mean        SD        2.5%     97.5% tail-prob.
    m1B: (Intercept)  0.33230787 0.1741880  0.03538584 0.6380535 0.06666667
    m1C: (Intercept)  0.39788965 0.2053512 -0.03257627 0.7057324 0.13333333
    m1B: c1           0.20459377 0.1882886 -0.14172023 0.4692660 0.26666667
    m1C: c1          -0.06977906 0.2471783 -0.56902964 0.2104772 1.00000000
                       GR-crit    MCE/SD
    m1B: (Intercept) 0.9954695 0.2713939
    m1C: (Intercept) 1.0156651 0.1476120
    m1B: c1          1.4164299 0.1825742
    m1C: c1          1.6459482 0.1825742
    
    
    $m1d
    $m1d$m2
                            Mean        SD       2.5%       97.5% tail-prob.
    m2B: (Intercept)  0.17447649 0.1961358 -0.1365398  0.48314542  0.4666667
    m2C: (Intercept)  0.07111141 0.1668612 -0.2017219  0.44191772  0.5333333
    m2B: c1          -0.40222150 0.1796564 -0.6701518 -0.06482932  0.0000000
    m2C: c1          -0.14396465 0.2167974 -0.5021135  0.23274726  0.6000000
                      GR-crit    MCE/SD
    m2B: (Intercept) 2.786842 0.3552224
    m2C: (Intercept) 1.893779 0.2098171
    m2B: c1          1.280341 0.2174483
    m2C: c1          1.156531 0.1825742
    
    
    $m2a
    $m2a$m1
                          Mean        SD        2.5%     97.5% tail-prob.  GR-crit
    m1B: (Intercept) 0.4523332 0.2525080 -0.01725488 0.7708970 0.06666667 1.383399
    m1B: C2          0.3104303 0.2949456 -0.13767688 0.9395541 0.26666667 3.312414
    m1C: (Intercept) 0.5431882 0.2693183  0.06573077 0.8858686 0.00000000 2.167057
    m1C: C2          0.5430399 0.2695326  0.19411106 1.2593429 0.00000000 4.915568
                        MCE/SD
    m1B: (Intercept) 0.4366272
    m1B: C2          0.4056142
    m1C: (Intercept) 0.4863807
    m1C: C2          0.4610951
    
    
    $m2b
    $m2b$m2
                            Mean        SD       2.5%     97.5% tail-prob.
    m2B: (Intercept)  0.18545716 0.2316659 -0.2716948 0.5480528  0.4000000
    m2B: C2           0.06751862 0.3295247 -0.5049670 0.6582114  1.0000000
    m2C: (Intercept)  0.01783536 0.2605607 -0.4346457 0.4360783  0.9333333
    m2C: C2          -0.13620709 0.4452529 -0.7662834 0.5818352  0.6666667
                       GR-crit    MCE/SD
    m2B: (Intercept)  1.330667 0.2083469
    m2B: C2           4.599792 0.3710497
    m2C: (Intercept)  2.390754 0.4301509
    m2C: C2          10.480672 0.4855091
    
    
    $m2c
    $m2c$m1
                            Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    m1B: (Intercept)  0.05469462 0.3577724 -0.5726995 0.7775530  0.9333333 2.137532
    m1C: (Intercept) -0.02391887 0.3498828 -0.7526038 0.6038130  0.9333333 2.277315
    m1B: c2          -1.18889343 1.3138488 -3.6099514 1.1487779  0.2666667 2.423742
    m1C: c2          -1.48017716 1.3112757 -4.3967736 0.7220399  0.2666667 2.324455
                        MCE/SD
    m1B: (Intercept) 0.3923798
    m1C: (Intercept) 0.2332048
    m1B: c2          0.1825742
    m1C: c2          0.2581751
    
    
    $m2d
    $m2d$m2
                            Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    m2B: (Intercept)  0.06884005 0.6662249 -1.0340878 0.9299347  0.8000000 4.211379
    m2C: (Intercept)  0.09450104 0.5786569 -0.9534779 0.9107729  0.7333333 4.627395
    m2B: c2          -0.50377781 2.5770601 -4.6334016 2.8366573  1.0000000 5.385492
    m2C: c2          -0.20029846 2.3561300 -4.4991855 3.5945898  0.9333333 4.543108
                        MCE/SD
    m2B: (Intercept) 0.3786841
    m2C: (Intercept) 0.3721307
    m2B: c2          0.5277955
    m2C: c2          0.5021305
    
    
    $m3a
    $m3a$c1
                       Mean          SD         2.5%      97.5% tail-prob.  GR-crit
    (Intercept) -7.66092103 28.84650091 -109.5248893 5.45017428  0.3333333 1.160351
    m1B         -0.07303115  0.09469874   -0.2356213 0.07679157  0.6000000 2.885421
    m1C         -0.14191406  0.09693537   -0.3257532 0.01857038  0.1333333 2.274959
                   MCE/SD
    (Intercept) 0.1825742
    m1B         0.2101254
    m1C         0.3273654
    
    
    $m3b
    $m3b$c1
                       Mean         SD       2.5%       97.5% tail-prob.  GR-crit
    (Intercept)  0.30716619 0.06421403  0.1823431  0.41252372        0.0 3.098939
    m2B         -0.14989608 0.07669020 -0.3087688 -0.01202926        0.0 2.095306
    m2C         -0.05170018 0.09456748 -0.2099551  0.12049474        0.6 4.163973
                   MCE/SD
    (Intercept) 0.4465119
    m2B         0.1825742
    m2C         0.3264864
    
    
    $m4a
    $m4a$m1
                                 Mean        SD        2.5%      97.5% tail-prob.
    m1B: (Intercept)      -0.34954956 2.2320397  -3.7068244  4.0787253  0.9333333
    m1B: M22               0.07482196 0.5467749  -0.9881366  0.6901861  0.7333333
    m1B: M23              -0.33448067 0.4691213  -0.9959813  0.6207413  0.4666667
    m1B: M24               0.81111205 0.3262735   0.2871981  1.3272468  0.0000000
    m1B: abs(C1 - C2)      0.27616703 0.3477122  -0.3537993  0.7731129  0.4666667
    m1B: log(C1)          -1.65763805 6.5121739 -12.1973853 11.5728646  0.8666667
    m1C: (Intercept)      -1.36972364 2.2151972  -5.3864371  3.4939971  0.2666667
    m1C: M22               0.13039559 0.6270180  -0.9349368  1.1277043  0.6666667
    m1C: M23              -0.30067311 0.5238373  -1.1753851  0.6170950  0.5333333
    m1C: M24               0.48533037 0.4892866  -0.2313747  1.4124154  0.4000000
    m1C: abs(C1 - C2)     -0.09221467 0.3643839  -0.8009995  0.4299194  0.9333333
    m1C: log(C1)          -6.43062118 6.6652105 -19.0396822  8.2371714  0.2000000
    m1B: m2B               0.32952211 0.6881115  -1.0065126  1.2363166  0.6666667
    m1B: m2C              -0.34273626 0.3404999  -0.8290328  0.3859447  0.4000000
    m1B: m2B:abs(C1 - C2) -0.61410352 0.5069768  -1.4124197  0.2167723  0.3333333
    m1B: m2C:abs(C1 - C2) -0.06559019 0.2261035  -0.4271897  0.3331745  0.7333333
    m1C: m2B               0.56092013 0.4712189  -0.3194328  1.2529526  0.2666667
    m1C: m2C              -0.63467112 0.4913127  -1.4621602  0.1697779  0.1333333
    m1C: m2B:abs(C1 - C2) -0.74508797 0.4276227  -1.5212777 -0.1298321  0.0000000
    m1C: m2C:abs(C1 - C2)  0.30918445 0.3227731  -0.1048224  0.9928746  0.4000000
                           GR-crit    MCE/SD
    m1B: (Intercept)      1.417318 0.1601231
    m1B: M22              7.719149 0.3479364
    m1B: M23              1.086786 0.4229629
    m1B: M24              2.831394 0.3040540
    m1B: abs(C1 - C2)     1.845078 0.2944073
    m1B: log(C1)          1.318980 0.3091415
    m1C: (Intercept)      2.351116 0.2270496
    m1C: M22              7.144523 0.4806885
    m1C: M23              1.611144 0.3102786
    m1C: M24              3.362157 0.5431270
    m1C: abs(C1 - C2)     2.158893 0.4101198
    m1C: log(C1)          1.887494 0.1825742
    m1B: m2B              7.248779 0.8257033
    m1B: m2C              1.772265 0.4732553
    m1B: m2B:abs(C1 - C2) 6.598520 0.6771023
    m1B: m2C:abs(C1 - C2) 2.745389 0.2337070
    m1C: m2B              5.477783 0.5412502
    m1C: m2C              1.304814 0.2886718
    m1C: m2B:abs(C1 - C2) 4.085916 0.4569155
    m1C: m2C:abs(C1 - C2) 2.493428 0.4042704
    
    
    $m4b
    $m4b$m1
                                                                           Mean
    m1B: (Intercept)                                                 5.31179862
    m1B: abs(C1 - C2)                                               -0.26595715
    m1B: log(C1)                                                    14.89783235
    m1C: (Intercept)                                                 3.95501617
    m1C: abs(C1 - C2)                                               -0.26296191
    m1C: log(C1)                                                    10.66927517
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.03222199
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.14032670
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.01904377
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.02875664
                                                                            SD
    m1B: (Intercept)                                                 4.2565459
    m1B: abs(C1 - C2)                                                0.5555408
    m1B: log(C1)                                                    12.3272946
    m1C: (Intercept)                                                 3.8636749
    m1C: abs(C1 - C2)                                                0.4524377
    m1C: log(C1)                                                    11.5048520
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.8525124
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.4717113
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.9781438
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.6028068
                                                                           2.5%
    m1B: (Intercept)                                                 -0.7150209
    m1B: abs(C1 - C2)                                                -1.0630861
    m1B: log(C1)                                                     -1.4217657
    m1C: (Intercept)                                                 -3.6569071
    m1C: abs(C1 - C2)                                                -0.8846438
    m1C: log(C1)                                                    -10.9308224
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -1.4664628
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.7900474
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -1.6241086
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.8335321
                                                                         97.5%
    m1B: (Intercept)                                                12.0737911
    m1B: abs(C1 - C2)                                                0.5350756
    m1B: log(C1)                                                    35.5100167
    m1C: (Intercept)                                                 9.0172643
    m1C: abs(C1 - C2)                                                0.6372715
    m1C: log(C1)                                                    29.1284389
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               1.0845985
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.6435259
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               1.2829513
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  1.0234230
                                                                    tail-prob.
    m1B: (Intercept)                                                 0.3333333
    m1B: abs(C1 - C2)                                                0.8666667
    m1B: log(C1)                                                     0.2666667
    m1C: (Intercept)                                                 0.3333333
    m1C: abs(C1 - C2)                                                0.6000000
    m1C: log(C1)                                                     0.4000000
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.7333333
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.7333333
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.8666667
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.9333333
                                                                     GR-crit
    m1B: (Intercept)                                                6.664791
    m1B: abs(C1 - C2)                                               7.037402
    m1B: log(C1)                                                    6.779515
    m1C: (Intercept)                                                7.323323
    m1C: abs(C1 - C2)                                               4.942524
    m1C: log(C1)                                                    6.375491
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              8.419086
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 6.875832
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              7.148380
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 3.652273
                                                                       MCE/SD
    m1B: (Intercept)                                                0.5681047
    m1B: abs(C1 - C2)                                               0.5093749
    m1B: log(C1)                                                    0.5233503
    m1C: (Intercept)                                                0.1825742
    m1C: abs(C1 - C2)                                               0.4573188
    m1C: log(C1)                                                    0.3785452
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.4381728
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.4862282
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.5689782
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.7015813
    
    
    $m4c
    $m4c$m1
                             Mean          SD         2.5%       97.5% tail-prob.
    m1B: (Intercept) -3.578941344  7.83905663 -20.12365002 10.45943573  0.6000000
    m1B: C1           4.885996667 10.50546739 -14.19219952 27.50485229  0.6000000
    m1B: B21          0.428013031  0.38564734  -0.10004235  1.14920004  0.2000000
    m1C: (Intercept)  0.766630087  7.50460239 -12.15098065 14.48955134  1.0000000
    m1C: C1          -1.420775453 10.04461755 -19.67414841 15.88297215  1.0000000
    m1C: B21          0.387761993  0.32426622  -0.11843946  1.04199063  0.2000000
    m1B: time        -0.091861282  0.09744787  -0.27266520  0.07184214  0.2666667
    m1B: c1           0.252422896  0.17565101  -0.03440799  0.55539471  0.2000000
    m1C: time         0.050008987  0.10469507  -0.09346187  0.28167730  0.5333333
    m1C: c1          -0.005712537  0.16653939  -0.27096364  0.31143651  0.9333333
                      GR-crit     MCE/SD
    m1B: (Intercept) 1.698614 0.23895850
    m1B: C1          1.650614 0.18257419
    m1B: B21         7.995082 0.62371560
    m1C: (Intercept) 1.834968 0.08360347
    m1C: C1          1.787326 0.08692177
    m1C: B21         3.636320 0.53088515
    m1B: time        1.781025 0.29257617
    m1B: c1          1.495511 0.19342761
    m1C: time        1.674804 0.21769382
    m1C: c1          1.220257 0.18257419
    
    
    $m4d
    $m4d$m1
                            Mean          SD         2.5%       97.5% tail-prob.
    m1B: (Intercept) -4.41245997  8.04113648 -19.52140538  8.36403961  0.6666667
    m1B: C1           6.77313979 10.70703203 -10.44127577 27.00171031  0.6666667
    m1C: (Intercept)  0.85851665 10.88486641 -16.54629680 19.16795737  0.8666667
    m1C: C1          -0.71169465 14.60030427 -25.78691976 22.55994973  0.9333333
    m1B: time        -0.17685615  0.32203363  -0.71415484  0.24140595  0.8000000
    m1B: I(time^2)    0.02695698  0.04432873  -0.07073487  0.08641906  0.5333333
    m1B: b21         -0.88637246  0.38482599  -1.60114042 -0.33743226  0.0000000
    m1B: c1          -0.14070716  0.21221380  -0.54349737  0.25282436  0.4000000
    m1B: C1:time     -0.05982384  0.50063453  -0.88924076  0.71283372  0.8000000
    m1B: b21:c1       2.69479054  0.85859477   1.36278291  4.27597815  0.0000000
    m1C: time         0.06687124  0.21098933  -0.33414582  0.34437084  0.7333333
    m1C: I(time^2)    0.04459811  0.07272565  -0.05998728  0.18318428  0.6000000
    m1C: b21         -0.62091633  0.52011190  -1.63159757  0.08295620  0.1333333
    m1C: c1          -0.24204281  0.24848432  -0.73684946  0.11464174  0.4666667
    m1C: C1:time     -0.31766766  0.35669872  -0.92139481  0.27000330  0.4000000
    m1C: b21:c1       1.05088231  0.98110079  -0.40557215  2.96148650  0.4000000
                       GR-crit    MCE/SD
    m1B: (Intercept) 3.9634853       Inf
    m1B: C1          3.9171874       Inf
    m1C: (Intercept) 2.5181427 0.4168774
    m1C: C1          2.4604490 0.4122508
    m1B: time        5.9464455 0.4673774
    m1B: I(time^2)   7.7842676 0.8100928
    m1B: b21         1.9428888 0.2361696
    m1B: c1          0.9614269 0.1825742
    m1B: C1:time     8.1237329 0.2946542
    m1B: b21:c1      1.4899127 0.3241631
    m1C: time        2.7203893 0.3557864
    m1C: I(time^2)   7.4791651 0.5029119
    m1C: b21         1.7071998 0.4352023
    m1C: c1          1.0299835 0.2168432
    m1C: C1:time     3.5542686 0.6509009
    m1C: b21:c1      1.0742094 0.3175327
    
    
    $m4e
    $m4e$m1
                             Mean          SD         2.5%       97.5% tail-prob.
    m1B: (Intercept) -7.462067327  9.60869346 -24.70181438  8.39066400  0.3333333
    m1B: C1          10.389507537 12.97431451 -11.29678628 33.50764992  0.3333333
    m1C: (Intercept) -4.872381875  9.34596095 -23.99916709  6.81924749  0.7333333
    m1C: C1           6.828512025 12.71897972  -9.13669017 32.66051454  0.7333333
    m1B: log(time)   -0.045067978  0.10974873  -0.26663200  0.11312051  0.8000000
    m1B: I(time^2)   -0.008173988  0.01816332  -0.03215524  0.02502058  0.6000000
    m1B: p1           0.002008155  0.06650675  -0.08698579  0.12938583  0.8666667
    m1C: log(time)   -0.015643543  0.10896714  -0.20411754  0.18264706  0.9333333
    m1C: I(time^2)    0.013875224  0.01799478  -0.01349538  0.04653946  0.5333333
    m1C: p1          -0.047964634  0.06254938  -0.14915098  0.07147995  0.3333333
                       GR-crit    MCE/SD
    m1B: (Intercept) 3.3396694 0.4298991
    m1B: C1          3.3844870 0.4301998
    m1C: (Intercept) 3.5432339 0.4262392
    m1C: C1          3.5551547 0.4270895
    m1B: log(time)   1.2233013 0.1825742
    m1B: I(time^2)   1.9947977 0.1825742
    m1B: p1          1.5113329 0.2155650
    m1C: log(time)   0.9927089 0.1825742
    m1C: I(time^2)   1.4441641 0.2056591
    m1C: p1          1.4124265 0.1825742
    
    

