# 24/40
x <- iris$Sepal.Length
y <- iris$Petal.Length
alpha <- 0.05
(vt <- (var.test(x, y)$p.value <= alpha))
t.test(x, y, var.equal = !vt ) 


# 29/40
# source("https://bioconductor.org/biocLite.R")
# biocLite("made4")
library(made4)
data(khan)
Anova.pvalues <- function(x){
   x <- unlist(x)
   SRBCT.aov.obj <- aov(x ~ khan$train.classes)
   SRBCT.aov.info <- unlist(summary(SRBCT.aov.obj))
   SRBCT.aov.info["Pr(>F)1"]
 }
SRBCT.aov.p <- apply(khan$train, 1, Anova.pvalues)


# 30/40
order.p <- order(SRBCT.aov.p)
ranked.genes <- data.frame(pvalues=SRBCT.aov.p[order.p], ann=khan$annotation[order.p, ])
top5.gene.row.loc <- rownames(ranked.genes[1:5,  ])
summary(t(khan$train[top5.gene.row.loc, ]))

par(mfrow=c(1, 5), mai=c(0.3, 0.4, 0.3, 0.3))
usr <- par("usr")
myplot <- function(gene){ 
boxplot(unlist(khan$train[gene, ]) ~ khan$train.classes, ylim=c(0, 6), main=ranked.genes[gene, 4])
   text(2, usr[4]-1, labels=paste("p=", ranked.genes[gene, 1], sep=""), col="blue")
   ranked.genes[gene,]
 }


# 31/40
do.call(rbind, lapply(top5.gene.row.loc, myplot))


# 35/40
par(mfrow=c(1, 2))
hist(iris$Sepal.Width)
qqnorm(iris$Sepal.Width)
qqline(iris$Sepal.Width, col="red")


# 36/40
x <- iris$Sepal.Width
ks.test(x, 'pnorm', mean(x), sd(x))

library(nortest)
ad.test(iris$Sepal.Width)

shapiro.test(iris$Sepal.Width)


# 40/40
M <- as.table(rbind(c(762, 327, 468), 
                      c(484, 239, 477)))
> dimnames(M) <- list(gender = c("F", "M"),
+                     party = c("Democrat",
                                "Independent", 
                                "Republican"))
M
(res <- chisq.test(M))

