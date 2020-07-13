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
map1 <- ggplot(for50w,aes(y=for.,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE) +
  labs(color = "ET\nChange (%)") +
  xlab('Precipitation Change (%)') +
  ylab('Natural Pervious Runoff Change (%)')

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

# MLR w/ interaction (pas pasest)
pas10w <- lm(pas~evap.mean*prcp.mean, data = pct.changes.10.corr)
summary(pas10w)
ggplot(pas10w,aes(y=pas,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

pas50w <- lm(pas~evap.mean*prcp.mean, data = pct.changes.50.corr)
summary(pas50w)
ggplot(pas50w,aes(y=pas,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

pas90w <- lm(pas~evap.mean*prcp.mean, data = pct.changes.90.corr)
summary(pas90w)
ggplot(pas90w,aes(y=pas,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

# MLR w/ interaction (soy soyest)
soy10w <- lm(soy~evap.mean*prcp.mean, data = pct.changes.10.corr)
summary(soy10w)
ggplot(soy10w,aes(y=soy,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

soy50w <- lm(soy~evap.mean*prcp.mean, data = pct.changes.50.corr)
summary(soy50w)
ggplot(soy50w,aes(y=soy,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

soy90w <- lm(soy~evap.mean*prcp.mean, data = pct.changes.90.corr)
summary(soy90w)
ggplot(soy90w,aes(y=soy,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

# MLR w/ interaction (cch cchest)
cch10w <- lm(cch~evap.mean*prcp.mean, data = pct.changes.10.corr)
summary(cch10w)
ggplot(cch10w,aes(y=cch,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

cch50w <- lm(cch~evap.mean*prcp.mean, data = pct.changes.50.corr)
summary(cch50w)
ggplot(cch50w,aes(y=cch,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

cch90w <- lm(cch~evap.mean*prcp.mean, data = pct.changes.90.corr)
summary(cch90w)
ggplot(cch90w,aes(y=cch,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

# MLR w/ interaction (cci cciest)
cci10w <- lm(cci~evap.mean*prcp.mean, data = pct.changes.10.corr)
summary(cci10w)
ggplot(cci10w,aes(y=cci,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)

cci50w <- lm(cci~evap.mean*prcp.mean, data = pct.changes.50.corr)
summary(cci50w)
map2 <- ggplot(cci50w,aes(y=cci,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE) +
  labs(color = "ET\nChange (%)") +
  xlab('Precipitation Change (%)') +
  ylab('Impervious Runoff Change (%)')


cci90w <- lm(cci~evap.mean*prcp.mean, data = pct.changes.90.corr)
summary(cci90w)
ggplot(cci90w,aes(y=cci,x=prcp.mean,color=evap.mean))+geom_point()+stat_smooth(method="lm",se=TRUE)
