library(JointAI)
library(splines)
simLong$id <- as.numeric(gsub('id', '', simLong$ID))
simLong <- simLong[!is.na(simLong$bmi), ]

mod <- lme_imp(bmi ~ AGE_M*GESTBIR + age * AGE_M + I(age^2), # + hgt,
               random = ~age + I(age^2)|id, data = simLong, n.iter = 500,
               no_model = 'age',
               monitor_params = c(ranef = TRUE),
               scale_vars = FALSE, keep_scaled_mcmc = TRUE)


traceplot(mod)

object = add_samples(mod, n.iter = 100, add = FALSE)

newdata <- simLong[simLong$id %in% c(9), ]
newdata <- newdata[complete.cases(newdata[, all.vars(object$fixed)]), ]

# plot(bmi ~ age, newdata, pch = 19)

# get y
y <- newdata[, colnames(object$Mlist$y)]

id <- extract_id(object$random)

op <- options(na.action = 'na.pass')

# make Z
mfZ <- model.frame(remove_grouping(object$random), newdata)
mtZ <- attr(mfZ, "terms")
Z <- model.matrix(mtZ, data = newdata)

# make X
mfX <- model.frame(remove_grouping(object$fixed), newdata, na.action = na.pass)
mtX <- attr(mfX, "terms")
X <- model.matrix(mtX, data = newdata, na.action = na.pass)

options(op)

Xc <- X[match(unique(newdata[, id]), newdata[, id]),
        object$Mlist$names_main$Xc, drop = FALSE]

Xic <- X[match(unique(newdata[, id]), newdata[, id]),
         object$Mlist$names_main$Xic, drop = FALSE]

Xl <- X[, object$Mlist$names_main$Xl, drop = FALSE]
Xil <- X[, object$Mlist$names_main$Xil, drop = FALSE]


# get MCMC
MCMC <- prep_MCMC(object, start = NULL, end = NULL, thin = NULL,
                  subset = object$monitor_params,
                  exclude_chains = NULL, warn = TRUE, mess = TRUE)

# extract D
Ds <- grep("^D\\[[[:digit:]]*,[[:digit:]]*\\]", colnames(MCMC), value = TRUE)
Dpos <- t(sapply(strsplit(gsub('D|\\[|\\]', '', Ds), ","), as.numeric))

Darr <- array(dim = c(max(Dpos), max(Dpos), nrow(MCMC)))

for (k in seq_along(Ds)) {
  Darr[Dpos[k, 1], Dpos[k, 2], ] <- MCMC[, Ds[k]]
  Darr[Dpos[k, 2], Dpos[k, 1], ] <- MCMC[, Ds[k]]
}

# extract sigma
sig <- MCMC[, paste0("sigma_", colnames(object$Mlist$y))]

# extract beta
beta <- MCMC[, colnames(X), drop = FALSE]

# empirical Bayes estimate
invVarr <- vapply(1:nrow(MCMC), function(k)
  chol2inv(Z %*% Darr[, , k] %*% t(Z) + sig[k]^2 * diag(nrow(Z))),
  FUN.VALUE = matrix(nrow = nrow(Z), ncol = nrow(Z), data = 0))

means <- t(sapply(1:nrow(MCMC), function(k)
  # Darr[, , k] %*% t(Z) %*% invVarr[, , k] %*% (y - X %*% beta[k, ])
  Darr[, , k] %*% t(Z) %*% invVarr[, , k] %*% (y - Xl %*% beta[k, colnames(Xl)] - Xil %*% beta[k, colnames(Xil)])
))

K <- vapply(1:nrow(MCMC), function(k)
  invVarr[, , k] - invVarr[, , k] %*% X %*%
    chol2inv(t(X) %*% invVarr[, , k] %*% X * object$Mlist$N) %*%
    t(X) %*% invVarr[, , k],
  FUN.VALUE = matrix(nrow = nrow(Z), ncol = nrow(Z), data = 0)
)

vars <- vapply(1:nrow(MCMC), function(k)
  Darr[, , k] %*% t(Z) %*% K[, , k] %*% Z %*% Darr[, , k],
  FUN.VALUE = matrix(nrow = ncol(Z), ncol = ncol(Z), data = 0)
)

hc_beta <- lapply(mod$Mlist$hc_list,
                  function(k) {
                    unlist(sapply(k, function(j) {
                      if(attr(j, 'matrix') == 'Xc')
                        attr(j, 'column')
                      else if(attr(j, 'matrix') == 'Z')
                        1
                    }))
                    # mat[mat %in% c('Xc', 'Z')]
                  }
)



# log density
logPost_b <- function(y, Xc, Xic, Xl, Xil, Z, beta, sig_y, b, D, hc_beta, ...) {
  part1 <- sum(-0.5 * (y -
                         Z %*% b -
                         Xl %*% beta[, colnames(Xl)] -
                         Xil %*% beta[, colnames(Xil)])^2 / sig_y^2)

  mu_b <- c(Xc %*% beta[, colnames(Xc)] + Xic %*% beta[, colnames(Xic)],
            sapply(seq_along(hc_beta), function(kk) {
              Xc[, na.omit(hc_beta[[kk]]), drop = FALSE] %*% beta[, names(hc_beta[[kk]])]
            })
  )
  part2 <- - 0.5 * (b - mu_b) %*% solve(D) %*% (b - mu_b)
  sum(part1, part2)
}


for(k in 1:nrow(MCMC)) {
  init <- means[k, ]
  if(k > 1) init <- unlist(out[k - 1, -1])

  res <- MH_algo(init = init, iters = 1,
                 logPost = function(...)
                   logPost_b(y = y, Xc = Xc, Xic = Xic, Xl = Xl, Xil = Xil,
                             beta = beta[k, , drop = FALSE], hc_beta,
                             sig_y = sig[k], D = Darr[, , k], Z = Z, ...),
                 proposal_d = function(...) mvtnorm::dmvnorm(sigma = vars[, , k], ...),
                 proposal_r = function(...) mvtnorm::rmvnorm(n = 1, sigma = vars[, , k], ...))

  if (k == 1) {
    out <- cbind(ar = mean(res$ar == 'accept'),
                 as.data.frame(res$chain[nrow(res$chain), , drop = FALSE]))
  } else {
    out <- rbind(out, cbind(ar = mean(res$ar == 'accept'),
                            as.data.frame(res$chain[nrow(res$chain), , drop = FALSE])))
  }
}



summary(out$ar)

# par(mfrow = c(1, ncol(out)-1))
# for(i in 2:ncol(out)) {
#   plot(1:nrow(out), out[, i], type = 'l')
# }



newDF <- predDF(object, var = 'age')
newDF$id <- unique(newdata$id)

# make Z
mfZ <- model.frame(remove_grouping(object$random), newDF)
mtZ <- attr(mfZ, "terms")
Znew <- model.matrix(mtZ, data = newDF)


mod2 <- lme(bmi ~ AGE_M * GESTBIR + age * AGE_M + I(age^2),
            random = object$random,
            data = simLong, na.action = na.omit, control = lmeControl(niterEM = 250))
b0 <- predict(mod2, newdata = newDF, level = 0)
b1 <- predict(mod2, newdata = newDF, level = 1)



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
