x <- sort(rnorm(10))
# rx <- seq_along(x)/length(x)
y <- sort(rnorm(10))
# ry <- seq_along(y)/length(y)

# ry_x <- as.numeric(as.character(cut(x, breaks = c(-Inf, y, Inf), labels = (0:length(y))/length(y))))
# rx_y <- as.numeric(as.character(cut(y, breaks = c(-Inf, x, Inf), labels = (0:length(x))/length(x))))

a <- seq(-3, 3, length = 500)
ax <- sapply(a, function(a) sum(a > x))/length(x)
ay <- sapply(a, function(a) sum(a > y))/length(y)

max(abs(ax - ay))

DF <- data.frame(value = c(x, y),
                 rx = c(rx, rx_y),
                 ry = c(ry_x, ry),
                 variable = rep(c('x', 'y'), c(length(x), length(y)))
)
DF$d <- DF$rx - DF$ry
K = max(abs(DF$d))

n <- length(x)
m <- length(y)
X <- sqrt(n)*sqrt(m/(n+m)) * K
# sqrt(log(2/0.05)/2)
n = seq(100, 10000, length = 100)
p = 0.5
m = n*p
sqrt(n)*sqrt(m/(n+m))
lines(n, n * sqrt(p/(n+n*p)))

ks.test(x,y)
plot(log(1:10), 1 - myfun(log(1:10), 1:1e3))
1 - myfun(X, 1:200)


myfun <- function(z, k){
  sapply(z, function(z)1 - 2 * sum((-1)^(k-1) * exp(-2 * k^2 * z^2)))
}

plot(seq(from = 0, to = 2, length = 100), myfun(seq(from = 0, to = 2, length = 100), k))

1 - myfun(0.707, 1:100)

sqrt(2*pi/z) * sum(exp(-(2 * k-1)^2*pi^2/(8*z^2)))



model2 <- "
  model {
    for (i in 1:N) {
      y[i] ~ dnorm(0, 1)
    }
    for (i in 1:Ns) {
      ry[i] <- sum(s[i] > y[])/N
    }
    D <- max(abs(ry[] - rx[]))
  }
  "
