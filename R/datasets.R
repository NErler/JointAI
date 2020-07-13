#' Longitudinal example dataset
#'
#' A simulated longitudinal dataset.
#'
#' @docType data
#'
#' @usage data(longDF)
#'
#' @format A simulated data frame with 329 rows and 21 variables with data from
#'         100 subjects:
#' \describe{
#'   \item{C1}{continuous, complete baseline variable}
#'   \item{C2}{continuous, incomplete baseline variable}
#'   \item{B1}{binary, complete baseline variable}
#'   \item{B2}{binary, incomplete baseline variable}
#'   \item{M1}{unordered factor; complete baseline variable}
#'   \item{M2}{unordered factor; incomplete baseline variable}
#'   \item{O1}{ordered factor; complete baseline variable}
#'   \item{O2}{ordered factor; incomplete baseline variable}
#'   \item{P1}{count variable; complete baseline variable}
#'   \item{P2}{count variable; incomplete baseline variable}
#'   \item{c1}{continuous, complete longitudinal variable}
#'   \item{c2}{continuous incomplete longitudinal variable}
#'   \item{b1}{binary, complete longitudinal variable}
#'   \item{b2}{binary incomplete longitudinal variable}
#'   \item{o1}{ordered factor; complete longitudinal variable}
#'   \item{o2}{ordered factor; incomplete longitudinal variable}
#'   \item{p1}{count variable; complete longitudinal variable}
#'   \item{p2}{count variable; incomplete longitudinal variable}
#'   \item{id}{id (grouping) variable}
#'   \item{time}{continuous complete longitudinal variable}
#'   \item{y}{continuous, longitudinal (outcome) variable}
#'}
#'
#' @keywords datasets
#'
#'
"longDF"

# longDF <- sim_data(N = 100, norm = c("C1", "C2"), bin = c("B1", "B2"),
#                    multi = c('M1', "M2"), ord = c("O1", "O2"),
#                    count = c('P1', 'P2'),
#                    longnorm = c('c1', "c2"), longbin = c("b1", 'b2'),
#                    longord = c('o1', 'o2'), longcount = c('p1', 'p2'),
#                    misvar = c('C2', 'B2', "M2", 'O2', 'P2', 'c2', "b2",
#                               'o2', 'p2'),
#                    seed = 2019)[[2]]

#' Cross-sectional example dataset
#'
#' A simulated cross-sectional dataset.
#'
#' @docType data
#'
#' @usage data(wideDF)
#'
#' @format A simulated data frame with 100 rows and 13 variables:
#' \describe{
#'   \item{C1}{continuous, complete variable}
#'   \item{C2}{continuous, incomplete variable}
#'   \item{B1}{binary, complete variable}
#'   \item{B2}{binary, incomplete variable}
#'   \item{M1}{unordered factor; complete variable}
#'   \item{M2}{unordered factor; incomplete variable}
#'   \item{O1}{ordered factor; complete variable}
#'   \item{O2}{ordered factor; incomplete variable}
#'   \item{L1}{continuous, complete variable}
#'   \item{L2}{continuous incomplete variable}
#'   \item{id}{id (grouping) variable}
#'   \item{time}{continuous complete variable}
#'   \item{y}{continuous, complete variable}
#'}
#' @keywords datasets
#'
#'
#'
"wideDF"





#' Simulated Longitudinal Data in Long and Wide Format
#'
#' This data was simulated to mimic data from a longitudinal cohort study
#' following mothers and their child from birth until approximately 4 years of
#' age.
#' It contains 2400 observations of 200 mother-child pairs. Children's BMI and
#' head circumference was measured repeatedly and their age in months was
#' recorded at each measurement. Furthermore, the data contain several baseline
#' variables with information on the mothers' demographics and socio-economic
#' status.
#'
#'
#' @format
#' \code{simLong}: A data frame in long format with 2400 rows and 16 variables
#'
#' \code{simWide}: A data frame in wide format with 200 rows and 81 variables
#'
#' @section Baseline covariates: (in \code{simLong} and \code{simWide})
#' \describe{
#'   \item{GESTBIR}{gestational age at birth (in weeks)}
#'   \item{ETHN}{ethnicity (binary: European vs. other)}
#'   \item{AGE_M}{age of the mother at intake}
#'   \item{HEIGHT_M}{height of the mother (in cm)}
#'   \item{PARITY}{number of times the mother has given birth
#'                 (binary: 0 vs. >=1)}
#'   \item{SMOKE}{smoking status of the mother during pregnancy
#'                (3 ordered categories: never smoked during pregnancy,
#'                 smoked until pregnancy was known, continued smoking in
#'                 pregnancy)}
#'   \item{EDUC}{educational level of the mother (3 ordered categories: low,
#'              mid, high)}
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
#'   \item{hgt}{child height in cm}
#'   \item{wgt}{child weight in gram}
#'   \item{sleep}{sleeping behavior of the child (3 ordered categories)}
#' }
#'
#'
#' @section Wide-format variables: (only in \code{simWide})
#' \describe{
#'   \item{age1, age2, age3, age4, age7, age11, age15, age20, age26, age32,
#'    age40, age50}{child age at the repeated measurements in months}
#'   \item{bmi1, bmi2, bmi3, bmi4, bmi7, bmi11, bmi15, bmi20, bmi26, bmi32,
#'    bmi40, bmi50}{repeated measurements of child BMI}
#'   \item{hc1, hc2, hc3, hc4, hc7, hc11, hc15, hc20, hc26, hc32,
#'    hc40, hc50}{repeated measurements of child head circumference in cm}
#'   \item{hgt1, hgt2, hgt3, hgt4, hgt7, hgt11, hgt15, hgt20, hgt26, hgt32,
#'    hgt40, hgt50}{repeated measurements of child height in cm}
#'   \item{wgt1, wgt2, wgt3, wgt4, wgt7, wgt11, wgt15, wgt20, wgt26, wgt32,
#'    wgt40, wgt50}{repeated measurements of child weight in gram}
#'   \item{sleep1, sleep2, sleep3, sleep4, sleep7, sleep11, sleep15, sleep20,
#'    sleep26, sleep32, sleep40, sleep50}{repeated measurements of child sleep
#'    behaviour (3 ordered categories)}
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




#' National Health and Nutrition Examination Survey (NHANES) Data
#'
#' This data is a small subset of the data collected within the 2011-2012 wave
#' of the NHANES study, a study designed to assess the health and nutritional
#' status of adults and children in the United States, conduced by the
#' \href{https://www.cdc.gov/nchs/}{National Center for Health Statistics}.
#'
#' @section Note:
#' The subset provided here was selected and re-coded to facilitate
#' demonstration of the functionality of the JointAI package,
#' and no clinical conclusions should be derived from it.
#'
#' @format A data frame with 186 rows and 13 variables:
#' \describe{
#'   \item{SBP}{systolic blood pressure}
#'   \item{gender}{male or female}
#'   \item{age}{in years}
#'   \item{race}{race / Hispanic origin (5 categories)}
#'   \item{WC}{waist circumference in cm}
#'   \item{alc}{alcohol consumption (binary: <1 drink per week vs. >= 1 drink
#'              per week)}
#'   \item{educ}{educational level (binary: low vs. high)}
#'   \item{creat}{creatinine concentration in mg/dL}
#'   \item{albu}{albumin concentration in g/dL}
#'   \item{uricacid}{uric acid concentration in mg/dL}
#'   \item{bili}{bilirubin concentration in mg/dL}
#'   \item{occup}{occupational status (3 categories)}
#'   \item{smoke}{smoking status (3 ordered categories)}
#'   }
#'
#' @usage data(NHANES)
#'
#' @source National Center for Health Statistics (NCHS) (2011 - 2012).
#'         National Health and Nutrition Examination Survey Data.
#'         URL \href{https://www.cdc.gov/nchs/nhanes/}{https://www.cdc.gov/nchs/nhanes/}.
#' @keywords datasets
#' @docType data
#'
#' @examples summary(NHANES)
"NHANES"



#' PBC data
#'
#' Data from the Mayo Clinic trial in primary biliary cirrhosis (PBC) of the
#' liver. This dataset was obtained from the \strong{survival} package:
#' the variables \code{copper} and \code{trig} from \code{survival::pbc} were
#' merged into \code{survival::pbcseq} and several categorical variables were
#' re-coded.
#'
#'
#' @format
#' \code{PBC}: A data frame of 312 individuals in long format with 1945 rows
#'             and 21 variables.
#'
#' @section Survival outcome and id:
#' \describe{
#'   \item{id}{case number}
#'   \item{futime}{number of days between registration and the earlier of death,
#'                 transplantation, or end of follow-up}
#'   \item{status}{status at endpoint ("censored", "transplant" or "dead")}
#'   }
#'
#'
#' @section Baseline covariates:
#' \describe{
#'   \item{trt}{D-pen (D-penicillamine) vs  placebo}
#'   \item{age}{in years}
#'   \item{sex}{male or female}
#'   \item{copper}{urine copper (\eqn{\mu}g/day)}
#'   \item{trig}{triglycerides (mg/dl)}
#'   }
#'
#'
#' @section Time-varying covariates:
#' \describe{
#'   \item{day}{number of days between enrolment and this visit date; all
#'              measurements below refer to this date}
#'   \item{albumin}{serum albumin (mg/dl)}
#'   \item{alk.phos}{alkaline phosphatase (U/liter)}
#'   \item{ascites}{presence of ascites}
#'   \item{ast}{aspartate aminotransferase (U/ml)}
#'   \item{bili}{serum bilirubin (mg/dl)}
#'   \item{chol}{serum cholesterol (mg/dl)}
#'   \item{edema}{"no": no oedema,
#'                "(un)treated": untreated or successfully treated 1 oedema,
#'                "edema": oedema despite diuretic therapy}
#'   \item{hepato}{presence of hepatomegaly (enlarged liver)}
#'   \item{platelet}{platelet count}
#'   \item{protime}{standardised blood clotting time}
#'   \item{spiders}{blood vessel malformations in the skin}
#'   \item{stage}{histologic stage of disease (4 levels)}
#'   }
#'
#'
#' @keywords datasets
#' @docType data
#' @examples
#'  summary(PBC)
#'
#' @name PBC
NULL


# PBC <- merge(survival::pbcseq,
#              subset(survival::pbc, select = c(id, copper, trig))
# )
# PBC$trt <- factor(PBC$trt, levels = 0:1, labels = c('D-pen', 'placebo'))
# PBC$ascites <- factor(PBC$ascites, levels = 0:1, labels = c('no', 'yes'))
# PBC$hepato <- factor(PBC$hepato, levels = 0:1, labels = c('no', 'yes'))
# PBC$spiders <- factor(PBC$spiders, levels = 0:1, labels = c('no', 'yes'))
# PBC$edema <- factor(PBC$edema, levels = c(0, 0.5, 1),
#                     labels = c('no', '(un)treated', 'edema'))
# PBC$stage <- factor(PBC$stage, levels = 1:4, labels = 1:4, ordered = TRUE)
# PBC$sex <- factor(PBC$sex, levels = c('m','f'), labels = c('male', 'female'))
# PBC$status <- factor(PBC$status, levels = 0:2,
#                      labels = c('censored', 'transplant', 'dead'))
#
# save(PBC, file = 'data/PBC.RData')
