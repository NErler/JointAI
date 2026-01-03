# National Health and Nutrition Examination Survey (NHANES) Data

This data is a small subset of the data collected within the 2011-2012
wave of the NHANES study, a study designed to assess the health and
nutritional status of adults and children in the United States, conduced
by the [National Center for Health
Statistics](https://www.cdc.gov/nchs/).

## Usage

``` r
data(NHANES)
```

## Format

A data frame with 186 rows and 13 variables:

- SBP:

  systolic blood pressure

- gender:

  male or female

- age:

  in years

- race:

  race / Hispanic origin (5 categories)

- WC:

  waist circumference in cm

- alc:

  alcohol consumption (binary: \<1 drink per week vs. \>= 1 drink per
  week)

- educ:

  educational level (binary: low vs. high)

- creat:

  creatinine concentration in mg/dL

- albu:

  albumin concentration in g/dL

- uricacid:

  uric acid concentration in mg/dL

- bili:

  bilirubin concentration in mg/dL

- occup:

  occupational status (3 categories)

- smoke:

  smoking status (3 ordered categories)

## Source

National Center for Health Statistics (NCHS) (2011 - 2012). National
Health and Nutrition Examination Survey Data. URL
<https://www.cdc.gov/nchs/nhanes/>.

## Note

The subset provided here was selected and re-coded to facilitate
demonstration of the functionality of the JointAI package, and no
clinical conclusions should be derived from it.

## Examples

``` r
summary(NHANES)
#>       SBP           gender         age                        race   
#>  Min.   : 86.0   male  :100   Min.   :20.00   Mexican American  :28  
#>  1st Qu.:109.3   female: 86   1st Qu.:32.00   Other Hispanic    :10  
#>  Median :116.7                Median :42.00   Non-Hispanic White:73  
#>  Mean   :119.3                Mean   :43.51   Non-Hispanic Black:32  
#>  3rd Qu.:127.2                3rd Qu.:55.75   other             :43  
#>  Max.   :177.3                Max.   :78.00                          
#>                                                                      
#>        WC           alc       educ         creat             albu      
#>  Min.   : 64.80   <1  :94   low : 70   Min.   :0.4700   Min.   :3.500  
#>  1st Qu.: 82.92   >=1 :58   high:116   1st Qu.:0.7200   1st Qu.:4.100  
#>  Median : 93.85   NA's:34              Median :0.8300   Median :4.350  
#>  Mean   : 95.00                        Mean   :0.8438   Mean   :4.346  
#>  3rd Qu.:104.20                        3rd Qu.:0.9575   3rd Qu.:4.500  
#>  Max.   :135.80                        Max.   :1.3800   Max.   :5.200  
#>  NA's   :2                             NA's   :8        NA's   :8      
#>     uricacid          bili                     occup        smoke    
#>  Min.   :2.500   Min.   :0.3000   working         :98   never  :107  
#>  1st Qu.:4.500   1st Qu.:0.6000   looking for work: 5   former : 36  
#>  Median :5.400   Median :0.7000   not working     :55   current: 36  
#>  Mean   :5.353   Mean   :0.7208   NA's            :28   NA's   :  7  
#>  3rd Qu.:6.100   3rd Qu.:0.8000                                      
#>  Max.   :8.800   Max.   :1.4000                                      
#>  NA's   :8       NA's   :8                                           
```
