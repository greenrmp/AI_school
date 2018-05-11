# 5/60

library(TTR)
data(ttrc)
dim(ttrc)
head(ttrc)

t <- 1:100
sma.20 <- SMA(ttrc[t, "Close"], 20)
ema.20 <- EMA(ttrc[t, "Close"], 20)
wma.20 <- WMA(ttrc[t, "Close"], 20)

plot(ttrc[t,"Close"], type="l", main="ttrc")
lines(sma.20, col="red", lwd=2)
lines(ema.20, col="blue", lwd=2)
lines(wma.20, col="green", lwd=2)
legend("topright", legend=c("sma.20", "ema.20", "wma.20"), col=c("red", "blue", "green"), lty=1, lwd=2)



# 10/60
plot(density(iris$Sepal.Length))

hist(iris$Sepal.Length, prob=T)
lines(density(iris$Sepal.Length), col="red")


#12/60
library(jpeg)
ruddyduck.img <- readJPEG("ruddyduck.jpg")
plot(0, xlim=c(0, 14), ylim=c(-6, 4), type='n', xlab="", ylab="", main="Spline approximate to the top profile of the ruddy duck")
rasterImage(ruddyduck.img, 0.6, -6, 13.8, 3.3)
abline(v=1:14, h=-6:4, col="grey")
 

# 13/60
ruddyduck.dat <- read.table("ruddyduck.txt", header=T, sep="\t")
head(ruddyduck.dat)
points(ruddyduck.dat, col="blue", pch=16)

duck.spl <- smooth.spline(ruddyduck.dat$fx ~ ruddyduck.dat$x)
lines(duck.spl, col = "red", lwd=2)


# 16/67
myvector <- c(10, 20, NA, 30, 40)
myvector
mycountry <- c("Austria", "Australia", NA, NA, "Germany", "NA")
mycountry
is.na(myvector)
which(is.na(myvector))
x <- c(1, 4, 7, 10)
x[4] <- NA # sets the 4th element to NA
x
is.na(x) <- 1 # sets the first element to NA
x

mydata$v1[mydata$v1==99] <- NA 

set.seed(12345)
mydata <- matrix(round(rnorm(20), 2), ncol=5)
mydata[sample(1:20, 3)] <- NA
mydata 
which(colSums(is.na(mydata))>0)


# 17/67
x <- c(1, 4, NA, 10)
summary(x)
mean(x)
sd(x)
mean(x, na.rm=TRUE)
sd(x, na.rm=TRUE)
x[!is.na(x)]


# 18/67
x <- c(1, 0, 10)
x/x
is.nan(x/x)

1/x
is.finite(1/x)
-10/x
is.infinite(-10/x)

exp(-Inf)
0/Inf
Inf - Inf
Inf/Inf


# 21/67
head(airquality)
dim(airquality)
mydata[4:10,3] <- rep(NA,7)
mydata[1:5,4] <- NA
summary(mydata)


# 22/67
library(mice)
md.pattern(mydata)

library(VIM)
mydata.aggrplot <- aggr(mydata, col=c('lightblue','red'), numbers=TRUE, prop = TRUE, sortVars=TRUE, labels=names(mydata), cex.axis=.7, gap=3)


# 23/67
matrixplot(mydata)


# 24/67
mdata <- matrix(rnorm(15), nrow=5)
mdata[sample(1:15, 4)] <- NA 
mdata <- as.data.frame(mdata)
mdata
(x1 <- na.omit(mdata))
(x2 <- mdata[complete.cases(mdata),])
mdata[!complete.cases(mdata),]


#25/67
cov(mdata)
cov(mdata, use = "all.obs")
cov(mdata, use = "complete.obs")

cov(mdata, use = "na.or.complete")
cov(mdata, use = "pairwise")


#26/67
mean.subst <- function(x) {
   x[is.na(x)] <- mean(x, na.rm = TRUE)
   x
}

mdata
mdata.mip <- apply(mdata, 2, mean.subst)
mdata.mip


# 28/67
names(airquality)
airquality.imp.median <- kNN(airquality[1:4], k=5)
head(airquality.imp.median)


# 29/67
matrixplot(airquality[1:4], interactive = F, main="airquality")
matrixplot(airquality.imp.median[1:4], interactive = F, main="imputed by median")

trim_mean <- function(x){
   mean(x, trim = 0.1)
}

airquality.imp.mean <- kNN(airquality[1:4], 
k=5, metric=dist, numFun=mean)
airquality.imp.tmean <- kNN(airquality[1:4], 
k=5, numFun=trim_mean)


# 31/67
airquality.imp.lm <- regressionImp(Ozone ~ Wind + Temp, data=airquality)
data(sleep)
summary(sleep)


# 32/67
sleep.imp.lm <- regressionImp(Dream + NonD ~ BodyWgt + BrainWgt, data=sleep)
summary(sleep.imp.lm)


# 36/67
par(mfrow=c(1,4))
raw.data <- 0:100
pa.data <- ifelse(raw.data >= 60, 1, 0)
id <- which(pa.data==1)
plot(raw.data[id], pa.data[id], main="present-absent", 
     type="l", lwd=2, col="blue", ylim=c(-1, 2), xlim=c(0, 100))
points(raw.data[-id], pa.data[-id], type="l", lwd=2, col="blue")
log.data <- log(raw.data)
plot(raw.data, log.data, main="log", type="l", lwd=2, col="blue")
sqrt10.data <- sqrt(raw.data)*10
plot(raw.data, sqrt10.data, main="sqrt*10", type="l", lwd=2, col="blue", asp=1)
abline(a=0, b=1)
trun.data <- ifelse(raw.data >= 80, 80, ifelse(raw.data < 20, 20, raw.data))
plot(raw.data, trun.data, main="truncation", type="l", lwd=2, col="blue")


# 37/67
par(mfrow=c(1,4))
raw.data <- 0:100
trans.data <- raw.data/max(raw.data)
plot(raw.data, trans.data, main="/max", type="l", lwd=2, col="blue")
trans.data <- raw.data/sum(raw.data)  #Species profile transformation
plot(raw.data, trans.data, main="/sum", type="l", lwd=2, col="blue")
trans.data <- raw.data/sqrt(sum(raw.data^2)) #length of 1, Chord transformation
plot(raw.data, trans.data, main="norm (Chord)", type="l", lwd=2, col="blue")
trans.data <- sqrt(raw.data/sum(raw.data)) #Hellinger transformation
plot(raw.data, trans.data, main="Hellinger", type="l", lwd=2, col="blue")


# 38/67
library('R.matlab')
data <- readMat("software.mat")
print(data)
str(data)


# 39/67
par(mfrow=c(1,2))
xylim <- range(data$prepsloc, data$defsloc)
plot(data$prepsloc, data$defsloc, xlab="PrepTime(min)/SLOC", ylab="Defects/SLOC", main="Software Data", xlim=xylim, ylim=xylim)
logxylim <- range(log(data$prepsloc), log(data$defsloc))
plot(log(data$prepsloc), log(data$defsloc), xlab="Log PrepTime/SLOC", 
ylab="Log Defects/SLOC", main="Software Data", xlim=logxylim, ylim=logxylim)


# 41/67
x <- rexp(1000)
bc <- function(y, lambda){
+     (y^lambda -1)/lambda
+ } 
bc1.x <- bc(x, 0.1)
bc2.x <- bc(x, 0.268)
bc3.x <- bc(x, 0.5)
par(mfrow=c(2, 2))
qqnorm(x); qqline(x, col="red")
qqnorm(bc1.x, main="lambda=0.1")> qqline(bc1.x, col="red")
qqnorm(bc2.x, main="lambda=0.268") 
qqline(bc2.x, col="red")
qqnorm(bc3.x, main="lambda=0.5")
qqline(bc3.x, col="red")


# 45/67
head(airquality )
r <- range(airquality[,1:4], na.rm = T)
hist(airquality$Ozone , xlim = r)
hist(airquality$Solar.R, xlim = r)
hist(airquality$Wind, xlim = r)
hist(airquality$Temp, xlim = r)
airquality.std <- as.data.frame(apply(airquality, 2, scale))
r.std <- c(-3, 3)
hist(airquality.std$Ozone, xlim = r.std)
hist(airquality.std$Solar.R, xlim = r.std)
hist(airquality.std$Wind, xlim = r.std)
hist(airquality.std$Temp, xlim = r.std)


# 47/67

prediction.accuracy.rate <- function(no.classifier=1, accuracy.rate=0.5){
   c(no.classifiers=no.classifier, 
     at.least.one.accuracy=1-(1-accuracy.rate)^no.classifier)
}
prediction.accuracy.rate()
t(sapply(1:10, prediction.accuracy.rate))


# 50/67
id <- sample(2, nrow(iris), replace = TRUE, prob = c(0.9, 0.1))
id
train.data <- iris[id == 1, ]
dim(train.data)
test.data <- iris[id == 2, ]
dim(test.data)

id <- sample(nrow(iris), floor(nrow(iris) * 0.9))
id
train.data <- iris[id, ]
dim(train.data)
test.data <- iris[-id, ]
dim(test.data)



# 53/67
set.seed(12345)
x <- runif(30) 
CV <- function(x) sqrt(var(x))/mean(x)
CV(x)
CV(sample(x, replace=T)) 
boot <- replicate(n=100, expr=CV(sample(x, replace=T)))
boot
mean(boot)
var(boot)
hist(boot)


# 56/67
library(rpart); library(mlbench); library(adabag)
data(Vehicle)
dim(Vehicle)
head(Vehicle)
table(Vehicle$Class)

n <- nrow(Vehicle)
sub <- sample(1:n, 2*n/3)
Vehicle.train <- Vehicle[sub, ]
Vehicle.test <- Vehicle[-sub, ]

mfinal <- 10 #Defaults to mfinal=100 iterations
maxdepth <- 5
# apply rpart
Vehicle.rpart <- rpart(Class ~ ., data = Vehicle.train, maxdepth = maxdepth)
Vehicle.rpart.pred <- predict(Vehicle.rpart, newdata = Vehicle.test, type = "class")
(tb <- table(Vehicle.rpart.pred, Observed.Class=Vehicle.test$Class))
(error.rpart <- 1 - (sum(diag(tb)) / sum(tb)))


# 57/67
library(adabag)
Vehicle.adaboost <- boosting(Class ~., data = Vehicle.train, mfinal = mfinal, 
                              control = rpart.control(maxdepth=maxdepth))
Vehicle.adaboost.pred <- predict.boosting(Vehicle.adaboost, newdata = Vehicle.test)
Vehicle.adaboost.pred$confusion
Vehicle.adaboost.pred$error
importanceplot(Vehicle.adaboost)
evol.train <- errorevol(Vehicle.adaboost, newdata = Vehicle.train)
evol.test <- errorevol(Vehicle.adaboost, newdata = Vehicle.test)
plot.errorevol(evol.test, evol.train)

sort(Vehicle.adaboost$importance, dec=T)[1:5]


# 63/67
data(ubIonosphere)
dim(ubIonosphere)
head(ubIonosphere)
table(ubIonosphere$Class)

library(unbalanced)
p <- ncol(ubIonosphere)
y <- ubIonosphere$Class
x <- ubIonosphere[ ,-p]
data <- ubBalance(X=x, Y=y, type="ubOver", k=0)
overData <- data.frame(data$X, Class=data$Y)
table(overData$Class)
data <- ubBalance(X=x, Y=y, type="ubUnder", perc=50, method="percPos")
underData <- data.frame(data$X, Class=data$Y)
table(underData$Class)
bdata <- ubBalance(X= x, Y=y, type="ubSMOTE", percOver=300, percUnder=150, verbose=TRUE)
str(bdata)
table(bdata$Y)


# 64/67
set.seed(12345)
n <- nrow(ubIonosphere) # 351
no.train <- floor(0.5*n) # 175
id <- sample(1:n, no.train)
x.train  <- x[id, ]  # 175 x 32
y.train <- y[id]
x.test <- x[-id, ] # 176  32
y.test <- y[-id]

library(e1071)
model1 <- svm(x.train, y.train) 
y.pred1 <- predict(model1, x.test)
table(y.pred1, y.test)

balancedData <- ubBalance(X=x.train, Y=y.train, type="ubSMOTE", percOver=200, percUnder=150)
table(balancedData$Y)

model2 <- svm(balancedData$X, balancedData$Y)
y.pred2 <- predict(model2, x.test)
table(y.pred2, y.test)


# 65/67
set.seed(1234)
load("creditcard.Rdata")
str(creditcard)
table(creditcard$Class)

ubConf <- list(percOver=200, percUnder=200, k=2, perc=50, method="percPos", w=NULL)
results <- ubRacing(Class ~., creditcard, "randomForest", 
                    positive=1, metric="auc", ubConf=ubConf, ntree=5)
results 


# 67/67
results <- ubRacing(Class ~., creditcard, "randomForest", positive=1, metric="auc", ubConf=ubConf, ncore=4)
library(e1071)
results <- ubRacing(Class ~., creditcard, "svm", positive=1, ubConf=ubConf)
library(rpart)
results <- ubRacing(Class ~., creditcard, "rpart", positive=1, ubConf=ubConf)
results 











