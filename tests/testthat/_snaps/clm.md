# GRcrit and MCerror give same result

    $m0a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    gamma_O1[1]       2.16       4.13
    gamma_O1[2]       1.05       1.31
    gamma_O1[3]       1.09       1.44
    
    
    $m0b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    gamma_O2[1]       1.24       1.76
    gamma_O2[2]       1.13       1.56
    gamma_O2[3]       1.10       1.43
    
    
    $m1a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    gamma_O1[1]      1.279       1.90
    gamma_O1[2]      1.054       1.34
    gamma_O1[3]      1.080       1.39
    C1               0.984       1.07
    
    
    $m1b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    gamma_O2[1]      1.494       2.33
    gamma_O2[2]      1.066       1.35
    gamma_O2[3]      1.509       2.48
    C1               0.996       1.15
    
    
    $m2a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    gamma_O1[1]      1.076       1.38
    gamma_O1[2]      1.049       1.29
    gamma_O1[3]      1.039       1.28
    C2               0.992       1.14
    
    
    $m2b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    gamma_O2[1]       1.62       2.76
    gamma_O2[2]       1.27       1.85
    gamma_O2[3]       1.13       1.53
    C2                1.13       1.58
    
    
    $m3a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    (Intercept)      1.171       1.64
    O1.L             1.058       1.13
    O1.Q             1.009       1.25
    O1.C             1.026       1.30
    sigma_C1         0.996       1.20
    
    
    $m3b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    (Intercept)       1.19       1.64
    O22               1.42       2.27
    O23               1.13       1.50
    O24               1.04       1.25
    sigma_C1          1.00       1.16
    
    
    $m4a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M22                   1.401       2.25
    M23                   1.414       2.92
    M24                   1.601       2.63
    O22                   3.362       6.78
    O23                   2.815       8.66
    O24                   2.608       6.95
    abs(C1 - C2)          2.151       4.27
    log(C1)               0.993       1.07
    O22:abs(C1 - C2)      2.351       5.72
    O23:abs(C1 - C2)      2.080       4.38
    O24:abs(C1 - C2)      3.364       7.52
    gamma_O1[1]           3.262       6.97
    gamma_O1[2]           2.172       4.07
    gamma_O1[3]           2.840       5.51
    
    
    $m4b
    Potential scale reduction factors:
    
                                                               Point est.
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)                    2.34
    abs(C1 - C2)                                                     1.28
    log(C1)                                                          1.28
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)       3.01
    gamma_O1[1]                                                      1.06
    gamma_O1[2]                                                      1.25
    gamma_O1[3]                                                      1.01
                                                               Upper C.I.
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)                    4.73
    abs(C1 - C2)                                                     1.89
    log(C1)                                                          2.47
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)       6.85
    gamma_O1[1]                                                      1.33
    gamma_O1[2]                                                      1.81
    gamma_O1[3]                                                      1.17
    
    
    $m5a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22               1.43       2.22
    M23               1.15       1.68
    M24               1.06       1.33
    O22               3.26       6.66
    O23               2.56       7.39
    O24               3.05       6.73
    O12: C1           1.29       2.66
    O12: C2           1.77       3.30
    O13: C1           1.31       3.01
    O13: C2           2.92       6.53
    O14: C1           1.20       1.85
    O14: C2           2.34       6.71
    gamma_O1[1]       3.36       7.17
    gamma_O1[2]       2.46       4.63
    gamma_O1[3]       1.71       2.87
    
    
    $m5b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22               2.42       4.76
    M23               1.81       3.01
    M24               1.70       3.17
    O22               1.27       2.13
    O23               1.14       1.70
    O24               2.04       4.25
    C1:C2             2.14       3.93
    O12: C1           1.44       2.38
    O12: C2           1.88       3.72
    O13: C1           4.13       8.78
    O13: C2           2.95       6.08
    O14: C1           2.89       5.31
    O14: C2           3.12       6.47
    gamma_O1[1]       2.78       6.67
    gamma_O1[2]       2.75       6.84
    gamma_O1[3]       3.34       6.43
    
    
    $m5c
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22               2.98      6.025
    M23               2.90      5.554
    M24               4.07      8.121
    O22               1.13      1.581
    O23               1.47      2.339
    O24               1.38      2.386
    O12: C1           1.02      1.138
    O12: C2           3.59      7.394
    O12: C1:C2        2.05      4.655
    O13: C1           1.02      1.201
    O13: C2           3.18      8.407
    O13: C1:C2        2.69      5.462
    O14: C1           0.97      0.986
    O14: C2           1.94      4.037
    O14: C1:C2        1.67      3.215
    gamma_O1[1]       6.94     15.695
    gamma_O1[2]       6.32     12.480
    gamma_O1[3]       3.04      5.550
    
    
    $m5d
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22               2.62       4.84
    M23               2.72       5.05
    M24               1.77       3.68
    O22               1.23       2.48
    O23               1.69       3.03
    O24               1.31       1.93
    M22:C2            1.29       2.09
    M23:C2            1.20       1.89
    M24:C2            1.94       3.55
    O12: C1           1.24       1.89
    O12: C2           2.33       4.24
    O13: C1           1.97       4.98
    O13: C2           1.57       2.77
    O14: C1           2.08       4.20
    O14: C2           1.93       3.65
    gamma_O1[1]       1.62       3.19
    gamma_O1[2]       2.66       5.28
    gamma_O1[3]       1.90       3.84
    
    
    $m5e
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    O12: C1          0.967      1.057
    O12: M22         4.210      8.719
    O12: M23         1.619      3.422
    O12: M24         2.698      5.241
    O12: C2          1.709      3.059
    O12: O22         1.543      3.077
    O12: O23         1.349      2.941
    O12: O24         1.236      1.997
    O12: M22:C2      1.275      2.580
    O12: M23:C2      1.705      2.871
    O12: M24:C2      3.046      7.014
    O13: C1          1.389      2.226
    O13: M22         2.351      4.598
    O13: M23         3.357      9.154
    O13: M24         2.893      5.380
    O13: C2          1.382      2.688
    O13: O22         1.484      2.398
    O13: O23         1.411      2.252
    O13: O24         1.820      3.250
    O13: M22:C2      1.366      2.150
    O13: M23:C2      1.663      2.901
    O13: M24:C2      2.703      5.884
    O14: C1          1.365      2.095
    O14: M22         2.863      5.663
    O14: M23         2.521      5.386
    O14: M24         2.460      4.519
    O14: C2          2.319      4.159
    O14: O22         2.307      4.395
    O14: O23         3.382      6.372
    O14: O24         2.756      5.521
    O14: M22:C2      0.965      0.991
    O14: M23:C2      1.633      2.999
    O14: M24:C2      2.398      4.241
    gamma_O1[1]      2.884      5.450
    gamma_O1[2]      4.568      9.064
    gamma_O1[3]      8.674     16.791
    
    
    $m6a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22              1.852       3.10
    M23              2.234       4.09
    M24              2.203       4.19
    O22              1.108       1.56
    O23              0.987       1.12
    O24              1.321       2.07
    O12: C1          1.824       3.65
    O12: C2          2.788       5.84
    O13: C1          1.263       2.04
    O13: C2          2.161       4.93
    O14: C1          0.979       1.07
    O14: C2          1.283       2.66
    gamma_O1[1]      2.494       4.82
    gamma_O1[2]      2.253       3.93
    gamma_O1[3]      1.526       2.50
    
    
    $m6b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22              1.257       1.85
    M23              2.224       4.14
    M24              1.584       2.79
    O22              1.015       1.13
    O23              1.304       2.04
    O24              1.060       1.32
    C1:C2            3.150       7.91
    O12: C1          1.034       1.17
    O12: C2          2.108       5.21
    O13: C1          1.391       2.39
    O13: C2          3.351       9.11
    O14: C1          0.986       1.02
    O14: C2          3.318       6.50
    gamma_O1[1]      1.756       3.20
    gamma_O1[2]      1.584       2.70
    gamma_O1[3]      1.652       3.33
    
    
    $m6c
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22              2.860       5.47
    M23              2.740       5.21
    M24              2.507       4.70
    O22              2.071       3.59
    O23              2.309       5.75
    O24              3.337       6.57
    O12: C1          1.284       2.13
    O12: C2          5.606      13.04
    O12: C1:C2       3.277       6.51
    O13: C1          1.915       3.55
    O13: C2          9.614      24.48
    O13: C1:C2       6.277      14.77
    O14: C1          1.436       2.25
    O14: C2          3.314       7.90
    O14: C1:C2       2.101       4.70
    gamma_O1[1]      0.965       1.05
    gamma_O1[2]      0.965       1.03
    gamma_O1[3]      1.062       1.35
    
    
    $m6d
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    M22              1.182      1.896
    M23              1.244      2.229
    M24              1.526      2.854
    O22              1.928      3.607
    O23              4.524      8.767
    O24              2.474      5.581
    M22:C2           1.330      2.112
    M23:C2           1.067      1.335
    M24:C2           0.951      0.988
    O12: C1          2.101      3.884
    O12: C2          1.600      2.850
    O13: C1          1.744      3.478
    O13: C2          1.261      1.809
    O14: C1          1.488      2.837
    O14: C2          1.357      2.126
    gamma_O1[1]      5.304     10.093
    gamma_O1[2]      6.237     12.628
    gamma_O1[3]      4.572      9.110
    
    
    $m6e
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    O12: C1           1.18       1.68
    O12: M22          1.80       3.09
    O12: M23          1.16       1.64
    O12: M24          1.41       2.30
    O12: C2           2.17       4.36
    O12: O22          1.78       4.74
    O12: O23          2.29       6.43
    O12: O24          1.78       3.95
    O12: M22:C2       1.05       1.31
    O12: M23:C2       1.08       1.43
    O12: M24:C2       2.64       5.35
    O13: C1           1.28       1.98
    O13: M22          2.34       5.23
    O13: M23          2.54       4.75
    O13: M24          4.23       8.98
    O13: C2           8.35      26.31
    O13: O22          1.92       5.59
    O13: O23          3.52      14.35
    O13: O24          4.25       8.97
    O13: M22:C2       3.55       7.75
    O13: M23:C2       4.38       9.73
    O13: M24:C2       3.95       9.73
    O14: C1           1.10       1.26
    O14: M22          3.17       6.44
    O14: M23          1.98       4.43
    O14: M24          3.61       8.85
    O14: C2           7.37      16.89
    O14: O22          2.27       4.41
    O14: O23          3.04       7.88
    O14: O24          1.52       2.85
    O14: M22:C2       4.12      11.59
    O14: M23:C2       3.35       6.46
    O14: M24:C2       2.38       7.00
    gamma_O1[1]       3.66       6.88
    gamma_O1[2]       1.97       3.37
    gamma_O1[3]       3.60       7.53
    
    

---

    $m0a
                   est  MCSE   SD MCSE/SD
    gamma_O1[1]  0.992 0.100 0.26   0.392
    gamma_O1[2] -0.037 0.011 0.19   0.061
    gamma_O1[3] -1.249 0.054 0.29   0.188
    
    $m0b
                  est  MCSE   SD MCSE/SD
    gamma_O2[1]  1.21 0.103 0.26    0.40
    gamma_O2[2]  0.19 0.021 0.20    0.11
    gamma_O2[3] -1.00 0.048 0.26    0.18
    
    $m1a
                   est  MCSE    SD MCSE/SD
    gamma_O1[1]  0.981 0.058  0.19    0.31
    gamma_O1[2] -0.027 0.033  0.18    0.18
    gamma_O1[3] -1.349 0.045  0.25    0.18
    C1          -0.871 2.736 14.98    0.18
    
    $m1b
                  est  MCSE    SD MCSE/SD
    gamma_O2[1]  1.27 0.109  0.29    0.37
    gamma_O2[2]  0.23 0.035  0.19    0.18
    gamma_O2[3] -1.00 0.052  0.29    0.18
    C1           4.69 2.146 11.12    0.19
    
    $m2a
                   est  MCSE   SD MCSE/SD
    gamma_O1[1]  0.943 0.036 0.20    0.18
    gamma_O1[2] -0.035 0.034 0.19    0.18
    gamma_O1[3] -1.295 0.028 0.24    0.12
    C2          -0.077 0.110 0.60    0.18
    
    $m2b
                  est  MCSE   SD MCSE/SD
    gamma_O2[1]  1.16 0.068 0.28    0.24
    gamma_O2[2]  0.11 0.045 0.25    0.18
    gamma_O2[3] -1.10 0.056 0.31    0.18
    C2          -0.89 0.112 0.61    0.18
    
    $m3a
                   est   MCSE    SD MCSE/SD
    (Intercept)  1.434 0.0042 0.023    0.18
    O1.L         0.024 0.0166 0.091    0.18
    O1.Q        -0.004 0.0200 0.109    0.18
    O1.C         0.022 0.0120 0.066    0.18
    sigma_C1     0.044 0.0125 0.068    0.18
    
    $m3b
                   est    MCSE     SD MCSE/SD
    (Intercept) 1.4324 0.00073 0.0040    0.18
    O22         0.0030 0.00094 0.0051    0.18
    O23         0.0031 0.00115 0.0063    0.18
    O24         0.0004 0.00107 0.0058    0.18
    sigma_C1    0.0197 0.00025 0.0013    0.18
    
    $m4a
                         est MCSE    SD MCSE/SD
    M22              -0.0462 0.14  0.50   0.277
    M23              -0.0098 0.11  0.55   0.206
    M24              -0.1510 0.11  0.53   0.215
    O22               1.1299 0.74  1.08   0.688
    O23               0.3863 0.38  0.66   0.571
    O24              -0.5836 0.52  1.20   0.430
    abs(C1 - C2)      0.0427 0.16  0.74   0.216
    log(C1)          -5.4574 0.39 20.41   0.019
    O22:abs(C1 - C2) -0.5306 0.34  0.75   0.454
    O23:abs(C1 - C2)  0.3527 0.19  0.47   0.411
    O24:abs(C1 - C2)  0.4410 0.41  0.75   0.547
    gamma_O1[1]       0.9108 0.27  0.59   0.457
    gamma_O1[2]      -0.1125 0.30  0.59   0.507
    gamma_O1[3]      -1.3713 0.30  0.58   0.521
    
    $m4b
                                                                  est  MCSE    SD
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)              -0.217 0.561  0.91
    abs(C1 - C2)                                               -0.363 0.153  0.67
    log(C1)                                                    -3.213 3.006 16.46
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.710 0.481  0.63
    gamma_O1[1]                                                 1.166 0.045  0.25
    gamma_O1[2]                                                 0.015 0.036  0.20
    gamma_O1[3]                                                -1.243 0.037  0.21
                                                               MCSE/SD
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)                 0.62
    abs(C1 - C2)                                                  0.23
    log(C1)                                                       0.18
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)    0.76
    gamma_O1[1]                                                   0.18
    gamma_O1[2]                                                   0.18
    gamma_O1[3]                                                   0.17
    
    $m5a
                    est  MCSE    SD MCSE/SD
    M22           0.089 0.077  0.42    0.18
    M23           0.206 0.066  0.36    0.18
    M24          -0.054 0.142  0.44    0.32
    O22           0.451 0.286  0.68    0.42
    O23           1.010 0.394  0.55    0.72
    O24           0.239 0.297  0.57    0.52
    O12: C1     -10.786 3.292 17.86    0.18
    O12: C2       0.443 0.157  0.86    0.18
    O13: C1      -6.895 3.549 11.03    0.32
    O13: C2       0.221 0.224  0.67    0.33
    O14: C1      -1.024 2.962 16.22    0.18
    O14: C2       0.226 0.288  0.81    0.35
    gamma_O1[1]   0.542 0.215  0.47    0.45
    gamma_O1[2]  -0.544 0.212  0.47    0.45
    gamma_O1[3]  -1.856 0.154  0.45    0.34
    
    $m5b
                   est MCSE    SD MCSE/SD
    M22          0.200 0.16  0.52    0.31
    M23          0.208 0.29  0.61    0.48
    M24         -0.015 0.18  0.53    0.34
    O22          0.499 0.09  0.38    0.23
    O23          1.055 0.34  0.53    0.64
    O24          0.276 0.24  0.50    0.47
    C1:C2        0.179 0.17  0.56    0.30
    O12: C1     -9.376 4.06 18.23    0.22
    O12: C2      0.172 0.36  0.88    0.41
    O13: C1     -6.059 5.10 13.08    0.39
    O13: C2     -0.043 0.45  0.83    0.54
    O14: C1     -2.372 6.67 13.19    0.51
    O14: C2     -0.322 0.16  0.88    0.18
    gamma_O1[1]  0.559 0.41  0.52    0.79
    gamma_O1[2] -0.609 0.09  0.49    0.18
    gamma_O1[3] -1.972 0.22  0.48    0.46
    
    $m5c
                   est  MCSE    SD MCSE/SD
    M22          0.054 0.235  0.56    0.42
    M23          0.070 0.434  0.63    0.69
    M24         -0.195 0.235  0.48    0.49
    O22          0.622 0.121  0.53    0.23
    O23          1.153 0.225  0.52    0.43
    O24          0.348 0.081  0.44    0.18
    O12: C1     -6.544 3.730 20.43    0.18
    O12: C2      2.528 0.790  1.83    0.43
    O12: C1:C2  -1.413 0.284  1.08    0.26
    O13: C1     -8.526 3.307 15.01    0.22
    O13: C2     -1.650 0.663  1.89    0.35
    O13: C1:C2   1.263 0.390  1.05    0.37
    O14: C1     -3.141 2.223 12.18    0.18
    O14: C2      1.731 0.833  1.61    0.52
    O14: C1:C2  -0.993 0.644  1.19    0.54
    gamma_O1[1]  0.636 0.444  0.58    0.77
    gamma_O1[2] -0.545 0.310  0.59    0.53
    gamma_O1[3] -1.926 0.275  0.59    0.46
    
    $m5d
                  est  MCSE    SD MCSE/SD
    M22         -0.22 0.264  0.62    0.43
    M23         -0.20 0.276  0.53    0.52
    M24         -0.25 0.246  0.61    0.40
    O22          0.35 0.108  0.59    0.18
    O23          0.99 0.185  0.50    0.37
    O24          0.11 0.107  0.53    0.20
    M22:C2      -0.68 0.378  1.55    0.24
    M23:C2       0.70 0.252  1.28    0.20
    M24:C2       2.46 0.189  1.04    0.18
    O12: C1      4.36 2.784 15.25    0.18
    O12: C2     -0.38 0.254  0.81    0.32
    O13: C1      6.62 4.237 12.64    0.34
    O13: C2     -0.91 0.231  0.73    0.31
    O14: C1      6.47 6.354 16.41    0.39
    O14: C2     -0.90 0.232  0.79    0.29
    gamma_O1[1]  0.90 0.067  0.30    0.23
    gamma_O1[2] -0.20 0.070  0.29    0.24
    gamma_O1[3] -1.60 0.091  0.31    0.29
    
    $m5e
                   est  MCSE    SD MCSE/SD
    O12: C1     -0.891 10.99 27.40    0.40
    O12: M22     0.935  0.43  0.83    0.52
    O12: M23    -0.389  0.46  0.93    0.50
    O12: M24    -0.087  0.34  0.75    0.46
    O12: C2     -1.888  0.68  1.67    0.41
    O12: O22        NA    NA  0.57      NA
    O12: O23     2.288  0.19  0.73    0.26
    O12: O24    -0.434  0.20  0.61    0.33
    O12: M22:C2  4.684  0.84  2.87    0.29
    O12: M23:C2 -0.075  0.78  1.55    0.51
    O12: M24:C2  9.681  1.59  3.54    0.45
    O13: C1     -7.076  6.42 18.32    0.35
    O13: M22    -0.572  0.37  0.75    0.49
    O13: M23     0.185  0.26  0.52    0.49
    O13: M24     0.180  0.35  0.64    0.54
    O13: C2     -0.023  0.53  1.06    0.50
    O13: O22    -0.043  0.14  0.44    0.31
    O13: O23     0.472  0.11  0.40    0.27
    O13: O24     0.164  0.14  0.43    0.32
    O13: M22:C2 -1.203  0.41  1.46    0.28
    O13: M23:C2  0.656  0.38  1.22    0.31
    O13: M24:C2 -0.236  0.62  1.84    0.34
    O14: C1      0.417  3.63 17.12    0.21
    O14: M22    -1.098  0.71  0.78    0.91
    O14: M23    -0.504  0.24  0.63    0.39
    O14: M24    -0.516  0.38  0.82    0.47
    O14: C2     -0.931  0.16  0.71    0.23
    O14: O22    -0.077  0.27  0.57    0.48
    O14: O23     0.787  0.49  0.65    0.75
    O14: O24    -0.400  0.23  0.66    0.36
    O14: M22:C2 -1.102  0.22  1.23    0.18
    O14: M23:C2  0.697  0.47  1.55    0.30
    O14: M24:C2  1.211  0.85  1.92    0.44
    gamma_O1[1]  0.650  0.29  0.61    0.47
    gamma_O1[2] -0.031  0.25  0.55    0.45
    gamma_O1[3] -1.192  0.76  0.94    0.81
    
    $m6a
                   est  MCSE    SD MCSE/SD
    M22         -0.213 0.269  0.53    0.51
    M23         -0.269 0.199  0.44    0.45
    M24          0.066 0.121  0.66    0.18
    O22         -0.492 0.081  0.44    0.18
    O23         -1.241 0.067  0.37    0.18
    O24         -0.359 0.137  0.41    0.34
    O12: C1      4.717 4.923 22.72    0.22
    O12: C2     -0.560 0.281  0.82    0.34
    O13: C1     -1.512 9.195 19.59    0.47
    O13: C2     -0.503 0.253  0.76    0.33
    O14: C1     -1.810 5.532 19.10    0.29
    O14: C2     -0.142 0.174  0.96    0.18
    gamma_O1[1] -0.397 0.232  0.40    0.59
    gamma_O1[2]  0.673 0.212  0.43    0.49
    gamma_O1[3]  2.066 0.101  0.36    0.28
    
    $m6b
                   est  MCSE    SD MCSE/SD
    M22          0.010 0.157  0.54    0.29
    M23         -0.117 0.166  0.51    0.32
    M24          0.198 0.170  0.53    0.32
    O22         -0.500 0.081  0.39    0.21
    O23         -0.998 0.079  0.37    0.21
    O24         -0.349 0.134  0.37    0.36
    C1:C2        0.042 0.380  0.87    0.44
    O12: C1     12.813 3.776 15.77    0.24
    O12: C2     -0.530 0.646  0.98    0.66
    O13: C1      8.807 4.159 11.48    0.36
    O13: C2     -0.135 0.390  1.06    0.37
    O14: C1      1.033 4.187 18.02    0.23
    O14: C2     -0.127 0.595  1.18    0.50
    gamma_O1[1] -0.594 0.189  0.51    0.37
    gamma_O1[2]  0.396 0.094  0.51    0.18
    gamma_O1[3]  1.803 0.261  0.58    0.45
    
    $m6c
                   est  MCSE    SD MCSE/SD
    M22          0.178 0.548  0.85    0.65
    M23          0.141 0.348  0.76    0.46
    M24          0.520 0.359  0.78    0.46
    O22         -0.403 0.203  0.63    0.32
    O23         -0.957 0.348  0.63    0.55
    O24         -0.152 0.319  0.61    0.52
    O12: C1      3.487 2.881 15.78    0.18
    O12: C2     -0.578 1.144  2.62    0.44
    O12: C1:C2  -0.039 0.683  1.48    0.46
    O13: C1      0.383 4.376 12.40    0.35
    O13: C2      0.835 1.398  2.08    0.67
    O13: C1:C2  -0.855 0.555  1.23    0.45
    O14: C1     -1.646 2.982 16.34    0.18
    O14: C2      0.106 1.018  1.92    0.53
    O14: C1:C2  -0.229 0.195  1.15    0.17
    gamma_O1[1]     NA    NA  0.53      NA
    gamma_O1[2]  0.201 0.138  0.55    0.25
    gamma_O1[3]  1.545 0.098  0.54    0.18
    
    $m6d
                  est MCSE    SD MCSE/SD
    M22          0.81 0.19  0.53    0.36
    M23          0.65 0.10  0.43    0.23
    M24          0.72 0.17  0.55    0.31
    O22         -0.88 0.22  0.68    0.32
    O23         -1.11 0.58  0.75    0.77
    O24         -0.49 0.33  0.71    0.46
    M22:C2       3.26 0.40  1.23    0.33
    M23:C2       1.83 0.20  1.07    0.18
    M24:C2       0.47 0.24  1.33    0.18
    O12: C1     -2.64 7.30 17.21    0.42
    O12: C2     -1.97 0.26  0.76    0.34
    O13: C1     -3.76 9.38 19.48    0.48
    O13: C2     -1.36 0.31  0.76    0.40
    O14: C1     -6.22 7.29 23.13    0.32
    O14: C2     -1.34 0.29  0.86    0.33
    gamma_O1[1] -1.06 0.38  0.58    0.65
    gamma_O1[2]  0.02 0.44  0.66    0.66
    gamma_O1[3]  1.42 0.36  0.65    0.55
    
    $m6e
                    est  MCSE    SD MCSE/SD
    O12: C1       4.343 1.788  9.79    0.18
    O12: M22     -1.098 0.138  0.46    0.30
    O12: M23      0.079 0.125  0.56    0.22
    O12: M24         NA    NA  0.61      NA
    O12: C2      -0.256 0.225  0.73    0.31
    O12: O22     -1.010 0.206  0.60    0.35
    O12: O23     -2.117 0.302  0.94    0.32
    O12: O24      0.068 0.179  0.53    0.33
    O12: M22:C2      NA    NA  1.50      NA
    O12: M23:C2   1.517 0.247  1.35    0.18
    O12: M24:C2  -5.610 1.307  2.09    0.63
    O13: C1      -3.196 1.986  8.82    0.23
    O13: M22      0.110 0.187  0.58    0.32
    O13: M23     -0.908 0.403  0.79    0.51
    O13: M24      0.235 0.488  0.82    0.60
    O13: C2       0.196 1.226  1.47    0.83
    O13: O22     -0.284 0.253  0.51    0.49
    O13: O23     -0.046 0.424  0.95    0.45
    O13: O24     -0.308 0.267  0.62    0.43
    O13: M22:C2   0.440 0.941  2.01    0.47
    O13: M23:C2  -3.225 1.430  3.58    0.40
    O13: M24:C2   0.759 1.121  1.80    0.62
    O14: C1     -16.871 4.148 12.39    0.33
    O14: M22      0.723 0.439  0.85    0.52
    O14: M23      0.052 0.395  0.84    0.47
    O14: M24      0.863 0.401  0.92    0.43
    O14: C2       0.343 1.263  1.59    0.79
    O14: O22     -0.149 0.186  0.54    0.34
    O14: O23     -0.301 0.286  0.85    0.34
    O14: O24      0.533 0.258  0.69    0.38
    O14: M22:C2   1.185 1.472  2.00    0.74
    O14: M23:C2  -1.276 1.378  2.53    0.54
    O14: M24:C2   0.176 0.820  2.03    0.40
    gamma_O1[1]  -0.334 0.219  0.38    0.58
    gamma_O1[2]   0.075 0.068  0.29    0.23
    gamma_O1[3]   0.928 0.325  0.62    0.52
    

# summary output remained the same on Windows

    
    Call:
    clm_imp(formula = O1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3 
     0.99162 -0.03733 -1.24892 
    
    Call:
    clm_imp(formula = O2 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O2" 
    
    
    Coefficients:
     O2 > 1  O2 > 2  O2 > 3 
     1.2108  0.1917 -0.9975 
    
    Call:
    clm_imp(formula = O1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3       C1 
     0.98147 -0.02708 -1.34948 -0.87064 
    
    Call:
    clm_imp(formula = O2 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O2" 
    
    
    Coefficients:
     O2 > 1  O2 > 2  O2 > 3      C1 
     1.2722  0.2297 -1.0025  4.6906 
    
    Call:
    clm_imp(formula = O1 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3       C2 
     0.94267 -0.03527 -1.29489 -0.07671 
    
    Call:
    clm_imp(formula = O2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O2" 
    
    
    Coefficients:
     O2 > 1  O2 > 2  O2 > 3      C2 
     1.1641  0.1132 -1.0967 -0.8900 
    
    Call:
    lm_imp(formula = C1 ~ O1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)        O1.L        O1.Q        O1.C 
       1.433577    0.024323   -0.003962    0.021690 
    
    
    Residual standard deviation:
    sigma_C1 
     0.04416 
    
    Call:
    lm_imp(formula = C1 ~ O2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)         O22         O23         O24 
      1.4324351   0.0029889   0.0030733   0.0003982 
    
    
    Residual standard deviation:
    sigma_C1 
     0.01974 
    
    Call:
    clm_imp(formula = O1 ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF, 
        n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
              O1 > 1           O1 > 2           O1 > 3              M22 
            0.910768        -0.112482        -1.371311        -0.046235 
                 M23              M24              O22              O23 
           -0.009786        -0.150952         1.129920         0.386266 
                 O24     abs(C1 - C2)          log(C1) O22:abs(C1 - C2) 
           -0.583569         0.042722        -5.457430        -0.530626 
    O23:abs(C1 - C2) O24:abs(C1 - C2) 
            0.352698         0.441029 
    
    Call:
    clm_imp(formula = O1 ~ ifelse(as.numeric(O2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1), data = wideDF, n.adapt = 5, 
        n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
                                                        O1 > 1 
                                                        1.1659 
                                                        O1 > 2 
                                                        0.0150 
                                                        O1 > 3 
                                                       -1.2431 
                 ifelse(as.numeric(O2) > as.numeric(M1), 1, 0) 
                                                       -0.2169 
                                                  abs(C1 - C2) 
                                                       -0.3626 
                                                       log(C1) 
                                                       -3.2133 
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                        0.7097 
    
    Call:
    clm_imp(formula = O1 ~ C1 + C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
       O1 > 1    O1 > 2    O1 > 3       M22       M23       M24       O22       O23 
      0.54248  -0.54366  -1.85640   0.08947   0.20601  -0.05394   0.45142   1.00971 
          O24        C1        C2        C1        C2        C1        C2 
      0.23854 -10.78552   0.44316  -6.89492   0.22083  -1.02407   0.22619 
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3      M22      M23      M24      O22      O23 
     0.55914 -0.60931 -1.97190  0.20019  0.20792 -0.01521  0.49913  1.05525 
         O24    C1:C2       C1       C2       C1       C2       C1       C2 
     0.27608  0.17851 -9.37613  0.17237 -6.05899 -0.04312 -2.37182 -0.32204 
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 * 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3      M22      M23      M24      O22      O23 
     0.63642 -0.54480 -1.92617  0.05424  0.06956 -0.19474  0.62220  1.15295 
         O24       C1       C2    C1:C2       C1       C2    C1:C2       C1 
     0.34771 -6.54385  2.52838 -1.41309 -8.52575 -1.64956  1.26324 -3.14100 
          C2    C1:C2 
     1.73064 -0.99274 
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
     O1 > 1  O1 > 2  O1 > 3     M22     M23     M24     O22     O23     O24  M22:C2 
     0.8998 -0.2011 -1.5980 -0.2226 -0.1963 -0.2454  0.3466  0.9863  0.1057 -0.6822 
     M23:C2  M24:C2      C1      C2      C1      C2      C1      C2 
     0.6968  2.4619  4.3649 -0.3840  6.6209 -0.9093  6.4724 -0.9008 
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = ~C1 + 
            M2 * C2 + O2, seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3       C1      M22      M23      M24       C2 
     0.65001 -0.03116 -1.19193 -0.89053  0.93524 -0.38898 -0.08674 -1.88804 
         O22      O23      O24   M22:C2   M23:C2   M24:C2       C1      M22 
     0.01978  2.28837 -0.43383  4.68384 -0.07511  9.68099 -7.07625 -0.57249 
         M23      M24       C2      O22      O23      O24   M22:C2   M23:C2 
     0.18464  0.18010 -0.02278 -0.04336  0.47157  0.16423 -1.20340  0.65552 
      M24:C2       C1      M22      M23      M24       C2      O22      O23 
    -0.23599  0.41744 -1.09828 -0.50420 -0.51611 -0.93136 -0.07658  0.78719 
         O24   M22:C2   M23:C2   M24:C2 
    -0.39963 -1.10230  0.69732  1.21104 
    
    Call:
    clm_imp(formula = O1 ~ C1 + C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 = 1   O1 = 2   O1 = 3      M22      M23      M24      O22      O23 
    -0.39684  0.67271  2.06585 -0.21332 -0.26910  0.06624 -0.49150 -1.24064 
         O24       C1       C2       C1       C2       C1       C2 
    -0.35916  4.71666 -0.55992 -1.51245 -0.50279 -1.81032 -0.14219 
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 = 1   O1 = 2   O1 = 3      M22      M23      M24      O22      O23 
    -0.59391  0.39630  1.80262  0.01018 -0.11675  0.19793 -0.49956 -0.99797 
         O24    C1:C2       C1       C2       C1       C2       C1       C2 
    -0.34880  0.04206 12.81328 -0.53031  8.80710 -0.13475  1.03261 -0.12654 
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 * 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 = 1   O1 = 2   O1 = 3      M22      M23      M24      O22      O23 
    -0.85572  0.20143  1.54537  0.17778  0.14080  0.52001 -0.40339 -0.95651 
         O24       C1       C2    C1:C2       C1       C2    C1:C2       C1 
    -0.15245  3.48737 -0.57824 -0.03888  0.38311  0.83486 -0.85538 -1.64598 
          C2    C1:C2 
     0.10604 -0.22896 
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 = 1   O1 = 2   O1 = 3      M22      M23      M24      O22      O23 
    -1.06368  0.02034  1.41707  0.80604  0.65479  0.71581 -0.88454 -1.10819 
         O24   M22:C2   M23:C2   M24:C2       C1       C2       C1       C2 
    -0.49126  3.26412  1.83443  0.47274 -2.63542 -1.97207 -3.75589 -1.35924 
          C1       C2 
    -6.22222 -1.33503 
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = ~C1 + 
            M2 * C2 + O2, rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
       O1 = 1    O1 = 2    O1 = 3        C1       M22       M23       M24        C2 
     -0.33390   0.07512   0.92770   4.34292  -1.09785   0.07876   0.34765  -0.25615 
          O22       O23       O24    M22:C2    M23:C2    M24:C2        C1       M22 
     -1.00966  -2.11710   0.06781  -1.05142   1.51661  -5.60957  -3.19563   0.10954 
          M23       M24        C2       O22       O23       O24    M22:C2    M23:C2 
     -0.90818   0.23479   0.19609  -0.28384  -0.04640  -0.30826   0.43976  -3.22542 
       M24:C2        C1       M22       M23       M24        C2       O22       O23 
      0.75853 -16.87087   0.72285   0.05184   0.86320   0.34293  -0.14930  -0.30051 
          O24    M22:C2    M23:C2    M24:C2 
      0.53320   1.18504  -1.27552   0.17611 
    $m0a
    
    Call:
    clm_imp(formula = O1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3 
     0.99162 -0.03733 -1.24892 
    
    $m0b
    
    Call:
    clm_imp(formula = O2 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O2" 
    
    
    Coefficients:
     O2 > 1  O2 > 2  O2 > 3 
     1.2108  0.1917 -0.9975 
    
    $m1a
    
    Call:
    clm_imp(formula = O1 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3       C1 
     0.98147 -0.02708 -1.34948 -0.87064 
    
    $m1b
    
    Call:
    clm_imp(formula = O2 ~ C1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O2" 
    
    
    Coefficients:
     O2 > 1  O2 > 2  O2 > 3      C1 
     1.2722  0.2297 -1.0025  4.6906 
    
    $m2a
    
    Call:
    clm_imp(formula = O1 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3       C2 
     0.94267 -0.03527 -1.29489 -0.07671 
    
    $m2b
    
    Call:
    clm_imp(formula = O2 ~ C2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian cumulative logit model for "O2" 
    
    
    Coefficients:
     O2 > 1  O2 > 2  O2 > 3      C2 
     1.1641  0.1132 -1.0967 -0.8900 
    
    $m3a
    
    Call:
    lm_imp(formula = C1 ~ O1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)        O1.L        O1.Q        O1.C 
       1.433577    0.024323   -0.003962    0.021690 
    
    
    Residual standard deviation:
    sigma_C1 
     0.04416 
    
    $m3b
    
    Call:
    lm_imp(formula = C1 ~ O2, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
     Bayesian linear model for "C1" 
    
    
    Coefficients:
    (Intercept)         O22         O23         O24 
      1.4324351   0.0029889   0.0030733   0.0003982 
    
    
    Residual standard deviation:
    sigma_C1 
     0.01974 
    
    $m4a
    
    Call:
    clm_imp(formula = O1 ~ M2 + O2 * abs(C1 - C2) + log(C1), data = wideDF, 
        n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
              O1 > 1           O1 > 2           O1 > 3              M22 
            0.910768        -0.112482        -1.371311        -0.046235 
                 M23              M24              O22              O23 
           -0.009786        -0.150952         1.129920         0.386266 
                 O24     abs(C1 - C2)          log(C1) O22:abs(C1 - C2) 
           -0.583569         0.042722        -5.457430        -0.530626 
    O23:abs(C1 - C2) O24:abs(C1 - C2) 
            0.352698         0.441029 
    
    $m4b
    
    Call:
    clm_imp(formula = O1 ~ ifelse(as.numeric(O2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1), data = wideDF, n.adapt = 5, 
        n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
                                                        O1 > 1 
                                                        1.1659 
                                                        O1 > 2 
                                                        0.0150 
                                                        O1 > 3 
                                                       -1.2431 
                 ifelse(as.numeric(O2) > as.numeric(M1), 1, 0) 
                                                       -0.2169 
                                                  abs(C1 - C2) 
                                                       -0.3626 
                                                       log(C1) 
                                                       -3.2133 
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                        0.7097 
    
    $m5a
    
    Call:
    clm_imp(formula = O1 ~ C1 + C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
       O1 > 1    O1 > 2    O1 > 3       M22       M23       M24       O22       O23 
      0.54248  -0.54366  -1.85640   0.08947   0.20601  -0.05394   0.45142   1.00971 
          O24        C1        C2        C1        C2        C1        C2 
      0.23854 -10.78552   0.44316  -6.89492   0.22083  -1.02407   0.22619 
    
    $m5b
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3      M22      M23      M24      O22      O23 
     0.55914 -0.60931 -1.97190  0.20019  0.20792 -0.01521  0.49913  1.05525 
         O24    C1:C2       C1       C2       C1       C2       C1       C2 
     0.27608  0.17851 -9.37613  0.17237 -6.05899 -0.04312 -2.37182 -0.32204 
    
    $m5c
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 * 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3      M22      M23      M24      O22      O23 
     0.63642 -0.54480 -1.92617  0.05424  0.06956 -0.19474  0.62220  1.15295 
         O24       C1       C2    C1:C2       C1       C2    C1:C2       C1 
     0.34771 -6.54385  2.52838 -1.41309 -8.52575 -1.64956  1.26324 -3.14100 
          C2    C1:C2 
     1.73064 -0.99274 
    
    $m5d
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
     O1 > 1  O1 > 2  O1 > 3     M22     M23     M24     O22     O23     O24  M22:C2 
     0.8998 -0.2011 -1.5980 -0.2226 -0.1963 -0.2454  0.3466  0.9863  0.1057 -0.6822 
     M23:C2  M24:C2      C1      C2      C1      C2      C1      C2 
     0.6968  2.4619  4.3649 -0.3840  6.6209 -0.9093  6.4724 -0.9008 
    
    $m5e
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = ~C1 + 
            M2 * C2 + O2, seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 > 1   O1 > 2   O1 > 3       C1      M22      M23      M24       C2 
     0.65001 -0.03116 -1.19193 -0.89053  0.93524 -0.38898 -0.08674 -1.88804 
         O22      O23      O24   M22:C2   M23:C2   M24:C2       C1      M22 
     0.01978  2.28837 -0.43383  4.68384 -0.07511  9.68099 -7.07625 -0.57249 
         M23      M24       C2      O22      O23      O24   M22:C2   M23:C2 
     0.18464  0.18010 -0.02278 -0.04336  0.47157  0.16423 -1.20340  0.65552 
      M24:C2       C1      M22      M23      M24       C2      O22      O23 
    -0.23599  0.41744 -1.09828 -0.50420 -0.51611 -0.93136 -0.07658  0.78719 
         O24   M22:C2   M23:C2   M24:C2 
    -0.39963 -1.10230  0.69732  1.21104 
    
    $m6a
    
    Call:
    clm_imp(formula = O1 ~ C1 + C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 = 1   O1 = 2   O1 = 3      M22      M23      M24      O22      O23 
    -0.39684  0.67271  2.06585 -0.21332 -0.26910  0.06624 -0.49150 -1.24064 
         O24       C1       C2       C1       C2       C1       C2 
    -0.35916  4.71666 -0.55992 -1.51245 -0.50279 -1.81032 -0.14219 
    
    $m6b
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 = 1   O1 = 2   O1 = 3      M22      M23      M24      O22      O23 
    -0.59391  0.39630  1.80262  0.01018 -0.11675  0.19793 -0.49956 -0.99797 
         O24    C1:C2       C1       C2       C1       C2       C1       C2 
    -0.34880  0.04206 12.81328 -0.53031  8.80710 -0.13475  1.03261 -0.12654 
    
    $m6c
    
    Call:
    clm_imp(formula = O1 ~ C1 * C2 + M2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 * 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 = 1   O1 = 2   O1 = 3      M22      M23      M24      O22      O23 
    -0.85572  0.20143  1.54537  0.17778  0.14080  0.52001 -0.40339 -0.95651 
         O24       C1       C2    C1:C2       C1       C2    C1:C2       C1 
    -0.15245  3.48737 -0.57824 -0.03888  0.38311  0.83486 -0.85538 -1.64598 
          C2    C1:C2 
     0.10604 -0.22896 
    
    $m6d
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = list(O1 = ~C1 + 
            C2), rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
      O1 = 1   O1 = 2   O1 = 3      M22      M23      M24      O22      O23 
    -1.06368  0.02034  1.41707  0.80604  0.65479  0.71581 -0.88454 -1.10819 
         O24   M22:C2   M23:C2   M24:C2       C1       C2       C1       C2 
    -0.49126  3.26412  1.83443  0.47274 -2.63542 -1.97207 -3.75589 -1.35924 
          C1       C2 
    -6.22222 -1.33503 
    
    $m6e
    
    Call:
    clm_imp(formula = O1 ~ C1 + M2 * C2 + O2, data = wideDF, n.adapt = 5, 
        n.iter = 10, monitor_params = list(other = "p_O1"), nonprop = ~C1 + 
            M2 * C2 + O2, rev = "O1", seed = 2020)
    
     Bayesian cumulative logit model for "O1" 
    
    
    Coefficients:
       O1 = 1    O1 = 2    O1 = 3        C1       M22       M23       M24        C2 
     -0.33390   0.07512   0.92770   4.34292  -1.09785   0.07876   0.34765  -0.25615 
          O22       O23       O24    M22:C2    M23:C2    M24:C2        C1       M22 
     -1.00966  -2.11710   0.06781  -1.05142   1.51661  -5.60957  -3.19563   0.10954 
          M23       M24        C2       O22       O23       O24    M22:C2    M23:C2 
     -0.90818   0.23479   0.19609  -0.28384  -0.04640  -0.30826   0.43976  -3.22542 
       M24:C2        C1       M22       M23       M24        C2       O22       O23 
      0.75853 -16.87087   0.72285   0.05184   0.86320   0.34293  -0.14930  -0.30051 
          O24    M22:C2    M23:C2    M24:C2 
      0.53320   1.18504  -1.27552   0.17611 
    

---

    $m0a
    $m0a$O1
         O1 > 1      O1 > 2      O1 > 3 
     0.99162064 -0.03732636 -1.24891969 
    
    
    $m0b
    $m0b$O2
        O2 > 1     O2 > 2     O2 > 3 
     1.2108473  0.1916950 -0.9974987 
    
    
    $m1a
    $m1a$O1
         O1 > 1      O1 > 2      O1 > 3          C1 
     0.98147361 -0.02707697 -1.34947855 -0.87064208 
    
    
    $m1b
    $m1b$O2
       O2 > 1    O2 > 2    O2 > 3        C1 
     1.272224  0.229729 -1.002503  4.690647 
    
    
    $m2a
    $m2a$O1
         O1 > 1      O1 > 2      O1 > 3          C2 
     0.94267286 -0.03526781 -1.29489432 -0.07671119 
    
    
    $m2b
    $m2b$O2
        O2 > 1     O2 > 2     O2 > 3         C2 
     1.1641030  0.1132149 -1.0966892 -0.8900381 
    
    
    $m3a
    $m3a$C1
     (Intercept)         O1.L         O1.Q         O1.C 
     1.433576985  0.024323200 -0.003961707  0.021689650 
    
    
    $m3b
    $m3b$C1
     (Intercept)          O22          O23          O24 
    1.4324351139 0.0029888620 0.0030733364 0.0003981795 
    
    
    $m4a
    $m4a$O1
              O1 > 1           O1 > 2           O1 > 3              M22 
         0.910768274     -0.112481886     -1.371311038     -0.046235419 
                 M23              M24              O22              O23 
        -0.009786385     -0.150951646      1.129919626      0.386265507 
                 O24     abs(C1 - C2)          log(C1) O22:abs(C1 - C2) 
        -0.583569497      0.042722066     -5.457429666     -0.530625641 
    O23:abs(C1 - C2) O24:abs(C1 - C2) 
         0.352697648      0.441028934 
    
    
    $m4b
    $m4b$O1
                                                        O1 > 1 
                                                    1.16591583 
                                                        O1 > 2 
                                                    0.01499861 
                                                        O1 > 3 
                                                   -1.24308326 
                 ifelse(as.numeric(O2) > as.numeric(M1), 1, 0) 
                                                   -0.21690083 
                                                  abs(C1 - C2) 
                                                   -0.36262963 
                                                       log(C1) 
                                                   -3.21326151 
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                    0.70973274 
    
    
    $m5a
    $m5a$O1
          O1 > 1       O1 > 2       O1 > 3          M22          M23          M24 
      0.54248250  -0.54365577  -1.85639973   0.08946898   0.20600658  -0.05393605 
             O22          O23          O24           C1           C2           C1 
      0.45141931   1.00971448   0.23854173 -10.78551700   0.44316235  -6.89491843 
              C2           C1           C2 
      0.22082776  -1.02407402   0.22619102 
    
    
    $m5b
    $m5b$O1
         O1 > 1      O1 > 2      O1 > 3         M22         M23         M24 
     0.55913826 -0.60931434 -1.97190434  0.20019094  0.20792029 -0.01520864 
            O22         O23         O24       C1:C2          C1          C2 
     0.49913019  1.05525082  0.27608091  0.17850997 -9.37612789  0.17237327 
             C1          C2          C1          C2 
    -6.05899268 -0.04311630 -2.37182145 -0.32203777 
    
    
    $m5c
    $m5c$O1
         O1 > 1      O1 > 2      O1 > 3         M22         M23         M24 
     0.63642147 -0.54479963 -1.92617249  0.05424051  0.06955619 -0.19473664 
            O22         O23         O24          C1          C2       C1:C2 
     0.62219882  1.15294872  0.34770773 -6.54385482  2.52837598 -1.41308578 
             C1          C2       C1:C2          C1          C2       C1:C2 
    -8.52574926 -1.64956479  1.26324381 -3.14100271  1.73064240 -0.99273749 
    
    
    $m5d
    $m5d$O1
        O1 > 1     O1 > 2     O1 > 3        M22        M23        M24        O22 
     0.8998323 -0.2011214 -1.5979641 -0.2225589 -0.1962664 -0.2453886  0.3466122 
           O23        O24     M22:C2     M23:C2     M24:C2         C1         C2 
     0.9863396  0.1057105 -0.6822322  0.6968064  2.4618644  4.3648912 -0.3839739 
            C1         C2         C1         C2 
     6.6209051 -0.9093091  6.4724487 -0.9008271 
    
    
    $m5e
    $m5e$O1
         O1 > 1      O1 > 2      O1 > 3          C1         M22         M23 
     0.65001089 -0.03116167 -1.19192521 -0.89053282  0.93524327 -0.38897701 
            M24          C2         O22         O23         O24      M22:C2 
    -0.08673669 -1.88803987  0.01978310  2.28837372 -0.43383269  4.68383782 
         M23:C2      M24:C2          C1         M22         M23         M24 
    -0.07511061  9.68099500 -7.07625022 -0.57248526  0.18463641  0.18009524 
             C2         O22         O23         O24      M22:C2      M23:C2 
    -0.02278091 -0.04336298  0.47157080  0.16422589 -1.20339780  0.65551900 
         M24:C2          C1         M22         M23         M24          C2 
    -0.23599461  0.41744304 -1.09827949 -0.50420139 -0.51610807 -0.93135563 
            O22         O23         O24      M22:C2      M23:C2      M24:C2 
    -0.07657773  0.78719049 -0.39963035 -1.10229779  0.69731779  1.21104356 
    
    
    $m6a
    $m6a$O1
         O1 = 1      O1 = 2      O1 = 3         M22         M23         M24 
    -0.39684022  0.67270768  2.06585424 -0.21331741 -0.26909883  0.06624172 
            O22         O23         O24          C1          C2          C1 
    -0.49150180 -1.24064009 -0.35915977  4.71665972 -0.55992279 -1.51244529 
             C2          C1          C2 
    -0.50279370 -1.81031992 -0.14219155 
    
    
    $m6b
    $m6b$O1
         O1 = 1      O1 = 2      O1 = 3         M22         M23         M24 
    -0.59390607  0.39630394  1.80261982  0.01018292 -0.11675017  0.19792773 
            O22         O23         O24       C1:C2          C1          C2 
    -0.49955970 -0.99797093 -0.34879687  0.04206054 12.81328454 -0.53031040 
             C1          C2          C1          C2 
     8.80710418 -0.13475382  1.03261482 -0.12653918 
    
    
    $m6c
    $m6c$O1
        O1 = 1     O1 = 2     O1 = 3        M22        M23        M24        O22 
    -0.8557166  0.2014260  1.5453685  0.1777782  0.1407952  0.5200074 -0.4033920 
           O23        O24         C1         C2      C1:C2         C1         C2 
    -0.9565074 -0.1524471  3.4873722 -0.5782418 -0.0388832  0.3831081  0.8348609 
         C1:C2         C1         C2      C1:C2 
    -0.8553797 -1.6459791  0.1060443 -0.2289640 
    
    
    $m6d
    $m6d$O1
         O1 = 1      O1 = 2      O1 = 3         M22         M23         M24 
    -1.06368027  0.02033976  1.41707305  0.80603868  0.65479149  0.71580502 
            O22         O23         O24      M22:C2      M23:C2      M24:C2 
    -0.88454115 -1.10818551 -0.49125970  3.26411580  1.83442991  0.47273765 
             C1          C2          C1          C2          C1          C2 
    -2.63541650 -1.97207458 -3.75588734 -1.35924254 -6.22222386 -1.33503339 
    
    
    $m6e
    $m6e$O1
          O1 = 1       O1 = 2       O1 = 3           C1          M22          M23 
     -0.33389990   0.07512444   0.92770081   4.34292460  -1.09785488   0.07876292 
             M24           C2          O22          O23          O24       M22:C2 
      0.34764892  -0.25614897  -1.00966031  -2.11710202   0.06780683  -1.05141685 
          M23:C2       M24:C2           C1          M22          M23          M24 
      1.51660764  -5.60957296  -3.19563162   0.10953947  -0.90818134   0.23478866 
              C2          O22          O23          O24       M22:C2       M23:C2 
      0.19608628  -0.28383577  -0.04639591  -0.30826006   0.43976314  -3.22542036 
          M24:C2           C1          M22          M23          M24           C2 
      0.75853094 -16.87086515   0.72285193   0.05183738   0.86320077   0.34293462 
             O22          O23          O24       M22:C2       M23:C2       M24:C2 
     -0.14930124  -0.30051350   0.53320381   1.18503702  -1.27552284   0.17610950 
    
    

---

    $m0a
    $m0a$O1
                 2.5%      97.5%
    O1 > 1  0.5803290  1.4292956
    O1 > 2 -0.3395248  0.2583132
    O1 > 3 -1.8124543 -0.8027858
    
    
    $m0b
    $m0b$O2
                  2.5%      97.5%
    O2 > 1  0.85983383  1.6107013
    O2 > 2 -0.09622027  0.5682783
    O2 > 3 -1.52411306 -0.5187390
    
    
    $m1a
    $m1a$O1
                  2.5%      97.5%
    O1 > 1   0.6536656  1.3088042
    O1 > 2  -0.3986761  0.2768796
    O1 > 3  -1.7861686 -0.8931783
    C1     -26.3728164 24.5500802
    
    
    $m1b
    $m1b$O2
                  2.5%      97.5%
    O2 > 1   0.7950479  1.7535649
    O2 > 2  -0.1325348  0.5309518
    O2 > 3  -1.6326747 -0.6040706
    C1     -17.4408287 19.7233496
    
    
    $m2a
    $m2a$O1
                 2.5%      97.5%
    O1 > 1  0.6283118  1.2476225
    O1 > 2 -0.2807250  0.2653818
    O1 > 3 -1.6842615 -0.9544439
    C2     -1.0953530  0.8419836
    
    
    $m2b
    $m2b$O2
                 2.5%      97.5%
    O2 > 1  0.6095743  1.6805904
    O2 > 2 -0.3623104  0.5877117
    O2 > 3 -1.9180066 -0.6289875
    C2     -1.8696645  0.4113309
    
    
    $m3a
    $m3a$C1
                       2.5%     97.5%
    (Intercept)  1.39448828 1.4635363
    O1.L        -0.04935405 0.3299230
    O1.Q        -0.26850210 0.1566694
    O1.C        -0.00994123 0.2019360
    
    
    $m3b
    $m3b$C1
                        2.5%       97.5%
    (Intercept)  1.425858371 1.440338362
    O22         -0.006120572 0.010808447
    O23         -0.008495764 0.012459695
    O24         -0.011846040 0.008716461
    
    
    $m4a
    $m4a$O1
                             2.5%      97.5%
    O1 > 1            -0.02664921  1.8362063
    O1 > 2            -1.27034495  0.8131176
    O1 > 3            -2.32102102 -0.4061696
    M22               -0.85969236  0.8790917
    M23               -0.78627993  1.0206915
    M24               -1.22850097  0.6179210
    O22               -0.43585398  2.9946119
    O23               -0.52266304  1.5019271
    O24               -2.58636225  1.0562738
    abs(C1 - C2)      -1.20810452  1.1535382
    log(C1)          -40.34080774 29.4922153
    O22:abs(C1 - C2)  -2.24111240  0.4748646
    O23:abs(C1 - C2)  -0.43698465  0.9005277
    O24:abs(C1 - C2)  -0.59451556  1.7686061
    
    
    $m4b
    $m4b$O1
                                                                      2.5%
    O1 > 1                                                       0.7839686
    O1 > 2                                                      -0.3025897
    O1 > 3                                                      -1.6924928
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               -1.3436588
    abs(C1 - C2)                                                -1.6891969
    log(C1)                                                    -44.4135789
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.3918672
                                                                    97.5%
    O1 > 1                                                      1.5999964
    O1 > 2                                                      0.3518042
    O1 > 3                                                     -0.9289533
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               1.5678690
    abs(C1 - C2)                                                0.5122760
    log(C1)                                                    18.7764474
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  1.5582018
    
    
    $m5a
    $m5a$O1
                  2.5%      97.5%
    O1 > 1  -0.2671435  1.2002261
    O1 > 2  -1.2902508  0.1964137
    O1 > 3  -2.7978998 -1.1922301
    M22     -0.6265813  0.9627160
    M23     -0.5132929  0.7780966
    M24     -0.7998983  0.8611047
    O22     -0.6074038  1.6952855
    O23      0.1939144  2.1302895
    O24     -0.6801701  1.1176146
    C1     -41.4168882 21.3187168
    C2      -1.2038728  1.6971127
    C1     -30.9828014  8.8944783
    C2      -0.9936259  1.1539007
    C1     -28.3158111 32.1672611
    C2      -1.0116292  1.6578368
    
    
    $m5b
    $m5b$O1
                   2.5%      97.5%
    O1 > 1  -0.18135743  1.4744417
    O1 > 2  -1.39698583  0.2854264
    O1 > 3  -2.89406573 -1.0831221
    M22     -0.88954686  0.9985997
    M23     -0.82310605  1.0725229
    M24     -1.08898364  0.7135056
    O22     -0.09816265  1.2193717
    O23     -0.10941166  1.8975879
    O24     -0.68589203  0.9421645
    C1:C2   -0.99626646  1.0958334
    C1     -44.66180786 14.7033784
    C2      -1.60873788  1.5123975
    C1     -33.34803508 10.8192682
    C2      -1.59541457  1.1859639
    C1     -28.88388326 16.8763963
    C2      -1.82049375  1.1937039
    
    
    $m5c
    $m5c$O1
                  2.5%      97.5%
    O1 > 1  -0.1004246  1.4928567
    O1 > 2  -1.4317794  0.4065131
    O1 > 3  -2.9016417 -1.0308469
    M22     -0.8842416  1.1624406
    M23     -1.2160601  0.9989346
    M24     -0.7599600  0.7864523
    O22     -0.3396193  1.6984406
    O23      0.4010522  1.9973679
    O24     -0.4111114  0.9551300
    C1     -41.0023454 26.5633376
    C2      -0.1142430  6.1163590
    C1:C2   -3.4602439  0.5341211
    C1     -32.7182716 13.8640706
    C2      -5.2378305  0.7734470
    C1:C2   -0.3510673  3.1038119
    C1     -23.0786316 18.4263853
    C2      -0.6399237  4.3342892
    C1:C2   -2.7967329  0.8908358
    
    
    $m5d
    $m5d$O1
                  2.5%      97.5%
    O1 > 1   0.2979967  1.3964394
    O1 > 2  -0.7034687  0.2727508
    O1 > 3  -2.1493418 -1.0232284
    M22     -1.0945471  1.0303739
    M23     -1.1142884  0.6575622
    M24     -1.0269427  0.7500228
    O22     -1.0447939  1.1809250
    O23      0.2235237  1.8938157
    O24     -0.7549601  0.9718110
    M22:C2  -3.8122078  1.8560535
    M23:C2  -0.9851441  3.2730289
    M24:C2   0.5333909  4.1199462
    C1     -30.0876107 28.6508636
    C2      -2.0821120  0.9431188
    C1     -21.1462536 23.8962317
    C2      -1.9943177  0.8421235
    C1     -27.8998372 33.9947283
    C2      -2.1359113  0.8060832
    
    
    $m5e
    $m5e$O1
                  2.5%       97.5%
    O1 > 1  -0.5175058  1.65411704
    O1 > 2  -0.9233650  0.78289786
    O1 > 3  -2.5876649  0.22197070
    C1     -54.7006164 39.50651777
    M22     -0.7638170  2.02109777
    M23     -1.9153762  1.06396585
    M24     -1.5345050  1.06878846
    C2      -4.8639839  0.98339287
    O22     -1.3774600  0.75896812
    O23      0.8465017  3.41328645
    O24     -1.6268722  0.68154660
    M22:C2  -0.9384961 10.78576049
    M23:C2  -2.8549021  3.03653316
    M24:C2   5.0846750 16.01433783
    C1     -44.8725759 15.74965649
    M22     -1.7575458  0.41173335
    M23     -0.3621631  1.26713276
    M24     -0.8955768  1.29812424
    C2      -1.5166846  1.98260187
    O22     -0.7437626  0.65122070
    O23     -0.1348628  1.22565103
    O24     -0.6601926  0.85591712
    M22:C2  -2.9944686  1.16048042
    M23:C2  -1.3533903  2.64352919
    M24:C2  -3.0655838  3.37716705
    C1     -26.9242742 25.24761557
    M22     -2.3973258  0.14591663
    M23     -1.5602830  0.45430951
    M24     -1.8475519  0.71107149
    C2      -2.3619998  0.07182334
    O22     -1.1828873  0.85124323
    O23     -0.2622139  1.96886014
    O24     -1.7386897  0.62719807
    M22:C2  -3.6075398  0.50578721
    M23:C2  -1.9843863  3.40012941
    M24:C2  -1.5801014  4.80360905
    
    
    $m6a
    $m6a$O1
                   2.5%      97.5%
    O1 = 1  -1.10558972  0.1672042
    O1 = 2  -0.01132578  1.3838107
    O1 = 3   1.41595389  2.6319491
    M22     -0.97157091  0.6748338
    M23     -0.99343317  0.4944521
    M24     -0.95736441  1.0545218
    O22     -1.13012177  0.4322934
    O23     -1.80281017 -0.4368739
    O24     -1.07750717  0.3208662
    C1     -36.00387774 38.3291410
    C2      -1.78838779  0.6345031
    C1     -34.57918651 39.5003234
    C2      -1.67952885  0.7025505
    C1     -33.51601610 31.8771466
    C2      -2.02901013  1.4295284
    
    
    $m6b
    $m6b$O1
                  2.5%      97.5%
    O1 = 1  -1.2197406  0.3699958
    O1 = 2  -0.3402051  1.4602769
    O1 = 3   1.0171435  2.9213180
    M22     -1.2464137  0.9719781
    M23     -0.8458509  0.8751863
    M24     -0.4579931  1.3183931
    O22     -1.1694969  0.2444874
    O23     -1.7042475 -0.4193296
    O24     -0.8847879  0.3703065
    C1:C2   -1.0765699  1.6617207
    C1     -19.8086027 37.6323447
    C2      -1.8459221  1.2645361
    C1      -7.3373944 33.2529915
    C2      -1.9931769  1.4381869
    C1     -26.2984639 31.1290199
    C2      -2.9419717  1.3311922
    
    
    $m6c
    $m6c$O1
                  2.5%       97.5%
    O1 = 1  -1.8381972 -0.03053809
    O1 = 2  -0.6708829  1.13482383
    O1 = 3   0.4329514  2.33886311
    M22     -1.3389282  1.36028204
    M23     -1.3105934  1.38189953
    M24     -0.7664274  1.65026110
    O22     -1.6661984  0.62301421
    O23     -2.0752311 -0.04717327
    O24     -1.2146871  0.95230254
    C1     -26.1731864 30.38961221
    C2      -4.7197740  3.55218634
    C1:C2   -2.5804811  2.24537807
    C1     -18.7870240 22.98418579
    C2      -1.6586285  4.29486193
    C1:C2   -3.1463307  0.58849108
    C1     -30.2414059 26.79248757
    C2      -3.8067166  2.65628139
    C1:C2   -1.8895807  1.96804823
    
    
    $m6d
    $m6d$O1
                  2.5%       97.5%
    O1 = 1  -2.1008439 -0.21939475
    O1 = 2  -1.1468953  0.88113659
    O1 = 3   0.3276953  2.36152287
    M22     -0.3293465  1.50594479
    M23     -0.2164511  1.26103596
    M24     -0.6354904  1.44205713
    O22     -1.9200135  0.41093978
    O23     -2.2188171  0.05888811
    O24     -1.8074345  0.65443332
    M22:C2   1.3599370  5.29622647
    M23:C2   0.1873079  3.67365823
    M24:C2  -1.7681228  2.57609317
    C1     -29.7255412 27.48709989
    C2      -3.3891266 -0.85005749
    C1     -30.3221156 31.67535863
    C2      -2.8535995  0.08268697
    C1     -44.8195125 25.99759631
    C2      -2.7521935  0.42855919
    
    
    $m6e
    $m6e$O1
                   2.5%      97.5%
    O1 = 1  -0.98408506  0.2882404
    O1 = 2  -0.38226902  0.5322925
    O1 = 3  -0.03568115  2.1168710
    C1     -14.18474753 18.6777332
    M22     -1.75196267 -0.3105292
    M23     -0.97788662  1.2769448
    M24     -0.46365345  1.4828985
    C2      -1.46396838  0.9533311
    O22     -2.02970840 -0.1584130
    O23     -4.52930053 -0.8325172
    O24     -1.16419382  1.0094442
    M22:C2  -3.47477438  1.8171689
    M23:C2  -1.06540952  3.7630348
    M24:C2  -9.18115117 -2.2025756
    C1     -18.29098276 13.7350247
    M22     -0.57806024  1.4733524
    M23     -2.27855183  0.2378887
    M24     -0.95903517  1.8436504
    C2      -2.01060429  1.7522331
    O22     -1.08266047  0.5673788
    O23     -2.30498258  1.1739572
    O24     -1.51463712  0.6236888
    M22:C2  -3.30714532  2.9301154
    M23:C2  -9.06829089  1.7974967
    M24:C2  -1.68875587  4.1709662
    C1     -37.02828325  9.3165845
    M22     -0.35210281  2.3906510
    M23     -1.67158011  1.3271733
    M24     -0.37727520  2.8769681
    C2      -2.23235293  2.7923077
    O22     -1.28414500  0.6222311
    O23     -2.23255286  1.0226427
    O24     -0.97579360  1.5192044
    M22:C2  -1.52173530  4.5076550
    M23:C2  -6.22093395  2.4282491
    M24:C2  -3.49983817  3.7199670
    
    

---

    $m0a
    
    Bayesian cumulative logit model fitted with JointAI
    
    Call:
    clm_imp(formula = O1 ~ 1, data = wideDF, n.adapt = 5, n.iter = 10, 
        seed = 2020)
    
    
    Posterior summary:
         Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    
    Posterior summary of the intercepts:
              Mean    SD  2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.9916 0.255  0.58  1.429      0.000    1.80  0.392
    O1 > 2 -0.0373 0.187 -0.34  0.258      0.933    0.99  0.061
    O1 > 3 -1.2489 0.286 -1.81 -0.803      0.000    1.33  0.188
    
    
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
             Mean    SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    O2 > 1  1.211 0.259  0.8598  1.611        0.0    1.65  0.398
    O2 > 2  0.192 0.201 -0.0962  0.568        0.4    1.37  0.105
    O2 > 3 -0.997 0.265 -1.5241 -0.519        0.0    1.02  0.183
    
    
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
         Mean SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    C1 -0.871 15 -26.4  24.6      0.867   0.985  0.183
    
    Posterior summary of the intercepts:
              Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.9815 0.185  0.654  1.309        0.0    1.36  0.315
    O1 > 2 -0.0271 0.178 -0.399  0.277        0.8    1.27  0.183
    O1 > 3 -1.3495 0.248 -1.786 -0.893        0.0    1.14  0.183
    
    
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
    C1 4.69 11.1 -17.4  19.7        0.6     1.1  0.193
    
    Posterior summary of the intercepts:
            Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O2 > 1  1.27 0.294  0.795  1.754        0.0    1.25  0.370
    O2 > 2  0.23 0.191 -0.133  0.531        0.2    1.23  0.183
    O2 > 3 -1.00 0.285 -1.633 -0.604        0.0    1.34  0.183
    
    
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
          Mean    SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    C2 -0.0767 0.604 -1.1 0.842          1    1.22  0.183
    
    Posterior summary of the intercepts:
              Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.9427 0.198  0.628  1.248      0.000    1.82  0.183
    O1 > 2 -0.0353 0.188 -0.281  0.265      0.867    1.20  0.183
    O1 > 3 -1.2949 0.238 -1.684 -0.954      0.000    1.14  0.118
    
    
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
        Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    C2 -0.89 0.614 -1.87 0.411        0.2    1.67  0.183
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O2 > 1  1.164 0.285  0.610  1.681      0.000    1.15  0.239
    O2 > 2  0.113 0.249 -0.362  0.588      0.533    1.05  0.183
    O2 > 3 -1.097 0.309 -1.918 -0.629      0.000    1.43  0.183
    
    
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
                    Mean     SD     2.5% 97.5% tail-prob. GR-crit MCE/SD
    (Intercept)  1.43358 0.0228  1.39449 1.464      0.000    1.68  0.183
    O1.L         0.02432 0.0912 -0.04935 0.330      0.933    1.07  0.183
    O1.Q        -0.00396 0.1094 -0.26850 0.157      0.867    1.47  0.183
    O1.C         0.02169 0.0657 -0.00994 0.202      0.733    1.12  0.183
    
    Posterior summary of residual std. deviation:
               Mean     SD   2.5% 97.5% GR-crit MCE/SD
    sigma_C1 0.0442 0.0685 0.0173 0.241    1.01  0.183
    
    
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
    (Intercept) 1.432435 0.00397  1.42586 1.44034      0.000    1.56  0.183
    O22         0.002989 0.00512 -0.00612 0.01081      0.600    1.28  0.183
    O23         0.003073 0.00629 -0.00850 0.01246      0.667    1.52  0.183
    O24         0.000398 0.00583 -0.01185 0.00872      0.800    1.09  0.183
    
    Posterior summary of residual std. deviation:
               Mean      SD   2.5%  97.5% GR-crit MCE/SD
    sigma_C1 0.0197 0.00135 0.0178 0.0226    1.06  0.183
    
    
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
    M22              -0.04624  0.497  -0.860  0.879      1.000   2.452  0.277
    M23              -0.00979  0.548  -0.786  1.021      0.933   2.333  0.206
    M24              -0.15095  0.533  -1.229  0.618      0.933   3.003  0.215
    O22               1.12992  1.083  -0.436  2.995      0.400   3.870  0.688
    O23               0.38627  0.661  -0.523  1.502      0.800   3.545  0.571
    O24              -0.58357  1.202  -2.586  1.056      1.000   7.237  0.430
    abs(C1 - C2)      0.04272  0.735  -1.208  1.154      0.933   2.531  0.216
    log(C1)          -5.45743 20.407 -40.341 29.492      0.867   0.985  0.019
    O22:abs(C1 - C2) -0.53063  0.752  -2.241  0.475      0.600   3.845  0.454
    O23:abs(C1 - C2)  0.35270  0.466  -0.437  0.901      0.533   5.158  0.411
    O24:abs(C1 - C2)  0.44103  0.751  -0.595  1.769      0.867   6.583  0.547
    
    Posterior summary of the intercepts:
             Mean    SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.911 0.592 -0.0266  1.836      0.133    4.35  0.457
    O1 > 2 -0.112 0.588 -1.2703  0.813      0.800    3.84  0.507
    O1 > 3 -1.371 0.579 -2.3210 -0.406      0.000    4.46  0.521
    
    
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
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)              -0.217  0.909
    abs(C1 - C2)                                               -0.363  0.669
    log(C1)                                                    -3.213 16.464
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.710  0.630
                                                                  2.5%  97.5%
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               -1.344  1.568
    abs(C1 - C2)                                                -1.689  0.512
    log(C1)                                                    -44.414 18.776
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.392  1.558
                                                               tail-prob. GR-crit
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)                   0.600    5.96
    abs(C1 - C2)                                                    0.733    2.09
    log(C1)                                                         0.867    1.63
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)      0.333    6.65
                                                               MCE/SD
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               0.617
    abs(C1 - C2)                                                0.228
    log(C1)                                                     0.183
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.763
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  1.166 0.248  0.784  1.600      0.000    1.30  0.183
    O1 > 2  0.015 0.198 -0.303  0.352      0.867    1.97  0.183
    O1 > 3 -1.243 0.215 -1.692 -0.929      0.000    1.22  0.173
    
    
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
    M22       0.0895  0.423  -0.627  0.963      0.933    1.84  0.183
    M23       0.2060  0.359  -0.513  0.778      0.467    1.47  0.183
    M24      -0.0539  0.441  -0.800  0.861      0.933    1.30  0.322
    O22       0.4514  0.684  -0.607  1.695      0.600    3.90  0.418
    O23       1.0097  0.546   0.194  2.130      0.000    5.20  0.721
    O24       0.2385  0.567  -0.680  1.118      0.733    6.20  0.524
    O12: C1 -10.7855 17.857 -41.417 21.319      0.533    1.55  0.184
    O12: C2   0.4432  0.861  -1.204  1.697      0.467    2.39  0.183
    O13: C1  -6.8949 11.031 -30.983  8.894      0.600    1.75  0.322
    O13: C2   0.2208  0.669  -0.994  1.154      0.600    3.68  0.335
    O14: C1  -1.0241 16.222 -28.316 32.167      0.800    1.11  0.183
    O14: C2   0.2262  0.812  -1.012  1.658      1.000    3.92  0.355
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.542 0.474 -0.267  1.200      0.333    5.63  0.455
    O1 > 2 -0.544 0.469 -1.290  0.196      0.400    4.56  0.452
    O1 > 3 -1.856 0.454 -2.798 -1.192      0.000    3.25  0.339
    
    
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
    M22      0.2002  0.523  -0.8895  0.999      0.533    3.52  0.305
    M23      0.2079  0.611  -0.8231  1.073      0.733    1.92  0.478
    M24     -0.0152  0.531  -1.0890  0.714      0.933    3.08  0.343
    O22      0.4991  0.385  -0.0982  1.219      0.133    1.60  0.234
    O23      1.0553  0.527  -0.1094  1.898      0.133    1.70  0.641
    O24      0.2761  0.504  -0.6859  0.942      0.533    2.63  0.469
    C1:C2    0.1785  0.556  -0.9963  1.096      0.733    2.81  0.303
    O12: C1 -9.3761 18.234 -44.6618 14.703      0.867    1.91  0.223
    O12: C2  0.1724  0.879  -1.6087  1.512      0.733    3.24  0.408
    O13: C1 -6.0590 13.083 -33.3480 10.819      0.800    5.59  0.390
    O13: C2 -0.0431  0.835  -1.5954  1.186      0.867    4.77  0.540
    O14: C1 -2.3718 13.186 -28.8839 16.876      1.000    3.91  0.506
    O14: C2 -0.3220  0.876  -1.8205  1.194      0.667    3.76  0.183
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.559 0.523 -0.181  1.474      0.467    6.03  0.788
    O1 > 2 -0.609 0.491 -1.397  0.285      0.133    4.76  0.183
    O1 > 3 -1.972 0.485 -2.894 -1.083      0.000    6.05  0.458
    
    
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
                  Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    M22         0.0542  0.564  -0.884  1.162     0.8667    3.61  0.416
    M23         0.0696  0.631  -1.216  0.999     0.9333    5.17  0.689
    M24        -0.1947  0.481  -0.760  0.786     0.5333    7.05  0.490
    O22         0.6222  0.533  -0.340  1.698     0.1333    1.19  0.226
    O23         1.1529  0.517   0.401  1.997     0.0000    3.08  0.435
    O24         0.3477  0.441  -0.411  0.955     0.6667    2.45  0.183
    O12: C1    -6.5439 20.432 -41.002 26.563     0.7333    1.04  0.183
    O12: C2     2.5284  1.826  -0.114  6.116     0.0667    6.44  0.433
    O12: C1:C2 -1.4131  1.081  -3.460  0.534     0.2000    2.94  0.263
    O13: C1    -8.5257 15.012 -32.718 13.864     0.7333    1.30  0.220
    O13: C2    -1.6496  1.888  -5.238  0.773     0.4667    4.37  0.351
    O13: C1:C2  1.2632  1.055  -0.351  3.104     0.2000    2.75  0.369
    O14: C1    -3.1410 12.178 -23.079 18.426     0.9333    1.07  0.183
    O14: C2     1.7306  1.611  -0.640  4.334     0.4000    2.29  0.517
    O14: C1:C2 -0.9927  1.194  -2.797  0.891     0.5333    2.76  0.540
    
    Posterior summary of the intercepts:
             Mean    SD  2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.636 0.578 -0.10  1.493      0.400   14.22  0.767
    O1 > 2 -0.545 0.588 -1.43  0.407      0.533   12.76  0.528
    O1 > 3 -1.926 0.595 -2.90 -1.031      0.000    6.56  0.463
    
    
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
    M22     -0.223  0.620  -1.095  1.030     0.6000    4.63  0.426
    M23     -0.196  0.532  -1.114  0.658     0.6667    3.89  0.519
    M24     -0.245  0.609  -1.027  0.750     0.7333    2.42  0.404
    O22      0.347  0.590  -1.045  1.181     0.4000    2.26  0.183
    O23      0.986  0.499   0.224  1.894     0.0667    3.27  0.371
    O24      0.106  0.532  -0.755  0.972     0.8667    1.94  0.202
    M22:C2  -0.682  1.550  -3.812  1.856     0.6667    2.17  0.244
    M23:C2   0.697  1.279  -0.985  3.273     0.6667    1.86  0.197
    M24:C2   2.462  1.037   0.533  4.120     0.0000    1.62  0.183
    O12: C1  4.365 15.250 -30.088 28.651     0.9333    2.02  0.183
    O12: C2 -0.384  0.806  -2.082  0.943     0.6000    2.90  0.316
    O13: C1  6.621 12.643 -21.146 23.896     0.5333    4.15  0.335
    O13: C2 -0.909  0.735  -1.994  0.842     0.2000    1.99  0.314
    O14: C1  6.472 16.409 -27.900 33.995     0.4000    3.43  0.387
    O14: C2 -0.901  0.794  -2.136  0.806     0.2667    2.04  0.293
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.900 0.296  0.298  1.396      0.000    1.80  0.226
    O1 > 2 -0.201 0.289 -0.703  0.273      0.533    1.82  0.242
    O1 > 3 -1.598 0.315 -2.149 -1.023      0.000    1.54  0.288
    
    
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
                   Mean     SD    2.5%   97.5% tail-prob. GR-crit MCE/SD
    O12: C1     -0.8905 27.400 -54.701 39.5065     0.9333    1.58  0.401
    O12: M22     0.9352  0.833  -0.764  2.0211     0.3333    6.57  0.518
    O12: M23    -0.3890  0.926  -1.915  1.0640     0.8667    3.24  0.499
    O12: M24    -0.0867  0.752  -1.535  1.0688     0.9333    2.85  0.458
    O12: C2     -1.8880  1.670  -4.864  0.9834     0.2000    2.68  0.407
    O12: O22     0.0198  0.572  -1.377  0.7590     0.7333    3.29       
    O12: O23     2.2884  0.729   0.847  3.4133     0.0000    2.38  0.262
    O12: O24    -0.4338  0.609  -1.627  0.6815     0.4667    1.18  0.329
    O12: M22:C2  4.6838  2.869  -0.938 10.7858     0.1333    2.09  0.291
    O12: M23:C2 -0.0751  1.549  -2.855  3.0365     0.9333    3.33  0.505
    O12: M24:C2  9.6810  3.541   5.085 16.0143     0.0000    5.88  0.450
    O13: C1     -7.0763 18.324 -44.873 15.7497     0.8000    2.76  0.350
    O13: M22    -0.5725  0.747  -1.758  0.4117     0.7333    4.78  0.491
    O13: M23     0.1846  0.519  -0.362  1.2671     0.9333    8.87  0.494
    O13: M24     0.1801  0.643  -0.896  1.2981     1.0000    5.98  0.537
    O13: C2     -0.0228  1.057  -1.517  1.9826     0.9333    3.42  0.498
    O13: O22    -0.0434  0.444  -0.744  0.6512     0.8667    1.98  0.307
    O13: O23     0.4716  0.399  -0.135  1.2257     0.3333    1.84  0.271
    O13: O24     0.1642  0.426  -0.660  0.8559     0.6000    3.04  0.324
    O13: M22:C2 -1.2034  1.464  -2.994  1.1605     0.6000    2.19  0.278
    O13: M23:C2  0.6555  1.222  -1.353  2.6435     0.5333    1.78  0.308
    O13: M24:C2 -0.2360  1.843  -3.066  3.3772     0.7333    4.50  0.336
    O14: C1      0.4174 17.117 -26.924 25.2476     1.0000    2.28  0.212
    O14: M22    -1.0983  0.777  -2.397  0.1459     0.1333    4.89  0.913
    O14: M23    -0.5042  0.625  -1.560  0.4543     0.4667    5.05  0.390
    O14: M24    -0.5161  0.817  -1.848  0.7111     0.5333    3.89  0.469
    O14: C2     -0.9314  0.715  -2.362  0.0718     0.0667    2.01  0.230
    O14: O22    -0.0766  0.569  -1.183  0.8512     0.8667    2.77  0.475
    O14: O23     0.7872  0.646  -0.262  1.9689     0.2667    5.59  0.753
    O14: O24    -0.3996  0.658  -1.739  0.6272     0.4667    3.63  0.356
    O14: M22:C2 -1.1023  1.229  -3.608  0.5058     0.3333    1.02  0.183
    O14: M23:C2  0.6973  1.552  -1.984  3.4001     0.7333    1.14  0.304
    O14: M24:C2  1.2110  1.925  -1.580  4.8036     0.5333    2.28  0.444
    
    Posterior summary of the intercepts:
              Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    O1 > 1  0.6500 0.614 -0.518 1.654      0.333    4.20  0.472
    O1 > 2 -0.0312 0.550 -0.923 0.783      0.933    6.89  0.447
    O1 > 3 -1.1919 0.937 -2.588 0.222      0.333   10.31  0.810
    
    
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
    M22     -0.2133  0.527  -0.972  0.675      0.733    3.47  0.511
    M23     -0.2691  0.438  -0.993  0.494      0.467    3.69  0.454
    M24      0.0662  0.663  -0.957  1.055      1.000    3.95  0.183
    O22     -0.4915  0.442  -1.130  0.432      0.267    1.17  0.183
    O23     -1.2406  0.369  -1.803 -0.437      0.000    1.08  0.183
    O24     -0.3592  0.408  -1.078  0.321      0.400    1.51  0.336
    O12: C1  4.7167 22.725 -36.004 38.329      0.933    1.33  0.217
    O12: C2 -0.5599  0.818  -1.788  0.635      0.533    3.10  0.344
    O13: C1 -1.5124 19.594 -34.579 39.500      0.733    1.49  0.469
    O13: C2 -0.5028  0.760  -1.680  0.703      0.667    2.91  0.333
    O14: C1 -1.8103 19.101 -33.516 31.877      0.800    1.18  0.290
    O14: C2 -0.1422  0.956  -2.029  1.430      0.867    2.96  0.183
    
    Posterior summary of the intercepts:
             Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    O1 = 1 -0.397 0.395 -1.1056 0.167     0.3333    5.66  0.587
    O1 = 2  0.673 0.430 -0.0113 1.384     0.0667    4.64  0.492
    O1 = 3  2.066 0.355  1.4160 2.632     0.0000    2.82  0.284
    
    
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
               Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    M22      0.0102  0.544  -1.246  0.972      0.867    1.82  0.289
    M23     -0.1168  0.512  -0.846  0.875      0.800    2.58  0.325
    M24      0.1979  0.525  -0.458  1.318      0.800    2.30  0.324
    O22     -0.4996  0.386  -1.169  0.244      0.200    1.42  0.209
    O23     -0.9980  0.367  -1.704 -0.419      0.000    1.84  0.214
    O24     -0.3488  0.371  -0.885  0.370      0.400    1.73  0.361
    C1:C2    0.0421  0.867  -1.077  1.662      0.800    6.28  0.439
    O12: C1 12.8133 15.768 -19.809 37.632      0.400    1.12  0.239
    O12: C2 -0.5303  0.977  -1.846  1.265      0.600    3.96  0.661
    O13: C1  8.8071 11.479  -7.337 33.253      0.467    1.58  0.362
    O13: C2 -0.1348  1.058  -1.993  1.438      0.933    5.35  0.369
    O14: C1  1.0326 18.016 -26.298 31.129      1.000    1.24  0.232
    O14: C2 -0.1265  1.185  -2.942  1.331      0.933    4.95  0.502
    
    Posterior summary of the intercepts:
             Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    O1 = 1 -0.594 0.513 -1.22  0.37      0.333    3.37  0.369
    O1 = 2  0.396 0.514 -0.34  1.46      0.467    2.99  0.183
    O1 = 3  1.803 0.583  1.02  2.92      0.000    2.98  0.447
    
    
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
                  Mean     SD    2.5%   97.5% tail-prob. GR-crit MCE/SD
    M22         0.1778  0.846  -1.339  1.3603     0.8667    6.02  0.648
    M23         0.1408  0.764  -1.311  1.3819     0.6667    5.92  0.456
    M24         0.5200  0.782  -0.766  1.6503     0.6000    4.89  0.459
    O22        -0.4034  0.628  -1.666  0.6230     0.4667    2.62  0.324
    O23        -0.9565  0.632  -2.075 -0.0472     0.0667    4.44  0.550
    O24        -0.1524  0.614  -1.215  0.9523     0.7333    4.16  0.520
    O12: C1     3.4874 15.781 -26.173 30.3896     0.8000    1.31  0.183
    O12: C2    -0.5782  2.615  -4.720  3.5522     0.9333    8.91  0.437
    O12: C1:C2 -0.0389  1.478  -2.580  2.2454     0.9333    6.23  0.462
    O13: C1     0.3831 12.402 -18.787 22.9842     0.9333    2.36  0.353
    O13: C2     0.8349  2.081  -1.659  4.2949     0.7333   14.39  0.672
    O13: C1:C2 -0.8554  1.234  -3.146  0.5885     0.8000    8.90  0.449
    O14: C1    -1.6460 16.336 -30.241 26.7925     0.8667    1.81  0.183
    O14: C2     0.1060  1.920  -3.807  2.6563     0.6000    5.26  0.530
    O14: C1:C2 -0.2290  1.146  -1.890  1.9680     0.8000    2.74  0.170
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%   97.5% tail-prob. GR-crit MCE/SD
    O1 = 1 -0.856 0.526 -1.838 -0.0305        0.0    1.23       
    O1 = 2  0.201 0.548 -0.671  1.1348        0.8    1.40  0.252
    O1 = 3  1.545 0.537  0.433  2.3389        0.0    1.31  0.183
    
    
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
              Mean     SD    2.5%   97.5% tail-prob. GR-crit MCE/SD
    M22      0.806  0.530  -0.329  1.5059     0.2000    1.00  0.359
    M23      0.655  0.435  -0.216  1.2610     0.1333    1.32  0.230
    M24      0.716  0.547  -0.635  1.4421     0.2000    1.18  0.315
    O22     -0.885  0.683  -1.920  0.4109     0.2667    2.70  0.324
    O23     -1.108  0.751  -2.219  0.0589     0.1333    6.01  0.770
    O24     -0.491  0.715  -1.807  0.6544     0.6000    4.04  0.459
    M22:C2   3.264  1.234   1.360  5.2962     0.0000    2.39  0.325
    M23:C2   1.834  1.072   0.187  3.6737     0.0000    1.32  0.183
    M24:C2   0.473  1.330  -1.768  2.5761     0.7333    1.21  0.183
    O12: C1 -2.635 17.208 -29.726 27.4871     0.9333    3.31  0.424
    O12: C2 -1.972  0.760  -3.389 -0.8501     0.0000    2.85  0.340
    O13: C1 -3.756 19.481 -30.322 31.6754     0.7333    4.08  0.482
    O13: C2 -1.359  0.762  -2.854  0.0827     0.0667    2.09  0.402
    O14: C1 -6.222 23.133 -44.820 25.9976     0.9333    3.27  0.315
    O14: C2 -1.335  0.860  -2.752  0.4286     0.2000    2.37  0.332
    
    Posterior summary of the intercepts:
              Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    O1 = 1 -1.0637 0.580 -2.101 -0.219        0.0    6.71  0.648
    O1 = 2  0.0203 0.662 -1.147  0.881        0.8    9.18  0.665
    O1 = 3  1.4171 0.646  0.328  2.362        0.0    6.15  0.552
    
    
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
                    Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    O12: C1       4.3429  9.794 -14.185 18.678     0.5333    2.07  0.183
    O12: M22     -1.0979  0.464  -1.752 -0.311     0.0000    2.87  0.299
    O12: M23      0.0788  0.559  -0.978  1.277     0.8000    1.93  0.224
    O12: M24      0.3476  0.605  -0.464  1.483     0.6667    2.27       
    O12: C2      -0.2561  0.735  -1.464  0.953     0.7333    2.79  0.306
    O12: O22     -1.0097  0.597  -2.030 -0.158     0.0667    4.79  0.345
    O12: O23     -2.1171  0.938  -4.529 -0.833     0.0000    4.17  0.322
    O12: O24      0.0678  0.535  -1.164  1.009     0.6667    2.81  0.334
    O12: M22:C2  -1.0514  1.496  -3.475  1.817     0.4667    1.33       
    O12: M23:C2   1.5166  1.353  -1.065  3.763     0.2667    1.83  0.183
    O12: M24:C2  -5.6096  2.086  -9.181 -2.203     0.0000    5.07  0.627
    O13: C1      -3.1956  8.820 -18.291 13.735     0.6667    1.88  0.225
    O13: M22      0.1095  0.581  -0.578  1.473     0.8667    4.15  0.321
    O13: M23     -0.9082  0.791  -2.279  0.238     0.2000    3.32  0.510
    O13: M24      0.2348  0.816  -0.959  1.844     0.9333    6.69  0.598
    O13: C2       0.1961  1.470  -2.011  1.752     0.7333    8.00  0.834
    O13: O22     -0.2838  0.513  -1.083  0.567     0.6667    4.24  0.493
    O13: O23     -0.0464  0.953  -2.305  1.174     0.7333   10.40  0.445
    O13: O24     -0.3083  0.616  -1.515  0.624     0.6667    5.17  0.434
    O13: M22:C2   0.4398  2.005  -3.307  2.930     0.8000    4.88  0.469
    O13: M23:C2  -3.2254  3.581  -9.068  1.797     0.6000    8.41  0.399
    O13: M24:C2   0.7585  1.802  -1.689  4.171     0.8667    6.65  0.622
    O14: C1     -16.8709 12.394 -37.028  9.317     0.2667    1.13  0.335
    O14: M22      0.7229  0.849  -0.352  2.391     0.3333    5.15  0.518
    O14: M23      0.0518  0.836  -1.672  1.327     1.0000    2.66  0.472
    O14: M24      0.8632  0.924  -0.377  2.877     0.2000    5.84  0.434
    O14: C2       0.3429  1.594  -2.232  2.792     0.6667    6.40  0.792
    O14: O22     -0.1493  0.545  -1.284  0.622     0.8667    2.72  0.342
    O14: O23     -0.3005  0.846  -2.233  1.023     0.8667    3.26  0.338
    O14: O24      0.5332  0.686  -0.976  1.519     0.4000    1.48  0.376
    O14: M22:C2   1.1850  1.999  -1.522  4.508     0.6667    4.59  0.737
    O14: M23:C2  -1.2755  2.532  -6.221  2.428     0.5333    6.96  0.544
    O14: M24:C2   0.1761  2.029  -3.500  3.720     0.9333    5.81  0.404
    
    Posterior summary of the intercepts:
              Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    O1 = 1 -0.3339 0.378 -0.9841 0.288      0.400    6.34  0.580
    O1 = 2  0.0751 0.288 -0.3823 0.532      0.800    3.82  0.235
    O1 = 3  0.9277 0.623 -0.0357 2.117      0.133    6.95  0.521
    
    
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
             Mean      SD      2.5%    97.5% tail-prob.   GR-crit    MCE/SD
    C1 -0.8706421 14.9832 -26.37282 24.55008  0.8666667 0.9852478 0.1825742
    
    
    $m1b
    $m1b$O2
           Mean      SD      2.5%    97.5% tail-prob. GR-crit    MCE/SD
    C1 4.690647 11.1203 -17.44083 19.72335        0.6 1.09686 0.1930138
    
    
    $m2a
    $m2a$O1
              Mean        SD      2.5%     97.5% tail-prob.  GR-crit    MCE/SD
    C2 -0.07671119 0.6041511 -1.095353 0.8419836          1 1.220118 0.1825742
    
    
    $m2b
    $m2b$O2
             Mean        SD      2.5%     97.5% tail-prob. GR-crit    MCE/SD
    C2 -0.8900381 0.6136366 -1.869664 0.4113309        0.2 1.66505 0.1825742
    
    
    $m3a
    $m3a$C1
                        Mean         SD        2.5%     97.5% tail-prob.  GR-crit
    (Intercept)  1.433576985 0.02284838  1.39448828 1.4635363  0.0000000 1.680396
    O1.L         0.024323200 0.09115722 -0.04935405 0.3299230  0.9333333 1.068808
    O1.Q        -0.003961707 0.10939495 -0.26850210 0.1566694  0.8666667 1.466988
    O1.C         0.021689650 0.06569537 -0.00994123 0.2019360  0.7333333 1.120312
                   MCE/SD
    (Intercept) 0.1825742
    O1.L        0.1825742
    O1.Q        0.1825742
    O1.C        0.1825742
    
    
    $m3b
    $m3b$C1
                        Mean          SD         2.5%       97.5% tail-prob.
    (Intercept) 1.4324351139 0.003973062  1.425858371 1.440338362  0.0000000
    O22         0.0029888620 0.005123755 -0.006120572 0.010808447  0.6000000
    O23         0.0030733364 0.006291526 -0.008495764 0.012459695  0.6666667
    O24         0.0003981795 0.005833859 -0.011846040 0.008716461  0.8000000
                 GR-crit    MCE/SD
    (Intercept) 1.562497 0.1825742
    O22         1.278558 0.1825742
    O23         1.519440 0.1825742
    O24         1.085210 0.1825742
    
    
    $m4a
    $m4a$O1
                             Mean         SD        2.5%      97.5% tail-prob.
    M22              -0.046235419  0.4966647  -0.8596924  0.8790917  1.0000000
    M23              -0.009786385  0.5479640  -0.7862799  1.0206915  0.9333333
    M24              -0.150951646  0.5329123  -1.2285010  0.6179210  0.9333333
    O22               1.129919626  1.0826054  -0.4358540  2.9946119  0.4000000
    O23               0.386265507  0.6608148  -0.5226630  1.5019271  0.8000000
    O24              -0.583569497  1.2020447  -2.5863622  1.0562738  1.0000000
    abs(C1 - C2)      0.042722066  0.7352414  -1.2081045  1.1535382  0.9333333
    log(C1)          -5.457429666 20.4071215 -40.3408077 29.4922153  0.8666667
    O22:abs(C1 - C2) -0.530625641  0.7515399  -2.2411124  0.4748646  0.6000000
    O23:abs(C1 - C2)  0.352697648  0.4663268  -0.4369847  0.9005277  0.5333333
    O24:abs(C1 - C2)  0.441028934  0.7506843  -0.5945156  1.7686061  0.8666667
                       GR-crit     MCE/SD
    M22              2.4516574 0.27749669
    M23              2.3328814 0.20560503
    M24              3.0028324 0.21519606
    O22              3.8700658 0.68751763
    O23              3.5453759 0.57148223
    O24              7.2369678 0.42998284
    abs(C1 - C2)     2.5308090 0.21646780
    log(C1)          0.9852895 0.01904239
    O22:abs(C1 - C2) 3.8449731 0.45392566
    O23:abs(C1 - C2) 5.1580537 0.41140344
    O24:abs(C1 - C2) 6.5833058 0.54672609
    
    
    $m4b
    $m4b$O1
                                                                     Mean
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)              -0.2169008
    abs(C1 - C2)                                               -0.3626296
    log(C1)                                                    -3.2132615
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.7097327
                                                                       SD
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               0.9094851
    abs(C1 - C2)                                                0.6693424
    log(C1)                                                    16.4640224
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.6299618
                                                                      2.5%
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               -1.3436588
    abs(C1 - C2)                                                -1.6891969
    log(C1)                                                    -44.4135789
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.3918672
                                                                   97.5% tail-prob.
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)               1.567869  0.6000000
    abs(C1 - C2)                                                0.512276  0.7333333
    log(C1)                                                    18.776447  0.8666667
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2)  1.558202  0.3333333
                                                                GR-crit    MCE/SD
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0)              5.960579 0.6170299
    abs(C1 - C2)                                               2.086202 0.2283766
    log(C1)                                                    1.625260 0.1825742
    ifelse(as.numeric(O2) > as.numeric(M1), 1, 0):abs(C1 - C2) 6.647339 0.7631866
    
    
    $m5a
    $m5a$O1
                    Mean         SD        2.5%      97.5% tail-prob.  GR-crit
    M22       0.08946898  0.4230751  -0.6265813  0.9627160  0.9333333 1.842439
    M23       0.20600658  0.3594332  -0.5132929  0.7780966  0.4666667 1.468804
    M24      -0.05393605  0.4412561  -0.7998983  0.8611047  0.9333333 1.295010
    O22       0.45141931  0.6838813  -0.6074038  1.6952855  0.6000000 3.901194
    O23       1.00971448  0.5459770   0.1939144  2.1302895  0.0000000 5.195397
    O24       0.23854173  0.5665115  -0.6801701  1.1176146  0.7333333 6.201147
    O12: C1 -10.78551700 17.8571418 -41.4168882 21.3187168  0.5333333 1.549372
    O12: C2   0.44316235  0.8607738  -1.2038728  1.6971127  0.4666667 2.392764
    O13: C1  -6.89491843 11.0311359 -30.9828014  8.8944783  0.6000000 1.747230
    O13: C2   0.22082776  0.6691905  -0.9936259  1.1539007  0.6000000 3.684459
    O14: C1  -1.02407402 16.2220628 -28.3158111 32.1672611  0.8000000 1.108735
    O14: C2   0.22619102  0.8119555  -1.0116292  1.6578368  1.0000000 3.917494
               MCE/SD
    M22     0.1825742
    M23     0.1825742
    M24     0.3216656
    O22     0.4182749
    O23     0.7214423
    O24     0.5244061
    O12: C1 0.1843290
    O12: C2 0.1825742
    O13: C1 0.3217644
    O13: C2 0.3349953
    O14: C1 0.1825742
    O14: C2 0.3548385
    
    
    $m5b
    $m5b$O1
                   Mean         SD         2.5%      97.5% tail-prob.  GR-crit
    M22      0.20019094  0.5234170  -0.88954686  0.9985997  0.5333333 3.515784
    M23      0.20792029  0.6110041  -0.82310605  1.0725229  0.7333333 1.917556
    M24     -0.01520864  0.5310363  -1.08898364  0.7135056  0.9333333 3.080709
    O22      0.49913019  0.3847042  -0.09816265  1.2193717  0.1333333 1.597053
    O23      1.05525082  0.5271703  -0.10941166  1.8975879  0.1333333 1.697432
    O24      0.27608091  0.5038529  -0.68589203  0.9421645  0.5333333 2.630787
    C1:C2    0.17850997  0.5557019  -0.99626646  1.0958334  0.7333333 2.814434
    O12: C1 -9.37612789 18.2338479 -44.66180786 14.7033784  0.8666667 1.907973
    O12: C2  0.17237327  0.8790974  -1.60873788  1.5123975  0.7333333 3.236331
    O13: C1 -6.05899268 13.0831157 -33.34803508 10.8192682  0.8000000 5.585659
    O13: C2 -0.04311630  0.8348870  -1.59541457  1.1859639  0.8666667 4.765406
    O14: C1 -2.37182145 13.1861748 -28.88388326 16.8763963  1.0000000 3.911064
    O14: C2 -0.32203777  0.8757362  -1.82049375  1.1937039  0.6666667 3.762203
               MCE/SD
    M22     0.3050452
    M23     0.4784831
    M24     0.3426300
    O22     0.2335556
    O23     0.6413095
    O24     0.4689533
    C1:C2   0.3028276
    O12: C1 0.2229126
    O12: C2 0.4080541
    O13: C1 0.3896511
    O13: C2 0.5404759
    O14: C1 0.5061341
    O14: C2 0.1825742
    
    
    $m5c
    $m5c$O1
                      Mean         SD        2.5%      97.5% tail-prob.  GR-crit
    M22         0.05424051  0.5644450  -0.8842416  1.1624406 0.86666667 3.612331
    M23         0.06955619  0.6308314  -1.2160601  0.9989346 0.93333333 5.167159
    M24        -0.19473664  0.4806671  -0.7599600  0.7864523 0.53333333 7.047996
    O22         0.62219882  0.5330272  -0.3396193  1.6984406 0.13333333 1.189820
    O23         1.15294872  0.5165938   0.4010522  1.9973679 0.00000000 3.076128
    O24         0.34770773  0.4409677  -0.4111114  0.9551300 0.66666667 2.445699
    O12: C1    -6.54385482 20.4320509 -41.0023454 26.5633376 0.73333333 1.040644
    O12: C2     2.52837598  1.8257789  -0.1142430  6.1163590 0.06666667 6.436626
    O12: C1:C2 -1.41308578  1.0813895  -3.4602439  0.5341211 0.20000000 2.936059
    O13: C1    -8.52574926 15.0115467 -32.7182716 13.8640706 0.73333333 1.300022
    O13: C2    -1.64956479  1.8884736  -5.2378305  0.7734470 0.46666667 4.367188
    O13: C1:C2  1.26324381  1.0547901  -0.3510673  3.1038119 0.20000000 2.752542
    O14: C1    -3.14100271 12.1781702 -23.0786316 18.4263853 0.93333333 1.070643
    O14: C2     1.73064240  1.6113350  -0.6399237  4.3342892 0.40000000 2.287434
    O14: C1:C2 -0.99273749  1.1935787  -2.7967329  0.8908358 0.53333333 2.758333
                  MCE/SD
    M22        0.4163820
    M23        0.6886633
    M24        0.4895418
    O22        0.2264704
    O23        0.4346880
    O24        0.1825742
    O12: C1    0.1825742
    O12: C2    0.4325525
    O12: C1:C2 0.2627520
    O13: C1    0.2202943
    O13: C2    0.3510633
    O13: C1:C2 0.3693653
    O14: C1    0.1825742
    O14: C2    0.5169217
    O14: C1:C2 0.5395895
    
    
    $m5d
    $m5d$O1
                  Mean         SD        2.5%      97.5% tail-prob.  GR-crit
    M22     -0.2225589  0.6198242  -1.0945471  1.0303739 0.60000000 4.628861
    M23     -0.1962664  0.5321232  -1.1142884  0.6575622 0.66666667 3.889883
    M24     -0.2453886  0.6090175  -1.0269427  0.7500228 0.73333333 2.416156
    O22      0.3466122  0.5901688  -1.0447939  1.1809250 0.40000000 2.258744
    O23      0.9863396  0.4994291   0.2235237  1.8938157 0.06666667 3.274503
    O24      0.1057105  0.5319370  -0.7549601  0.9718110 0.86666667 1.935536
    M22:C2  -0.6822322  1.5499297  -3.8122078  1.8560535 0.66666667 2.167252
    M23:C2   0.6968064  1.2790253  -0.9851441  3.2730289 0.66666667 1.858253
    M24:C2   2.4618644  1.0368109   0.5333909  4.1199462 0.00000000 1.620011
    O12: C1  4.3648912 15.2499008 -30.0876107 28.6508636 0.93333333 2.018123
    O12: C2 -0.3839739  0.8055973  -2.0821120  0.9431188 0.60000000 2.903853
    O13: C1  6.6209051 12.6429249 -21.1462536 23.8962317 0.53333333 4.149147
    O13: C2 -0.9093091  0.7348577  -1.9943177  0.8421235 0.20000000 1.987521
    O14: C1  6.4724487 16.4089266 -27.8998372 33.9947283 0.40000000 3.426843
    O14: C2 -0.9008271  0.7939860  -2.1359113  0.8060832 0.26666667 2.039318
               MCE/SD
    M22     0.4257767
    M23     0.5189994
    M24     0.4044615
    O22     0.1825742
    O23     0.3705128
    O24     0.2019368
    M22:C2  0.2436505
    M23:C2  0.1968770
    M24:C2  0.1825742
    O12: C1 0.1825742
    O12: C2 0.3158441
    O13: C1 0.3351570
    O13: C2 0.3139075
    O14: C1 0.3872259
    O14: C2 0.2926592
    
    
    $m5e
    $m5e$O1
                       Mean         SD        2.5%       97.5% tail-prob.  GR-crit
    O12: C1     -0.89053282 27.4002825 -54.7006164 39.50651777 0.93333333 1.575928
    O12: M22     0.93524327  0.8329103  -0.7638170  2.02109777 0.33333333 6.566330
    O12: M23    -0.38897701  0.9259124  -1.9153762  1.06396585 0.86666667 3.235017
    O12: M24    -0.08673669  0.7524850  -1.5345050  1.06878846 0.93333333 2.848467
    O12: C2     -1.88803987  1.6704194  -4.8639839  0.98339287 0.20000000 2.680531
    O12: O22     0.01978310  0.5721304  -1.3774600  0.75896812 0.73333333 3.292327
    O12: O23     2.28837372  0.7287929   0.8465017  3.41328645 0.00000000 2.382567
    O12: O24    -0.43383269  0.6092039  -1.6268722  0.68154660 0.46666667 1.183222
    O12: M22:C2  4.68383782  2.8686497  -0.9384961 10.78576049 0.13333333 2.090515
    O12: M23:C2 -0.07511061  1.5487604  -2.8549021  3.03653316 0.93333333 3.330900
    O12: M24:C2  9.68099500  3.5412127   5.0846750 16.01433783 0.00000000 5.881504
    O13: C1     -7.07625022 18.3237915 -44.8725759 15.74965649 0.80000000 2.760797
    O13: M22    -0.57248526  0.7474724  -1.7575458  0.41173335 0.73333333 4.783125
    O13: M23     0.18463641  0.5186396  -0.3621631  1.26713276 0.93333333 8.873907
    O13: M24     0.18009524  0.6433330  -0.8955768  1.29812424 1.00000000 5.983724
    O13: C2     -0.02278091  1.0567146  -1.5166846  1.98260187 0.93333333 3.417069
    O13: O22    -0.04336298  0.4443815  -0.7437626  0.65122070 0.86666667 1.982363
    O13: O23     0.47157080  0.3992237  -0.1348628  1.22565103 0.33333333 1.844664
    O13: O24     0.16422589  0.4259409  -0.6601926  0.85591712 0.60000000 3.038345
    O13: M22:C2 -1.20339780  1.4641992  -2.9944686  1.16048042 0.60000000 2.188446
    O13: M23:C2  0.65551900  1.2223420  -1.3533903  2.64352919 0.53333333 1.779604
    O13: M24:C2 -0.23599461  1.8431410  -3.0655838  3.37716705 0.73333333 4.500887
    O14: C1      0.41744304 17.1166412 -26.9242742 25.24761557 1.00000000 2.275969
    O14: M22    -1.09827949  0.7765494  -2.3973258  0.14591663 0.13333333 4.894306
    O14: M23    -0.50420139  0.6251268  -1.5602830  0.45430951 0.46666667 5.049420
    O14: M24    -0.51610807  0.8171595  -1.8475519  0.71107149 0.53333333 3.891257
    O14: C2     -0.93135563  0.7146836  -2.3619998  0.07182334 0.06666667 2.008095
    O14: O22    -0.07657773  0.5694539  -1.1828873  0.85124323 0.86666667 2.767680
    O14: O23     0.78719049  0.6460748  -0.2622139  1.96886014 0.26666667 5.587950
    O14: O24    -0.39963035  0.6582536  -1.7386897  0.62719807 0.46666667 3.633121
    O14: M22:C2 -1.10229779  1.2291391  -3.6075398  0.50578721 0.33333333 1.022182
    O14: M23:C2  0.69731779  1.5520858  -1.9843863  3.40012941 0.73333333 1.137837
    O14: M24:C2  1.21104356  1.9246572  -1.5801014  4.80360905 0.53333333 2.281904
                   MCE/SD
    O12: C1     0.4012161
    O12: M22    0.5181328
    O12: M23    0.4986804
    O12: M24    0.4584553
    O12: C2     0.4069865
    O12: O22           NA
    O12: O23    0.2617709
    O12: O24    0.3290421
    O12: M22:C2 0.2911804
    O12: M23:C2 0.5051449
    O12: M24:C2 0.4495671
    O13: C1     0.3501577
    O13: M22    0.4908238
    O13: M23    0.4938478
    O13: M24    0.5371205
    O13: C2     0.4977600
    O13: O22    0.3071163
    O13: O23    0.2711476
    O13: O24    0.3243645
    O13: M22:C2 0.2778680
    O13: M23:C2 0.3076753
    O13: M24:C2 0.3362988
    O14: C1     0.2118697
    O14: M22    0.9132312
    O14: M23    0.3901435
    O14: M24    0.4689245
    O14: C2     0.2302804
    O14: O22    0.4752620
    O14: O23    0.7533747
    O14: O24    0.3559039
    O14: M22:C2 0.1825742
    O14: M23:C2 0.3042243
    O14: M24:C2 0.4441047
    
    
    $m6a
    $m6a$O1
                   Mean         SD        2.5%      97.5% tail-prob.  GR-crit
    M22     -0.21331741  0.5266943  -0.9715709  0.6748338  0.7333333 3.474679
    M23     -0.26909883  0.4377396  -0.9934332  0.4944521  0.4666667 3.692063
    M24      0.06624172  0.6629838  -0.9573644  1.0545218  1.0000000 3.949677
    O22     -0.49150180  0.4422473  -1.1301218  0.4322934  0.2666667 1.169333
    O23     -1.24064009  0.3686041  -1.8028102 -0.4368739  0.0000000 1.076554
    O24     -0.35915977  0.4078524  -1.0775072  0.3208662  0.4000000 1.510574
    O12: C1  4.71665972 22.7245538 -36.0038777 38.3291410  0.9333333 1.327232
    O12: C2 -0.55992279  0.8184043  -1.7883878  0.6345031  0.5333333 3.101509
    O13: C1 -1.51244529 19.5939113 -34.5791865 39.5003234  0.7333333 1.488549
    O13: C2 -0.50279370  0.7599811  -1.6795289  0.7025505  0.6666667 2.910542
    O14: C1 -1.81031992 19.1011949 -33.5160161 31.8771466  0.8000000 1.183982
    O14: C2 -0.14219155  0.9555300  -2.0290101  1.4295284  0.8666667 2.955281
               MCE/SD
    M22     0.5105045
    M23     0.4544375
    M24     0.1825742
    O22     0.1825742
    O23     0.1825742
    O24     0.3364756
    O12: C1 0.2166551
    O12: C2 0.3437726
    O13: C1 0.4692744
    O13: C2 0.3325540
    O14: C1 0.2896256
    O14: C2 0.1825742
    
    
    $m6b
    $m6b$O1
                   Mean         SD        2.5%      97.5% tail-prob.  GR-crit
    M22      0.01018292  0.5436557  -1.2464137  0.9719781  0.8666667 1.824645
    M23     -0.11675017  0.5124069  -0.8458509  0.8751863  0.8000000 2.579880
    M24      0.19792773  0.5253063  -0.4579931  1.3183931  0.8000000 2.295999
    O22     -0.49955970  0.3859478  -1.1694969  0.2444874  0.2000000 1.423751
    O23     -0.99797093  0.3673316  -1.7042475 -0.4193296  0.0000000 1.839896
    O24     -0.34879687  0.3709788  -0.8847879  0.3703065  0.4000000 1.726869
    C1:C2    0.04206054  0.8671995  -1.0765699  1.6617207  0.8000000 6.275963
    O12: C1 12.81328454 15.7684002 -19.8086027 37.6323447  0.4000000 1.123552
    O12: C2 -0.53031040  0.9768958  -1.8459221  1.2645361  0.6000000 3.963656
    O13: C1  8.80710418 11.4794545  -7.3373944 33.2529915  0.4666667 1.578922
    O13: C2 -0.13475382  1.0578218  -1.9931769  1.4381869  0.9333333 5.351747
    O14: C1  1.03261482 18.0160814 -26.2984639 31.1290199  1.0000000 1.240494
    O14: C2 -0.12653918  1.1847415  -2.9419717  1.3311922  0.9333333 4.954950
               MCE/SD
    M22     0.2892538
    M23     0.3247419
    M24     0.3240491
    O22     0.2089533
    O23     0.2143903
    O24     0.3606873
    C1:C2   0.4385064
    O12: C1 0.2394822
    O12: C2 0.6614106
    O13: C1 0.3623340
    O13: C2 0.3685820
    O14: C1 0.2323912
    O14: C2 0.5023818
    
    
    $m6c
    $m6c$O1
                     Mean         SD        2.5%       97.5% tail-prob.   GR-crit
    M22         0.1777782  0.8463509  -1.3389282  1.36028204 0.86666667  6.021652
    M23         0.1407952  0.7638778  -1.3105934  1.38189953 0.66666667  5.915740
    M24         0.5200074  0.7817605  -0.7664274  1.65026110 0.60000000  4.890656
    O22        -0.4033920  0.6278465  -1.6661984  0.62301421 0.46666667  2.620510
    O23        -0.9565074  0.6320413  -2.0752311 -0.04717327 0.06666667  4.441761
    O24        -0.1524471  0.6141796  -1.2146871  0.95230254 0.73333333  4.159614
    O12: C1     3.4873722 15.7807147 -26.1731864 30.38961221 0.80000000  1.308800
    O12: C2    -0.5782418  2.6154722  -4.7197740  3.55218634 0.93333333  8.908413
    O12: C1:C2 -0.0388832  1.4782618  -2.5804811  2.24537807 0.93333333  6.230724
    O13: C1     0.3831081 12.4023218 -18.7870240 22.98418579 0.93333333  2.363860
    O13: C2     0.8348609  2.0813799  -1.6586285  4.29486193 0.73333333 14.391879
    O13: C1:C2 -0.8553797  1.2339888  -3.1463307  0.58849108 0.80000000  8.902342
    O14: C1    -1.6459791 16.3357027 -30.2414059 26.79248757 0.86666667  1.807200
    O14: C2     0.1060443  1.9203943  -3.8067166  2.65628139 0.60000000  5.258054
    O14: C1:C2 -0.2289640  1.1459090  -1.8895807  1.96804823 0.80000000  2.737193
                  MCE/SD
    M22        0.6476874
    M23        0.4555750
    M24        0.4592913
    O22        0.3240535
    O23        0.5500385
    O24        0.5198576
    O12: C1    0.1825742
    O12: C2    0.4372870
    O12: C1:C2 0.4622697
    O13: C1    0.3528094
    O13: C2    0.6717254
    O13: C1:C2 0.4493942
    O14: C1    0.1825742
    O14: C2    0.5303510
    O14: C1:C2 0.1698577
    
    
    $m6d
    $m6d$O1
                  Mean         SD        2.5%       97.5% tail-prob.  GR-crit
    M22      0.8060387  0.5299455  -0.3293465  1.50594479 0.20000000 1.003290
    M23      0.6547915  0.4348473  -0.2164511  1.26103596 0.13333333 1.318189
    M24      0.7158050  0.5472001  -0.6354904  1.44205713 0.20000000 1.176976
    O22     -0.8845412  0.6833382  -1.9200135  0.41093978 0.26666667 2.703444
    O23     -1.1081855  0.7513248  -2.2188171  0.05888811 0.13333333 6.009725
    O24     -0.4912597  0.7148381  -1.8074345  0.65443332 0.60000000 4.041227
    M22:C2   3.2641158  1.2343084   1.3599370  5.29622647 0.00000000 2.387051
    M23:C2   1.8344299  1.0716931   0.1873079  3.67365823 0.00000000 1.319142
    M24:C2   0.4727376  1.3295859  -1.7681228  2.57609317 0.73333333 1.214392
    O12: C1 -2.6354165 17.2080249 -29.7255412 27.48709989 0.93333333 3.309897
    O12: C2 -1.9720746  0.7600227  -3.3891266 -0.85005749 0.00000000 2.846036
    O13: C1 -3.7558873 19.4809852 -30.3221156 31.67535863 0.73333333 4.081818
    O13: C2 -1.3592425  0.7624537  -2.8535995  0.08268697 0.06666667 2.090289
    O14: C1 -6.2222239 23.1326522 -44.8195125 25.99759631 0.93333333 3.269894
    O14: C2 -1.3350334  0.8601178  -2.7521935  0.42855919 0.20000000 2.373774
               MCE/SD
    M22     0.3594170
    M23     0.2297620
    M24     0.3146788
    O22     0.3237873
    O23     0.7701390
    O24     0.4587163
    M22:C2  0.3254831
    M23:C2  0.1825742
    M24:C2  0.1825742
    O12: C1 0.4243124
    O12: C2 0.3399113
    O13: C1 0.4816257
    O13: C2 0.4020598
    O14: C1 0.3150019
    O14: C2 0.3322043
    
    
    $m6e
    $m6e$O1
                        Mean         SD        2.5%      97.5% tail-prob.   GR-crit
    O12: C1       4.34292460  9.7939284 -14.1847475 18.6777332 0.53333333  2.066695
    O12: M22     -1.09785488  0.4635390  -1.7519627 -0.3105292 0.00000000  2.870564
    O12: M23      0.07876292  0.5592785  -0.9778866  1.2769448 0.80000000  1.932021
    O12: M24      0.34764892  0.6052227  -0.4636535  1.4828985 0.66666667  2.270262
    O12: C2      -0.25614897  0.7347799  -1.4639684  0.9533311 0.73333333  2.791884
    O12: O22     -1.00966031  0.5968316  -2.0297084 -0.1584130 0.06666667  4.791250
    O12: O23     -2.11710202  0.9376070  -4.5293005 -0.8325172 0.00000000  4.169262
    O12: O24      0.06780683  0.5347890  -1.1641938  1.0094442 0.66666667  2.813334
    O12: M22:C2  -1.05141685  1.4964493  -3.4747744  1.8171689 0.46666667  1.328922
    O12: M23:C2   1.51660764  1.3533471  -1.0654095  3.7630348 0.26666667  1.832710
    O12: M24:C2  -5.60957296  2.0864701  -9.1811512 -2.2025756 0.00000000  5.068159
    O13: C1      -3.19563162  8.8202426 -18.2909828 13.7350247 0.66666667  1.877927
    O13: M22      0.10953947  0.5805803  -0.5780602  1.4733524 0.86666667  4.150296
    O13: M23     -0.90818134  0.7913496  -2.2785518  0.2378887 0.20000000  3.317788
    O13: M24      0.23478866  0.8162914  -0.9590352  1.8436504 0.93333333  6.693718
    O13: C2       0.19608628  1.4696007  -2.0106043  1.7522331 0.73333333  8.004615
    O13: O22     -0.28383577  0.5134716  -1.0826605  0.5673788 0.66666667  4.240458
    O13: O23     -0.04639591  0.9525516  -2.3049826  1.1739572 0.73333333 10.403423
    O13: O24     -0.30826006  0.6156820  -1.5146371  0.6236888 0.66666667  5.170637
    O13: M22:C2   0.43976314  2.0052767  -3.3071453  2.9301154 0.80000000  4.879028
    O13: M23:C2  -3.22542036  3.5806813  -9.0682909  1.7974967 0.60000000  8.411901
    O13: M24:C2   0.75853094  1.8019364  -1.6887559  4.1709662 0.86666667  6.649726
    O14: C1     -16.87086515 12.3937419 -37.0282832  9.3165845 0.26666667  1.131366
    O14: M22      0.72285193  0.8487073  -0.3521028  2.3906510 0.33333333  5.150954
    O14: M23      0.05183738  0.8355582  -1.6715801  1.3271733 1.00000000  2.655979
    O14: M24      0.86320077  0.9241010  -0.3772752  2.8769681 0.20000000  5.835775
    O14: C2       0.34293462  1.5943440  -2.2323529  2.7923077 0.66666667  6.403624
    O14: O22     -0.14930124  0.5445058  -1.2841450  0.6222311 0.86666667  2.723258
    O14: O23     -0.30051350  0.8464810  -2.2325529  1.0226427 0.86666667  3.260366
    O14: O24      0.53320381  0.6855650  -0.9757936  1.5192044 0.40000000  1.476124
    O14: M22:C2   1.18503702  1.9986895  -1.5217353  4.5076550 0.66666667  4.590325
    O14: M23:C2  -1.27552284  2.5321678  -6.2209340  2.4282491 0.53333333  6.959292
    O14: M24:C2   0.17610950  2.0288622  -3.4998382  3.7199670 0.93333333  5.813792
                   MCE/SD
    O12: C1     0.1825742
    O12: M22    0.2985319
    O12: M23    0.2242930
    O12: M24           NA
    O12: C2     0.3058641
    O12: O22    0.3452055
    O12: O23    0.3224034
    O12: O24    0.3338425
    O12: M22:C2        NA
    O12: M23:C2 0.1825742
    O12: M24:C2 0.6265249
    O13: C1     0.2251229
    O13: M22    0.3214723
    O13: M23    0.5096101
    O13: M24    0.5975914
    O13: C2     0.8342024
    O13: O22    0.4932643
    O13: O23    0.4451020
    O13: O24    0.4343549
    O13: M22:C2 0.4690416
    O13: M23:C2 0.3994199
    O13: M24:C2 0.6223195
    O14: C1     0.3346742
    O14: M22    0.5177305
    O14: M23    0.4724269
    O14: M24    0.4340780
    O14: C2     0.7919140
    O14: O22    0.3422024
    O14: O23    0.3375233
    O14: O24    0.3757066
    O14: M22:C2 0.7366405
    O14: M23:C2 0.5441981
    O14: M24:C2 0.4039813
    
    

