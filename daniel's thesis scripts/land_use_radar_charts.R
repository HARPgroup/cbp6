# Following the creation of the pct.changes scenario data frames, this script will create radar
# charts showing the land use unit flows for each land use group.

min.change.10 <- vector()
min.change.50 <- vector()
min.change.90 <- vector()

max.change.10 <- vector()
max.change.50 <- vector()
max.change.90 <- vector()

for (i in 1:length(pct.changes.10$segment)) {
  min.change.10[i] <- colnames(pct.changes.10[which(as.numeric(pct.changes.10[i,4:46]) == as.numeric(min(pct.changes.10[i,4:46])))+3])
  min.change.50[i] <- colnames(pct.changes.50[which(as.numeric(pct.changes.50[i,4:46]) == as.numeric(min(pct.changes.50[i,4:46])))+3])
  min.change.90[i] <- colnames(pct.changes.90[which(as.numeric(pct.changes.90[i,4:46]) == as.numeric(min(pct.changes.90[i,4:46])))+3])
  
  max.change.10[i] <- colnames(pct.changes.10[which(as.numeric(pct.changes.10[i,4:46]) == as.numeric(max(pct.changes.10[i,4:46])))+3])
  max.change.50[i] <- colnames(pct.changes.50[which(as.numeric(pct.changes.50[i,4:46]) == as.numeric(max(pct.changes.50[i,4:46])))+3])
  max.change.90[i] <- colnames(pct.changes.90[which(as.numeric(pct.changes.90[i,4:46]) == as.numeric(max(pct.changes.90[i,4:46])))+3])
}

table(min.change.10)
mean(pct.changes.10$cfr)
mean(pct.changes.10$for.)
table(min.change.50)
mean(pct.changes.50$cci)
mean(pct.changes.50$fnp)
mean(pct.changes.50$lhy)
mean(pct.changes.50$hfr)
table(min.change.90)
mean(pct.changes.90$cci)
mean(pct.changes.90$fnp)

table(max.change.10)
mean(pct.changes.10$cci)
mean(pct.changes.10$fnp)
table(max.change.50)
mean(pct.changes.50$aop)
mean(pct.changes.50$pas)
table(max.change.90)
mean(pct.changes.90$cfr)
mean(pct.changes.90$for.)

pct.changes.10 <- pct.changes.10[which(pct.changes.10$segment %in% lsegs.df_p10$FIPS_NHL),]
pct.changes.50 <- pct.changes.50[which(pct.changes.50$segment %in% lsegs.df_p50$FIPS_NHL),]
pct.changes.90 <- pct.changes.90[which(pct.changes.90$segment %in% lsegs.df_p90$FIPS_NHL),]

library(fmsb)
mean.change.10 <- as.data.frame(matrix(colMeans(pct.changes.10[,c(8,15,10,34,35,4,41,19,5,7,14,6)]), ncol = 12))
max.change.10 <- sapply(pct.changes.10[,c(8,15,10,34,35,4,41,19,5,7,14,6)], max)
min.change.10 <- sapply(pct.changes.10[,c(8,15,10,34,35,4,41,19,5,7,14,6)], min)
radar.changes.10 <- rbind(min.change.10, mean.change.10, max.change.10)
data.10 <- rbind(rep(0,length(colnames(mean.change.10))), rep(-40, length(colnames(mean.change.10))), radar.changes.10)
colnames(data.10) <- c('CSS True Forest', 'Natural Pervious', 'CSS Mixed Open', 'Natural Mixed Open',
                              'Hay and Forage', 'Ag Open Space', 'Commodity Crops', 'Harvested Forest',
                              'Turf Grass', 'Construction', 'Feeding Space', 'Impervious')
radarchart(data.10, axistype = 1, axislabcol = 'grey30',
           cglcol = 'grey', cglty = 1, plty = 1, plwd = 2,
           caxislabels = c('-40%', '-30%', '-20%', '-10%', '0%'),
           pcol = c('red', 'green', 'blue'))
legend(x = 1, y = 1.25, legend = c('Minimum', 'Mean', 'Maximum'), col = c('red', 'green', 'blue'), lty = 1, lwd = 2)

mean.change.50 <- as.data.frame(matrix(colMeans(pct.changes.50[,c(8,15,10,34,35,4,41,19,5,7,14,6)]), ncol = 12))
max.change.50 <- sapply(pct.changes.50[,c(8,15,10,34,35,4,41,19,5,7,14,6)], max)
min.change.50 <- sapply(pct.changes.50[,c(8,15,10,34,35,4,41,19,5,7,14,6)], min)
radar.changes.50 <- rbind(min.change.50, mean.change.50, max.change.50)
data.50 <- rbind(rep(16,length(colnames(mean.change.50))), rep(0, length(colnames(mean.change.50))), radar.changes.50)
colnames(data.50) <- c('CSS True Forest', 'Natural Pervious', 'CSS Mixed Open', 'Natural Mixed Open',
                       'Hay and Forage', 'Ag Open Space', 'Commodity Crops', 'Harvested Forest',
                       'Turf Grass', 'Construction', 'Feeding Space', 'Impervious')
radarchart(data.50, axistype = 1, axislabcol = 'grey30',
           cglcol = 'grey', cglty = 1, plty = 1, plwd = 2,
           caxislabels = c('0%', '4%', '8%', '12%', '16%'),
           pcol = c('red', 'green', 'blue'))
legend(x = 1, y = 1.25, legend = c('Minimum', 'Mean', 'Maximum'), col = c('red', 'green', 'blue'), lty = 1, lwd = 2)

mean.change.90 <- as.data.frame(matrix(colMeans(pct.changes.90[,c(8,15,10,34,35,4,41,19,5,7,14,6)]), ncol = 12))
max.change.90 <- sapply(pct.changes.90[,c(8,15,10,34,35,4,41,19,5,7,14,6)], max)
min.change.90 <- sapply(pct.changes.90[,c(8,15,10,34,35,4,41,19,5,7,14,6)], min)
radar.changes.90 <- rbind(min.change.90, mean.change.90, max.change.90)
data.90 <- rbind(rep(80,length(colnames(mean.change.90))), rep(20, length(colnames(mean.change.90))), radar.changes.90)
colnames(data.90) <- c('CSS True Forest', 'Natural Pervious', 'CSS Mixed Open', 'Natural Mixed Open',
                              'Hay and Forage', 'Ag Open Space', 'Commodity Crops', 'Harvested Forest',
                              'Turf Grass', 'Construction', 'Feeding Space', 'Impervious')
radarchart(data.90, axistype = 1, axislabcol = 'grey30',
           cglcol = 'grey', cglty = 1, plty = 1, plwd = 2,
           caxislabels = c('+20%', '+35%', '+50%', '+65%', '+80%'),
           pcol = c('red', 'green', 'blue'))
legend(x = 1, y = 1.25, legend = c('Minimum', 'Mean', 'Maximum'), col = c('red', 'green', 'blue'), lty = 1, lwd = 2)

radar.means <- rbind(mean.change.10, mean.change.50, mean.change.90)
data.means <- rbind(rep(60,length(colnames(radar.means))), rep(-30, length(colnames(radar.means))), radar.means)
colnames(data.means) <- c('CSS True Forest', 'Natural Pervious', 'CSS Mixed Open', 'Natural Mixed Open',
                       'Hay and Forage', 'Ag Open Space', 'Commodity Crops', 'Harvested Forest',
                       'Turf Grass', 'Construction', 'Feeding Space', 'Impervious')
radarchart(data.means, axistype = 1, axislabcol = 'grey30',
           cglcol = 'grey', cglty = 1, plty = 1, plwd = 2,
           caxislabels = c('-30%', '-7.5%', '+15%', '+37.5%', '+60%'),
           pcol = c('chocolate2', 'green3', 'blueviolet'))
legend(x = 1, y = 1.25, legend = c('ccP10T10', 'ccP50T50', 'ccP90T90'), col = c('chocolate2', 'green3', 'blueviolet'), lty = 1, lwd = 2)
