#' Mayo Clinic Primary Biliary Cirrhosis, baseline data
#'
#' This data is from the Mayo Clinic trial in primary biliary cirrhosis (PBC) of the
#' liver conducted between 1974 and 1984.
#' The first 312 cases in the data set participated in the randomized placebo controlled
#' trial of the drug D-penicillamine and contain largely complete data.
#' The additional 106 cases did not participate in the clinical trial, but consented
#' to have basic measurements recorded and to be followed for survival

#' @format A data frame with 418 rows and 19 variables:
#' \describe{
#'   \item{age}{in years}
#'   \item{albumin}{serum albumin (g/dl)}
#'   \item{alk.phos}{alkaline phosphotase (U/liter)}
#'   \item{ascites}{presence of ascites}
#'   \item{ast}{aspartate aminotransferase, once called SGOT (U/ml)}
#'   \item{bili}{serum bilirunbin (mg/dl)}
#'   \item{chol}{serum cholesterol (mg/dl)}
#'   \item{copper}{urine copper (ug/day)}
#'   \item{edema}{0 no edema, 0.5 untreated or successfully treated,
#'                        1 edema despite diuretic therapy}
#'   \item{hepato}{presence of hepatomegaly or enlarged liver}
#'   \item{id}{case number}
#'   \item{platelet}{platelet count}
#'   \item{protime}{standardised blood clotting time}
#'   \item{sex}{male (m) or female (f)}
#'   \item{spiders}{blood vessel malformations in the skin}
#'   \item{stage}{histologic stage of disease (needs biopsy)}
#'   \item{status}{status at endpoint, 0/1/2 for censored, transplant, dead}
#'   \item{time}{number of days between registration and the earlier of death,
#'                        transplantion, or study analysis in July, 1986}
#'   \item{trt}{1/2/NA for D-penicillmain, placebo, not randomised}
#'   \item{trig}{triglycerides (mg/dl)}
#'   }
#'
#' @source Therneau, T. and Grambsch, P. (2000)
#'             \emph{Modeling Survival Data: Extending the Cox Model}.
#'             Springer-Verlag, New York.
#' @keywords datasets
#' @examples summary(pbc)
"pbc"

# library(survival)
# for (i in 1:ncol(pbc)) {
#   if (length(unique(pbc[, i])) < 6) {
#     pbc[, i] <- factor(pbc[, i])
#   }
# }
# save(pbc,  file = "data/pbc.RData")
#
#
# temp <- subset(pbc, id <= 312, select = c(id:sex, stage)) # baseline
# pbc2 <- tmerge(temp, temp, id = id, death = event(time, status)) #set range
# pbc2 <- tmerge(pbc2, pbcseq, id = id, ascites = tdc(day, ascites),
#                  bili = tdc(day, bili), albumin = tdc(day, albumin),
#                  protime = tdc(day, protime), alk.phos = tdc(day, alk.phos))
#
# save(pbc2,  file = "data/pbc2.RData")





#' Mayo Clinic Primary Biliary Cirrhosis, sequential data
#'
#' This data is a continuation of the \link{pbc} data set, and contains the follow-up
#' laboratory data for the 312 randomized patients study patient.
#' Some baseline data values in this file differ from the original PBC file,
#' for instance, the data errors in prothrombin time and age which were discovered after
#' the orignal analysis (see Fleming and Harrington, figure 4.6.7).

#' @format A data frame with 1945 rows and 20 variables:
#' \describe{
#'   \item{age}{in years}
#'   \item{albumin}{serum albumin (g/dl)}
#'   \item{alk.phos}{alkaline phosphotase (U/liter)}
#'   \item{ascites}{presence of ascites}
#'   \item{ast}{aspartate aminotransferase, once called SGOT (U/ml)}
#'   \item{bili}{serum bilirunbin (mg/dl)}
#'   \item{chol}{serum cholesterol (mg/dl)}
#'   \item{day}{number of days between enrollment and this visit date}
#'   \item{edema}{0 no edema, 0.5 untreated or successfully treated,
#'                        1 edema despite diuretic therapy}
#'   \item{futime}{number of days between registration and the earlier of death,
#'                        transplantion, or study analysis in July, 1986}
#'   \item{hepato}{presence of hepatomegaly or enlarged liver}
#'   \item{id}{case number}
#'   \item{platelet}{platelet count}
#'   \item{protime}{standardised blood clotting time}
#'   \item{sex}{male (m) or female (f)}
#'   \item{spiders}{blood vessel malformations in the skin}
#'   \item{stage}{histologic stage of disease (needs biopsy)}
#'   \item{status}{status at endpoint, 0/1/2 for censored, transplant, dead}
#'   \item{trt}{1/2/NA for D-penicillmain, placebo, not randomised}
#'}
#' @source Therneau, T. and Grambsch, P. (2000)
#'             \emph{Modeling Survival Data: Extending the Cox Model}.
#'             Springer-Verlag, New York.
#' @keywords datasets
#' @examples summary(pbc_long)
"pbc_long"
# pbc_long <- survival::pbcseq
# for (i in 1:ncol(pbc_long)) {
#   if (length(unique(pbc_long[, i])) < 6) {
#     pbc_long[, i] <- factor(pbc_long[, i])
#   }
# }
# save(pbc_long,  file = "data/pbc_long.RData")

