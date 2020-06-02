mtcars.pca <- prcomp(mtcars[,c(1:7,10,11)], center = TRUE, scale. = TRUE)
summary(mtcars.pca)

library(devtools)
install_github("vqv/ggbiplot")

library(ggbiplot)
ggbiplot(mtcars.pca)

ggbiplot(mtcars.pca, labels = rownames(mtcars))

mtcars.country <- c(rep("Japan", 3), rep("US",4), rep("Europe", 7),rep("US",3), "Europe", rep("Japan", 3), rep("US",4), rep("Europe", 3), "US", rep("Europe", 3))

ggbiplot(mtcars.pca,ellipse=TRUE,  labels=rownames(mtcars), groups=mtcars.country)

# ON MY DATA
pct.changes.10.pca <- prcomp(pct.changes.10.corr[,c(2,3,9,15,35,60)], center = TRUE, scale. = TRUE)
summary(pct.changes.10.pca)
ggbiplot(pct.changes.10.pca)
ggbiplot(pct.changes.10.pca, labels = pct.changes.10.corr[,1])

pct.changes.50.pca <- prcomp(pct.changes.50.corr[,c(2,3,9,15,35,60)], center = TRUE, scale. = TRUE)
summary(pct.changes.50.pca)
ggbiplot(pct.changes.50.pca)
ggbiplot(pct.changes.50.pca, labels = pct.changes.50.corr[,1])

pct.changes.90.pca <- prcomp(pct.changes.90.corr[,c(2,3,9,15,35,60)], center = TRUE, scale. = TRUE)
summary(pct.changes.90.pca)
ggbiplot(pct.changes.90.pca)
ggbiplot(pct.changes.90.pca, labels = pct.changes.90.corr[,1])

# MLR w/o interaction (for forest)
for10 <- lm(for.~evap.mean+prcp.mean, data = pct.changes.10.corr)
summary(for10)
ggplot(for10,aes(y=for.,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

for50 <- lm(for.~evap.mean+prcp.mean, data = pct.changes.50.corr)
summary(for50)
ggplot(for50,aes(y=for.,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

for90 <- lm(for.~evap.mean+prcp.mean, data = pct.changes.90.corr)
summary(for90)
ggplot(for90,aes(y=for.,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

# MLR w/ interaction (for forest)
for10w <- lm(for.~evap.mean*prcp.mean, data = pct.changes.10.corr)
summary(for10w)
ggplot(for10w,aes(y=for.,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

for50w <- lm(for.~evap.mean*prcp.mean, data = pct.changes.50.corr)
summary(for50w)
ggplot(for50w,aes(y=for.,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

for90w <- lm(for.~evap.mean*prcp.mean, data = pct.changes.90.corr)
summary(for90w)
ggplot(for90w,aes(y=for.,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

# test: mlr for 30 land uses?
lu.10.pca <- prcomp(pct.changes.10.corr[,c(4:46)], center = TRUE, scale. = TRUE)
summary(lu.10.pca)
ggbiplot(lu.10.pca)

lu.50.pca <- prcomp(pct.changes.50.corr[,c(4:46)], center = TRUE, scale. = TRUE)
summary(lu.50.pca)
ggbiplot(lu.50.pca)

lu.90.pca <- prcomp(pct.changes.90.corr[,c(4:46)], center = TRUE, scale. = TRUE)
summary(lu.90.pca)
ggbiplot(lu.90.pca)
