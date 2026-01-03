# Simulated Longitudinal Data in Long and Wide Format

This data was simulated to mimic data from a longitudinal cohort study
following mothers and their child from birth until approximately 4 years
of age. It contains 2400 observations of 200 mother-child pairs.
Children's BMI and head circumference was measured repeatedly and their
age in months was recorded at each measurement. Furthermore, the data
contain several baseline variables with information on the mothers'
demographics and socio-economic status.

## Usage

``` r
simLong

simWide
```

## Format

`simLong`: A data frame in long format with 2400 rows and 16 variables

`simWide`: A data frame in wide format with 200 rows and 81 variables

An object of class `data.frame` with 2400 rows and 16 columns.

An object of class `data.frame` with 200 rows and 81 columns.

## Baseline covariates

(in `simLong` and `simWide`)

- GESTBIR:

  gestational age at birth (in weeks)

- ETHN:

  ethnicity (binary: European vs. other)

- AGE_M:

  age of the mother at intake

- HEIGHT_M:

  height of the mother (in cm)

- PARITY:

  number of times the mother has given birth (binary: 0 vs. \>=1)

- SMOKE:

  smoking status of the mother during pregnancy (3 ordered categories:
  never smoked during pregnancy, smoked until pregnancy was known,
  continued smoking in pregnancy)

- EDUC:

  educational level of the mother (3 ordered categories: low, mid, high)

- MARITAL:

  marital status (3 categories)

- ID:

  subject identifier

## Long-format variables

(only in `simLong`)

- time:

  measurement occasion/visit (by design, children should be measured
  at/around 1, 2, 3, 4, 7, 11, 15, 20, 26, 32, 40 and 50 months of age)

- age:

  child age at measurement time in months

- bmi:

  child BMI

- hc:

  child head circumference in cm

- hgt:

  child height in cm

- wgt:

  child weight in gram

- sleep:

  sleeping behaviour of the child (3 ordered categories)

## Wide-format variables

(only in `simWide`)

- age1, age2, age3, age4, age7, age11, age15, age20, age26, age32,
  age40, age50:

  child age at the repeated measurements in months

- bmi1, bmi2, bmi3, bmi4, bmi7, bmi11, bmi15, bmi20, bmi26, bmi32,
  bmi40, bmi50:

  repeated measurements of child BMI

- hc1, hc2, hc3, hc4, hc7, hc11, hc15, hc20, hc26, hc32, hc40, hc50:

  repeated measurements of child head circumference in cm

- hgt1, hgt2, hgt3, hgt4, hgt7, hgt11, hgt15, hgt20, hgt26, hgt32,
  hgt40, hgt50:

  repeated measurements of child height in cm

- wgt1, wgt2, wgt3, wgt4, wgt7, wgt11, wgt15, wgt20, wgt26, wgt32,
  wgt40, wgt50:

  repeated measurements of child weight in gram

- sleep1, sleep2, sleep3, sleep4, sleep7, sleep11, sleep15, sleep20,
  sleep26, sleep32, sleep40, sleep50:

  repeated measurements of child sleep behaviour (3 ordered categories)

## Examples

``` r
 summary(simLong)
#>     GESTBIR            ETHN          AGE_M          HEIGHT_M      PARITY    
#>  Min.   :37.21   European:1620   Min.   :16.40   Min.   :151.7   0   :1440  
#>  1st Qu.:39.30   other   : 708   1st Qu.:26.91   1st Qu.:163.6   >= 1: 888  
#>  Median :40.17   NA's    :  72   Median :30.26   Median :169.1   NA's:  72  
#>  Mean   :40.23                   Mean   :30.34   Mean   :168.8              
#>  3rd Qu.:41.04                   3rd Qu.:33.90   3rd Qu.:173.9              
#>  Max.   :44.49                   Max.   :47.07   Max.   :185.2              
#>                                                  NA's   :48                 
#>                               SMOKE        EDUC                 MARITAL    
#>  never smoked during pregnancy   :1620   high:1104   married        :1212  
#>  smoked until pregnancy was known: 132   mid : 876   living together: 768  
#>  continued smoking in pregnancy  : 372   low : 228   no partner     : 228  
#>  NA's                            : 276   NA's: 192   NA's           : 192  
#>                                                                            
#>                                                                            
#>                                                                            
#>       time            age               bmi              hc       
#>  Min.   : 1.00   Min.   : 0.5086   Min.   :10.82   Min.   :31.83  
#>  1st Qu.: 3.75   1st Qu.: 3.9900   1st Qu.:15.85   1st Qu.:41.63  
#>  Median :13.00   Median :12.8095   Median :16.64   Median :45.59  
#>  Mean   :17.58   Mean   :16.7850   Mean   :16.55   Mean   :45.33  
#>  3rd Qu.:27.50   3rd Qu.:28.4537   3rd Qu.:17.37   3rd Qu.:49.07  
#>  Max.   :50.00   Max.   :48.8542   Max.   :19.65   Max.   :56.43  
#>                                    NA's   :519     NA's   :567    
#>       hgt              wgt               sleep          ID           
#>  Min.   : 48.83   Min.   : 2353   no problem:717   Length:2400       
#>  1st Qu.: 64.97   1st Qu.: 6701   sometimes :915   Class :character  
#>  Median : 78.80   Median : 9902   difficult :176   Mode  :character  
#>  Mean   : 78.96   Mean   :10295   NA's      :592                     
#>  3rd Qu.: 91.58   3rd Qu.:13460                                      
#>  Max.   :116.83   Max.   :23855                                      
#>  NA's   :479      NA's   :210                                        
 summary(simWide)
#>     GESTBIR            ETHN         AGE_M          HEIGHT_M      PARITY   
#>  Min.   :37.21   European:135   Min.   :16.40   Min.   :151.7   0   :120  
#>  1st Qu.:39.30   other   : 59   1st Qu.:26.91   1st Qu.:163.6   >= 1: 74  
#>  Median :40.17   NA's    :  6   Median :30.26   Median :169.1   NA's:  6  
#>  Mean   :40.23                  Mean   :30.34   Mean   :168.8             
#>  3rd Qu.:41.04                  3rd Qu.:33.90   3rd Qu.:173.9             
#>  Max.   :44.49                  Max.   :47.07   Max.   :185.2             
#>                                                 NA's   :4                 
#>                               SMOKE       EDUC               MARITAL   
#>  never smoked during pregnancy   :135   high:92   married        :101  
#>  smoked until pregnancy was known: 11   mid :73   living together: 64  
#>  continued smoking in pregnancy  : 31   low :19   no partner     : 19  
#>  NA's                            : 23   NA's:16   NA's           : 16  
#>                                                                        
#>                                                                        
#>                                                                        
#>       ID                 age1             bmi1            hc1       
#>  Length:200         Min.   :0.5086   Min.   :11.81   Min.   :31.83  
#>  Class :character   1st Qu.:0.9767   1st Qu.:14.30   1st Qu.:36.43  
#>  Mode  :character   Median :1.1596   Median :15.18   Median :37.28  
#>                     Mean   :1.1341   Mean   :15.30   Mean   :37.30  
#>                     3rd Qu.:1.2787   3rd Qu.:16.32   3rd Qu.:38.29  
#>                     Max.   :1.8476   Max.   :19.22   Max.   :40.87  
#>                                                      NA's   :26     
#>       hgt1            wgt1             sleep1        age2            bmi2      
#>  Min.   :48.83   Min.   :2353   no problem:28   Min.   :2.004   Min.   :12.43  
#>  1st Qu.:53.32   1st Qu.:4092   sometimes :89   1st Qu.:2.209   1st Qu.:15.20  
#>  Median :55.01   Median :4680   difficult :32   Median :2.363   Median :16.13  
#>  Mean   :54.97   Mean   :4680   NA's      :51   Mean   :2.387   Mean   :16.11  
#>  3rd Qu.:56.66   3rd Qu.:5263                   3rd Qu.:2.511   3rd Qu.:16.96  
#>  Max.   :60.69   Max.   :6432                   Max.   :2.984   Max.   :20.00  
#>  NA's   :56      NA's   :12                                                    
#>       hc2             hgt2            wgt2             sleep2        age3      
#>  Min.   :36.97   Min.   :53.48   Min.   :3738   no problem:45   Min.   :3.002  
#>  1st Qu.:39.25   1st Qu.:57.52   1st Qu.:5248   sometimes :89   1st Qu.:3.251  
#>  Median :40.28   Median :59.25   Median :5683   difficult :22   Median :3.385  
#>  Mean   :40.22   Mean   :59.24   Mean   :5763   NA's      :44   Mean   :3.419  
#>  3rd Qu.:41.03   3rd Qu.:60.83   3rd Qu.:6342                   3rd Qu.:3.583  
#>  Max.   :43.85   Max.   :65.46   Max.   :7561                   Max.   :3.951  
#>  NA's   :43      NA's   :87      NA's   :29                                    
#>       bmi3            hc3             hgt3            wgt3             sleep3  
#>  Min.   :13.14   Min.   :38.34   Min.   :56.61   Min.   :4338   no problem:42  
#>  1st Qu.:15.77   1st Qu.:40.71   1st Qu.:60.48   1st Qu.:5978   sometimes :85  
#>  Median :16.79   Median :41.48   Median :61.83   Median :6429   difficult :21  
#>  Mean   :16.82   Mean   :41.63   Mean   :62.07   Mean   :6487   NA's      :52  
#>  3rd Qu.:17.78   3rd Qu.:42.55   3rd Qu.:63.82   3rd Qu.:6975                  
#>  Max.   :20.83   Max.   :45.72   Max.   :68.26   Max.   :8785                  
#>                  NA's   :28      NA's   :63      NA's   :17                    
#>       age4            bmi4            hc4             hgt4            wgt4     
#>  Min.   :4.003   Min.   :13.56   Min.   :39.21   Min.   :58.22   Min.   :4909  
#>  1st Qu.:4.251   1st Qu.:16.26   1st Qu.:41.51   1st Qu.:62.38   1st Qu.:6435  
#>  Median :4.390   Median :17.10   Median :42.34   Median :64.07   Median :6917  
#>  Mean   :4.427   Mean   :17.08   Mean   :42.48   Mean   :64.24   Mean   :6948  
#>  3rd Qu.:4.589   3rd Qu.:18.01   3rd Qu.:43.51   3rd Qu.:66.20   3rd Qu.:7520  
#>  Max.   :4.993   Max.   :20.88   Max.   :46.25   Max.   :70.75   Max.   :9227  
#>                                  NA's   :45      NA's   :87      NA's   :28    
#>         sleep4         age7            bmi7            hc7       
#>  no problem: 37   Min.   :5.038   Min.   :13.48   Min.   :40.52  
#>  sometimes :100   1st Qu.:5.772   1st Qu.:16.32   1st Qu.:42.84  
#>  difficult : 28   Median :6.278   Median :17.40   Median :43.93  
#>  NA's      : 35   Mean   :6.260   Mean   :17.33   Mean   :43.89  
#>                   3rd Qu.:6.724   3rd Qu.:18.20   3rd Qu.:45.03  
#>                   Max.   :8.005   Max.   :20.63   Max.   :47.66  
#>                                                   NA's   :30     
#>       hgt7            wgt7              sleep7       age11      
#>  Min.   :61.38   Min.   : 5446   no problem:24   Min.   :10.11  
#>  1st Qu.:65.70   1st Qu.: 7165   sometimes :93   1st Qu.:10.74  
#>  Median :67.51   Median : 7851   difficult :26   Median :11.17  
#>  Mean   :67.58   Mean   : 7831   NA's      :57   Mean   :11.18  
#>  3rd Qu.:69.53   3rd Qu.: 8513                   3rd Qu.:11.57  
#>  Max.   :74.28   Max.   :10786                   Max.   :12.44  
#>  NA's   :36      NA's   :16                                     
#>      bmi11            hc11           hgt11           wgt11      
#>  Min.   :12.49   Min.   :42.61   Min.   :68.36   Min.   : 7018  
#>  1st Qu.:16.47   1st Qu.:44.78   1st Qu.:72.13   1st Qu.: 8760  
#>  Median :17.49   Median :45.71   Median :74.13   Median : 9577  
#>  Mean   :17.38   Mean   :45.95   Mean   :74.43   Mean   : 9574  
#>  3rd Qu.:18.31   3rd Qu.:47.22   3rd Qu.:76.66   3rd Qu.:10326  
#>  Max.   :21.11   Max.   :50.62   Max.   :82.79   Max.   :12566  
#>                  NA's   :28      NA's   :17      NA's   :13     
#>        sleep11        age15           bmi15            hc15      
#>  no problem: 37   Min.   :13.18   Min.   :13.76   Min.   :42.94  
#>  sometimes :100   1st Qu.:14.06   1st Qu.:16.38   1st Qu.:45.44  
#>  difficult : 11   Median :14.47   Median :17.14   Median :46.61  
#>  NA's      : 52   Mean   :14.48   Mean   :17.20   Mean   :46.56  
#>                   3rd Qu.:14.87   3rd Qu.:18.09   3rd Qu.:47.51  
#>                   Max.   :16.56   Max.   :20.50   Max.   :50.29  
#>                                                   NA's   :112    
#>      hgt15           wgt15             sleep15       age20      
#>  Min.   :70.42   Min.   : 6755   no problem:54   Min.   :17.02  
#>  1st Qu.:76.41   1st Qu.: 9642   sometimes :82   1st Qu.:18.15  
#>  Median :78.41   Median :10563   difficult :12   Median :18.75  
#>  Mean   :78.31   Mean   :10491   NA's      :52   Mean   :18.78  
#>  3rd Qu.:80.13   3rd Qu.:11332                   3rd Qu.:19.35  
#>  Max.   :85.96   Max.   :13591                   Max.   :22.25  
#>  NA's   :13      NA's   :14                                     
#>      bmi20            hc20           hgt20           wgt20      
#>  Min.   :13.45   Min.   :43.79   Min.   :74.56   Min.   : 7908  
#>  1st Qu.:16.12   1st Qu.:46.59   1st Qu.:80.70   1st Qu.:10716  
#>  Median :17.05   Median :47.88   Median :83.03   Median :11637  
#>  Mean   :16.96   Mean   :47.92   Mean   :82.80   Mean   :11590  
#>  3rd Qu.:17.79   3rd Qu.:49.07   3rd Qu.:84.67   3rd Qu.:12452  
#>  Max.   :20.27   Max.   :51.92   Max.   :91.05   Max.   :15449  
#>                  NA's   :30      NA's   :17      NA's   :17     
#>        sleep20       age26           bmi26            hc26      
#>  no problem:69   Min.   :23.05   Min.   :11.98   Min.   :46.24  
#>  sometimes :81   1st Qu.:24.40   1st Qu.:15.59   1st Qu.:47.69  
#>  difficult : 8   Median :25.07   Median :16.33   Median :48.94  
#>  NA's      :42   Mean   :25.06   Mean   :16.37   Mean   :49.15  
#>                  3rd Qu.:25.75   3rd Qu.:17.17   3rd Qu.:50.32  
#>                  Max.   :28.27   Max.   :19.59   Max.   :52.76  
#>                                                  NA's   :135    
#>      hgt26           wgt26             sleep26       age32      
#>  Min.   :80.58   Min.   : 8775   no problem:85   Min.   :29.00  
#>  1st Qu.:86.21   1st Qu.:12217   sometimes :65   1st Qu.:30.01  
#>  Median :88.78   Median :13093   difficult : 7   Median :30.76  
#>  Mean   :88.69   Mean   :13149   NA's      :43   Mean   :30.78  
#>  3rd Qu.:90.98   3rd Qu.:14121                   3rd Qu.:31.37  
#>  Max.   :98.10   Max.   :18037                   Max.   :34.03  
#>  NA's   :20      NA's   :15                                     
#>      bmi32            hc32           hgt32            wgt32      
#>  Min.   :11.35   Min.   :45.33   Min.   : 82.27   Min.   : 9021  
#>  1st Qu.:15.32   1st Qu.:48.42   1st Qu.: 90.58   1st Qu.:13154  
#>  Median :16.24   Median :49.81   Median : 93.15   Median :14328  
#>  Mean   :16.28   Mean   :49.77   Mean   : 93.17   Mean   :14278  
#>  3rd Qu.:17.27   3rd Qu.:51.00   3rd Qu.: 95.64   3rd Qu.:15513  
#>  Max.   :19.80   Max.   :53.70   Max.   :102.17   Max.   :19133  
#>                  NA's   :30      NA's   :34       NA's   :20     
#>        sleep32       age40           bmi40            hc40      
#>  no problem:92   Min.   :35.06   Min.   :10.33   Min.   :45.87  
#>  sometimes :52   1st Qu.:36.42   1st Qu.:14.98   1st Qu.:48.91  
#>  difficult : 5   Median :37.31   Median :15.93   Median :50.17  
#>  NA's      :51   Mean   :37.31   Mean   :15.93   Mean   :50.31  
#>                  3rd Qu.:38.15   3rd Qu.:16.86   3rd Qu.:51.51  
#>                  Max.   :40.78   Max.   :19.45   Max.   :55.09  
#>                                                  NA's   :30     
#>      hgt40            wgt40             sleep40        age50      
#>  Min.   : 87.61   Min.   :10138   no problem:100   Min.   :44.13  
#>  1st Qu.: 95.03   1st Qu.:14169   sometimes : 45   1st Qu.:45.54  
#>  Median : 98.04   Median :15378   difficult :  3   Median :46.18  
#>  Mean   : 97.71   Mean   :15355   NA's      : 52   Mean   :46.21  
#>  3rd Qu.:100.03   3rd Qu.:16697                    3rd Qu.:46.89  
#>  Max.   :106.70   Max.   :20508                    Max.   :48.85  
#>  NA's   :24       NA's   :13                                      
#>      bmi50             hc50           hgt50            wgt50      
#>  Min.   : 9.716   Min.   :47.49   Min.   : 93.78   Min.   :11540  
#>  1st Qu.:14.827   1st Qu.:50.05   1st Qu.:101.05   1st Qu.:15490  
#>  Median :15.835   Median :51.21   Median :103.97   Median :16974  
#>  Mean   :15.848   Mean   :51.31   Mean   :103.87   Mean   :16966  
#>  3rd Qu.:16.914   3rd Qu.:52.48   3rd Qu.:106.84   3rd Qu.:18284  
#>  Max.   :20.205   Max.   :56.43   Max.   :116.83   Max.   :23855  
#>                   NA's   :30      NA's   :25       NA's   :16     
#>        sleep50   
#>  no problem:104  
#>  sometimes : 34  
#>  difficult :  1  
#>  NA's      : 61  
#>                  
#>                  
#>                  
```
