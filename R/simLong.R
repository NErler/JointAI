#' Simulated Longitudinal Data in Long and Wide Format
#'
#' This data was simulated to mimic data from a longitudinal cohort study
#' following mothers and their child from birth until approximately 4 years of
#' age.
#' It contains 3903 observations of 500 mother-child pairs. Children's BMI and
#' head circumference was measured repeatedly and their age in months was recorded
#' at each measurement. Furthermore, the data contain several baseline variables
#' with information on the mothers' demographics and socioeconomic status.
#'
#'
#' @format
#' \code{simLong}: A data frame in long format with 3908 rows and 13 variables
#'
#' \code{simWide}: A data frame in wide format with 500 rows and 45 variables
#'
#' @section Baseline covariates: (in \code{simLong} and \code{simWide})
#' \describe{
#'   \item{GESTBIR}{gestational age at birth (in weeks)}
#'   \item{ETHN}{ethnicity (binary: European vs. other)}
#'   \item{AGE_M}{age of the mother at intake}
#'   \item{HEIGHT_M}{height of the mother (in cm)}
#'   \item{PARITY}{number of times the mother has given birth (binary: 0 vs. >=1)}
#'   \item{SMOKE}{smoking status of the mother during pregnancy
#'                (3 ordered categories: never smoked during pregnancy,
#'                 smoked until pregnancy was known, continued smoking in pregnancy)}
#'   \item{EDUC}{educational level of the mother (3 ordered categories: low, mid, high)}
#'   \item{MARITAL}{marital status (3 categories)}
#'   \item{ID}{subject identifier}
#'   }
#'
#'
#'
#' @section Long-format variables: (only in \code{simLong})
#' \describe{
#'    \item{time}{measurement occasion/visit
#'               (by design, children should be measured at/around
#'               1, 2, 3, 4, 7, 11, 15, 20, 26, 32, 40 and 50 months of age)}
#'   \item{age}{child age at measurement time in months}
#'   \item{bmi}{child BMI}
#'   \item{hc}{child head circumference in cm}
#'   \item{ID}{subject identifier}
#' }
#'
#'
#' @section Wide-format variables: (only in \code{simWide})
#' \describe{
#'   \item{age1, age2, age3, age4, age7, age11, age15, age20, age26, age32,
#'    age40, age50}{child age at the repeated measurements in months}
#'   \item{bmi1, bmi2, bmi3, bmi4, bmi7, bmi11, bmi15, bmi20, bmi26, bmi32,
#'    bmi40, bmi50}{repeated measurements of child BMI}
#'   \item{age1, age2, age3, age4, age7, age11, age15, age20, age26, age32,
#'    age40, age50}{repeated measurements of child head circumference in cm}
#' }
#'
#'
#'
#' @keywords datasets
#' @docType data
#' @examples
#'  summary(simLong)
#'  summary(simWide)
#'
#' @name simLong
NULL

#' @rdname simLong
"simLong"

#' @rdname simLong
"simWide"
