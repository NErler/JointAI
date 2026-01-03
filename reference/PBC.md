# PBC data

Data from the Mayo Clinic trial in primary biliary cirrhosis (PBC) of
the liver. This dataset was obtained from the **survival** package: the
variables `copper` and `trig` from
[`survival::pbc`](https://rdrr.io/pkg/survival/man/pbc.html) were merged
into [`survival::pbcseq`](https://rdrr.io/pkg/survival/man/pbcseq.html)
and several categorical variables were re-coded.

## Format

`PBC`: A data frame of 312 individuals in long format with 1945 rows and
21 variables.

## Survival outcome and id

- id:

  case number

- futime:

  number of days between registration and the earlier of death,
  transplantation, or end of follow-up

- status:

  status at endpoint ("censored", "transplant" or "dead")

## Baseline covariates

- trt:

  D-pen (D-penicillamine) vs placebo

- age:

  in years

- sex:

  male or female

- copper:

  urine copper (\\\mu\\g/day)

- trig:

  triglycerides (mg/dl)

## Time-varying covariates

- day:

  number of days between enrolment and this visit date; all measurements
  below refer to this date

- albumin:

  serum albumin (mg/dl)

- alk.phos:

  alkaline phosphatase (U/liter)

- ascites:

  presence of ascites

- ast:

  aspartate aminotransferase (U/ml)

- bili:

  serum bilirubin (mg/dl)

- chol:

  serum cholesterol (mg/dl)

- edema:

  "no": no oedema, "(un)treated": untreated or successfully treated 1
  oedema, "edema": oedema despite diuretic therapy

- hepato:

  presence of hepatomegaly (enlarged liver)

- platelet:

  platelet count

- protime:

  standardised blood clotting time

- spiders:

  blood vessel malformations in the skin

- stage:

  histologic stage of disease (4 levels)

## Examples

``` r
 summary(PBC)
#>        id            futime            status          trt           age       
#>  Min.   :  1.0   Min.   :  41   censored  :1073   D-pen  :967   Min.   :26.28  
#>  1st Qu.: 61.0   1st Qu.:2055   transplant: 147   placebo:978   1st Qu.:41.79  
#>  Median :126.0   Median :2963   dead      : 725                 Median :48.87  
#>  Mean   :135.4   Mean   :2941                                   Mean   :49.26  
#>  3rd Qu.:203.0   3rd Qu.:3819                                   3rd Qu.:56.15  
#>  Max.   :312.0   Max.   :5225                                   Max.   :78.44  
#>                                                                                
#>      sex            day       ascites      hepato    spiders    
#>  male  : 237   Min.   :   0   no  :1716   no  :952   no  :1311  
#>  female:1708   1st Qu.: 192   yes : 169   yes :932   yes : 576  
#>                Median : 750   NA's:  60   NA's: 61   NA's:  58  
#>                Mean   :1145                                     
#>                3rd Qu.:1838                                     
#>                Max.   :5152                                     
#>                                                                 
#>          edema           bili             chol           albumin    
#>  no         :1401   Min.   : 0.100   Min.   :  55.0   Min.   :1.17  
#>  (un)treated: 379   1st Qu.: 0.800   1st Qu.: 235.0   1st Qu.:3.11  
#>  edema      : 165   Median : 1.400   Median : 281.0   Median :3.44  
#>                     Mean   : 3.672   Mean   : 320.5   Mean   :3.39  
#>                     3rd Qu.: 3.900   3rd Qu.: 349.2   3rd Qu.:3.70  
#>                     Max.   :41.000   Max.   :1775.0   Max.   :8.01  
#>                                      NA's   :821                    
#>     alk.phos          ast            platelet        protime     stage  
#>  Min.   :   73   Min.   :   6.2   Min.   : 40.0   Min.   : 9.0   1: 95  
#>  1st Qu.:  737   1st Qu.:  72.0   1st Qu.:165.0   1st Qu.:10.1   2:266  
#>  Median : 1072   Median : 107.0   Median :228.0   Median :10.8   3:612  
#>  Mean   : 1382   Mean   : 122.7   Mean   :233.7   Mean   :11.0   4:972  
#>  3rd Qu.: 1636   3rd Qu.: 155.0   3rd Qu.:290.2   3rd Qu.:11.5          
#>  Max.   :13862   Max.   :1205.0   Max.   :991.0   Max.   :36.0          
#>  NA's   :60                       NA's   :73                            
#>      copper            trig    
#>  Min.   :  4.00   Min.   : 33  
#>  1st Qu.: 38.00   1st Qu.: 83  
#>  Median : 65.00   Median :105  
#>  Mean   : 84.54   Mean   :122  
#>  3rd Qu.:105.00   3rd Qu.:151  
#>  Max.   :588.00   Max.   :598  
#>  NA's   :8        NA's   :206  
```
