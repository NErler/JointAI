library(JointAI)
library(splines)
simLong <- simLong[!is.na(simLong$sleep), ]


N <- 100
J <- 8

b <- mvtnorm::rmvnorm(N, mean = c(0, 0, 0), sigma = diag(c(0.5, 0.1, 0.001)))

DF <- data.frame(id = rep(1:N, each = J),
                 time  = c(sapply(1:N, function(i) sort(runif(J, 0, 1)))),
                 x  = rnorm(N*J, 0, 0.1)
)

X <- model.matrix(~x + time + I(time^2), DF)
Z <- model.matrix(~ time + I(time^2), DF)


eta <- exp((X %*% t(t(c(0, -0.3, -0.5, -1.5))) + rowSums(Z * b[DF$id, ])))
plot(DF$time, eta)
hist(eta)

var <- 0.5^2
shape = eta^2 / var
rate = eta / var

DF$y <- abs(rnorm(nrow(DF), mean = eta, sd = 0.3))
# DF$y <- rpois(nrow(DF), lambda = exp(eta))
hist(DF$y, nclass = 50)
plot(DF$x, DF$y)
ggplot(DF, aes(x = time, y = y, group = id)) +
  geom_line()

library(lme4)
test <- glmer(y ~ time + I(time^2) + (time| id), data = DF, family = Gamma())


mod <- glme_imp(y ~ time + I(time^2) + x,
               random = ~ time| id, data = DF, n.iter = 500,
               seed = 2019, family = Gamma(), n.adapt = 200,
               monitor_params = c(ranef = T))


traceplot(mod)

object = add_samples(mod, n.iter = 5000, add = FALSE, thin = 10)
traceplot(object)


newdata <- DF[DF$id %in% 1:6, ]
newdata <- newdata[complete.cases(newdata[, all.vars(object$fixed)]), ]
newdata2 <- newdata
newdata2$newid <- newdata2$id
newdata$newid <- newdata$id
newdata$type = 'JAGS'
newdata2$id <- paste0('id00', newdata2$id)
newdata2$type = "sim"

test <- predict(object, newdata = rbind(newdata, newdata2), random = T, n.iter = 1, adj = 1,
                exclude_chains = 3)


ggplot(test$dat, aes(x = time, y = exp(fit), group = type, fill = type, color = type)) +
  # geom_ribbon(aes(ymin = `2.5%`, ymax = `97.5%`), alpha = 0.5) +
  geom_line() +
  facet_wrap("newid") +
  theme(legend.position = 'bottom') +
  geom_point(data = rbind(newdata, newdata2), aes(x = time, y = y, shape = type))



plot(test$smpl[[1]][, 1:2], type = 'l')
plot(test$smpl[[1]][, c(1,3)], type = 'l')
test$acceptance

library(ggplot2)
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



sum(dbinom(as.numeric(DF$y > 3), 1, plogis(eta), TRUE))
sum(-log(1 + exp(eta)) + as.numeric(DF$y > 3) * eta)

sum(dpois(DF$y, lambda = exp(eta), log = TRUE))
sum(c(DF$y * log(exp(eta)) - exp(eta) - lgamma(DF$y + 1)))


a <- -0.5 * (DF$y - eta)^2 / 0.5^2 + log(1/sqrt(2*pi)/0.5)
b <- dnorm(DF$y, mean = eta, sd = 0.5, log = T)


eta <- 1
var <- 1

var <- 0.5^2
shape = eta^2 / var
rate = eta / var

dev.off()
  a <- dgamma(DF$y, shape = eta^2 / var, rate = eta / var, log = T)
  b <- (shape - 1) * log(DF$y) +  shape * log(rate) - log(gamma(shape)) - rate * DF$y

plot(DF$y, a, ylim = c(-45, 0))
points(DF$y, b, col = 2)

abline(a = 0, b = 1)

