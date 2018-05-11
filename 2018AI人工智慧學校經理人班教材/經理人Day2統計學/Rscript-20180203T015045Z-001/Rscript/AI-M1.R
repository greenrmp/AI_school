# 12/44
score2015.orig <- read.table("score2015.txt", header=T, sep = "\t")
dim(score2015.orig)
head(score2015.orig)
summary(score2015.orig[, 3:ncol(score2015.orig)])
table(score2015.orig["出席次數"])


# 13/44
score2015 <- score2015.orig
score2015[is.na(score2015)] <- 0
colMeans(score2015[, 5:11])
apply(score2015[, 5:11], 1, mean)
apply(score2015[, 5:11], 2, sd)
x <- score2015[,"小考1"]
min(x)
max(x)
sum(x)
mean(x)
mean(x)
mean(x, trim=0.1)
median(x)

Mode <- function(x, na.rm = FALSE) {
  if(na.rm) x = x[!is.na(x)]  
  ux <- unique(x)
  ifelse(length(x)==length(ux), 
         "no mode",   
         ux[which.max(tabulate(match(x, ux)))])
}

Mode(x)
quantile(x)
quantile(x, prob= seq(0, 100, 10)/100)
range(x)
sd(x)
var(x)


# 23/44
library("corpcor")
n <- 6 
p <- 10 
set.seed(123456)
sigma <- matrix(rnorm(p * p), ncol = p)
sigma <- crossprod(sigma) + diag(rep(0.1, p)) 
x <- mvrnorm(n, mu=rep(0, p), Sigma=sigma)
s1 <- cov(x)
s2 <- cov.shrink(x)
par(mfrow=c(1,3))
image(t(sigma)[,p:1], main="true cov", xaxt="n", yaxt="n")
image(t(s1)[,p:1], main="empirical cov", xaxt="n", yaxt="n")
image(t(s2)[,p:1], main="shrinkage cov", xaxt="n", yaxt="n")
sum((s1 - sigma) ^ 2)
sum((s2 - sigma) ^ 2)

mvrnorm {MASS}:
mvrnorm(n = 1, mu, Sigma, ...)


# 24/44
is.positive.definite(sigma)
is.positive.definite(s1)
is.positive.definite(s2)
rc <- rbind(
  data.frame(rank.condition(sigma)),
  data.frame(rank.condition(s1)),
  data.frame(rank.condition(s2)))
rownames(rc) <- c("true", "empirical", "shrinkage")
rc
e0 <- eigen(sigma, symmetric = TRUE)$values
e1 <- eigen(s1, symmetric = TRUE)$values
e2 <- eigen(s2, symmetric = TRUE)$values
matplot(data.frame(e0, e1, e2), type = "l", ylab="eigenvalues", lwd=2)
legend("top", legend=c("true", "empirical", "shrinkage"), lwd=2, lty=1:3, col=1:3)
 
# 33/44
curve(pnorm(x), -3, 3)
arrows(-1, 0, -1, pnorm(-1), col="red")
arrows(-1, pnorm(-1), -3, pnorm(-1), col="green")
pnorm(-1)


# 34/44
qnorm(0.025)
qnorm(0.5)
qnorm(0.975)


# 38/44
par(mfrow = c(1, 2))
n <- 20 # 4
p <- 0.4 # 0.04
mu <- n * p
sigma <- sqrt(n * p * (1 - p))
x <- 0:n
plot(x, dbinom(x, n, p), type = 'h', lwd = 2, 
     xlab = "x", ylab = "P(X=x)",
     main = "B(20, 0.4)")
z <- seq(0, n, 0.1)
lines(z, dnorm(z, mu, sigma), col = "red", lwd = 2)
abline(h = 0, lwd = 2, col = "grey")


# 42/44
z <- (126/210 -0.7)/sqrt(0.001) # 通過人數>126的機率
z
1 - pnorm(z)

pass.prob <- function(x, n, mu, sigma2, digit=m){
    xbar <- x/n
    z <- (xbar-mu)/sqrt(sigma2)
    zvalue <- round(z, digit)
    right.prob <- round(1-pnorm(z), digit)
    list(zvalue=zvalue, prob=right.prob)
  }

pass.prob(126, 210, 0.7, 0.001, 4)


# 41/44
girl.born <- function(n, show.id = F){
  
  girl.count <- 0
  for (i in 1:n) {
    if (show.id) cat(i,": ")
    child.count <- 0
    repeat {
      rn <- sample(0:99, 1, replace=T) # random number
      if (show.id) cat(paste0("(", rn, ")"))
      is.girl <- ifelse(rn <= 48, TRUE, FALSE)
      child.count <- child.count + 1
      if (is.girl){
        girl.count <- girl.count + 1
        if (show.id) cat("女+")
        break
      } else if (child.count == 3) {
        if (show.id) cat("男")        
        break
      } else{
        if (show.id) cat("男")        
      }
    }
    if (show.id) cat("\n")
  }
  p <- girl.count / n
  p
  
}

girl.p <- 0.49 + 0.51*0.49 + 0.51^2*0.49
girl.p
girl.born(n=10, show.id = T)
girl.born(n=10000)



