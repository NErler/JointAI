library(JointAI)
library(splines)
simLong <- simLong[!is.na(simLong$sleep), ]

mod <- lme_imp(bmi ~ AGE_M + GESTBIR + ns(age, df = 3),
               random = ~ns(age, df = 3)|ID, data = simLong, n.iter = 500,
               no_model = 'age', seed = 2019)


traceplot(mod)

object = add_samples(mod, n.iter = 500, add = FALSE)
traceplot(object)

newdata <- simLong[simLong$ID %in% c('id118'), ]
newdata <- newdata[complete.cases(newdata[, all.vars(object$fixed)]), ]

# plot(bmi ~ age, newdata, pch = 19)


test <- predict(object, newdata = newdata, random = T, n.iter = 1, adj = 1)

plot(test$smpl[[1]][, 1:2], type = 'l')
plot(test$smpl[[1]][, c(1,3)], type = 'l')
test$acceptance

ggplot(test$dat, aes(x = age)) +
  geom_point(aes(y = bmi)) +
  geom_line(aes(y = fit)) +
  geom_ribbon(aes(ymin = `2.5%`, ymax = `97.5%`), alpha = 0.2)




test <- ranef_sample(object, n.iter = 1, newdata = newdata)

summary(test$acceptance)

plot(test$sample)


newDF <- predDF(object, var = 'age')
newDF$id <- unique(newdata$id)

# make Z
mfZ <- model.frame(remove_grouping(object$random), newDF)
mtZ <- attr(mfZ, "terms")
Znew <- model.matrix(mtZ, data = newDF)


ids <- unique(object$data_list$group[which(object$data[, id] == unique(newDF[, id]))])

ranefs <- MCMC[, grep(paste0('^b\\[', ids, ",[[:digit:]]+\\]"), colnames(MCMC))] %*% t(Znew)

ranef_summary <- rbind(
  mean = colMeans(ranefs),
  apply(ranefs, 2, quantile, c(0.025, 0.975))
)

fit <- Znew %*% t(out[-c(1:100), -1])

b_summary <- rbind(
  mean = rowMeans(fit),
  apply(fit, 1, quantile, c(0.025, 0.975))
)


# dev.off()
par(mfrow = c(2, 1), mar = c(3, 3, 2.5, 0.5), mgp = c(2, 0.6, 0))
plot(bmi ~ age, newdata, pch = 19, main = 'subject specific',
     ylim = range(ranef_summary, b_summary, newdata$bmi, b0, b1))

lines(newDF$age, ranef_summary['mean', ], col = 2, lwd = 2)
lines(newDF$age, ranef_summary['2.5%', ], col = 2)
lines(newDF$age, ranef_summary['97.5%', ], col = 2)

lines(newDF$age, b_summary['mean', ], col = 4, lwd = 2)
lines(newDF$age, b_summary['2.5%', ], col = 4)
lines(newDF$age, b_summary['97.5%', ], col = 4)


lines(newDF$age, b1, lwd = 2, lty = 2)

legend(x = 'bottomleft',
       col = c(1, 2, 4), lty = c(2, 1, 1),
       legend = c('nlme', 'JAGS', 're-sampled'), bty = 'n')


pred <- predict(object, newdata = newDF)

plot(bmi ~ age, newdata, pch = 19,
     ylim = range(ranef_summary, b_summary, newdata$bmi, b0, b1),
     main = 'overall')

lines(newDF$age, pred$dat$fit, lwd = 2, col = 2)
lines(newDF$age, pred$dat$`2.5%`, col = 2)
lines(newDF$age, pred$dat$`97.5%`, col = 2)
lines(newDF$age, b0, lwd = 2, lty = 2)
legend(x = 'bottomleft',
       col = c(1, 2), lty = c(2, 1),
       legend = c('nlme', 'JAGS'), bty = 'n')




mod2 <- lme(bmi ~ AGE_M * GESTBIR + age * AGE_M + I(age^2),
            random = object$random,
            data = simLong, na.action = na.omit, control = lmeControl(niterEM = 250))
b0 <- predict(mod2, newdata = newDF, level = 0)
b1 <- predict(mod2, newdata = newDF, level = 1)

