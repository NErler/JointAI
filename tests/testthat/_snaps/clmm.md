# GRcrit and MCerror give same result

    $m0a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o1[1]        2.91       5.30
    gamma_o1[2]        1.07       1.37
    D_o1_id[1,1]       2.09       4.41
    
    
    $m0b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o2[1]        1.50       2.61
    gamma_o2[2]        1.36       2.16
    gamma_o2[3]        2.03       3.47
    D_o2_id[1,1]       1.31       2.92
    
    
    $m1a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o1[1]        1.18       1.66
    gamma_o1[2]        1.20       1.69
    C1                 1.18       1.77
    D_o1_id[1,1]       1.16       1.62
    
    
    $m1b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o2[1]        2.30       4.13
    gamma_o2[2]        2.14       4.27
    gamma_o2[3]        1.72       3.26
    C1                 1.14       1.60
    D_o2_id[1,1]       1.55       3.77
    
    
    $m1c
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o1[1]        1.50       2.37
    gamma_o1[2]        1.04       1.29
    c1                 1.23       1.95
    D_o1_id[1,1]       1.49       3.42
    
    
    $m1d
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o2[1]        2.53       4.88
    gamma_o2[2]        1.93       3.60
    gamma_o2[3]        1.70       3.35
    c1                 1.07       1.35
    D_o2_id[1,1]       1.17       1.60
    
    
    $m2a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o1[1]        2.73       5.38
    gamma_o1[2]        3.31       6.38
    C2                 1.90       3.21
    D_o1_id[1,1]       2.75       5.10
    
    
    $m2b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o2[1]        1.11       1.50
    gamma_o2[2]        1.12       1.62
    gamma_o2[3]        1.44       2.23
    C2                 1.66       2.78
    D_o2_id[1,1]       2.16       7.93
    
    
    $m2c
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o1[1]        1.22       2.09
    gamma_o1[2]        1.25       1.77
    c2                 1.14       1.54
    D_o1_id[1,1]       1.88       3.37
    
    
    $m2d
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o2[1]        2.73       5.31
    gamma_o2[2]        1.34       2.14
    gamma_o2[3]        1.58       2.62
    c2                 1.45       2.27
    D_o2_id[1,1]       1.54       2.79
    
    
    $m3a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    (Intercept)       2.737       5.10
    o1.L              1.133       1.58
    o1.Q              0.996       1.19
    sigma_c1          0.980       1.10
    D_c1_id[1,1]      1.049       1.38
    
    
    $m3b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    (Intercept)        3.12       7.26
    o22                2.10       3.81
    o23                2.65       6.78
    o24                3.30       6.14
    sigma_c1           1.27       1.90
    D_c1_id[1,1]       1.77       3.06
    
    
    $m4a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M22                    1.53       3.52
    M23                    1.61       2.62
    M24                    1.55       2.75
    abs(C1 - C2)           1.60       3.07
    log(C1)                1.05       1.30
    o22                    2.37       4.27
    o23                    4.87       9.53
    o24                    2.82       5.50
    o22:abs(C1 - C2)       3.03       7.02
    o23:abs(C1 - C2)       4.40       8.32
    o24:abs(C1 - C2)       1.99       4.22
    gamma_o1[1]            1.19       1.73
    gamma_o1[2]            1.45       2.68
    D_o1_id[1,1]           1.18       2.02
    
    
    $m4b
    Potential scale reduction factors:
    
                                                               Point est.
    abs(C1 - C2)                                                     1.09
    log(C1)                                                          1.22
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)                    1.95
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)       2.98
    gamma_o1[1]                                                      1.20
    gamma_o1[2]                                                      1.63
    D_o1_id[1,1]                                                     1.55
                                                               Upper C.I.
    abs(C1 - C2)                                                     1.33
    log(C1)                                                          1.74
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)                    4.35
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)       5.63
    gamma_o1[1]                                                      1.68
    gamma_o1[2]                                                      2.81
    D_o1_id[1,1]                                                     4.46
    
    
    $m4c
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    C1                 2.02       3.63
    B21                3.96       7.83
    time               1.36       2.09
    c1                 1.12       1.48
    gamma_o1[1]        1.99       4.09
    gamma_o1[2]        1.38       2.66
    D_o1_id[1,1]       3.52       6.51
    D_o1_id[1,2]       1.30       1.95
    D_o1_id[2,2]       3.61       7.66
    D_o1_id[1,3]       1.61       3.12
    D_o1_id[2,3]       2.37       4.26
    D_o1_id[3,3]       2.20       3.92
    D_o1_id[1,4]       3.82       7.75
    D_o1_id[2,4]       2.41       5.34
    D_o1_id[3,4]       2.66       5.02
    D_o1_id[4,4]       6.69      14.80
    
    
    $m4d
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    C1                 1.08       1.41
    time               3.74       7.40
    I(time^2)          2.23       4.19
    b21                1.43       2.38
    c1                 2.09       3.62
    C1:time            3.37       7.50
    b21:c1             3.70       7.80
    gamma_o1[1]        1.25       1.88
    gamma_o1[2]        1.62       2.60
    D_o1_id[1,1]       2.05       3.65
    D_o1_id[1,2]       1.15       1.73
    D_o1_id[2,2]       2.22       4.83
    
    
    $m4e
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    C1                 1.22       2.01
    log(time)          1.21       1.81
    I(time^2)          1.33       2.17
    p1                 1.00       1.04
    gamma_o1[1]        2.06       4.09
    gamma_o1[2]        1.03       1.24
    D_o1_id[1,1]       2.06       3.96
    
    
    $m5a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    O22                1.86       3.36
    O23                2.68       5.16
    o12: C1            1.98       3.49
    o12: C2            1.75       3.22
    o13: C1            1.39       2.18
    o13: C2            1.50       2.80
    o12: b21           1.29       1.89
    o13: b21           1.19       1.85
    gamma_o1[1]        4.24       8.31
    gamma_o1[2]        3.14       7.34
    D_o1_id[1,1]       1.14       1.63
    
    
    $m5b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    M22               1.303       2.31
    M23               1.883       3.28
    M24               1.835       3.60
    O22               1.229       1.92
    O23               0.983       1.11
    o13: C2           1.013       1.14
    c1:C2             1.867       3.38
    o12: C2           1.679       3.01
    o12: c1           2.227       4.26
    o13: c1           3.367       6.99
    gamma_o1[1]       2.829       7.64
    gamma_o1[2]       3.487       7.45
    D_o1_id[1,1]      1.731       7.30
    
    
    $m5c
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    M22                1.71       2.84
    M23                2.43       4.35
    M24                2.20       4.15
    O22                4.06       7.95
    O23                3.66       8.60
    o12: C2            3.00       6.43
    o13: C2            5.61      12.20
    o12: c1            3.06       6.23
    o12: c1:C2         6.19      12.59
    o13: c1            2.92       6.51
    o13: c1:C2         5.54      17.58
    gamma_o1[1]        8.23      17.13
    gamma_o1[2]        6.63      12.71
    D_o1_id[1,1]       1.74       3.42
    
    
    $m5d
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    M22                4.88       9.23
    M23                2.98       6.27
    M24                1.31       2.61
    O22                1.29       1.94
    O23                1.44       2.44
    M22:C2             1.73       3.07
    M23:C2             1.10       1.45
    M24:C2             1.24       1.82
    o12: C2            3.51       9.15
    o13: C2            5.98      15.19
    o12: c1            1.29       2.00
    o13: c1            1.35       2.12
    gamma_o1[1]        6.16      13.60
    gamma_o1[2]        5.44      10.90
    D_o1_id[1,1]       2.50       4.73
    
    
    $m5e
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    o12: M22          1.186       2.18
    o12: M23          1.935       5.78
    o12: M24          4.205       9.40
    o12: C2           2.217       4.04
    o12: O22          1.461       2.53
    o12: O23          0.995       1.08
    o12: M22:C2       3.549       8.16
    o12: M23:C2       1.931       3.69
    o12: M24:C2       3.299       6.55
    o13: M22          3.433       8.04
    o13: M23          3.130       6.82
    o13: M24          3.127       6.76
    o13: C2           1.255       2.82
    o13: O22          1.307       2.06
    o13: O23          1.798       3.03
    o13: M22:C2       1.062       1.31
    o13: M23:C2       2.520       4.85
    o13: M24:C2       1.695       3.39
    o12: c1           1.459       2.25
    o13: c1           1.383       2.30
    gamma_o1[1]       1.601       2.78
    gamma_o1[2]       2.684       5.48
    D_o1_id[1,1]      1.120       1.49
    
    
    $m6a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    O22                3.48       6.43
    O23                1.34       2.18
    o12: C1            1.29       2.10
    o12: C2            2.96       5.81
    o13: C1            1.29       1.90
    o13: C2            2.62       7.85
    o12: b21           2.49       4.96
    o13: b21           2.68       6.06
    gamma_o1[1]        1.52       2.49
    gamma_o1[2]        1.11       1.54
    D_o1_id[1,1]       1.16       1.70
    
    
    $m6b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    M22                2.26       4.26
    M23                1.53       2.85
    M24                1.52       2.49
    O22                1.26       1.95
    O23                1.42       2.16
    o13: C2            3.10       6.47
    c1:C2              5.03       9.76
    o12: C2            1.70       3.06
    o12: c1            1.86       3.41
    o13: c1            1.65       2.88
    gamma_o1[1]        2.20       4.30
    gamma_o1[2]        1.53       3.28
    D_o1_id[1,1]       1.43       3.89
    
    
    $m6c
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    M22                1.58       2.76
    M23                2.02       3.45
    M24                1.19       1.67
    O22                1.47       2.28
    O23                1.13       1.56
    o12: C2            2.11       3.73
    o13: C2            1.41       2.27
    o12: c1            1.16       1.61
    o12: c1:C2         1.37       2.50
    o13: c1            2.19       6.07
    o13: c1:C2         2.98       9.98
    gamma_o1[1]        1.92       3.43
    gamma_o1[2]        1.78       3.63
    D_o1_id[1,1]       3.26       7.58
    
    
    $m6d
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    M22                1.82       3.36
    M23                2.57       4.83
    M24                1.60       2.82
    O22                1.19       1.67
    O23                1.14       1.53
    M22:C2             2.82       6.03
    M23:C2             1.69       4.15
    M24:C2             2.67       5.65
    o12: C2            3.22       6.93
    o13: C2            4.47       8.81
    o12: c1            1.30       1.90
    o13: c1            1.51       2.38
    gamma_o1[1]        6.03      12.59
    gamma_o1[2]        4.69      10.23
    D_o1_id[1,1]       1.53       3.66
    
    
    $m6e
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    o12: M22           6.49      13.55
    o12: M23           1.49       2.34
    o12: M24           3.65      11.40
    o12: C2            6.68      13.77
    o12: O22           2.33       5.80
    o12: O23           3.35       7.44
    o12: M22:C2        6.82      17.34
    o12: M23:C2        5.73      10.95
    o12: M24:C2        4.16       7.79
    o13: M22           4.89      14.95
    o13: M23           1.72       3.28
    o13: M24           4.88      10.73
    o13: C2            4.43       9.04
    o13: O22           1.13       1.52
    o13: O23           2.62       5.28
    o13: M22:C2        1.32       3.40
    o13: M23:C2        5.57      11.60
    o13: M24:C2        2.77       7.49
    o12: c1            1.63       3.07
    o13: c1            1.71       3.05
    gamma_o1[1]        6.51      13.24
    gamma_o1[2]        4.03       9.86
    D_o1_id[1,1]       1.87       3.19
    
    
    $m7a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    (Intercept)      1.009       1.09
    C1               1.014       1.12
    o1.L             1.219       1.81
    o1.Q             1.681       3.47
    o22              0.972       1.07
    o23              1.166       1.64
    o24              2.115       3.79
    x2               3.212       6.63
    x3               3.751      11.27
    x4               4.390       8.85
    time             1.088       1.43
    sigma_y          1.062       1.32
    D_y_id[1,1]      1.131       1.59
    
    
    $m7b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    (Intercept)      1.053      1.295
    o22              2.140      3.727
    o23              1.033      1.227
    o24              1.468      2.271
    o1.L             1.041      1.269
    o1.Q             1.014      1.196
    c2               1.174      1.607
    b21              1.772      3.089
    sigma_y          0.975      0.989
    D_y_id[1,1]      1.108      1.465
    
    

---

    $m0a
                   est  MCSE   SD MCSE/SD
    gamma_o1[1]   0.72 0.142 0.23    0.62
    gamma_o1[2]  -1.28 0.052 0.23    0.23
    D_o1_id[1,1]  1.46 0.233 0.50    0.46
    
    $m0b
                   est  MCSE   SD MCSE/SD
    gamma_o2[1]   1.32 0.050 0.18    0.28
    gamma_o2[2]   0.21 0.035 0.18    0.20
    gamma_o2[3]  -1.13 0.042 0.20    0.21
    D_o2_id[1,1]  1.43 0.211 0.77    0.27
    
    $m1a
                    est  MCSE    SD MCSE/SD
    gamma_o1[1]    0.74 0.075  0.22    0.34
    gamma_o1[2]   -1.22 0.048  0.22    0.22
    C1           -15.95 5.100 15.20    0.34
    D_o1_id[1,1]   1.68 0.370  0.87    0.43
    
    $m1b
                   est  MCSE    SD MCSE/SD
    gamma_o2[1]   1.40 0.172  0.33    0.53
    gamma_o2[2]   0.25 0.168  0.34    0.50
    gamma_o2[3]  -1.23 0.077  0.38    0.21
    C1           -5.60 3.114 14.50    0.21
    D_o2_id[1,1]  2.58 0.710  1.58    0.45
    
    $m1c
                    est  MCSE   SD MCSE/SD
    gamma_o1[1]   0.676 0.035 0.16    0.21
    gamma_o1[2]  -1.228 0.032 0.18    0.18
    c1            0.027 0.047 0.19    0.24
    D_o1_id[1,1]  1.152 0.187 0.45    0.42
    
    $m1d
                   est  MCSE   SD MCSE/SD
    gamma_o2[1]   1.21 0.120 0.26    0.46
    gamma_o2[2]   0.14 0.080 0.25    0.32
    gamma_o2[3]  -1.14 0.057 0.23    0.25
    c1           -0.22 0.033 0.18    0.18
    D_o2_id[1,1]  1.18 0.158 0.54    0.29
    
    $m2a
                   est  MCSE   SD MCSE/SD
    gamma_o1[1]   0.93 0.096 0.26    0.37
    gamma_o1[2]  -1.15 0.162 0.31    0.52
    C2           -0.25 0.097 0.33    0.29
    D_o1_id[1,1]  2.14 0.346 1.05    0.33
    
    $m2b
                   est  MCSE   SD MCSE/SD
    gamma_o2[1]   1.32 0.088 0.22    0.40
    gamma_o2[2]   0.14 0.093 0.23    0.40
    gamma_o2[3]  -1.29 0.174 0.38    0.46
    C2            0.25 0.088 0.28    0.32
    D_o2_id[1,1]  2.70 1.634 2.83    0.58
    
    $m2c
                   est  MCSE   SD MCSE/SD
    gamma_o1[1]   0.76 0.088 0.21    0.43
    gamma_o1[2]  -1.16 0.068 0.18    0.39
    c2           -1.15 0.235 1.29    0.18
    D_o1_id[1,1]  1.42 0.115 0.33    0.34
    
    $m2d
                   est  MCSE   SD MCSE/SD
    gamma_o2[1]   1.24 0.090 0.20    0.44
    gamma_o2[2]   0.16 0.039 0.17    0.23
    gamma_o2[3]  -1.22 0.043 0.20    0.22
    c2            1.35 0.776 1.59    0.49
    D_o2_id[1,1]  1.34 0.127 0.43    0.30
    
    $m3a
                     est    MCSE      SD MCSE/SD
    (Intercept)   -0.498   5.441 3.0e+01    0.18
    o1.L           0.016   0.017 7.9e-02    0.22
    o1.Q           0.101   0.015 8.2e-02    0.18
    sigma_c1       0.649   0.011 5.8e-02    0.18
    D_c1_id[1,1] 912.463 653.977 3.6e+03    0.18
    
    $m3b
                    est   MCSE    SD MCSE/SD
    (Intercept)   0.279 0.0636 0.111    0.57
    o22           0.013 0.0536 0.136    0.39
    o23          -0.093 0.1009 0.164    0.61
    o24          -0.059 0.0816 0.147    0.56
    sigma_c1      0.612 0.0095 0.029    0.33
    D_c1_id[1,1]  0.088 0.0123 0.027    0.45
    
    $m4a
                         est  MCSE    SD MCSE/SD
    M22              -0.0053 0.220  0.64    0.34
    M23               1.3081 0.156  0.46    0.34
    M24              -0.1488 0.215  0.66    0.33
    abs(C1 - C2)      0.4870 0.106  0.45    0.23
    log(C1)          -9.5446 2.195 13.91    0.16
    o22               1.6455 0.129  0.41    0.32
    o23              -0.9969 0.255  0.77    0.33
    o24              -0.2099 0.114  0.37    0.31
    o22:abs(C1 - C2) -0.8234 0.266  0.41    0.64
    o23:abs(C1 - C2) -0.0979 0.161  0.58    0.28
    o24:abs(C1 - C2)  0.5167 0.127  0.31    0.41
    gamma_o1[1]           NA    NA  0.17      NA
    gamma_o1[2]      -1.8004 0.069  0.23    0.30
    D_o1_id[1,1]      3.3763 0.470  2.57    0.18
    
    $m4b
                                                                  est  MCSE    SD
    abs(C1 - C2)                                                0.385 0.084  0.35
    log(C1)                                                    -4.295 1.904 10.43
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)              -0.044 0.242  0.52
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.199 0.238  0.35
    gamma_o1[1]                                                    NA    NA  0.18
    gamma_o1[2]                                                -1.347 0.059  0.20
    D_o1_id[1,1]                                                2.604 0.724  1.41
                                                               MCSE/SD
    abs(C1 - C2)                                                  0.24
    log(C1)                                                       0.18
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)                 0.47
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)    0.68
    gamma_o1[1]                                                     NA
    gamma_o1[2]                                                   0.29
    D_o1_id[1,1]                                                  0.51
    
    $m4c
                     est   MCSE    SD MCSE/SD
    C1           -1.5388 0.7169 3.926    0.18
    B21          -0.0040 0.0565 0.120    0.47
    time          0.0057 0.0053 0.029    0.18
    c1           -0.0275 0.0210 0.094    0.22
    gamma_o1[1]   0.7149 0.0646 0.150    0.43
    gamma_o1[2]  -1.0365 0.0252 0.132    0.19
    D_o1_id[1,1]  0.2170 0.0372 0.075    0.50
    D_o1_id[1,2] -0.0129 0.0102 0.030    0.34
    D_o1_id[2,2]  0.2921 0.0503 0.101    0.50
    D_o1_id[1,3]  0.0158 0.0160 0.039    0.41
    D_o1_id[2,3]  0.0388 0.0264 0.052    0.51
    D_o1_id[3,3]  0.1910 0.0111 0.061    0.18
    D_o1_id[1,4] -0.0108 0.0205 0.052    0.40
    D_o1_id[2,4]  0.0033 0.0152 0.037    0.41
    D_o1_id[3,4]  0.0227 0.0181 0.048    0.38
    D_o1_id[4,4]  0.2085 0.0446 0.097    0.46
    
    $m4d
                    est   MCSE    SD MCSE/SD
    C1           -1.624 1.0903 5.260    0.21
    time          0.141 0.1154 0.211    0.55
    I(time^2)    -0.024 0.0044 0.021    0.21
    b21           0.759 0.1046 0.341    0.31
    c1           -0.099 0.1128 0.220    0.51
    C1:time      -0.052 0.0700 0.144    0.49
    b21:c1        0.179 0.4377 0.822    0.53
    gamma_o1[1]   0.654 0.0955 0.213    0.45
    gamma_o1[2]  -1.198 0.0473 0.210    0.22
    D_o1_id[1,1]  0.547 0.0716 0.159    0.45
    D_o1_id[1,2]  0.035 0.0099 0.054    0.18
    D_o1_id[2,2]  0.386 0.0369 0.082    0.45
    
    $m4e
                      est   MCSE     SD MCSE/SD
    C1           -13.1317 2.9497 11.623   0.254
    log(time)     -0.1894 0.0270  0.119   0.227
    I(time^2)     -0.0057 0.0040  0.018   0.218
    p1            -0.0473 0.0031  0.046   0.066
    gamma_o1[1]    0.7616 0.0822  0.230   0.358
    gamma_o1[2]   -1.2359 0.0380  0.208   0.183
    D_o1_id[1,1]   1.6122 0.2320  0.673   0.345
    
    $m5a
                   est  MCSE    SD MCSE/SD
    O22           0.18 0.175  0.43    0.41
    O23           0.43 0.119  0.40    0.30
    o12: C1      -7.53 4.366 12.23    0.36
    o12: C2      -0.13 0.080  0.30    0.27
    o13: C1      -7.74 3.885 10.26    0.38
    o13: C2      -0.46 0.085  0.28    0.31
    o12: b21      0.92 0.188  0.57    0.33
    o13: b21      0.80 0.094  0.38    0.25
    gamma_o1[1]   0.50 0.229  0.32    0.71
    gamma_o1[2]  -1.71 0.193  0.28    0.69
    D_o1_id[1,1]  2.68 0.382  1.33    0.29
    
    $m5b
                   est  MCSE   SD MCSE/SD
    M22           0.55 0.215 0.93    0.23
    M23           1.48 0.164 0.90    0.18
    M24          -0.31 0.137 0.58    0.24
    O22          -0.16 0.144 0.79    0.18
    O23           0.33 0.158 0.83    0.19
    o13: C2       0.17 0.063 0.28    0.22
    c1:C2        -0.21 0.137 0.33    0.42
    o12: C2       0.70 0.163 0.36    0.45
    o12: c1       0.36 0.155 0.30    0.51
    o13: c1       0.85 0.198 0.31    0.64
    gamma_o1[1]   0.45 0.174 0.35    0.49
    gamma_o1[2]  -1.84 0.275 0.48    0.57
    D_o1_id[1,1]  3.62 1.032 2.67    0.39
    
    $m5c
                    est MCSE   SD MCSE/SD
    M22          -0.030 0.24 0.78    0.31
    M23           0.603 0.24 0.80    0.30
    M24          -0.074 0.18 0.80    0.23
    O22           0.036 0.68 1.06    0.64
    O23           0.258 0.39 0.90    0.43
    o12: C2       0.173 0.26 0.46    0.56
    o13: C2      -0.405 0.16 0.46    0.34
    o12: c1       0.055 0.18 0.43    0.41
    o12: c1:C2    0.304 0.26 0.59    0.43
    o13: c1       0.632 0.41 0.56    0.74
    o13: c1:C2    0.447 0.37 0.66    0.57
    gamma_o1[1]   0.745 0.43 0.64    0.66
    gamma_o1[2]  -1.632 0.47 0.73    0.64
    D_o1_id[1,1]  3.658 0.75 2.59    0.29
    
    $m5d
                    est  MCSE   SD MCSE/SD
    M22          -1.555 1.885 2.04    0.92
    M23           2.287 0.553 1.64    0.34
    M24          -0.196 0.151 0.83    0.18
    O22           0.173 0.142 0.78    0.18
    O23          -0.259 0.180 0.99    0.18
    M22:C2       -1.245 0.524 1.31    0.40
    M23:C2        0.910 0.147 0.80    0.18
    M24:C2        0.736 0.304 0.79    0.38
    o12: C2      -0.087 0.291 0.46    0.63
    o13: C2      -0.549 0.266 0.43    0.62
    o12: c1      -0.100 0.057 0.19    0.30
    o13: c1       0.402 0.065 0.25    0.26
    gamma_o1[1]   0.916 0.278 0.55    0.50
    gamma_o1[2]  -1.435 0.356 0.66    0.54
    D_o1_id[1,1]  4.616 0.669 2.69    0.25
    
    $m5e
                    est  MCSE   SD MCSE/SD
    o12: M22     -0.106 0.175 0.43    0.41
    o12: M23      0.938 0.303 0.60    0.50
    o12: M24      0.286 0.479 0.56    0.85
    o12: C2      -0.376 0.170 0.47    0.36
    o12: O22      0.039 0.127 0.37    0.34
    o12: O23      0.372 0.109 0.36    0.30
    o12: M22:C2  -0.134 0.265 0.70    0.38
    o12: M23:C2   0.531 0.238 0.45    0.53
    o12: M24:C2   1.026 0.247 0.47    0.52
    o13: M22     -1.850 0.242 0.51    0.48
    o13: M23     -0.167 0.251 0.52    0.49
    o13: M24     -0.375 0.885 0.82    1.09
    o13: C2       0.609 0.121 0.39    0.31
    o13: O22     -0.650 0.075 0.28    0.27
    o13: O23      0.035 0.134 0.32    0.42
    o13: M22:C2  -1.861 0.255 0.55    0.46
    o13: M23:C2  -1.227 0.259 0.53    0.49
    o13: M24:C2  -0.122 0.209 0.63    0.33
    o12: c1      -0.193 0.044 0.21    0.21
    o13: c1       0.129 0.043 0.20    0.22
    gamma_o1[1]   0.349 0.138 0.23    0.61
    gamma_o1[2]  -0.177 0.570 0.54    1.05
    D_o1_id[1,1]  1.322 0.097 0.32    0.30
    
    $m6a
                    est  MCSE    SD MCSE/SD
    O22          -0.147 0.202  0.37    0.55
    O23          -0.339 0.062  0.34    0.18
    o12: C1       0.853 3.297 10.54    0.31
    o12: C2      -0.088 0.071  0.27    0.26
    o13: C1       0.194 2.591 11.47    0.23
    o13: C2       0.339 0.111  0.31    0.36
    o12: b21     -1.030 0.209  0.69    0.30
    o13: b21     -1.420 0.215  0.63    0.34
    gamma_o1[1]  -0.549 0.050  0.22    0.23
    gamma_o1[2]   1.774 0.056  0.25    0.22
    D_o1_id[1,1]  1.954 0.203  0.76    0.27
    
    $m6b
                    est  MCSE   SD MCSE/SD
    M22           0.084 0.293 0.93    0.31
    M23          -1.386 0.179 0.98    0.18
    M24           0.234 0.384 1.00    0.39
    O22          -0.143 0.140 0.76    0.18
    O23          -0.400 0.160 0.69    0.23
    o13: C2       0.073 0.269 0.42    0.65
    c1:C2         0.311 0.467 0.58    0.81
    o12: C2      -0.687 0.091 0.31    0.29
    o12: c1      -0.312 0.154 0.29    0.53
    o13: c1      -0.913 0.135 0.33    0.41
    gamma_o1[1]  -0.392 0.072 0.21    0.34
    gamma_o1[2]   1.941 0.101 0.29    0.35
    D_o1_id[1,1]  5.065 1.650 3.25    0.51
    
    $m6c
                    est  MCSE   SD MCSE/SD
    M22           0.156 0.333 0.74    0.45
    M23          -0.834 0.191 0.76    0.25
    M24           0.330 0.121 0.66    0.18
    O22          -0.047 0.102 0.56    0.18
    O23          -0.397 0.107 0.58    0.18
    o12: C2       0.022 0.103 0.30    0.34
    o13: C2       0.375 0.065 0.27    0.24
    o12: c1      -0.234 0.055 0.30    0.18
    o12: c1:C2   -0.460 0.098 0.28    0.35
    o13: c1      -0.654 0.163 0.40    0.40
    o13: c1:C2   -0.308 0.301 0.56    0.54
    gamma_o1[1]  -0.628 0.156 0.32    0.49
    gamma_o1[2]   1.713 0.103 0.28    0.37
    D_o1_id[1,1]  3.617 0.559 1.72    0.33
    
    $m6d
                    est  MCSE   SD MCSE/SD
    M22           1.138 0.317 1.12   0.283
    M23          -1.041 0.471 1.26   0.375
    M24           0.199 0.039 0.92   0.042
    O22          -0.502 0.149 0.82   0.183
    O23          -0.633 0.120 0.66   0.183
    M22:C2        1.554 0.441 1.09   0.405
    M23:C2       -0.276 0.332 1.09   0.305
    M24:C2       -0.018 0.275 0.93   0.296
    o12: C2      -0.253 0.306 0.58   0.528
    o13: C2       0.109 0.246 0.48   0.517
    o12: c1       0.127 0.038 0.21   0.183
    o13: c1      -0.393 0.044 0.20   0.219
    gamma_o1[1]  -0.656 0.177 0.64   0.278
    gamma_o1[2]   1.580 0.191 0.64   0.300
    D_o1_id[1,1]  3.547 0.587 2.53   0.232
    
    $m6e
                     est  MCSE   SD MCSE/SD
    o12: M22     -0.1932 0.301 0.73    0.41
    o12: M23      0.1425 0.138 0.36    0.38
    o12: M24      0.5289 0.736 0.99    0.74
    o12: C2       0.2384 0.516 0.88    0.59
    o12: O22     -0.7293 0.204 0.43    0.48
    o12: O23     -0.9123 0.230 0.42    0.55
    o12: M22:C2  -0.6819 0.418 0.59    0.71
    o12: M23:C2  -0.2823 0.823 1.19    0.69
    o12: M24:C2  -0.0770 0.594 1.06    0.56
    o13: M22      1.4189 0.321 0.73    0.44
    o13: M23      0.6105 0.213 0.49    0.43
    o13: M24      0.2247 0.610 0.94    0.65
    o13: C2       0.3278 0.107 0.28    0.39
    o13: O22      0.0057 0.046 0.25    0.18
    o13: O23     -0.4328 0.304 0.60    0.50
    o13: M22:C2   0.4245 0.065 0.29    0.22
    o13: M23:C2   0.3964 0.679 1.01    0.67
    o13: M24:C2  -0.4602 0.183 0.65    0.28
    o12: c1       0.1556 0.091 0.25    0.37
    o13: c1      -0.2315 0.049 0.24    0.21
    gamma_o1[1]  -0.2064 0.371 0.50    0.74
    gamma_o1[2]   0.8937 0.127 0.31    0.41
    D_o1_id[1,1]  1.7393 0.302 0.58    0.52
    
    $m7a
                   est  MCSE    SD MCSE/SD
    (Intercept)  30.61 3.847 21.07    0.18
    C1          -50.92 5.201 28.48    0.18
    o1.L          0.92 0.226  0.53    0.43
    o1.Q          0.41 0.117  0.56    0.21
    o22           0.31 0.111  0.61    0.18
    o23           0.85 0.151  0.53    0.28
    o24          -2.35 0.344  0.74    0.46
    x2            0.89 0.486  0.82    0.59
    x3           -0.25 0.414  1.06    0.39
    x4            0.13 0.634  1.24    0.51
    time         -1.64 0.079  0.22    0.36
    sigma_y       4.30 0.046  0.25    0.18
    D_y_id[1,1]  17.61 0.629  4.15    0.15
    
    $m7b
                   est  MCSE   SD MCSE/SD
    (Intercept) -11.64 0.120 0.76    0.16
    o22           0.92 0.579 0.78    0.74
    o23           0.90 0.122 0.65    0.19
    o24          -2.05 0.150 0.66    0.23
    o1.L          1.21 0.100 0.55    0.18
    o1.Q          0.36 0.091 0.50    0.18
    c2           -4.29 0.728 3.17    0.23
    b21          -0.94 0.433 0.95    0.45
    sigma_y       4.78 0.039 0.22    0.18
    D_y_id[1,1]  17.47 1.896 4.20    0.45
    

# summary output remained the same on Windows

    
    Call:
    clmm_imp(fixed = o1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2 
     0.7166 -1.2817 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.464
    
    
    Call:
    clmm_imp(fixed = o2 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3 
     1.3181  0.2135 -1.1345 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.431
    
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2       C1 
      0.7387  -1.2202 -15.9451 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.676
    
    
    Call:
    clmm_imp(fixed = o2 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3      C1 
     1.3964  0.2504 -1.2286 -5.5995 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.583
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2       c1 
     0.67611 -1.22823  0.02665 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.152
    
    
    Call:
    clmm_imp(fixed = o2 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3      c1 
     1.2136  0.1385 -1.1416 -0.2156 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.183
    
    
    Call:
    clmm_imp(fixed = o1 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2      C2 
     0.9260 -1.1485 -0.2476 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        2.14
    
    
    Call:
    clmm_imp(fixed = o2 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3      C2 
     1.3167  0.1394 -1.2898  0.2501 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.703
    
    
    Call:
    clmm_imp(fixed = o1 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2      c2 
     0.7556 -1.1597 -1.1454 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.42
    
    
    Call:
    clmm_imp(fixed = o2 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3      c2 
     1.2442  0.1621 -1.2234  1.3527 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.339
    
    
    Call:
    lme_imp(fixed = c1 ~ o1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)        o1.L        o1.Q 
       -0.49824     0.01605     0.10146 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       912.5
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6487 
    
    Call:
    lme_imp(fixed = c1 ~ o2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         o22         o23         o24 
        0.27893     0.01345    -0.09257    -0.05863 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)     0.08781
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6122 
    
    Call:
    clmm_imp(fixed = o1 ~ M2 + o2 * abs(C1 - C2) + log(C1) + (1 | 
        id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
              o1 > 1           o1 > 2              M22              M23 
            0.547346        -1.800439        -0.005264         1.308090 
                 M24     abs(C1 - C2)          log(C1)              o22 
           -0.148828         0.486998        -9.544603         1.645538 
                 o23              o24 o22:abs(C1 - C2) o23:abs(C1 - C2) 
           -0.996870        -0.209898        -0.823412        -0.097940 
    o24:abs(C1 - C2) 
            0.516687 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.376
    
    
    Call:
    clmm_imp(fixed = o1 ~ ifelse(as.numeric(o2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1) + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
                                                        o1 > 1 
                                                       0.78555 
                                                        o1 > 2 
                                                      -1.34713 
                                                  abs(C1 - C2) 
                                                       0.38513 
                                                       log(C1) 
                                                      -4.29475 
                 ifelse(as.numeric(o2) > as.numeric(M1), 1, 0) 
                                                      -0.04439 
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                      -0.19893 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.604
    
    
    Call:
    clmm_imp(fixed = o1 ~ time + c1 + C1 + B2 + (c1 * time | id), 
        data = longDF, n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 > 1    o1 > 2        C1       B21      time        c1 
     0.714860 -1.036496 -1.538764 -0.003975  0.005750 -0.027527 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)        c1    time   c1:time
    (Intercept)     0.21703 -0.012897 0.01579 -0.010795
    c1             -0.01290  0.292145 0.03883  0.003329
    time            0.01579  0.038833 0.19099  0.022679
    c1:time        -0.01079  0.003329 0.02268  0.208501
    
    
    Call:
    clmm_imp(fixed = o1 ~ C1 * time + I(time^2) + b2 * c1, data = longDF, 
        random = ~time | id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 > 1    o1 > 2        C1      time I(time^2)       b21        c1   C1:time 
      0.65447  -1.19756  -1.62381   0.14141  -0.02432   0.75904  -0.09933  -0.05229 
       b21:c1 
      0.17872 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)    time
    (Intercept)     0.54726 0.03549
    time            0.03549 0.38649
    
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + log(time) + I(time^2) + p1, data = longDF, 
        random = ~1 | id, n.adapt = 5, n.iter = 10, shrinkage = "ridge", 
        seed = 2020, parallel = TRUE, n.cores = 2)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 > 1    o1 > 2        C1 log(time) I(time^2)        p1 
      0.76156  -1.23590 -13.13167  -0.18944  -0.00569  -0.04731 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.612
    
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + C2 + b2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~C1 + C2 + b2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2     O22     O23      C1      C2      C1      C2     b21     b21 
     0.4990 -1.7060  0.1836  0.4290 -7.5261 -0.1285 -7.7427 -0.4594  0.9212  0.7970 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.681
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2     M22     M23     M24     O22     O23      C2   c1:C2      C2 
     0.4462 -1.8358  0.5459  1.4830 -0.3073 -0.1551  0.3262  0.1677 -0.2094  0.7042 
         c1      c1 
     0.3559  0.8531 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.615
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 * C2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2      M22      M23      M24      O22      O23       C2 
     0.74465 -1.63172 -0.02957  0.60298 -0.07375  0.03610  0.25750  0.17324 
          C2       c1    c1:C2       c1    c1:C2 
    -0.40501  0.05535  0.30430  0.63197  0.44710 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.658
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2      M22      M23      M24      O22      O23   M22:C2 
     0.91644 -1.43550 -1.55530  2.28657 -0.19650  0.17262 -0.25917 -1.24459 
      M23:C2   M24:C2       C2       C2       c1       c1 
     0.91042  0.73604 -0.08681 -0.54921 -0.09966  0.40242 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       4.616
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = ~c1 + M2 * C2 + O2, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2      M22      M23      M24       C2      O22      O23 
     0.34936 -0.17745 -0.10579  0.93758  0.28557 -0.37649  0.03918  0.37247 
      M22:C2   M23:C2   M24:C2      M22      M23      M24       C2      O22 
    -0.13381  0.53114  1.02582 -1.84961 -0.16686 -0.37478  0.60890 -0.64966 
         O23   M22:C2   M23:C2   M24:C2       c1       c1 
     0.03493 -1.86051 -1.22676 -0.12209 -0.19334  0.12887 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.322
    
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + C2 + b2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~C1 + C2 + b2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 = 1   o1 = 2      O22      O23       C1       C2       C1       C2 
    -0.54879  1.77406 -0.14721 -0.33949  0.85328 -0.08849  0.19356  0.33901 
         b21      b21 
    -1.03036 -1.42033 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.954
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 = 1   o1 = 2      M22      M23      M24      O22      O23       C2 
    -0.39243  1.94085  0.08385 -1.38627  0.23404 -0.14272 -0.39985  0.07344 
       c1:C2       C2       c1       c1 
     0.31057 -0.68710 -0.31247 -0.91333 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       5.065
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 * C2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 = 1   o1 = 2      M22      M23      M24      O22      O23       C2 
    -0.62834  1.71272  0.15629 -0.83431  0.32987 -0.04666 -0.39740  0.02195 
          C2       c1    c1:C2       c1    c1:C2 
     0.37524 -0.23436 -0.46029 -0.65448 -0.30845 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.617
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 = 1   o1 = 2      M22      M23      M24      O22      O23   M22:C2 
    -0.65632  1.58043  1.13812 -1.04136  0.19944 -0.50246 -0.63263  1.55430 
      M23:C2   M24:C2       C2       C2       c1       c1 
    -0.27640 -0.01811 -0.25298  0.10923  0.12666 -0.39344 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.547
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = ~c1 + M2 * C2 + O2, rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 = 1    o1 = 2       M22       M23       M24        C2       O22       O23 
    -0.206419  0.893739 -0.193170  0.142487  0.528866  0.238446 -0.729332 -0.912319 
       M22:C2    M23:C2    M24:C2       M22       M23       M24        C2       O22 
    -0.681945 -0.282328 -0.076985  1.418925  0.610513  0.224744  0.327756  0.005701 
          O23    M22:C2    M23:C2    M24:C2        c1        c1 
    -0.432796  0.424457  0.396398 -0.460192  0.155577 -0.231476 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.739
    
    
    Call:
    lme_imp(fixed = y ~ C1 + o1 + o2 + x + time, data = longDF, random = ~1 | 
        id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "y" 
    
    Fixed effects:
    (Intercept)          C1        o1.L        o1.Q         o22         o23 
        30.6083    -50.9157      0.9207      0.4064      0.3122      0.8493 
            o24          x2          x3          x4        time 
        -2.3476      0.8890     -0.2451      0.1300     -1.6443 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       17.61
    
    
    
    Residual standard deviation:
    sigma_y 
      4.305 
    
    Call:
    lme_imp(fixed = y ~ o2 + o1 + c2 + b2, data = longDF, random = ~1 | 
        id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "y" 
    
    Fixed effects:
    (Intercept)         o22         o23         o24        o1.L        o1.Q 
       -11.6351      0.9212      0.9003     -2.0487      1.2117      0.3644 
             c2         b21 
        -4.2913     -0.9371 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       17.47
    
    
    
    Residual standard deviation:
    sigma_y 
      4.776 
    $m0a
    
    Call:
    clmm_imp(fixed = o1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2 
     0.7166 -1.2817 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.464
    
    
    $m0b
    
    Call:
    clmm_imp(fixed = o2 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3 
     1.3181  0.2135 -1.1345 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.431
    
    
    $m1a
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2       C1 
      0.7387  -1.2202 -15.9451 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.676
    
    
    $m1b
    
    Call:
    clmm_imp(fixed = o2 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3      C1 
     1.3964  0.2504 -1.2286 -5.5995 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.583
    
    
    $m1c
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2       c1 
     0.67611 -1.22823  0.02665 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.152
    
    
    $m1d
    
    Call:
    clmm_imp(fixed = o2 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3      c1 
     1.2136  0.1385 -1.1416 -0.2156 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.183
    
    
    $m2a
    
    Call:
    clmm_imp(fixed = o1 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2      C2 
     0.9260 -1.1485 -0.2476 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        2.14
    
    
    $m2b
    
    Call:
    clmm_imp(fixed = o2 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3      C2 
     1.3167  0.1394 -1.2898  0.2501 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.703
    
    
    $m2c
    
    Call:
    clmm_imp(fixed = o1 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2      c2 
     0.7556 -1.1597 -1.1454 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.42
    
    
    $m2d
    
    Call:
    clmm_imp(fixed = o2 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3      c2 
     1.2442  0.1621 -1.2234  1.3527 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.339
    
    
    $m3a
    
    Call:
    lme_imp(fixed = c1 ~ o1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)        o1.L        o1.Q 
       -0.49824     0.01605     0.10146 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       912.5
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6487 
    
    $m3b
    
    Call:
    lme_imp(fixed = c1 ~ o2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         o22         o23         o24 
        0.27893     0.01345    -0.09257    -0.05863 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)     0.08781
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6122 
    
    $m4a
    
    Call:
    clmm_imp(fixed = o1 ~ M2 + o2 * abs(C1 - C2) + log(C1) + (1 | 
        id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
              o1 > 1           o1 > 2              M22              M23 
            0.547346        -1.800439        -0.005264         1.308090 
                 M24     abs(C1 - C2)          log(C1)              o22 
           -0.148828         0.486998        -9.544603         1.645538 
                 o23              o24 o22:abs(C1 - C2) o23:abs(C1 - C2) 
           -0.996870        -0.209898        -0.823412        -0.097940 
    o24:abs(C1 - C2) 
            0.516687 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.376
    
    
    $m4b
    
    Call:
    clmm_imp(fixed = o1 ~ ifelse(as.numeric(o2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1) + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
                                                        o1 > 1 
                                                       0.78555 
                                                        o1 > 2 
                                                      -1.34713 
                                                  abs(C1 - C2) 
                                                       0.38513 
                                                       log(C1) 
                                                      -4.29475 
                 ifelse(as.numeric(o2) > as.numeric(M1), 1, 0) 
                                                      -0.04439 
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                      -0.19893 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.604
    
    
    $m4c
    
    Call:
    clmm_imp(fixed = o1 ~ time + c1 + C1 + B2 + (c1 * time | id), 
        data = longDF, n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 > 1    o1 > 2        C1       B21      time        c1 
     0.714860 -1.036496 -1.538764 -0.003975  0.005750 -0.027527 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)        c1    time   c1:time
    (Intercept)     0.21703 -0.012897 0.01579 -0.010795
    c1             -0.01290  0.292145 0.03883  0.003329
    time            0.01579  0.038833 0.19099  0.022679
    c1:time        -0.01079  0.003329 0.02268  0.208501
    
    
    $m4d
    
    Call:
    clmm_imp(fixed = o1 ~ C1 * time + I(time^2) + b2 * c1, data = longDF, 
        random = ~time | id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 > 1    o1 > 2        C1      time I(time^2)       b21        c1   C1:time 
      0.65447  -1.19756  -1.62381   0.14141  -0.02432   0.75904  -0.09933  -0.05229 
       b21:c1 
      0.17872 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)    time
    (Intercept)     0.54726 0.03549
    time            0.03549 0.38649
    
    
    $m4e
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + log(time) + I(time^2) + p1, data = longDF, 
        random = ~1 | id, n.adapt = 5, n.iter = 10, shrinkage = "ridge", 
        seed = 2020, parallel = TRUE, n.cores = 2)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 > 1    o1 > 2        C1 log(time) I(time^2)        p1 
      0.76156  -1.23590 -13.13167  -0.18944  -0.00569  -0.04731 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.612
    
    
    $m5a
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + C2 + b2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~C1 + C2 + b2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2     O22     O23      C1      C2      C1      C2     b21     b21 
     0.4990 -1.7060  0.1836  0.4290 -7.5261 -0.1285 -7.7427 -0.4594  0.9212  0.7970 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.681
    
    
    $m5b
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2     M22     M23     M24     O22     O23      C2   c1:C2      C2 
     0.4462 -1.8358  0.5459  1.4830 -0.3073 -0.1551  0.3262  0.1677 -0.2094  0.7042 
         c1      c1 
     0.3559  0.8531 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.615
    
    
    $m5c
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 * C2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2      M22      M23      M24      O22      O23       C2 
     0.74465 -1.63172 -0.02957  0.60298 -0.07375  0.03610  0.25750  0.17324 
          C2       c1    c1:C2       c1    c1:C2 
    -0.40501  0.05535  0.30430  0.63197  0.44710 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.658
    
    
    $m5d
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2      M22      M23      M24      O22      O23   M22:C2 
     0.91644 -1.43550 -1.55530  2.28657 -0.19650  0.17262 -0.25917 -1.24459 
      M23:C2   M24:C2       C2       C2       c1       c1 
     0.91042  0.73604 -0.08681 -0.54921 -0.09966  0.40242 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       4.616
    
    
    $m5e
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = ~c1 + M2 * C2 + O2, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2      M22      M23      M24       C2      O22      O23 
     0.34936 -0.17745 -0.10579  0.93758  0.28557 -0.37649  0.03918  0.37247 
      M22:C2   M23:C2   M24:C2      M22      M23      M24       C2      O22 
    -0.13381  0.53114  1.02582 -1.84961 -0.16686 -0.37478  0.60890 -0.64966 
         O23   M22:C2   M23:C2   M24:C2       c1       c1 
     0.03493 -1.86051 -1.22676 -0.12209 -0.19334  0.12887 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.322
    
    
    $m6a
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + C2 + b2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~C1 + C2 + b2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 = 1   o1 = 2      O22      O23       C1       C2       C1       C2 
    -0.54879  1.77406 -0.14721 -0.33949  0.85328 -0.08849  0.19356  0.33901 
         b21      b21 
    -1.03036 -1.42033 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.954
    
    
    $m6b
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 = 1   o1 = 2      M22      M23      M24      O22      O23       C2 
    -0.39243  1.94085  0.08385 -1.38627  0.23404 -0.14272 -0.39985  0.07344 
       c1:C2       C2       c1       c1 
     0.31057 -0.68710 -0.31247 -0.91333 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       5.065
    
    
    $m6c
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 * C2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 = 1   o1 = 2      M22      M23      M24      O22      O23       C2 
    -0.62834  1.71272  0.15629 -0.83431  0.32987 -0.04666 -0.39740  0.02195 
          C2       c1    c1:C2       c1    c1:C2 
     0.37524 -0.23436 -0.46029 -0.65448 -0.30845 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.617
    
    
    $m6d
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 = 1   o1 = 2      M22      M23      M24      O22      O23   M22:C2 
    -0.65632  1.58043  1.13812 -1.04136  0.19944 -0.50246 -0.63263  1.55430 
      M23:C2   M24:C2       C2       C2       c1       c1 
    -0.27640 -0.01811 -0.25298  0.10923  0.12666 -0.39344 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.547
    
    
    $m6e
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = ~c1 + M2 * C2 + O2, rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 = 1    o1 = 2       M22       M23       M24        C2       O22       O23 
    -0.206419  0.893739 -0.193170  0.142487  0.528866  0.238446 -0.729332 -0.912319 
       M22:C2    M23:C2    M24:C2       M22       M23       M24        C2       O22 
    -0.681945 -0.282328 -0.076985  1.418925  0.610513  0.224744  0.327756  0.005701 
          O23    M22:C2    M23:C2    M24:C2        c1        c1 
    -0.432796  0.424457  0.396398 -0.460192  0.155577 -0.231476 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.739
    
    
    $m7a
    
    Call:
    lme_imp(fixed = y ~ C1 + o1 + o2 + x + time, data = longDF, random = ~1 | 
        id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "y" 
    
    Fixed effects:
    (Intercept)          C1        o1.L        o1.Q         o22         o23 
        30.6083    -50.9157      0.9207      0.4064      0.3122      0.8493 
            o24          x2          x3          x4        time 
        -2.3476      0.8890     -0.2451      0.1300     -1.6443 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       17.61
    
    
    
    Residual standard deviation:
    sigma_y 
      4.305 
    
    $m7b
    
    Call:
    lme_imp(fixed = y ~ o2 + o1 + c2 + b2, data = longDF, random = ~1 | 
        id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "y" 
    
    Fixed effects:
    (Intercept)         o22         o23         o24        o1.L        o1.Q 
       -11.6351      0.9212      0.9003     -2.0487      1.2117      0.3644 
             c2         b21 
        -4.2913     -0.9371 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       17.47
    
    
    
    Residual standard deviation:
    sigma_y 
      4.776 
    

---

    $m0a
    $m0a$o1
        o1 > 1     o1 > 2 
     0.7166014 -1.2817304 
    
    
    $m0b
    $m0b$o2
        o2 > 1     o2 > 2     o2 > 3 
     1.3181367  0.2135418 -1.1345484 
    
    
    $m1a
    $m1a$o1
        o1 > 1     o1 > 2         C1 
      0.738726  -1.220184 -15.945096 
    
    
    $m1b
    $m1b$o2
        o2 > 1     o2 > 2     o2 > 3         C1 
     1.3963684  0.2503889 -1.2286423 -5.5995125 
    
    
    $m1c
    $m1c$o1
         o1 > 1      o1 > 2          c1 
     0.67611365 -1.22823236  0.02665475 
    
    
    $m1d
    $m1d$o2
        o2 > 1     o2 > 2     o2 > 3         c1 
     1.2136117  0.1385305 -1.1415935 -0.2155600 
    
    
    $m2a
    $m2a$o1
        o1 > 1     o1 > 2         C2 
     0.9259980 -1.1484604 -0.2475899 
    
    
    $m2b
    $m2b$o2
        o2 > 1     o2 > 2     o2 > 3         C2 
     1.3167014  0.1393902 -1.2898064  0.2500689 
    
    
    $m2c
    $m2c$o1
        o1 > 1     o1 > 2         c2 
     0.7555581 -1.1596979 -1.1454001 
    
    
    $m2d
    $m2d$o2
        o2 > 1     o2 > 2     o2 > 3         c2 
     1.2441766  0.1621265 -1.2233991  1.3527173 
    
    
    $m3a
    $m3a$c1
    (Intercept)        o1.L        o1.Q 
    -0.49823890  0.01604904  0.10146012 
    
    
    $m3b
    $m3b$c1
    (Intercept)         o22         o23         o24 
     0.27892987  0.01344824 -0.09256567 -0.05862995 
    
    
    $m4a
    $m4a$o1
              o1 > 1           o1 > 2              M22              M23 
         0.547345510     -1.800439197     -0.005263968      1.308090267 
                 M24     abs(C1 - C2)          log(C1)              o22 
        -0.148827612      0.486997818     -9.544603430      1.645537623 
                 o23              o24 o22:abs(C1 - C2) o23:abs(C1 - C2) 
        -0.996869673     -0.209898147     -0.823411662     -0.097940452 
    o24:abs(C1 - C2) 
         0.516686864 
    
    
    $m4b
    $m4b$o1
                                                        o1 > 1 
                                                    0.78555024 
                                                        o1 > 2 
                                                   -1.34712746 
                                                  abs(C1 - C2) 
                                                    0.38512927 
                                                       log(C1) 
                                                   -4.29474837 
                 ifelse(as.numeric(o2) > as.numeric(M1), 1, 0) 
                                                   -0.04439108 
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                   -0.19893228 
    
    
    $m4c
    $m4c$o1
          o1 > 1       o1 > 2           C1          B21         time           c1 
     0.714859640 -1.036495524 -1.538764362 -0.003975088  0.005749868 -0.027526644 
    
    
    $m4d
    $m4d$o1
         o1 > 1      o1 > 2          C1        time   I(time^2)         b21 
     0.65447112 -1.19756469 -1.62380997  0.14140823 -0.02432388  0.75903854 
             c1     C1:time      b21:c1 
    -0.09933145 -0.05228622  0.17871973 
    
    
    $m4e
    $m4e$o1
           o1 > 1        o1 > 2            C1     log(time)     I(time^2) 
      0.761555465  -1.235900903 -13.131665834  -0.189439645  -0.005690086 
               p1 
     -0.047310981 
    
    
    $m5a
    $m5a$o1
        o1 > 1     o1 > 2        O22        O23         C1         C2         C1 
     0.4990183 -1.7060447  0.1836294  0.4290190 -7.5261095 -0.1285198 -7.7427487 
            C2        b21        b21 
    -0.4594278  0.9212371  0.7969994 
    
    
    $m5b
    $m5b$o1
        o1 > 1     o1 > 2        M22        M23        M24        O22        O23 
     0.4462318 -1.8358426  0.5459010  1.4829642 -0.3073447 -0.1551100  0.3261893 
            C2      c1:C2         C2         c1         c1 
     0.1676607 -0.2094225  0.7041978  0.3559364  0.8530636 
    
    
    $m5c
    $m5c$o1
         o1 > 1      o1 > 2         M22         M23         M24         O22 
     0.74464900 -1.63172151 -0.02957264  0.60297543 -0.07375422  0.03610004 
            O23          C2          C2          c1       c1:C2          c1 
     0.25750073  0.17324100 -0.40501013  0.05534847  0.30429820  0.63197117 
          c1:C2 
     0.44710225 
    
    
    $m5d
    $m5d$o1
         o1 > 1      o1 > 2         M22         M23         M24         O22 
     0.91643905 -1.43549859 -1.55529997  2.28657158 -0.19649635  0.17261522 
            O23      M22:C2      M23:C2      M24:C2          C2          C2 
    -0.25916610 -1.24458883  0.91041882  0.73603743 -0.08681346 -0.54921198 
             c1          c1 
    -0.09966001  0.40241839 
    
    
    $m5e
    $m5e$o1
         o1 > 1      o1 > 2         M22         M23         M24          C2 
     0.34935723 -0.17744878 -0.10578560  0.93757711  0.28557202 -0.37648980 
            O22         O23      M22:C2      M23:C2      M24:C2         M22 
     0.03918135  0.37247496 -0.13381483  0.53113800  1.02582340 -1.84960723 
            M23         M24          C2         O22         O23      M22:C2 
    -0.16685631 -0.37477593  0.60889566 -0.64965883  0.03492591 -1.86051387 
         M23:C2      M24:C2          c1          c1 
    -1.22675629 -0.12208562 -0.19334338  0.12886557 
    
    
    $m6a
    $m6a$o1
         o1 = 1      o1 = 2         O22         O23          C1          C2 
    -0.54878986  1.77405753 -0.14721232 -0.33948969  0.85327733 -0.08849219 
             C1          C2         b21         b21 
     0.19356442  0.33901366 -1.03036055 -1.42033391 
    
    
    $m6b
    $m6b$o1
         o1 = 1      o1 = 2         M22         M23         M24         O22 
    -0.39242557  1.94085310  0.08385219 -1.38626545  0.23403814 -0.14272125 
            O23          C2       c1:C2          C2          c1          c1 
    -0.39984959  0.07344404  0.31057320 -0.68710493 -0.31246821 -0.91332611 
    
    
    $m6c
    $m6c$o1
         o1 = 1      o1 = 2         M22         M23         M24         O22 
    -0.62834347  1.71271982  0.15628833 -0.83431238  0.32986669 -0.04666314 
            O23          C2          C2          c1       c1:C2          c1 
    -0.39740485  0.02195033  0.37523623 -0.23435661 -0.46028612 -0.65448342 
          c1:C2 
    -0.30845149 
    
    
    $m6d
    $m6d$o1
        o1 = 1     o1 = 2        M22        M23        M24        O22        O23 
    -0.6563180  1.5804307  1.1381161 -1.0413565  0.1994396 -0.5024572 -0.6326255 
        M22:C2     M23:C2     M24:C2         C2         C2         c1         c1 
     1.5543031 -0.2764047 -0.0181119 -0.2529793  0.1092323  0.1266634 -0.3934415 
    
    
    $m6e
    $m6e$o1
          o1 = 1       o1 = 2          M22          M23          M24           C2 
    -0.206418550  0.893738549 -0.193170066  0.142487389  0.528866082  0.238446399 
             O22          O23       M22:C2       M23:C2       M24:C2          M22 
    -0.729331798 -0.912318989 -0.681944728 -0.282327932 -0.076984784  1.418925340 
             M23          M24           C2          O22          O23       M22:C2 
     0.610512848  0.224743791  0.327756315  0.005700526 -0.432796059  0.424456710 
          M23:C2       M24:C2           c1           c1 
     0.396397889 -0.460192276  0.155576563 -0.231475621 
    
    
    $m7a
    $m7a$y
    (Intercept)          C1        o1.L        o1.Q         o22         o23 
     30.6083349 -50.9157354   0.9207167   0.4063556   0.3122119   0.8493234 
            o24          x2          x3          x4        time 
     -2.3476027   0.8889990  -0.2450804   0.1299734  -1.6443213 
    
    
    $m7b
    $m7b$y
    (Intercept)         o22         o23         o24        o1.L        o1.Q 
    -11.6351246   0.9211858   0.9003031  -2.0487311   1.2117087   0.3643813 
             c2         b21 
     -4.2913049  -0.9370973 
    
    

---

    $m0a
    $m0a$o1
                 2.5%      97.5%
    o1 > 1  0.3757083  1.1098398
    o1 > 2 -1.8014007 -0.9060326
    
    
    $m0b
    $m0b$o2
                  2.5%      97.5%
    o2 > 1  1.05660462  1.6104674
    o2 > 2 -0.04194673  0.4993613
    o2 > 3 -1.46990224 -0.7924972
    
    
    $m1a
    $m1a$o1
                  2.5%      97.5%
    o1 > 1   0.2573501  1.0543246
    o1 > 2  -1.6974628 -0.8858575
    C1     -47.6855264  6.9684885
    
    
    $m1b
    $m1b$o2
                  2.5%      97.5%
    o2 > 1   0.9970400  1.9862404
    o2 > 2  -0.3301338  0.8557003
    o2 > 3  -1.7909930 -0.6297474
    C1     -36.1837953 17.0712007
    
    
    $m1c
    $m1c$o1
                 2.5%      97.5%
    o1 > 1  0.4310754  0.9754063
    o1 > 2 -1.5497322 -0.8959109
    c1     -0.2430641  0.3630849
    
    
    $m1d
    $m1d$o2
                 2.5%       97.5%
    o2 > 1  0.7500651  1.69139618
    o2 > 2 -0.3146497  0.58016235
    o2 > 3 -1.6375000 -0.74053620
    c1     -0.5246251  0.05635831
    
    
    $m2a
    $m2a$o1
                 2.5%      97.5%
    o1 > 1  0.4155809  1.3387868
    o1 > 2 -1.7424408 -0.7613909
    C2     -0.7399117  0.3216636
    
    
    $m2b
    $m2b$o2
                 2.5%      97.5%
    o2 > 1  0.8931870  1.6865871
    o2 > 2 -0.3766822  0.4575274
    o2 > 3 -2.2051864 -0.7680313
    C2     -0.3724619  0.7400229
    
    
    $m2c
    $m2c$o1
                 2.5%      97.5%
    o1 > 1  0.3640769  1.1255313
    o1 > 2 -1.4223415 -0.8565383
    c2     -3.6591686  0.4008031
    
    
    $m2d
    $m2d$o2
                 2.5%      97.5%
    o2 > 1  0.9729987  1.6330215
    o2 > 2 -0.1082704  0.5217081
    o2 > 3 -1.5497343 -0.8693382
    c2     -1.2323269  3.9907071
    
    
    $m3a
    $m3a$c1
                        2.5%     97.5%
    (Intercept) -38.41008748 38.141325
    o1.L         -0.13578520  0.144816
    o1.Q         -0.07729913  0.230482
    
    
    $m3b
    $m3b$c1
                      2.5%     97.5%
    (Intercept)  0.1093443 0.4461342
    o22         -0.2071233 0.3197796
    o23         -0.3149814 0.1535758
    o24         -0.3286544 0.1810937
    
    
    $m4a
    $m4a$o1
                              2.5%       97.5%
    o1 > 1            2.674127e-01  0.80475164
    o1 > 2           -2.227970e+00 -1.37466850
    M22              -1.249252e+00  0.91740547
    M23               6.313427e-01  2.25018331
    M24              -1.320427e+00  0.93834987
    abs(C1 - C2)     -1.576040e-01  1.39296398
    log(C1)          -4.292229e+01 11.02316414
    o22               9.738293e-01  2.46106485
    o23              -2.283943e+00  0.02821279
    o24              -8.940740e-01  0.27777986
    o22:abs(C1 - C2) -1.391606e+00 -0.08260987
    o23:abs(C1 - C2) -1.328644e+00  0.81580133
    o24:abs(C1 - C2)  3.249182e-04  1.04136294
    
    
    $m4b
    $m4b$o1
                                                                      2.5%
    o1 > 1                                                       0.4775337
    o1 > 2                                                      -1.7372063
    abs(C1 - C2)                                                -0.1614070
    log(C1)                                                    -25.5846402
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)               -0.9535282
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.8595235
                                                                    97.5%
    o1 > 1                                                      1.0826951
    o1 > 2                                                     -1.0469754
    abs(C1 - C2)                                                1.0525813
    log(C1)                                                    13.2373697
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)               0.9433073
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.3579237
    
    
    $m4c
    $m4c$o1
                  2.5%       97.5%
    o1 > 1  0.50846697  1.08946008
    o1 > 2 -1.21866677 -0.80867654
    C1     -9.04281609  4.84257283
    B21    -0.20992774  0.17456705
    time   -0.04376344  0.05127424
    c1     -0.15710190  0.18432233
    
    
    $m4d
    $m4d$o1
                     2.5%       97.5%
    o1 > 1      0.3085149  0.93114506
    o1 > 2     -1.6006327 -0.79217860
    C1        -10.7789590  7.19360664
    time       -0.1892098  0.53838607
    I(time^2)  -0.0581543  0.01204487
    b21         0.1452251  1.35078616
    c1         -0.4686095  0.29323738
    C1:time    -0.2994663  0.18173446
    b21:c1     -1.3528231  1.48788434
    
    
    $m4e
    $m4e$o1
                      2.5%       97.5%
    o1 > 1      0.37561611  1.11585416
    o1 > 2     -1.61219070 -0.86593342
    C1        -34.30626521  5.90815379
    log(time)  -0.42387330  0.01113377
    I(time^2)  -0.03605464  0.02591907
    p1         -0.13279062  0.03402942
    
    
    $m5a
    $m5a$o1
                   2.5%      97.5%
    o1 > 1   0.06261021  1.1007588
    o1 > 2  -2.13741837 -1.2116971
    O22     -0.65837509  0.7436957
    O23     -0.31039894  1.1158065
    C1     -26.29977439 15.4025356
    C2      -0.80206921  0.2772197
    C1     -26.65500072 11.8435094
    C2      -1.01967379 -0.1344532
    b21     -0.04702644  1.6685025
    b21      0.19988348  1.3636056
    
    
    $m5b
    $m5b$o1
                  2.5%      97.5%
    o1 > 1 -0.14321878  1.1765780
    o1 > 2 -2.50602883 -1.1374342
    M22    -1.08250771  2.6626906
    M23    -0.21184890  2.8370495
    M24    -1.10121662  0.7155098
    O22    -1.77461190  1.1049876
    O23    -0.73326687  2.1765882
    C2     -0.43474837  0.5635401
    c1:C2  -0.85007271  0.3604886
    C2      0.12883910  1.2868493
    c1     -0.07762887  0.9412268
    c1      0.30999642  1.2841030
    
    
    $m5c
    $m5c$o1
                   2.5%      97.5%
    o1 > 1 -0.008391628  1.7531465
    o1 > 2 -2.615129883 -0.4559405
    M22    -1.756763406  1.1231145
    M23    -0.804200170  1.9683095
    M24    -1.363771354  1.2899292
    O22    -1.737424351  1.6453639
    O23    -1.152492799  1.7084294
    C2     -0.417280648  0.9713900
    C2     -1.144243455  0.2925439
    c1     -0.619143600  0.7785419
    c1:C2  -0.384147426  1.2970258
    c1     -0.405953471  1.3331337
    c1:C2  -0.548507948  1.2667987
    
    
    $m5d
    $m5d$o1
                  2.5%      97.5%
    o1 > 1  0.28290336  1.8738727
    o1 > 2 -2.21744263 -0.2352852
    M22    -5.76902086  0.9459116
    M23    -0.50979837  4.6320910
    M24    -1.48388682  1.5410149
    O22    -0.98904747  1.7960176
    O23    -2.29079017  1.7070828
    M22:C2 -3.86661828  0.6635921
    M23:C2 -0.29306336  2.5171107
    M24:C2 -0.77114704  2.0601213
    C2     -0.91960145  0.4685419
    C2     -1.09065370  0.1945582
    c1     -0.37721975  0.2652896
    c1     -0.02062636  0.8508289
    
    
    $m5e
    $m5e$o1
                   2.5%      97.5%
    o1 > 1  0.052547840  0.7920653
    o1 > 2 -1.044555543  0.7360974
    M22    -0.777779700  0.7146560
    M23     0.044036610  2.2290055
    M24    -0.479924172  1.2156713
    C2     -1.220303896  0.3674405
    O22    -0.481623564  0.8628483
    O23    -0.113797260  1.0512685
    M22:C2 -1.170771515  1.0677753
    M23:C2  0.001228692  1.4127329
    M24:C2  0.361616221  1.8290963
    M22    -2.519916897 -1.0442021
    M23    -0.808558583  0.7921731
    M24    -1.474276580  1.2120793
    C2      0.006861703  1.5407888
    O22    -1.187045931 -0.1216580
    O23    -0.477503322  0.6121450
    M22:C2 -2.833232670 -0.8364812
    M23:C2 -2.070624509 -0.2088185
    M24:C2 -0.992400953  1.1816506
    c1     -0.575025163  0.1722863
    c1     -0.292354073  0.3910513
    
    
    $m6a
    $m6a$o1
                  2.5%      97.5%
    o1 = 1  -0.9926980 -0.1392118
    o1 = 2   1.3858776  2.2965774
    O22     -0.7318300  0.4249368
    O23     -0.9279967  0.2332150
    C1     -16.1905174 20.2906642
    C2      -0.5930618  0.3534096
    C1     -21.8244398 20.9240807
    C2      -0.1698474  0.8580139
    b21     -2.4270777  0.3402608
    b21     -2.2482082 -0.1108535
    
    
    $m6b
    $m6b$o1
                 2.5%      97.5%
    o1 = 1 -0.8420684 -0.1399890
    o1 = 2  1.2015683  2.3378404
    M22    -1.4114783  1.5864729
    M23    -2.9914278  0.5370397
    M24    -0.8929366  2.6662874
    O22    -1.6744671  0.9044471
    O23    -1.7824970  0.5339711
    C2     -0.5827201  0.7828628
    c1:C2  -0.5370176  1.2637743
    C2     -1.2049953 -0.1699491
    c1     -0.9161944  0.1450043
    c1     -1.4136093 -0.4274750
    
    
    $m6c
    $m6c$o1
                 2.5%     97.5%
    o1 = 1 -1.1153287 0.0210673
    o1 = 2  1.2303507 2.2735912
    M22    -1.1312289 1.5374328
    M23    -2.3892653 0.3291817
    M24    -0.5437060 1.5584586
    O22    -0.8360804 1.0696515
    O23    -1.3202774 0.6411357
    C2     -0.4504254 0.6252057
    C2     -0.1702441 0.8154603
    c1     -0.6954011 0.2959077
    c1:C2  -0.8508832 0.0512646
    c1     -1.1826277 0.1924441
    c1:C2  -0.9746227 0.8083141
    
    
    $m6d
    $m6d$o1
                 2.5%      97.5%
    o1 = 1 -1.6006266  0.2291268
    o1 = 2  0.6355016  2.5922972
    M22    -0.9643052  2.6643462
    M23    -3.2062246  0.6486016
    M24    -1.4978526  1.4679641
    O22    -2.1465773  0.6123692
    O23    -2.0477404  0.2929267
    M22:C2  0.1274979  3.9141424
    M23:C2 -2.4840751  1.4286055
    M24:C2 -1.6229566  1.3223018
    C2     -1.3944644  0.7229504
    C2     -0.5646272  0.8928222
    c1     -0.1425695  0.4600998
    c1     -0.8226574 -0.0204390
    
    
    $m6e
    $m6e$o1
                  2.5%       97.5%
    o1 = 1 -1.12410008  0.49631368
    o1 = 2  0.26725453  1.20217998
    M22    -1.38073062  0.79169083
    M23    -0.39242686  0.90248502
    M24    -0.80981622  1.99639320
    C2     -0.86264689  1.74346396
    O22    -1.53953107 -0.01591025
    O23    -1.56169976 -0.19307932
    M22:C2 -1.66778859  0.03122184
    M23:C2 -1.84250239  1.51413975
    M24:C2 -1.74340928  1.66159271
    M22    -0.03708787  2.26157085
    M23    -0.33468802  1.39334852
    M24    -1.26191940  1.72330284
    C2     -0.10661841  0.68664289
    O22    -0.38800681  0.46230827
    O23    -1.45948351  0.38085804
    M22:C2 -0.14847633  0.89547477
    M23:C2 -0.90051248  2.00582791
    M24:C2 -1.68577364  0.61506882
    c1     -0.29445736  0.52329911
    c1     -0.64466495  0.15865665
    
    
    $m7a
    $m7a$y
                         2.5%      97.5%
    (Intercept)   -5.56553444 75.8866814
    C1          -113.75801029 -2.1320266
    o1.L          -0.09752605  1.6495140
    o1.Q          -0.53386460  1.3121715
    o22           -0.66146635  1.3679092
    o23           -0.01220589  1.8589265
    o24           -3.56447295 -0.9512662
    x2            -0.65447669  2.0398297
    x3            -2.42342853  1.2983296
    x4            -2.09874250  1.8641994
    time          -1.96500434 -1.3066596
    
    
    $m7b
    $m7b$y
                       2.5%       97.5%
    (Intercept) -13.0227549 -10.2417092
    o22          -0.5110718   2.2093744
    o23          -0.4192943   1.9372367
    o24          -3.1731308  -0.9097730
    o1.L          0.3368099   2.0478916
    o1.Q         -0.3879058   1.1918417
    c2           -9.1186841   1.4490554
    b21          -2.3311733   0.4440725
    
    

---

    $m0a
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
         Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.717 0.229  0.376  1.110          0    5.66  0.621
    o1 > 2 -1.282 0.230 -1.801 -0.906          0    1.44  0.226
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 1.46 0.501 0.79  2.34               3.85  0.464
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m0b
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o2 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
         Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    
    Posterior summary of the intercepts:
             Mean    SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    o2 > 1  1.318 0.179  1.0566  1.610      0.000    2.02  0.279
    o2 > 2  0.214 0.176 -0.0419  0.499      0.267    2.06  0.201
    o2 > 3 -1.135 0.197 -1.4699 -0.792      0.000    3.06  0.212
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o2_id[1,1] 1.43 0.774 0.714  3.25               2.69  0.272
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m1a
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
        Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    C1 -15.9 15.2 -47.7  6.97      0.333    1.63  0.336
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.739 0.219  0.257  1.054          0    2.21  0.343
    o1 > 2 -1.220 0.218 -1.697 -0.886          0    1.04  0.222
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 1.68 0.865 0.74   3.9               1.92  0.428
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m1b
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o2 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
       Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    C1 -5.6 14.5 -36.2  17.1        0.8     1.4  0.215
    
    Posterior summary of the intercepts:
            Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o2 > 1  1.40 0.327  0.997  1.986        0.0    4.11  0.527
    o2 > 2  0.25 0.338 -0.330  0.856        0.4    3.57  0.496
    o2 > 3 -1.23 0.375 -1.791 -0.630        0.0    2.24  0.205
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o2_id[1,1] 2.58 1.58 0.895  5.66               2.55   0.45
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m1c
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
         Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    c1 0.0267 0.194 -0.243 0.363      0.933     1.3  0.241
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.676 0.163  0.431  0.975          0   1.004  0.215
    o1 > 2 -1.228 0.175 -1.550 -0.896          0   0.982  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 1.15 0.446 0.775  2.51               5.27   0.42
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m1d
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o2 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
         Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    c1 -0.216 0.178 -0.525 0.0564      0.133     1.4  0.183
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o2 > 1  1.214 0.259  0.750  1.691      0.000    3.17  0.464
    o2 > 2  0.139 0.247 -0.315  0.580      0.467    2.39  0.323
    o2 > 3 -1.142 0.231 -1.637 -0.741      0.000    1.61  0.248
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o2_id[1,1] 1.18 0.54 0.51  2.19               1.02  0.292
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m2a
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
         Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    C2 -0.248 0.331 -0.74 0.322      0.467    3.24  0.292
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.926 0.256  0.416  1.339          0    3.71  0.373
    o1 > 2 -1.148 0.311 -1.742 -0.761          0    6.99  0.521
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 2.14 1.05 0.772  4.16               1.76  0.331
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m2b
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o2 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
       Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    C2 0.25 0.278 -0.372  0.74        0.2    1.36  0.316
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o2 > 1  1.317 0.220  0.893  1.687        0.0    1.14  0.397
    o2 > 2  0.139 0.231 -0.377  0.458        0.4    2.12  0.401
    o2 > 3 -1.290 0.380 -2.205 -0.768        0.0    2.63  0.459
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o2_id[1,1]  2.7 2.83 0.59  10.4               8.33  0.577
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m2c
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
        Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    c2 -1.15 1.29 -3.66 0.401        0.2    1.18  0.183
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.756 0.207  0.364  1.126          0   0.976  0.428
    o1 > 2 -1.160 0.175 -1.422 -0.857          0   0.968  0.391
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 1.42 0.334 0.874  2.07               3.07  0.344
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m2d
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o2 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
       Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    c2 1.35 1.59 -1.23  3.99      0.467     2.3  0.488
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o2 > 1  1.244 0.203  0.973  1.633      0.000    4.06  0.444
    o2 > 2  0.162 0.174 -0.108  0.522      0.267    2.09  0.226
    o2 > 3 -1.223 0.198 -1.550 -0.869      0.000    1.46  0.219
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o2_id[1,1] 1.34 0.427 0.661     2               1.58  0.299
    
    
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
    lme_imp(fixed = c1 ~ o1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                  Mean      SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    (Intercept) -0.498 29.7993 -38.4101 38.141      0.333    1.63  0.183
    o1.L         0.016  0.0786  -0.1358  0.145      0.933    1.24  0.220
    o1.Q         0.101  0.0819  -0.0773  0.230      0.133    1.90  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_c1_id[1,1]  912 3582 0.058 11871               1.46  0.183
    
    Posterior summary of residual std. deviation:
              Mean     SD  2.5% 97.5% GR-crit MCE/SD
    sigma_c1 0.649 0.0583 0.583 0.814   0.999  0.183
    
    
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
    lme_imp(fixed = c1 ~ o2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                   Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    (Intercept)  0.2789 0.111  0.109 0.446      0.000    8.38  0.573
    o22          0.0134 0.136 -0.207 0.320      1.000    4.03  0.393
    o23         -0.0926 0.164 -0.315 0.154      0.733    7.88  0.614
    o24         -0.0586 0.147 -0.329 0.181      0.667    6.71  0.556
    
    Posterior summary of random effects covariance matrix:
                   Mean     SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_c1_id[1,1] 0.0878 0.0274 0.0462  0.14               2.17  0.451
    
    Posterior summary of residual std. deviation:
              Mean     SD  2.5% 97.5% GR-crit MCE/SD
    sigma_c1 0.612 0.0287 0.562 0.663    1.83  0.332
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m4a
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ M2 + o2 * abs(C1 - C2) + log(C1) + (1 | 
        id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                         Mean     SD      2.5%   97.5% tail-prob. GR-crit MCE/SD
    M22              -0.00526  0.640 -1.25e+00  0.9174     0.9333    3.33  0.344
    M23               1.30809  0.462  6.31e-01  2.2502     0.0000    1.31  0.339
    M24              -0.14883  0.658 -1.32e+00  0.9383     0.6667    1.73  0.327
    abs(C1 - C2)      0.48700  0.453 -1.58e-01  1.3930     0.3333    2.00  0.234
    log(C1)          -9.54460 13.908 -4.29e+01 11.0232     0.5333    1.50  0.158
    o22               1.64554  0.409  9.74e-01  2.4611     0.0000    2.59  0.316
    o23              -0.99687  0.770 -2.28e+00  0.0282     0.0667    4.58  0.331
    o24              -0.20990  0.373 -8.94e-01  0.2778     0.8000    5.34  0.306
    o22:abs(C1 - C2) -0.82341  0.413 -1.39e+00 -0.0826     0.0667    5.18  0.643
    o23:abs(C1 - C2) -0.09794  0.584 -1.33e+00  0.8158     0.7333    3.18  0.276
    o24:abs(C1 - C2)  0.51669  0.309  3.25e-04  1.0414     0.0667    4.39  0.412
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.547 0.166  0.267  0.805          0    1.49       
    o1 > 2 -1.800 0.228 -2.228 -1.375          0    1.72  0.302
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 3.38 2.57 1.36  10.2               2.25  0.183
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m4b
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ ifelse(as.numeric(o2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1) + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
    
    Posterior summary:
                                                                  Mean     SD
    abs(C1 - C2)                                                0.3851  0.351
    log(C1)                                                    -4.2947 10.427
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)              -0.0444  0.516
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.1989  0.350
                                                                  2.5%  97.5%
    abs(C1 - C2)                                                -0.161  1.053
    log(C1)                                                    -25.585 13.237
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)               -0.954  0.943
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.860  0.358
                                                               tail-prob. GR-crit
    abs(C1 - C2)                                                    0.133    1.95
    log(C1)                                                         0.533    2.06
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)                   0.733    3.81
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)      0.533    5.48
                                                               MCE/SD
    abs(C1 - C2)                                                0.240
    log(C1)                                                     0.183
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)               0.469
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.682
    
    Posterior summary of the intercepts:
             Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.786 0.175  0.478  1.08          0    1.33       
    o1 > 2 -1.347 0.202 -1.737 -1.05          0    2.38  0.293
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1]  2.6 1.41 1.08  6.62               3.73  0.514
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m4c
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ time + c1 + C1 + B2 + (c1 * time | id), 
        data = longDF, n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
    
    Posterior summary:
             Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    C1   -1.53876 3.9265 -9.0428 4.8426      0.733    2.20  0.183
    B21  -0.00398 0.1204 -0.2099 0.1746      0.933    7.20  0.470
    time  0.00575 0.0291 -0.0438 0.0513      0.867    1.32  0.183
    c1   -0.02753 0.0936 -0.1571 0.1843      0.667    1.62  0.224
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.715 0.150  0.508  1.089          0    4.30  0.431
    o1 > 2 -1.036 0.132 -1.219 -0.809          0    1.81  0.191
    
    Posterior summary of random effects covariance matrix:
                     Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1]  0.21703 0.0749  0.1156 0.3605               6.86  0.497
    D_o1_id[1,2] -0.01290 0.0301 -0.0561 0.0378      0.667    2.34  0.338
    D_o1_id[2,2]  0.29215 0.1014  0.1485 0.4405               8.12  0.496
    D_o1_id[1,3]  0.01579 0.0394 -0.0674 0.0743      0.667    2.96  0.405
    D_o1_id[2,3]  0.03883 0.0521 -0.0522 0.1269      0.467    4.14  0.506
    D_o1_id[3,3]  0.19099 0.0609  0.1137 0.3420               5.73  0.183
    D_o1_id[1,4] -0.01079 0.0515 -0.1177 0.0483      0.933    5.47  0.398
    D_o1_id[2,4]  0.00333 0.0370 -0.0846 0.0563      0.800    4.39  0.411
    D_o1_id[3,4]  0.02268 0.0481 -0.0424 0.1195      0.667    6.30  0.375
    D_o1_id[4,4]  0.20850 0.0970  0.1041 0.3884              15.02  0.460
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m4d
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ C1 * time + I(time^2) + b2 * c1, data = longDF, 
        random = ~time | id, n.adapt = 5, n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                 Mean     SD     2.5% 97.5% tail-prob. GR-crit MCE/SD
    C1        -1.6238 5.2597 -10.7790 7.194      0.867    1.57  0.207
    time       0.1414 0.2114  -0.1892 0.538      0.467    6.12  0.546
    I(time^2) -0.0243 0.0212  -0.0582 0.012      0.267    3.20  0.208
    b21        0.7590 0.3409   0.1452 1.351      0.000    2.25  0.307
    c1        -0.0993 0.2198  -0.4686 0.293      0.533    3.78  0.513
    C1:time   -0.0523 0.1441  -0.2995 0.182      0.800    6.17  0.486
    b21:c1     0.1787 0.8221  -1.3528 1.488      0.600    5.59  0.532
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.654 0.213  0.309  0.931          0    2.83  0.448
    o1 > 2 -1.198 0.210 -1.601 -0.792          0    2.46  0.225
    
    Posterior summary of random effects covariance matrix:
                   Mean     SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 0.5473 0.1589  0.2819 0.826               4.33  0.451
    D_o1_id[1,2] 0.0355 0.0541 -0.0376 0.155      0.533    1.48  0.183
    D_o1_id[2,2] 0.3865 0.0816  0.2753 0.574               2.82  0.452
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m4e
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + log(time) + I(time^2) + p1, data = longDF, 
        random = ~1 | id, n.adapt = 5, n.iter = 10, shrinkage = "ridge", 
        seed = 2020, parallel = TRUE, n.cores = 2)
    
    
    Posterior summary:
                   Mean      SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    C1        -13.13167 11.6225 -34.3063 5.9082     0.1333    1.99 0.2538
    log(time)  -0.18944  0.1187  -0.4239 0.0111     0.0667    1.91 0.2270
    I(time^2)  -0.00569  0.0184  -0.0361 0.0259     0.6667    2.16 0.2182
    p1         -0.04731  0.0462  -0.1328 0.0340     0.4000    1.01 0.0665
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.762 0.230  0.376  1.116          0    4.11  0.358
    o1 > 2 -1.236 0.208 -1.612 -0.866          0    1.07  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 1.61 0.673 0.638  3.12               2.23  0.345
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m5a
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + C2 + b2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~C1 + C2 + b2), seed = 2020)
    
    
    Posterior summary:
               Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    O22       0.184  0.425  -0.658  0.744     0.6000    3.27  0.411
    O23       0.429  0.398  -0.310  1.116     0.4000    4.15  0.300
    o12: C1  -7.526 12.233 -26.300 15.403     0.6000    4.25  0.357
    o12: C2  -0.129  0.296  -0.802  0.277     0.6667    2.97  0.270
    o13: C1  -7.743 10.259 -26.655 11.844     0.4667    2.67  0.379
    o13: C2  -0.459  0.279  -1.020 -0.134     0.0000    2.17  0.305
    o12: b21  0.921  0.569  -0.047  1.669     0.0667    2.31  0.330
    o13: b21  0.797  0.377   0.200  1.364     0.0000    2.13  0.250
    
    Posterior summary of the intercepts:
             Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.499 0.324  0.0626  1.10     0.0667    6.93  0.708
    o1 > 2 -1.706 0.282 -2.1374 -1.21     0.0000    6.58  0.685
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 2.68 1.33 1.21  5.85               1.09  0.288
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m5b
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), seed = 2020)
    
    
    Posterior summary:
              Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    M22      0.546 0.928 -1.0825 2.663      0.400    2.34  0.232
    M23      1.483 0.899 -0.2118 2.837      0.133    2.30  0.183
    M24     -0.307 0.580 -1.1012 0.716      0.467    2.80  0.236
    O22     -0.155 0.786 -1.7746 1.105      0.933    1.10  0.183
    O23      0.326 0.831 -0.7333 2.177      0.867    1.47  0.190
    o12: C2  0.168 0.284 -0.4347 0.564      0.533    1.24  0.222
    o13: C2 -0.209 0.327 -0.8501 0.360      0.600    2.04  0.420
    c1:C2    0.704 0.359  0.1288 1.287      0.000    3.10  0.455
    o12: c1  0.356 0.304 -0.0776 0.941      0.267    3.75  0.509
    o13: c1  0.853 0.309  0.3100 1.284      0.000    6.21  0.641
    
    Posterior summary of the intercepts:
             Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.446 0.354 -0.143  1.18      0.267    5.76  0.491
    o1 > 2 -1.836 0.480 -2.506 -1.14      0.000    6.05  0.572
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 3.62 2.67 1.49  10.1               5.17  0.387
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m5c
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 * C2), seed = 2020)
    
    
    Posterior summary:
                  Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    M22        -0.0296 0.779 -1.757 1.123      0.933    2.26  0.306
    M23         0.6030 0.796 -0.804 1.968      0.467    3.79  0.299
    M24        -0.0738 0.797 -1.364 1.290      0.933    3.14  0.231
    O22         0.0361 1.055 -1.737 1.645      0.800    6.35  0.644
    O23         0.2575 0.899 -1.152 1.708      0.733    4.29  0.430
    o12: C2     0.1732 0.457 -0.417 0.971      1.000    5.31  0.564
    o13: C2    -0.4050 0.458 -1.144 0.293      0.600    9.39  0.340
    o12: c1     0.0553 0.433 -0.619 0.779      0.867    6.83  0.412
    o12: c1:C2  0.3043 0.590 -0.384 1.297      0.867   10.32  0.434
    o13: c1     0.6320 0.559 -0.406 1.333      0.200    6.90  0.739
    o13: c1:C2  0.4471 0.655 -0.549 1.267      0.667   13.27  0.572
    
    Posterior summary of the intercepts:
             Mean    SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.745 0.645 -0.00839  1.753     0.0667    19.0  0.663
    o1 > 2 -1.632 0.734 -2.61513 -0.456     0.0000     9.4  0.636
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 3.66 2.59 0.884  9.26               1.38  0.289
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m5d
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), seed = 2020)
    
    
    Posterior summary:
               Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    M22     -1.5553 2.039 -5.7690 0.946      0.467    8.03  0.924
    M23      2.2866 1.636 -0.5098 4.632      0.267    4.59  0.338
    M24     -0.1965 0.829 -1.4839 1.541      0.733    2.11  0.183
    O22      0.1726 0.778 -0.9890 1.796      0.933    1.26  0.183
    O23     -0.2592 0.985 -2.2908 1.707      0.667    2.30  0.183
    M22:C2  -1.2446 1.310 -3.8666 0.664      0.333    2.22  0.400
    M23:C2   0.9104 0.804 -0.2931 2.517      0.333    1.25  0.183
    M24:C2   0.7360 0.795 -0.7711 2.060      0.333    1.92  0.383
    o12: C2 -0.0868 0.458 -0.9196 0.469      0.933   10.77  0.634
    o13: C2 -0.5492 0.430 -1.0907 0.195      0.400    8.70  0.620
    o12: c1 -0.0997 0.190 -0.3772 0.265      0.467    2.81  0.300
    o13: c1  0.4024 0.254 -0.0206 0.851      0.133    2.29  0.257
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.916 0.552  0.283  1.874          0    12.8  0.503
    o1 > 2 -1.435 0.661 -2.217 -0.235          0    10.2  0.538
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 4.62 2.69 1.13  10.8               2.07  0.249
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m5e
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = ~c1 + M2 * C2 + O2, seed = 2020)
    
    
    Posterior summary:
                   Mean    SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    o12: M22    -0.1058 0.429 -0.77778  0.715     0.8000    1.78  0.408
    o12: M23     0.9376 0.600  0.04404  2.229     0.0667    2.86  0.505
    o12: M24     0.2856 0.565 -0.47992  1.216     0.7333    9.65  0.848
    o12: C2     -0.3765 0.469 -1.22030  0.367     0.5333    4.26  0.363
    o12: O22     0.0392 0.371 -0.48162  0.863     1.0000    1.49  0.343
    o12: O23     0.3725 0.361 -0.11380  1.051     0.2000    1.27  0.302
    o12: M22:C2 -0.1338 0.699 -1.17077  1.068     0.9333    4.55  0.379
    o12: M23:C2  0.5311 0.445  0.00123  1.413     0.0667    2.50  0.534
    o12: M24:C2  1.0258 0.471  0.36162  1.829     0.0000    5.87  0.525
    o13: M22    -1.8496 0.506 -2.51992 -1.044     0.0000    6.19  0.478
    o13: M23    -0.1669 0.515 -0.80856  0.792     0.8000    3.56  0.487
    o13: M24    -0.3748 0.815 -1.47428  1.212     0.8000    5.22  1.086
    o13: C2      0.6089 0.388  0.00686  1.541     0.0667    1.78  0.312
    o13: O22    -0.6497 0.278 -1.18705 -0.122     0.0000    1.05  0.270
    o13: O23     0.0349 0.317 -0.47750  0.612     0.8667    1.66  0.421
    o13: M22:C2 -1.8605 0.555 -2.83323 -0.836     0.0000    1.68  0.460
    o13: M23:C2 -1.2268 0.527 -2.07062 -0.209     0.0000    3.52  0.492
    o13: M24:C2 -0.1221 0.634 -0.99240  1.182     0.7333    2.31  0.329
    o12: c1     -0.1933 0.205 -0.57503  0.172     0.4000    2.41  0.212
    o13: c1      0.1289 0.199 -0.29235  0.391     0.3333    1.63  0.217
    
    Posterior summary of the intercepts:
             Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.349 0.228  0.0525 0.792     0.0667    3.28  0.606
    o1 > 2 -0.177 0.545 -1.0446 0.736     0.8000    5.97  1.047
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 1.32 0.322 0.87  1.87                1.4  0.302
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m6a
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + C2 + b2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~C1 + C2 + b2), rev = "o1", seed = 2020)
    
    
    Posterior summary:
                Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    O22      -0.1472  0.370  -0.732  0.425      0.667    3.88  0.546
    O23      -0.3395  0.338  -0.928  0.233      0.400    1.12  0.183
    o12: C1   0.8533 10.540 -16.191 20.291      1.000    2.16  0.313
    o12: C2  -0.0885  0.270  -0.593  0.353      0.867    2.86  0.262
    o13: C1   0.1936 11.473 -21.824 20.924      0.933    1.86  0.226
    o13: C2   0.3390  0.311  -0.170  0.858      0.333    5.20  0.358
    o12: b21 -1.0304  0.690  -2.427  0.340      0.133    3.46  0.303
    o13: b21 -1.4203  0.634  -2.248 -0.111      0.000    3.93  0.339
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 = 1 -0.549 0.219 -0.993 -0.139          0   1.549  0.228
    o1 = 2  1.774 0.255  1.386  2.297          0   0.962  0.221
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 1.95 0.755 0.893  3.46               1.45  0.269
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m6b
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), rev = "o1", seed = 2020)
    
    
    Posterior summary:
               Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    M22      0.0839 0.934 -1.411  1.586      0.733    2.22  0.313
    M23     -1.3863 0.981 -2.991  0.537      0.200    1.41  0.183
    M24      0.2340 0.996 -0.893  2.666      1.000    3.99  0.386
    O22     -0.1427 0.765 -1.674  0.904      1.000    1.65  0.183
    O23     -0.3998 0.691 -1.782  0.534      0.667    1.78  0.232
    o12: C2  0.0734 0.415 -0.583  0.783      0.933    6.65  0.648
    o13: C2  0.3106 0.579 -0.537  1.264      0.667    9.36  0.807
    c1:C2   -0.6871 0.310 -1.205 -0.170      0.000    2.33  0.295
    o12: c1 -0.3125 0.290 -0.916  0.145      0.467    2.54  0.530
    o13: c1 -0.9133 0.327 -1.414 -0.427      0.000    3.10  0.414
    
    Posterior summary of the intercepts:
             Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    o1 = 1 -0.392 0.211 -0.842 -0.14          0    2.90  0.340
    o1 = 2  1.941 0.287  1.202  2.34          0    1.98  0.351
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 5.06 3.25 2.16    13               3.49  0.507
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m6c
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 * C2), rev = "o1", seed = 2020)
    
    
    Posterior summary:
                  Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    M22         0.1563 0.743 -1.131 1.5374      0.800    2.48  0.447
    M23        -0.8343 0.763 -2.389 0.3292      0.267    2.65  0.251
    M24         0.3299 0.663 -0.544 1.5585      0.867    1.48  0.183
    O22        -0.0467 0.560 -0.836 1.0697      0.800    1.35  0.183
    O23        -0.3974 0.584 -1.320 0.6411      0.533    1.15  0.183
    o12: C2     0.0220 0.302 -0.450 0.6252      1.000    2.43  0.342
    o13: C2     0.3752 0.270 -0.170 0.8155      0.200    1.66  0.240
    o12: c1    -0.2344 0.304 -0.695 0.2959      0.467    1.32  0.183
    o12: c1:C2 -0.4603 0.278 -0.851 0.0513      0.133    1.21  0.354
    o13: c1    -0.6545 0.401 -1.183 0.1924      0.267    3.76  0.405
    o13: c1:C2 -0.3085 0.559 -0.975 0.8083      0.667    4.22  0.539
    
    Posterior summary of the intercepts:
             Mean    SD  2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 = 1 -0.628 0.319 -1.12 0.0211      0.133    4.17  0.489
    o1 = 2  1.713 0.279  1.23 2.2736      0.000    3.76  0.367
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 3.62 1.72 1.23  6.59               2.44  0.325
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m6d
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), rev = "o1", seed = 2020)
    
    
    Posterior summary:
               Mean    SD   2.5%   97.5% tail-prob. GR-crit MCE/SD
    M22      1.1381 1.123 -0.964  2.6643     0.4000    2.87 0.2826
    M23     -1.0414 1.256 -3.206  0.6486     0.4667    3.59 0.3747
    M24      0.1994 0.921 -1.498  1.4680     0.8000    2.65 0.0424
    O22     -0.5025 0.818 -2.147  0.6124     0.4667    1.29 0.1826
    O23     -0.6326 0.660 -2.048  0.2929     0.1333    1.20 0.1826
    M22:C2   1.5543 1.090  0.127  3.9141     0.0667    3.77 0.4051
    M23:C2  -0.2764 1.090 -2.484  1.4286     0.8667    1.69 0.3049
    M24:C2  -0.0181 0.928 -1.623  1.3223     0.8667    2.43 0.2959
    o12: C2 -0.2530 0.580 -1.394  0.7230     0.6000    4.35 0.5281
    o13: C2  0.1092 0.476 -0.565  0.8928     0.9333    4.45 0.5166
    o12: c1  0.1267 0.210 -0.143  0.4601     0.7333    2.26 0.1826
    o13: c1 -0.3934 0.201 -0.823 -0.0204     0.0000    2.04 0.2186
    
    Posterior summary of the intercepts:
             Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    o1 = 1 -0.656 0.636 -1.601 0.229      0.267    10.9  0.278
    o1 = 2  1.580 0.638  0.636 2.592      0.000    11.1  0.300
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 3.55 2.53 1.54  9.98               1.96  0.232
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m6e
    
    Bayesian cumulative logit mixed model fitted with JointAI
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = ~c1 + M2 * C2 + O2, rev = "o1", seed = 2020)
    
    
    Posterior summary:
                   Mean    SD    2.5%   97.5% tail-prob. GR-crit MCE/SD
    o12: M22    -0.1932 0.730 -1.3807  0.7917     1.0000    7.02  0.412
    o12: M23     0.1425 0.360 -0.3924  0.9025     0.7333    2.94  0.382
    o12: M24     0.5289 0.992 -0.8098  1.9964     0.6667    9.01  0.742
    o12: C2      0.2384 0.878 -0.8626  1.7435     0.8667   12.11  0.588
    o12: O22    -0.7293 0.430 -1.5395 -0.0159     0.0667    5.66  0.475
    o12: O23    -0.9123 0.420 -1.5617 -0.1931     0.0000    6.37  0.546
    o12: M22:C2 -0.6819 0.590 -1.6678  0.0312     0.1333    7.64  0.709
    o12: M23:C2 -0.2823 1.188 -1.8425  1.5141     0.6667    9.73  0.693
    o12: M24:C2 -0.0770 1.059 -1.7434  1.6616     0.8000    8.01  0.561
    o13: M22     1.4189 0.731 -0.0371  2.2616     0.0667    5.05  0.439
    o13: M23     0.6105 0.490 -0.3347  1.3933     0.3333    2.49  0.434
    o13: M24     0.2247 0.939 -1.2619  1.7233     0.9333    6.24  0.649
    o13: C2      0.3278 0.275 -0.1066  0.6866     0.4000    8.39  0.389
    o13: O22     0.0057 0.255 -0.3880  0.4623     1.0000    1.25  0.183
    o13: O23    -0.4328 0.602 -1.4595  0.3809     0.6000    3.92  0.505
    o13: M22:C2  0.4245 0.293 -0.1485  0.8955     0.2000    2.62  0.223
    o13: M23:C2  0.3964 1.008 -0.9005  2.0058     0.8667   11.69  0.673
    o13: M24:C2 -0.4602 0.650 -1.6858  0.6151     0.3333    2.26  0.282
    o12: c1      0.1556 0.247 -0.2945  0.5233     0.6000    1.79  0.366
    o13: c1     -0.2315 0.237 -0.6447  0.1587     0.4000    2.25  0.207
    
    Posterior summary of the intercepts:
             Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    o1 = 1 -0.206 0.500 -1.124 0.496      0.667   10.16  0.741
    o1 = 2  0.894 0.313  0.267 1.202      0.000    4.42  0.407
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 1.74 0.579 0.906  2.64               1.67  0.521
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m7a
    
    Bayesian linear mixed model fitted with JointAI
    
    Call:
    lme_imp(fixed = y ~ C1 + o1 + o2 + x + time, data = longDF, random = ~1 | 
        id, n.adapt = 5, n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                   Mean     SD      2.5%  97.5% tail-prob. GR-crit MCE/SD
    (Intercept)  30.608 21.071   -5.5655 75.887     0.2000   1.155  0.183
    C1          -50.916 28.485 -113.7580 -2.132     0.0667   1.187  0.183
    o1.L          0.921  0.529   -0.0975  1.650     0.1333   2.263  0.426
    o1.Q          0.406  0.557   -0.5339  1.312     0.6000   3.152  0.210
    o22           0.312  0.606   -0.6615  1.368     0.6667   0.969  0.183
    o23           0.849  0.534   -0.0122  1.859     0.0667   1.680  0.283
    o24          -2.348  0.743   -3.5645 -0.951     0.0000   3.271  0.463
    x2            0.889  0.820   -0.6545  2.040     0.4000   6.335  0.593
    x3           -0.245  1.064   -2.4234  1.298     1.0000   4.141  0.389
    x4            0.130  1.241   -2.0987  1.864     1.0000   4.589  0.511
    time         -1.644  0.217   -1.9650 -1.307     0.0000   1.108  0.362
    
    Posterior summary of random effects covariance matrix:
                Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_y_id[1,1] 17.6 4.15 12.4  26.2               1.11  0.152
    
    Posterior summary of residual std. deviation:
            Mean    SD 2.5% 97.5% GR-crit MCE/SD
    sigma_y  4.3 0.254 3.96  4.83    1.24  0.183
    
    
    MCMC settings:
    Iterations = 6:15
    Sample size per chain = 10 
    Thinning interval = 1 
    Number of chains = 3 
    
    Number of observations: 329 
    Number of groups:
     - id: 100
    
    $m7b
    
    Bayesian linear mixed model fitted with JointAI
    
    Call:
    lme_imp(fixed = y ~ o2 + o1 + c2 + b2, data = longDF, random = ~1 | 
        id, n.adapt = 5, n.iter = 10, seed = 2020)
    
    
    Posterior summary:
                   Mean    SD    2.5%   97.5% tail-prob. GR-crit MCE/SD
    (Intercept) -11.635 0.756 -13.023 -10.242      0.000    1.12  0.159
    o22           0.921 0.784  -0.511   2.209      0.200    2.36  0.738
    o23           0.900 0.652  -0.419   1.937      0.200    1.43  0.187
    o24          -2.049 0.662  -3.173  -0.910      0.000    2.33  0.226
    o1.L          1.212 0.546   0.337   2.048      0.000    1.43  0.183
    o1.Q          0.364 0.500  -0.388   1.192      0.533    1.21  0.183
    c2           -4.291 3.173  -9.119   1.449      0.133    1.27  0.229
    b21          -0.937 0.955  -2.331   0.444      0.333    1.45  0.454
    
    Posterior summary of random effects covariance matrix:
                Mean  SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_y_id[1,1] 17.5 4.2 12.6  26.1                2.2  0.451
    
    Posterior summary of residual std. deviation:
            Mean    SD 2.5% 97.5% GR-crit MCE/SD
    sigma_y 4.78 0.216 4.44  5.27    1.09  0.183
    
    
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
    $m0a$o1
         Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    
    
    $m0b
    $m0b$o2
         Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    
    
    $m1a
    $m1a$o1
           Mean       SD      2.5%    97.5% tail-prob.  GR-crit    MCE/SD
    C1 -15.9451 15.19643 -47.68553 6.968488  0.3333333 1.633862 0.3356175
    
    
    $m1b
    $m1b$o2
            Mean       SD     2.5%   97.5% tail-prob.  GR-crit    MCE/SD
    C1 -5.599512 14.49558 -36.1838 17.0712        0.8 1.401766 0.2148355
    
    
    $m1c
    $m1c$o1
             Mean        SD       2.5%     97.5% tail-prob.  GR-crit    MCE/SD
    c1 0.02665475 0.1944797 -0.2430641 0.3630849  0.9333333 1.296198 0.2407498
    
    
    $m1d
    $m1d$o2
           Mean        SD       2.5%      97.5% tail-prob.  GR-crit    MCE/SD
    c1 -0.21556 0.1783272 -0.5246251 0.05635831  0.1333333 1.402305 0.1825742
    
    
    $m2a
    $m2a$o1
             Mean        SD       2.5%     97.5% tail-prob.  GR-crit    MCE/SD
    C2 -0.2475899 0.3307392 -0.7399117 0.3216636  0.4666667 3.244983 0.2922974
    
    
    $m2b
    $m2b$o2
            Mean        SD       2.5%     97.5% tail-prob.  GR-crit    MCE/SD
    C2 0.2500689 0.2779541 -0.3724619 0.7400229        0.2 1.356943 0.3163107
    
    
    $m2c
    $m2c$o1
          Mean       SD      2.5%     97.5% tail-prob.  GR-crit    MCE/SD
    c2 -1.1454 1.286736 -3.659169 0.4008031        0.2 1.182637 0.1825742
    
    
    $m2d
    $m2d$o2
           Mean       SD      2.5%    97.5% tail-prob.  GR-crit    MCE/SD
    c2 1.352717 1.589423 -1.232327 3.990707  0.4666667 2.301712 0.4879875
    
    
    $m3a
    $m3a$c1
                       Mean          SD         2.5%     97.5% tail-prob.  GR-crit
    (Intercept) -0.49823890 29.79933958 -38.41008748 38.141325  0.3333333 1.632474
    o1.L         0.01604904  0.07858663  -0.13578520  0.144816  0.9333333 1.241972
    o1.Q         0.10146012  0.08194810  -0.07729913  0.230482  0.1333333 1.904318
                   MCE/SD
    (Intercept) 0.1825742
    o1.L        0.2196639
    o1.Q        0.1825742
    
    
    $m3b
    $m3b$c1
                       Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    (Intercept)  0.27892987 0.1109155  0.1093443 0.4461342  0.0000000 8.376186
    o22          0.01344824 0.1363739 -0.2071233 0.3197796  1.0000000 4.025754
    o23         -0.09256567 0.1642682 -0.3149814 0.1535758  0.7333333 7.879450
    o24         -0.05862995 0.1466349 -0.3286544 0.1810937  0.6666667 6.707234
                   MCE/SD
    (Intercept) 0.5732165
    o22         0.3928232
    o23         0.6139638
    o24         0.5561568
    
    
    $m4a
    $m4a$o1
                             Mean         SD          2.5%       97.5% tail-prob.
    M22              -0.005263968  0.6402583 -1.249252e+00  0.91740547 0.93333333
    M23               1.308090267  0.4617777  6.313427e-01  2.25018331 0.00000000
    M24              -0.148827612  0.6578341 -1.320427e+00  0.93834987 0.66666667
    abs(C1 - C2)      0.486997818  0.4527346 -1.576040e-01  1.39296398 0.33333333
    log(C1)          -9.544603430 13.9075541 -4.292229e+01 11.02316414 0.53333333
    o22               1.645537623  0.4093034  9.738293e-01  2.46106485 0.00000000
    o23              -0.996869673  0.7702668 -2.283943e+00  0.02821279 0.06666667
    o24              -0.209898147  0.3729034 -8.940740e-01  0.27777986 0.80000000
    o22:abs(C1 - C2) -0.823411662  0.4134985 -1.391606e+00 -0.08260987 0.06666667
    o23:abs(C1 - C2) -0.097940452  0.5838533 -1.328644e+00  0.81580133 0.73333333
    o24:abs(C1 - C2)  0.516686864  0.3089197  3.249182e-04  1.04136294 0.06666667
                      GR-crit    MCE/SD
    M22              3.328295 0.3437551
    M23              1.309749 0.3387917
    M24              1.730665 0.3274677
    abs(C1 - C2)     2.000120 0.2338926
    log(C1)          1.501779 0.1578298
    o22              2.588689 0.3157628
    o23              4.580708 0.3314112
    o24              5.343347 0.3055060
    o22:abs(C1 - C2) 5.180885 0.6427547
    o23:abs(C1 - C2) 3.177022 0.2761185
    o24:abs(C1 - C2) 4.386574 0.4124009
    
    
    $m4b
    $m4b$o1
                                                                      Mean
    abs(C1 - C2)                                                0.38512927
    log(C1)                                                    -4.29474837
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)              -0.04439108
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2) -0.19893228
                                                                       SD
    abs(C1 - C2)                                                0.3514369
    log(C1)                                                    10.4274481
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)               0.5157696
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.3495133
                                                                      2.5%
    abs(C1 - C2)                                                -0.1614070
    log(C1)                                                    -25.5846402
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)               -0.9535282
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.8595235
                                                                    97.5%
    abs(C1 - C2)                                                1.0525813
    log(C1)                                                    13.2373697
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)               0.9433073
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.3579237
                                                               tail-prob.  GR-crit
    abs(C1 - C2)                                                0.1333333 1.950700
    log(C1)                                                     0.5333333 2.056054
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)               0.7333333 3.809751
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.5333333 5.483508
                                                                  MCE/SD
    abs(C1 - C2)                                               0.2403293
    log(C1)                                                    0.1825742
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)              0.4691037
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.6817911
    
    
    $m4c
    $m4c$o1
                 Mean         SD        2.5%      97.5% tail-prob.  GR-crit
    C1   -1.538764362 3.92647118 -9.04281609 4.84257283  0.7333333 2.198802
    B21  -0.003975088 0.12035380 -0.20992774 0.17456705  0.9333333 7.201216
    time  0.005749868 0.02912302 -0.04376344 0.05127424  0.8666667 1.318419
    c1   -0.027526644 0.09364915 -0.15710190 0.18432233  0.6666667 1.623844
            MCE/SD
    C1   0.1825742
    B21  0.4698036
    time 0.1825742
    c1   0.2244349
    
    
    $m4d
    $m4d$o1
                     Mean         SD        2.5%      97.5% tail-prob.  GR-crit
    C1        -1.62380997 5.25972223 -10.7789590 7.19360664  0.8666667 1.568002
    time       0.14140823 0.21144786  -0.1892098 0.53838607  0.4666667 6.115274
    I(time^2) -0.02432388 0.02119263  -0.0581543 0.01204487  0.2666667 3.204231
    b21        0.75903854 0.34094696   0.1452251 1.35078616  0.0000000 2.247848
    c1        -0.09933145 0.21984555  -0.4686095 0.29323738  0.5333333 3.784041
    C1:time   -0.05228622 0.14411350  -0.2994663 0.18173446  0.8000000 6.165287
    b21:c1     0.17871973 0.82209072  -1.3528231 1.48788434  0.6000000 5.587943
                 MCE/SD
    C1        0.2072953
    time      0.5458184
    I(time^2) 0.2076106
    b21       0.3068982
    c1        0.5132124
    C1:time   0.4858655
    b21:c1    0.5323824
    
    
    $m4e
    $m4e$o1
                       Mean          SD         2.5%      97.5% tail-prob.  GR-crit
    C1        -13.131665834 11.62254650 -34.30626521 5.90815379 0.13333333 1.992818
    log(time)  -0.189439645  0.11872442  -0.42387330 0.01113377 0.06666667 1.909586
    I(time^2)  -0.005690086  0.01838242  -0.03605464 0.02591907 0.66666667 2.159819
    p1         -0.047310981  0.04616614  -0.13279062 0.03402942 0.40000000 1.010626
                  MCE/SD
    C1        0.25378796
    log(time) 0.22699827
    I(time^2) 0.21820029
    p1        0.06645151
    
    
    $m5a
    $m5a$o1
                   Mean         SD         2.5%      97.5% tail-prob.  GR-crit
    O22       0.1836294  0.4253544  -0.65837509  0.7436957 0.60000000 3.267131
    O23       0.4290190  0.3983740  -0.31039894  1.1158065 0.40000000 4.149441
    o12: C1  -7.5261095 12.2332890 -26.29977439 15.4025356 0.60000000 4.251191
    o12: C2  -0.1285198  0.2956602  -0.80206921  0.2772197 0.66666667 2.966897
    o13: C1  -7.7427487 10.2586415 -26.65500072 11.8435094 0.46666667 2.673181
    o13: C2  -0.4594278  0.2789896  -1.01967379 -0.1344532 0.00000000 2.169032
    o12: b21  0.9212371  0.5689634  -0.04702644  1.6685025 0.06666667 2.306415
    o13: b21  0.7969994  0.3772123   0.19988348  1.3636056 0.00000000 2.130295
                MCE/SD
    O22      0.4106025
    O23      0.2995024
    o12: C1  0.3568607
    o12: C2  0.2697198
    o13: C1  0.3786894
    o13: C2  0.3052646
    o12: b21 0.3303697
    o13: b21 0.2504934
    
    
    $m5b
    $m5b$o1
                  Mean        SD        2.5%     97.5% tail-prob.  GR-crit
    M22      0.5459010 0.9278122 -1.08250771 2.6626906  0.4000000 2.344445
    M23      1.4829642 0.8986303 -0.21184890 2.8370495  0.1333333 2.298222
    M24     -0.3073447 0.5800271 -1.10121662 0.7155098  0.4666667 2.797438
    O22     -0.1551100 0.7861070 -1.77461190 1.1049876  0.9333333 1.095329
    O23      0.3261893 0.8306450 -0.73326687 2.1765882  0.8666667 1.470836
    o12: C2  0.1676607 0.2839910 -0.43474837 0.5635401  0.5333333 1.236686
    o13: C2 -0.2094225 0.3265773 -0.85007271 0.3604886  0.6000000 2.041712
    c1:C2    0.7041978 0.3588700  0.12883910 1.2868493  0.0000000 3.104264
    o12: c1  0.3559364 0.3038916 -0.07762887 0.9412268  0.2666667 3.746145
    o13: c1  0.8530636 0.3085489  0.30999642 1.2841030  0.0000000 6.209118
               MCE/SD
    M22     0.2316305
    M23     0.1825742
    M24     0.2361035
    O22     0.1825742
    O23     0.1899997
    o12: C2 0.2219943
    o13: C2 0.4201285
    c1:C2   0.4546228
    o12: c1 0.5091237
    o13: c1 0.6408535
    
    
    $m5c
    $m5c$o1
                      Mean        SD       2.5%     97.5% tail-prob.   GR-crit
    M22        -0.02957264 0.7786757 -1.7567634 1.1231145  0.9333333  2.255762
    M23         0.60297543 0.7958090 -0.8042002 1.9683095  0.4666667  3.787483
    M24        -0.07375422 0.7969344 -1.3637714 1.2899292  0.9333333  3.140478
    O22         0.03610004 1.0552901 -1.7374244 1.6453639  0.8000000  6.354702
    O23         0.25750073 0.8992024 -1.1524928 1.7084294  0.7333333  4.288031
    o12: C2     0.17324100 0.4567501 -0.4172806 0.9713900  1.0000000  5.312875
    o13: C2    -0.40501013 0.4576207 -1.1442435 0.2925439  0.6000000  9.388314
    o12: c1     0.05534847 0.4325872 -0.6191436 0.7785419  0.8666667  6.834352
    o12: c1:C2  0.30429820 0.5898218 -0.3841474 1.2970258  0.8666667 10.316562
    o13: c1     0.63197117 0.5591554 -0.4059535 1.3331337  0.2000000  6.896472
    o13: c1:C2  0.44710225 0.6553441 -0.5485079 1.2667987  0.6666667 13.267745
                  MCE/SD
    M22        0.3059981
    M23        0.2994471
    M24        0.2306674
    O22        0.6442922
    O23        0.4304867
    o12: C2    0.5638793
    o13: C2    0.3395831
    o12: c1    0.4124447
    o12: c1:C2 0.4341143
    o13: c1    0.7388979
    o13: c1:C2 0.5720296
    
    
    $m5d
    $m5d$o1
                   Mean        SD        2.5%     97.5% tail-prob.   GR-crit
    M22     -1.55529997 2.0393252 -5.76902086 0.9459116  0.4666667  8.033302
    M23      2.28657158 1.6361651 -0.50979837 4.6320910  0.2666667  4.589023
    M24     -0.19649635 0.8290849 -1.48388682 1.5410149  0.7333333  2.107697
    O22      0.17261522 0.7778108 -0.98904747 1.7960176  0.9333333  1.264865
    O23     -0.25916610 0.9854319 -2.29079017 1.7070828  0.6666667  2.304659
    M22:C2  -1.24458883 1.3095573 -3.86661828 0.6635921  0.3333333  2.215749
    M23:C2   0.91041882 0.8044885 -0.29306336 2.5171107  0.3333333  1.248102
    M24:C2   0.73603743 0.7946909 -0.77114704 2.0601213  0.3333333  1.916175
    o12: C2 -0.08681346 0.4584891 -0.91960145 0.4685419  0.9333333 10.765106
    o13: C2 -0.54921198 0.4295046 -1.09065370 0.1945582  0.4000000  8.701383
    o12: c1 -0.09966001 0.1902087 -0.37721975 0.2652896  0.4666667  2.809526
    o13: c1  0.40241839 0.2543555 -0.02062636 0.8508289  0.1333333  2.290586
               MCE/SD
    M22     0.9242646
    M23     0.3380689
    M24     0.1825742
    O22     0.1825742
    O23     0.1825742
    M22:C2  0.3999018
    M23:C2  0.1825742
    M24:C2  0.3828764
    o12: C2 0.6341133
    o13: C2 0.6199016
    o12: c1 0.3000841
    o13: c1 0.2568860
    
    
    $m5e
    $m5e$o1
                       Mean        SD         2.5%      97.5% tail-prob.  GR-crit
    o12: M22    -0.10578560 0.4286949 -0.777779700  0.7146560 0.80000000 1.783318
    o12: M23     0.93757711 0.6001549  0.044036610  2.2290055 0.06666667 2.861307
    o12: M24     0.28557202 0.5647659 -0.479924172  1.2156713 0.73333333 9.645197
    o12: C2     -0.37648980 0.4687530 -1.220303896  0.3674405 0.53333333 4.260268
    o12: O22     0.03918135 0.3708233 -0.481623564  0.8628483 1.00000000 1.493905
    o12: O23     0.37247496 0.3611066 -0.113797260  1.0512685 0.20000000 1.265278
    o12: M22:C2 -0.13381483 0.6987907 -1.170771515  1.0677753 0.93333333 4.546068
    o12: M23:C2  0.53113800 0.4453914  0.001228692  1.4127329 0.06666667 2.504917
    o12: M24:C2  1.02582340 0.4711453  0.361616221  1.8290963 0.00000000 5.874302
    o13: M22    -1.84960723 0.5057916 -2.519916897 -1.0442021 0.00000000 6.192026
    o13: M23    -0.16685631 0.5154752 -0.808558583  0.7921731 0.80000000 3.557348
    o13: M24    -0.37477593 0.8150644 -1.474276580  1.2120793 0.80000000 5.218155
    o13: C2      0.60889566 0.3882595  0.006861703  1.5407888 0.06666667 1.780412
    o13: O22    -0.64965883 0.2776600 -1.187045931 -0.1216580 0.00000000 1.048241
    o13: O23     0.03492591 0.3172022 -0.477503322  0.6121450 0.86666667 1.656450
    o13: M22:C2 -1.86051387 0.5548687 -2.833232670 -0.8364812 0.00000000 1.683269
    o13: M23:C2 -1.22675629 0.5270067 -2.070624509 -0.2088185 0.00000000 3.524127
    o13: M24:C2 -0.12208562 0.6343022 -0.992400953  1.1816506 0.73333333 2.310798
    o12: c1     -0.19334338 0.2051179 -0.575025163  0.1722863 0.40000000 2.413391
    o13: c1      0.12886557 0.1993018 -0.292354073  0.3910513 0.33333333 1.625474
                   MCE/SD
    o12: M22    0.4079133
    o12: M23    0.5049831
    o12: M24    0.8479568
    o12: C2     0.3631054
    o12: O22    0.3434131
    o12: O23    0.3019565
    o12: M22:C2 0.3786690
    o12: M23:C2 0.5335468
    o12: M24:C2 0.5245553
    o13: M22    0.4782340
    o13: M23    0.4869192
    o13: M24    1.0857555
    o13: C2     0.3115865
    o13: O22    0.2700883
    o13: O23    0.4211680
    o13: M22:C2 0.4603827
    o13: M23:C2 0.4923647
    o13: M24:C2 0.3291490
    o12: c1     0.2121451
    o13: c1     0.2170585
    
    
    $m6a
    $m6a$o1
                    Mean         SD        2.5%      97.5% tail-prob.  GR-crit
    O22      -0.14721232  0.3701011  -0.7318300  0.4249368  0.6666667 3.882253
    O23      -0.33948969  0.3383801  -0.9279967  0.2332150  0.4000000 1.117218
    o12: C1   0.85327733 10.5395241 -16.1905174 20.2906642  1.0000000 2.157175
    o12: C2  -0.08849219  0.2703404  -0.5930618  0.3534096  0.8666667 2.863575
    o13: C1   0.19356442 11.4731322 -21.8244398 20.9240807  0.9333333 1.864296
    o13: C2   0.33901366  0.3114403  -0.1698474  0.8580139  0.3333333 5.198373
    o12: b21 -1.03036055  0.6896958  -2.4270777  0.3402608  0.1333333 3.461033
    o13: b21 -1.42033391  0.6337065  -2.2482082 -0.1108535  0.0000000 3.929761
                MCE/SD
    O22      0.5458415
    O23      0.1825742
    o12: C1  0.3128385
    o12: C2  0.2623066
    o13: C1  0.2258359
    o13: C2  0.3579910
    o12: b21 0.3027412
    o13: b21 0.3394717
    
    
    $m6b
    $m6b$o1
                   Mean        SD       2.5%      97.5% tail-prob.  GR-crit
    M22      0.08385219 0.9342258 -1.4114783  1.5864729  0.7333333 2.218361
    M23     -1.38626545 0.9814033 -2.9914278  0.5370397  0.2000000 1.407781
    M24      0.23403814 0.9960020 -0.8929366  2.6662874  1.0000000 3.992818
    O22     -0.14272125 0.7649444 -1.6744671  0.9044471  1.0000000 1.646633
    O23     -0.39984959 0.6905616 -1.7824970  0.5339711  0.6666667 1.776315
    o12: C2  0.07344404 0.4151872 -0.5827201  0.7828628  0.9333333 6.649564
    o13: C2  0.31057320 0.5789501 -0.5370176  1.2637743  0.6666667 9.364259
    c1:C2   -0.68710493 0.3104110 -1.2049953 -0.1699491  0.0000000 2.334989
    o12: c1 -0.31246821 0.2896515 -0.9161944  0.1450043  0.4666667 2.543775
    o13: c1 -0.91332611 0.3274443 -1.4136093 -0.4274750  0.0000000 3.099014
               MCE/SD
    M22     0.3131581
    M23     0.1825742
    M24     0.3856033
    O22     0.1825742
    O23     0.2321057
    o12: C2 0.6481644
    o13: C2 0.8068325
    c1:C2   0.2947352
    o12: c1 0.5303399
    o13: c1 0.4136957
    
    
    $m6c
    $m6c$o1
                      Mean        SD       2.5%     97.5% tail-prob.  GR-crit
    M22         0.15628833 0.7434104 -1.1312289 1.5374328  0.8000000 2.476036
    M23        -0.83431238 0.7626075 -2.3892653 0.3291817  0.2666667 2.652479
    M24         0.32986669 0.6627326 -0.5437060 1.5584586  0.8666667 1.483246
    O22        -0.04666314 0.5602675 -0.8360804 1.0696515  0.8000000 1.353125
    O23        -0.39740485 0.5840172 -1.3202774 0.6411357  0.5333333 1.148198
    o12: C2     0.02195033 0.3015181 -0.4504254 0.6252057  1.0000000 2.429835
    o13: C2     0.37523623 0.2703626 -0.1702441 0.8154603  0.2000000 1.662359
    o12: c1    -0.23435661 0.3036328 -0.6954011 0.2959077  0.4666667 1.321044
    o12: c1:C2 -0.46028612 0.2782249 -0.8508832 0.0512646  0.1333333 1.206385
    o13: c1    -0.65448342 0.4013506 -1.1826277 0.1924441  0.2666667 3.760129
    o13: c1:C2 -0.30845149 0.5586191 -0.9746227 0.8083141  0.6666667 4.220274
                  MCE/SD
    M22        0.4473823
    M23        0.2510331
    M24        0.1825742
    O22        0.1825742
    O23        0.1825742
    o12: C2    0.3424751
    o13: C2    0.2401272
    o12: c1    0.1825742
    o12: c1:C2 0.3537803
    o13: c1    0.4049480
    o13: c1:C2 0.5392070
    
    
    $m6d
    $m6d$o1
                  Mean        SD       2.5%      97.5% tail-prob.  GR-crit
    M22      1.1381161 1.1231975 -0.9643052  2.6643462 0.40000000 2.874639
    M23     -1.0413565 1.2556607 -3.2062246  0.6486016 0.46666667 3.586768
    M24      0.1994396 0.9209847 -1.4978526  1.4679641 0.80000000 2.651501
    O22     -0.5024572 0.8177165 -2.1465773  0.6123692 0.46666667 1.288545
    O23     -0.6326255 0.6595665 -2.0477404  0.2929267 0.13333333 1.203431
    M22:C2   1.5543031 1.0897332  0.1274979  3.9141424 0.06666667 3.771726
    M23:C2  -0.2764047 1.0895320 -2.4840751  1.4286055 0.86666667 1.689949
    M24:C2  -0.0181119 0.9281672 -1.6229566  1.3223018 0.86666667 2.432303
    o12: C2 -0.2529793 0.5796459 -1.3944644  0.7229504 0.60000000 4.346389
    o13: C2  0.1092323 0.4763964 -0.5646272  0.8928222 0.93333333 4.447865
    o12: c1  0.1266634 0.2102662 -0.1425695  0.4600998 0.73333333 2.263351
    o13: c1 -0.3934415 0.2009755 -0.8226574 -0.0204390 0.00000000 2.044330
                MCE/SD
    M22     0.28260119
    M23     0.37473183
    M24     0.04241933
    O22     0.18257419
    O23     0.18257419
    M22:C2  0.40508099
    M23:C2  0.30491368
    M24:C2  0.29586807
    o12: C2 0.52811489
    o13: C2 0.51664317
    o12: c1 0.18257419
    o13: c1 0.21863909
    
    
    $m6e
    $m6e$o1
                        Mean        SD        2.5%       97.5% tail-prob.   GR-crit
    o12: M22    -0.193170066 0.7299212 -1.38073062  0.79169083 1.00000000  7.018558
    o12: M23     0.142487389 0.3602276 -0.39242686  0.90248502 0.73333333  2.941139
    o12: M24     0.528866082 0.9918521 -0.80981622  1.99639320 0.66666667  9.009142
    o12: C2      0.238446399 0.8777912 -0.86264689  1.74346396 0.86666667 12.105682
    o12: O22    -0.729331798 0.4298286 -1.53953107 -0.01591025 0.06666667  5.659993
    o12: O23    -0.912318989 0.4204038 -1.56169976 -0.19307932 0.00000000  6.372846
    o12: M22:C2 -0.681944728 0.5896038 -1.66778859  0.03122184 0.13333333  7.640851
    o12: M23:C2 -0.282327932 1.1882007 -1.84250239  1.51413975 0.66666667  9.729900
    o12: M24:C2 -0.076984784 1.0590473 -1.74340928  1.66159271 0.80000000  8.006547
    o13: M22     1.418925340 0.7306333 -0.03708787  2.26157085 0.06666667  5.054567
    o13: M23     0.610512848 0.4897237 -0.33468802  1.39334852 0.33333333  2.487965
    o13: M24     0.224743791 0.9394881 -1.26191940  1.72330284 0.93333333  6.244821
    o13: C2      0.327756315 0.2754149 -0.10661841  0.68664289 0.40000000  8.388568
    o13: O22     0.005700526 0.2545335 -0.38800681  0.46230827 1.00000000  1.247989
    o13: O23    -0.432796059 0.6017938 -1.45948351  0.38085804 0.60000000  3.915695
    o13: M22:C2  0.424456710 0.2932175 -0.14847633  0.89547477 0.20000000  2.621726
    o13: M23:C2  0.396397889 1.0082689 -0.90051248  2.00582791 0.86666667 11.691105
    o13: M24:C2 -0.460192276 0.6496330 -1.68577364  0.61506882 0.33333333  2.258392
    o12: c1      0.155576563 0.2472503 -0.29445736  0.52329911 0.60000000  1.791574
    o13: c1     -0.231475621 0.2370719 -0.64466495  0.15865665 0.40000000  2.251037
                   MCE/SD
    o12: M22    0.4118866
    o12: M23    0.3823722
    o12: M24    0.7421169
    o12: C2     0.5883100
    o12: O22    0.4753385
    o12: O23    0.5464109
    o12: M22:C2 0.7086196
    o12: M23:C2 0.6930202
    o12: M24:C2 0.5606983
    o13: M22    0.4393187
    o13: M23    0.4339471
    o13: M24    0.6492889
    o13: C2     0.3888174
    o13: O22    0.1825742
    o13: O23    0.5046740
    o13: M22:C2 0.2228852
    o13: M23:C2 0.6729567
    o13: M24:C2 0.2823246
    o12: c1     0.3660986
    o13: c1     0.2072822
    
    
    $m7a
    $m7a$y
                       Mean         SD          2.5%      97.5% tail-prob.
    (Intercept)  30.6083349 21.0709377   -5.56553444 75.8866814 0.20000000
    C1          -50.9157354 28.4849066 -113.75801029 -2.1320266 0.06666667
    o1.L          0.9207167  0.5292451   -0.09752605  1.6495140 0.13333333
    o1.Q          0.4063556  0.5570429   -0.53386460  1.3121715 0.60000000
    o22           0.3122119  0.6059388   -0.66146635  1.3679092 0.66666667
    o23           0.8493234  0.5344359   -0.01220589  1.8589265 0.06666667
    o24          -2.3476027  0.7434880   -3.56447295 -0.9512662 0.00000000
    x2            0.8889990  0.8197730   -0.65447669  2.0398297 0.40000000
    x3           -0.2450804  1.0643643   -2.42342853  1.2983296 1.00000000
    x4            0.1299734  1.2413250   -2.09874250  1.8641994 1.00000000
    time         -1.6443213  0.2172503   -1.96500434 -1.3066596 0.00000000
                  GR-crit    MCE/SD
    (Intercept) 1.1550659 0.1825742
    C1          1.1871351 0.1825742
    o1.L        2.2630475 0.4264014
    o1.Q        3.1516202 0.2104738
    o22         0.9686938 0.1825742
    o23         1.6802831 0.2825402
    o24         3.2705232 0.4625365
    x2          6.3346943 0.5928669
    x3          4.1412708 0.3891245
    x4          4.5887630 0.5110309
    time        1.1076296 0.3617653
    
    
    $m7b
    $m7b$y
                       Mean        SD        2.5%       97.5% tail-prob.  GR-crit
    (Intercept) -11.6351246 0.7564174 -13.0227549 -10.2417092  0.0000000 1.119913
    o22           0.9211858 0.7843077  -0.5110718   2.2093744  0.2000000 2.357138
    o23           0.9003031 0.6524022  -0.4192943   1.9372367  0.2000000 1.434216
    o24          -2.0487311 0.6623007  -3.1731308  -0.9097730  0.0000000 2.329820
    o1.L          1.2117087 0.5457132   0.3368099   2.0478916  0.0000000 1.429275
    o1.Q          0.3643813 0.5000975  -0.3879058   1.1918417  0.5333333 1.206021
    c2           -4.2913049 3.1728993  -9.1186841   1.4490554  0.1333333 1.269967
    b21          -0.9370973 0.9546982  -2.3311733   0.4440725  0.3333333 1.454987
                   MCE/SD
    (Intercept) 0.1588429
    o22         0.7377493
    o23         0.1870965
    o24         0.2257541
    o1.L        0.1825742
    o1.Q        0.1825742
    c2          0.2293714
    b21         0.4535319
    
    

