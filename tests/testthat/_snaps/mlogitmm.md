# GRcrit and MCerror give same result

    $m0a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       2.75       5.76
    m1C: (Intercept)       3.82       7.18
    D_m1_id[1,1]           2.54       5.15
    
    
    $m0b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       1.36       2.24
    m2C: (Intercept)       1.40       2.67
    D_m2_id[1,1]           3.68       8.20
    
    
    $m1a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       2.57       5.11
    m1B: C1                2.58       5.13
    m1C: (Intercept)       1.83       3.50
    m1C: C1                1.83       3.52
    D_m1_id[1,1]           1.85       4.61
    
    
    $m1b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       1.31       2.63
    m2B: C1                1.32       2.62
    m2C: (Intercept)       1.17       2.01
    m2C: C1                1.15       1.90
    D_m2_id[1,1]           5.15      11.76
    
    
    $m1c
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       2.01       3.50
    m1C: (Intercept)       1.91       3.21
    m1B: c1                1.62       2.73
    m1C: c1                1.39       2.11
    D_m1_id[1,1]           1.50       4.01
    
    
    $m1d
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)      1.015       1.02
    m2C: (Intercept)      0.969       1.06
    m2B: c1               1.447       2.47
    m2C: c1               1.074       1.35
    D_m2_id[1,1]          2.324       4.43
    
    
    $m2a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.23       1.89
    m1B: C2                1.43       3.01
    m1C: (Intercept)       1.04       1.27
    m1C: C2                1.10       1.46
    D_m1_id[1,1]           2.60       6.57
    
    
    $m2b
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       2.71       6.33
    m2B: C2                2.37       6.18
    m2C: (Intercept)       2.29       4.54
    m2C: C2                2.00       3.53
    D_m2_id[1,1]           2.95       5.65
    
    
    $m2c
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       2.02       3.88
    m1C: (Intercept)       2.63       5.43
    m1B: c2                1.69       2.75
    m1C: c2                3.39       6.42
    D_m1_id[1,1]           2.12       3.97
    
    
    $m2d
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m2B: (Intercept)       3.89       7.65
    m2C: (Intercept)       3.32       6.21
    m2B: c2                2.65       5.25
    m2C: c2                1.71       3.79
    D_m2_id[1,1]           1.45       2.40
    
    
    $m3a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    (Intercept)       4.497      11.48
    m1B               2.288       4.30
    m1C               2.635       6.85
    sigma_c1          0.967       1.06
    D_c1_id[1,1]      1.032       1.27
    
    
    $m3b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    (Intercept)        2.03       3.56
    m2B                1.58       3.36
    m2C                1.58       2.73
    sigma_c1           1.21       1.83
    D_c1_id[1,1]       1.54       2.55
    
    
    $m4a
    Potential scale reduction factors:
    
                          Point est. Upper C.I.
    m1B: (Intercept)            3.60       6.67
    m1B: M22                    2.38       5.15
    m1B: M23                    4.07       7.68
    m1B: M24                    2.64       4.73
    m1B: abs(C1 - C2)           2.10       5.50
    m1B: log(C1)                3.60       6.81
    m1C: (Intercept)            2.03       3.57
    m1C: M22                    1.14       1.62
    m1C: M23                    1.27       1.90
    m1C: M24                    1.24       1.78
    m1C: abs(C1 - C2)           1.45       2.56
    m1C: log(C1)                2.31       4.28
    m1B: m2B                    1.70       3.05
    m1B: m2C                    9.82      18.95
    m1B: m2B:abs(C1 - C2)       2.90       9.68
    m1B: m2C:abs(C1 - C2)       3.68       7.11
    m1C: m2B                    1.94       4.27
    m1C: m2C                    4.19       8.74
    m1C: m2B:abs(C1 - C2)       1.61       3.86
    m1C: m2C:abs(C1 - C2)       2.76       5.24
    D_m1_id[1,1]                1.27       2.05
    
    
    $m4b
    Potential scale reduction factors:
    
                                                                    Point est.
    m1B: (Intercept)                                                      2.84
    m1B: abs(C1 - C2)                                                     1.28
    m1B: log(C1)                                                          2.64
    m1C: (Intercept)                                                      2.52
    m1C: abs(C1 - C2)                                                     1.25
    m1C: log(C1)                                                          2.57
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                    2.51
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)       1.72
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                    1.45
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)       1.15
    D_m1_id[1,1]                                                          1.18
                                                                    Upper C.I.
    m1B: (Intercept)                                                      5.21
    m1B: abs(C1 - C2)                                                     1.86
    m1B: log(C1)                                                          5.02
    m1C: (Intercept)                                                      4.83
    m1C: abs(C1 - C2)                                                     1.95
    m1C: log(C1)                                                          4.91
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                    4.53
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)       2.93
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                    2.53
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)       1.64
    D_m1_id[1,1]                                                          1.63
    
    
    $m4c
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)       1.39       2.24
    m1B: C1                1.39       2.26
    m1B: B21               3.61       8.17
    m1C: (Intercept)       1.01       1.19
    m1C: C1                1.02       1.22
    m1C: B21               2.45       5.86
    m1B: time              1.23       1.78
    m1B: c1                1.27       2.23
    m1C: time              1.50       2.35
    m1C: c1                1.11       1.36
    D_m1_id[1,1]           4.02      10.49
    D_m1_id[1,2]           3.29       6.71
    D_m1_id[2,2]           2.36       4.15
    D_m1_id[1,3]           1.83       3.16
    D_m1_id[2,3]           3.58      13.66
    D_m1_id[3,3]           2.54       4.66
    D_m1_id[1,4]           1.17       1.76
    D_m1_id[2,4]           2.53       6.17
    D_m1_id[3,4]           1.00       1.17
    D_m1_id[4,4]           2.59       5.20
    
    
    $m4d
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)      1.892       3.23
    m1B: C1               1.835       3.11
    m1C: (Intercept)      1.368       2.30
    m1C: C1               1.360       2.29
    m1B: time            10.785      20.67
    m1B: I(time^2)        1.506       2.84
    m1B: b21              2.569       5.38
    m1B: c1               1.522       2.58
    m1B: C1:time          2.584       5.62
    m1B: b21:c1           1.238       1.83
    m1C: time             0.977       1.02
    m1C: I(time^2)        2.661       5.01
    m1C: b21              2.555       4.78
    m1C: c1               2.009       3.71
    m1C: C1:time          2.546       6.68
    m1C: b21:c1           1.549       3.03
    D_m1_id[1,1]          5.035      15.34
    D_m1_id[1,2]          2.054       4.96
    D_m1_id[2,2]          3.429       6.61
    
    
    $m4e
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    m1B: (Intercept)      0.969      0.972
    m1B: C1               0.970      0.977
    m1C: (Intercept)      1.024      1.118
    m1C: C1               1.032      1.119
    m1B: log(time)        1.012      1.127
    m1B: I(time^2)        0.954      1.017
    m1B: p1               1.220      2.176
    m1C: log(time)        0.977      1.009
    m1C: I(time^2)        1.024      1.138
    m1C: p1               1.165      1.875
    D_m1_id[1,1]          2.860      5.905
    
    

---

    $m0a
                      est  MCSE   SD MCSE/SD
    m1B: (Intercept) 0.35 0.081 0.23    0.35
    m1C: (Intercept) 0.22 0.086 0.24    0.36
    D_m1_id[1,1]     1.75 0.117 0.64    0.18
    
    $m0b
                      est  MCSE   SD MCSE/SD
    m2B: (Intercept) 0.30 0.046 0.26    0.18
    m2C: (Intercept) 0.46 0.067 0.27    0.25
    D_m2_id[1,1]     1.15 0.239 0.48    0.50
    
    $m1a
                        est MCSE    SD MCSE/SD
    m1B: (Intercept)  -0.29 3.86  7.97    0.48
    m1B: C1            0.71 5.22 10.80    0.48
    m1C: (Intercept) -16.93 3.93  8.46    0.46
    m1C: C1           23.02 5.31 11.48    0.46
    D_m1_id[1,1]       1.74 0.43  0.91    0.47
    
    $m1b
                      est MCSE    SD MCSE/SD
    m2B: (Intercept)  7.1  3.0  9.78    0.31
    m2B: C1          -9.2  4.2 13.31    0.31
    m2C: (Intercept)  4.7  1.9 10.24    0.18
    m2C: C1          -5.7  2.5 13.81    0.18
    D_m2_id[1,1]      2.0  0.5  0.92    0.55
    
    $m1c
                        est  MCSE   SD MCSE/SD
    m1B: (Intercept)  0.188 0.124 0.19    0.66
    m1C: (Intercept)  0.071 0.116 0.24    0.49
    m1B: c1          -0.179 0.038 0.21    0.18
    m1C: c1          -0.412 0.039 0.18    0.22
    D_m1_id[1,1]      2.026 0.573 1.07    0.54
    
    $m1d
                      est  MCSE   SD MCSE/SD
    m2B: (Intercept) 0.05 0.065 0.19    0.35
    m2C: (Intercept) 0.29 0.049 0.15    0.32
    m2B: c1          0.63 0.070 0.31    0.23
    m2C: c1          0.19 0.049 0.27    0.18
    D_m2_id[1,1]     1.00 0.170 0.41    0.41
    
    $m2a
                        est  MCSE   SD MCSE/SD
    m1B: (Intercept)     NA    NA 0.26      NA
    m1B: C2          -0.098 0.083 0.28    0.30
    m1C: (Intercept)  0.329 0.069 0.27    0.25
    m1C: C2           0.247 0.067 0.26    0.26
    D_m1_id[1,1]      1.720 0.220 0.68    0.33
    
    $m2b
                        est  MCSE   SD MCSE/SD
    m2B: (Intercept) 0.2663 0.176 0.31    0.56
    m2B: C2          0.0086 0.226 0.42    0.54
    m2C: (Intercept) 0.4609 0.096 0.29    0.34
    m2C: C2          0.1043 0.095 0.31    0.31
    D_m2_id[1,1]     1.5692 0.429 0.82    0.52
    
    $m2c
                         est MCSE   SD MCSE/SD
    m1B: (Intercept)  0.3519 0.17 0.36    0.48
    m1C: (Intercept)  0.0141 0.14 0.39    0.36
    m1B: c2           0.8896 0.48 1.17    0.41
    m1C: c2          -0.0096 0.62 1.34    0.46
    D_m1_id[1,1]      1.3081 0.27 0.62    0.43
    
    $m2d
                        est MCSE   SD MCSE/SD
    m2B: (Intercept)  0.096 0.18 0.51    0.36
    m2C: (Intercept)  0.400 0.16 0.36    0.45
    m2B: c2          -0.905 0.97 1.99    0.49
    m2C: c2          -0.081 0.55 1.24    0.44
    D_m2_id[1,1]      1.335 0.14 0.47    0.29
    
    $m3a
                     est    MCSE      SD MCSE/SD
    (Intercept)   -0.466   5.441 3.0e+01    0.18
    m1B           -0.049   0.020 9.0e-02    0.22
    m1C           -0.104   0.034 1.1e-01    0.31
    sigma_c1       0.649   0.011 5.9e-02    0.18
    D_c1_id[1,1] 912.462 653.977 3.6e+03    0.18
    
    $m3b
                     est   MCSE    SD MCSE/SD
    (Intercept)   0.2177 0.0579 0.108    0.53
    m2B           0.1521 0.0549 0.102    0.54
    m2C          -0.0046 0.0680 0.129    0.53
    sigma_c1      0.6151 0.0041 0.022    0.18
    D_c1_id[1,1]  0.1187 0.0061 0.027    0.22
    
    $m4a
                             est MCSE    SD MCSE/SD
    m1B: (Intercept)      -1.615 1.71  4.17    0.41
    m1B: M22              -0.024 0.33  0.57    0.57
    m1B: M23              -0.424 0.40  0.72    0.55
    m1B: M24               0.024 0.25  0.50    0.51
    m1B: abs(C1 - C2)      0.174 0.22  0.60    0.37
    m1B: log(C1)          -4.662 5.82 13.76    0.42
    m1C: (Intercept)       3.793 0.88  3.26    0.27
    m1C: M22               0.255 0.15  0.39    0.39
    m1C: M23               0.467 0.17  0.44    0.39
    m1C: M24               0.312 0.16  0.56    0.29
    m1C: abs(C1 - C2)     -0.219 0.18  0.35    0.50
    m1C: log(C1)          12.210 2.91 10.37    0.28
    m1B: m2B               0.421 0.15  0.46    0.33
    m1B: m2C              -0.052 0.30  0.64    0.46
    m1B: m2B:abs(C1 - C2) -0.125 0.20  0.38    0.53
    m1B: m2C:abs(C1 - C2)  0.168 0.22  0.61    0.36
    m1C: m2B              -0.047 0.21  0.41    0.50
    m1C: m2C              -0.020 0.25  0.47    0.54
    m1C: m2B:abs(C1 - C2)  0.013 0.16  0.39    0.41
    m1C: m2C:abs(C1 - C2) -0.141 0.19  0.37    0.51
    D_m1_id[1,1]           1.237 0.14  0.51    0.27
    
    $m4b
                                                                      est  MCSE
    m1B: (Intercept)                                                -2.53 1.117
    m1B: abs(C1 - C2)                                                0.44 0.059
    m1B: log(C1)                                                    -6.71 4.251
    m1C: (Intercept)                                                 2.77 0.823
    m1C: abs(C1 - C2)                                                0.11 0.104
    m1C: log(C1)                                                     9.35 2.853
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.77 0.320
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.43 0.095
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.79 0.145
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.59 0.098
    D_m1_id[1,1]                                                     1.20 0.116
                                                                       SD MCSE/SD
    m1B: (Intercept)                                                 2.72    0.41
    m1B: abs(C1 - C2)                                                0.32    0.18
    m1B: log(C1)                                                     8.96    0.47
    m1C: (Intercept)                                                 2.98    0.28
    m1C: abs(C1 - C2)                                                0.36    0.28
    m1C: log(C1)                                                     9.97    0.29
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.66    0.49
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.30    0.32
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.48    0.30
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.25    0.40
    D_m1_id[1,1]                                                     0.39    0.30
    
    $m4c
                          est   MCSE     SD MCSE/SD
    m1B: (Intercept)  6.78786 3.0247  8.105   0.373
    m1B: C1          -9.43869 3.9960 10.818   0.369
    m1B: B21         -0.27735 0.1208  0.251   0.481
    m1C: (Intercept) -7.49582 1.4613  6.524   0.224
    m1C: C1          10.16016 1.9471  8.722   0.223
    m1C: B21         -0.08248 0.0614  0.168   0.366
    m1B: time         0.26975 0.0179  0.098   0.183
    m1B: c1          -0.13242 0.0462  0.253   0.183
    m1C: time         0.08408 0.0367  0.111   0.332
    m1C: c1          -0.32869 0.0183  0.274   0.067
    D_m1_id[1,1]      0.34880 0.1071  0.129   0.832
    D_m1_id[1,2]     -0.06185 0.0298  0.063   0.474
    D_m1_id[2,2]      0.31823 0.0262  0.061   0.429
    D_m1_id[1,3]     -0.07573 0.0227  0.061   0.369
    D_m1_id[2,3]      0.00601 0.0850  0.101   0.845
    D_m1_id[3,3]      0.31612 0.0332  0.066   0.501
    D_m1_id[1,4]      0.00072 0.0132  0.049   0.270
    D_m1_id[2,4]      0.02577 0.0352  0.065   0.545
    D_m1_id[3,4]     -0.12770 0.0067  0.037   0.183
    D_m1_id[4,4]      0.27225 0.0207  0.068   0.305
    
    $m4d
                          est  MCSE     SD MCSE/SD
    m1B: (Intercept)   0.2172 1.697  7.575    0.22
    m1B: C1           -0.7519 2.229 10.048    0.22
    m1C: (Intercept) -16.4435 1.572  7.628    0.21
    m1C: C1           22.6408 2.100 10.183    0.21
    m1B: time          0.5699 0.222  0.367    0.61
    m1B: I(time^2)    -0.0081 0.017  0.038    0.43
    m1B: b21          -0.6720 0.202  0.558    0.36
    m1B: c1           -0.4231 0.042  0.227    0.18
    m1B: C1:time      -0.3386 0.111  0.469    0.24
    m1B: b21:c1        0.5773 0.168  0.715    0.23
    m1C: time          0.1560 0.018  0.098    0.18
    m1C: I(time^2)     0.0462 0.014  0.037    0.38
    m1C: b21          -0.2777 0.247  0.522    0.47
    m1C: c1                NA    NA  0.237      NA
    m1C: C1:time      -0.4124 0.064  0.271    0.24
    m1C: b21:c1        0.8070 0.239  0.694    0.34
    D_m1_id[1,1]       0.5406 0.132  0.226    0.58
    D_m1_id[1,2]       0.0221 0.027  0.071    0.37
    D_m1_id[2,2]       0.3882 0.054  0.109    0.49
    
    $m4e
                          est   MCSE     SD MCSE/SD
    m1B: (Intercept)   2.8445 1.9713  7.569    0.26
    m1B: C1           -3.6499 2.7791 10.493    0.26
    m1C: (Intercept) -11.2629 2.5293  5.295    0.48
    m1C: C1           15.8672 3.4626  7.202    0.48
    m1B: log(time)     0.0665 0.0368  0.112    0.33
    m1B: I(time^2)     0.0258 0.0039  0.021    0.18
    m1B: p1           -0.0181 0.0373  0.080    0.47
    m1C: log(time)     0.1054 0.0733  0.178    0.41
    m1C: I(time^2)    -0.0057 0.0049  0.021    0.24
    m1C: p1           -0.0647 0.0260  0.079    0.33
    D_m1_id[1,1]       1.6475 0.1791  0.611    0.29
    

# summary output remained the same

    
    Call:
    mlogitmm_imp(fixed = m1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept) 
         0.3542      0.2155 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.754
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept) 
         0.3036      0.4631 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.148
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
        -0.2859      0.7142    -16.9260     23.0244 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.744
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
          7.130      -9.197       4.728      -5.724 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.961
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
        0.18840     0.07134    -0.17907    -0.41182 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.026
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
        0.04957     0.29259     0.62664     0.19197 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)      0.9977
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
        0.26963    -0.09787     0.32860     0.24667 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.72
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
       0.266268    0.008614    0.460859    0.104304 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.569
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
       0.351895    0.014132    0.889566   -0.009624 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.308
    
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
        0.09605     0.39987    -0.90490    -0.08109 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.335
    
    
    Call:
    lme_imp(fixed = c1 ~ m1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m1B         m1C 
       -0.46554    -0.04946    -0.10422 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       912.5
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6486 
    
    Call:
    lme_imp(fixed = c1 ~ m2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m2B         m2C 
       0.217693    0.152093   -0.004563 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)      0.1187
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6151 
    
    Call:
    mlogitmm_imp(fixed = m1 ~ M2 + m2 * abs(C1 - C2) + log(C1) + 
        (1 | id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
         (Intercept)              M22              M23              M24 
            -1.61549         -0.02412         -0.42373          0.02392 
        abs(C1 - C2)          log(C1)      (Intercept)              M22 
             0.17397         -4.66234          3.79296          0.25534 
                 M23              M24     abs(C1 - C2)          log(C1) 
             0.46730          0.31175         -0.21891         12.21032 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
             0.42144         -0.05205         -0.12520          0.16815 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
            -0.04730         -0.01962          0.01258         -0.14073 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.237
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ ifelse(as.numeric(m2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1) + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
                                                   (Intercept) 
                                                       -2.5326 
                                                  abs(C1 - C2) 
                                                        0.4399 
                                                       log(C1) 
                                                       -6.7129 
                                                   (Intercept) 
                                                        2.7694 
                                                  abs(C1 - C2) 
                                                        0.1133 
                                                       log(C1) 
                                                        9.3549 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                        0.7697 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                       -0.4305 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                        0.7868 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                       -0.5922 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.204
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ time + c1 + C1 + B2 + (c1 * time | 
        id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020, 
        warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1         B21 (Intercept)          C1         B21 
        6.78786    -9.43869    -0.27735    -7.49582    10.16016    -0.08248 
           time          c1        time          c1 
        0.26975    -0.13242     0.08408    -0.32869 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)        c1      time    c1:time
    (Intercept)   0.3488030 -0.061853 -0.075731  0.0007246
    c1           -0.0618534  0.318229  0.006009  0.0257717
    time         -0.0757307  0.006009  0.316116 -0.1276967
    c1:time       0.0007246  0.025772 -0.127697  0.2722492
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 * time + I(time^2) + b2 * c1, data = longDF, 
        random = ~time | id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1        time   I(time^2) 
       0.217190   -0.751918  -16.443502   22.640827    0.569944   -0.008085 
            b21          c1     C1:time      b21:c1        time   I(time^2) 
      -0.672005   -0.423086   -0.338606    0.577281    0.156041    0.046249 
            b21          c1     C1:time      b21:c1 
      -0.277696   -0.650702   -0.412423    0.807046 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)    time
    (Intercept)     0.54060 0.02208
    time            0.02208 0.38823
    
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + log(time) + I(time^2) + p1, data = longDF, 
        random = ~1 | id, n.adapt = 5, n.iter = 10, shrinkage = "ridge", 
        seed = 2020, parallel = TRUE, n.cores = 2)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1   log(time)   I(time^2) 
       2.844494   -3.649859  -11.262894   15.867187    0.066528    0.025847 
             p1   log(time)   I(time^2)          p1 
      -0.018139    0.105442   -0.005714   -0.064699 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.647
    
    $m0a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept) 
         0.3542      0.2155 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.754
    
    
    $m0b
    
    Call:
    mlogitmm_imp(fixed = m2 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept) 
         0.3036      0.4631 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.148
    
    
    $m1a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
        -0.2859      0.7142    -16.9260     23.0244 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.744
    
    
    $m1b
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1 
          7.130      -9.197       4.728      -5.724 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.961
    
    
    $m1c
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
        0.18840     0.07134    -0.17907    -0.41182 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.026
    
    
    $m1d
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c1          c1 
        0.04957     0.29259     0.62664     0.19197 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)      0.9977
    
    
    $m2a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
        0.26963    -0.09787     0.32860     0.24667 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.72
    
    
    $m2b
    
    Call:
    mlogitmm_imp(fixed = m2 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept)          C2 (Intercept)          C2 
       0.266268    0.008614    0.460859    0.104304 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.569
    
    
    $m2c
    
    Call:
    mlogitmm_imp(fixed = m1 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
       0.351895    0.014132    0.889566   -0.009624 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.308
    
    
    $m2d
    
    Call:
    mlogitmm_imp(fixed = m2 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m2" 
    
    Fixed effects:
    (Intercept) (Intercept)          c2          c2 
        0.09605     0.39987    -0.90490    -0.08109 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.335
    
    
    $m3a
    
    Call:
    lme_imp(fixed = c1 ~ m1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m1B         m1C 
       -0.46554    -0.04946    -0.10422 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       912.5
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6486 
    
    $m3b
    
    Call:
    lme_imp(fixed = c1 ~ m2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         m2B         m2C 
       0.217693    0.152093   -0.004563 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)      0.1187
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6151 
    
    $m4a
    
    Call:
    mlogitmm_imp(fixed = m1 ~ M2 + m2 * abs(C1 - C2) + log(C1) + 
        (1 | id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
         (Intercept)              M22              M23              M24 
            -1.61549         -0.02412         -0.42373          0.02392 
        abs(C1 - C2)          log(C1)      (Intercept)              M22 
             0.17397         -4.66234          3.79296          0.25534 
                 M23              M24     abs(C1 - C2)          log(C1) 
             0.46730          0.31175         -0.21891         12.21032 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
             0.42144         -0.05205         -0.12520          0.16815 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
            -0.04730         -0.01962          0.01258         -0.14073 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.237
    
    
    $m4b
    
    Call:
    mlogitmm_imp(fixed = m1 ~ ifelse(as.numeric(m2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1) + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
                                                   (Intercept) 
                                                       -2.5326 
                                                  abs(C1 - C2) 
                                                        0.4399 
                                                       log(C1) 
                                                       -6.7129 
                                                   (Intercept) 
                                                        2.7694 
                                                  abs(C1 - C2) 
                                                        0.1133 
                                                       log(C1) 
                                                        9.3549 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                        0.7697 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                       -0.4305 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                        0.7868 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                       -0.5922 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.204
    
    
    $m4c
    
    Call:
    mlogitmm_imp(fixed = m1 ~ time + c1 + C1 + B2 + (c1 * time | 
        id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020, 
        warn = FALSE)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1         B21 (Intercept)          C1         B21 
        6.78786    -9.43869    -0.27735    -7.49582    10.16016    -0.08248 
           time          c1        time          c1 
        0.26975    -0.13242     0.08408    -0.32869 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)        c1      time    c1:time
    (Intercept)   0.3488030 -0.061853 -0.075731  0.0007246
    c1           -0.0618534  0.318229  0.006009  0.0257717
    time         -0.0757307  0.006009  0.316116 -0.1276967
    c1:time       0.0007246  0.025772 -0.127697  0.2722492
    
    
    $m4d
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 * time + I(time^2) + b2 * c1, data = longDF, 
        random = ~time | id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1        time   I(time^2) 
       0.217190   -0.751918  -16.443502   22.640827    0.569944   -0.008085 
            b21          c1     C1:time      b21:c1        time   I(time^2) 
      -0.672005   -0.423086   -0.338606    0.577281    0.156041    0.046249 
            b21          c1     C1:time      b21:c1 
      -0.277696   -0.650702   -0.412423    0.807046 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)    time
    (Intercept)     0.54060 0.02208
    time            0.02208 0.38823
    
    
    $m4e
    
    Call:
    mlogitmm_imp(fixed = m1 ~ C1 + log(time) + I(time^2) + p1, data = longDF, 
        random = ~1 | id, n.adapt = 5, n.iter = 10, shrinkage = "ridge", 
        seed = 2020, parallel = TRUE, n.cores = 2)
    
     Bayesian multinomial logit mixed model for "m1" 
    
    Fixed effects:
    (Intercept)          C1 (Intercept)          C1   log(time)   I(time^2) 
       2.844494   -3.649859  -11.262894   15.867187    0.066528    0.025847 
             p1   log(time)   I(time^2)          p1 
      -0.018139    0.105442   -0.005714   -0.064699 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.647
    
    

---

    $m0a
    $m0a$m1
    (Intercept) (Intercept) 
      0.3542453   0.2154708 
    
    
    $m0b
    $m0b$m2
    (Intercept) (Intercept) 
      0.3035747   0.4630791 
    
    
    $m1a
    $m1a$m1
    (Intercept)          C1 (Intercept)          C1 
     -0.2858827   0.7141809 -16.9260155  23.0244114 
    
    
    $m1b
    $m1b$m2
    (Intercept)          C1 (Intercept)          C1 
       7.130387   -9.197116    4.728020   -5.724413 
    
    
    $m1c
    $m1c$m1
    (Intercept) (Intercept)          c1          c1 
     0.18839846  0.07133715 -0.17906885 -0.41182435 
    
    
    $m1d
    $m1d$m2
    (Intercept) (Intercept)          c1          c1 
     0.04957115  0.29259229  0.62664310  0.19197135 
    
    
    $m2a
    $m2a$m1
    (Intercept)          C2 (Intercept)          C2 
     0.26962869 -0.09786995  0.32860498  0.24666926 
    
    
    $m2b
    $m2b$m2
    (Intercept)          C2 (Intercept)          C2 
    0.266267570 0.008614323 0.460858515 0.104304049 
    
    
    $m2c
    $m2c$m1
     (Intercept)  (Intercept)           c2           c2 
     0.351895115  0.014131775  0.889566128 -0.009624084 
    
    
    $m2d
    $m2d$m2
    (Intercept) (Intercept)          c2          c2 
     0.09605166  0.39987272 -0.90489774 -0.08109253 
    
    
    $m3a
    $m3a$c1
    (Intercept)         m1B         m1C 
    -0.46553966 -0.04945722 -0.10422332 
    
    
    $m3b
    $m3b$c1
     (Intercept)          m2B          m2C 
     0.217693096  0.152093174 -0.004563397 
    
    
    $m4a
    $m4a$m1
         (Intercept)              M22              M23              M24 
         -1.61549140      -0.02412358      -0.42373186       0.02391670 
        abs(C1 - C2)          log(C1)      (Intercept)              M22 
          0.17396985      -4.66234259       3.79296391       0.25533735 
                 M23              M24     abs(C1 - C2)          log(C1) 
          0.46729596       0.31174547      -0.21890536      12.21032262 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
          0.42144169      -0.05205009      -0.12519803       0.16814842 
                 m2B              m2C m2B:abs(C1 - C2) m2C:abs(C1 - C2) 
         -0.04729858      -0.01962095       0.01257931      -0.14073116 
    
    
    $m4b
    $m4b$m1
                                                   (Intercept) 
                                                    -2.5325765 
                                                  abs(C1 - C2) 
                                                     0.4399245 
                                                       log(C1) 
                                                    -6.7129481 
                                                   (Intercept) 
                                                     2.7693739 
                                                  abs(C1 - C2) 
                                                     0.1133290 
                                                       log(C1) 
                                                     9.3549030 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                     0.7696937 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                    -0.4304683 
                 ifelse(as.numeric(m2) > as.numeric(M1), 1, 0) 
                                                     0.7868088 
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                    -0.5922248 
    
    
    $m4c
    $m4c$m1
    (Intercept)          C1         B21 (Intercept)          C1         B21 
     6.78786418 -9.43868952 -0.27735413 -7.49581740 10.16016437 -0.08247902 
           time          c1        time          c1 
     0.26975498 -0.13241632  0.08408243 -0.32868559 
    
    
    $m4d
    $m4d$m1
      (Intercept)            C1   (Intercept)            C1          time 
      0.217190062  -0.751917877 -16.443502092  22.640826747   0.569944274 
        I(time^2)           b21            c1       C1:time        b21:c1 
     -0.008085148  -0.672005081  -0.423086046  -0.338605892   0.577281309 
             time     I(time^2)           b21            c1       C1:time 
      0.156040790   0.046249136  -0.277695927  -0.650702153  -0.412423378 
           b21:c1 
      0.807045606 
    
    
    $m4e
    $m4e$m1
      (Intercept)            C1   (Intercept)            C1     log(time) 
      2.844494397  -3.649858558 -11.262893929  15.867186732   0.066528451 
        I(time^2)            p1     log(time)     I(time^2)            p1 
      0.025846903  -0.018138700   0.105441586  -0.005713525  -0.064699026 
    
    

---

    $m0a
    $m0a$m1
                       2.5%     97.5%
    (Intercept) -0.06316343 0.7214487
    (Intercept) -0.12353814 0.6788072
    
    
    $m0b
    $m0b$m2
                      2.5%     97.5%
    (Intercept) -0.2153658 0.6664625
    (Intercept) -0.1561300 0.7877159
    
    
    $m1a
    $m1a$m1
                      2.5%     97.5%
    (Intercept) -14.903977 10.892567
    C1          -14.467401 20.429750
    (Intercept) -31.271942 -3.504324
    C1            4.642985 42.080985
    
    
    $m1b
    $m1b$m2
                     2.5%    97.5%
    (Intercept)  -9.50314 28.61834
    C1          -38.66262 13.28645
    (Intercept) -16.87839 23.97285
    C1          -32.30911 23.38421
    
    
    $m1c
    $m1c$m1
                       2.5%       97.5%
    (Intercept) -0.06088719  0.56233004
    (Intercept) -0.26153541  0.58110327
    c1          -0.48817954  0.13823515
    c1          -0.77685168 -0.04141497
    
    
    $m1d
    $m1d$m2
                       2.5%     97.5%
    (Intercept) -0.31477095 0.3782127
    (Intercept)  0.05655426 0.5287541
    c1           0.11676860 1.2178605
    c1          -0.23922558 0.6314370
    
    
    $m2a
    $m2a$m1
                       2.5%     97.5%
    (Intercept) -0.10015516 0.8187634
    C2          -0.60829535 0.3780664
    (Intercept) -0.09566229 0.7671042
    C2          -0.30159985 0.6311437
    
    
    $m2b
    $m2b$m2
                       2.5%     97.5%
    (Intercept) -0.17743960 0.7752542
    C2          -0.67883547 0.6211233
    (Intercept) -0.05272318 1.0119275
    C2          -0.39028056 0.6321929
    
    
    $m2c
    $m2c$m1
                      2.5%     97.5%
    (Intercept) -0.2104912 0.9197156
    (Intercept) -0.7239983 0.5002189
    c2          -1.1865999 3.0707653
    c2          -2.0906338 1.9258559
    
    
    $m2d
    $m2d$m2
                      2.5%     97.5%
    (Intercept) -0.7993114 0.8260135
    (Intercept) -0.1903624 0.9252156
    c2          -4.1287761 2.4548271
    c2          -2.0161370 2.0466504
    
    
    $m3a
    $m3a$c1
                       2.5%       97.5%
    (Intercept) -38.3089110 38.14132495
    m1B          -0.2224455  0.10336049
    m1C          -0.2964888  0.08804854
    
    
    $m3b
    $m3b$c1
                       2.5%     97.5%
    (Intercept)  0.07715407 0.4281611
    m2B         -0.07356971 0.2753252
    m2C         -0.24623955 0.1801688
    
    
    $m4a
    $m4a$m1
                            2.5%      97.5%
    (Intercept)       -8.6165138  3.9349036
    M22               -0.9434256  0.7821816
    M23               -1.6033785  0.5011628
    M24               -0.7537041  0.8924411
    abs(C1 - C2)      -0.9254833  1.1636246
    log(C1)          -30.5185860 13.3781566
    (Intercept)       -2.6011981  8.7599720
    M22               -0.3958306  0.9155968
    M23               -0.2435775  1.3485195
    M24               -0.7577968  1.2619447
    abs(C1 - C2)      -1.0285074  0.3625021
    log(C1)           -7.7741357 28.2110021
    m2B               -0.4388267  1.1674639
    m2C               -0.9705549  0.6839786
    m2B:abs(C1 - C2)  -0.6866045  0.3552610
    m2C:abs(C1 - C2)  -0.6950720  1.2472781
    m2B               -0.6338127  0.6098406
    m2C               -0.5532896  0.8695153
    m2B:abs(C1 - C2)  -0.4432718  0.7640115
    m2C:abs(C1 - C2)  -0.6478418  0.5831362
    
    
    $m4b
    $m4b$m1
                                                                       2.5%
    (Intercept)                                                 -7.95661586
    abs(C1 - C2)                                                -0.02279616
    log(C1)                                                    -24.59801464
    (Intercept)                                                 -2.03625772
    abs(C1 - C2)                                                -0.30943190
    log(C1)                                                     -7.56930514
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.14706020
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -1.09171982
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.12566208
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.95729419
                                                                      97.5%
    (Intercept)                                                 1.199320686
    abs(C1 - C2)                                                0.913858892
    log(C1)                                                     6.101188369
    (Intercept)                                                 8.584259047
    abs(C1 - C2)                                                0.937074531
    log(C1)                                                    30.632693182
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               2.092950744
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.008854472
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               1.729885232
    ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.085649949
    
    
    $m4c
    $m4c$m1
                        2.5%      97.5%
    (Intercept) -11.22315566 18.4194436
    C1          -25.40855592 14.4016373
    B21          -0.76518650  0.0675754
    (Intercept) -18.21531440  4.5085338
    C1           -6.59188834 25.1939633
    B21          -0.42888377  0.1648211
    time          0.08690913  0.4506674
    c1           -0.66971377  0.1334354
    time         -0.09449535  0.2773993
    c1           -0.74960535  0.2706338
    
    
    $m4d
    $m4d$m1
                         2.5%       97.5%
    (Intercept) -13.001683536 10.81145195
    C1          -14.578720457 16.58480439
    (Intercept) -27.556712941 -4.14671915
    C1            6.525287627 37.43634838
    time          0.039062325  1.06067446
    I(time^2)    -0.066380904  0.06172971
    b21          -1.573184519  0.32511307
    c1           -0.747324234  0.01672333
    C1:time      -1.223313345  0.46860358
    b21:c1       -0.514288950  1.79396416
    time         -0.055306982  0.31003834
    I(time^2)    -0.008852696  0.11838744
    b21          -1.195275791  0.63100856
    c1           -1.060702492 -0.25494552
    C1:time      -0.888163707 -0.03794932
    b21:c1       -0.305079045  1.86436912
    
    
    $m4e
    $m4e$m1
                         2.5%       97.5%
    (Intercept) -11.945919272 13.49418937
    C1          -18.347356468 17.19591993
    (Intercept) -22.038214288 -2.82057468
    C1            4.427527123 30.59338563
    log(time)    -0.077314518  0.28445202
    I(time^2)    -0.002160007  0.06915515
    p1           -0.138509754  0.14156621
    log(time)    -0.234007465  0.43692023
    I(time^2)    -0.046719876  0.02989787
    p1           -0.230719769  0.06645028
    
    

---

    $m0a
    
    Bayesian multinomial logit mixed model fitted with JointAI
    
    Call:
    mlogitmm_imp(fixed = m1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                      Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept) 0.354 0.233 -0.0632 0.721      0.133    3.96  0.349
    m1C: (Intercept) 0.215 0.240 -0.1235 0.679      0.400    4.39  0.360
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.75 0.642 0.613  2.72               2.24  0.183
    
    
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
    m2B: (Intercept) 0.304 0.256 -0.215 0.666      0.333    2.25  0.178
    m2C: (Intercept) 0.463 0.269 -0.156 0.788      0.133    2.55  0.247
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 1.15 0.482 0.587  2.14               3.78  0.496
    
    
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
    m1B: (Intercept)  -0.286  7.97 -14.90  10.9      0.867    4.39  0.484
    m1B: C1            0.714 10.80 -14.47  20.4      0.867    4.34  0.483
    m1C: (Intercept) -16.926  8.46 -31.27  -3.5      0.000    3.69  0.464
    m1C: C1           23.024 11.48   4.64  42.1      0.000    3.68  0.463
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.74 0.914 0.606  3.86               2.19  0.474
    
    
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
    m2B: (Intercept)  7.13  9.78  -9.5  28.6      0.467    1.06  0.312
    m2B: C1          -9.20 13.31 -38.7  13.3      0.533    1.04  0.313
    m2C: (Intercept)  4.73 10.24 -16.9  24.0      0.600    1.74  0.183
    m2C: C1          -5.72 13.81 -32.3  23.4      0.667    1.66  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 1.96 0.916 0.669  3.56               8.29  0.551
    
    
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
                        Mean    SD    2.5%   97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)  0.1884 0.189 -0.0609  0.5623      0.333    4.28  0.656
    m1C: (Intercept)  0.0713 0.236 -0.2615  0.5811      0.800    4.00  0.491
    m1B: c1          -0.1791 0.205 -0.4882  0.1382      0.467    1.81  0.183
    m1C: c1          -0.4118 0.180 -0.7769 -0.0414      0.000    2.21  0.216
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 2.03 1.07 1.09  4.66               5.74  0.535
    
    
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
    m2B: (Intercept) 0.0496 0.187 -0.3148 0.378      0.667    1.69  0.348
    m2C: (Intercept) 0.2926 0.153  0.0566 0.529      0.000    1.42  0.320
    m2B: c1          0.6266 0.306  0.1168 1.218      0.000    3.27  0.227
    m2C: c1          0.1920 0.266 -0.2392 0.631      0.600    1.83  0.183
    
    Posterior summary of random effects covariance matrix:
                  Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 0.998 0.411 0.438  1.96               2.61  0.414
    
    
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
    m1B: (Intercept)  0.2696 0.260 -0.1002 0.819      0.267    1.97       
    m1B: C2          -0.0979 0.277 -0.6083 0.378      0.733    2.37  0.299
    m1C: (Intercept)  0.3286 0.274 -0.0957 0.767      0.267    1.54  0.252
    m1C: C2           0.2467 0.262 -0.3016 0.631      0.333    1.84  0.256
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.72 0.675 0.812  3.24               1.99  0.326
    
    
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
                        Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    m2B: (Intercept) 0.26627 0.315 -0.1774 0.775      0.533    5.45  0.558
    m2B: C2          0.00861 0.417 -0.6788 0.621      0.867    3.31  0.543
    m2C: (Intercept) 0.46086 0.286 -0.0527 1.012      0.133    3.60  0.336
    m2C: C2          0.10430 0.306 -0.3903 0.632      0.933    2.19  0.311
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 1.57 0.823 0.596  3.46                4.6  0.521
    
    
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
    m1B: (Intercept)  0.35190 0.364 -0.210  0.92      0.400    4.83  0.480
    m1C: (Intercept)  0.01413 0.389 -0.724  0.50      1.000    4.81  0.356
    m1B: c2           0.88957 1.172 -1.187  3.07      0.467    3.41  0.409
    m1C: c2          -0.00962 1.343 -2.091  1.93      0.933    6.12  0.463
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.31 0.615 0.498   2.7               2.34  0.432
    
    
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
    m2B: (Intercept)  0.0961 0.509 -0.799 0.826      0.733    2.98  0.357
    m2C: (Intercept)  0.3999 0.362 -0.190 0.925      0.467    2.81  0.447
    m2B: c2          -0.9049 1.987 -4.129 2.455      0.667    1.72  0.488
    m2C: c2          -0.0811 1.239 -2.016 2.047      1.000    1.22  0.441
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m2_id[1,1] 1.33 0.466 0.762  2.53               1.53  0.292
    
    
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
                   Mean      SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    (Intercept) -0.4655 29.7990 -38.309 38.141      0.333    1.63  0.183
    m1B         -0.0495  0.0898  -0.222  0.103      0.533    2.26  0.220
    m1C         -0.1042  0.1096  -0.296  0.088      0.267    3.31  0.310
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_c1_id[1,1]  912 3582 0.0559 11871               1.46  0.183
    
    Posterior summary of residual std. deviation:
              Mean     SD  2.5% 97.5% GR-crit MCE/SD
    sigma_c1 0.649 0.0588 0.584 0.811   0.976  0.183
    
    
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
    (Intercept)  0.21769 0.108  0.0772 0.428      0.000    5.18  0.533
    m2B          0.15209 0.102 -0.0736 0.275      0.200    4.13  0.540
    m2C         -0.00456 0.129 -0.2462 0.180      0.867    3.82  0.527
    
    Posterior summary of random effects covariance matrix:
                  Mean     SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_c1_id[1,1] 0.119 0.0274 0.0846 0.189               2.01  0.224
    
    Posterior summary of residual std. deviation:
              Mean     SD  2.5% 97.5% GR-crit MCE/SD
    sigma_c1 0.615 0.0224 0.574 0.651    1.37  0.183
    
    
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
                             Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)      -1.6155  4.169  -8.617  3.935      0.800    6.60  0.410
    m1B: M22              -0.0241  0.574  -0.943  0.782      0.800    2.52  0.572
    m1B: M23              -0.4237  0.724  -1.603  0.501      0.733    7.23  0.547
    m1B: M24               0.0239  0.496  -0.754  0.892      1.000    3.93  0.507
    m1B: abs(C1 - C2)      0.1740  0.601  -0.925  1.164      0.733    4.07  0.367
    m1B: log(C1)          -4.6623 13.761 -30.519 13.378      0.800    6.20  0.423
    m1C: (Intercept)       3.7930  3.258  -2.601  8.760      0.333    4.45  0.271
    m1C: M22               0.2553  0.390  -0.396  0.916      0.533    1.95  0.386
    m1C: M23               0.4673  0.443  -0.244  1.349      0.333    1.48  0.392
    m1C: M24               0.3117  0.555  -0.758  1.262      0.533    2.31  0.295
    m1C: abs(C1 - C2)     -0.2189  0.351  -1.029  0.363      0.467    1.22  0.499
    m1C: log(C1)          12.2103 10.375  -7.774 28.211      0.333    5.18  0.281
    m1B: m2B               0.4214  0.456  -0.439  1.167      0.267    3.48  0.330
    m1B: m2C              -0.0521  0.640  -0.971  0.684      0.933   10.03  0.463
    m1B: m2B:abs(C1 - C2) -0.1252  0.379  -0.687  0.355      1.000    9.17  0.529
    m1B: m2C:abs(C1 - C2)  0.1681  0.605  -0.695  1.247      0.933    7.38  0.357
    m1C: m2B              -0.0473  0.414  -0.634  0.610      0.867    4.43  0.497
    m1C: m2C              -0.0196  0.470  -0.553  0.870      0.800    6.73  0.540
    m1C: m2B:abs(C1 - C2)  0.0126  0.386  -0.443  0.764      0.933    2.61  0.412
    m1C: m2C:abs(C1 - C2) -0.1407  0.373  -0.648  0.583      0.800    5.81  0.511
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.24 0.514 0.707  2.42               1.09  0.269
    
    
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
    m1B: (Intercept)                                                -2.533 2.722
    m1B: abs(C1 - C2)                                                0.440 0.321
    m1B: log(C1)                                                    -6.713 8.963
    m1C: (Intercept)                                                 2.769 2.975
    m1C: abs(C1 - C2)                                                0.113 0.365
    m1C: log(C1)                                                     9.355 9.975
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.770 0.660
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.430 0.303
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.787 0.481
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.592 0.246
                                                                        2.5%
    m1B: (Intercept)                                                 -7.9566
    m1B: abs(C1 - C2)                                                -0.0228
    m1B: log(C1)                                                    -24.5980
    m1C: (Intercept)                                                 -2.0363
    m1C: abs(C1 - C2)                                                -0.3094
    m1C: log(C1)                                                     -7.5693
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.1471
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -1.0917
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.1257
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.9573
                                                                       97.5%
    m1B: (Intercept)                                                 1.19932
    m1B: abs(C1 - C2)                                                0.91386
    m1B: log(C1)                                                     6.10119
    m1C: (Intercept)                                                 8.58426
    m1C: abs(C1 - C2)                                                0.93707
    m1C: log(C1)                                                    30.63269
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               2.09295
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.00885
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               1.72989
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.08565
                                                                    tail-prob.
    m1B: (Intercept)                                                    0.3333
    m1B: abs(C1 - C2)                                                   0.1333
    m1B: log(C1)                                                        0.4667
    m1C: (Intercept)                                                    0.3333
    m1C: abs(C1 - C2)                                                   1.0000
    m1C: log(C1)                                                        0.2667
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                  0.1333
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)     0.0667
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                  0.1333
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)     0.0000
                                                                    GR-crit MCE/SD
    m1B: (Intercept)                                                   4.25  0.410
    m1B: abs(C1 - C2)                                                  1.33  0.183
    m1B: log(C1)                                                       4.36  0.474
    m1C: (Intercept)                                                   3.05  0.277
    m1C: abs(C1 - C2)                                                  2.05  0.284
    m1C: log(C1)                                                       3.28  0.286
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                 3.00  0.485
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)    1.57  0.315
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)                 1.75  0.302
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)    1.60  0.398
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1]  1.2 0.386 0.615  1.92               1.01  0.302
    
    
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
                        Mean     SD     2.5%   97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)  6.7879  8.105 -11.2232 18.4194      0.333    1.48 0.3732
    m1B: C1          -9.4387 10.818 -25.4086 14.4016      0.333    1.47 0.3694
    m1B: B21         -0.2774  0.251  -0.7652  0.0676      0.267    4.63 0.4809
    m1C: (Intercept) -7.4958  6.524 -18.2153  4.5085      0.200    1.27 0.2240
    m1C: C1          10.1602  8.722  -6.5919 25.1940      0.200    1.24 0.2232
    m1C: B21         -0.0825  0.168  -0.4289  0.1648      0.667    2.34 0.3659
    m1B: time         0.2698  0.098   0.0869  0.4507      0.000    1.78 0.1826
    m1B: c1          -0.1324  0.253  -0.6697  0.1334      0.733    2.11 0.1826
    m1C: time         0.0841  0.111  -0.0945  0.2774      0.467    1.98 0.3319
    m1C: c1          -0.3287  0.274  -0.7496  0.2706      0.133    1.88 0.0666
    
    Posterior summary of random effects covariance matrix:
                      Mean     SD    2.5%   97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1]  0.348803 0.1287  0.1779  0.5945               8.22  0.832
    D_m1_id[1,2] -0.061853 0.0630 -0.1503  0.0435      0.400    3.88  0.474
    D_m1_id[2,2]  0.318229 0.0611  0.2215  0.4374               2.08  0.429
    D_m1_id[1,3] -0.075731 0.0615 -0.1941  0.0217      0.267    2.47  0.369
    D_m1_id[2,3]  0.006009 0.1006 -0.1259  0.1877      0.867   11.16  0.845
    D_m1_id[3,3]  0.316116 0.0662  0.2217  0.4308               4.41  0.501
    D_m1_id[1,4]  0.000725 0.0489 -0.0910  0.0983      0.933    1.54  0.270
    D_m1_id[2,4]  0.025772 0.0646 -0.0675  0.1348      0.667    5.83  0.545
    D_m1_id[3,4] -0.127697 0.0365 -0.2050 -0.0745      0.000    1.12  0.183
    D_m1_id[4,4]  0.272249 0.0677  0.1826  0.4210               4.55  0.305
    
    
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
                          Mean      SD      2.5%   97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)   0.21719  7.5747 -13.00168 10.8115     0.9333    1.30  0.224
    m1B: C1           -0.75192 10.0483 -14.57872 16.5848     0.9333    1.26  0.222
    m1C: (Intercept) -16.44350  7.6279 -27.55671 -4.1467     0.0667    1.47  0.206
    m1C: C1           22.64083 10.1834   6.52529 37.4363     0.0667    1.48  0.206
    m1B: time          0.56994  0.3667   0.03906  1.0607     0.0000   17.27  0.606
    m1B: I(time^2)    -0.00809  0.0381  -0.06638  0.0617     0.6667    2.08  0.433
    m1B: b21          -0.67201  0.5580  -1.57318  0.3251     0.2667    5.00  0.361
    m1B: c1           -0.42309  0.2274  -0.74732  0.0167     0.1333    1.74  0.183
    m1B: C1:time      -0.33861  0.4686  -1.22331  0.4686     0.4667    5.03  0.237
    m1B: b21:c1        0.57728  0.7145  -0.51429  1.7940     0.5333    1.90  0.235
    m1C: time          0.15604  0.0984  -0.05531  0.3100     0.1333    1.16  0.183
    m1C: I(time^2)     0.04625  0.0371  -0.00885  0.1184     0.1333    5.59  0.379
    m1C: b21          -0.27770  0.5223  -1.19528  0.6310     0.6000    3.53  0.473
    m1C: c1           -0.65070  0.2366  -1.06070 -0.2549     0.0000    1.99       
    m1C: C1:time      -0.41242  0.2713  -0.88816 -0.0379     0.0667    3.49  0.235
    m1C: b21:c1        0.80705  0.6943  -0.30508  1.8644     0.2000    2.54  0.344
    
    Posterior summary of random effects covariance matrix:
                   Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 0.5406 0.226  0.205 0.930              12.81  0.583
    D_m1_id[1,2] 0.0221 0.071 -0.103 0.176        0.8    3.15  0.374
    D_m1_id[2,2] 0.3882 0.109  0.231 0.599               4.94  0.491
    
    
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
                          Mean      SD      2.5%   97.5% tail-prob. GR-crit MCE/SD
    m1B: (Intercept)   2.84449  7.5689 -11.94592 13.4942      0.733    1.35  0.260
    m1B: C1           -3.64986 10.4931 -18.34736 17.1959      0.733    1.37  0.265
    m1C: (Intercept) -11.26289  5.2945 -22.03821 -2.8206      0.000    2.05  0.478
    m1C: C1           15.86719  7.2022   4.42753 30.5934      0.000    2.08  0.481
    m1B: log(time)     0.06653  0.1120  -0.07731  0.2845      0.800    1.60  0.329
    m1B: I(time^2)     0.02585  0.0213  -0.00216  0.0692      0.133    0.98  0.183
    m1B: p1           -0.01814  0.0797  -0.13851  0.1416      0.800    1.48  0.467
    m1C: log(time)     0.10544  0.1782  -0.23401  0.4369      0.467    1.64  0.411
    m1C: I(time^2)    -0.00571  0.0206  -0.04672  0.0299      0.933    1.05  0.238
    m1C: p1           -0.06470  0.0789  -0.23072  0.0665      0.533    1.92  0.330
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_m1_id[1,1] 1.65 0.611 0.643  2.87               3.79  0.293
    
    
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
    m1B: (Intercept) 0.3542453 0.2325335 -0.06316343 0.7214487  0.1333333 3.959152
    m1C: (Intercept) 0.2154708 0.2401154 -0.12353814 0.6788072  0.4000000 4.388061
                        MCE/SD
    m1B: (Intercept) 0.3485177
    m1C: (Intercept) 0.3598832
    
    
    $m0b
    $m0b$m2
                          Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    m2B: (Intercept) 0.3035747 0.2562136 -0.2153658 0.6664625  0.3333333 2.246159
    m2C: (Intercept) 0.4630791 0.2693313 -0.1561300 0.7877159  0.1333333 2.546514
                        MCE/SD
    m2B: (Intercept) 0.1779935
    m2C: (Intercept) 0.2474673
    
    
    $m1a
    $m1a$m1
                            Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    m1B: (Intercept)  -0.2858827  7.970955 -14.903977 10.892567  0.8666667 4.389922
    m1B: C1            0.7141809 10.804872 -14.467401 20.429750  0.8666667 4.335952
    m1C: (Intercept) -16.9260155  8.459568 -31.271942 -3.504324  0.0000000 3.694932
    m1C: C1           23.0244114 11.484281   4.642985 42.080985  0.0000000 3.676865
                        MCE/SD
    m1B: (Intercept) 0.4844836
    m1B: C1          0.4828153
    m1C: (Intercept) 0.4641552
    m1C: C1          0.4627977
    
    
    $m1b
    $m1b$m2
                          Mean        SD      2.5%    97.5% tail-prob.  GR-crit
    m2B: (Intercept)  7.130387  9.776657  -9.50314 28.61834  0.4666667 1.057514
    m2B: C1          -9.197116 13.310980 -38.66262 13.28645  0.5333333 1.038385
    m2C: (Intercept)  4.728020 10.235234 -16.87839 23.97285  0.6000000 1.735318
    m2C: C1          -5.724413 13.814231 -32.30911 23.38421  0.6666667 1.661638
                        MCE/SD
    m2B: (Intercept) 0.3118912
    m2B: C1          0.3132049
    m2C: (Intercept) 0.1825742
    m2C: C1          0.1825742
    
    
    $m1c
    $m1c$m1
                            Mean        SD        2.5%       97.5% tail-prob.
    m1B: (Intercept)  0.18839846 0.1888818 -0.06088719  0.56233004  0.3333333
    m1C: (Intercept)  0.07133715 0.2363949 -0.26153541  0.58110327  0.8000000
    m1B: c1          -0.17906885 0.2054499 -0.48817954  0.13823515  0.4666667
    m1C: c1          -0.41182435 0.1800433 -0.77685168 -0.04141497  0.0000000
                      GR-crit    MCE/SD
    m1B: (Intercept) 4.279962 0.6560639
    m1C: (Intercept) 4.000966 0.4905199
    m1B: c1          1.812915 0.1825742
    m1C: c1          2.206003 0.2163994
    
    
    $m1d
    $m1d$m2
                           Mean        SD        2.5%     97.5% tail-prob.  GR-crit
    m2B: (Intercept) 0.04957115 0.1868717 -0.31477095 0.3782127  0.6666667 1.688755
    m2C: (Intercept) 0.29259229 0.1532869  0.05655426 0.5287541  0.0000000 1.417005
    m2B: c1          0.62664310 0.3062373  0.11676860 1.2178605  0.0000000 3.270582
    m2C: c1          0.19197135 0.2660597 -0.23922558 0.6314370  0.6000000 1.829394
                        MCE/SD
    m2B: (Intercept) 0.3479438
    m2C: (Intercept) 0.3197492
    m2B: c1          0.2269502
    m2C: c1          0.1825742
    
    
    $m2a
    $m2a$m1
                            Mean        SD        2.5%     97.5% tail-prob.
    m1B: (Intercept)  0.26962869 0.2599868 -0.10015516 0.8187634  0.2666667
    m1B: C2          -0.09786995 0.2768676 -0.60829535 0.3780664  0.7333333
    m1C: (Intercept)  0.32860498 0.2735172 -0.09566229 0.7671042  0.2666667
    m1C: C2           0.24666926 0.2621385 -0.30159985 0.6311437  0.3333333
                      GR-crit    MCE/SD
    m1B: (Intercept) 1.969708        NA
    m1B: C2          2.366729 0.2994971
    m1C: (Intercept) 1.541473 0.2517044
    m1C: C2          1.835256 0.2559623
    
    
    $m2b
    $m2b$m2
                            Mean        SD        2.5%     97.5% tail-prob.
    m2B: (Intercept) 0.266267570 0.3147665 -0.17743960 0.7752542  0.5333333
    m2B: C2          0.008614323 0.4169842 -0.67883547 0.6211233  0.8666667
    m2C: (Intercept) 0.460858515 0.2855532 -0.05272318 1.0119275  0.1333333
    m2C: C2          0.104304049 0.3064412 -0.39028056 0.6321929  0.9333333
                      GR-crit    MCE/SD
    m2B: (Intercept) 5.452451 0.5580455
    m2B: C2          3.310707 0.5425015
    m2C: (Intercept) 3.604322 0.3359502
    m2C: C2          2.194529 0.3107771
    
    
    $m2c
    $m2c$m1
                             Mean        SD       2.5%     97.5% tail-prob.
    m1B: (Intercept)  0.351895115 0.3641964 -0.2104912 0.9197156  0.4000000
    m1C: (Intercept)  0.014131775 0.3885524 -0.7239983 0.5002189  1.0000000
    m1B: c2           0.889566128 1.1724299 -1.1865999 3.0707653  0.4666667
    m1C: c2          -0.009624084 1.3429823 -2.0906338 1.9258559  0.9333333
                      GR-crit    MCE/SD
    m1B: (Intercept) 4.829518 0.4795481
    m1C: (Intercept) 4.812305 0.3556333
    m1B: c2          3.406711 0.4092366
    m1C: c2          6.120453 0.4633726
    
    
    $m2d
    $m2d$m2
                            Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    m2B: (Intercept)  0.09605166 0.5089016 -0.7993114 0.8260135  0.7333333 2.983824
    m2C: (Intercept)  0.39987272 0.3619936 -0.1903624 0.9252156  0.4666667 2.810646
    m2B: c2          -0.90489774 1.9871058 -4.1287761 2.4548271  0.6666667 1.719917
    m2C: c2          -0.08109253 1.2390880 -2.0161370 2.0466504  1.0000000 1.218848
                        MCE/SD
    m2B: (Intercept) 0.3574766
    m2C: (Intercept) 0.4471902
    m2B: c2          0.4882244
    m2C: c2          0.4406629
    
    
    $m3a
    $m3a$c1
                       Mean         SD        2.5%       97.5% tail-prob.  GR-crit
    (Intercept) -0.46553966 29.7990131 -38.3089110 38.14132495  0.3333333 1.630227
    m1B         -0.04945722  0.0897634  -0.2224455  0.10336049  0.5333333 2.255486
    m1C         -0.10422332  0.1095730  -0.2964888  0.08804854  0.2666667 3.306735
                   MCE/SD
    (Intercept) 0.1825742
    m1B         0.2204648
    m1C         0.3096155
    
    
    $m3b
    $m3b$c1
                        Mean        SD        2.5%     97.5% tail-prob.  GR-crit
    (Intercept)  0.217693096 0.1084866  0.07715407 0.4281611  0.0000000 5.179637
    m2B          0.152093174 0.1016593 -0.07356971 0.2753252  0.2000000 4.130288
    m2C         -0.004563397 0.1290130 -0.24623955 0.1801688  0.8666667 3.816069
                   MCE/SD
    (Intercept) 0.5333887
    m2B         0.5402131
    m2C         0.5269156
    
    
    $m4a
    $m4a$m1
                                 Mean         SD        2.5%      97.5% tail-prob.
    m1B: (Intercept)      -1.61549140  4.1686932  -8.6165138  3.9349036  0.8000000
    m1B: M22              -0.02412358  0.5736837  -0.9434256  0.7821816  0.8000000
    m1B: M23              -0.42373186  0.7241047  -1.6033785  0.5011628  0.7333333
    m1B: M24               0.02391670  0.4959440  -0.7537041  0.8924411  1.0000000
    m1B: abs(C1 - C2)      0.17396985  0.6013704  -0.9254833  1.1636246  0.7333333
    m1B: log(C1)          -4.66234259 13.7611168 -30.5185860 13.3781566  0.8000000
    m1C: (Intercept)       3.79296391  3.2583096  -2.6011981  8.7599720  0.3333333
    m1C: M22               0.25533735  0.3897525  -0.3958306  0.9155968  0.5333333
    m1C: M23               0.46729596  0.4434515  -0.2435775  1.3485195  0.3333333
    m1C: M24               0.31174547  0.5550251  -0.7577968  1.2619447  0.5333333
    m1C: abs(C1 - C2)     -0.21890536  0.3508320  -1.0285074  0.3625021  0.4666667
    m1C: log(C1)          12.21032262 10.3747901  -7.7741357 28.2110021  0.3333333
    m1B: m2B               0.42144169  0.4556905  -0.4388267  1.1674639  0.2666667
    m1B: m2C              -0.05205009  0.6403758  -0.9705549  0.6839786  0.9333333
    m1B: m2B:abs(C1 - C2) -0.12519803  0.3792674  -0.6866045  0.3552610  1.0000000
    m1B: m2C:abs(C1 - C2)  0.16814842  0.6050197  -0.6950720  1.2472781  0.9333333
    m1C: m2B              -0.04729858  0.4144526  -0.6338127  0.6098406  0.8666667
    m1C: m2C              -0.01962095  0.4700214  -0.5532896  0.8695153  0.8000000
    m1C: m2B:abs(C1 - C2)  0.01257931  0.3862802  -0.4432718  0.7640115  0.9333333
    m1C: m2C:abs(C1 - C2) -0.14073116  0.3734829  -0.6478418  0.5831362  0.8000000
                            GR-crit    MCE/SD
    m1B: (Intercept)       6.602775 0.4099760
    m1B: M22               2.523726 0.5716889
    m1B: M23               7.227265 0.5473728
    m1B: M24               3.928235 0.5066861
    m1B: abs(C1 - C2)      4.071585 0.3674939
    m1B: log(C1)           6.200443 0.4227931
    m1C: (Intercept)       4.449918 0.2711319
    m1C: M22               1.953841 0.3857426
    m1C: M23               1.483256 0.3923611
    m1C: M24               2.305332 0.2947794
    m1C: abs(C1 - C2)      1.222991 0.4988566
    m1C: log(C1)           5.181426 0.2806397
    m1B: m2B               3.482279 0.3297053
    m1B: m2C              10.027176 0.4626371
    m1B: m2B:abs(C1 - C2)  9.168613 0.5289996
    m1B: m2C:abs(C1 - C2)  7.381925 0.3565050
    m1C: m2B               4.432190 0.4967227
    m1C: m2C               6.726357 0.5402824
    m1C: m2B:abs(C1 - C2)  2.606886 0.4120060
    m1C: m2C:abs(C1 - C2)  5.813705 0.5114595
    
    
    $m4b
    $m4b$m1
                                                                          Mean
    m1B: (Intercept)                                                -2.5325765
    m1B: abs(C1 - C2)                                                0.4399245
    m1B: log(C1)                                                    -6.7129481
    m1C: (Intercept)                                                 2.7693739
    m1C: abs(C1 - C2)                                                0.1133290
    m1C: log(C1)                                                     9.3549030
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.7696937
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.4304683
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               0.7868088
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.5922248
                                                                           SD
    m1B: (Intercept)                                                2.7216681
    m1B: abs(C1 - C2)                                               0.3208269
    m1B: log(C1)                                                    8.9632712
    m1C: (Intercept)                                                2.9754056
    m1C: abs(C1 - C2)                                               0.3646304
    m1C: log(C1)                                                    9.9746422
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.6596442
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.3025533
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.4807649
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.2458338
                                                                            2.5%
    m1B: (Intercept)                                                 -7.95661586
    m1B: abs(C1 - C2)                                                -0.02279616
    m1B: log(C1)                                                    -24.59801464
    m1C: (Intercept)                                                 -2.03625772
    m1C: abs(C1 - C2)                                                -0.30943190
    m1C: log(C1)                                                     -7.56930514
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.14706020
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -1.09171982
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               -0.12566208
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.95729419
                                                                           97.5%
    m1B: (Intercept)                                                 1.199320686
    m1B: abs(C1 - C2)                                                0.913858892
    m1B: log(C1)                                                     6.101188369
    m1C: (Intercept)                                                 8.584259047
    m1C: abs(C1 - C2)                                                0.937074531
    m1C: log(C1)                                                    30.632693182
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               2.092950744
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.008854472
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)               1.729885232
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.085649949
                                                                    tail-prob.
    m1B: (Intercept)                                                0.33333333
    m1B: abs(C1 - C2)                                               0.13333333
    m1B: log(C1)                                                    0.46666667
    m1C: (Intercept)                                                0.33333333
    m1C: abs(C1 - C2)                                               1.00000000
    m1C: log(C1)                                                    0.26666667
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.13333333
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.06666667
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.13333333
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.00000000
                                                                     GR-crit
    m1B: (Intercept)                                                4.252643
    m1B: abs(C1 - C2)                                               1.330518
    m1B: log(C1)                                                    4.362916
    m1C: (Intercept)                                                3.054964
    m1C: abs(C1 - C2)                                               2.048452
    m1C: log(C1)                                                    3.276632
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              3.003340
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 1.566150
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              1.754301
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 1.604322
                                                                       MCE/SD
    m1B: (Intercept)                                                0.4103559
    m1B: abs(C1 - C2)                                               0.1825742
    m1B: log(C1)                                                    0.4743201
    m1C: (Intercept)                                                0.2767352
    m1C: abs(C1 - C2)                                               0.2841656
    m1C: log(C1)                                                    0.2860588
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.4854297
    m1B: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.3152185
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0)              0.3023900
    m1C: ifelse(as.numeric(m2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.3975079
    
    
    $m4c
    $m4c$m1
                            Mean          SD         2.5%      97.5% tail-prob.
    m1B: (Intercept)  6.78786418  8.10518058 -11.22315566 18.4194436  0.3333333
    m1B: C1          -9.43868952 10.81766940 -25.40855592 14.4016373  0.3333333
    m1B: B21         -0.27735413  0.25122111  -0.76518650  0.0675754  0.2666667
    m1C: (Intercept) -7.49581740  6.52445088 -18.21531440  4.5085338  0.2000000
    m1C: C1          10.16016437  8.72195776  -6.59188834 25.1939633  0.2000000
    m1C: B21         -0.08247902  0.16780377  -0.42888377  0.1648211  0.6666667
    m1B: time         0.26975498  0.09797599   0.08690913  0.4506674  0.0000000
    m1B: c1          -0.13241632  0.25311420  -0.66971377  0.1334354  0.7333333
    m1C: time         0.08408243  0.11051058  -0.09449535  0.2773993  0.4666667
    m1C: c1          -0.32868559  0.27417190  -0.74960535  0.2706338  0.1333333
                      GR-crit    MCE/SD
    m1B: (Intercept) 1.482642 0.3731817
    m1B: C1          1.470187 0.3693911
    m1B: B21         4.629197 0.4809379
    m1C: (Intercept) 1.267521 0.2239719
    m1C: C1          1.235786 0.2232367
    m1C: B21         2.338802 0.3659167
    m1B: time        1.783181 0.1825742
    m1B: c1          2.112947 0.1825742
    m1C: time        1.977207 0.3318518
    m1C: c1          1.880892 0.0665883
    
    
    $m4d
    $m4d$m1
                              Mean          SD          2.5%       97.5% tail-prob.
    m1B: (Intercept)   0.217190062  7.57467637 -13.001683536 10.81145195 0.93333333
    m1B: C1           -0.751917877 10.04831218 -14.578720457 16.58480439 0.93333333
    m1C: (Intercept) -16.443502092  7.62788210 -27.556712941 -4.14671915 0.06666667
    m1C: C1           22.640826747 10.18335835   6.525287627 37.43634838 0.06666667
    m1B: time          0.569944274  0.36670971   0.039062325  1.06067446 0.00000000
    m1B: I(time^2)    -0.008085148  0.03811758  -0.066380904  0.06172971 0.66666667
    m1B: b21          -0.672005081  0.55800395  -1.573184519  0.32511307 0.26666667
    m1B: c1           -0.423086046  0.22736510  -0.747324234  0.01672333 0.13333333
    m1B: C1:time      -0.338605892  0.46857133  -1.223313345  0.46860358 0.46666667
    m1B: b21:c1        0.577281309  0.71452311  -0.514288950  1.79396416 0.53333333
    m1C: time          0.156040790  0.09838243  -0.055306982  0.31003834 0.13333333
    m1C: I(time^2)     0.046249136  0.03708470  -0.008852696  0.11838744 0.13333333
    m1C: b21          -0.277695927  0.52225957  -1.195275791  0.63100856 0.60000000
    m1C: c1           -0.650702153  0.23662194  -1.060702492 -0.25494552 0.00000000
    m1C: C1:time      -0.412423378  0.27131780  -0.888163707 -0.03794932 0.06666667
    m1C: b21:c1        0.807045606  0.69427087  -0.305079045  1.86436912 0.20000000
                       GR-crit    MCE/SD
    m1B: (Intercept)  1.298498 0.2239791
    m1B: C1           1.263114 0.2218553
    m1C: (Intercept)  1.468530 0.2060224
    m1C: C1           1.482445 0.2062353
    m1B: time        17.265259 0.6055752
    m1B: I(time^2)    2.081501 0.4331582
    m1B: b21          4.996367 0.3612078
    m1B: c1           1.739778 0.1825742
    m1B: C1:time      5.031168 0.2370341
    m1B: b21:c1       1.896077 0.2345725
    m1C: time         1.164815 0.1825742
    m1C: I(time^2)    5.585538 0.3790127
    m1C: b21          3.530555 0.4729985
    m1C: c1           1.985206        NA
    m1C: C1:time      3.491703 0.2351351
    m1C: b21:c1       2.538411 0.3437827
    
    
    $m4e
    $m4e$m1
                              Mean          SD          2.5%       97.5% tail-prob.
    m1B: (Intercept)   2.844494397  7.56885863 -11.945919272 13.49418937  0.7333333
    m1B: C1           -3.649858558 10.49309219 -18.347356468 17.19591993  0.7333333
    m1C: (Intercept) -11.262893929  5.29450606 -22.038214288 -2.82057468  0.0000000
    m1C: C1           15.867186732  7.20222078   4.427527123 30.59338563  0.0000000
    m1B: log(time)     0.066528451  0.11195954  -0.077314518  0.28445202  0.8000000
    m1B: I(time^2)     0.025846903  0.02129080  -0.002160007  0.06915515  0.1333333
    m1B: p1           -0.018138700  0.07974689  -0.138509754  0.14156621  0.8000000
    m1C: log(time)     0.105441586  0.17823789  -0.234007465  0.43692023  0.4666667
    m1C: I(time^2)    -0.005713525  0.02062257  -0.046719876  0.02989787  0.9333333
    m1C: p1           -0.064699026  0.07893223  -0.230719769  0.06645028  0.5333333
                       GR-crit    MCE/SD
    m1B: (Intercept) 1.3519945 0.2604423
    m1B: C1          1.3709896 0.2648481
    m1C: (Intercept) 2.0486992 0.4777224
    m1C: C1          2.0815935 0.4807659
    m1B: log(time)   1.5957170 0.3289061
    m1B: I(time^2)   0.9802752 0.1825742
    m1B: p1          1.4839841 0.4671321
    m1C: log(time)   1.6377608 0.4110422
    m1C: I(time^2)   1.0452243 0.2382946
    m1C: p1          1.9232403 0.3299436
    
    

