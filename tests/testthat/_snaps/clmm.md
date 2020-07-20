# GRcrit and MCerror give same result

    $m0a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o1[1]        3.43       6.42
    gamma_o1[2]        1.17       1.66
    D_o1_id[1,1]       1.54       2.79
    
    
    $m0b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o2[1]       1.132       1.53
    gamma_o2[2]       0.983       1.10
    gamma_o2[3]       1.010       1.15
    D_o2_id[1,1]      1.152       1.55
    
    
    $m1a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o1[1]        1.06       1.32
    gamma_o1[2]        1.51       2.40
    C1                 1.61       2.79
    D_o1_id[1,1]       1.38       2.58
    
    
    $m1b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o2[1]        1.61       5.07
    gamma_o2[2]        1.57       3.63
    gamma_o2[3]        1.34       2.22
    C1                 1.11       1.59
    D_o2_id[1,1]       2.05       4.28
    
    
    $m1c
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o1[1]        2.10       3.92
    gamma_o1[2]        1.04       1.27
    c1                 1.06       1.32
    D_o1_id[1,1]       2.12       3.69
    
    
    $m1d
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o2[1]       1.469      2.289
    gamma_o2[2]       1.138      1.576
    gamma_o2[3]       1.041      1.267
    c1                0.971      0.998
    D_o2_id[1,1]      1.679      3.110
    
    
    $m2a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o1[1]        3.29       9.39
    gamma_o1[2]        1.79       3.73
    C2                 1.48       2.40
    D_o1_id[1,1]       1.34       1.98
    
    
    $m2b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o2[1]        1.18       1.73
    gamma_o2[2]        1.08       1.39
    gamma_o2[3]        1.00       1.17
    C2                 1.47       2.75
    D_o2_id[1,1]       1.41       3.48
    
    
    $m2c
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o1[1]        1.07       1.34
    gamma_o1[2]        2.55       4.86
    c2                 1.07       1.35
    D_o1_id[1,1]       1.97       4.01
    
    
    $m2d
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    gamma_o2[1]        3.10       6.97
    gamma_o2[2]        2.33       4.38
    gamma_o2[3]        1.18       1.63
    c2                 1.20       1.82
    D_o2_id[1,1]       3.48       6.50
    
    
    $m3a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    (Intercept)       2.770       7.48
    o1.L              1.145       1.96
    o1.Q              1.059       1.46
    sigma_c1          0.994       1.18
    D_c1_id[1,1]      1.334       2.08
    
    
    $m3b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    (Intercept)        2.11       5.36
    o22                1.47       2.39
    o23                1.12       1.66
    o24                1.73       3.16
    sigma_c1           1.10       1.44
    D_c1_id[1,1]       1.01       1.06
    
    
    $m4a
    Potential scale reduction factors:
    
                     Point est. Upper C.I.
    M22                   1.369       2.37
    M23                   1.993       3.63
    M24                   1.158       1.82
    abs(C1 - C2)          1.597       2.61
    log(C1)               1.427       2.30
    o22                   4.011      11.22
    o23                   3.806       8.15
    o24                   8.784      17.15
    o22:abs(C1 - C2)      3.514       9.22
    o23:abs(C1 - C2)      5.234      10.08
    o24:abs(C1 - C2)      4.635      10.97
    gamma_o1[1]           2.689       5.90
    gamma_o1[2]           2.966       6.99
    D_o1_id[1,1]          0.986       1.07
    
    
    $m4b
    Potential scale reduction factors:
    
                                                               Point est.
    abs(C1 - C2)                                                     1.77
    log(C1)                                                          1.25
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)                    2.82
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)       1.89
    gamma_o1[1]                                                      1.83
    gamma_o1[2]                                                      1.77
    D_o1_id[1,1]                                                     3.16
                                                               Upper C.I.
    abs(C1 - C2)                                                     2.91
    log(C1)                                                          2.12
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)                    6.05
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)       3.57
    gamma_o1[1]                                                      3.29
    gamma_o1[2]                                                      4.13
    D_o1_id[1,1]                                                     7.40
    
    
    $m4c
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    C1                 2.65       5.04
    B21                2.65       4.80
    time               2.10       4.27
    c1                 4.75       9.27
    gamma_o1[1]        1.05       1.30
    gamma_o1[2]        1.78       2.95
    D_o1_id[1,1]       5.24      16.97
    D_o1_id[1,2]       3.27       6.65
    D_o1_id[2,2]       3.34       9.85
    D_o1_id[1,3]       6.41      13.51
    D_o1_id[2,3]       5.08       9.89
    D_o1_id[3,3]       1.49       2.88
    D_o1_id[1,4]       2.56       7.70
    D_o1_id[2,4]       2.20       4.23
    D_o1_id[3,4]       3.40       6.52
    D_o1_id[4,4]       3.51       6.99
    
    
    $m4d
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    C1                 1.39       2.14
    time               1.90       4.20
    I(time^2)          1.04       1.28
    b21                1.78       3.60
    c1                 1.15       1.59
    C1:time            2.35       4.70
    b21:c1             1.51       2.54
    gamma_o1[1]        1.19       1.77
    gamma_o1[2]        1.16       1.66
    D_o1_id[1,1]       3.99       8.55
    D_o1_id[1,2]       4.60       9.42
    D_o1_id[2,2]       5.44      28.31
    
    
    $m4e
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    C1                1.627       2.96
    log(time)         1.268       1.87
    I(time^2)         1.416       2.35
    p1                1.037       1.23
    gamma_o1[1]       0.990       0.99
    gamma_o1[2]       0.964       1.05
    D_o1_id[1,1]      3.097       7.94
    
    
    $m5a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    O22                3.13       6.24
    O23                3.18       5.84
    o12: C1            1.76       3.60
    o12: C2            1.85       3.39
    o13: C1            1.44       2.32
    o13: C2            1.80       3.65
    o12: b21           1.32       1.95
    o13: b21           1.60       2.64
    gamma_o1[1]        4.74      13.02
    gamma_o1[2]        4.19       8.62
    D_o1_id[1,1]       1.94       4.07
    
    
    $m5b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    M22                1.29       2.16
    M23                1.56       2.89
    M24                1.70       2.90
    O22                1.02       1.14
    O23                2.07       3.56
    o13: C2            4.34      11.54
    c1:C2              6.19      12.51
    o12: C2            2.73       5.39
    o12: c1            1.18       1.62
    o13: c1            1.32       2.80
    gamma_o1[1]        5.87      18.13
    gamma_o1[2]        4.65       8.88
    D_o1_id[1,1]       1.63       4.01
    
    
    $m5c
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    M22                2.57       5.17
    M23                2.34       4.21
    M24                1.78       3.00
    O22                2.41       5.39
    O23                1.94       4.42
    o12: C2            1.75       3.66
    o13: C2            1.19       1.71
    o12: c1            1.79       3.02
    o12: c1:C2         1.91       3.50
    o13: c1            2.74       5.39
    o13: c1:C2         2.58       4.93
    gamma_o1[1]        3.90      11.67
    gamma_o1[2]        5.62      11.83
    D_o1_id[1,1]       1.12       1.51
    
    
    $m5d
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    M22               2.041       3.83
    M23               1.449       2.28
    M24               1.329       2.09
    O22               1.076       1.36
    O23               1.098       1.45
    M22:C2            1.365       2.34
    M23:C2            2.270       4.83
    M24:C2            3.814       8.32
    o12: C2           4.006       8.18
    o13: C2           3.993      11.59
    o12: c1           0.995       1.11
    o13: c1           1.153       1.65
    gamma_o1[1]       3.686       7.03
    gamma_o1[2]       1.570       2.56
    D_o1_id[1,1]      2.096       3.62
    
    
    $m5e
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    o12: M22           1.76       3.35
    o12: M23           1.08       1.45
    o12: M24           1.24       2.25
    o12: C2            4.72      11.22
    o12: O22           3.14       6.83
    o12: O23           2.04       3.66
    o12: M22:C2        5.37      14.33
    o12: M23:C2        3.69       8.07
    o12: M24:C2        7.50      14.54
    o13: M22           4.27       8.14
    o13: M23           4.60      10.56
    o13: M24           2.62       5.66
    o13: C2            5.29      13.75
    o13: O22           2.85       6.75
    o13: O23           2.32       4.52
    o13: M22:C2        1.54       2.67
    o13: M23:C2        2.68       5.83
    o13: M24:C2        5.35      11.27
    o12: c1            1.24       1.89
    o13: c1            0.98       1.10
    gamma_o1[1]        4.18       9.27
    gamma_o1[2]        2.04       3.50
    D_o1_id[1,1]       4.42       8.33
    
    
    $m6a
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    O22                2.93       5.80
    O23                5.54      11.17
    o12: C1            1.02       1.10
    o12: C2            3.94      10.95
    o13: C1            1.20       1.80
    o13: C2            2.38       4.73
    o12: b21           1.02       1.22
    o13: b21           1.50       3.01
    gamma_o1[1]        4.33       8.69
    gamma_o1[2]        4.09       7.87
    D_o1_id[1,1]       1.25       2.27
    
    
    $m6b
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    M22                1.13       1.50
    M23                1.04       1.26
    M24                1.94       3.77
    O22                1.03       1.26
    O23                1.07       1.36
    o13: C2            4.25       8.07
    c1:C2              2.35       4.13
    o12: C2            2.11       4.24
    o12: c1            1.95       3.36
    o13: c1            2.08       3.62
    gamma_o1[1]        2.10       4.31
    gamma_o1[2]        2.66       4.97
    D_o1_id[1,1]       1.59       3.01
    
    
    $m6c
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    M22               1.178       1.63
    M23               0.968       1.04
    M24               1.027       1.22
    O22               2.697       4.99
    O23               1.123       1.53
    o12: C2           3.449       6.52
    o13: C2           3.563       6.60
    o12: c1           2.316       4.93
    o12: c1:C2        3.744       9.57
    o13: c1           1.506       2.70
    o13: c1:C2        2.304       4.23
    gamma_o1[1]       3.528       6.64
    gamma_o1[2]       3.002       6.23
    D_o1_id[1,1]      1.916       8.45
    
    
    $m6d
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    M22                1.50       2.38
    M23                1.28       2.16
    M24                1.19       1.78
    O22                1.13       1.74
    O23                1.47       3.24
    M22:C2             1.04       1.28
    M23:C2             1.73       3.37
    M24:C2             1.05       1.29
    o12: C2            2.88       6.73
    o13: C2            1.69       3.14
    o12: c1            1.69       2.80
    o13: c1            1.90       3.37
    gamma_o1[1]        5.08      10.71
    gamma_o1[2]        5.10      10.24
    D_o1_id[1,1]       1.43       2.21
    
    
    $m6e
    Potential scale reduction factors:
    
                 Point est. Upper C.I.
    o12: M22           7.67      15.40
    o12: M23           1.61       3.07
    o12: M24           1.28       2.01
    o12: C2            2.90       5.35
    o12: O22           1.22       2.01
    o12: O23           2.80       6.55
    o12: M22:C2        2.17       3.93
    o12: M23:C2        2.43       6.04
    o12: M24:C2        5.30      11.64
    o13: M22           1.39       2.77
    o13: M23           3.41       8.71
    o13: M24           2.69       4.93
    o13: C2            3.88       7.86
    o13: O22           1.72       3.20
    o13: O23           4.26       8.56
    o13: M22:C2        4.22       7.90
    o13: M23:C2        1.08       1.42
    o13: M24:C2        5.48      14.07
    o12: c1            1.60       3.85
    o13: c1            1.33       2.17
    gamma_o1[1]        3.52       6.96
    gamma_o1[2]        3.38       7.34
    D_o1_id[1,1]       1.29       2.26
    
    
    $m7a
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    (Intercept)      0.936      0.952
    C1               0.940      0.964
    o1.L             1.003      1.167
    o1.Q             1.303      2.092
    o22              2.432      5.240
    o23              1.477      2.403
    o24              1.098      1.239
    x2               1.374      2.222
    x3               1.026      1.182
    x4               1.853      3.710
    time             1.178      1.611
    sigma_y          1.282      1.884
    D_y_id[1,1]      1.066      1.303
    
    
    $m7b
    Potential scale reduction factors:
    
                Point est. Upper C.I.
    (Intercept)      1.368       2.24
    o22              1.329       2.40
    o23              1.071       1.22
    o24              1.674       2.81
    o1.L             1.361       2.03
    o1.Q             0.971       1.02
    c2               1.301       2.18
    b21              1.699       2.88
    sigma_y          1.532       2.99
    D_y_id[1,1]      2.143       4.35
    
    

---

    $m0a
                  est  MCSE   SD MCSE/SD
    gamma_o1[1]   0.7 0.114 0.21    0.54
    gamma_o1[2]  -1.2 0.054 0.18    0.31
    D_o1_id[1,1]  1.1 0.046 0.34    0.13
    
    $m0b
                   est  MCSE   SD MCSE/SD
    gamma_o2[1]   1.24 0.030 0.15    0.21
    gamma_o2[2]   0.21 0.031 0.17    0.18
    gamma_o2[3]  -1.09 0.031 0.17    0.18
    D_o2_id[1,1]  0.71 0.068 0.20    0.34
    
    $m1a
                   est  MCSE    SD MCSE/SD
    gamma_o1[1]   0.85 0.045  0.18    0.25
    gamma_o1[2]  -1.19 0.083  0.24    0.34
    C1           -7.93 4.087 12.10    0.34
    D_o1_id[1,1]  1.70 0.270  0.71    0.38
    
    $m1b
                     est MCSE    SD MCSE/SD
    gamma_o2[1]       NA   NA  0.20      NA
    gamma_o2[2]   -0.027 0.11  0.22    0.50
    gamma_o2[3]   -1.429 0.10  0.34    0.30
    C1           -15.130 3.69 16.97    0.22
    D_o2_id[1,1]   2.426 0.63  1.83    0.34
    
    $m1c
                    est  MCSE   SD MCSE/SD
    gamma_o1[1]   0.785 0.043 0.15    0.29
    gamma_o1[2]  -1.198 0.039 0.17    0.23
    c1            0.023 0.031 0.17    0.18
    D_o1_id[1,1]  1.196 0.196 0.37    0.53
    
    $m1d
                   est   MCSE   SD MCSE/SD
    gamma_o2[1]   1.24 0.0717 0.22   0.331
    gamma_o2[2]   0.16 0.0332 0.18   0.183
    gamma_o2[3]  -1.14 0.0415 0.23   0.183
    c1           -0.27 0.0087 0.14   0.061
    D_o2_id[1,1]  1.02 0.1164 0.48   0.245
    
    $m2a
                   est  MCSE   SD MCSE/SD
    gamma_o1[1]   0.76 0.174 0.26    0.67
    gamma_o1[2]  -1.26 0.043 0.23    0.18
    C2           -0.58 0.056 0.31    0.18
    D_o1_id[1,1]  1.75 0.339 0.92    0.37
    
    $m2b
                   est  MCSE   SD MCSE/SD
    gamma_o2[1]   1.28 0.030 0.16    0.18
    gamma_o2[2]   0.21 0.038 0.18    0.21
    gamma_o2[3]  -1.17 0.038 0.21    0.18
    C2            0.26 0.074 0.29    0.26
    D_o2_id[1,1]  1.78 0.546 1.08    0.50
    
    $m2c
                   est  MCSE   SD MCSE/SD
    gamma_o1[1]   0.66 0.052 0.21    0.25
    gamma_o1[2]  -1.22 0.066 0.21    0.31
    c2           -1.12 0.187 1.02    0.18
    D_o1_id[1,1]  1.41 0.306 0.58    0.53
    
    $m2d
                   est  MCSE   SD MCSE/SD
    gamma_o2[1]   1.33 0.122 0.23    0.53
    gamma_o2[2]   0.22 0.048 0.17    0.29
    gamma_o2[3]  -1.12 0.036 0.16    0.23
    c2            0.95 0.381 1.32    0.29
    D_o2_id[1,1]  1.31 0.282 0.54    0.52
    
    $m3a
                     est    MCSE      SD MCSE/SD
    (Intercept)   -7.722   5.264 2.9e+01    0.18
    o1.L           0.030   0.018 9.7e-02    0.18
    o1.Q           0.099   0.017 9.1e-02    0.18
    sigma_c1       0.652   0.010 4.5e-02    0.23
    D_c1_id[1,1] 863.160 583.895 3.2e+03    0.18
    
    $m3b
                    est   MCSE    SD MCSE/SD
    (Intercept)   0.383 0.0642 0.090    0.71
    o22          -0.089 0.0505 0.124    0.41
    o23          -0.220 0.0298 0.113    0.26
    o24          -0.159 0.0657 0.142    0.46
    sigma_c1      0.627 0.0045 0.024    0.18
    D_c1_id[1,1]  0.080 0.0085 0.038    0.22
    
    $m4a
                        est  MCSE    SD MCSE/SD
    M22               0.607 0.119  0.60    0.20
    M23               1.669 0.312  0.87    0.36
    M24               0.546 0.252  0.77    0.33
    abs(C1 - C2)      0.761 0.229  0.67    0.34
    log(C1)          -6.424 2.906 15.92    0.18
    o22               1.271 0.348  0.74    0.47
    o23              -1.077 0.298  0.67    0.44
    o24               0.603 1.008  1.01    0.99
    o22:abs(C1 - C2) -0.686 0.177  0.38    0.46
    o23:abs(C1 - C2) -0.129 0.289  0.42    0.69
    o24:abs(C1 - C2) -0.174 0.512  0.64    0.80
    gamma_o1[1]       0.019 0.130  0.28    0.46
    gamma_o1[2]      -2.477 0.087  0.25    0.34
    D_o1_id[1,1]      4.523 0.568  2.40    0.24
    
    $m4b
                                                                 est  MCSE   SD
    abs(C1 - C2)                                                0.47 0.101 0.26
    log(C1)                                                    -8.85 1.807 9.90
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)              -0.51 0.249 0.61
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.17 0.083 0.33
    gamma_o1[1]                                                 0.49 0.089 0.23
    gamma_o1[2]                                                -1.44 0.091 0.32
    D_o1_id[1,1]                                                2.20 0.633 1.26
                                                               MCSE/SD
    abs(C1 - C2)                                                  0.39
    log(C1)                                                       0.18
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)                 0.41
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)    0.26
    gamma_o1[1]                                                   0.39
    gamma_o1[2]                                                   0.29
    D_o1_id[1,1]                                                  0.50
    
    $m4c
                     est  MCSE    SD MCSE/SD
    C1           -2.4778 0.931 3.296    0.28
    B21           0.0092 0.022 0.068    0.32
    time         -0.0195 0.015 0.049    0.31
    c1            0.0398 0.063 0.125    0.51
    gamma_o1[1]   0.6771 0.022 0.101    0.22
    gamma_o1[2]  -1.0565 0.033 0.141    0.23
    D_o1_id[1,1]  0.1742 0.041 0.099    0.42
    D_o1_id[1,2] -0.0306 0.025 0.035    0.71
    D_o1_id[2,2]  0.1561 0.029 0.055    0.53
    D_o1_id[1,3] -0.0216 0.031 0.055    0.57
    D_o1_id[2,3]  0.0247 0.018 0.043    0.42
    D_o1_id[3,3]      NA    NA 0.033      NA
    D_o1_id[1,4]  0.0105 0.013 0.044    0.29
    D_o1_id[2,4] -0.0141 0.011 0.027    0.40
    D_o1_id[3,4] -0.0112 0.027 0.047    0.57
    D_o1_id[4,4]  0.1965 0.024 0.059    0.41
    
    $m4d
                    est   MCSE    SD MCSE/SD
    C1           -3.244 2.1669 5.477    0.40
    time          0.347 0.0619 0.194    0.32
    I(time^2)    -0.036 0.0029 0.016    0.18
    b21           0.648 0.1570 0.510    0.31
    c1           -0.013 0.0435 0.193    0.23
    C1:time      -0.170 0.0558 0.122    0.46
    b21:c1       -0.104 0.1733 0.539    0.32
    gamma_o1[1]   0.675 0.0292 0.160    0.18
    gamma_o1[2]  -1.196 0.0360 0.197    0.18
    D_o1_id[1,1]  0.370 0.0617 0.120    0.51
    D_o1_id[1,2] -0.041 0.0565 0.109    0.52
    D_o1_id[2,2]  0.432 0.1185 0.196    0.61
    
    $m4e
                     est   MCSE    SD MCSE/SD
    C1           -6.6796 2.5606 7.392    0.35
    log(time)    -0.1074 0.0278 0.114    0.24
    I(time^2)    -0.0076 0.0031 0.014    0.22
    p1           -0.0432 0.0079 0.043    0.18
    gamma_o1[1]   0.7522 0.0721 0.192    0.38
    gamma_o1[2]  -1.1394 0.0546 0.173    0.32
    D_o1_id[1,1]  1.1012 0.1515 0.303    0.50
    
    $m5a
                    est  MCSE    SD MCSE/SD
    O22            0.14 0.293  0.57    0.52
    O23            0.31 0.261  0.61    0.43
    o12: C1      -14.10 4.457  9.62    0.46
    o12: C2       -0.05 0.131  0.33    0.39
    o13: C1      -15.19 3.306 11.72    0.28
    o13: C2       -0.34 0.077  0.26    0.30
    o12: b21       0.70 0.122  0.52    0.23
    o13: b21       0.71 0.075  0.35    0.21
    gamma_o1[1]    0.62 0.416  0.48    0.86
    gamma_o1[2]   -1.58 0.177  0.46    0.38
    D_o1_id[1,1]   2.49 0.555  1.39    0.40
    
    $m5b
                    est  MCSE   SD MCSE/SD
    M22          -0.496 0.230 0.77    0.30
    M23           0.013 0.304 0.69    0.44
    M24          -0.900 0.157 0.69    0.23
    O22           0.293 0.163 0.68    0.24
    O23           0.669 0.211 0.81    0.26
    o13: C2      -0.202 0.224 0.44    0.51
    c1:C2        -0.462 0.126 0.49    0.26
    o12: C2       0.567 0.111 0.40    0.28
    o12: c1       0.254 0.073 0.32    0.23
    o13: c1       0.688 0.070 0.32    0.22
    gamma_o1[1]   0.837 0.239 0.42    0.57
    gamma_o1[2]  -1.385 0.206 0.46    0.45
    D_o1_id[1,1]  3.733 0.915 2.01    0.45
    
    $m5c
                    est  MCSE   SD MCSE/SD
    M22           0.297 0.473 1.01    0.47
    M23           1.207 0.329 0.98    0.34
    M24          -0.463 0.349 0.72    0.48
    O22           0.034 0.405 1.02    0.40
    O23           0.155 0.218 0.66    0.33
    o12: C2       0.064 0.203 0.42    0.48
    o13: C2      -0.325 0.049 0.27    0.18
    o12: c1       0.225 0.190 0.42    0.45
    o12: c1:C2    0.592 0.168 0.34    0.50
    o13: c1       0.931 0.224 0.42    0.53
    o13: c1:C2    0.774 0.225 0.46    0.49
    gamma_o1[1]   0.627 0.373 0.46    0.80
    gamma_o1[2]  -1.787 0.404 0.54    0.75
    D_o1_id[1,1]  3.668 0.468 1.53    0.31
    
    $m5d
                    est  MCSE   SD MCSE/SD
    M22          -0.734 0.660 1.12    0.59
    M23           1.464 0.220 0.99    0.22
    M24          -1.112 0.279 1.11    0.25
    O22           0.612 0.104 0.57    0.18
    O23           0.770 0.116 0.55    0.21
    M22:C2       -0.969 0.324 0.99    0.33
    M23:C2        0.435 0.468 1.11    0.42
    M24:C2       -0.911 0.350 1.40    0.25
    o12: C2       0.288 0.546 0.85    0.64
    o13: C2      -0.100 0.327 0.67    0.49
    o12: c1      -0.086 0.036 0.20    0.18
    o13: c1       0.271 0.053 0.26    0.20
    gamma_o1[1]   0.339 0.138 0.24    0.58
    gamma_o1[2]  -1.900 0.075 0.27    0.28
    D_o1_id[1,1]  3.621 0.830 2.33    0.36
    
    $m5e
                    est  MCSE   SD MCSE/SD
    o12: M22     -0.108 0.257 0.39    0.65
    o12: M23      1.043 0.084 0.61    0.14
    o12: M24      0.141 0.100 0.29    0.34
    o12: C2      -0.070 0.312 0.59    0.52
    o12: O22      0.406 0.290 0.55    0.53
    o12: O23      0.406 0.132 0.37    0.35
    o12: M22:C2  -0.219 0.365 0.70    0.52
    o12: M23:C2   0.432 0.199 0.52    0.38
    o12: M24:C2   0.069 0.591 1.05    0.56
    o13: M22     -1.366 0.442 0.75    0.59
    o13: M23      0.386 0.294 0.55    0.53
    o13: M24     -0.284 0.238 0.47    0.51
    o13: C2       0.468 0.243 0.48    0.51
    o13: O22     -0.678 0.134 0.35    0.38
    o13: O23     -0.062 0.154 0.33    0.47
    o13: M22:C2  -1.586 0.205 0.40    0.51
    o13: M23:C2  -0.986 0.362 0.63    0.58
    o13: M24:C2  -0.579 0.697 0.82    0.85
    o12: c1      -0.179 0.033 0.18    0.18
    o13: c1       0.158 0.043 0.24    0.18
    gamma_o1[1]   0.177 0.291 0.38    0.77
    gamma_o1[2]  -0.584 0.067 0.16    0.43
    D_o1_id[1,1]  1.186 0.238 0.44    0.54
    
    $m6a
                   est  MCSE    SD MCSE/SD
    O22          -0.42 0.279  0.53    0.53
    O23          -0.56 0.286  0.61    0.47
    o12: C1       7.26 2.749 13.64    0.20
    o12: C2       0.12 0.150  0.44    0.34
    o13: C1       1.41 5.568 12.52    0.44
    o13: C2       0.43 0.087  0.29    0.30
    o12: b21     -0.76 0.093  0.42    0.22
    o13: b21     -1.03 0.213  0.44    0.48
    gamma_o1[1]  -0.37 0.191  0.51    0.38
    gamma_o1[2]   1.89 0.268  0.48    0.55
    D_o1_id[1,1]  2.43 0.356  1.17    0.30
    
    $m6b
                   est  MCSE   SD MCSE/SD
    M22           0.84 0.238 0.70    0.34
    M23             NA    NA 0.84      NA
    M24           0.54 0.208 0.60    0.35
    O22          -0.22 0.202 0.67    0.30
    O23          -0.64 0.106 0.45    0.24
    o13: C2       0.30 0.179 0.47    0.38
    c1:C2         0.77 0.200 0.44    0.45
    o12: C2      -0.73 0.189 0.38    0.49
    o12: c1      -0.25 0.091 0.33    0.28
    o13: c1      -0.72 0.105 0.35    0.30
    gamma_o1[1]  -0.84 0.204 0.29    0.71
    gamma_o1[2]   1.41 0.240 0.43    0.56
    D_o1_id[1,1]  3.08 0.944 1.83    0.52
    
    $m6c
                    est  MCSE   SD MCSE/SD
    M22          -0.679 0.356 0.79    0.45
    M23          -1.501 0.106 0.58    0.18
    M24          -0.545 0.073 0.62    0.12
    O22           0.205 0.274 0.53    0.51
    O23          -0.131 0.127 0.55    0.23
    o12: C2      -0.059 0.166 0.36    0.47
    o13: C2       0.331 0.246 0.50    0.49
    o12: c1      -0.274 0.109 0.27    0.40
    o12: c1:C2   -0.568 0.152 0.35    0.44
    o13: c1      -0.745 0.148 0.41    0.36
    o13: c1:C2   -0.562 0.158 0.42    0.37
    gamma_o1[1]  -0.189 0.170 0.27    0.63
    gamma_o1[2]   2.098 0.167 0.35    0.48
    D_o1_id[1,1]  3.575 0.711 2.43    0.29
    
    $m6d
                     est  MCSE   SD MCSE/SD
    M22           0.5595 0.217 0.93    0.23
    M23          -2.1085 0.496 1.46    0.34
    M24          -0.3429 0.400 1.05    0.38
    O22           0.5338 0.142 0.78    0.18
    O23          -0.0085 0.182 0.85    0.21
    M22:C2        0.6585 0.147 0.81    0.18
    M23:C2       -0.7007 0.532 1.40    0.38
    M24:C2       -0.6541 0.249 1.09    0.23
    o12: C2       0.3096 0.170 0.34    0.49
    o13: C2       0.5050 0.180 0.40    0.45
    o12: c1       0.1080 0.046 0.25    0.18
    o13: c1      -0.4283 0.071 0.26    0.27
    gamma_o1[1]  -0.8478 0.142 0.29    0.50
    gamma_o1[2]   1.4881 0.194 0.43    0.45
    D_o1_id[1,1]  4.3880 0.621 2.51    0.25
    
    $m6e
                    est  MCSE   SD MCSE/SD
    o12: M22     -0.474 0.671 0.83    0.81
    o12: M23     -0.873 0.255 0.53    0.48
    o12: M24     -0.204 0.085 0.25    0.33
    o12: C2       0.018 0.180 0.33    0.54
    o12: O22     -0.434 0.084 0.35    0.24
    o12: O23     -0.393 0.165 0.38    0.43
    o12: M22:C2   0.085 0.138 0.31    0.44
    o12: M23:C2  -0.343 0.302 0.57    0.53
    o12: M24:C2  -0.150 0.265 0.59    0.45
    o13: M22      0.838 0.291 0.57    0.51
    o13: M23     -0.213 0.272 0.53    0.51
    o13: M24     -0.267 0.268 0.50    0.54
    o13: C2      -0.249 0.256 0.56    0.45
    o13: O22      0.092 0.076 0.28    0.27
    o13: O23     -0.162 0.199 0.44    0.46
    o13: M22:C2   1.086 0.399 0.76    0.52
    o13: M23:C2   0.763 0.049 0.27    0.18
    o13: M24:C2   0.118 0.676 0.91    0.75
    o12: c1       0.149 0.116 0.33    0.36
    o13: c1      -0.257 0.058 0.24    0.24
    gamma_o1[1]  -0.190 0.163 0.34    0.48
    gamma_o1[2]   1.058 0.121 0.35    0.35
    D_o1_id[1,1]  1.325 0.086 0.28    0.31
    
    $m7a
                    est  MCSE    SD MCSE/SD
    (Intercept)  22.657 4.184 22.92    0.18
    C1          -39.921 5.678 31.10    0.18
    o1.L          0.665 0.086  0.47    0.18
    o1.Q             NA    NA  0.42      NA
    o22           0.964 0.447  0.91    0.49
    o23           1.421 0.168  0.73    0.23
    o24          -1.427 0.149  0.63    0.24
    x2           -1.340 0.178  0.85    0.21
    x3           -0.521 0.096  0.76    0.13
    x4           -0.049 0.256  0.65    0.39
    time         -1.646 0.037  0.20    0.18
    sigma_y       4.379 0.035  0.19    0.18
    D_y_id[1,1]  15.112 0.680  2.96    0.23
    
    $m7b
                   est  MCSE   SD MCSE/SD
    (Intercept) -11.75 0.169 0.93    0.18
    o22           1.81 0.307 0.95    0.32
    o23           1.34 0.147 0.72    0.21
    o24          -1.43 0.312 0.94    0.33
    o1.L          1.01 0.116 0.54    0.21
    o1.Q          0.29 0.091 0.50    0.18
    c2           -2.17 0.538 2.53    0.21
    b21          -0.63 0.197 0.92    0.21
    sigma_y       4.88 0.053 0.23    0.23
    D_y_id[1,1]  15.95 0.996 3.26    0.31
    

# summary output remained the same on Windows

    
    Call:
    clmm_imp(fixed = o1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2 
     0.6993 -1.2467 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.08
    
    
    Call:
    clmm_imp(fixed = o2 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3 
     1.2408  0.2072 -1.0915 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       0.715
    
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2      C1 
     0.8482 -1.1866 -7.9254 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)         1.7
    
    
    Call:
    clmm_imp(fixed = o2 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
       o2 > 1    o2 > 2    o2 > 3        C1 
      1.07547  -0.02682  -1.42852 -15.12993 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.426
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2       c1 
     0.78494 -1.19756  0.02265 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.196
    
    
    Call:
    clmm_imp(fixed = o2 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3      c1 
     1.2447  0.1649 -1.1411 -0.2674 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.019
    
    
    Call:
    clmm_imp(fixed = o1 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2      C2 
     0.7628 -1.2555 -0.5833 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.754
    
    
    Call:
    clmm_imp(fixed = o2 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3      C2 
     1.2805  0.2150 -1.1661  0.2587 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.777
    
    
    Call:
    clmm_imp(fixed = o1 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2      c2 
     0.6586 -1.2227 -1.1162 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.411
    
    
    Call:
    clmm_imp(fixed = o2 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3      c2 
     1.3339  0.2209 -1.1171  0.9525 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.31
    
    
    Call:
    lme_imp(fixed = c1 ~ o1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)        o1.L        o1.Q 
       -7.72209     0.03038     0.09892 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       863.2
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6519 
    
    Call:
    lme_imp(fixed = c1 ~ o2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         o22         o23         o24 
        0.38320    -0.08862    -0.22029    -0.15928 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)     0.07972
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6271 
    
    Call:
    clmm_imp(fixed = o1 ~ M2 + o2 * abs(C1 - C2) + log(C1) + (1 | 
        id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
              o1 > 1           o1 > 2              M22              M23 
             0.01884         -2.47715          0.60691          1.66919 
                 M24     abs(C1 - C2)          log(C1)              o22 
             0.54555          0.76094         -6.42350          1.27119 
                 o23              o24 o22:abs(C1 - C2) o23:abs(C1 - C2) 
            -1.07735          0.60301         -0.68562         -0.12852 
    o24:abs(C1 - C2) 
            -0.17379 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       4.523
    
    
    Call:
    clmm_imp(fixed = o1 ~ ifelse(as.numeric(o2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1) + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
                                                        o1 > 1 
                                                        0.4898 
                                                        o1 > 2 
                                                       -1.4448 
                                                  abs(C1 - C2) 
                                                        0.4729 
                                                       log(C1) 
                                                       -8.8464 
                 ifelse(as.numeric(o2) > as.numeric(M1), 1, 0) 
                                                       -0.5136 
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                        0.1730 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.202
    
    
    Call:
    clmm_imp(fixed = o1 ~ time + c1 + C1 + B2 + (c1 * time | id), 
        data = longDF, n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 > 1    o1 > 2        C1       B21      time        c1 
     0.677072 -1.056545 -2.477847  0.009168 -0.019478  0.039825 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)       c1     time  c1:time
    (Intercept)     0.17423 -0.03059 -0.02163  0.01053
    c1             -0.03059  0.15608  0.02467 -0.01410
    time           -0.02163  0.02467  0.13207 -0.01118
    c1:time         0.01053 -0.01410 -0.01118  0.19646
    
    
    Call:
    clmm_imp(fixed = o1 ~ C1 * time + I(time^2) + b2 * c1, data = longDF, 
        random = ~time | id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 > 1    o1 > 2        C1      time I(time^2)       b21        c1   C1:time 
      0.67529  -1.19597  -3.24406   0.34746  -0.03584   0.64830  -0.01319  -0.16972 
       b21:c1 
     -0.10393 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)     time
    (Intercept)     0.36960 -0.04086
    time           -0.04086  0.43183
    
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + log(time) + I(time^2) + p1, data = longDF, 
        random = ~1 | id, n.adapt = 5, n.iter = 10, shrinkage = "ridge", 
        seed = 2020, parallel = TRUE, n.cores = 2)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 > 1    o1 > 2        C1 log(time) I(time^2)        p1 
      0.75224  -1.13944  -6.67959  -0.10736  -0.00761  -0.04324 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.101
    
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + C2 + b2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~C1 + C2 + b2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 > 1    o1 > 2       O22       O23        C1        C2        C1        C2 
      0.61871  -1.57547   0.14211   0.31010 -14.09667  -0.05035 -15.19261  -0.33644 
          b21       b21 
      0.70279   0.71334 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.485
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2      M22      M23      M24      O22      O23       C2 
     0.83745 -1.38478 -0.49570  0.01298 -0.90016  0.29305  0.66856 -0.20244 
       c1:C2       C2       c1       c1 
    -0.46162  0.56664  0.25443  0.68752 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.733
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 * C2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2      M22      M23      M24      O22      O23       C2 
     0.62708 -1.78749  0.29684  1.20688 -0.46318  0.03442  0.15470  0.06389 
          C2       c1    c1:C2       c1    c1:C2 
    -0.32468  0.22547  0.59153  0.93141  0.77398 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.668
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2      M22      M23      M24      O22      O23   M22:C2 
     0.33891 -1.89959 -0.73381  1.46442 -1.11216  0.61157  0.76958 -0.96941 
      M23:C2   M24:C2       C2       C2       c1       c1 
     0.43525 -0.91095  0.28818 -0.10012 -0.08609  0.27136 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.621
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = ~c1 + M2 * C2 + O2, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2      M22      M23      M24       C2      O22      O23 
     0.17661 -0.58391 -0.10767  1.04315  0.14130 -0.07027  0.40584  0.40623 
      M22:C2   M23:C2   M24:C2      M22      M23      M24       C2      O22 
    -0.21853  0.43156  0.06859 -1.36648  0.38626 -0.28373  0.46839 -0.67836 
         O23   M22:C2   M23:C2   M24:C2       c1       c1 
    -0.06247 -1.58615 -0.98570 -0.57879 -0.17857  0.15796 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.186
    
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + C2 + b2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~C1 + C2 + b2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 = 1  o1 = 2     O22     O23      C1      C2      C1      C2     b21     b21 
    -0.3704  1.8865 -0.4161 -0.5572  7.2638  0.1223  1.4125  0.4304 -0.7647 -1.0330 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.428
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 = 1  o1 = 2     M22     M23     M24     O22     O23      C2   c1:C2      C2 
    -0.8402  1.4122  0.8364 -0.2639  0.5442 -0.2213 -0.6420  0.2959  0.7696 -0.7321 
         c1      c1 
    -0.2507 -0.7241 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.082
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 * C2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 = 1   o1 = 2      M22      M23      M24      O22      O23       C2 
    -0.18940  2.09791 -0.67947 -1.50088 -0.54458  0.20507 -0.13053 -0.05929 
          C2       c1    c1:C2       c1    c1:C2 
     0.33128 -0.27379 -0.56823 -0.74530 -0.56233 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.575
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 = 1    o1 = 2       M22       M23       M24       O22       O23    M22:C2 
    -0.847796  1.488107  0.559481 -2.108465 -0.342857  0.533834 -0.008488  0.658544 
       M23:C2    M24:C2        C2        C2        c1        c1 
    -0.700700 -0.654119  0.309555  0.504960  0.107984 -0.428338 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       4.388
    
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = ~c1 + M2 * C2 + O2, rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 = 1   o1 = 2      M22      M23      M24       C2      O22      O23 
    -0.18987  1.05796 -0.47383 -0.87264 -0.20392  0.01790 -0.43393 -0.39316 
      M22:C2   M23:C2   M24:C2      M22      M23      M24       C2      O22 
     0.08460 -0.34287 -0.15012  0.83802 -0.21290 -0.26745 -0.24928  0.09219 
         O23   M22:C2   M23:C2   M24:C2       c1       c1 
    -0.16224  1.08611  0.76320  0.11786  0.14916 -0.25657 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.325
    
    
    Call:
    lme_imp(fixed = y ~ C1 + o1 + o2 + x + time, data = longDF, random = ~1 | 
        id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "y" 
    
    Fixed effects:
    (Intercept)          C1        o1.L        o1.Q         o22         o23 
       22.65718   -39.92146     0.66513     0.33499     0.96383     1.42085 
            o24          x2          x3          x4        time 
       -1.42700    -1.33973    -0.52115    -0.04887    -1.64584 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       15.11
    
    
    
    Residual standard deviation:
    sigma_y 
      4.379 
    
    Call:
    lme_imp(fixed = y ~ o2 + o1 + c2 + b2, data = longDF, random = ~1 | 
        id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "y" 
    
    Fixed effects:
    (Intercept)         o22         o23         o24        o1.L        o1.Q 
       -11.7470      1.8144      1.3401     -1.4287      1.0068      0.2891 
             c2         b21 
        -2.1701     -0.6315 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       15.95
    
    
    
    Residual standard deviation:
    sigma_y 
      4.885 
    $m0a
    
    Call:
    clmm_imp(fixed = o1 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2 
     0.6993 -1.2467 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.08
    
    
    $m0b
    
    Call:
    clmm_imp(fixed = o2 ~ 1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3 
     1.2408  0.2072 -1.0915 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       0.715
    
    
    $m1a
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2      C1 
     0.8482 -1.1866 -7.9254 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)         1.7
    
    
    $m1b
    
    Call:
    clmm_imp(fixed = o2 ~ C1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
       o2 > 1    o2 > 2    o2 > 3        C1 
      1.07547  -0.02682  -1.42852 -15.12993 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.426
    
    
    $m1c
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2       c1 
     0.78494 -1.19756  0.02265 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.196
    
    
    $m1d
    
    Call:
    clmm_imp(fixed = o2 ~ c1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3      c1 
     1.2447  0.1649 -1.1411 -0.2674 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.019
    
    
    $m2a
    
    Call:
    clmm_imp(fixed = o1 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2      C2 
     0.7628 -1.2555 -0.5833 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.754
    
    
    $m2b
    
    Call:
    clmm_imp(fixed = o2 ~ C2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3      C2 
     1.2805  0.2150 -1.1661  0.2587 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.777
    
    
    $m2c
    
    Call:
    clmm_imp(fixed = o1 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 > 1  o1 > 2      c2 
     0.6586 -1.2227 -1.1162 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.411
    
    
    $m2d
    
    Call:
    clmm_imp(fixed = o2 ~ c2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o2" 
    
    Fixed effects:
     o2 > 1  o2 > 2  o2 > 3      c2 
     1.3339  0.2209 -1.1171  0.9525 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)        1.31
    
    
    $m3a
    
    Call:
    lme_imp(fixed = c1 ~ o1 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)        o1.L        o1.Q 
       -7.72209     0.03038     0.09892 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       863.2
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6519 
    
    $m3b
    
    Call:
    lme_imp(fixed = c1 ~ o2 + (1 | id), data = longDF, n.adapt = 5, 
        n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "c1" 
    
    Fixed effects:
    (Intercept)         o22         o23         o24 
        0.38320    -0.08862    -0.22029    -0.15928 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)     0.07972
    
    
    
    Residual standard deviation:
    sigma_c1 
      0.6271 
    
    $m4a
    
    Call:
    clmm_imp(fixed = o1 ~ M2 + o2 * abs(C1 - C2) + log(C1) + (1 | 
        id), data = longDF, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
              o1 > 1           o1 > 2              M22              M23 
             0.01884         -2.47715          0.60691          1.66919 
                 M24     abs(C1 - C2)          log(C1)              o22 
             0.54555          0.76094         -6.42350          1.27119 
                 o23              o24 o22:abs(C1 - C2) o23:abs(C1 - C2) 
            -1.07735          0.60301         -0.68562         -0.12852 
    o24:abs(C1 - C2) 
            -0.17379 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       4.523
    
    
    $m4b
    
    Call:
    clmm_imp(fixed = o1 ~ ifelse(as.numeric(o2) > as.numeric(M1), 
        1, 0) * abs(C1 - C2) + log(C1) + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
                                                        o1 > 1 
                                                        0.4898 
                                                        o1 > 2 
                                                       -1.4448 
                                                  abs(C1 - C2) 
                                                        0.4729 
                                                       log(C1) 
                                                       -8.8464 
                 ifelse(as.numeric(o2) > as.numeric(M1), 1, 0) 
                                                       -0.5136 
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                        0.1730 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.202
    
    
    $m4c
    
    Call:
    clmm_imp(fixed = o1 ~ time + c1 + C1 + B2 + (c1 * time | id), 
        data = longDF, n.adapt = 5, n.iter = 10, seed = 2020, warn = FALSE)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 > 1    o1 > 2        C1       B21      time        c1 
     0.677072 -1.056545 -2.477847  0.009168 -0.019478  0.039825 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)       c1     time  c1:time
    (Intercept)     0.17423 -0.03059 -0.02163  0.01053
    c1             -0.03059  0.15608  0.02467 -0.01410
    time           -0.02163  0.02467  0.13207 -0.01118
    c1:time         0.01053 -0.01410 -0.01118  0.19646
    
    
    $m4d
    
    Call:
    clmm_imp(fixed = o1 ~ C1 * time + I(time^2) + b2 * c1, data = longDF, 
        random = ~time | id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 > 1    o1 > 2        C1      time I(time^2)       b21        c1   C1:time 
      0.67529  -1.19597  -3.24406   0.34746  -0.03584   0.64830  -0.01319  -0.16972 
       b21:c1 
     -0.10393 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)     time
    (Intercept)     0.36960 -0.04086
    time           -0.04086  0.43183
    
    
    $m4e
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + log(time) + I(time^2) + p1, data = longDF, 
        random = ~1 | id, n.adapt = 5, n.iter = 10, shrinkage = "ridge", 
        seed = 2020, parallel = TRUE, n.cores = 2)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 > 1    o1 > 2        C1 log(time) I(time^2)        p1 
      0.75224  -1.13944  -6.67959  -0.10736  -0.00761  -0.04324 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.101
    
    
    $m5a
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + C2 + b2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~C1 + C2 + b2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 > 1    o1 > 2       O22       O23        C1        C2        C1        C2 
      0.61871  -1.57547   0.14211   0.31010 -14.09667  -0.05035 -15.19261  -0.33644 
          b21       b21 
      0.70279   0.71334 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.485
    
    
    $m5b
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2      M22      M23      M24      O22      O23       C2 
     0.83745 -1.38478 -0.49570  0.01298 -0.90016  0.29305  0.66856 -0.20244 
       c1:C2       C2       c1       c1 
    -0.46162  0.56664  0.25443  0.68752 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.733
    
    
    $m5c
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 * C2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2      M22      M23      M24      O22      O23       C2 
     0.62708 -1.78749  0.29684  1.20688 -0.46318  0.03442  0.15470  0.06389 
          C2       c1    c1:C2       c1    c1:C2 
    -0.32468  0.22547  0.59153  0.93141  0.77398 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.668
    
    
    $m5d
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2      M22      M23      M24      O22      O23   M22:C2 
     0.33891 -1.89959 -0.73381  1.46442 -1.11216  0.61157  0.76958 -0.96941 
      M23:C2   M24:C2       C2       C2       c1       c1 
     0.43525 -0.91095  0.28818 -0.10012 -0.08609  0.27136 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.621
    
    
    $m5e
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = ~c1 + M2 * C2 + O2, seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 > 1   o1 > 2      M22      M23      M24       C2      O22      O23 
     0.17661 -0.58391 -0.10767  1.04315  0.14130 -0.07027  0.40584  0.40623 
      M22:C2   M23:C2   M24:C2      M22      M23      M24       C2      O22 
    -0.21853  0.43156  0.06859 -1.36648  0.38626 -0.28373  0.46839 -0.67836 
         O23   M22:C2   M23:C2   M24:C2       c1       c1 
    -0.06247 -1.58615 -0.98570 -0.57879 -0.17857  0.15796 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.186
    
    
    $m6a
    
    Call:
    clmm_imp(fixed = o1 ~ C1 + C2 + b2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~C1 + C2 + b2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 = 1  o1 = 2     O22     O23      C1      C2      C1      C2     b21     b21 
    -0.3704  1.8865 -0.4161 -0.5572  7.2638  0.1223  1.4125  0.4304 -0.7647 -1.0330 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       2.428
    
    
    $m6b
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
     o1 = 1  o1 = 2     M22     M23     M24     O22     O23      C2   c1:C2      C2 
    -0.8402  1.4122  0.8364 -0.2639  0.5442 -0.2213 -0.6420  0.2959  0.7696 -0.7321 
         c1      c1 
    -0.2507 -0.7241 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.082
    
    
    $m6c
    
    Call:
    clmm_imp(fixed = o1 ~ c1 * C2 + M2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 * C2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 = 1   o1 = 2      M22      M23      M24      O22      O23       C2 
    -0.18940  2.09791 -0.67947 -1.50088 -0.54458  0.20507 -0.13053 -0.05929 
          C2       c1    c1:C2       c1    c1:C2 
     0.33128 -0.27379 -0.56823 -0.74530 -0.56233 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       3.575
    
    
    $m6d
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = list(o1 = ~c1 + C2), rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
       o1 = 1    o1 = 2       M22       M23       M24       O22       O23    M22:C2 
    -0.847796  1.488107  0.559481 -2.108465 -0.342857  0.533834 -0.008488  0.658544 
       M23:C2    M24:C2        C2        C2        c1        c1 
    -0.700700 -0.654119  0.309555  0.504960  0.107984 -0.428338 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       4.388
    
    
    $m6e
    
    Call:
    clmm_imp(fixed = o1 ~ c1 + M2 * C2 + O2 + (1 | id), data = longDF, 
        n.adapt = 5, n.iter = 10, monitor_params = list(other = "p_o1"), 
        nonprop = ~c1 + M2 * C2 + O2, rev = "o1", seed = 2020)
    
     Bayesian cumulative logit mixed model for "o1" 
    
    Fixed effects:
      o1 = 1   o1 = 2      M22      M23      M24       C2      O22      O23 
    -0.18987  1.05796 -0.47383 -0.87264 -0.20392  0.01790 -0.43393 -0.39316 
      M22:C2   M23:C2   M24:C2      M22      M23      M24       C2      O22 
     0.08460 -0.34287 -0.15012  0.83802 -0.21290 -0.26745 -0.24928  0.09219 
         O23   M22:C2   M23:C2   M24:C2       c1       c1 
    -0.16224  1.08611  0.76320  0.11786  0.14916 -0.25657 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       1.325
    
    
    $m7a
    
    Call:
    lme_imp(fixed = y ~ C1 + o1 + o2 + x + time, data = longDF, random = ~1 | 
        id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "y" 
    
    Fixed effects:
    (Intercept)          C1        o1.L        o1.Q         o22         o23 
       22.65718   -39.92146     0.66513     0.33499     0.96383     1.42085 
            o24          x2          x3          x4        time 
       -1.42700    -1.33973    -0.52115    -0.04887    -1.64584 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       15.11
    
    
    
    Residual standard deviation:
    sigma_y 
      4.379 
    
    $m7b
    
    Call:
    lme_imp(fixed = y ~ o2 + o1 + c2 + b2, data = longDF, random = ~1 | 
        id, n.adapt = 5, n.iter = 10, seed = 2020)
    
     Bayesian linear mixed model for "y" 
    
    Fixed effects:
    (Intercept)         o22         o23         o24        o1.L        o1.Q 
       -11.7470      1.8144      1.3401     -1.4287      1.0068      0.2891 
             c2         b21 
        -2.1701     -0.6315 
    
    
    Random effects covariance matrix:
    $id
                (Intercept)
    (Intercept)       15.95
    
    
    
    Residual standard deviation:
    sigma_y 
      4.885 
    

---

    $m0a
    $m0a$o1
        o1 > 1     o1 > 2 
     0.6993332 -1.2466519 
    
    
    $m0b
    $m0b$o2
        o2 > 1     o2 > 2     o2 > 3 
     1.2407794  0.2072089 -1.0915063 
    
    
    $m1a
    $m1a$o1
        o1 > 1     o1 > 2         C1 
     0.8482372 -1.1866458 -7.9253878 
    
    
    $m1b
    $m1b$o2
          o2 > 1       o2 > 2       o2 > 3           C1 
      1.07547138  -0.02682403  -1.42852417 -15.12993266 
    
    
    $m1c
    $m1c$o1
         o1 > 1      o1 > 2          c1 
     0.78494319 -1.19756090  0.02264669 
    
    
    $m1d
    $m1d$o2
        o2 > 1     o2 > 2     o2 > 3         c1 
     1.2447026  0.1649330 -1.1410728 -0.2674255 
    
    
    $m2a
    $m2a$o1
        o1 > 1     o1 > 2         C2 
     0.7627952 -1.2555380 -0.5832702 
    
    
    $m2b
    $m2b$o2
        o2 > 1     o2 > 2     o2 > 3         C2 
     1.2804941  0.2149688 -1.1661257  0.2587026 
    
    
    $m2c
    $m2c$o1
        o1 > 1     o1 > 2         c2 
     0.6585666 -1.2226976 -1.1162492 
    
    
    $m2d
    $m2d$o2
        o2 > 1     o2 > 2     o2 > 3         c2 
     1.3339073  0.2208608 -1.1171403  0.9525483 
    
    
    $m3a
    $m3a$c1
    (Intercept)        o1.L        o1.Q 
    -7.72208512  0.03038305  0.09892350 
    
    
    $m3b
    $m3b$c1
    (Intercept)         o22         o23         o24 
     0.38319842 -0.08861873 -0.22028818 -0.15928284 
    
    
    $m4a
    $m4a$o1
              o1 > 1           o1 > 2              M22              M23 
          0.01883928      -2.47715122       0.60691491       1.66918903 
                 M24     abs(C1 - C2)          log(C1)              o22 
          0.54555145       0.76093584      -6.42350177       1.27118881 
                 o23              o24 o22:abs(C1 - C2) o23:abs(C1 - C2) 
         -1.07735049       0.60301408      -0.68561800      -0.12851783 
    o24:abs(C1 - C2) 
         -0.17379478 
    
    
    $m4b
    $m4b$o1
                                                        o1 > 1 
                                                     0.4898129 
                                                        o1 > 2 
                                                    -1.4448420 
                                                  abs(C1 - C2) 
                                                     0.4729205 
                                                       log(C1) 
                                                    -8.8464243 
                 ifelse(as.numeric(o2) > as.numeric(M1), 1, 0) 
                                                    -0.5136087 
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2) 
                                                     0.1729866 
    
    
    $m4c
    $m4c$o1
          o1 > 1       o1 > 2           C1          B21         time           c1 
     0.677072445 -1.056545005 -2.477846625  0.009167661 -0.019477808  0.039824745 
    
    
    $m4d
    $m4d$o1
         o1 > 1      o1 > 2          C1        time   I(time^2)         b21 
     0.67529453 -1.19596705 -3.24405740  0.34746303 -0.03583755  0.64830015 
             c1     C1:time      b21:c1 
    -0.01318653 -0.16972186 -0.10392670 
    
    
    $m4e
    $m4e$o1
          o1 > 1       o1 > 2           C1    log(time)    I(time^2)           p1 
     0.752240227 -1.139436385 -6.679594443 -0.107362927 -0.007610436 -0.043236749 
    
    
    $m5a
    $m5a$o1
          o1 > 1       o1 > 2          O22          O23           C1           C2 
      0.61870516  -1.57546796   0.14210637   0.31010348 -14.09666768  -0.05035175 
              C1           C2          b21          b21 
    -15.19261387  -0.33643981   0.70278756   0.71334463 
    
    
    $m5b
    $m5b$o1
         o1 > 1      o1 > 2         M22         M23         M24         O22 
     0.83745156 -1.38478219 -0.49569842  0.01298077 -0.90015640  0.29304634 
            O23          C2       c1:C2          C2          c1          c1 
     0.66855897 -0.20244157 -0.46162268  0.56664331  0.25443416  0.68751950 
    
    
    $m5c
    $m5c$o1
         o1 > 1      o1 > 2         M22         M23         M24         O22 
     0.62708464 -1.78748615  0.29683564  1.20687653 -0.46318436  0.03442037 
            O23          C2          C2          c1       c1:C2          c1 
     0.15470224  0.06389382 -0.32467897  0.22547225  0.59153131  0.93141079 
          c1:C2 
     0.77398469 
    
    
    $m5d
    $m5d$o1
         o1 > 1      o1 > 2         M22         M23         M24         O22 
     0.33890968 -1.89959141 -0.73380719  1.46442352 -1.11215720  0.61156526 
            O23      M22:C2      M23:C2      M24:C2          C2          C2 
     0.76957519 -0.96940864  0.43525494 -0.91094789  0.28818454 -0.10011912 
             c1          c1 
    -0.08608693  0.27135980 
    
    
    $m5e
    $m5e$o1
         o1 > 1      o1 > 2         M22         M23         M24          C2 
     0.17661063 -0.58391186 -0.10767414  1.04315238  0.14130401 -0.07027105 
            O22         O23      M22:C2      M23:C2      M24:C2         M22 
     0.40583545  0.40622744 -0.21852748  0.43156032  0.06859126 -1.36647926 
            M23         M24          C2         O22         O23      M22:C2 
     0.38625775 -0.28372752  0.46839290 -0.67836033 -0.06247163 -1.58615242 
         M23:C2      M24:C2          c1          c1 
    -0.98569715 -0.57879073 -0.17856977  0.15795824 
    
    
    $m6a
    $m6a$o1
        o1 = 1     o1 = 2        O22        O23         C1         C2         C1 
    -0.3704471  1.8864825 -0.4160980 -0.5571939  7.2638436  0.1223253  1.4124623 
            C2        b21        b21 
     0.4304222 -0.7646823 -1.0329831 
    
    
    $m6b
    $m6b$o1
        o1 = 1     o1 = 2        M22        M23        M24        O22        O23 
    -0.8401627  1.4121838  0.8364250 -0.2639200  0.5441793 -0.2213229 -0.6420012 
            C2      c1:C2         C2         c1         c1 
     0.2958578  0.7695723 -0.7320974 -0.2507145 -0.7240615 
    
    
    $m6c
    $m6c$o1
         o1 = 1      o1 = 2         M22         M23         M24         O22 
    -0.18940113  2.09790512 -0.67947122 -1.50087513 -0.54457960  0.20506961 
            O23          C2          C2          c1       c1:C2          c1 
    -0.13053241 -0.05928772  0.33127965 -0.27379246 -0.56823400 -0.74529771 
          c1:C2 
    -0.56233010 
    
    
    $m6d
    $m6d$o1
          o1 = 1       o1 = 2          M22          M23          M24          O22 
    -0.847795780  1.488106526  0.559481280 -2.108465295 -0.342856733  0.533833814 
             O23       M22:C2       M23:C2       M24:C2           C2           C2 
    -0.008488434  0.658544120 -0.700699830 -0.654118798  0.309555073  0.504960057 
              c1           c1 
     0.107983707 -0.428338335 
    
    
    $m6e
    $m6e$o1
         o1 = 1      o1 = 2         M22         M23         M24          C2 
    -0.18986731  1.05795867 -0.47382777 -0.87264287 -0.20391766  0.01789769 
            O22         O23      M22:C2      M23:C2      M24:C2         M22 
    -0.43393298 -0.39315885  0.08460397 -0.34286582 -0.15011635  0.83801957 
            M23         M24          C2         O22         O23      M22:C2 
    -0.21289780 -0.26744724 -0.24927958  0.09218536 -0.16223952  1.08610521 
         M23:C2      M24:C2          c1          c1 
     0.76319974  0.11785553  0.14915853 -0.25657073 
    
    
    $m7a
    $m7a$y
     (Intercept)           C1         o1.L         o1.Q          o22          o23 
     22.65717813 -39.92145622   0.66512769   0.33498727   0.96383091   1.42084992 
             o24           x2           x3           x4         time 
     -1.42699640  -1.33972918  -0.52114836  -0.04886736  -1.64584397 
    
    
    $m7b
    $m7b$y
    (Intercept)         o22         o23         o24        o1.L        o1.Q 
    -11.7470100   1.8143807   1.3401226  -1.4287042   1.0067962   0.2891074 
             c2         b21 
     -2.1701021  -0.6315147 
    
    

---

    $m0a
    $m0a$o1
                 2.5%      97.5%
    o1 > 1  0.3540066  1.0330257
    o1 > 2 -1.5239392 -0.9324003
    
    
    $m0b
    $m0b$o2
                  2.5%      97.5%
    o2 > 1  1.00254982  1.4498031
    o2 > 2 -0.09507208  0.4904778
    o2 > 3 -1.46529773 -0.7773362
    
    
    $m1a
    $m1a$o1
                  2.5%      97.5%
    o1 > 1   0.5214481  1.1698634
    o1 > 2  -1.6205671 -0.8540612
    C1     -29.8539326 12.4009027
    
    
    $m1b
    $m1b$o2
                  2.5%      97.5%
    o2 > 1   0.8050183  1.5339519
    o2 > 2  -0.4212421  0.2933610
    o2 > 3  -2.1211858 -0.9513714
    C1     -52.9692349 18.2313527
    
    
    $m1c
    $m1c$o1
                 2.5%      97.5%
    o1 > 1  0.5021075  1.0407790
    o1 > 2 -1.4019581 -0.8852392
    c1     -0.2851665  0.3066444
    
    
    $m1d
    $m1d$o2
                 2.5%       97.5%
    o2 > 1  0.8912609  1.65728794
    o2 > 2 -0.1751158  0.48526869
    o2 > 3 -1.4929771 -0.71421714
    c1     -0.5728984 -0.03484079
    
    
    $m2a
    $m2a$o1
                2.5%       97.5%
    o1 > 1  0.208756  1.17641356
    o1 > 2 -1.736926 -0.87500506
    C2     -1.147961 -0.03640213
    
    
    $m2b
    $m2b$o2
                 2.5%      97.5%
    o2 > 1  0.8182049  1.4888972
    o2 > 2 -0.1882480  0.4768646
    o2 > 3 -1.6133066 -0.7903823
    C2     -0.3660556  0.7053177
    
    
    $m2c
    $m2c$o1
                 2.5%      97.5%
    o1 > 1  0.3551485  1.0567748
    o1 > 2 -1.5614556 -0.8853310
    c2     -2.4990615  0.8037814
    
    
    $m2d
    $m2d$o2
                  2.5%      97.5%
    o2 > 1  0.99607348  1.6918131
    o2 > 2 -0.03987433  0.5031851
    o2 > 3 -1.34851067 -0.8123833
    c2     -1.77971729  2.8683720
    
    
    $m3a
    $m3a$c1
                         2.5%     97.5%
    (Intercept) -109.52488926 5.4743465
    o1.L          -0.13446871 0.2054076
    o1.Q          -0.07745853 0.2487869
    
    
    $m3b
    $m3b$c1
                      2.5%       97.5%
    (Intercept)  0.2556293  0.58171530
    o22         -0.2661888  0.12693787
    o23         -0.4580881 -0.04122073
    o24         -0.4065167  0.09311458
    
    
    $m4a
    $m4a$o1
                             2.5%        97.5%
    o1 > 1            -0.50870904  0.468826079
    o1 > 2            -2.87372349 -2.040475921
    M22               -0.51382076  1.406677812
    M23                0.06175414  3.083972714
    M24               -0.83272672  2.441994008
    abs(C1 - C2)      -0.19973668  2.197780030
    log(C1)          -33.97870272 22.802582494
    o22               -0.03589551  2.696054520
    o23               -1.96318810 -0.061551030
    o24               -0.59115522  2.183317300
    o22:abs(C1 - C2)  -1.36826291 -0.006642153
    o23:abs(C1 - C2)  -0.72878581  0.530361418
    o24:abs(C1 - C2)  -1.39218373  0.758588388
    
    
    $m4b
    $m4b$o1
                                                                        2.5%
    o1 > 1                                                       0.025512065
    o1 > 2                                                      -2.104123361
    abs(C1 - C2)                                                 0.005481029
    log(C1)                                                    -30.265971051
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)               -1.695890740
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.390515704
                                                                    97.5%
    o1 > 1                                                      0.8250917
    o1 > 2                                                     -1.0728962
    abs(C1 - C2)                                                0.9552189
    log(C1)                                                     7.0274734
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)               0.4332628
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.8537039
    
    
    $m4c
    $m4c$o1
                  2.5%       97.5%
    o1 > 1  0.53340515  0.85362644
    o1 > 2 -1.33362791 -0.84094310
    C1     -7.62611614  3.10569098
    B21    -0.08767717  0.13506643
    time   -0.09393696  0.06792336
    c1     -0.13429377  0.24045131
    
    
    $m4d
    $m4d$o1
                      2.5%        97.5%
    o1 > 1      0.44057538  0.929617177
    o1 > 2     -1.45074996 -0.781954291
    C1        -12.29239698  5.569689130
    time        0.08211350  0.723092571
    I(time^2)  -0.06913376 -0.014375423
    b21        -0.58208242  1.347776598
    c1         -0.28189540  0.324271674
    C1:time    -0.40339407  0.004293776
    b21:c1     -1.16478892  0.763189224
    
    
    $m4e
    $m4e$o1
                      2.5%       97.5%
    o1 > 1      0.54025920  1.23417376
    o1 > 2     -1.43247651 -0.74689785
    C1        -18.47754335  2.71535734
    log(time)  -0.29043319  0.09771717
    I(time^2)  -0.03774125  0.01281260
    p1         -0.11210675  0.04129903
    
    
    $m5a
    $m5a$o1
                  2.5%       97.5%
    o1 > 1  -0.1515750  1.34280765
    o1 > 2  -2.3988905 -0.88399520
    O22     -0.9302746  1.11906650
    O23     -1.0524381  1.19572863
    C1     -34.0757259  2.38649907
    C2      -0.5402391  0.58227075
    C1     -34.1626307  4.27941833
    C2      -0.8294186  0.09235476
    b21     -0.2406003  1.53268861
    b21      0.1370949  1.31352473
    
    
    $m5b
    $m5b$o1
                   2.5%      97.5%
    o1 > 1  0.131632177  1.4544856
    o1 > 2 -2.152918409 -0.6827363
    M22    -2.084008061  0.7973864
    M23    -0.971386352  1.5635718
    M24    -2.181758089  0.1460613
    O22    -1.079488392  1.4888339
    O23    -0.474005762  2.1148438
    C2     -0.785297580  0.7309578
    c1:C2  -1.196127099  0.3667669
    C2     -0.088854450  1.2603537
    c1     -0.438953531  0.6434105
    c1     -0.005529997  1.1788545
    
    
    $m5c
    $m5c$o1
                   2.5%      97.5%
    o1 > 1 -0.098821456  1.4733102
    o1 > 2 -2.558865620 -1.0312280
    M22    -1.645249462  1.7590590
    M23    -0.673637614  2.7439929
    M24    -1.726351113  0.8347648
    O22    -1.555489219  1.8914068
    O23    -1.115827129  1.4307916
    C2     -0.620631733  0.8597524
    C2     -0.754611287  0.2070102
    c1     -0.411151536  0.9728807
    c1:C2  -0.028674696  1.1186266
    c1      0.166637694  1.4804937
    c1:C2   0.003261384  1.4666859
    
    
    $m5d
    $m5d$o1
                   2.5%      97.5%
    o1 > 1 -0.008519956  0.7340547
    o1 > 2 -2.374458220 -1.4473358
    M22    -2.519941337  1.5399140
    M23    -0.360547837  3.1423893
    M24    -3.173775915  0.5926373
    O22    -0.309462244  1.6813366
    O23    -0.089714062  1.7432343
    M22:C2 -2.582463174  0.6861062
    M23:C2 -1.289487772  2.6784602
    M24:C2 -2.941832956  1.2547480
    C2     -1.068362708  1.8231393
    C2     -1.021862126  1.2673127
    c1     -0.374205732  0.3004297
    c1     -0.138756059  0.7243975
    
    
    $m5e
    $m5e$o1
                 2.5%       97.5%
    o1 > 1 -0.3903881  0.74615070
    o1 > 2 -0.8601397 -0.33343762
    M22    -0.7354685  0.62944682
    M23     0.2033432  2.18644696
    M24    -0.2724786  0.85205184
    C2     -1.1759750  0.87646918
    O22    -0.4991370  1.16754325
    O23    -0.1606294  1.13653044
    M22:C2 -1.1998344  1.01898804
    M23:C2 -0.5269527  1.53988500
    M24:C2 -1.2303256  1.85302179
    M22    -2.8476337 -0.54600535
    M23    -0.3707003  1.34972369
    M24    -1.2656575  0.51839457
    C2     -0.4428088  1.23972025
    O22    -1.2026289 -0.07359378
    O23    -0.6302249  0.50805596
    M22:C2 -2.2564383 -0.98607961
    M23:C2 -2.1624013 -0.16659643
    M24:C2 -1.9147631  0.73071495
    c1     -0.5374548  0.15204213
    c1     -0.2008339  0.53836642
    
    
    $m6a
    $m6a$o1
                   2.5%       97.5%
    o1 = 1  -1.30784268  0.26947907
    o1 = 2   1.04124437  2.57012582
    O22     -1.13479983  0.51887144
    O23     -1.31647925  0.59101797
    C1     -13.55929840 28.98451252
    C2      -0.74770240  0.81733270
    C1     -22.87326065 24.66306448
    C2       0.01639224  0.95293774
    b21     -1.67599674  0.09681726
    b21     -1.87877715 -0.42347879
    
    
    $m6b
    $m6b$o1
                  2.5%       97.5%
    o1 = 1 -1.42590425 -0.38205930
    o1 = 2  0.62578095  2.17754105
    M22    -0.03417103  2.58602012
    M23    -2.15414504  0.86557357
    M24    -0.33044935  1.48686634
    O22    -1.46026218  0.85578674
    O23    -1.50241652  0.05911442
    C2     -0.40699367  1.07497362
    c1:C2   0.14197382  1.67076592
    C2     -1.33202824 -0.02574031
    c1     -0.88061830  0.31772808
    c1     -1.34532481 -0.12947825
    
    
    $m6c
    $m6c$o1
                 2.5%       97.5%
    o1 = 1 -0.6406824  0.24976940
    o1 = 2  1.5230955  2.60796955
    M22    -2.4959563  0.37291793
    M23    -2.7364502 -0.56053772
    M24    -1.7272434  0.46724645
    O22    -0.6305035  1.17496922
    O23    -1.1380572  0.74286976
    C2     -0.7698483  0.54345437
    C2     -0.3635105  1.20810394
    c1     -0.6489835  0.17301853
    c1:C2  -1.0164986  0.01054438
    c1     -1.3372007 -0.04408089
    c1:C2  -1.1358340  0.39668180
    
    
    $m6d
    $m6d$o1
                  2.5%       97.5%
    o1 = 1 -1.26819561 -0.37242817
    o1 = 2  0.89582668  2.19803335
    M22    -1.52549246  2.09584673
    M23    -5.38014392 -0.20675150
    M24    -1.84435325  1.88365274
    O22    -0.82911367  1.92820942
    O23    -1.67306531  1.08814483
    M22:C2 -0.80531061  1.81173000
    M23:C2 -3.28454510  1.87588768
    M24:C2 -2.51073175  1.56920045
    C2     -0.30856651  0.90456842
    C2     -0.07874678  1.23860394
    c1     -0.33782517  0.48957365
    c1     -0.88884171  0.09171705
    
    
    $m6e
    $m6e$o1
                  2.5%       97.5%
    o1 = 1 -0.84278532 0.331642676
    o1 = 2  0.52363065 1.576543835
    M22    -1.89433499 0.627841889
    M23    -1.62990079 0.005287224
    M24    -0.63474010 0.228160634
    C2     -0.52240526 0.580326397
    O22    -1.13018749 0.014549451
    O23    -0.91333936 0.501445356
    M22:C2 -0.54273377 0.566713262
    M23:C2 -1.23668455 0.540133935
    M24:C2 -1.14987201 0.746887563
    M22     0.07426814 1.912196390
    M23    -1.20301909 0.507046458
    M24    -1.17286267 0.436619094
    C2     -1.13174013 0.542659799
    O22    -0.42548191 0.662458007
    O23    -0.76745028 0.585402015
    M22:C2  0.02938175 2.558669444
    M23:C2  0.21908264 1.178508745
    M24:C2 -0.80899814 1.899811883
    c1     -0.27836808 0.972890649
    c1     -0.65634619 0.192001113
    
    
    $m7a
    $m7a$y
                       2.5%       97.5%
    (Intercept) -13.7369574 59.88259806
    C1          -91.0339519  9.81986683
    o1.L         -0.2228435  1.36792708
    o1.Q         -0.5365374  1.05923135
    o22          -0.2502464  3.16153686
    o23           0.2265291  2.71848857
    o24          -2.4586899  0.01888373
    x2           -2.6104714  0.50534675
    x3           -1.8804197  0.67004053
    x4           -1.1640423  0.95512544
    time         -1.9632493 -1.28824005
    
    
    $m7b
    $m7b$y
                        2.5%       97.5%
    (Intercept) -13.38603521 -10.3169281
    o22           0.79456826   3.6954364
    o23           0.13438940   2.4564851
    o24          -3.06036256   0.2904691
    o1.L         -0.04777933   1.8787537
    o1.Q         -0.56350757   1.0280544
    c2           -7.31427618   1.4970016
    b21          -2.37829792   0.6265542
    
    

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
    o1 > 1  0.699 0.210  0.354  1.033          0    4.28  0.542
    o1 > 2 -1.247 0.176 -1.524 -0.932          0    2.42  0.306
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 1.08 0.343 0.609  1.82               1.93  0.134
    
    
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
    o2 > 1  1.241 0.145  1.0025  1.450      0.000    1.78  0.208
    o2 > 2  0.207 0.171 -0.0951  0.490      0.333    1.19  0.183
    o2 > 3 -1.092 0.171 -1.4653 -0.777      0.000    1.12  0.183
    
    Posterior summary of random effects covariance matrix:
                  Mean    SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o2_id[1,1] 0.715 0.198 0.47  1.17               1.54  0.345
    
    
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
    C1 -7.93 12.1 -29.9  12.4        0.6    1.56  0.338
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.848 0.180  0.521  1.170          0    1.69  0.249
    o1 > 2 -1.187 0.243 -1.621 -0.854          0    2.30  0.342
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1]  1.7 0.709 0.707  3.08               1.34  0.382
    
    
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
        Mean SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    C1 -15.1 17  -53  18.2      0.267    1.84  0.217
    
    Posterior summary of the intercepts:
              Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o2 > 1  1.0755 0.197  0.805  1.534      0.000    1.76       
    o2 > 2 -0.0268 0.219 -0.421  0.293      0.933    2.40  0.502
    o2 > 3 -1.4285 0.340 -2.121 -0.951      0.000    2.37  0.298
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o2_id[1,1] 2.43 1.83 0.417  7.32               2.56  0.342
    
    
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
    c1 0.0226 0.172 -0.285 0.307          1    1.38  0.183
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.785 0.149  0.502  1.041          0    3.58  0.287
    o1 > 2 -1.198 0.170 -1.402 -0.885          0    1.74  0.231
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1]  1.2 0.368 0.632  1.97               3.41  0.534
    
    
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
         Mean    SD   2.5%   97.5% tail-prob. GR-crit MCE/SD
    c1 -0.267 0.142 -0.573 -0.0348          0    1.43  0.061
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o2 > 1  1.245 0.217  0.891  1.657        0.0    1.44  0.331
    o2 > 2  0.165 0.182 -0.175  0.485        0.4    1.19  0.183
    o2 > 3 -1.141 0.227 -1.493 -0.714        0.0    1.22  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o2_id[1,1] 1.02 0.475 0.43  2.26               1.32  0.245
    
    
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
         Mean    SD  2.5%   97.5% tail-prob. GR-crit MCE/SD
    C2 -0.583 0.307 -1.15 -0.0364          0     2.1  0.183
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.763 0.258  0.209  1.176          0    5.12  0.673
    o1 > 2 -1.256 0.234 -1.737 -0.875          0    2.66  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 1.75 0.919 0.64  3.71               1.49  0.369
    
    
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
    C2 0.259 0.288 -0.366 0.705      0.333    1.99  0.258
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o2 > 1  1.280 0.165  0.818  1.489        0.0    1.60  0.183
    o2 > 2  0.215 0.184 -0.188  0.477        0.2    1.78  0.209
    o2 > 3 -1.166 0.207 -1.613 -0.790        0.0    1.41  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o2_id[1,1] 1.78 1.08 0.806  4.15               2.31  0.504
    
    
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
        Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    c2 -1.12 1.02 -2.5 0.804      0.133   0.982  0.183
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.659 0.212  0.355  1.057          0    1.10  0.246
    o1 > 2 -1.223 0.213 -1.561 -0.885          0    1.69  0.310
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 1.41 0.578 0.643  2.44               4.26  0.529
    
    
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
    c2 0.953 1.32 -1.78  2.87      0.467   0.997  0.288
    
    Posterior summary of the intercepts:
             Mean    SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    o2 > 1  1.334 0.231  0.9961  1.692        0.0    3.87  0.526
    o2 > 2  0.221 0.167 -0.0399  0.503        0.2    2.79  0.290
    o2 > 3 -1.117 0.161 -1.3485 -0.812        0.0    1.36  0.226
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o2_id[1,1] 1.31 0.538 0.544  2.21               5.07  0.525
    
    
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
                   Mean      SD      2.5% 97.5% tail-prob. GR-crit MCE/SD
    (Intercept) -7.7221 28.8303 -109.5249 5.474      0.333    1.16  0.183
    o1.L         0.0304  0.0974   -0.1345 0.205      0.733    1.51  0.183
    o1.Q         0.0989  0.0905   -0.0775 0.249      0.200    1.01  0.183
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_c1_id[1,1]  863 3198 0.0658 12177               1.25  0.183
    
    Posterior summary of residual std. deviation:
              Mean     SD  2.5% 97.5% GR-crit MCE/SD
    sigma_c1 0.652 0.0452 0.602  0.77    1.03   0.23
    
    
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
                   Mean     SD   2.5%   97.5% tail-prob. GR-crit MCE/SD
    (Intercept)  0.3832 0.0898  0.256  0.5817      0.000    6.83  0.715
    o22         -0.0886 0.1238 -0.266  0.1269      0.467    3.34  0.408
    o23         -0.2203 0.1126 -0.458 -0.0412      0.000    2.28  0.264
    o24         -0.1593 0.1422 -0.407  0.0931      0.267    4.38  0.462
    
    Posterior summary of random effects covariance matrix:
                   Mean     SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_c1_id[1,1] 0.0797 0.0384 0.0383  0.19               3.65   0.22
    
    Posterior summary of residual std. deviation:
              Mean     SD  2.5% 97.5% GR-crit MCE/SD
    sigma_c1 0.627 0.0244 0.585 0.672    1.77  0.183
    
    
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
                       Mean     SD     2.5%    97.5% tail-prob. GR-crit MCE/SD
    M22               0.607  0.600  -0.5138  1.40668     0.3333    2.60  0.198
    M23               1.669  0.869   0.0618  3.08397     0.0000    3.07  0.360
    M24               0.546  0.771  -0.8327  2.44199     0.4667    1.96  0.327
    abs(C1 - C2)      0.761  0.667  -0.1997  2.19778     0.2667    2.08  0.344
    log(C1)          -6.424 15.917 -33.9787 22.80258     0.8000    1.58  0.183
    o22               1.271  0.739  -0.0359  2.69605     0.1333    5.49  0.471
    o23              -1.077  0.674  -1.9632 -0.06155     0.0667    7.22  0.443
    o24               0.603  1.014  -0.5912  2.18332     0.7333   14.56  0.994
    o22:abs(C1 - C2) -0.686  0.384  -1.3683 -0.00664     0.0667    3.69  0.460
    o23:abs(C1 - C2) -0.129  0.420  -0.7288  0.53036     0.8000    5.69  0.686
    o24:abs(C1 - C2) -0.174  0.644  -1.3922  0.75859     0.8667    7.22  0.795
    
    Posterior summary of the intercepts:
              Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.0188 0.280 -0.509  0.469      0.733    4.66  0.463
    o1 > 2 -2.4772 0.254 -2.874 -2.040      0.000    3.99  0.343
    
    Posterior summary of random effects covariance matrix:
                 Mean  SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 4.52 2.4 1.57  8.73              0.991  0.236
    
    
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
                                                                 Mean    SD
    abs(C1 - C2)                                                0.473 0.258
    log(C1)                                                    -8.846 9.898
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)              -0.514 0.611
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.173 0.327
                                                                    2.5% 97.5%
    abs(C1 - C2)                                                 0.00548 0.955
    log(C1)                                                    -30.26597 7.027
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)               -1.69589 0.433
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.39052 0.854
                                                               tail-prob. GR-crit
    abs(C1 - C2)                                                   0.0667    2.47
    log(C1)                                                        0.3333    1.11
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)                  0.3333    5.38
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)     0.5333    3.11
                                                               MCE/SD
    abs(C1 - C2)                                                0.390
    log(C1)                                                     0.183
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)               0.408
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.255
    
    Posterior summary of the intercepts:
            Mean    SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.49 0.231  0.0255  0.825          0    3.65  0.386
    o1 > 2 -1.44 0.320 -2.1041 -1.073          0    4.36  0.286
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1]  2.2 1.26 0.454  4.13               3.36  0.503
    
    
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
    C1   -2.47785 3.2958 -7.6261 3.1057      0.533    3.43  0.282
    B21   0.00917 0.0678 -0.0877 0.1351      0.867    3.94  0.322
    time -0.01948 0.0486 -0.0939 0.0679      0.600    4.09  0.312
    c1    0.03982 0.1249 -0.1343 0.2405      1.000    5.92  0.506
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.677 0.101  0.533  0.854          0    1.62  0.222
    o1 > 2 -1.057 0.141 -1.334 -0.841          0    3.13  0.230
    
    Posterior summary of random effects covariance matrix:
                    Mean     SD    2.5%  97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1]  0.1742 0.0987  0.0750 0.3617              13.79  0.419
    D_o1_id[1,2] -0.0306 0.0347 -0.0903 0.0263        0.4    6.06  0.709
    D_o1_id[2,2]  0.1561 0.0549  0.0924 0.2585               6.77  0.528
    D_o1_id[1,3] -0.0216 0.0547 -0.1169 0.0369        0.8   12.73  0.574
    D_o1_id[2,3]  0.0247 0.0427 -0.0320 0.0942        0.8   10.66  0.415
    D_o1_id[3,3]  0.1321 0.0329  0.0932 0.2024               2.86       
    D_o1_id[1,4]  0.0105 0.0439 -0.0474 0.0849        1.0    6.27  0.293
    D_o1_id[2,4] -0.0141 0.0265 -0.0644 0.0268        0.6    3.23  0.398
    D_o1_id[3,4] -0.0112 0.0474 -0.0924 0.0549        1.0    6.98  0.571
    D_o1_id[4,4]  0.1965 0.0590  0.1189 0.3106               4.35  0.410
    
    
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
                 Mean     SD     2.5%    97.5% tail-prob. GR-crit MCE/SD
    C1        -3.2441 5.4770 -12.2924  5.56969      0.533    1.40  0.396
    time       0.3475 0.1938   0.0821  0.72309      0.000    2.91  0.319
    I(time^2) -0.0358 0.0159  -0.0691 -0.01438      0.000    1.39  0.183
    b21        0.6483 0.5102  -0.5821  1.34778      0.133    3.52  0.308
    c1        -0.0132 0.1933  -0.2819  0.32427      0.733    2.02  0.225
    C1:time   -0.1697 0.1222  -0.4034  0.00429      0.133    3.03  0.457
    b21:c1    -0.1039 0.5393  -1.1648  0.76319      0.933    2.59  0.321
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.675 0.160  0.441  0.930          0    2.00  0.183
    o1 > 2 -1.196 0.197 -1.451 -0.782          0    1.33  0.183
    
    Posterior summary of random effects covariance matrix:
                    Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1]  0.3696 0.120  0.218 0.602               5.25  0.515
    D_o1_id[1,2] -0.0409 0.109 -0.244 0.108      0.933    7.67  0.520
    D_o1_id[2,2]  0.4318 0.196  0.233 0.846              16.34  0.606
    
    
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
                  Mean     SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    C1        -6.67959 7.3920 -18.4775 2.7154      0.400    1.95  0.346
    log(time) -0.10736 0.1143  -0.2904 0.0977      0.467    1.88  0.243
    I(time^2) -0.00761 0.0145  -0.0377 0.0128      0.600    1.69  0.216
    p1        -0.04324 0.0430  -0.1121 0.0413      0.267    1.44  0.183
    
    Posterior summary of the intercepts:
             Mean    SD  2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.752 0.192  0.54  1.234          0    2.08  0.376
    o1 > 2 -1.139 0.173 -1.43 -0.747          0    1.67  0.315
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1]  1.1 0.303 0.648  1.63               4.58    0.5
    
    
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
    O22        0.1421  0.567  -0.930 1.1191     0.5333    4.20  0.517
    O23        0.3101  0.607  -1.052 1.1957     0.4667    4.10  0.430
    o12: C1  -14.0967  9.621 -34.076 2.3865     0.1333    3.10  0.463
    o12: C2   -0.0504  0.334  -0.540 0.5823     0.8000    3.34  0.393
    o13: C1  -15.1926 11.723 -34.163 4.2794     0.2667    2.49  0.282
    o13: C2   -0.3364  0.257  -0.829 0.0924     0.2000    2.73  0.298
    o12: b21   0.7028  0.518  -0.241 1.5327     0.2000    2.15  0.235
    o13: b21   0.7133  0.352   0.137 1.3135     0.0667    2.41  0.214
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.619 0.483 -0.152  1.343        0.2    9.86  0.862
    o1 > 2 -1.575 0.464 -2.399 -0.884        0.0    6.37  0.381
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 2.49 1.39 0.993  5.58               2.76  0.399
    
    
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
              Mean    SD     2.5% 97.5% tail-prob. GR-crit MCE/SD
    M22     -0.496 0.769 -2.08401 0.797     0.5333    2.59  0.299
    M23      0.013 0.689 -0.97139 1.564     0.9333    2.74  0.441
    M24     -0.900 0.693 -2.18176 0.146     0.1333    3.18  0.227
    O22      0.293 0.681 -1.07949 1.489     0.6000    1.17  0.239
    O23      0.669 0.805 -0.47401 2.115     0.6000    2.84  0.262
    o12: C2 -0.202 0.436 -0.78530 0.731     0.4667    8.00  0.513
    o13: C2 -0.462 0.493 -1.19613 0.367     0.4667    7.51  0.256
    c1:C2    0.567 0.397 -0.08885 1.260     0.1333    2.27  0.280
    o12: c1  0.254 0.319 -0.43895 0.643     0.4000    1.19  0.228
    o13: c1  0.688 0.322 -0.00553 1.179     0.0667    1.06  0.218
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.837 0.420  0.132  1.454          0    7.52  0.570
    o1 > 2 -1.385 0.461 -2.153 -0.683          0    6.69  0.446
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 3.73 2.01 1.45  7.99               2.86  0.454
    
    
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
                  Mean    SD     2.5% 97.5% tail-prob. GR-crit MCE/SD
    M22         0.2968 1.005 -1.64525 1.759     0.6667    2.77  0.470
    M23         1.2069 0.977 -0.67364 2.744     0.2000    2.13  0.336
    M24        -0.4632 0.722 -1.72635 0.835     0.4000    2.44  0.484
    O22         0.0344 1.017 -1.55549 1.891     1.0000    1.69  0.398
    O23         0.1547 0.662 -1.11583 1.431     0.7333    1.95  0.330
    o12: C2     0.0639 0.421 -0.62063 0.860     0.8000    3.58  0.481
    o13: C2    -0.3247 0.268 -0.75461 0.207     0.3333    1.29  0.183
    o12: c1     0.2255 0.423 -0.41115 0.973     0.7333    2.76  0.449
    o12: c1:C2  0.5915 0.339 -0.02867 1.119     0.1333    3.55  0.496
    o13: c1     0.9314 0.420  0.16664 1.480     0.0000    5.27  0.533
    o13: c1:C2  0.7740 0.460  0.00326 1.467     0.0667    4.19  0.489
    
    Posterior summary of the intercepts:
             Mean    SD    2.5% 97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.627 0.464 -0.0988  1.47      0.133    6.35  0.804
    o1 > 2 -1.787 0.542 -2.5589 -1.03      0.000   11.31  0.746
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 3.67 1.53 1.67  6.96               1.02  0.306
    
    
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
    M22     -0.7338 1.125 -2.5199 1.540      0.533    4.03  0.587
    M23      1.4644 0.988 -0.3605 3.142      0.200    1.72  0.223
    M24     -1.1122 1.109 -3.1738 0.593      0.333    1.60  0.251
    O22      0.6116 0.569 -0.3095 1.681      0.467    1.70  0.183
    O23      0.7696 0.554 -0.0897 1.743      0.267    1.10  0.209
    M22:C2  -0.9694 0.993 -2.5825 0.686      0.267    1.08  0.326
    M23:C2   0.4353 1.111 -1.2895 2.678      0.667    3.08  0.421
    M24:C2  -0.9109 1.398 -2.9418 1.255      0.600    5.68  0.250
    o12: C2  0.2882 0.852 -1.0684 1.823      0.733    8.40  0.640
    o13: C2 -0.1001 0.674 -1.0219 1.267      0.867    6.39  0.486
    o12: c1 -0.0861 0.195 -0.3742 0.300      0.467    1.09  0.183
    o13: c1  0.2714 0.259 -0.1388 0.724      0.333    1.84  0.203
    
    Posterior summary of the intercepts:
             Mean    SD     2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.339 0.236 -0.00852  0.734     0.0667    5.92  0.584
    o1 > 2 -1.900 0.273 -2.37446 -1.447     0.0000    2.96  0.277
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 3.62 2.33 1.08  8.79               1.56  0.357
    
    
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
                   Mean    SD   2.5%   97.5% tail-prob. GR-crit MCE/SD
    o12: M22    -0.1077 0.392 -0.735  0.6294     0.7333    4.16  0.655
    o12: M23     1.0432 0.611  0.203  2.1864     0.0667    1.02  0.137
    o12: M24     0.1413 0.291 -0.272  0.8521     0.6000    1.73  0.343
    o12: C2     -0.0703 0.595 -1.176  0.8765     0.9333    8.08  0.525
    o12: O22     0.4058 0.547 -0.499  1.1675     0.6000    4.01  0.530
    o12: O23     0.4062 0.374 -0.161  1.1365     0.3333    3.18  0.352
    o12: M22:C2 -0.2185 0.698 -1.200  1.0190     0.6000    5.74  0.523
    o12: M23:C2  0.4316 0.524 -0.527  1.5399     0.4000    7.05  0.381
    o12: M24:C2  0.0686 1.051 -1.230  1.8530     0.8667    7.74  0.562
    o13: M22    -1.3665 0.750 -2.848 -0.5460     0.0000    6.98  0.589
    o13: M23     0.3863 0.551 -0.371  1.3497     0.5333    5.40  0.533
    o13: M24    -0.2837 0.466 -1.266  0.5184     0.6000    4.13  0.511
    o13: C2      0.4684 0.481 -0.443  1.2397     0.2667    5.96  0.505
    o13: O22    -0.6784 0.353 -1.203 -0.0736     0.0000    3.02  0.379
    o13: O23    -0.0625 0.330 -0.630  0.5081     0.8000    3.06  0.468
    o13: M22:C2 -1.5862 0.402 -2.256 -0.9861     0.0000    1.74  0.510
    o13: M23:C2 -0.9857 0.626 -2.162 -0.1666     0.0000    4.04  0.579
    o13: M24:C2 -0.5788 0.819 -1.915  0.7307     0.5333    9.09  0.850
    o12: c1     -0.1786 0.182 -0.537  0.1520     0.4000    1.31  0.183
    o13: c1      0.1580 0.238 -0.201  0.5384     0.6000    1.12  0.183
    
    Posterior summary of the intercepts:
             Mean    SD  2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 > 1  0.177 0.379 -0.39  0.746      0.733    6.04  0.769
    o1 > 2 -0.584 0.158 -0.86 -0.333      0.000    2.56  0.426
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 1.19 0.438 0.374  1.79               5.15  0.543
    
    
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
               Mean     SD     2.5%   97.5% tail-prob. GR-crit MCE/SD
    O22      -0.416  0.528  -1.1348  0.5189     0.6000    6.64  0.529
    O23      -0.557  0.614  -1.3165  0.5910     0.4667    7.82  0.466
    o12: C1   7.264 13.641 -13.5593 28.9845     0.6667    1.28  0.202
    o12: C2   0.122  0.438  -0.7477  0.8173     0.8000    2.99  0.342
    o13: C1   1.412 12.517 -22.8733 24.6631     0.8000    1.68  0.445
    o13: C2   0.430  0.290   0.0164  0.9529     0.0667    3.01  0.301
    o12: b21 -0.765  0.419  -1.6760  0.0968     0.1333    1.59  0.222
    o13: b21 -1.033  0.440  -1.8788 -0.4235     0.0000    3.45  0.484
    
    Posterior summary of the intercepts:
            Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    o1 = 1 -0.37 0.508 -1.31 0.269        0.6    6.89  0.376
    o1 = 2  1.89 0.484  1.04 2.570        0.0    8.19  0.554
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 2.43 1.17 1.13  4.95               1.18  0.303
    
    
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
              Mean    SD    2.5%   97.5% tail-prob. GR-crit MCE/SD
    M22      0.836 0.698 -0.0342  2.5860     0.0667    2.26  0.342
    M23     -0.264 0.839 -2.1541  0.8656     0.8667    2.06       
    M24      0.544 0.598 -0.3304  1.4869     0.4667    2.40  0.348
    O22     -0.221 0.667 -1.4603  0.8558     0.8000    1.45  0.303
    O23     -0.642 0.452 -1.5024  0.0591     0.1333    1.84  0.236
    o12: C2  0.296 0.474 -0.4070  1.0750     0.5333    4.90  0.378
    o13: C2  0.770 0.441  0.1420  1.6708     0.0000    3.50  0.454
    c1:C2   -0.732 0.385 -1.3320 -0.0257     0.0667    3.98  0.491
    o12: c1 -0.251 0.328 -0.8806  0.3177     0.5333    2.56  0.276
    o13: c1 -0.724 0.347 -1.3453 -0.1295     0.0667    2.98  0.303
    
    Posterior summary of the intercepts:
            Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 = 1 -0.84 0.290 -1.426 -0.382          0    4.45  0.705
    o1 = 2  1.41 0.431  0.626  2.178          0    4.29  0.556
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 3.08 1.83 1.16  6.93               1.97  0.516
    
    
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
                  Mean    SD   2.5%   97.5% tail-prob. GR-crit MCE/SD
    M22        -0.6795 0.789 -2.496  0.3729     0.3333   2.658  0.451
    M23        -1.5009 0.582 -2.736 -0.5605     0.0000   0.998  0.183
    M24        -0.5446 0.615 -1.727  0.4672     0.3333   1.149  0.119
    O22         0.2051 0.533 -0.631  1.1750     0.7333   4.169  0.513
    O23        -0.1305 0.552 -1.138  0.7429     0.8000   1.380  0.230
    o12: C2    -0.0593 0.355 -0.770  0.5435     0.8000   6.587  0.467
    o13: C2     0.3313 0.500 -0.364  1.2081     0.5333   5.737  0.492
    o12: c1    -0.2738 0.274 -0.649  0.1730     0.4667   4.361  0.397
    o12: c1:C2 -0.5682 0.349 -1.016  0.0105     0.0667   5.306  0.437
    o13: c1    -0.7453 0.410 -1.337 -0.0441     0.0667   2.209  0.360
    o13: c1:C2 -0.5623 0.424 -1.136  0.3967     0.2667   1.923  0.371
    
    Posterior summary of the intercepts:
             Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    o1 = 1 -0.189 0.271 -0.641  0.25      0.533    6.33  0.627
    o1 = 2  2.098 0.347  1.523  2.61      0.000    4.36  0.482
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 3.58 2.43 1.24  8.72               4.67  0.293
    
    
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
                Mean    SD    2.5%   97.5% tail-prob. GR-crit MCE/SD
    M22      0.55948 0.931 -1.5255  2.0958     0.4667    2.64  0.233
    M23     -2.10847 1.458 -5.3801 -0.2068     0.0667    3.66  0.340
    M24     -0.34286 1.046 -1.8444  1.8837     0.5333    2.81  0.382
    O22      0.53383 0.777 -0.8291  1.9282     0.4000    1.88  0.183
    O23     -0.00849 0.847 -1.6731  1.0881     0.8667    2.90  0.214
    M22:C2   0.65854 0.805 -0.8053  1.8117     0.5333    1.05  0.183
    M23:C2  -0.70070 1.399 -3.2845  1.8759     0.5333    3.69  0.380
    M24:C2  -0.65412 1.094 -2.5107  1.5692     0.6000    1.15  0.228
    o12: C2  0.30956 0.345 -0.3086  0.9046     0.3333    4.19  0.492
    o13: C2  0.50496 0.404 -0.0787  1.2386     0.1333    2.76  0.446
    o12: c1  0.10798 0.254 -0.3378  0.4896     0.8000    1.94  0.183
    o13: c1 -0.42834 0.264 -0.8888  0.0917     0.1333    3.05  0.269
    
    Posterior summary of the intercepts:
             Mean    SD   2.5%  97.5% tail-prob. GR-crit MCE/SD
    o1 = 1 -0.848 0.285 -1.268 -0.372          0    7.82  0.499
    o1 = 2  1.488 0.435  0.896  2.198          0    8.05  0.446
    
    Posterior summary of random effects covariance matrix:
                 Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 4.39 2.51 1.55  9.88               2.33  0.247
    
    
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
    o12: M22    -0.4738 0.831 -1.8943 0.62784     0.6667    9.63  0.807
    o12: M23    -0.8726 0.528 -1.6299 0.00529     0.0667    2.74  0.483
    o12: M24    -0.2039 0.255 -0.6347 0.22816     0.4000    1.64  0.332
    o12: C2      0.0179 0.333 -0.5224 0.58033     1.0000    4.93  0.539
    o12: O22    -0.4339 0.353 -1.1302 0.01455     0.1333    2.10  0.239
    o12: O23    -0.3932 0.382 -0.9133 0.50145     0.2000    3.86  0.432
    o12: M22:C2  0.0846 0.315 -0.5427 0.56671     0.6667    3.29  0.437
    o12: M23:C2 -0.3429 0.567 -1.2367 0.54013     0.5333    5.12  0.534
    o12: M24:C2 -0.1501 0.587 -1.1499 0.74689     0.8667    7.01  0.451
    o13: M22     0.8380 0.574  0.0743 1.91220     0.0000    2.23  0.506
    o13: M23    -0.2129 0.530 -1.2030 0.50705     0.8000    4.31  0.514
    o13: M24    -0.2674 0.498 -1.1729 0.43662     0.5333    4.40  0.539
    o13: C2     -0.2493 0.565 -1.1317 0.54266     0.7333    8.86  0.454
    o13: O22     0.0922 0.284 -0.4255 0.66246     0.6667    3.96  0.266
    o13: O23    -0.1622 0.435 -0.7675 0.58540     0.6667    8.97  0.457
    o13: M22:C2  1.0861 0.763  0.0294 2.55867     0.0667    6.89  0.522
    o13: M23:C2  0.7632 0.271  0.2191 1.17851     0.0667    2.09  0.183
    o13: M24:C2  0.1179 0.908 -0.8090 1.89981     0.6667   14.06  0.745
    o12: c1      0.1492 0.326 -0.2784 0.97289     0.6000    2.35  0.357
    o13: c1     -0.2566 0.245 -0.6563 0.19200     0.3333    1.46  0.237
    
    Posterior summary of the intercepts:
            Mean    SD   2.5% 97.5% tail-prob. GR-crit MCE/SD
    o1 = 1 -0.19 0.341 -0.843 0.332      0.733    5.79  0.477
    o1 = 2  1.06 0.348  0.524 1.577      0.000    6.34  0.347
    
    Posterior summary of random effects covariance matrix:
                 Mean    SD  2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_o1_id[1,1] 1.33 0.278 0.892  1.88               1.83  0.309
    
    
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
                    Mean     SD    2.5%   97.5% tail-prob. GR-crit MCE/SD
    (Intercept)  22.6572 22.919 -13.737 59.8826     0.4000    1.22  0.183
    C1          -39.9215 31.099 -91.034  9.8199     0.2000    1.25  0.183
    o1.L          0.6651  0.470  -0.223  1.3679     0.2667    1.11  0.183
    o1.Q          0.3350  0.416  -0.537  1.0592     0.3333    1.69       
    o22           0.9638  0.912  -0.250  3.1615     0.3333    2.61  0.491
    o23           1.4208  0.726   0.227  2.7185     0.0667    2.25  0.232
    o24          -1.4270  0.633  -2.459  0.0189     0.0667    1.42  0.236
    x2           -1.3397  0.846  -2.610  0.5053     0.1333    2.57  0.210
    x3           -0.5211  0.756  -1.880  0.6700     0.6000    1.71  0.127
    x4           -0.0489  0.652  -1.164  0.9551     1.0000    4.05  0.393
    time         -1.6458  0.201  -1.963 -1.2882     0.0000    1.09  0.183
    
    Posterior summary of random effects covariance matrix:
                Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_y_id[1,1] 15.1 2.96   11    21               1.39   0.23
    
    Posterior summary of residual std. deviation:
            Mean    SD 2.5% 97.5% GR-crit MCE/SD
    sigma_y 4.38 0.193 3.99  4.67    2.13  0.183
    
    
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
                   Mean    SD     2.5%   97.5% tail-prob. GR-crit MCE/SD
    (Intercept) -11.747 0.927 -13.3860 -10.317     0.0000    1.84  0.183
    o22           1.814 0.950   0.7946   3.695     0.0000    3.82  0.323
    o23           1.340 0.716   0.1344   2.456     0.0667    1.74  0.205
    o24          -1.429 0.944  -3.0604   0.290     0.2000    3.33  0.331
    o1.L          1.007 0.542  -0.0478   1.879     0.1333    1.65  0.215
    o1.Q          0.289 0.496  -0.5635   1.028     0.6000    1.12  0.183
    c2           -2.170 2.527  -7.3143   1.497     0.2667    1.28  0.213
    b21          -0.632 0.921  -2.3783   0.627     0.6000    2.37  0.214
    
    Posterior summary of random effects covariance matrix:
                Mean   SD 2.5% 97.5% tail-prob. GR-crit MCE/SD
    D_y_id[1,1]   16 3.26 11.3  21.4               3.81  0.305
    
    Posterior summary of residual std. deviation:
            Mean    SD 2.5% 97.5% GR-crit MCE/SD
    sigma_y 4.88 0.227  4.5  5.32    2.95  0.232
    
    
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
            Mean       SD      2.5%   97.5% tail-prob.  GR-crit    MCE/SD
    C1 -7.925388 12.10175 -29.85393 12.4009        0.6 1.561363 0.3376896
    
    
    $m1b
    $m1b$o2
            Mean       SD      2.5%    97.5% tail-prob.  GR-crit    MCE/SD
    C1 -15.12993 16.97033 -52.96923 18.23135  0.2666667 1.840015 0.2172907
    
    
    $m1c
    $m1c$o1
             Mean        SD       2.5%     97.5% tail-prob.  GR-crit    MCE/SD
    c1 0.02264669 0.1715701 -0.2851665 0.3066444          1 1.378702 0.1825742
    
    
    $m1d
    $m1d$o2
             Mean        SD       2.5%       97.5% tail-prob.  GR-crit     MCE/SD
    c1 -0.2674255 0.1423939 -0.5728984 -0.03484079          0 1.428244 0.06102249
    
    
    $m2a
    $m2a$o1
             Mean        SD      2.5%       97.5% tail-prob.  GR-crit    MCE/SD
    C2 -0.5832702 0.3072305 -1.147961 -0.03640213          0 2.098735 0.1825742
    
    
    $m2b
    $m2b$o2
            Mean        SD       2.5%     97.5% tail-prob.  GR-crit    MCE/SD
    C2 0.2587026 0.2875599 -0.3660556 0.7053177  0.3333333 1.991069 0.2584651
    
    
    $m2c
    $m2c$o1
            Mean       SD      2.5%     97.5% tail-prob.   GR-crit    MCE/SD
    c2 -1.116249 1.022173 -2.499062 0.8037814  0.1333333 0.9822189 0.1825742
    
    
    $m2d
    $m2d$o2
            Mean       SD      2.5%    97.5% tail-prob.   GR-crit    MCE/SD
    c2 0.9525483 1.321138 -1.779717 2.868372  0.4666667 0.9969769 0.2880765
    
    
    $m3a
    $m3a$c1
                       Mean          SD          2.5%     97.5% tail-prob.  GR-crit
    (Intercept) -7.72208512 28.83025737 -109.52488926 5.4743465  0.3333333 1.159933
    o1.L         0.03038305  0.09737804   -0.13446871 0.2054076  0.7333333 1.514597
    o1.Q         0.09892350  0.09053360   -0.07745853 0.2487869  0.2000000 1.012790
                   MCE/SD
    (Intercept) 0.1825742
    o1.L        0.1825742
    o1.Q        0.1825742
    
    
    $m3b
    $m3b$c1
                       Mean         SD       2.5%       97.5% tail-prob.  GR-crit
    (Intercept)  0.38319842 0.08979798  0.2556293  0.58171530  0.0000000 6.832711
    o22         -0.08861873 0.12381609 -0.2661888  0.12693787  0.4666667 3.344019
    o23         -0.22028818 0.11264145 -0.4580881 -0.04122073  0.0000000 2.275370
    o24         -0.15928284 0.14217666 -0.4065167  0.09311458  0.2666667 4.382486
                   MCE/SD
    (Intercept) 0.7146024
    o22         0.4080280
    o23         0.2642145
    o24         0.4620964
    
    
    $m4a
    $m4a$o1
                           Mean         SD         2.5%        97.5% tail-prob.
    M22               0.6069149  0.5995331  -0.51382076  1.406677812 0.33333333
    M23               1.6691890  0.8687555   0.06175414  3.083972714 0.00000000
    M24               0.5455515  0.7714893  -0.83272672  2.441994008 0.46666667
    abs(C1 - C2)      0.7609358  0.6672672  -0.19973668  2.197780030 0.26666667
    log(C1)          -6.4235018 15.9168449 -33.97870272 22.802582494 0.80000000
    o22               1.2711888  0.7394154  -0.03589551  2.696054520 0.13333333
    o23              -1.0773505  0.6740438  -1.96318810 -0.061551030 0.06666667
    o24               0.6030141  1.0137166  -0.59115522  2.183317300 0.73333333
    o22:abs(C1 - C2) -0.6856180  0.3840179  -1.36826291 -0.006642153 0.06666667
    o23:abs(C1 - C2) -0.1285178  0.4204780  -0.72878581  0.530361418 0.80000000
    o24:abs(C1 - C2) -0.1737948  0.6438473  -1.39218373  0.758588388 0.86666667
                       GR-crit    MCE/SD
    M22               2.600410 0.1978183
    M23               3.069147 0.3597047
    M24               1.960261 0.3269108
    abs(C1 - C2)      2.080572 0.3439067
    log(C1)           1.582392 0.1825742
    o22               5.491820 0.4707901
    o23               7.221835 0.4428014
    o24              14.556402 0.9941463
    o22:abs(C1 - C2)  3.687006 0.4602178
    o23:abs(C1 - C2)  5.685318 0.6861445
    o24:abs(C1 - C2)  7.221410 0.7950850
    
    
    $m4b
    $m4b$o1
                                                                     Mean        SD
    abs(C1 - C2)                                                0.4729205 0.2584860
    log(C1)                                                    -8.8464243 9.8975381
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)              -0.5136087 0.6113228
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  0.1729866 0.3271131
                                                                        2.5%
    abs(C1 - C2)                                                 0.005481029
    log(C1)                                                    -30.265971051
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)               -1.695890740
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2)  -0.390515704
                                                                   97.5% tail-prob.
    abs(C1 - C2)                                               0.9552189 0.06666667
    log(C1)                                                    7.0274734 0.33333333
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)              0.4332628 0.33333333
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2) 0.8537039 0.53333333
                                                                GR-crit    MCE/SD
    abs(C1 - C2)                                               2.468282 0.3895358
    log(C1)                                                    1.107555 0.1825742
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0)              5.382608 0.4077298
    ifelse(as.numeric(o2) > as.numeric(M1), 1, 0):abs(C1 - C2) 3.107606 0.2550895
    
    
    $m4c
    $m4c$o1
                 Mean         SD        2.5%      97.5% tail-prob.  GR-crit
    C1   -2.477846625 3.29578888 -7.62611614 3.10569098  0.5333333 3.426009
    B21   0.009167661 0.06780996 -0.08767717 0.13506643  0.8666667 3.937416
    time -0.019477808 0.04859244 -0.09393696 0.06792336  0.6000000 4.087600
    c1    0.039824745 0.12492659 -0.13429377 0.24045131  1.0000000 5.920871
            MCE/SD
    C1   0.2824539
    B21  0.3220318
    time 0.3122238
    c1   0.5063398
    
    
    $m4d
    $m4d$o1
                     Mean        SD         2.5%        97.5% tail-prob.  GR-crit
    C1        -3.24405740 5.4769559 -12.29239698  5.569689130  0.5333333 1.398097
    time       0.34746303 0.1938009   0.08211350  0.723092571  0.0000000 2.911407
    I(time^2) -0.03583755 0.0159074  -0.06913376 -0.014375423  0.0000000 1.392135
    b21        0.64830015 0.5101540  -0.58208242  1.347776598  0.1333333 3.520811
    c1        -0.01318653 0.1932787  -0.28189540  0.324271674  0.7333333 2.016778
    C1:time   -0.16972186 0.1222192  -0.40339407  0.004293776  0.1333333 3.034204
    b21:c1    -0.10392670 0.5392668  -1.16478892  0.763189224  0.9333333 2.591679
                 MCE/SD
    C1        0.3956335
    time      0.3192929
    I(time^2) 0.1825742
    b21       0.3078144
    c1        0.2252736
    C1:time   0.4569599
    b21:c1    0.3212834
    
    
    $m4e
    $m4e$o1
                      Mean         SD         2.5%      97.5% tail-prob.  GR-crit
    C1        -6.679594443 7.39201441 -18.47754335 2.71535734  0.4000000 1.946729
    log(time) -0.107362927 0.11434379  -0.29043319 0.09771717  0.4666667 1.884464
    I(time^2) -0.007610436 0.01446964  -0.03774125 0.01281260  0.6000000 1.686151
    p1        -0.043236749 0.04300678  -0.11210675 0.04129903  0.2666667 1.436689
                 MCE/SD
    C1        0.3463941
    log(time) 0.2432107
    I(time^2) 0.2155272
    p1        0.1825742
    
    
    $m5a
    $m5a$o1
                     Mean         SD        2.5%      97.5% tail-prob.  GR-crit
    O22        0.14210637  0.5674312  -0.9302746 1.11906650 0.53333333 4.203882
    O23        0.31010348  0.6066037  -1.0524381 1.19572863 0.46666667 4.104598
    o12: C1  -14.09666768  9.6206366 -34.0757259 2.38649907 0.13333333 3.099386
    o12: C2   -0.05035175  0.3338402  -0.5402391 0.58227075 0.80000000 3.341282
    o13: C1  -15.19261387 11.7227491 -34.1626307 4.27941833 0.26666667 2.491391
    o13: C2   -0.33643981  0.2573592  -0.8294186 0.09235476 0.20000000 2.727137
    o12: b21   0.70278756  0.5178993  -0.2406003 1.53268861 0.20000000 2.146699
    o13: b21   0.71334463  0.3515892   0.1370949 1.31352473 0.06666667 2.412406
                MCE/SD
    O22      0.5167711
    O23      0.4300558
    o12: C1  0.4633001
    o12: C2  0.3928230
    o13: C1  0.2820119
    o13: C2  0.2979475
    o12: b21 0.2346998
    o13: b21 0.2141493
    
    
    $m5b
    $m5b$o1
                   Mean        SD         2.5%     97.5% tail-prob.  GR-crit
    M22     -0.49569842 0.7690426 -2.084008061 0.7973864 0.53333333 2.586563
    M23      0.01298077 0.6891883 -0.971386352 1.5635718 0.93333333 2.743111
    M24     -0.90015640 0.6928370 -2.181758089 0.1460613 0.13333333 3.182664
    O22      0.29304634 0.6812384 -1.079488392 1.4888339 0.60000000 1.169980
    O23      0.66855897 0.8052048 -0.474005762 2.1148438 0.60000000 2.838490
    o12: C2 -0.20244157 0.4363922 -0.785297580 0.7309578 0.46666667 8.001925
    o13: C2 -0.46162268 0.4932495 -1.196127099 0.3667669 0.46666667 7.509757
    c1:C2    0.56664331 0.3974353 -0.088854450 1.2603537 0.13333333 2.274987
    o12: c1  0.25443416 0.3187164 -0.438953531 0.6434105 0.40000000 1.189872
    o13: c1  0.68751950 0.3222196 -0.005529997 1.1788545 0.06666667 1.061001
               MCE/SD
    M22     0.2993290
    M23     0.4405553
    M24     0.2270214
    O22     0.2386910
    O23     0.2618795
    o12: C2 0.5128617
    o13: C2 0.2556563
    c1:C2   0.2796126
    o12: c1 0.2277474
    o13: c1 0.2180725
    
    
    $m5c
    $m5c$o1
                      Mean        SD         2.5%     97.5% tail-prob.  GR-crit
    M22         0.29683564 1.0053345 -1.645249462 1.7590590 0.66666667 2.773572
    M23         1.20687653 0.9773527 -0.673637614 2.7439929 0.20000000 2.127884
    M24        -0.46318436 0.7215374 -1.726351113 0.8347648 0.40000000 2.436319
    O22         0.03442037 1.0172050 -1.555489219 1.8914068 1.00000000 1.690887
    O23         0.15470224 0.6615911 -1.115827129 1.4307916 0.73333333 1.946961
    o12: C2     0.06389382 0.4209221 -0.620631733 0.8597524 0.80000000 3.576646
    o13: C2    -0.32467897 0.2677752 -0.754611287 0.2070102 0.33333333 1.289504
    o12: c1     0.22547225 0.4226797 -0.411151536 0.9728807 0.73333333 2.764359
    o12: c1:C2  0.59153131 0.3394279 -0.028674696 1.1186266 0.13333333 3.550451
    o13: c1     0.93141079 0.4201785  0.166637694 1.4804937 0.00000000 5.272677
    o13: c1:C2  0.77398469 0.4598176  0.003261384 1.4666859 0.06666667 4.190389
                  MCE/SD
    M22        0.4701095
    M23        0.3363107
    M24        0.4841061
    O22        0.3984609
    O23        0.3295635
    o12: C2    0.4811368
    o13: C2    0.1825742
    o12: c1    0.4490876
    o12: c1:C2 0.4955347
    o13: c1    0.5332566
    o13: c1:C2 0.4889223
    
    
    $m5d
    $m5d$o1
                   Mean        SD        2.5%     97.5% tail-prob.  GR-crit
    M22     -0.73380719 1.1245049 -2.51994134 1.5399140  0.5333333 4.029006
    M23      1.46442352 0.9876810 -0.36054784 3.1423893  0.2000000 1.719916
    M24     -1.11215720 1.1091622 -3.17377592 0.5926373  0.3333333 1.598869
    O22      0.61156526 0.5692680 -0.30946224 1.6813366  0.4666667 1.703415
    O23      0.76957519 0.5541067 -0.08971406 1.7432343  0.2666667 1.100010
    M22:C2  -0.96940864 0.9928523 -2.58246317 0.6861062  0.2666667 1.079535
    M23:C2   0.43525494 1.1109733 -1.28948777 2.6784602  0.6666667 3.080705
    M24:C2  -0.91094789 1.3983101 -2.94183296 1.2547480  0.6000000 5.682916
    o12: C2  0.28818454 0.8523297 -1.06836271 1.8231393  0.7333333 8.399205
    o13: C2 -0.10011912 0.6740700 -1.02186213 1.2673127  0.8666667 6.391557
    o12: c1 -0.08608693 0.1953189 -0.37420573 0.3004297  0.4666667 1.093693
    o13: c1  0.27135980 0.2585944 -0.13875606 0.7243975  0.3333333 1.835016
               MCE/SD
    M22     0.5871084
    M23     0.2232038
    M24     0.2514457
    O22     0.1825742
    O23     0.2088709
    M22:C2  0.3263583
    M23:C2  0.4214820
    M24:C2  0.2503056
    o12: C2 0.6400588
    o13: C2 0.4856658
    o12: c1 0.1825742
    o13: c1 0.2034248
    
    
    $m5e
    $m5e$o1
                       Mean        SD       2.5%       97.5% tail-prob.  GR-crit
    o12: M22    -0.10767414 0.3921676 -0.7354685  0.62944682 0.73333333 4.156397
    o12: M23     1.04315238 0.6107652  0.2033432  2.18644696 0.06666667 1.021557
    o12: M24     0.14130401 0.2912363 -0.2724786  0.85205184 0.60000000 1.733235
    o12: C2     -0.07027105 0.5949846 -1.1759750  0.87646918 0.93333333 8.075013
    o12: O22     0.40583545 0.5472474 -0.4991370  1.16754325 0.60000000 4.006482
    o12: O23     0.40622744 0.3741072 -0.1606294  1.13653044 0.33333333 3.175337
    o12: M22:C2 -0.21852748 0.6977236 -1.1998344  1.01898804 0.60000000 5.743878
    o12: M23:C2  0.43156032 0.5239203 -0.5269527  1.53988500 0.40000000 7.054723
    o12: M24:C2  0.06859126 1.0514375 -1.2303256  1.85302179 0.86666667 7.737955
    o13: M22    -1.36647926 0.7498071 -2.8476337 -0.54600535 0.00000000 6.977492
    o13: M23     0.38625775 0.5511290 -0.3707003  1.34972369 0.53333333 5.395269
    o13: M24    -0.28372752 0.4660478 -1.2656575  0.51839457 0.60000000 4.127577
    o13: C2      0.46839290 0.4806774 -0.4428088  1.23972025 0.26666667 5.959846
    o13: O22    -0.67836033 0.3529477 -1.2026289 -0.07359378 0.00000000 3.021978
    o13: O23    -0.06247163 0.3296876 -0.6302249  0.50805596 0.80000000 3.055963
    o13: M22:C2 -1.58615242 0.4021587 -2.2564383 -0.98607961 0.00000000 1.737542
    o13: M23:C2 -0.98569715 0.6258253 -2.1624013 -0.16659643 0.00000000 4.044004
    o13: M24:C2 -0.57879073 0.8193484 -1.9147631  0.73071495 0.53333333 9.093211
    o12: c1     -0.17856977 0.1824624 -0.5374548  0.15204213 0.40000000 1.314205
    o13: c1      0.15795824 0.2375063 -0.2008339  0.53836642 0.60000000 1.124704
                   MCE/SD
    o12: M22    0.6545059
    o12: M23    0.1368900
    o12: M24    0.3429716
    o12: C2     0.5245870
    o12: O22    0.5301434
    o12: O23    0.3519557
    o12: M22:C2 0.5230328
    o12: M23:C2 0.3807686
    o12: M24:C2 0.5620827
    o13: M22    0.5889249
    o13: M23    0.5332364
    o13: M24    0.5111064
    o13: C2     0.5053031
    o13: O22    0.3786988
    o13: O23    0.4681197
    o13: M22:C2 0.5104144
    o13: M23:C2 0.5790148
    o13: M24:C2 0.8504581
    o12: c1     0.1825742
    o13: c1     0.1825742
    
    
    $m6a
    $m6a$o1
                   Mean         SD         2.5%       97.5% tail-prob.  GR-crit
    O22      -0.4160980  0.5279404  -1.13479983  0.51887144 0.60000000 6.643382
    O23      -0.5571939  0.6142867  -1.31647925  0.59101797 0.46666667 7.821257
    o12: C1   7.2638436 13.6407059 -13.55929840 28.98451252 0.66666667 1.281373
    o12: C2   0.1223253  0.4381936  -0.74770240  0.81733270 0.80000000 2.990923
    o13: C1   1.4124623 12.5165045 -22.87326065 24.66306448 0.80000000 1.676677
    o13: C2   0.4304222  0.2904985   0.01639224  0.95293774 0.06666667 3.006435
    o12: b21 -0.7646823  0.4191889  -1.67599674  0.09681726 0.13333333 1.586677
    o13: b21 -1.0329831  0.4401389  -1.87877715 -0.42347879 0.00000000 3.452956
                MCE/SD
    O22      0.5288373
    O23      0.4662740
    o12: C1  0.2015043
    o12: C2  0.3418445
    o13: C1  0.4448435
    o13: C2  0.3011727
    o12: b21 0.2222031
    o13: b21 0.4835914
    
    
    $m6b
    $m6b$o1
                  Mean        SD        2.5%       97.5% tail-prob.  GR-crit
    M22      0.8364250 0.6976887 -0.03417103  2.58602012 0.06666667 2.263154
    M23     -0.2639200 0.8393284 -2.15414504  0.86557357 0.86666667 2.060376
    M24      0.5441793 0.5981553 -0.33044935  1.48686634 0.46666667 2.404299
    O22     -0.2213229 0.6670441 -1.46026218  0.85578674 0.80000000 1.447171
    O23     -0.6420012 0.4516848 -1.50241652  0.05911442 0.13333333 1.838130
    o12: C2  0.2958578 0.4735885 -0.40699367  1.07497362 0.53333333 4.897300
    o13: C2  0.7695723 0.4406904  0.14197382  1.67076592 0.00000000 3.500165
    c1:C2   -0.7320974 0.3845026 -1.33202824 -0.02574031 0.06666667 3.975293
    o12: c1 -0.2507145 0.3283163 -0.88061830  0.31772808 0.53333333 2.557243
    o13: c1 -0.7240615 0.3470735 -1.34532481 -0.12947825 0.06666667 2.980859
               MCE/SD
    M22     0.3415407
    M23            NA
    M24     0.3477028
    O22     0.3030628
    O23     0.2356274
    o12: C2 0.3783128
    o13: C2 0.4535072
    c1:C2   0.4909222
    o12: c1 0.2759054
    o13: c1 0.3025906
    
    
    $m6c
    $m6c$o1
                      Mean        SD       2.5%       97.5% tail-prob.   GR-crit
    M22        -0.67947122 0.7892804 -2.4959563  0.37291793 0.33333333 2.6579787
    M23        -1.50087513 0.5817715 -2.7364502 -0.56053772 0.00000000 0.9979593
    M24        -0.54457960 0.6151148 -1.7272434  0.46724645 0.33333333 1.1494767
    O22         0.20506961 0.5334214 -0.6305035  1.17496922 0.73333333 4.1687828
    O23        -0.13053241 0.5515881 -1.1380572  0.74286976 0.80000000 1.3799215
    o12: C2    -0.05928772 0.3552193 -0.7698483  0.54345437 0.80000000 6.5865145
    o13: C2     0.33127965 0.4995269 -0.3635105  1.20810394 0.53333333 5.7366493
    o12: c1    -0.27379246 0.2737499 -0.6489835  0.17301853 0.46666667 4.3614354
    o12: c1:C2 -0.56823400 0.3490809 -1.0164986  0.01054438 0.06666667 5.3063685
    o13: c1    -0.74529771 0.4096552 -1.3372007 -0.04408089 0.06666667 2.2090334
    o13: c1:C2 -0.56233010 0.4244555 -1.1358340  0.39668180 0.26666667 1.9226823
                  MCE/SD
    M22        0.4505753
    M23        0.1825742
    M24        0.1188446
    O22        0.5127343
    O23        0.2297186
    o12: C2    0.4674283
    o13: C2    0.4923838
    o12: c1    0.3967172
    o12: c1:C2 0.4366427
    o13: c1    0.3604430
    o13: c1:C2 0.3713719
    
    
    $m6d
    $m6d$o1
                    Mean        SD        2.5%       97.5% tail-prob.  GR-crit
    M22      0.559481280 0.9310205 -1.52549246  2.09584673 0.46666667 2.641107
    M23     -2.108465295 1.4584035 -5.38014392 -0.20675150 0.06666667 3.662946
    M24     -0.342856733 1.0461158 -1.84435325  1.88365274 0.53333333 2.809332
    O22      0.533833814 0.7774507 -0.82911367  1.92820942 0.40000000 1.884377
    O23     -0.008488434 0.8474831 -1.67306531  1.08814483 0.86666667 2.901645
    M22:C2   0.658544120 0.8054489 -0.80531061  1.81173000 0.53333333 1.050551
    M23:C2  -0.700699830 1.3993713 -3.28454510  1.87588768 0.53333333 3.691928
    M24:C2  -0.654118798 1.0938716 -2.51073175  1.56920045 0.60000000 1.147508
    o12: C2  0.309555073 0.3449236 -0.30856651  0.90456842 0.33333333 4.187951
    o13: C2  0.504960057 0.4038537 -0.07874678  1.23860394 0.13333333 2.761482
    o12: c1  0.107983707 0.2536349 -0.33782517  0.48957365 0.80000000 1.938636
    o13: c1 -0.428338335 0.2643577 -0.88884171  0.09171705 0.13333333 3.048865
               MCE/SD
    M22     0.2325784
    M23     0.3404131
    M24     0.3821319
    O22     0.1825742
    O23     0.2142682
    M22:C2  0.1825742
    M23:C2  0.3803993
    M24:C2  0.2277554
    o12: C2 0.4924286
    o13: C2 0.4462763
    o12: c1 0.1825742
    o13: c1 0.2694294
    
    
    $m6e
    $m6e$o1
                       Mean        SD        2.5%       97.5% tail-prob.   GR-crit
    o12: M22    -0.47382777 0.8313756 -1.89433499 0.627841889 0.66666667  9.631190
    o12: M23    -0.87264287 0.5277553 -1.62990079 0.005287224 0.06666667  2.741272
    o12: M24    -0.20391766 0.2546191 -0.63474010 0.228160634 0.40000000  1.644933
    o12: C2      0.01789769 0.3332065 -0.52240526 0.580326397 1.00000000  4.932886
    o12: O22    -0.43393298 0.3527845 -1.13018749 0.014549451 0.13333333  2.098115
    o12: O23    -0.39315885 0.3819417 -0.91333936 0.501445356 0.20000000  3.861608
    o12: M22:C2  0.08460397 0.3146756 -0.54273377 0.566713262 0.66666667  3.288466
    o12: M23:C2 -0.34286582 0.5669126 -1.23668455 0.540133935 0.53333333  5.122434
    o12: M24:C2 -0.15011635 0.5872776 -1.14987201 0.746887563 0.86666667  7.011517
    o13: M22     0.83801957 0.5743786  0.07426814 1.912196390 0.00000000  2.227093
    o13: M23    -0.21289780 0.5298270 -1.20301909 0.507046458 0.80000000  4.306403
    o13: M24    -0.26744724 0.4976939 -1.17286267 0.436619094 0.53333333  4.395937
    o13: C2     -0.24927958 0.5647890 -1.13174013 0.542659799 0.73333333  8.864393
    o13: O22     0.09218536 0.2842000 -0.42548191 0.662458007 0.66666667  3.962784
    o13: O23    -0.16223952 0.4350561 -0.76745028 0.585402015 0.66666667  8.970156
    o13: M22:C2  1.08610521 0.7629239  0.02938175 2.558669444 0.06666667  6.892056
    o13: M23:C2  0.76319974 0.2706887  0.21908264 1.178508745 0.06666667  2.087298
    o13: M24:C2  0.11785553 0.9077053 -0.80899814 1.899811883 0.66666667 14.060298
    o12: c1      0.14915853 0.3256578 -0.27836808 0.972890649 0.60000000  2.350096
    o13: c1     -0.25657073 0.2449689 -0.65634619 0.192001113 0.33333333  1.455799
                   MCE/SD
    o12: M22    0.8069768
    o12: M23    0.4827573
    o12: M24    0.3320257
    o12: C2     0.5387766
    o12: O22    0.2385413
    o12: O23    0.4319156
    o12: M22:C2 0.4373627
    o12: M23:C2 0.5335668
    o12: M24:C2 0.4508238
    o13: M22    0.5062736
    o13: M23    0.5140463
    o13: M24    0.5393219
    o13: C2     0.4535940
    o13: O22    0.2664302
    o13: O23    0.4569067
    o13: M22:C2 0.5223480
    o13: M23:C2 0.1825742
    o13: M24:C2 0.7452067
    o12: c1     0.3569422
    o13: c1     0.2370848
    
    
    $m7a
    $m7a$y
                        Mean         SD        2.5%       97.5% tail-prob.  GR-crit
    (Intercept)  22.65717813 22.9189213 -13.7369574 59.88259806 0.40000000 1.222817
    C1          -39.92145622 31.0988503 -91.0339519  9.81986683 0.20000000 1.252648
    o1.L          0.66512769  0.4696920  -0.2228435  1.36792708 0.26666667 1.108587
    o1.Q          0.33498727  0.4159481  -0.5365374  1.05923135 0.33333333 1.692782
    o22           0.96383091  0.9120881  -0.2502464  3.16153686 0.33333333 2.608573
    o23           1.42084992  0.7262264   0.2265291  2.71848857 0.06666667 2.246098
    o24          -1.42699640  0.6325290  -2.4586899  0.01888373 0.06666667 1.424570
    x2           -1.33972918  0.8458692  -2.6104714  0.50534675 0.13333333 2.570812
    x3           -0.52114836  0.7555624  -1.8804197  0.67004053 0.60000000 1.712633
    x4           -0.04886736  0.6515110  -1.1640423  0.95512544 1.00000000 4.051461
    time         -1.64584397  0.2012466  -1.9632493 -1.28824005 0.00000000 1.089852
                   MCE/SD
    (Intercept) 0.1825742
    C1          0.1825742
    o1.L        0.1825742
    o1.Q               NA
    o22         0.4905557
    o23         0.2316965
    o24         0.2358027
    x2          0.2103040
    x3          0.1273831
    x4          0.3926097
    time        0.1825742
    
    
    $m7b
    $m7b$y
                       Mean        SD         2.5%       97.5% tail-prob.  GR-crit
    (Intercept) -11.7470100 0.9269411 -13.38603521 -10.3169281 0.00000000 1.837559
    o22           1.8143807 0.9498907   0.79456826   3.6954364 0.00000000 3.820602
    o23           1.3401226 0.7157419   0.13438940   2.4564851 0.06666667 1.743017
    o24          -1.4287042 0.9442650  -3.06036256   0.2904691 0.20000000 3.331466
    o1.L          1.0067962 0.5417741  -0.04777933   1.8787537 0.13333333 1.649040
    o1.Q          0.2891074 0.4963349  -0.56350757   1.0280544 0.60000000 1.116453
    c2           -2.1701021 2.5269647  -7.31427618   1.4970016 0.26666667 1.278833
    b21          -0.6315147 0.9206429  -2.37829792   0.6265542 0.60000000 2.372864
                   MCE/SD
    (Intercept) 0.1825742
    o22         0.3230828
    o23         0.2054636
    o24         0.3305578
    o1.L        0.2146497
    o1.Q        0.1825742
    c2          0.2130841
    b21         0.2142203
    
    

