# GRcrit and MCerror give same result

    $m0a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    gamma_O1[1]      1.513      2.393
    gamma_O1[2]      1.202      1.682
    gamma_O1[3]      0.951      0.996
    
    
    $m0b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    gamma_O2[1]      0.958       1.02
    gamma_O2[2]      1.043       1.28
    gamma_O2[3]      0.976       1.05
    
    
    $m1a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    gamma_O1[1]       1.90       3.19
    gamma_O1[2]       1.02       1.21
    gamma_O1[3]       1.04       1.28
    C1                1.05       1.24
    
    
    $m1b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    gamma_O2[1]       1.25       1.80
    gamma_O2[2]       1.05       1.29
    gamma_O2[3]       1.02       1.19
    C1                1.09       1.16
    
    
    $m2a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    gamma_O1[1]      1.105      1.565
    gamma_O1[2]      1.017      1.144
    gamma_O1[3]      0.947      0.961
    C2               1.054      1.101
    
    
    $m2b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    gamma_O2[1]       1.09       1.41
    gamma_O2[2]       1.00       1.12
    gamma_O2[3]       1.08       1.38
    C2                1.43       2.39
    
    
    $m3a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    (Intercept)      1.046      1.346
    O1.L             0.947      1.026
    O1.Q             0.919      0.973
    O1.C             1.015      1.275
    sigma_C1         1.060      1.386
    
    
    $m3b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    (Intercept)       1.16       1.56
    O22               1.10       1.45
    O23               1.11       1.53
    O24               1.39       2.26
    sigma_C1          1.41       2.60
    
    
    $m4a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M22                    1.10       1.43
    M23                    2.23       4.74
    M24                    1.11       1.61
    O22                    1.64       3.03
    O23                    3.27       8.07
    O24                    1.95       5.63
    abs(C1 - C2)           1.24       1.85
    log(C1)                1.14       1.53
    O22:abs(C1 - C2)       2.21       4.10
    O23:abs(C1 - C2)       2.43       5.44
    O24:abs(C1 - C2)       1.99       7.20
    gamma_O1[1]            4.80      14.32
    gamma_O1[2]            5.61      11.62
    gamma_O1[3]            4.52       8.99
    
    
    $m4b
    Potential scale reduction factors:
    
                                                               Point est.
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)                   6.024
    abs(C1 - C2)                                                    1.464
    log(C1)                                                         1.032
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)      6.099
    gamma_O1[1]                                                     1.170
    gamma_O1[2]                                                     1.116
    gamma_O1[3]                                                     0.956
                                                               Upper C.I.
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)                   11.96
    abs(C1 - C2)                                                     2.36
    log(C1)                                                          1.21
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)      15.58
    gamma_O1[1]                                                      1.80
    gamma_O1[2]                                                      1.47
    gamma_O1[3]                                                      1.01
    
    
    $m5a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22               1.06       1.34
    M23               1.42       2.62
    M24               1.58       2.53
    O22               1.11       1.52
    O23               1.12       1.53
    O24               1.04       1.29
    O12: C1           1.79       5.82
    O12: C2           2.01       5.02
    O13: C1           1.81       3.03
    O13: C2           1.14       1.65
    O14: C1           1.48       2.35
    O14: C2           1.04       1.24
    gamma_O1[1]       2.42       4.31
    gamma_O1[2]       1.65       3.48
    gamma_O1[3]       2.03       3.55
    
    
    $m5b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22               1.85       3.22
    M23               2.44       4.44
    M24               2.51       5.02
    O22               1.86       3.70
    O23               1.43       2.22
    O24               1.01       1.17
    C1:C2             7.63      15.00
    O12: C1           1.18       1.66
    O12: C2          14.75      28.38
    O13: C1           1.36       2.02
    O13: C2           6.30      13.22
    O14: C1           1.10       1.41
    O14: C2           5.29      11.49
    gamma_O1[1]       5.40      10.57
    gamma_O1[2]       3.94       8.77
    gamma_O1[3]       2.95       5.57
    
    
    $m5c
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22              1.684       2.77
    M23              1.509       2.49
    M24              1.244       1.82
    O22              1.051       1.32
    O23              1.524       2.55
    O24              1.447       2.77
    O12: C1          1.037       1.26
    O12: C2          1.264       2.49
    O12: C1:C2       2.050       3.67
    O13: C1          0.999       1.16
    O13: C2          1.595       2.99
    O13: C1:C2       1.373       2.53
    O14: C1          1.676       4.52
    O14: C2          1.532       2.79
    O14: C1:C2       1.343       2.25
    gamma_O1[1]      2.885       5.57
    gamma_O1[2]      2.828       7.69
    gamma_O1[3]      2.258       4.38
    
    
    $m5d
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22              1.304      2.387
    M23              1.996      4.614
    M24              1.682      3.074
    O22              1.683      4.149
    O23              1.299      1.898
    O24              2.142      3.745
    M22:C2           1.109      1.547
    M23:C2           1.609      2.700
    M24:C2           1.383      2.201
    O12: C1          1.017      1.151
    O12: C2          1.577      2.775
    O13: C1          0.979      0.986
    O13: C2          1.847      3.479
    O14: C1          1.112      1.480
    O14: C2          1.388      2.371
    gamma_O1[1]      3.274      6.453
    gamma_O1[2]      2.896      6.005
    gamma_O1[3]      3.252      6.478
    
    
    $m5e
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    O12: C1           1.71       2.93
    O12: M22          1.47       2.62
    O12: M23          4.56      10.06
    O12: M24          1.31       1.97
    O12: C2           4.40       9.27
    O12: O22          3.70       7.85
    O12: O23          1.06       1.33
    O12: O24          1.32       2.17
    O12: M22:C2       1.71       3.04
    O12: M23:C2       4.90      14.49
    O12: M24:C2       1.31       1.92
    O13: C1           1.13       1.37
    O13: M22          2.62       4.87
    O13: M23          2.51       6.03
    O13: M24          1.29       2.08
    O13: C2           1.71       5.22
    O13: O22          3.04       5.76
    O13: O23          1.25       2.02
    O13: O24          1.23       2.37
    O13: M22:C2       1.96       4.13
    O13: M23:C2       1.07       1.38
    O13: M24:C2       1.97       3.79
    O14: C1           1.06       1.14
    O14: M22          1.26       1.86
    O14: M23          1.16       1.64
    O14: M24          1.33       2.42
    O14: C2           2.69       5.39
    O14: O22          1.89       3.21
    O14: O23          2.57       5.99
    O14: O24          1.19       1.83
    O14: M22:C2       1.68       2.78
    O14: M23:C2       1.94       3.63
    O14: M24:C2       1.57       3.08
    gamma_O1[1]       1.55       2.51
    gamma_O1[2]       1.35       2.22
    gamma_O1[3]       3.53       8.03
    
    
    $m6a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22               2.63       5.41
    M23               1.54       3.18
    M24               1.83       3.69
    O22               1.78       3.46
    O23               1.49       2.65
    O24               1.72       2.85
    O12: C1           1.23       1.88
    O12: C2           1.26       1.91
    O13: C1           1.23       1.73
    O13: C2           1.63       2.88
    O14: C1           1.01       1.19
    O14: C2           1.15       1.56
    gamma_O1[1]       2.31       4.18
    gamma_O1[2]       2.22       4.39
    gamma_O1[3]       1.55       3.53
    
    
    $m6b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22              2.312      4.075
    M23              2.220      4.305
    M24              1.968      3.833
    O22              1.157      1.724
    O23              1.247      2.160
    O24              0.963      0.975
    C1:C2            3.158      6.748
    O12: C1          1.297      1.916
    O12: C2          2.711      4.866
    O13: C1          1.244      2.109
    O13: C2          2.967      5.687
    O14: C1          0.960      1.027
    O14: C2          2.171      5.032
    gamma_O1[1]      2.280      4.703
    gamma_O1[2]      2.712      5.292
    gamma_O1[3]      2.326      4.237
    
    
    $m6c
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22               2.35       5.12
    M23               1.12       1.53
    M24               1.24       1.79
    O22               1.76       3.29
    O23               1.27       1.87
    O24               1.12       1.50
    O12: C1           1.22       2.00
    O12: C2           7.43      15.53
    O12: C1:C2        4.06      15.27
    O13: C1           1.47       2.68
    O13: C2           6.35      15.74
    O13: C1:C2        5.48      11.40
    O14: C1           1.34       2.47
    O14: C2           1.89       3.24
    O14: C1:C2        1.60       2.56
    gamma_O1[1]       2.33       4.58
    gamma_O1[2]       1.53       2.55
    gamma_O1[3]       1.48       2.37
    
    
    $m6d
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22               1.57       2.70
    M23               1.26       1.98
    M24               1.59       2.98
    O22               1.88       3.35
    O23               1.96       5.82
    O24               1.30       2.70
    M22:C2            1.84       3.15
    M23:C2            2.33       4.42
    M24:C2            1.99       3.46
    O12: C1           1.00       1.10
    O12: C2           3.17      12.32
    O13: C1           1.05       1.29
    O13: C2           2.58       5.69
    O14: C1           1.29       1.95
    O14: C2           2.45       4.95
    gamma_O1[1]       3.85       9.34
    gamma_O1[2]       2.88       5.27
    gamma_O1[3]       2.19       4.00
    
    
    $m6e
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    O12: C1          2.275       4.24
    O12: M22         2.271       8.39
    O12: M23         3.116       7.62
    O12: M24         1.755       3.72
    O12: C2          1.602       2.95
    O12: O22         2.464       4.95
    O12: O23         0.937       0.95
    O12: O24         1.163       1.62
    O12: M22:C2      1.822       3.34
    O12: M23:C2      1.578       2.70
    O12: M24:C2      1.200       1.78
    O13: C1          4.076       9.02
    O13: M22         1.628       2.77
    O13: M23         2.025       4.72
    O13: M24         3.273       6.45
    O13: C2          7.763      19.58
    O13: O22         1.413       2.41
    O13: O23         1.060       1.34
    O13: O24         1.686       2.84
    O13: M22:C2      2.592       6.20
    O13: M23:C2      1.281       2.10
    O13: M24:C2      4.787       9.20
    O14: C1          2.908       7.85
    O14: M22         2.201       4.70
    O14: M23         1.681       2.73
    O14: M24         2.356       4.53
    O14: C2          2.606       5.35
    O14: O22         1.546       2.86
    O14: O23         2.666       4.94
    O14: O24         1.556       2.48
    O14: M22:C2      1.148       1.59
    O14: M23:C2      1.374       2.13
    O14: M24:C2      1.043       1.28
    gamma_O1[1]      2.007       4.00
    gamma_O1[2]      2.184       3.83
    gamma_O1[3]      1.754       4.17
    
    

---

    $m0a
                    est  MCSE   SD MCSE/SD
    gamma_O1[1]  1.1204 0.038 0.19   0.203
    gamma_O1[2] -0.0011 0.028 0.16   0.183
    gamma_O1[3] -1.2925 0.018 0.23   0.079
    
    $m0b
                  est  MCSE   SD MCSE/SD
    gamma_O2[1]  1.21 0.038 0.21    0.18
    gamma_O2[2]  0.18 0.039 0.21    0.18
    gamma_O2[3] -1.01 0.028 0.22    0.12
    
    $m1a
                   est  MCSE    SD MCSE/SD
    gamma_O1[1]  0.957 0.059  0.19    0.31
    gamma_O1[2] -0.044 0.028  0.16    0.18
    gamma_O1[3] -1.324 0.039  0.22    0.18
    C1          -2.427 2.363 12.94    0.18
    
    $m1b
                  est  MCSE    SD MCSE/SD
    gamma_O2[1]  1.36 0.047  0.21   0.222
    gamma_O2[2]  0.22 0.043  0.23   0.183
    gamma_O2[3] -0.97 0.021  0.28   0.074
    C1          10.14 3.126 17.12   0.183
    
    $m2a
                   est  MCSE   SD MCSE/SD
    gamma_O1[1]  1.035 0.050 0.28    0.18
    gamma_O1[2]  0.011 0.026 0.24    0.11
    gamma_O1[3] -1.252 0.026 0.26    0.10
    C2          -0.180 0.114 0.63    0.18
    
    $m2b
                  est  MCSE   SD MCSE/SD
    gamma_O2[1]  1.25 0.063 0.24    0.26
    gamma_O2[2]  0.15 0.034 0.18    0.18
    gamma_O2[3] -1.09 0.038 0.21    0.18
    C2          -0.91 0.191 0.56    0.34
    
    $m3a
                   est   MCSE    SD MCSE/SD
    (Intercept) 1.4365 0.0022 0.012    0.18
    O1.L        0.0064 0.0050 0.027    0.18
    O1.Q        0.0124 0.0111 0.061    0.18
    O1.C        0.0094 0.0046 0.025    0.18
    sigma_C1    0.0288 0.0055 0.030    0.18
    
    $m3b
                    est    MCSE     SD MCSE/SD
    (Intercept) 1.43251 0.00063 0.0034    0.18
    O22         0.00280 0.00090 0.0049    0.18
    O23         0.00314 0.00089 0.0049    0.18
    O24         0.00031 0.00081 0.0045    0.18
    sigma_C1    0.01926 0.00025 0.0014    0.18
    
    $m4a
                         est  MCSE    SD MCSE/SD
    M22              -0.4105 0.067  0.37    0.18
    M23              -0.4481 0.156  0.47    0.33
    M24              -0.5045 0.109  0.39    0.28
    O22               1.4913 0.221  0.66    0.33
    O23               2.6302 0.686  1.17    0.59
    O24               0.2531 0.353  0.91    0.39
    abs(C1 - C2)     -0.0025 0.122  0.67    0.18
    log(C1)          -1.3370 3.615 19.80    0.18
    O22:abs(C1 - C2) -0.4854 0.223  0.50    0.44
    O23:abs(C1 - C2) -0.8662 0.399  0.74    0.54
    O24:abs(C1 - C2)  0.1557 0.382  0.67    0.57
    gamma_O1[1]       0.2422 0.296  0.48    0.62
    gamma_O1[2]      -0.8205 0.567  0.53    1.07
    gamma_O1[3]      -2.1180 0.532  0.51    1.04
    
    $m4b
                                                                  est  MCSE    SD
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               1.696 0.440  1.13
    abs(C1 - C2)                                                0.384 0.129  0.71
    log(C1)                                                    -8.016 3.303 18.09
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.551 0.713  0.82
    gamma_O1[1]                                                 1.065 0.034  0.18
    gamma_O1[2]                                                -0.011 0.035  0.19
    gamma_O1[3]                                                -1.374 0.041  0.22
                                                               MCSE/SD
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)                 0.39
    abs(C1 - C2)                                                  0.18
    log(C1)                                                       0.18
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)    0.87
    gamma_O1[1]                                                   0.19
    gamma_O1[2]                                                   0.18
    gamma_O1[3]                                                   0.18
    
    $m5a
                   est  MCSE    SD MCSE/SD
    M22          0.272 0.071  0.39    0.18
    M23          0.419 0.077  0.35    0.22
    M24          0.061 0.084  0.46    0.18
    O22          0.451 0.304  0.66    0.46
    O23          1.116 0.162  0.53    0.30
    O24          0.385 0.135  0.53    0.25
    O12: C1     -3.785 4.400 11.71    0.38
    O12: C2      0.417 0.129  0.64    0.20
    O13: C1     -0.284 1.752  9.59    0.18
    O13: C2      0.573 0.181  0.49    0.37
    O14: C1      0.189 3.445 15.44    0.22
    O14: C2      0.349 0.129  0.71    0.18
    gamma_O1[1]  0.333 0.339  0.41    0.83
    gamma_O1[2] -0.815 0.210  0.40    0.52
    gamma_O1[3] -2.139 0.354  0.43    0.82
    
    $m5b
                   est  MCSE    SD MCSE/SD
    M22          0.091 0.211  0.49    0.43
    M23          0.088 0.305  0.63    0.49
    M24         -0.295 0.385  0.54    0.71
    O22          0.761 0.106  0.37    0.28
    O23          1.253 0.094  0.43    0.22
    O24          0.613 0.061  0.33    0.18
    C1:C2        0.359 0.961  1.72    0.56
    O12: C1     -3.329 2.709 13.06    0.21
    O12: C2     -0.164 1.459  2.29    0.64
    O13: C1      3.219 1.691  9.26    0.18
    O13: C2     -0.157 2.108  2.46    0.86
    O14: C1      8.418 2.597 14.23    0.18
    O14: C2     -0.291 0.968  2.39    0.40
    gamma_O1[1]  0.357 0.443  0.50    0.88
    gamma_O1[2] -0.630 0.419  0.54    0.77
    gamma_O1[3] -1.964 0.293  0.56    0.52
    
    $m5c
                  est  MCSE    SD MCSE/SD
    M22         -0.43 0.260  0.57    0.45
    M23         -0.36 0.095  0.43    0.22
    M24         -0.67 0.083  0.38    0.22
    O22          0.63 0.077  0.42    0.18
    O23          1.14 0.077  0.36    0.21
    O24          0.45 0.128  0.44    0.29
    O12: C1     -4.64 2.960 16.21    0.18
    O12: C2     -1.12 0.382  0.94    0.41
    O12: C1:C2   1.05 0.248  0.75    0.33
    O13: C1      0.61 2.080 11.39    0.18
    O13: C2      0.30 0.172  0.57    0.30
    O13: C1:C2   0.14 0.204  0.49    0.42
    O14: C1      5.70 3.450 18.89    0.18
    O14: C2     -0.36 0.504  0.97    0.52
    O14: C1:C2   0.45 0.293  0.62    0.47
    gamma_O1[1]  0.91 0.176  0.40    0.44
    gamma_O1[2] -0.14 0.219  0.46    0.47
    gamma_O1[3] -1.50 0.173  0.55    0.31
    
    $m5d
                    est MCSE    SD MCSE/SD
    M22          0.1511 0.26  0.40    0.64
    M23         -0.0044 0.13  0.53    0.24
    M24         -0.1188 0.13  0.47    0.27
    O22          0.6257 0.28  0.69    0.40
    O23          1.1112 0.25  0.63    0.40
    O24          0.2421 0.34  0.51    0.66
    M22:C2      -1.0708 0.25  1.17    0.22
    M23:C2      -0.3051 0.42  1.19    0.35
    M24:C2       1.3188 0.38  1.64    0.23
    O12: C1     -2.0833 2.91 15.94    0.18
    O12: C2      0.3412 0.28  1.17    0.24
    O13: C1     -0.0161 1.82  9.94    0.18
    O13: C2     -0.0196 0.27  0.77    0.34
    O14: C1      2.3926 3.02 14.13    0.21
    O14: C2     -0.1221 0.32  0.97    0.33
    gamma_O1[1]  0.5625 0.36  0.51    0.70
    gamma_O1[2] -0.5345 0.26  0.54    0.47
    gamma_O1[3] -1.9118 0.58  0.54    1.08
    
    $m5e
                   est   MCSE    SD MCSE/SD
    O12: C1     10.153 10.049 19.38   0.519
    O12: M22     1.787  0.246  0.42   0.582
    O12: M23    -2.110  0.809  1.37   0.592
    O12: M24    -0.283  0.090  0.42   0.216
    O12: C2      0.149  1.145  1.91   0.600
    O12: O22     1.120  0.489  0.89   0.552
    O12: O23     3.027  0.187  0.57   0.326
    O12: O24    -0.194  0.206  0.64   0.323
    O12: M22:C2  4.453  0.583  1.81   0.323
    O12: M23:C2 -5.058  2.040  4.09   0.499
    O12: M24:C2 10.022  0.737  3.78   0.195
    O13: C1     -9.368  2.221 11.43   0.194
    O13: M22    -0.412  0.262  0.52   0.505
    O13: M23    -0.181  0.345  0.53   0.645
    O13: M24    -0.471  0.176  0.42   0.417
    O13: C2      0.942  0.412  0.74   0.557
    O13: O22     0.416  0.199  0.53   0.378
    O13: O23     0.912  0.082  0.45   0.183
    O13: O24     0.456  0.108  0.39   0.273
    O13: M22:C2 -2.386  0.610  1.61   0.379
    O13: M23:C2  0.395  0.197  1.08   0.183
    O13: M24:C2 -1.530  0.665  1.37   0.484
    O14: C1     -1.221  1.349 15.71   0.086
    O14: M22    -1.592  0.175  0.59   0.298
    O14: M23    -1.103  0.165  0.68   0.241
    O14: M24    -1.514  0.136  0.74   0.183
    O14: C2      0.192  0.320  1.08   0.297
    O14: O22    -0.211  0.149  0.63   0.236
    O14: O23     0.604  0.125  0.49   0.255
    O14: O24    -1.053  0.184  0.70   0.262
    O14: M22:C2 -3.354  0.881  2.60   0.339
    O14: M23:C2 -0.557  0.484  2.65   0.183
    O14: M24:C2  0.741  0.545  1.56   0.349
    gamma_O1[1] -0.038  0.077  0.28   0.275
    gamma_O1[2] -0.193  0.102  0.27   0.379
    gamma_O1[3] -0.557  0.175  0.38   0.458
    
    $m6a
                  est MCSE    SD MCSE/SD
    M22          0.34 0.28  0.60    0.46
    M23          0.27 0.26  0.65    0.40
    M24          0.62 0.12  0.68    0.18
    O22         -0.40 0.22  0.54    0.41
    O23         -0.94 0.27  0.53    0.51
    O24         -0.25 0.16  0.48    0.33
    O12: C1      0.72 2.54 12.49    0.20
    O12: C2     -0.71 0.31  0.95    0.33
    O13: C1     -1.58 3.31 15.07    0.22
    O13: C2     -0.43 0.23  0.70    0.33
    O14: C1     -8.12 5.21 21.30    0.24
    O14: C2     -0.29 0.12  0.69    0.18
    gamma_O1[1] -0.95 0.14  0.41    0.33
    gamma_O1[2]    NA   NA  0.47      NA
    gamma_O1[3]  1.43 0.20  0.51    0.40
    
    $m6b
                   est  MCSE    SD MCSE/SD
    M22         -0.109 0.238  0.68    0.35
    M23         -0.109 0.169  0.54    0.31
    M24          0.021 0.161  0.51    0.31
    O22         -0.098 0.144  0.48    0.30
    O23         -0.732 0.112  0.39    0.29
    O24         -0.073 0.083  0.41    0.20
    C1:C2        0.994 0.315  0.77    0.41
    O12: C1      4.778 2.720 12.77    0.21
    O12: C2     -1.835 0.380  1.24    0.31
    O13: C1      1.083 3.941 11.84    0.33
    O13: C2     -1.540 0.386  1.16    0.33
    O14: C1     -3.485 2.351 12.88    0.18
    O14: C2     -1.433 0.307  1.01    0.30
    gamma_O1[1] -0.688 0.158  0.51    0.31
    gamma_O1[2]  0.233 0.201  0.57    0.36
    gamma_O1[3]  1.573 0.285  0.59    0.49
    
    $m6c
                    est  MCSE    SD MCSE/SD
    M22         -0.0052 0.171  0.41    0.41
    M23          0.1013 0.103  0.44    0.23
    M24          0.2483 0.071  0.38    0.19
    O22         -0.3705 0.078  0.43    0.18
    O23         -0.9554 0.073  0.40    0.18
    O24         -0.1907 0.066  0.41    0.16
    O12: C1      8.7236 3.184 14.11    0.23
    O12: C2     -0.1205 1.426  2.07    0.69
    O12: C1:C2  -0.2515 0.783  1.44    0.54
    O13: C1      4.6668 4.406 12.77    0.35
    O13: C2     -1.8528 1.884  2.58    0.73
    O13: C1:C2   1.1846 0.693  1.54    0.45
    O14: C1      4.2731 3.368 18.45    0.18
    O14: C2     -1.7941 0.737  1.31    0.56
    O14: C1:C2   1.2748 0.445  0.94    0.47
    gamma_O1[1] -0.7812 0.115  0.30    0.39
    gamma_O1[2]      NA    NA  0.30      NA
    gamma_O1[3]  1.7158 0.111  0.37    0.30
    
    $m6d
                   est   MCSE    SD MCSE/SD
    M22          0.266  0.196  0.45    0.43
    M23          0.075  0.094  0.51    0.18
    M24          0.378  0.136  0.44    0.31
    O22         -0.632  0.081  0.37    0.22
    O23         -1.166  0.162  0.41    0.39
    O24         -0.467  0.037  0.53    0.07
    M22:C2       1.041  0.732  2.08    0.35
    M23:C2       0.119  0.672  1.68    0.40
    M24:C2      -0.491  0.733  1.95    0.38
    O12: C1      4.433  5.563 19.05    0.29
    O12: C2     -0.223  0.747  1.48    0.51
    O13: C1      7.605  8.507 17.03    0.50
    O13: C2     -0.115  0.871  1.40    0.62
    O14: C1      5.755 10.991 26.15    0.42
    O14: C2      0.046  0.522  1.40    0.37
    gamma_O1[1] -0.667  0.292  0.51    0.57
    gamma_O1[2]  0.396  0.218  0.43    0.51
    gamma_O1[3]  1.762  0.150  0.43    0.35
    
    $m6e
                    est   MCSE    SD MCSE/SD
    O12: C1      -9.390  7.121 24.13    0.30
    O12: M22     -0.415  0.220  0.70    0.31
    O12: M23      0.603  0.332  0.76    0.44
    O12: M24      0.340  0.185  0.62    0.30
    O12: C2       0.326  0.517  1.19    0.43
    O12: O22     -1.295  0.436  0.93    0.47
    O12: O23     -1.995  0.149  0.62    0.24
    O12: O24     -0.271  0.103  0.56    0.18
    O12: M22:C2  -1.793  1.088  2.20    0.49
    O12: M23:C2   0.128  0.295  1.24    0.24
    O12: M24:C2  -5.179  0.572  1.68    0.34
    O13: C1      -2.429  7.479 16.40    0.46
    O13: M22      0.828  0.224  0.52    0.43
    O13: M23     -0.311  0.270  0.61    0.44
    O13: M24      0.395  0.308  0.57    0.54
    O13: C2      -0.816  1.096  1.89    0.58
    O13: O22     -0.539  0.314  0.71    0.44
    O13: O23     -0.805  0.086  0.32    0.27
    O13: O24     -0.179  0.153  0.53    0.29
    O13: M22:C2   1.981  1.779  2.99    0.59
    O13: M23:C2  -1.580  0.290  1.28    0.23
    O13: M24:C2   0.806  0.598  2.11    0.28
    O14: C1     -23.480 16.580 22.36    0.74
    O14: M22      2.077  0.250  0.81    0.31
    O14: M23      0.805  0.253  0.53    0.48
    O14: M24      1.754  0.369  0.83    0.45
    O14: C2      -0.556  0.355  0.74    0.48
    O14: O22     -0.310  0.269  0.70    0.39
    O14: O23     -0.893  0.416  0.68    0.61
    O14: O24      1.171  0.211  0.65    0.32
    O14: M22:C2   3.582  0.462  1.54    0.30
    O14: M23:C2  -0.087  0.254  1.39    0.18
    O14: M24:C2   0.085  0.598  1.24    0.48
    gamma_O1[1]  -0.511  0.177  0.30    0.58
    gamma_O1[2]  -0.062  0.150  0.36    0.42
    gamma_O1[3]   0.288  0.279  0.58    0.48
    

# summary output remained the same

    
    Call:
    clm_imp(formula = O1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
       O1 > 1    O1 > 2    O1 > 3 
     1.120376 -0.001082 -1.292482 
    
    Call:
    clm_imp(formula = O2 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O2" 
    
    
    Coefficients:
     O2 > 1  O2 > 2  O2 > 3 
     1.2088  0.1751 -1.0118 
    
    Call:
    clm_imp(formula = O1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3       C1 
     0.95715 -0.04353 -1.32433 -2.42664 
    
    Call:
    clm_imp(formula = O2 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O2" 
    
    
    Coefficients:
     O2 > 1  O2 > 2  O2 > 3      C1 
     1.3573  0.2166 -0.9656 10.1375 
    
    Call:
    clm_imp(formula = O1 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
     O1 > 1  O1 > 2  O1 > 3      C2 
     1.0353  0.0112 -1.2521 -0.1802 
    
    Call:
    clm_imp(formula = O2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O2" 
    
    
    Coefficients:
     O2 > 1  O2 > 2  O2 > 3      C2 
     1.2501  0.1547 -1.0901 -0.9148 
    
    Call:
    lm_imp(formula = C1 ~ O1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)        O1.L        O1.Q        O1.C 
       1.436464    0.006394    0.012352    0.009362 
    
    
    Residual standard deviation:
    sigma_C1 
     0.02875 
    
    Call:
    lm_imp(formula = C1 ~ O2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)         O22         O23         O24 
      1.4325074   0.0028016   0.0031386   0.0003059 
    
    
    Residual standard deviation:
    sigma_C1 
     0.01926 
    
    Call:
    clm_imp(formula = O1 ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF, 
        n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
              O1 > 1           O1 > 2           O1 > 3              M22 
            0.242228        -0.820526        -2.118042        -0.410529 
                 M23              M24              O22              O23 
           -0.448126        -0.504514         1.491252         2.630153 
                 O24     abs(C1 - C2)          log(C1) O22:abs(C1 - C2) 
            0.253100        -0.002499        -1.337025        -0.485403 
    O23:abs(C1 - C2) O24:abs(C1 - C2) 
           -0.866186         0.155660 
    
    Call:
    clm_imp(formula = O1 ~ ifelse(as.numeric(O2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1), data = wideDF, n.adapt = 5, 
        n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
                                                        O1 > 1 
                                                       1.06538 
                                                        O1 > 2 
                                                      -0.01069 
                                                        O1 > 3 
                                                      -1.37361 
                 ifelse(as.numeric(O2) > as.numeric(M1), 1, 0) 
                                                       1.69613 
                                                  abs(C1 - C2) 
                                                       0.38436 
                                                       log(C1) 
                                                      -8.01620 
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                      -0.55104 
    
    Call:
    clm_imp(formula = O1 ~ C1 + C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3      M22      M23      M24      O22      O23 
     0.33350 -0.81536 -2.13884  0.27220  0.41871  0.06127  0.45122  1.11648 
         O24       C1       C2       C1       C2       C1       C2 
     0.38525 -3.78529  0.41668 -0.28426  0.57279  0.18921  0.34901 
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3      M22      M23      M24      O22      O23 
     0.35692 -0.63048 -1.96438  0.09070  0.08814 -0.29490  0.76082  1.25294 
         O24    C1:C2       C1       C2       C1       C2       C1       C2 
     0.61286  0.35935 -3.32871 -0.16414  3.21861 -0.15652  8.41759 -0.29139 
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 * 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
     O1 > 1  O1 > 2  O1 > 3     M22     M23     M24     O22     O23     O24      C1 
     0.9128 -0.1389 -1.4970 -0.4346 -0.3599 -0.6712  0.6301  1.1371  0.4505 -4.6398 
         C2   C1:C2      C1      C2   C1:C2      C1      C2   C1:C2 
    -1.1212  1.0534  0.6087  0.2995  0.1387  5.7016 -0.3573  0.4520 
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
       O1 > 1    O1 > 2    O1 > 3       M22       M23       M24       O22       O23 
     0.562532 -0.534467 -1.911784  0.151123 -0.004449 -0.118789  0.625676  1.111174 
          O24    M22:C2    M23:C2    M24:C2        C1        C2        C1        C2 
     0.242101 -1.070787 -0.305063  1.318800 -2.083259  0.341205 -0.016068 -0.019604 
           C1        C2 
     2.392597 -0.122124 
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = ~C1 + 
            M2 * C2 + O2, seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3       C1      M22      M23      M24       C2 
    -0.03833 -0.19302 -0.55681 10.15277  1.78719 -2.10997 -0.28280  0.14936 
         O22      O23      O24   M22:C2   M23:C2   M24:C2       C1      M22 
     1.12031  3.02734 -0.19410  4.45264 -5.05792 10.02218 -9.36847 -0.41193 
         M23      M24       C2      O22      O23      O24   M22:C2   M23:C2 
    -0.18149 -0.47106  0.94221  0.41649  0.91210  0.45552 -2.38564  0.39499 
      M24:C2       C1      M22      M23      M24       C2      O22      O23 
    -1.52970 -1.22110 -1.59156 -1.10269 -1.51378  0.19151 -0.21056  0.60429 
         O24   M22:C2   M23:C2   M24:C2 
    -1.05296 -3.35372 -0.55727  0.74090 
    
    Call:
    clm_imp(formula = O1 ~ C1 + C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
     O1 = 1  O1 = 2  O1 = 3     M22     M23     M24     O22     O23     O24      C1 
    -0.9502  0.1264  1.4339  0.3378  0.2726  0.6155 -0.3994 -0.9443 -0.2451  0.7229 
         C2      C1      C2      C1      C2 
    -0.7053 -1.5777 -0.4314 -8.1197 -0.2882 
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 = 1   O1 = 2   O1 = 3      M22      M23      M24      O22      O23 
    -0.68759  0.23284  1.57292 -0.10881 -0.10927  0.02061 -0.09762 -0.73151 
         O24    C1:C2       C1       C2       C1       C2       C1       C2 
    -0.07349  0.99378  4.77759 -1.83546  1.08339 -1.53971 -3.48467 -1.43317 
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 * 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
       O1 = 1    O1 = 2    O1 = 3       M22       M23       M24       O22       O23 
    -0.781242  0.329337  1.715791 -0.005194  0.101309  0.248258 -0.370494 -0.955430 
          O24        C1        C2     C1:C2        C1        C2     C1:C2        C1 
    -0.190733  8.723644 -0.120519 -0.251492  4.666810 -1.852785  1.184580  4.273071 
           C2     C1:C2 
    -1.794086  1.274817 
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 = 1   O1 = 2   O1 = 3      M22      M23      M24      O22      O23 
    -0.66674  0.39611  1.76156  0.26639  0.07506  0.37774 -0.63239 -1.16581 
         O24   M22:C2   M23:C2   M24:C2       C1       C2       C1       C2 
    -0.46687  1.04114  0.11947 -0.49123  4.43320 -0.22265  7.60510 -0.11510 
          C1       C2 
     5.75481  0.04606 
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = ~C1 + 
            M2 * C2 + O2, rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
       O1 = 1    O1 = 2    O1 = 3        C1       M22       M23       M24        C2 
     -0.51108  -0.06168   0.28830  -9.39019  -0.41485   0.60325   0.33996   0.32606 
          O22       O23       O24    M22:C2    M23:C2    M24:C2        C1       M22 
     -1.29506  -1.99539  -0.27085  -1.79294   0.12770  -5.17868  -2.42869   0.82803 
          M23       M24        C2       O22       O23       O24    M22:C2    M23:C2 
     -0.31066   0.39494  -0.81565  -0.53876  -0.80518  -0.17880   1.98117  -1.58028 
       M24:C2        C1       M22       M23       M24        C2       O22       O23 
      0.80628 -23.48042   2.07668   0.80541   1.75353  -0.55572  -0.31040  -0.89309 
          O24    M22:C2    M23:C2    M24:C2 
      1.17061   3.58232  -0.08683   0.08451 
    $m0a
    
    Call:
    clm_imp(formula = O1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
       O1 > 1    O1 > 2    O1 > 3 
     1.120376 -0.001082 -1.292482 
    
    $m0b
    
    Call:
    clm_imp(formula = O2 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O2" 
    
    
    Coefficients:
     O2 > 1  O2 > 2  O2 > 3 
     1.2088  0.1751 -1.0118 
    
    $m1a
    
    Call:
    clm_imp(formula = O1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3       C1 
     0.95715 -0.04353 -1.32433 -2.42664 
    
    $m1b
    
    Call:
    clm_imp(formula = O2 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O2" 
    
    
    Coefficients:
     O2 > 1  O2 > 2  O2 > 3      C1 
     1.3573  0.2166 -0.9656 10.1375 
    
    $m2a
    
    Call:
    clm_imp(formula = O1 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
     O1 > 1  O1 > 2  O1 > 3      C2 
     1.0353  0.0112 -1.2521 -0.1802 
    
    $m2b
    
    Call:
    clm_imp(formula = O2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O2" 
    
    
    Coefficients:
     O2 > 1  O2 > 2  O2 > 3      C2 
     1.2501  0.1547 -1.0901 -0.9148 
    
    $m3a
    
    Call:
    lm_imp(formula = C1 ~ O1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)        O1.L        O1.Q        O1.C 
       1.436464    0.006394    0.012352    0.009362 
    
    
    Residual standard deviation:
    sigma_C1 
     0.02875 
    
    $m3b
    
    Call:
    lm_imp(formula = C1 ~ O2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)         O22         O23         O24 
      1.4325074   0.0028016   0.0031386   0.0003059 
    
    
    Residual standard deviation:
    sigma_C1 
     0.01926 
    
    $m4a
    
    Call:
    clm_imp(formula = O1 ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF, 
        n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
              O1 > 1           O1 > 2           O1 > 3              M22 
            0.242228        -0.820526        -2.118042        -0.410529 
                 M23              M24              O22              O23 
           -0.448126        -0.504514         1.491252         2.630153 
                 O24     abs(C1 - C2)          log(C1) O22:abs(C1 - C2) 
            0.253100        -0.002499        -1.337025        -0.485403 
    O23:abs(C1 - C2) O24:abs(C1 - C2) 
           -0.866186         0.155660 
    
    $m4b
    
    Call:
    clm_imp(formula = O1 ~ ifelse(as.numeric(O2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1), data = wideDF, n.adapt = 5, 
        n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
                                                        O1 > 1 
                                                       1.06538 
                                                        O1 > 2 
                                                      -0.01069 
                                                        O1 > 3 
                                                      -1.37361 
                 ifelse(as.numeric(O2) > as.numeric(M1), 1, 0) 
                                                       1.69613 
                                                  abs(C1 - C2) 
                                                       0.38436 
                                                       log(C1) 
                                                      -8.01620 
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                      -0.55104 
    
    $m5a
    
    Call:
    clm_imp(formula = O1 ~ C1 + C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3      M22      M23      M24      O22      O23 
     0.33350 -0.81536 -2.13884  0.27220  0.41871  0.06127  0.45122  1.11648 
         O24       C1       C2       C1       C2       C1       C2 
     0.38525 -3.78529  0.41668 -0.28426  0.57279  0.18921  0.34901 
    
    $m5b
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3      M22      M23      M24      O22      O23 
     0.35692 -0.63048 -1.96438  0.09070  0.08814 -0.29490  0.76082  1.25294 
         O24    C1:C2       C1       C2       C1       C2       C1       C2 
     0.61286  0.35935 -3.32871 -0.16414  3.21861 -0.15652  8.41759 -0.29139 
    
    $m5c
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 * 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
     O1 > 1  O1 > 2  O1 > 3     M22     M23     M24     O22     O23     O24      C1 
     0.9128 -0.1389 -1.4970 -0.4346 -0.3599 -0.6712  0.6301  1.1371  0.4505 -4.6398 
         C2   C1:C2      C1      C2   C1:C2      C1      C2   C1:C2 
    -1.1212  1.0534  0.6087  0.2995  0.1387  5.7016 -0.3573  0.4520 
    
    $m5d
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
       O1 > 1    O1 > 2    O1 > 3       M22       M23       M24       O22       O23 
     0.562532 -0.534467 -1.911784  0.151123 -0.004449 -0.118789  0.625676  1.111174 
          O24    M22:C2    M23:C2    M24:C2        C1        C2        C1        C2 
     0.242101 -1.070787 -0.305063  1.318800 -2.083259  0.341205 -0.016068 -0.019604 
           C1        C2 
     2.392597 -0.122124 
    
    $m5e
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = ~C1 + 
            M2 * C2 + O2, seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3       C1      M22      M23      M24       C2 
    -0.03833 -0.19302 -0.55681 10.15277  1.78719 -2.10997 -0.28280  0.14936 
         O22      O23      O24   M22:C2   M23:C2   M24:C2       C1      M22 
     1.12031  3.02734 -0.19410  4.45264 -5.05792 10.02218 -9.36847 -0.41193 
         M23      M24       C2      O22      O23      O24   M22:C2   M23:C2 
    -0.18149 -0.47106  0.94221  0.41649  0.91210  0.45552 -2.38564  0.39499 
      M24:C2       C1      M22      M23      M24       C2      O22      O23 
    -1.52970 -1.22110 -1.59156 -1.10269 -1.51378  0.19151 -0.21056  0.60429 
         O24   M22:C2   M23:C2   M24:C2 
    -1.05296 -3.35372 -0.55727  0.74090 
    
    $m6a
    
    Call:
    clm_imp(formula = O1 ~ C1 + C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
     O1 = 1  O1 = 2  O1 = 3     M22     M23     M24     O22     O23     O24      C1 
    -0.9502  0.1264  1.4339  0.3378  0.2726  0.6155 -0.3994 -0.9443 -0.2451  0.7229 
         C2      C1      C2      C1      C2 
    -0.7053 -1.5777 -0.4314 -8.1197 -0.2882 
    
    $m6b
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 = 1   O1 = 2   O1 = 3      M22      M23      M24      O22      O23 
    -0.68759  0.23284  1.57292 -0.10881 -0.10927  0.02061 -0.09762 -0.73151 
         O24    C1:C2       C1       C2       C1       C2       C1       C2 
    -0.07349  0.99378  4.77759 -1.83546  1.08339 -1.53971 -3.48467 -1.43317 
    
    $m6c
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 * 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
       O1 = 1    O1 = 2    O1 = 3       M22       M23       M24       O22       O23 
    -0.781242  0.329337  1.715791 -0.005194  0.101309  0.248258 -0.370494 -0.955430 
          O24        C1        C2     C1:C2        C1        C2     C1:C2        C1 
    -0.190733  8.723644 -0.120519 -0.251492  4.666810 -1.852785  1.184580  4.273071 
           C2     C1:C2 
    -1.794086  1.274817 
    
    $m6d
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 = 1   O1 = 2   O1 = 3      M22      M23      M24      O22      O23 
    -0.66674  0.39611  1.76156  0.26639  0.07506  0.37774 -0.63239 -1.16581 
         O24   M22:C2   M23:C2   M24:C2       C1       C2       C1       C2 
    -0.46687  1.04114  0.11947 -0.49123  4.43320 -0.22265  7.60510 -0.11510 
          C1       C2 
     5.75481  0.04606 
    
    $m6e
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = ~C1 + 
            M2 * C2 + O2, rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
       O1 = 1    O1 = 2    O1 = 3        C1       M22       M23       M24        C2 
     -0.51108  -0.06168   0.28830  -9.39019  -0.41485   0.60325   0.33996   0.32606 
          O22       O23       O24    M22:C2    M23:C2    M24:C2        C1       M22 
     -1.29506  -1.99539  -0.27085  -1.79294   0.12770  -5.17868  -2.42869   0.82803 
          M23       M24        C2       O22       O23       O24    M22:C2    M23:C2 
     -0.31066   0.39494  -0.81565  -0.53876  -0.80518  -0.17880   1.98117  -1.58028 
       M24:C2        C1       M22       M23       M24        C2       O22       O23 
      0.80628 -23.48042   2.07668   0.80541   1.75353  -0.55572  -0.31040  -0.89309 
          O24    M22:C2    M23:C2    M24:C2 
      1.17061   3.58232  -0.08683   0.08451 
    

---

    $m0a
    $m0a$O1
          O1 > 1       O1 > 2       O1 > 3 
     1.120375516 -0.001081672 -1.292481653 
    
    
    $m0b
    $m0b$O2
        O2 > 1     O2 > 2     O2 > 3 
     1.2087523  0.1751462 -1.0117976 
    
    
    $m1a
    $m1a$O1
         O1 > 1      O1 > 2      O1 > 3          C1 
     0.95715332 -0.04353217 -1.32432653 -2.42663524 
    
    
    $m1b
    $m1b$O2
        O2 > 1     O2 > 2     O2 > 3         C1 
     1.3573373  0.2166277 -0.9655930 10.1375041 
    
    
    $m2a
    $m2a$O1
         O1 > 1      O1 > 2      O1 > 3          C2 
     1.03529183  0.01119995 -1.25213442 -0.18015978 
    
    
    $m2b
    $m2b$O2
        O2 > 1     O2 > 2     O2 > 3         C2 
     1.2500969  0.1546733 -1.0900575 -0.9148039 
    
    
    $m3a
    $m3a$C1
    (Intercept)        O1.L        O1.Q        O1.C 
    1.436463811 0.006394116 0.012351738 0.009362007 
    
    
    $m3b
    $m3b$C1
     (Intercept)          O22          O23          O24 
    1.4325073793 0.0028016071 0.0031386255 0.0003059072 
    
    
    $m4a
    $m4a$O1
              O1 > 1           O1 > 2           O1 > 3              M22 
           0.2422284       -0.8205262       -2.1180422       -0.4105287 
                 M23              M24              O22              O23 
          -0.4481260       -0.5045137        1.4912517        2.6301532 
                 O24     abs(C1 - C2)          log(C1) O22:abs(C1 - C2) 
           0.2531003       -0.0024989       -1.3370254       -0.4854031 
    O23:abs(C1 - C2) O24:abs(C1 - C2) 
          -0.8661857        0.1556598 
    
    
    $m4b
    $m4b$O1
                                                        O1 > 1 
                                                    1.06537920 
                                                        O1 > 2 
                                                   -0.01068967 
                                                        O1 > 3 
                                                   -1.37360536 
                 ifelse(as.numeric(O2) > as.numeric(M1), 1, 0) 
                                                    1.69613498 
                                                  abs(C1 - C2) 
                                                    0.38435633 
                                                       log(C1) 
                                                   -8.01620199 
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                   -0.55104117 
    
    
    $m5a
    $m5a$O1
         O1 > 1      O1 > 2      O1 > 3         M22         M23         M24 
     0.33349575 -0.81536198 -2.13884288  0.27220064  0.41870659  0.06127484 
            O22         O23         O24          C1          C2          C1 
     0.45121507  1.11648042  0.38524849 -3.78528834  0.41667706 -0.28425994 
             C2          C1          C2 
     0.57279245  0.18921215  0.34901393 
    
    
    $m5b
    $m5b$O1
         O1 > 1      O1 > 2      O1 > 3         M22         M23         M24 
     0.35691912 -0.63048285 -1.96438237  0.09070221  0.08813786 -0.29490449 
            O22         O23         O24       C1:C2          C1          C2 
     0.76082413  1.25294010  0.61285980  0.35934619 -3.32870953 -0.16414201 
             C1          C2          C1          C2 
     3.21861465 -0.15651736  8.41759231 -0.29138506 
    
    
    $m5c
    $m5c$O1
        O1 > 1     O1 > 2     O1 > 3        M22        M23        M24        O22 
     0.9128434 -0.1388565 -1.4970246 -0.4345671 -0.3598824 -0.6711653  0.6300617 
           O23        O24         C1         C2      C1:C2         C1         C2 
     1.1370647  0.4504774 -4.6398093 -1.1211857  1.0533686  0.6086971  0.2995319 
         C1:C2         C1         C2      C1:C2 
     0.1386650  5.7016387 -0.3573073  0.4520274 
    
    
    $m5d
    $m5d$O1
          O1 > 1       O1 > 2       O1 > 3          M22          M23          M24 
     0.562532154 -0.534466565 -1.911784352  0.151123233 -0.004449056 -0.118788995 
             O22          O23          O24       M22:C2       M23:C2       M24:C2 
     0.625675818  1.111174384  0.242100583 -1.070787476 -0.305063192  1.318800432 
              C1           C2           C1           C2           C1           C2 
    -2.083258642  0.341204644 -0.016067540 -0.019603538  2.392597454 -0.122123516 
    
    
    $m5e
    $m5e$O1
         O1 > 1      O1 > 2      O1 > 3          C1         M22         M23 
    -0.03833498 -0.19302490 -0.55680623 10.15277478  1.78718934 -2.10997001 
            M24          C2         O22         O23         O24      M22:C2 
    -0.28279569  0.14935875  1.12031275  3.02733521 -0.19409533  4.45264040 
         M23:C2      M24:C2          C1         M22         M23         M24 
    -5.05791829 10.02217982 -9.36847416 -0.41192909 -0.18148658 -0.47105809 
             C2         O22         O23         O24      M22:C2      M23:C2 
     0.94220955  0.41649100  0.91209550  0.45552122 -2.38564110  0.39498750 
         M24:C2          C1         M22         M23         M24          C2 
    -1.52969654 -1.22110051 -1.59156131 -1.10268527 -1.51378285  0.19151477 
            O22         O23         O24      M22:C2      M23:C2      M24:C2 
    -0.21056117  0.60428906 -1.05296113 -3.35372420 -0.55726994  0.74090252 
    
    
    $m6a
    $m6a$O1
        O1 = 1     O1 = 2     O1 = 3        M22        M23        M24        O22 
    -0.9501623  0.1264139  1.4339375  0.3377949  0.2726240  0.6155196 -0.3993749 
           O23        O24         C1         C2         C1         C2         C1 
    -0.9442958 -0.2450897  0.7229371 -0.7052831 -1.5776581 -0.4313567 -8.1196969 
            C2 
    -0.2881769 
    
    
    $m6b
    $m6b$O1
         O1 = 1      O1 = 2      O1 = 3         M22         M23         M24 
    -0.68758681  0.23284417  1.57292497 -0.10881100 -0.10926645  0.02061368 
            O22         O23         O24       C1:C2          C1          C2 
    -0.09762433 -0.73150647 -0.07349287  0.99378487  4.77758610 -1.83546389 
             C1          C2          C1          C2 
     1.08339237 -1.53971342 -3.48467466 -1.43316652 
    
    
    $m6c
    $m6c$O1
         O1 = 1      O1 = 2      O1 = 3         M22         M23         M24 
    -0.78124169  0.32933741  1.71579097 -0.00519442  0.10130936  0.24825834 
            O22         O23         O24          C1          C2       C1:C2 
    -0.37049357 -0.95543004 -0.19073252  8.72364405 -0.12051911 -0.25149224 
             C1          C2       C1:C2          C1          C2       C1:C2 
     4.66681036 -1.85278533  1.18458023  4.27307090 -1.79408602  1.27481737 
    
    
    $m6d
    $m6d$O1
         O1 = 1      O1 = 2      O1 = 3         M22         M23         M24 
    -0.66673747  0.39610779  1.76155920  0.26639269  0.07506469  0.37773871 
            O22         O23         O24      M22:C2      M23:C2      M24:C2 
    -0.63239376 -1.16581142 -0.46687344  1.04113868  0.11947407 -0.49123268 
             C1          C2          C1          C2          C1          C2 
     4.43320326 -0.22265476  7.60509532 -0.11510364  5.75481452  0.04606375 
    
    
    $m6e
    $m6e$O1
          O1 = 1       O1 = 2       O1 = 3           C1          M22          M23 
     -0.51107528  -0.06167980   0.28829541  -9.39019078  -0.41485066   0.60325232 
             M24           C2          O22          O23          O24       M22:C2 
      0.33995615   0.32605673  -1.29506331  -1.99539480  -0.27084558  -1.79293535 
          M23:C2       M24:C2           C1          M22          M23          M24 
      0.12769987  -5.17868455  -2.42868633   0.82802571  -0.31065629   0.39493587 
              C2          O22          O23          O24       M22:C2       M23:C2 
     -0.81565035  -0.53876127  -0.80517704  -0.17880460   1.98117016  -1.58027919 
          M24:C2           C1          M22          M23          M24           C2 
      0.80627611 -23.48042453   2.07667577   0.80541400   1.75352620  -0.55572317 
             O22          O23          O24       M22:C2       M23:C2       M24:C2 
     -0.31040427  -0.89309252   1.17060780   3.58232128  -0.08683247   0.08451319 
    
    

---

    $m0a
    $m0a$O1
                 2.5%      97.5%
    O1 > 1  0.8325775  1.4844697
    O1 > 2 -0.2370317  0.2395984
    O1 > 3 -1.6223060 -0.8953068
    
    
    $m0b
    $m0b$O2
                 2.5%      97.5%
    O2 > 1  0.7423602  1.5588057
    O2 > 2 -0.2068869  0.4967566
    O2 > 3 -1.3960195 -0.6107119
    
    
    $m1a
    $m1a$O1
                  2.5%      97.5%
    O1 > 1   0.6632330  1.3111343
    O1 > 2  -0.3567271  0.2304299
    O1 > 3  -1.6692021 -0.9636308
    C1     -31.8285167 16.1339312
    
    
    $m1b
    $m1b$O2
                  2.5%      97.5%
    O2 > 1   0.9268634  1.6427343
    O2 > 2  -0.1461823  0.6204412
    O2 > 3  -1.3924742 -0.5222266
    C1     -24.2486070 36.8018971
    
    
    $m2a
    $m2a$O1
                 2.5%      97.5%
    O1 > 1  0.6102887  1.6309554
    O1 > 2 -0.4562767  0.5218901
    O1 > 3 -1.6867818 -0.8048017
    C2     -1.4254151  0.8036173
    
    
    $m2b
    $m2b$O2
                 2.5%       97.5%
    O2 > 1  0.9401770  1.75320147
    O2 > 2 -0.1175513  0.47079928
    O2 > 3 -1.5458580 -0.75204388
    C2     -1.8764105  0.08353113
    
    
    $m3a
    $m3a$C1
                        2.5%      97.5%
    (Intercept)  1.427061043 1.47657813
    O1.L        -0.014073626 0.09725592
    O1.Q        -0.026317632 0.16013420
    O1.C        -0.003815161 0.09471880
    
    
    $m3b
    $m3b$C1
                        2.5%       97.5%
    (Intercept)  1.427085824 1.438861959
    O22         -0.007998298 0.009558208
    O23         -0.007810045 0.011350991
    O24         -0.008529130 0.005873684
    
    
    $m4a
    $m4a$O1
                            2.5%      97.5%
    O1 > 1            -0.6983920  0.8430801
    O1 > 2            -1.9098555 -0.2979375
    O1 > 3            -3.1403933 -1.4588523
    M22               -1.0158650  0.3353908
    M23               -1.1496576  0.2510169
    M24               -1.2660566  0.1925154
    O22                0.4734436  2.5719514
    O23                1.3693795  5.2630614
    O24               -0.6747292  2.1933668
    abs(C1 - C2)      -1.1169351  1.2505698
    log(C1)          -41.0989671 32.5897140
    O22:abs(C1 - C2)  -1.1551747  0.5572573
    O23:abs(C1 - C2)  -2.4719827  0.1178019
    O24:abs(C1 - C2)  -1.3917247  0.7749933
    
    
    $m4b
    $m4b$O1
                                                                      2.5%
    O1 > 1                                                       0.7041012
    O1 > 2                                                      -0.3065579
    O1 > 3                                                      -1.7591514
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)                0.2505599
    abs(C1 - C2)                                                -0.8959353
    log(C1)                                                    -42.8430804
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -1.7851153
                                                                    97.5%
    O1 > 1                                                      1.3983236
    O1 > 2                                                      0.3399476
    O1 > 3                                                     -0.9995948
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               3.5416607
    abs(C1 - C2)                                                1.6409697
    log(C1)                                                    22.2062993
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.5400665
    
    
    $m5a
    $m5a$O1
                  2.5%      97.5%
    O1 > 1  -0.3195088  0.9598189
    O1 > 2  -1.6927364 -0.2354202
    O1 > 3  -2.9312848 -1.4461807
    M22     -0.3932740  0.8669502
    M23     -0.2038340  1.0062703
    M24     -0.7710896  0.7507077
    O22     -0.5239641  1.6547782
    O23      0.1608464  1.9051242
    O24     -0.4752860  1.1030486
    C1     -22.8760875 19.1727095
    C2      -0.5122600  1.4152615
    C1     -16.5989363 17.3080731
    C2      -0.3739016  1.4564378
    C1     -18.7349950 26.6923080
    C2      -1.0482607  1.4414023
    
    
    $m5b
    $m5b$O1
                   2.5%      97.5%
    O1 > 1  -0.25200127  1.2008006
    O1 > 2  -1.41576054  0.3429875
    O1 > 3  -2.84448842 -1.0412872
    M22     -0.70102448  0.8753301
    M23     -0.97478307  1.1381814
    M24     -1.08529041  0.6384003
    O22      0.23357592  1.4363929
    O23      0.46827375  1.9361371
    O24     -0.02917112  1.1057263
    C1:C2   -1.48398419  3.5339037
    C1     -23.64298431 21.6439076
    C2      -4.01316792  2.8214525
    C1     -15.03327995 18.9622683
    C2      -4.95086335  2.4014455
    C1     -19.19529150 28.3870178
    C2      -4.97683066  2.4827680
    
    
    $m5c
    $m5c$O1
                    2.5%      97.5%
    O1 > 1   0.185974517  1.5233052
    O1 > 2  -1.048142063  0.5134274
    O1 > 3  -2.509905907 -0.7040824
    M22     -1.316907105  0.8018673
    M23     -1.091761870  0.5516659
    M24     -1.310361261 -0.1901848
    O22      0.005496614  1.4988243
    O23      0.502225436  1.8264157
    O24     -0.265607663  1.2096639
    C1     -33.386418015 24.7639934
    C2      -2.551825058  0.5537774
    C1:C2   -0.244570337  2.1338184
    C1     -22.746936221 19.1248389
    C2      -0.940302495  1.2638537
    C1:C2   -1.005235834  0.9827404
    C1     -25.142484723 42.8086666
    C2      -2.120572684  1.0795931
    C1:C2   -0.537440035  1.6921279
    
    
    $m5d
    $m5d$O1
                  2.5%      97.5%
    O1 > 1  -0.1689379  1.4894496
    O1 > 2  -1.1921564  0.6229498
    O1 > 3  -2.6721038 -0.9885213
    M22     -0.6098327  0.8076460
    M23     -1.1718663  0.6622466
    M24     -0.7989810  0.6811750
    O22     -0.8475776  1.5653176
    O23      0.1851692  2.5078203
    O24     -0.4582431  1.2366768
    M22:C2  -3.2000540  0.6599821
    M23:C2  -2.8349463  1.5271753
    M24:C2  -1.7943990  4.0023851
    C1     -32.5626345 23.8266089
    C2      -1.4009384  2.6465389
    C1     -20.9325675 16.9841020
    C2      -1.2541586  1.5938974
    C1     -22.1123288 27.6969311
    C2      -2.1962339  1.2036617
    
    
    $m5e
    $m5e$O1
                   2.5%       97.5%
    O1 > 1  -0.57272203  0.39027481
    O1 > 2  -0.64370589  0.28134105
    O1 > 3  -1.13569257  0.06134955
    C1     -28.06706310 43.35135463
    M22      1.19067760  2.64534361
    M23     -3.87303258  0.54137366
    M24     -1.04162946  0.51809363
    C2      -2.64319081  3.30374289
    O22     -0.06731357  2.77300928
    O23      2.05757115  3.97904424
    O24     -1.35231031  1.06492016
    M22:C2   0.96978174  7.69763721
    M23:C2 -12.08370093  0.34207369
    M24:C2   4.20774019 17.09240585
    C1     -36.87588538  8.01070353
    M22     -1.19348062  0.52487260
    M23     -1.08119140  0.77314450
    M24     -1.18611356  0.19495364
    C2      -0.33741779  1.82421741
    O22     -0.67457368  1.21963876
    O23      0.08659713  1.53536242
    O24     -0.09948201  1.24561143
    M22:C2  -4.68090363  0.78365492
    M23:C2  -1.78055092  1.67108646
    M24:C2  -3.43870263  0.91862332
    C1     -28.20545142 24.50288670
    M22     -2.76117001 -0.36692448
    M23     -2.73692343 -0.08719270
    M24     -3.46373639 -0.36414381
    C2      -1.70994200  1.86252312
    O22     -1.35513761  1.15303564
    O23     -0.09588429  1.42369074
    O24     -2.40904190 -0.04987549
    M22:C2  -8.14200983  0.49529361
    M23:C2  -6.98008725  3.71829387
    M24:C2  -1.28001614  4.75579373
    
    
    $m6a
    $m6a$O1
                  2.5%      97.5%
    O1 > 1  -1.7520974 -0.1881495
    O1 > 2  -0.8055116  0.9865119
    O1 > 3   0.1988844  2.3403813
    M22     -0.8741144  1.0295919
    M23     -1.0263889  1.2673812
    M24     -0.8312354  1.5765832
    O22     -1.2683696  0.4845602
    O23     -2.0687304 -0.2389565
    O24     -1.0425973  0.7040273
    C1     -27.1763897 20.5073862
    C2      -2.4394803  0.8877031
    C1     -23.6360721 23.5884741
    C2      -1.5394453  0.7732481
    C1     -54.6456692 30.3358488
    C2      -1.6460524  0.8877789
    
    
    $m6b
    $m6b$O1
                   2.5%        97.5%
    O1 > 1  -1.46277755  0.016816087
    O1 > 2  -0.57036741  1.097897469
    O1 > 3   0.61924271  2.614495508
    M22     -1.28283999  1.042758738
    M23     -1.15983838  0.708673652
    M24     -1.02666004  0.851406834
    O22     -1.08147315  0.578812412
    O23     -1.43527161 -0.009381978
    O24     -0.78577602  0.545513967
    C1:C2    0.01172845  2.336074595
    C1     -18.28559039 24.937134677
    C2      -4.22706971 -0.033153769
    C1     -16.78304130 22.006253630
    C2      -4.06887046 -0.106448723
    C1     -23.47382244 22.748434659
    C2      -3.64518786  0.130662574
    
    
    $m6c
    $m6c$O1
                   2.5%      97.5%
    O1 > 1  -1.23402154 -0.2722993
    O1 > 2  -0.20562667  0.9544025
    O1 > 3   1.02649047  2.2546703
    M22     -0.68124103  0.7029645
    M23     -0.55729203  0.8973943
    M24     -0.43227418  0.8597950
    O22     -0.95150214  0.5887584
    O23     -1.71438167 -0.3601706
    O24     -0.79101192  0.4822315
    C1     -14.35857123 38.7546578
    C2      -3.15151900  2.9275176
    C1:C2   -3.08906975  1.6221691
    C1     -20.27697210 32.9017649
    C2      -6.51123834  1.1475162
    C1:C2   -0.55244353  4.0006910
    C1     -31.67076706 33.6613513
    C2      -4.47022800  0.0676389
    C1:C2   -0.05371522  3.0989501
    
    
    $m6d
    $m6d$O1
                  2.5%       97.5%
    O1 > 1  -1.4908608  0.03032698
    O1 > 2  -0.3059452  1.08317627
    O1 > 3   1.0865413  2.49129608
    M22     -0.7559268  1.05222390
    M23     -0.5563582  1.08648272
    M24     -0.4514271  0.97652968
    O22     -1.2257996  0.09402384
    O23     -1.9150459 -0.50861107
    O24     -1.4802892  0.59275053
    M22:C2  -1.6247713  5.28069443
    M23:C2  -2.4149425  3.13894288
    M24:C2  -3.2991735  3.18945697
    C1     -27.0022730 44.20279190
    C2      -3.0016031  1.18070199
    C1     -27.6230547 28.76058173
    C2      -2.9212231  1.49182994
    C1     -50.4292619 40.13815254
    C2      -2.8455190  1.84507749
    
    
    $m6e
    $m6e$O1
                  2.5%       97.5%
    O1 > 1  -1.0343871  0.03860266
    O1 > 2  -0.6308554  0.73968274
    O1 > 3  -0.6014118  1.50666983
    C1     -41.1881023 47.39522195
    M22     -1.8599025  0.49873106
    M23     -0.5293270  1.72201942
    M24     -0.8718149  1.34438759
    C2      -1.3107817  2.47048269
    O22     -2.6145259  0.16594523
    O23     -3.3969759 -1.22678512
    O24     -1.4099577  0.59890318
    M22:C2  -5.4122531  0.90282021
    M23:C2  -1.9471339  2.20988785
    M24:C2  -8.6175596 -2.62400476
    C1     -28.4760028 22.88916042
    M22     -0.2216978  1.49687626
    M23     -1.4978787  0.82887185
    M24     -0.6129649  1.40964912
    C2      -3.9125585  1.48660202
    O22     -1.8136647  0.60996890
    O23     -1.2732745 -0.18515588
    O24     -0.9777241  0.74246845
    M22:C2  -1.9498782  6.78497541
    M23:C2  -4.5927806  0.91677344
    M24:C2  -2.9083870  4.66674785
    C1     -68.4460353  5.20487463
    M22      0.7383721  3.30183192
    M23     -0.0134552  1.66142252
    M24      0.3578133  3.05498824
    C2      -1.8630890  0.50521821
    O22     -1.6045778  0.90777741
    O23     -1.8641236  0.40056273
    O24      0.1110135  2.23495002
    M22:C2   1.2064429  6.19083279
    M23:C2  -2.2794536  2.50598416
    M24:C2  -1.6511611  2.37835130
    
    

---

    $m0a
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
         Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    
    Posterior summary of the intercepts:
               Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  1.12038 0.187  0.833  1.484      0.000   1.516 0.2027
    O1 > 2 -0.00108 0.156 -0.237  0.240      0.933   0.981 0.1826
    O1 > 3 -1.29248 0.235 -1.622 -0.895      0.000   1.009 0.0786
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m0b
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O2 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
         Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O2 > 1  1.209 0.210  0.742  1.559      0.000   1.136  0.183
    O2 > 2  0.175 0.214 -0.207  0.497      0.467   1.345  0.183
    O2 > 3 -1.012 0.222 -1.396 -0.611      0.000   0.999  0.125
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m1a
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
        Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    C1 -2.43 12.9 -31.8  16.1      0.867    1.17  0.183
    
    Posterior summary of the intercepts:
              Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.9572 0.191  0.663  1.311        0.0    2.15  0.308
    O1 > 2 -0.0435 0.156 -0.357  0.230        0.6    1.02  0.183
    O1 > 3 -1.3243 0.216 -1.669 -0.964        0.0    1.09  0.183
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m1b
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O2 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
       Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    C1 10.1 17.1 -24.2  36.8      0.467    1.15  0.183
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O2 > 1  1.357 0.211  0.927  1.643      0.000    1.67 0.2223
    O2 > 2  0.217 0.234 -0.146  0.620      0.333    1.21 0.1826
    O2 > 3 -0.966 0.279 -1.392 -0.522      0.000    1.24 0.0744
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m2a
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
        Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    C2 -0.18 0.627 -1.43 0.804      0.867    1.23  0.183
    
    Posterior summary of the intercepts:
              Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  1.0353 0.275  0.610  1.631      0.000    1.39  0.183
    O1 > 2  0.0112 0.244 -0.456  0.522      0.867    1.31  0.108
    O1 > 3 -1.2521 0.260 -1.687 -0.805      0.000    1.03  0.100
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m2b
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
         Mean    SD  2.5%  97.5% tail-prob. GR-crit MCE/SD
    C2 -0.915 0.564 -1.88 0.0835     0.0667    2.65  0.339
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O2 > 1  1.250 0.240  0.940  1.753      0.000    1.25  0.263
    O2 > 2  0.155 0.184 -0.118  0.471      0.467    1.06  0.183
    O2 > 3 -1.090 0.208 -1.546 -0.752      0.000    1.31  0.183
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m3a
    
    Bayesian linear model fitted with JointAI
    
    Call:
    lm_imp(formula = C1 ~ O1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
                   Mean     SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    (Intercept) 1.43646 0.0119  1.42706 1.4766      0.000    1.09  0.183
    O1.L        0.00639 0.0273 -0.01407 0.0973      0.867    1.21  0.183
    O1.Q        0.01235 0.0609 -0.02632 0.1601      1.000    1.97  0.183
    O1.C        0.00936 0.0253 -0.00382 0.0947      0.667    1.20  0.183
    
    Posterior summary of residual std. deviation:
               Mean     SD   2.5% 97.5% GR-crit MCE/SD
    sigma_C1 0.0288 0.0303 0.0165 0.113    1.42  0.183
    
    
    MCMC settings:
    Iterations = 1:10
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m3b
    
    Bayesian linear model fitted with JointAI
    
    Call:
    lm_imp(formula = C1 ~ O2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
                    Mean      SD     2.5%   97.5% tail-prob. GR-crit MCE/SD
    (Intercept) 1.432507 0.00343  1.42709 1.43886      0.000    1.24  0.183
    O22         0.002802 0.00493 -0.00800 0.00956      0.533    1.17  0.183
    O23         0.003139 0.00486 -0.00781 0.01135      0.467    1.42  0.183
    O24         0.000306 0.00445 -0.00853 0.00587      0.867    1.20  0.183
    
    Posterior summary of residual std. deviation:
               Mean      SD   2.5%  97.5% GR-crit MCE/SD
    sigma_C1 0.0193 0.00138 0.0173 0.0223     1.8  0.183
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m4a
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF, 
        n.adapt = 5, n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                        Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    M22              -0.4105  0.369  -1.016  0.335      0.267    1.18  0.183
    M23              -0.4481  0.472  -1.150  0.251      0.467    1.66  0.330
    M24              -0.5045  0.392  -1.266  0.193      0.200    1.40  0.278
    O22               1.4913  0.664   0.473  2.572      0.000    2.32  0.333
    O23               2.6302  1.170   1.369  5.263      0.000    5.30  0.587
    O24               0.2531  0.909  -0.675  2.193      0.800    5.59  0.389
    abs(C1 - C2)     -0.0025  0.668  -1.117  1.251      1.000    2.27  0.183
    log(C1)          -1.3370 19.798 -41.099 32.590      0.800    1.16  0.183
    O22:abs(C1 - C2) -0.4854  0.501  -1.155  0.557      0.400    2.10  0.445
    O23:abs(C1 - C2) -0.8662  0.739  -2.472  0.118      0.200    3.77  0.539
    O24:abs(C1 - C2)  0.1557  0.668  -1.392  0.775      0.533    9.69  0.571
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.242 0.477 -0.698  0.843      0.467    9.87  0.622
    O1 > 2 -0.821 0.529 -1.910 -0.298      0.000    7.74  1.073
    O1 > 3 -2.118 0.513 -3.140 -1.459      0.000    5.16  1.036
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m4b
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ ifelse(as.numeric(O2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1), data = wideDF, n.adapt = 5, 
        n.iter = 10, seed = 2020, warn = FALSE)
    
    
    Posterior summary:
                                                                 Mean     SD
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               1.696  1.131
    abs(C1 - C2)                                                0.384  0.708
    log(C1)                                                    -8.016 18.092
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.551  0.824
                                                                  2.5% 97.5%
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)                0.251  3.54
    abs(C1 - C2)                                                -0.896  1.64
    log(C1)                                                    -42.843 22.21
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -1.785  0.54
                                                               tail-prob. GR-crit
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)                   0.000   10.19
    abs(C1 - C2)                                                    0.533    1.72
    log(C1)                                                         0.667    1.27
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)      0.800    8.80
                                                               MCE/SD
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               0.389
    abs(C1 - C2)                                                0.183
    log(C1)                                                     0.183
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.865
    
    Posterior summary of the intercepts:
              Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  1.0654 0.180  0.704  1.40      0.000    2.08  0.188
    O1 > 2 -0.0107 0.192 -0.307  0.34      0.933    1.61  0.183
    O1 > 3 -1.3736 0.224 -1.759 -1.00      0.000    1.12  0.183
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m5a
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ C1 + C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
    
    Posterior summary:
               Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    M22      0.2722  0.386  -0.393  0.867     0.6667    1.61  0.183
    M23      0.4187  0.346  -0.204  1.006     0.2667    1.91  0.221
    M24      0.0613  0.458  -0.771  0.751     0.9333    1.94  0.183
    O22      0.4512  0.660  -0.524  1.655     0.6000    1.58  0.460
    O23      1.1165  0.532   0.161  1.905     0.0667    1.89  0.305
    O24      0.3852  0.533  -0.475  1.103     0.4667    1.27  0.253
    O12: C1 -3.7853 11.712 -22.876 19.173     0.6000    2.77  0.376
    O12: C2  0.4167  0.635  -0.512  1.415     0.6000    1.82  0.204
    O13: C1 -0.2843  9.594 -16.599 17.308     1.0000    1.60  0.183
    O13: C2  0.5728  0.488  -0.374  1.456     0.2667    1.58  0.370
    O14: C1  0.1892 15.443 -18.735 26.692     0.9333    1.78  0.223
    O14: C2  0.3490  0.706  -1.048  1.441     0.6000    1.03  0.183
    
    Posterior summary of the intercepts:
             Mean    SD  2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.333 0.408 -0.32  0.960      0.533    5.29  0.831
    O1 > 2 -0.815 0.404 -1.69 -0.235      0.000    2.79  0.519
    O1 > 3 -2.139 0.434 -2.93 -1.446      0.000    3.88  0.816
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m5b
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
    
    Posterior summary:
               Mean     SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    M22      0.0907  0.495  -0.7010  0.875     0.8667    3.50  0.426
    M23      0.0881  0.626  -0.9748  1.138     0.8667    3.66  0.487
    M24     -0.2949  0.541  -1.0853  0.638     0.6000    5.12  0.711
    O22      0.7608  0.372   0.2336  1.436     0.0000    1.52  0.284
    O23      1.2529  0.432   0.4683  1.936     0.0000    2.36  0.217
    O24      0.6129  0.332  -0.0292  1.106     0.0667    1.35  0.183
    C1:C2    0.3593  1.722  -1.4840  3.534     0.8000   12.04  0.558
    O12: C1 -3.3287 13.058 -23.6430 21.644     0.8667    1.99  0.207
    O12: C2 -0.1641  2.291  -4.0132  2.821     0.6667   11.12  0.637
    O13: C1  3.2186  9.259 -15.0333 18.962     0.7333    1.80  0.183
    O13: C2 -0.1565  2.460  -4.9509  2.401     0.8000   10.44  0.857
    O14: C1  8.4176 14.225 -19.1953 28.387     0.5333    1.11  0.183
    O14: C2 -0.2914  2.392  -4.9768  2.483     0.6667    9.25  0.405
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.357 0.505 -0.252  1.201      0.667    9.74  0.877
    O1 > 2 -0.630 0.543 -1.416  0.343      0.333    7.46  0.771
    O1 > 3 -1.964 0.559 -2.844 -1.041      0.000    6.27  0.524
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m5c
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 * 
            C2), seed = 2020)
    
    
    Posterior summary:
                 Mean     SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    M22        -0.435  0.573  -1.3169  0.802     0.2667    1.57  0.454
    M23        -0.360  0.432  -1.0918  0.552     0.3333    1.47  0.220
    M24        -0.671  0.381  -1.3104 -0.190     0.0000    1.21  0.218
    O22         0.630  0.421   0.0055  1.499     0.0667    1.27  0.183
    O23         1.137  0.358   0.5022  1.826     0.0000    2.17  0.215
    O24         0.450  0.436  -0.2656  1.210     0.4667    1.83  0.294
    O12: C1    -4.640 16.210 -33.3864 24.764     0.7333    1.34  0.183
    O12: C2    -1.121  0.936  -2.5518  0.554     0.2667    2.88  0.408
    O12: C1:C2  1.053  0.750  -0.2446  2.134     0.0667    2.05  0.331
    O13: C1     0.609 11.390 -22.7469 19.125     0.9333    1.76  0.183
    O13: C2     0.300  0.567  -0.9403  1.264     0.5333    2.07  0.303
    O13: C1:C2  0.139  0.490  -1.0052  0.983     0.4667    2.40  0.417
    O14: C1     5.702 18.894 -25.1425 42.809     0.7333    2.53  0.183
    O14: C2    -0.357  0.967  -2.1206  1.080     0.8000    1.52  0.522
    O14: C1:C2  0.452  0.618  -0.5374  1.692     0.4667    1.73  0.474
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.913 0.395  0.186  1.523        0.0    2.75  0.445
    O1 > 2 -0.139 0.462 -1.048  0.513        0.8    2.57  0.474
    O1 > 3 -1.497 0.549 -2.510 -0.704        0.0    2.61  0.314
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m5d
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
    
    Posterior summary:
                Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    M22      0.15112  0.399  -0.610  0.808      0.667    1.36  0.639
    M23     -0.00445  0.534  -1.172  0.662      1.000    3.01  0.243
    M24     -0.11879  0.472  -0.799  0.681      0.867    1.73  0.272
    O22      0.62568  0.691  -0.848  1.565      0.467    4.34  0.399
    O23      1.11117  0.629   0.185  2.508      0.000    2.54  0.402
    O24      0.24210  0.513  -0.458  1.237      0.733    3.51  0.659
    M22:C2  -1.07079  1.173  -3.200  0.660      0.400    1.71  0.216
    M23:C2  -0.30506  1.188  -2.835  1.527      0.867    1.82  0.350
    M24:C2   1.31880  1.638  -1.794  4.002      0.333    2.28  0.232
    O12: C1 -2.08326 15.941 -32.563 23.827      0.933    1.42  0.183
    O12: C2  0.34120  1.171  -1.401  2.647      0.933    1.99  0.238
    O13: C1 -0.01607  9.945 -20.933 16.984      0.800    1.28  0.183
    O13: C2 -0.01960  0.773  -1.254  1.594      0.867    3.46  0.343
    O14: C1  2.39260 14.131 -22.112 27.697      0.933    1.63  0.214
    O14: C2 -0.12212  0.970  -2.196  1.204      0.867    2.15  0.327
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.563 0.508 -0.169  1.489      0.200    5.16  0.701
    O1 > 2 -0.534 0.540 -1.192  0.623      0.333    5.13  0.474
    O1 > 3 -1.912 0.541 -2.672 -0.989      0.000    5.46  1.078
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m5e
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = ~C1 + 
            M2 * C2 + O2, seed = 2020)
    
    
    Posterior summary:
                  Mean     SD     2.5%   97.5% tail-prob. GR-crit MCE/SD
    O12: C1     10.153 19.380 -28.0671 43.3514     0.4667    3.10 0.5185
    O12: M22     1.787  0.423   1.1907  2.6453     0.0000    3.46 0.5816
    O12: M23    -2.110  1.366  -3.8730  0.5414     0.2000    4.38 0.5918
    O12: M24    -0.283  0.417  -1.0416  0.5181     0.4667    2.32 0.2157
    O12: C2      0.149  1.908  -2.6432  3.3037     1.0000    7.84 0.6002
    O12: O22     1.120  0.886  -0.0673  2.7730     0.0667    5.41 0.5520
    O12: O23     3.027  0.573   2.0576  3.9790     0.0000    1.28 0.3262
    O12: O24    -0.194  0.636  -1.3523  1.0649     0.6000    2.46 0.3232
    O12: M22:C2  4.453  1.807   0.9698  7.6976     0.0000    2.01 0.3227
    O12: M23:C2 -5.058  4.088 -12.0837  0.3421     0.1333    4.12 0.4989
    O12: M24:C2 10.022  3.780   4.2077 17.0924     0.0000    1.91 0.1949
    O13: C1     -9.368 11.429 -36.8759  8.0107     0.4667    1.23 0.1943
    O13: M22    -0.412  0.519  -1.1935  0.5249     0.4667    2.97 0.5054
    O13: M23    -0.181  0.534  -1.0812  0.7731     0.7333    4.48 0.6454
    O13: M24    -0.471  0.423  -1.1861  0.1950     0.2667    2.56 0.4169
    O13: C2      0.942  0.741  -0.3374  1.8242     0.2667    3.37 0.5565
    O13: O22     0.416  0.526  -0.6746  1.2196     0.5333    4.77 0.3778
    O13: O23     0.912  0.447   0.0866  1.5354     0.0000    2.19 0.1826
    O13: O24     0.456  0.394  -0.0995  1.2456     0.1333    1.96 0.2727
    O13: M22:C2 -2.386  1.606  -4.6809  0.7837     0.2000    3.69 0.3795
    O13: M23:C2  0.395  1.081  -1.7806  1.6711     0.6000    1.36 0.1826
    O13: M24:C2 -1.530  1.375  -3.4387  0.9186     0.3333    3.81 0.4836
    O14: C1     -1.221 15.712 -28.2055 24.5029     1.0000    1.09 0.0859
    O14: M22    -1.592  0.589  -2.7612 -0.3669     0.0000    1.12 0.2975
    O14: M23    -1.103  0.685  -2.7369 -0.0872     0.0667    1.19 0.2413
    O14: M24    -1.514  0.744  -3.4637 -0.3641     0.0000    1.77 0.1826
    O14: C2      0.192  1.079  -1.7099  1.8625     0.8667    5.58 0.2969
    O14: O22    -0.211  0.633  -1.3551  1.1530     0.7333    2.27 0.2355
    O14: O23     0.604  0.490  -0.0959  1.4237     0.1333    3.57 0.2545
    O14: O24    -1.053  0.703  -2.4090 -0.0499     0.0667    1.75 0.2617
    O14: M22:C2 -3.354  2.600  -8.1420  0.4953     0.2000    2.62 0.3387
    O14: M23:C2 -0.557  2.650  -6.9801  3.7183     1.0000    3.30 0.1826
    O14: M24:C2  0.741  1.561  -1.2800  4.7558     0.6000    3.51 0.3488
    
    Posterior summary of the intercepts:
              Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1 -0.0383 0.282 -0.573 0.3903     0.9333    2.65  0.275
    O1 > 2 -0.1930 0.268 -0.644 0.2813     0.4000    1.68  0.379
    O1 > 3 -0.5568 0.382 -1.136 0.0613     0.0667    4.66  0.458
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m6a
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ C1 + C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
    
    Posterior summary:
              Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    M22      0.338  0.603  -0.874  1.030     0.4000    5.96  0.457
    M23      0.273  0.649  -1.026  1.267     0.6000    2.16  0.405
    M24      0.616  0.677  -0.831  1.577     0.3333    2.62  0.183
    O22     -0.399  0.542  -1.268  0.485     0.5333    3.79  0.413
    O23     -0.944  0.530  -2.069 -0.239     0.0667    2.37  0.509
    O24     -0.245  0.479  -1.043  0.704     0.6000    2.65  0.328
    O12: C1  0.723 12.487 -27.176 20.507     0.9333    1.16  0.204
    O12: C2 -0.705  0.955  -2.439  0.888     0.3333    1.81  0.329
    O13: C1 -1.578 15.071 -23.636 23.588     1.0000    1.20  0.220
    O13: C2 -0.431  0.701  -1.539  0.773     0.6000    2.04  0.325
    O14: C1 -8.120 21.295 -54.646 30.336     0.7333    1.22  0.245
    O14: C2 -0.288  0.687  -1.646  0.888     0.7333    1.37  0.177
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 = 1 -0.950 0.407 -1.752 -0.188     0.0000    3.66  0.332
    O1 = 2  0.126 0.472 -0.806  0.987     0.5333    4.15       
    O1 = 3  1.434 0.509  0.199  2.340     0.0667    3.03  0.399
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m6b
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
    
    Posterior summary:
               Mean     SD     2.5%    97.5% tail-prob. GR-crit MCE/SD
    M22     -0.1088  0.681  -1.2828  1.04276     0.9333    4.01  0.349
    M23     -0.1093  0.536  -1.1598  0.70867     0.8000    2.72  0.315
    M24      0.0206  0.514  -1.0267  0.85141     0.8000    2.08  0.313
    O22     -0.0976  0.477  -1.0815  0.57881     1.0000    2.18  0.302
    O23     -0.7315  0.390  -1.4353 -0.00938     0.0667    2.28  0.287
    O24     -0.0735  0.412  -0.7858  0.54551     1.0000    1.03  0.203
    C1:C2    0.9938  0.773   0.0117  2.33607     0.0667    5.61  0.407
    O12: C1  4.7776 12.768 -18.2856 24.93713     0.7333    1.58  0.213
    O12: C2 -1.8355  1.239  -4.2271 -0.03315     0.0667    3.86  0.307
    O13: C1  1.0834 11.843 -16.7830 22.00625     0.8000    1.21  0.333
    O13: C2 -1.5397  1.158  -4.0689 -0.10645     0.0667    4.53  0.333
    O14: C1 -3.4847 12.878 -23.4738 22.74843     0.7333    1.17  0.183
    O14: C2 -1.4332  1.013  -3.6452  0.13066     0.0667    2.53  0.303
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 = 1 -0.688 0.510 -1.463 0.0168     0.0667    4.42  0.309
    O1 = 2  0.233 0.566 -0.570 1.0979     0.8000    4.36  0.356
    O1 = 3  1.573 0.586  0.619 2.6145     0.0000    3.75  0.486
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m6c
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 * 
            C2), rev = "O1", seed = 2020)
    
    
    Posterior summary:
                   Mean     SD     2.5%   97.5% tail-prob. GR-crit MCE/SD
    M22        -0.00519  0.414  -0.6812  0.7030     0.8667    3.99  0.414
    M23         0.10131  0.443  -0.5573  0.8974     0.9333    1.95  0.233
    M24         0.24826  0.381  -0.4323  0.8598     0.4667    1.70  0.186
    O22        -0.37049  0.427  -0.9515  0.5888     0.3333    1.38  0.183
    O23        -0.95543  0.399  -1.7144 -0.3602     0.0000    1.45  0.183
    O24        -0.19073  0.409  -0.7910  0.4822     0.6667    1.03  0.161
    O12: C1     8.72364 14.113 -14.3586 38.7547     0.4000    1.37  0.226
    O12: C2    -0.12052  2.069  -3.1515  2.9275     0.9333   11.90  0.689
    O12: C1:C2 -0.25149  1.444  -3.0891  1.6222     0.8000   11.79  0.542
    O13: C1     4.66681 12.767 -20.2770 32.9018     0.8000    1.37  0.345
    O13: C2    -1.85279  2.576  -6.5112  1.1475     0.6667   10.65  0.731
    O13: C1:C2  1.18458  1.540  -0.5524  4.0007     0.6667    8.68  0.450
    O14: C1     4.27307 18.448 -31.6708 33.6614     0.6667    1.01  0.183
    O14: C2    -1.79409  1.309  -4.4702  0.0676     0.1333    2.44  0.563
    O14: C1:C2  1.27482  0.942  -0.0537  3.0990     0.0667    2.26  0.472
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 = 1 -0.781 0.295 -1.234 -0.272        0.0    2.91  0.389
    O1 = 2  0.329 0.304 -0.206  0.954        0.2    2.48       
    O1 = 3  1.716 0.371  1.026  2.255        0.0    2.60  0.299
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m6d
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
    
    Posterior summary:
               Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    M22      0.2664  0.453  -0.756  1.052      0.400    2.85 0.4319
    M23      0.0751  0.514  -0.556  1.086      0.933    2.40 0.1826
    M24      0.3777  0.437  -0.451  0.977      0.400    2.39 0.3112
    O22     -0.6324  0.375  -1.226  0.094      0.133    2.47 0.2167
    O23     -1.1658  0.414  -1.915 -0.509      0.000    1.84 0.3903
    O24     -0.4669  0.532  -1.480  0.593      0.333    1.35 0.0701
    M22:C2   1.0411  2.083  -1.625  5.281      0.867    2.30 0.3515
    M23:C2   0.1195  1.676  -2.415  3.139      0.933    2.13 0.4008
    M24:C2  -0.4912  1.950  -3.299  3.189      0.867    3.35 0.3760
    O12: C1  4.4332 19.049 -27.002 44.203      0.800    1.31 0.2920
    O12: C2 -0.2227  1.477  -3.002  1.181      0.733    3.55 0.5059
    O13: C1  7.6051 17.031 -27.623 28.761      0.533    2.25 0.4995
    O13: C2 -0.1151  1.403  -2.921  1.492      0.733    3.48 0.6208
    O14: C1  5.7548 26.151 -50.429 40.138      0.667    3.02 0.4203
    O14: C2  0.0461  1.399  -2.846  1.845      0.733    2.74 0.3733
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 = 1 -0.667 0.510 -1.491 0.0303      0.133    5.74  0.573
    O1 = 2  0.396 0.431 -0.306 1.0832      0.333    3.86  0.506
    O1 = 3  1.762 0.428  1.087 2.4913      0.000    2.63  0.350
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    
    $m6e
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = ~C1 + 
            M2 * C2 + O2, rev = "O1", seed = 2020)
    
    
    Posterior summary:
                    Mean     SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    O12: C1      -9.3902 24.129 -41.1881 47.395     0.6667    3.47  0.295
    O12: M22     -0.4149  0.700  -1.8599  0.499     0.6667    5.43  0.314
    O12: M23      0.6033  0.757  -0.5293  1.722     0.4667    5.02  0.439
    O12: M24      0.3400  0.620  -0.8718  1.344     0.5333    2.38  0.299
    O12: C2       0.3261  1.192  -1.3108  2.470     1.0000    2.84  0.434
    O12: O22     -1.2951  0.927  -2.6145  0.166     0.1333    1.67  0.470
    O12: O23     -1.9954  0.617  -3.3970 -1.227     0.0000    1.02  0.242
    O12: O24     -0.2708  0.562  -1.4100  0.599     0.7333    1.29  0.183
    O12: M22:C2  -1.7929  2.200  -5.4123  0.903     0.7333    4.26  0.495
    O12: M23:C2   0.1277  1.235  -1.9471  2.210     0.9333    2.25  0.239
    O12: M24:C2  -5.1787  1.680  -8.6176 -2.624     0.0000    1.49  0.341
    O13: C1      -2.4287 16.399 -28.4760 22.889     0.9333    6.45  0.456
    O13: M22      0.8280  0.520  -0.2217  1.497     0.1333    3.00  0.430
    O13: M23     -0.3107  0.607  -1.4979  0.829     0.4667    3.35  0.444
    O13: M24      0.3949  0.572  -0.6130  1.410     0.4000    4.74  0.539
    O13: C2      -0.8157  1.887  -3.9126  1.487     0.8000   10.05  0.581
    O13: O22     -0.5388  0.712  -1.8137  0.610     0.4667    2.61  0.441
    O13: O23     -0.8052  0.324  -1.2733 -0.185     0.0000    1.66  0.267
    O13: O24     -0.1788  0.533  -0.9777  0.742     0.8000    2.38  0.287
    O13: M22:C2   1.9812  2.994  -1.9499  6.785     0.8000    5.96  0.594
    O13: M23:C2  -1.5803  1.285  -4.5928  0.917     0.2667    1.52  0.226
    O13: M24:C2   0.8063  2.108  -2.9084  4.667     0.6000    4.61  0.284
    O14: C1     -23.4804 22.362 -68.4460  5.205     0.2000    5.53  0.741
    O14: M22      2.0767  0.810   0.7384  3.302     0.0000    4.08  0.309
    O14: M23      0.8054  0.529  -0.0135  1.661     0.1333    3.51  0.479
    O14: M24      1.7535  0.825   0.3578  3.055     0.0000    3.66  0.447
    O14: C2      -0.5557  0.737  -1.8631  0.505     0.5333    4.57  0.482
    O14: O22     -0.3104  0.695  -1.6046  0.908     0.6667    2.26  0.387
    O14: O23     -0.8931  0.684  -1.8641  0.401     0.2667    4.64  0.608
    O14: O24      1.1706  0.653   0.1110  2.235     0.0667    1.63  0.324
    O14: M22:C2   3.5823  1.542   1.2064  6.191     0.0000    2.42  0.299
    O14: M23:C2  -0.0868  1.393  -2.2795  2.506     0.9333    1.28  0.183
    O14: M24:C2   0.0845  1.238  -1.6512  2.378     0.9333    1.26  0.483
    
    Posterior summary of the intercepts:
              Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 = 1 -0.5111 0.303 -1.034 0.0386      0.133    4.55  0.582
    O1 = 2 -0.0617 0.357 -0.631 0.7397      0.800    3.93  0.418
    O1 = 3  0.2883 0.578 -0.601 1.5067      0.667    2.75  0.483
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 100 
    

---

    $m0a
    $m0a$O1
         Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    
    
    $m0b
    $m0b$O2
         Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    
    
    $m1a
    $m1a$O1
            Mean      SD      2.5%    97.5% tail-prob.  GR-crit    MCE/SD
    C1 -2.426635 12.9443 -31.82852 16.13393  0.8666667 1.168318 0.1825742
    
    
    $m1b
    $m1b$O2
          Mean       SD      2.5%   97.5% tail-prob.  GR-crit    MCE/SD
    C1 10.1375 17.12153 -24.24861 36.8019  0.4666667 1.147318 0.1825742
    
    
    $m2a
    $m2a$O1
             Mean        SD      2.5%     97.5% tail-prob.  GR-crit    MCE/SD
    C2 -0.1801598 0.6265016 -1.425415 0.8036173  0.8666667 1.232444 0.1825742
    
    
    $m2b
    $m2b$O2
             Mean       SD      2.5%      97.5% tail-prob.  GR-crit    MCE/SD
    C2 -0.9148039 0.563654 -1.876411 0.08353113 0.06666667 2.646827 0.3393658
    
    
    $m3a
    $m3a$C1
                       Mean         SD         2.5%      97.5% tail-prob.  GR-crit
    (Intercept) 1.436463811 0.01185681  1.427061043 1.47657813  0.0000000 1.089550
    O1.L        0.006394116 0.02729519 -0.014073626 0.09725592  0.8666667 1.212686
    O1.Q        0.012351738 0.06091733 -0.026317632 0.16013420  1.0000000 1.967077
    O1.C        0.009362007 0.02530659 -0.003815161 0.09471880  0.6666667 1.202390
                   MCE/SD
    (Intercept) 0.1825742
    O1.L        0.1825742
    O1.Q        0.1825742
    O1.C        0.1825742
    
    
    $m3b
    $m3b$C1
                        Mean          SD         2.5%       97.5% tail-prob.
    (Intercept) 1.4325073793 0.003425844  1.427085824 1.438861959  0.0000000
    O22         0.0028016071 0.004925283 -0.007998298 0.009558208  0.5333333
    O23         0.0031386255 0.004858210 -0.007810045 0.011350991  0.4666667
    O24         0.0003059072 0.004450778 -0.008529130 0.005873684  0.8666667
                 GR-crit    MCE/SD
    (Intercept) 1.240224 0.1825742
    O22         1.166908 0.1825742
    O23         1.423326 0.1825742
    O24         1.197626 0.1825742
    
    
    $m4a
    $m4a$O1
                           Mean         SD        2.5%      97.5% tail-prob.
    M22              -0.4105287  0.3694907  -1.0158650  0.3353908  0.2666667
    M23              -0.4481260  0.4718186  -1.1496576  0.2510169  0.4666667
    M24              -0.5045137  0.3922363  -1.2660566  0.1925154  0.2000000
    O22               1.4912517  0.6641266   0.4734436  2.5719514  0.0000000
    O23               2.6301532  1.1699846   1.3693795  5.2630614  0.0000000
    O24               0.2531003  0.9088829  -0.6747292  2.1933668  0.8000000
    abs(C1 - C2)     -0.0024989  0.6677401  -1.1169351  1.2505698  1.0000000
    log(C1)          -1.3370254 19.7982143 -41.0989671 32.5897140  0.8000000
    O22:abs(C1 - C2) -0.4854031  0.5012492  -1.1551747  0.5572573  0.4000000
    O23:abs(C1 - C2) -0.8661857  0.7390963  -2.4719827  0.1178019  0.2000000
    O24:abs(C1 - C2)  0.1556598  0.6680127  -1.3917247  0.7749933  0.5333333
                      GR-crit    MCE/SD
    M22              1.181622 0.1825742
    M23              1.664909 0.3301828
    M24              1.395804 0.2783519
    O22              2.316085 0.3329430
    O23              5.297524 0.5867221
    O24              5.594596 0.3888318
    abs(C1 - C2)     2.273287 0.1825742
    log(C1)          1.161352 0.1825742
    O22:abs(C1 - C2) 2.102732 0.4445750
    O23:abs(C1 - C2) 3.774657 0.5392507
    O24:abs(C1 - C2) 9.690705 0.5713474
    
    
    $m4b
    $m4b$O1
                                                                     Mean
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               1.6961350
    abs(C1 - C2)                                                0.3843563
    log(C1)                                                    -8.0162020
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.5510412
                                                                       SD
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               1.1312545
    abs(C1 - C2)                                                0.7082249
    log(C1)                                                    18.0917857
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.8240207
                                                                      2.5%
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)                0.2505599
    abs(C1 - C2)                                                -0.8959353
    log(C1)                                                    -42.8430804
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -1.7851153
                                                                    97.5%
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               3.5416607
    abs(C1 - C2)                                                1.6409697
    log(C1)                                                    22.2062993
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.5400665
                                                               tail-prob.   GR-crit
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               0.0000000 10.189969
    abs(C1 - C2)                                                0.5333333  1.721466
    log(C1)                                                     0.6666667  1.274218
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.8000000  8.798436
                                                                  MCE/SD
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)              0.3891343
    abs(C1 - C2)                                               0.1825742
    log(C1)                                                    0.1825742
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.8653425
    
    
    $m5a
    $m5a$O1
                   Mean         SD        2.5%      97.5% tail-prob.  GR-crit
    M22      0.27220064  0.3864388  -0.3932740  0.8669502 0.66666667 1.610213
    M23      0.41870659  0.3458262  -0.2038340  1.0062703 0.26666667 1.908308
    M24      0.06127484  0.4583465  -0.7710896  0.7507077 0.93333333 1.936815
    O22      0.45121507  0.6604955  -0.5239641  1.6547782 0.60000000 1.583368
    O23      1.11648042  0.5315229   0.1608464  1.9051242 0.06666667 1.889780
    O24      0.38524849  0.5334378  -0.4752860  1.1030486 0.46666667 1.273095
    O12: C1 -3.78528834 11.7121808 -22.8760875 19.1727095 0.60000000 2.774663
    O12: C2  0.41667706  0.6351594  -0.5122600  1.4152615 0.60000000 1.816548
    O13: C1 -0.28425994  9.5940779 -16.5989363 17.3080731 1.00000000 1.603177
    O13: C2  0.57279245  0.4880240  -0.3739016  1.4564378 0.26666667 1.580839
    O14: C1  0.18921215 15.4425278 -18.7349950 26.6923080 0.93333333 1.776885
    O14: C2  0.34901393  0.7059830  -1.0482607  1.4414023 0.60000000 1.028660
               MCE/SD
    M22     0.1825742
    M23     0.2213175
    M24     0.1825742
    O22     0.4601649
    O23     0.3046772
    O24     0.2530912
    O12: C1 0.3757092
    O12: C2 0.2038043
    O13: C1 0.1825742
    O13: C2 0.3700035
    O14: C1 0.2231079
    O14: C2 0.1825742
    
    
    $m5b
    $m5b$O1
                   Mean         SD         2.5%      97.5% tail-prob.   GR-crit
    M22      0.09070221  0.4948783  -0.70102448  0.8753301 0.86666667  3.499136
    M23      0.08813786  0.6256499  -0.97478307  1.1381814 0.86666667  3.657342
    M24     -0.29490449  0.5408033  -1.08529041  0.6384003 0.60000000  5.117558
    O22      0.76082413  0.3715308   0.23357592  1.4363929 0.00000000  1.518412
    O23      1.25294010  0.4317910   0.46827375  1.9361371 0.00000000  2.356408
    O24      0.61285980  0.3315104  -0.02917112  1.1057263 0.06666667  1.345258
    C1:C2    0.35934619  1.7219243  -1.48398419  3.5339037 0.80000000 12.038387
    O12: C1 -3.32870953 13.0583540 -23.64298431 21.6439076 0.86666667  1.993580
    O12: C2 -0.16414201  2.2911815  -4.01316792  2.8214525 0.66666667 11.121954
    O13: C1  3.21861465  9.2594640 -15.03327995 18.9622683 0.73333333  1.796977
    O13: C2 -0.15651736  2.4596771  -4.95086335  2.4014455 0.80000000 10.443449
    O14: C1  8.41759231 14.2250780 -19.19529150 28.3870178 0.53333333  1.105435
    O14: C2 -0.29138506  2.3916514  -4.97683066  2.4827680 0.66666667  9.250450
               MCE/SD
    M22     0.4256158
    M23     0.4870531
    M24     0.7112384
    O22     0.2840155
    O23     0.2168094
    O24     0.1825742
    C1:C2   0.5578750
    O12: C1 0.2074690
    O12: C2 0.6369928
    O13: C1 0.1825742
    O13: C2 0.8569105
    O14: C1 0.1825742
    O14: C2 0.4046644
    
    
    $m5c
    $m5c$O1
                     Mean         SD          2.5%      97.5% tail-prob.  GR-crit
    M22        -0.4345671  0.5728386  -1.316907105  0.8018673 0.26666667 1.565526
    M23        -0.3598824  0.4324672  -1.091761870  0.5516659 0.33333333 1.467844
    M24        -0.6711653  0.3808718  -1.310361261 -0.1901848 0.00000000 1.209103
    O22         0.6300617  0.4205266   0.005496614  1.4988243 0.06666667 1.269794
    O23         1.1370647  0.3575827   0.502225436  1.8264157 0.00000000 2.171012
    O24         0.4504774  0.4363807  -0.265607663  1.2096639 0.46666667 1.830525
    O12: C1    -4.6398093 16.2098688 -33.386418015 24.7639934 0.73333333 1.340741
    O12: C2    -1.1211857  0.9362221  -2.551825058  0.5537774 0.26666667 2.877757
    O12: C1:C2  1.0533686  0.7504892  -0.244570337  2.1338184 0.06666667 2.046818
    O13: C1     0.6086971 11.3902542 -22.746936221 19.1248389 0.93333333 1.763124
    O13: C2     0.2995319  0.5673304  -0.940302495  1.2638537 0.53333333 2.072791
    O13: C1:C2  0.1386650  0.4902048  -1.005235834  0.9827404 0.46666667 2.396243
    O14: C1     5.7016387 18.8939086 -25.142484723 42.8086666 0.73333333 2.531866
    O14: C2    -0.3573073  0.9667021  -2.120572684  1.0795931 0.80000000 1.517055
    O14: C1:C2  0.4520274  0.6176472  -0.537440035  1.6921279 0.46666667 1.725167
                  MCE/SD
    M22        0.4537789
    M23        0.2201022
    M24        0.2182180
    O22        0.1825742
    O23        0.2145113
    O24        0.2943410
    O12: C1    0.1825742
    O12: C2    0.4080462
    O12: C1:C2 0.3307472
    O13: C1    0.1825742
    O13: C2    0.3028487
    O13: C1:C2 0.4171724
    O14: C1    0.1825742
    O14: C2    0.5217967
    O14: C1:C2 0.4738945
    
    
    $m5d
    $m5d$O1
                    Mean         SD        2.5%      97.5% tail-prob.  GR-crit
    M22      0.151123233  0.3990052  -0.6098327  0.8076460  0.6666667 1.361594
    M23     -0.004449056  0.5343658  -1.1718663  0.6622466  1.0000000 3.011741
    M24     -0.118788995  0.4719389  -0.7989810  0.6811750  0.8666667 1.734717
    O22      0.625675818  0.6907992  -0.8475776  1.5653176  0.4666667 4.342873
    O23      1.111174384  0.6287610   0.1851692  2.5078203  0.0000000 2.538146
    O24      0.242100583  0.5126576  -0.4582431  1.2366768  0.7333333 3.512051
    M22:C2  -1.070787476  1.1725865  -3.2000540  0.6599821  0.4000000 1.709792
    M23:C2  -0.305063192  1.1881077  -2.8349463  1.5271753  0.8666667 1.824563
    M24:C2   1.318800432  1.6378918  -1.7943990  4.0023851  0.3333333 2.277367
    O12: C1 -2.083258642 15.9407844 -32.5626345 23.8266089  0.9333333 1.421660
    O12: C2  0.341204644  1.1708115  -1.4009384  2.6465389  0.9333333 1.991093
    O13: C1 -0.016067540  9.9449921 -20.9325675 16.9841020  0.8000000 1.279594
    O13: C2 -0.019603538  0.7729275  -1.2541586  1.5938974  0.8666667 3.462559
    O14: C1  2.392597454 14.1312439 -22.1123288 27.6969311  0.9333333 1.626195
    O14: C2 -0.122123516  0.9696481  -2.1962339  1.2036617  0.8666667 2.149045
               MCE/SD
    M22     0.6391803
    M23     0.2425650
    M24     0.2717215
    O22     0.3994382
    O23     0.4018437
    O24     0.6589619
    M22:C2  0.2157420
    M23:C2  0.3502966
    M24:C2  0.2316799
    O12: C1 0.1825742
    O12: C2 0.2375575
    O13: C1 0.1825742
    O13: C2 0.3429650
    O14: C1 0.2140205
    O14: C2 0.3273648
    
    
    $m5e
    $m5e$O1
                      Mean         SD         2.5%       97.5% tail-prob.  GR-crit
    O12: C1     10.1527748 19.3796827 -28.06706310 43.35135463 0.46666667 3.095725
    O12: M22     1.7871893  0.4234484   1.19067760  2.64534361 0.00000000 3.458385
    O12: M23    -2.1099700  1.3662943  -3.87303258  0.54137366 0.20000000 4.383025
    O12: M24    -0.2827957  0.4168466  -1.04162946  0.51809363 0.46666667 2.319085
    O12: C2      0.1493588  1.9082842  -2.64319081  3.30374289 1.00000000 7.842261
    O12: O22     1.1203128  0.8860755  -0.06731357  2.77300928 0.06666667 5.413410
    O12: O23     3.0273352  0.5725732   2.05757115  3.97904424 0.00000000 1.284585
    O12: O24    -0.1940953  0.6361170  -1.35231031  1.06492016 0.60000000 2.458830
    O12: M22:C2  4.4526404  1.8065928   0.96978174  7.69763721 0.00000000 2.007414
    O12: M23:C2 -5.0579183  4.0880888 -12.08370093  0.34207369 0.13333333 4.120359
    O12: M24:C2 10.0221798  3.7795697   4.20774019 17.09240585 0.00000000 1.911682
    O13: C1     -9.3684742 11.4294213 -36.87588538  8.01070353 0.46666667 1.227626
    O13: M22    -0.4119291  0.5193414  -1.19348062  0.52487260 0.46666667 2.973837
    O13: M23    -0.1814866  0.5344941  -1.08119140  0.77314450 0.73333333 4.478473
    O13: M24    -0.4710581  0.4231700  -1.18611356  0.19495364 0.26666667 2.561281
    O13: C2      0.9422096  0.7410501  -0.33741779  1.82421741 0.26666667 3.373754
    O13: O22     0.4164910  0.5255638  -0.67457368  1.21963876 0.53333333 4.769125
    O13: O23     0.9120955  0.4469817   0.08659713  1.53536242 0.00000000 2.193812
    O13: O24     0.4555212  0.3943380  -0.09948201  1.24561143 0.13333333 1.955073
    O13: M22:C2 -2.3856411  1.6064482  -4.68090363  0.78365492 0.20000000 3.694498
    O13: M23:C2  0.3949875  1.0810176  -1.78055092  1.67108646 0.60000000 1.358657
    O13: M24:C2 -1.5296965  1.3749744  -3.43870263  0.91862332 0.33333333 3.810055
    O14: C1     -1.2211005 15.7120938 -28.20545142 24.50288670 1.00000000 1.091418
    O14: M22    -1.5915613  0.5890977  -2.76117001 -0.36692448 0.00000000 1.118137
    O14: M23    -1.1026853  0.6847367  -2.73692343 -0.08719270 0.06666667 1.192926
    O14: M24    -1.5137829  0.7443956  -3.46373639 -0.36414381 0.00000000 1.770881
    O14: C2      0.1915148  1.0790162  -1.70994200  1.86252312 0.86666667 5.575082
    O14: O22    -0.2105612  0.6327898  -1.35513761  1.15303564 0.73333333 2.273666
    O14: O23     0.6042891  0.4899182  -0.09588429  1.42369074 0.13333333 3.569638
    O14: O24    -1.0529611  0.7032306  -2.40904190 -0.04987549 0.06666667 1.750474
    O14: M22:C2 -3.3537242  2.6004986  -8.14200983  0.49529361 0.20000000 2.618793
    O14: M23:C2 -0.5572699  2.6499434  -6.98008725  3.71829387 1.00000000 3.302844
    O14: M24:C2  0.7409025  1.5613818  -1.28001614  4.75579373 0.60000000 3.512741
                    MCE/SD
    O12: C1     0.51851278
    O12: M22    0.58157802
    O12: M23    0.59182330
    O12: M24    0.21567434
    O12: C2     0.60018013
    O12: O22    0.55204825
    O12: O23    0.32621844
    O12: O24    0.32315379
    O12: M22:C2 0.32274268
    O12: M23:C2 0.49890596
    O12: M24:C2 0.19491146
    O13: C1     0.19430979
    O13: M22    0.50543853
    O13: M23    0.64540410
    O13: M24    0.41688284
    O13: C2     0.55651552
    O13: O22    0.37780743
    O13: O23    0.18257419
    O13: O24    0.27270850
    O13: M22:C2 0.37948144
    O13: M23:C2 0.18257419
    O13: M24:C2 0.48359801
    O14: C1     0.08585758
    O14: M22    0.29750470
    O14: M23    0.24134867
    O14: M24    0.18257419
    O14: C2     0.29689616
    O14: O22    0.23554363
    O14: O23    0.25453133
    O14: O24    0.26174841
    O14: M22:C2 0.33874142
    O14: M23:C2 0.18257419
    O14: M24:C2 0.34880557
    
    
    $m6a
    $m6a$O1
                  Mean         SD        2.5%      97.5% tail-prob.  GR-crit
    M22      0.3377949  0.6030702  -0.8741144  1.0295919 0.40000000 5.958015
    M23      0.2726240  0.6488370  -1.0263889  1.2673812 0.60000000 2.157109
    M24      0.6155196  0.6772171  -0.8312354  1.5765832 0.33333333 2.617392
    O22     -0.3993749  0.5419571  -1.2683696  0.4845602 0.53333333 3.790985
    O23     -0.9442958  0.5297420  -2.0687304 -0.2389565 0.06666667 2.369875
    O24     -0.2450897  0.4788910  -1.0425973  0.7040273 0.60000000 2.648208
    O12: C1  0.7229371 12.4870902 -27.1763897 20.5073862 0.93333333 1.155948
    O12: C2 -0.7052831  0.9549687  -2.4394803  0.8877031 0.33333333 1.810455
    O13: C1 -1.5776581 15.0711276 -23.6360721 23.5884741 1.00000000 1.197642
    O13: C2 -0.4313567  0.7007697  -1.5394453  0.7732481 0.60000000 2.037710
    O14: C1 -8.1196969 21.2954737 -54.6456692 30.3358488 0.73333333 1.223727
    O14: C2 -0.2881769  0.6871098  -1.6460524  0.8877789 0.73333333 1.373258
               MCE/SD
    M22     0.4571934
    M23     0.4048184
    M24     0.1825742
    O22     0.4134717
    O23     0.5092104
    O24     0.3283076
    O12: C1 0.2035630
    O12: C2 0.3293618
    O13: C1 0.2197793
    O13: C2 0.3252096
    O14: C1 0.2446091
    O14: C2 0.1772454
    
    
    $m6b
    $m6b$O1
                   Mean         SD         2.5%        97.5% tail-prob.  GR-crit
    M22     -0.10881100  0.6811436  -1.28283999  1.042758738 0.93333333 4.014770
    M23     -0.10926645  0.5364202  -1.15983838  0.708673652 0.80000000 2.715026
    M24      0.02061368  0.5139248  -1.02666004  0.851406834 0.80000000 2.078707
    O22     -0.09762433  0.4768571  -1.08147315  0.578812412 1.00000000 2.184570
    O23     -0.73150647  0.3902962  -1.43527161 -0.009381978 0.06666667 2.284793
    O24     -0.07349287  0.4115512  -0.78577602  0.545513967 1.00000000 1.033806
    C1:C2    0.99378487  0.7730632   0.01172845  2.336074595 0.06666667 5.608975
    O12: C1  4.77758610 12.7681566 -18.28559039 24.937134677 0.73333333 1.575079
    O12: C2 -1.83546389  1.2392084  -4.22706971 -0.033153769 0.06666667 3.862657
    O13: C1  1.08339237 11.8430267 -16.78304130 22.006253630 0.80000000 1.209088
    O13: C2 -1.53971342  1.1582460  -4.06887046 -0.106448723 0.06666667 4.532257
    O14: C1 -3.48467466 12.8784481 -23.47382244 22.748434659 0.73333333 1.174744
    O14: C2 -1.43316652  1.0134604  -3.64518786  0.130662574 0.06666667 2.530521
               MCE/SD
    M22     0.3492697
    M23     0.3148462
    M24     0.3130090
    O22     0.3017643
    O23     0.2867109
    O24     0.2026144
    C1:C2   0.4072635
    O12: C1 0.2130322
    O12: C2 0.3068812
    O13: C1 0.3327929
    O13: C2 0.3333979
    O14: C1 0.1825742
    O14: C2 0.3026570
    
    
    $m6c
    $m6c$O1
                      Mean         SD         2.5%      97.5% tail-prob.   GR-crit
    M22        -0.00519442  0.4140714  -0.68124103  0.7029645 0.86666667  3.991951
    M23         0.10130936  0.4431519  -0.55729203  0.8973943 0.93333333  1.948188
    M24         0.24825834  0.3814514  -0.43227418  0.8597950 0.46666667  1.701002
    O22        -0.37049357  0.4272538  -0.95150214  0.5887584 0.33333333  1.377399
    O23        -0.95543004  0.3993156  -1.71438167 -0.3601706 0.00000000  1.451101
    O24        -0.19073252  0.4090209  -0.79101192  0.4822315 0.66666667  1.034271
    O12: C1     8.72364405 14.1128230 -14.35857123 38.7546578 0.40000000  1.366961
    O12: C2    -0.12051911  2.0689818  -3.15151900  2.9275176 0.93333333 11.901905
    O12: C1:C2 -0.25149224  1.4437530  -3.08906975  1.6221691 0.80000000 11.785256
    O13: C1     4.66681036 12.7674682 -20.27697210 32.9017649 0.80000000  1.374370
    O13: C2    -1.85278533  2.5762320  -6.51123834  1.1475162 0.66666667 10.649351
    O13: C1:C2  1.18458023  1.5395424  -0.55244353  4.0006910 0.66666667  8.683715
    O14: C1     4.27307090 18.4479620 -31.67076706 33.6613513 0.66666667  1.008406
    O14: C2    -1.79408602  1.3094883  -4.47022800  0.0676389 0.13333333  2.443980
    O14: C1:C2  1.27481737  0.9424987  -0.05371522  3.0989501 0.06666667  2.262127
                  MCE/SD
    M22        0.4138362
    M23        0.2333155
    M24        0.1858359
    O22        0.1825742
    O23        0.1825742
    O24        0.1612402
    O12: C1    0.2256391
    O12: C2    0.6894356
    O12: C1:C2 0.5422434
    O13: C1    0.3450958
    O13: C2    0.7311088
    O13: C1:C2 0.4500594
    O14: C1    0.1825742
    O14: C2    0.5626032
    O14: C1:C2 0.4723696
    
    
    $m6d
    $m6d$O1
                   Mean         SD        2.5%       97.5% tail-prob.  GR-crit
    M22      0.26639269  0.4533003  -0.7559268  1.05222390  0.4000000 2.850175
    M23      0.07506469  0.5136378  -0.5563582  1.08648272  0.9333333 2.402059
    M24      0.37773871  0.4368019  -0.4514271  0.97652968  0.4000000 2.386034
    O22     -0.63239376  0.3747303  -1.2257996  0.09402384  0.1333333 2.472251
    O23     -1.16581142  0.4141018  -1.9150459 -0.50861107  0.0000000 1.840930
    O24     -0.46687344  0.5324632  -1.4802892  0.59275053  0.3333333 1.346678
    M22:C2   1.04113868  2.0833245  -1.6247713  5.28069443  0.8666667 2.296382
    M23:C2   0.11947407  1.6760969  -2.4149425  3.13894288  0.9333333 2.129512
    M24:C2  -0.49123268  1.9499396  -3.2991735  3.18945697  0.8666667 3.346157
    O12: C1  4.43320326 19.0487872 -27.0022730 44.20279190  0.8000000 1.309059
    O12: C2 -0.22265476  1.4773685  -3.0016031  1.18070199  0.7333333 3.554145
    O13: C1  7.60509532 17.0312494 -27.6230547 28.76058173  0.5333333 2.252876
    O13: C2 -0.11510364  1.4034986  -2.9212231  1.49182994  0.7333333 3.476185
    O14: C1  5.75481452 26.1507245 -50.4292619 40.13815254  0.6666667 3.022974
    O14: C2  0.04606375  1.3987241  -2.8455190  1.84507749  0.7333333 2.744794
               MCE/SD
    M22     0.4319321
    M23     0.1825742
    M24     0.3111637
    O22     0.2166775
    O23     0.3903180
    O24     0.0701379
    M22:C2  0.3514786
    M23:C2  0.4007805
    M24:C2  0.3759533
    O12: C1 0.2920223
    O12: C2 0.5058911
    O13: C1 0.4994995
    O13: C2 0.6207871
    O14: C1 0.4203090
    O14: C2 0.3732619
    
    
    $m6e
    $m6e$O1
                        Mean         SD        2.5%      97.5% tail-prob.   GR-crit
    O12: C1      -9.39019078 24.1287199 -41.1881023 47.3952220 0.66666667  3.467694
    O12: M22     -0.41485066  0.6995681  -1.8599025  0.4987311 0.66666667  5.428568
    O12: M23      0.60325232  0.7565192  -0.5293270  1.7220194 0.46666667  5.015825
    O12: M24      0.33995615  0.6203725  -0.8718149  1.3443876 0.53333333  2.378696
    O12: C2       0.32605673  1.1918011  -1.3107817  2.4704827 1.00000000  2.844488
    O12: O22     -1.29506331  0.9273633  -2.6145259  0.1659452 0.13333333  1.669275
    O12: O23     -1.99539480  0.6169683  -3.3969759 -1.2267851 0.00000000  1.022514
    O12: O24     -0.27084558  0.5616333  -1.4099577  0.5989032 0.73333333  1.292172
    O12: M22:C2  -1.79293535  2.1996873  -5.4122531  0.9028202 0.73333333  4.257157
    O12: M23:C2   0.12769987  1.2353979  -1.9471339  2.2098879 0.93333333  2.249354
    O12: M24:C2  -5.17868455  1.6802213  -8.6175596 -2.6240048 0.00000000  1.487533
    O13: C1      -2.42868633 16.3989636 -28.4760028 22.8891604 0.93333333  6.451553
    O13: M22      0.82802571  0.5202109  -0.2216978  1.4968763 0.13333333  2.995760
    O13: M23     -0.31065629  0.6073616  -1.4978787  0.8288718 0.46666667  3.354938
    O13: M24      0.39493587  0.5717671  -0.6129649  1.4096491 0.40000000  4.736787
    O13: C2      -0.81565035  1.8866337  -3.9125585  1.4866020 0.80000000 10.054783
    O13: O22     -0.53876127  0.7118725  -1.8136647  0.6099689 0.46666667  2.610791
    O13: O23     -0.80517704  0.3236284  -1.2732745 -0.1851559 0.00000000  1.661788
    O13: O24     -0.17880460  0.5331915  -0.9777241  0.7424685 0.80000000  2.376498
    O13: M22:C2   1.98117016  2.9943399  -1.9498782  6.7849754 0.80000000  5.957311
    O13: M23:C2  -1.58027919  1.2846894  -4.5927806  0.9167734 0.26666667  1.517857
    O13: M24:C2   0.80627611  2.1078102  -2.9083870  4.6667478 0.60000000  4.609736
    O14: C1     -23.48042453 22.3618351 -68.4460353  5.2048746 0.20000000  5.531443
    O14: M22      2.07667577  0.8103511   0.7383721  3.3018319 0.00000000  4.080700
    O14: M23      0.80541400  0.5288762  -0.0134552  1.6614225 0.13333333  3.508883
    O14: M24      1.75352620  0.8254842   0.3578133  3.0549882 0.00000000  3.664379
    O14: C2      -0.55572317  0.7368975  -1.8630890  0.5052182 0.53333333  4.574578
    O14: O22     -0.31040427  0.6953540  -1.6045778  0.9077774 0.66666667  2.263915
    O14: O23     -0.89309252  0.6844623  -1.8641236  0.4005627 0.26666667  4.644397
    O14: O24      1.17060780  0.6529543   0.1110135  2.2349500 0.06666667  1.632738
    O14: M22:C2   3.58232128  1.5421651   1.2064429  6.1908328 0.00000000  2.423500
    O14: M23:C2  -0.08683247  1.3925670  -2.2794536  2.5059842 0.93333333  1.284761
    O14: M24:C2   0.08451319  1.2379399  -1.6511611  2.3783513 0.93333333  1.260937
                   MCE/SD
    O12: C1     0.2951348
    O12: M22    0.3141620
    O12: M23    0.4386245
    O12: M24    0.2985347
    O12: C2     0.4339849
    O12: O22    0.4704447
    O12: O23    0.2419990
    O12: O24    0.1825742
    O12: M22:C2 0.4946753
    O12: M23:C2 0.2386702
    O12: M24:C2 0.3406354
    O13: C1     0.4560954
    O13: M22    0.4300909
    O13: M23    0.4437236
    O13: M24    0.5392680
    O13: C2     0.5809762
    O13: O22    0.4414442
    O13: O23    0.2668479
    O13: O24    0.2869754
    O13: M22:C2 0.5942802
    O13: M23:C2 0.2260091
    O13: M24:C2 0.2836478
    O14: C1     0.7414474
    O14: M22    0.3085575
    O14: M23    0.4790439
    O14: M24    0.4468042
    O14: C2     0.4822678
    O14: O22    0.3867907
    O14: O23    0.6075159
    O14: O24    0.3235270
    O14: M22:C2 0.2993543
    O14: M23:C2 0.1825742
    O14: M24:C2 0.4834356
    
    

