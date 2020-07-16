# Creates principal component analysis plots describing correlations between precipitation/temperature
# and land use unit runoff values.

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

# testing
cfr10w <- lm(cfr~evap.mean*prcp.mean, data = pct.changes.10)
cfr50w <- lm(cfr~evap.mean*prcp.mean, data = pct.changes.50)
cfr90w <- lm(cfr~evap.mean*prcp.mean, data = pct.changes.90)

for10w <- lm(for.~evap.mean*prcp.mean, data = pct.changes.10)
for50w <- lm(for.~evap.mean*prcp.mean, data = pct.changes.50)
for90w <- lm(for.~evap.mean*prcp.mean, data = pct.changes.90)

cmo10w <- lm(cmo~evap.mean*prcp.mean, data = pct.changes.10)
cmo50w <- lm(cmo~evap.mean*prcp.mean, data = pct.changes.50)
cmo90w <- lm(cmo~evap.mean*prcp.mean, data = pct.changes.90)

osp10w <- lm(osp~evap.mean*prcp.mean, data = pct.changes.10)
osp50w <- lm(osp~evap.mean*prcp.mean, data = pct.changes.50)
osp90w <- lm(osp~evap.mean*prcp.mean, data = pct.changes.90)

pas10w <- lm(pas~evap.mean*prcp.mean, data = pct.changes.10)
pas50w <- lm(pas~evap.mean*prcp.mean, data = pct.changes.50)
pas90w <- lm(pas~evap.mean*prcp.mean, data = pct.changes.90)

aop10w <- lm(aop~evap.mean*prcp.mean, data = pct.changes.10)
aop50w <- lm(aop~evap.mean*prcp.mean, data = pct.changes.50)
aop90w <- lm(aop~evap.mean*prcp.mean, data = pct.changes.90)

soy10w <- lm(soy~evap.mean*prcp.mean, data = pct.changes.10)
soy50w <- lm(soy~evap.mean*prcp.mean, data = pct.changes.50)
soy90w <- lm(soy~evap.mean*prcp.mean, data = pct.changes.90)

cci10w <- lm(cci~evap.mean*prcp.mean, data = pct.changes.10)
cci50w <- lm(cci~evap.mean*prcp.mean, data = pct.changes.50)
cci90w <- lm(cci~evap.mean*prcp.mean, data = pct.changes.90)

hfr10w <- lm(hfr~evap.mean*prcp.mean, data = pct.changes.10)
hfr50w <- lm(hfr~evap.mean*prcp.mean, data = pct.changes.50)
hfr90w <- lm(hfr~evap.mean*prcp.mean, data = pct.changes.90)

cch10w <- lm(cch~evap.mean*prcp.mean, data = pct.changes.10)
cch50w <- lm(cch~evap.mean*prcp.mean, data = pct.changes.50)
cch90w <- lm(cch~evap.mean*prcp.mean, data = pct.changes.90)

ccn10w <- lm(ccn~evap.mean*prcp.mean, data = pct.changes.10)
ccn50w <- lm(ccn~evap.mean*prcp.mean, data = pct.changes.50)
ccn90w <- lm(ccn~evap.mean*prcp.mean, data = pct.changes.90)

fnp10w <- lm(fnp~evap.mean*prcp.mean, data = pct.changes.10)
fnp50w <- lm(fnp~evap.mean*prcp.mean, data = pct.changes.50)
fnp90w <- lm(fnp~evap.mean*prcp.mean, data = pct.changes.90)

rsqs <- data.frame(matrix(data = NA, nrow = 12, ncol = 3))
rsqs[1, 1] <- round(summary(cfr10w)$r.squared, 3)
rsqs[1, 2] <- round(summary(cfr50w)$r.squared, 3)
rsqs[1, 3] <- round(summary(cfr90w)$r.squared, 3)
rsqs[2, 1] <- round(summary(for10w)$r.squared, 3)
rsqs[2, 2] <- round(summary(for50w)$r.squared, 3)
rsqs[2, 3] <- round(summary(for90w)$r.squared, 3)
rsqs[3, 1] <- round(summary(cmo10w)$r.squared, 3)
rsqs[3, 2] <- round(summary(cmo50w)$r.squared, 3)
rsqs[3, 3] <- round(summary(cmo90w)$r.squared, 3)
rsqs[4, 1] <- round(summary(osp10w)$r.squared, 3)
rsqs[4, 2] <- round(summary(osp50w)$r.squared, 3)
rsqs[4, 3] <- round(summary(osp90w)$r.squared, 3)
rsqs[5, 1] <- round(summary(pas10w)$r.squared, 3)
rsqs[5, 2] <- round(summary(pas50w)$r.squared, 3)
rsqs[5, 3] <- round(summary(pas90w)$r.squared, 3)
rsqs[6, 1] <- round(summary(aop10w)$r.squared, 3)
rsqs[6, 2] <- round(summary(aop50w)$r.squared, 3)
rsqs[6, 3] <- round(summary(aop90w)$r.squared, 3)
rsqs[7, 1] <- round(summary(soy10w)$r.squared, 3)
rsqs[7, 2] <- round(summary(soy50w)$r.squared, 3)
rsqs[7, 3] <- round(summary(soy90w)$r.squared, 3)
rsqs[8, 1] <- round(summary(hfr10w)$r.squared, 3)
rsqs[8, 2] <- round(summary(hfr50w)$r.squared, 3)
rsqs[8, 3] <- round(summary(hfr90w)$r.squared, 3)
rsqs[9, 1] <- round(summary(cch10w)$r.squared, 3)
rsqs[9, 2] <- round(summary(cch50w)$r.squared, 3)
rsqs[9, 3] <- round(summary(cch90w)$r.squared, 3)
rsqs[10, 1] <- round(summary(ccn10w)$r.squared, 3)
rsqs[10, 2] <- round(summary(ccn50w)$r.squared, 3)
rsqs[10, 3] <- round(summary(ccn90w)$r.squared, 3)
rsqs[11, 1] <- round(summary(fnp10w)$r.squared, 3)
rsqs[11, 2] <- round(summary(fnp50w)$r.squared, 3)
rsqs[11, 3] <- round(summary(fnp90w)$r.squared, 3)
rsqs[12, 1] <- round(summary(cci10w)$r.squared, 3)
rsqs[12, 2] <- round(summary(cci50w)$r.squared, 3)
rsqs[12, 3] <- round(summary(cci90w)$r.squared, 3)
colnames(rsqs) <- c('ccP10T10', 'ccP50T50', 'ccP90T90')
rownames(rsqs) <- c('CSS True Forest', 'Natural Pervious', 'CSS Mixed Open', 'Natural Mixed Open',
                    'Hay and Forage', 'Ag Open Space', 'Commodity Crops', 'Harvested Forest',
                    'Turf Grass', 'Construction', 'Feeding Space', 'Impervious')
library(readxl)
library(kableExtra)

# OUTPUT TABLE IN KABLE FORMAT
kable(rsqs, "latex", booktabs = T,
      caption = paste("Coefficients of Determination Between Evaporation, Precipitation, and Land Use Runoff for Climate Change Scenarios"), 
      label = paste("Coefficients of Determination Between Evaporation, Precipitation, and Land Use Runoff for Climate Change Scenarios"),
      ) %>%
  kable_styling(latex_options = c("striped", "scale_down")) %>% 
  #column_spec(1, width = "5em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste("~/","rsqs.tex",sep=""))
