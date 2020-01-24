data.location <- 'C:\\Users\\danie\\Documents\\HARP\\GitHub\\cbp6\\Data\\CBP6_Temp_Prcp_Data'
va.or.cbw <- 'va'

# CREATING DIRECTORY TO STORE DATA AND OUTPUTS
dir.create('~/Precip_and_Temp_Mapper')
dir.location <- '~/Precip_and_Temp_Mapper'
setwd(dir.location)

if (va.or.cbw == 'va') {
    lseg.loc <- paste0(data.location, '\\P6_LSegs_VA')
  } else if (va.or.cbw == 'cbw') {
    lseg.loc <- paste0(data.location, '\\P6_LSegs')
  } else {
    print(paste('ERROR: Neither VA nor CBW selected'))
}

# LOADING DATA -----
land.seg.info <- read.csv(paste0(data.location, '\\Land_Segment_CBWatershed_Area.csv'), header = FALSE)

mod.names <- c('access1-0.1', 'bcc-csm1-1.1', 'bcc-csm1-1-m.1', 'canesm2.1',
               'ccsm4.1', 'cesm1-bgc.1', 'cesm1-cam5.1', 'cmcc-cm.1',
               'cnrm-cm5.1', 'csiro-mk3-6-0.1', 'ec-earth.8', 'fgoals-g2.1',
               'fio-esm.1', 'gfdl-cm3.1', 'gfdl-esm2g.1', 'gfdl-esm2m.1',
               'giss-e2-r.1', 'hadgem2-ao.1', 'hadgem2-cc.1', 'hadgem2-es.1',
               'inmcm4.1', 'ipsl-cm5a-lr.1', 'ipsl-cm5a-mr.1', 'ipsl-cm5b-lr.1',
               'miroc5.1', 'miroc-esm.1', 'miroc-esm-chem.1', 'mpi-esm-lr.1',
               'mpi-esm-mr.1', 'mri-cgcm3.1', 'noresm1-m.1')

PRCP.ENS.10.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_Ensemble_CRT_2041_2070_P10.csv'), nrows = 244)
PRCP.ENS.50.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_Ensemble_CRT_2041_2070_P50.csv'), nrows = 244)
PRCP.ENS.90.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_Ensemble_CRT_2041_2070_P90.csv'), nrows = 244)

prcp.ens.mod.1 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_access1-0.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.2 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_bcc-csm1-1.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.3 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_bcc-csm1-1-m.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.4 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_canesm2.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.5 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_ccsm4.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.6 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_cesm1-bgc.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.7 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_cesm1-cam5.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.8 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_cmcc-cm.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.9 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_cnrm-cm5.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.10 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_csiro-mk3-6-0.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.11 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_ec-earth.8_2041_2070.csv'), nrows = 244)
prcp.ens.mod.12 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_fgoals-g2.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.13 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_fio-esm.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.14 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_gfdl-cm3.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.15 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_gfdl-esm2g.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.16 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_gfdl-esm2m.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.17 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_giss-e2-r.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.18 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_hadgem2-ao.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.19 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_hadgem2-cc.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.20 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_hadgem2-es.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.21 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_inmcm4.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.22 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_ipsl-cm5a-lr.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.23 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_ipsl-cm5a-mr.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.24 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_ipsl-cm5b-lr.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.25 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_miroc5.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.26 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_miroc-esm.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.27 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_miroc-esm-chem.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.28 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_mpi-esm-lr.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.29 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_mpi-esm-mr.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.30 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_mri-cgcm3.1_2041_2070.csv'), nrows = 244)
prcp.ens.mod.31 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_noresm1-m.1_2041_2070.csv'), nrows = 244)

TEMP.ENS.10.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_Ensemble_CRT_2041_2070_P10.csv'), nrows = 244)
TEMP.ENS.50.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_Ensemble_CRT_2041_2070_P50.csv'), nrows = 244)
TEMP.ENS.90.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_Ensemble_CRT_2041_2070_P90.csv'), nrows = 244)

temp.ens.mod.1 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_access1-0.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.2 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_bcc-csm1-1.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.3 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_bcc-csm1-1-m.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.4 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_canesm2.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.5 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_ccsm4.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.6 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_cesm1-bgc.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.7 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_cesm1-cam5.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.8 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_cmcc-cm.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.9 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_cnrm-cm5.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.10 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_csiro-mk3-6-0.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.11 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_ec-earth.8_2041_2070.csv'), nrows = 244)
temp.ens.mod.12 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_fgoals-g2.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.13 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_fio-esm.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.14 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_gfdl-cm3.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.15 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_gfdl-esm2g.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.16 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_gfdl-esm2m.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.17 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_giss-e2-r.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.18 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_hadgem2-ao.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.19 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_hadgem2-cc.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.20 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_hadgem2-es.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.21 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_inmcm4.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.22 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_ipsl-cm5a-lr.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.23 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_ipsl-cm5a-mr.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.24 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_ipsl-cm5b-lr.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.25 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_miroc5.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.26 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_miroc-esm.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.27 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_miroc-esm-chem.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.28 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_mpi-esm-lr.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.29 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_mpi-esm-mr.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.30 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_mri-cgcm3.1_2041_2070.csv'), nrows = 244)
temp.ens.mod.31 <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_noresm1-m.1_2041_2070.csv'), nrows = 244)

# DOWNLOADING AND PREPPING LAND-RIVER SEGMENT DATA -- DOESN'T WORK RIGHT NOW -----
# library(rgdal)
# library(rgeos)
# library(dplyr)
#
# # downloading data
# download.file('ftp://ftp.chesapeakebay.net/gis/ModelingP6/P6Beta_v3_LRSegs_081516.zip', destfile = '~/p6_lrsegs.zip')
# unzip('~/p6_lrsegs.zip', exdir = '.')
# 
# # reading in lr-seg layer
# lrsegs <- readOGR('.', 'P6Beta_v3_LRSegs_081516')
# plot(lrsegs)
# 
# # join precipitation/temperature data
# lrsegs@data <- full_join(lrsegs@data, PRCP.ENS.10.PCT, by = 'FIPS_NHL')
# rownames(lrsegs@data) <- lrsegs@data$FIPS_NHL
# lrsegs <- spChFIDs(lrsegs, rownames(lrsegs@data))
# 
# # dissolving lr-seg layer to l-seg layer
# lsegs <- gUnaryUnion(lrsegs, id = lrsegs@data$FIPS_NHL)
# plot(lsegs)

# USING LOCALLY STORED, MANUALLY CREATED LAND-SEG GIS LAYER
library(rgdal)

if (va.or.cbw == 'va') {
    lsegs <- readOGR(lseg.loc, 'P6_LSegs_VA')
  } else if (va.or.cbw == 'cbw') {
    lsegs <- readOGR(lseg.loc, 'P6_LSegs')
  } else {
    print(paste('ERROR: Neither VA nor CBW selected'))
}

# plot(lsegs) #make sure the plot looks right

# CREATING PLOTS -----
# library(ggplot2)
# library(maptools)
# library(broom)
library(tmap)

#p10 precip mapping:
p10.prcp.lsegs <- lsegs
p10.prcp.lsegs@data <- merge(x = p10.prcp.lsegs@data, y = PRCP.ENS.10.PCT, by = 'FIPS_NHL', all.x = TRUE)
p10.prcp.lsegs$`Overall P10 Precipitation Change` <- p10.prcp.lsegs$Total
png('p10.prcp.overall.map.png', width = 800, height = 600)
qtm(p10.prcp.lsegs, fill = 'Overall P10 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.prcp.lsegs$`Jan. P10 Precipitation Change` <- p10.prcp.lsegs$Jan
png('p10.prcp.jan.map.png', width = 800, height = 600)
qtm(p10.prcp.lsegs, fill = 'Jan. P10 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.prcp.lsegs$`Feb. P10 Precipitation Change` <- p10.prcp.lsegs$Feb
png('p10.prcp.feb.map.png', width = 800, height = 600)
qtm(p10.prcp.lsegs, fill = 'Feb. P10 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.prcp.lsegs$`Mar. P10 Precipitation Change` <- p10.prcp.lsegs$Mar
png('p10.prcp.mar.map.png', width = 800, height = 600)
qtm(p10.prcp.lsegs, fill = 'Mar. P10 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.prcp.lsegs$`Apr. P10 Precipitation Change` <- p10.prcp.lsegs$Apr
png('p10.prcp.apr.map.png', width = 800, height = 600)
qtm(p10.prcp.lsegs, fill = 'Apr. P10 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.prcp.lsegs$`May P10 Precipitation Change` <- p10.prcp.lsegs$May
png('p10.prcp.may.map.png', width = 800, height = 600)
qtm(p10.prcp.lsegs, fill = 'May P10 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.prcp.lsegs$`Jun. P10 Precipitation Change` <- p10.prcp.lsegs$Jun
png('p10.prcp.jun.map.png', width = 800, height = 600)
qtm(p10.prcp.lsegs, fill = 'Jun. P10 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.prcp.lsegs$`Jul. P10 Precipitation Change` <- p10.prcp.lsegs$Jul
png('p10.prcp.jul.map.png', width = 800, height = 600)
qtm(p10.prcp.lsegs, fill = 'Jul. P10 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.prcp.lsegs$`Aug. P10 Precipitation Change` <- p10.prcp.lsegs$Aug
png('p10.prcp.aug.map.png', width = 800, height = 600)
qtm(p10.prcp.lsegs, fill = 'Aug. P10 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.prcp.lsegs$`Sep. P10 Precipitation Change` <- p10.prcp.lsegs$Sep
png('p10.prcp.sep.map.png', width = 800, height = 600)
qtm(p10.prcp.lsegs, fill = 'Sep. P10 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.prcp.lsegs$`Oct. P10 Precipitation Change` <- p10.prcp.lsegs$Oct
png('p10.prcp.oct.map.png', width = 800, height = 600)
qtm(p10.prcp.lsegs, fill = 'Oct. P10 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.prcp.lsegs$`Nov. P10 Precipitation Change` <- p10.prcp.lsegs$Nov
png('p10.prcp.nov.map.png', width = 800, height = 600)
qtm(p10.prcp.lsegs, fill = 'Nov. P10 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.prcp.lsegs$`Dec. P10 Precipitation Change` <- p10.prcp.lsegs$Dec
png('p10.prcp.dec.map.png', width = 800, height = 600)
qtm(p10.prcp.lsegs, fill = 'Dec. P10 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()

png('p10.prcp.overall.long.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_X, p10.prcp.lsegs$Total, xlab = 'Longitude (deg W)', 
     ylab = 'Overall P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Total ~ p10.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.jan.long.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_X, p10.prcp.lsegs$Jan, xlab = 'Longitude (deg W)', 
     ylab = 'Jan. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Jan ~ p10.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.feb.long.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_X, p10.prcp.lsegs$Feb, xlab = 'Longitude (deg W)', 
     ylab = 'Feb. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Feb ~ p10.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.mar.long.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_X, p10.prcp.lsegs$Mar, xlab = 'Longitude (deg W)', 
     ylab = 'Mar. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Mar ~ p10.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.apr.long.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_X, p10.prcp.lsegs$Apr, xlab = 'Longitude (deg W)', 
     ylab = 'Apr. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Apr ~ p10.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.may.long.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_X, p10.prcp.lsegs$May, xlab = 'Longitude (deg W)', 
     ylab = 'May P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$May ~ p10.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.jun.long.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_X, p10.prcp.lsegs$Jun, xlab = 'Longitude (deg W)', 
     ylab = 'Jun. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Jun ~ p10.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.jul.long.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_X, p10.prcp.lsegs$Jul, xlab = 'Longitude (deg W)', 
     ylab = 'Jul. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Jul ~ p10.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.aug.long.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_X, p10.prcp.lsegs$Aug, xlab = 'Longitude (deg W)', 
     ylab = 'Aug. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Aug ~ p10.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.sep.long.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_X, p10.prcp.lsegs$Sep, xlab = 'Longitude (deg W)', 
     ylab = 'Sep. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Sep ~ p10.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.oct.long.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_X, p10.prcp.lsegs$Oct, xlab = 'Longitude (deg W)', 
     ylab = 'Oct. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Oct ~ p10.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.nov.long.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_X, p10.prcp.lsegs$Nov, xlab = 'Longitude (deg W)', 
     ylab = 'Nov. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Nov ~ p10.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.dec.long.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_X, p10.prcp.lsegs$Dec, xlab = 'Longitude (deg W)', 
     ylab = 'Dec. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Dec ~ p10.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()

png('p10.prcp.overall.lat.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_Y, p10.prcp.lsegs$Total, xlab = 'Latitude (deg N)', 
     ylab = 'Overall P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Total ~ p10.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.jan.lat.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_Y, p10.prcp.lsegs$Jan, xlab = 'Latitude (deg N)', 
     ylab = 'Jan. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Jan ~ p10.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.feb.lat.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_Y, p10.prcp.lsegs$Feb, xlab = 'Latitude (deg N)', 
     ylab = 'Feb. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Feb ~ p10.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.mar.lat.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_Y, p10.prcp.lsegs$Mar, xlab = 'Latitude (deg N)', 
     ylab = 'Mar. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Mar ~ p10.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.apr.lat.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_Y, p10.prcp.lsegs$Apr, xlab = 'Latitude (deg N)', 
     ylab = 'Apr. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Apr ~ p10.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.may.lat.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_Y, p10.prcp.lsegs$May, xlab = 'Latitude (deg N)', 
     ylab = 'May P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$May ~ p10.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.jun.lat.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_Y, p10.prcp.lsegs$Jun, xlab = 'Latitude (deg N)', 
     ylab = 'Jun. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Jun ~ p10.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.jul.lat.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_Y, p10.prcp.lsegs$Jul, xlab = 'Latitude (deg N)', 
     ylab = 'Jul. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Jul ~ p10.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.aug.lat.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_Y, p10.prcp.lsegs$Aug, xlab = 'Latitude (deg N)', 
     ylab = 'Aug. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Aug ~ p10.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.sep.lat.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_Y, p10.prcp.lsegs$Sep, xlab = 'Latitude (deg N)', 
     ylab = 'Sep. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Sep ~ p10.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.oct.lat.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_Y, p10.prcp.lsegs$Oct, xlab = 'Latitude (deg N)', 
     ylab = 'Oct. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Oct ~ p10.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.nov.lat.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_Y, p10.prcp.lsegs$Nov, xlab = 'Latitude (deg N)', 
     ylab = 'Nov. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Nov ~ p10.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.prcp.dec.lat.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_Y, p10.prcp.lsegs$Dec, xlab = 'Latitude (deg N)', 
     ylab = 'Dec. P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Dec ~ p10.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()

#p10 temp mapping:
p10.temp.lsegs <- lsegs
p10.temp.lsegs@data <- merge(x = p10.temp.lsegs@data, y = TEMP.ENS.10.PCT, by = 'FIPS_NHL', all.x = TRUE)
p10.temp.lsegs$`Overall P10 Temperature Change` <- p10.temp.lsegs$Total
png('p10.temp.overall.map.png', width = 800, height = 600)
qtm(p10.temp.lsegs, fill = 'Overall P10 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.temp.lsegs$`Jan. P10 Temperature Change` <- p10.temp.lsegs$Jan
png('p10.temp.jan.map.png', width = 800, height = 600)
qtm(p10.temp.lsegs, fill = 'Jan. P10 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.temp.lsegs$`Feb. P10 Temperature Change` <- p10.temp.lsegs$Feb
png('p10.temp.feb.map.png', width = 800, height = 600)
qtm(p10.temp.lsegs, fill = 'Feb. P10 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.temp.lsegs$`Mar. P10 Temperature Change` <- p10.temp.lsegs$Mar
png('p10.temp.mar.map.png', width = 800, height = 600)
qtm(p10.temp.lsegs, fill = 'Mar. P10 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.temp.lsegs$`Apr. P10 Temperature Change` <- p10.temp.lsegs$Apr
png('p10.temp.apr.map.png', width = 800, height = 600)
qtm(p10.temp.lsegs, fill = 'Apr. P10 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.temp.lsegs$`May P10 Temperature Change` <- p10.temp.lsegs$May
png('p10.temp.may.map.png', width = 800, height = 600)
qtm(p10.temp.lsegs, fill = 'May P10 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.temp.lsegs$`Jun. P10 Temperature Change` <- p10.temp.lsegs$Jun
png('p10.temp.jun.map.png', width = 800, height = 600)
qtm(p10.temp.lsegs, fill = 'Jun. P10 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.temp.lsegs$`Jul. P10 Temperature Change` <- p10.temp.lsegs$Jul
png('p10.temp.jul.map.png', width = 800, height = 600)
qtm(p10.temp.lsegs, fill = 'Jul. P10 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.temp.lsegs$`Aug. P10 Temperature Change` <- p10.temp.lsegs$Aug
png('p10.temp.aug.map.png', width = 800, height = 600)
qtm(p10.temp.lsegs, fill = 'Aug. P10 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.temp.lsegs$`Sep. P10 Temperature Change` <- p10.temp.lsegs$Sep
png('p10.temp.sep.map.png', width = 800, height = 600)
qtm(p10.temp.lsegs, fill = 'Sep. P10 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.temp.lsegs$`Oct. P10 Temperature Change` <- p10.temp.lsegs$Oct
png('p10.temp.oct.map.png', width = 800, height = 600)
qtm(p10.temp.lsegs, fill = 'Oct. P10 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.temp.lsegs$`Nov. P10 Temperature Change` <- p10.temp.lsegs$Nov
png('p10.temp.nov.map.png', width = 800, height = 600)
qtm(p10.temp.lsegs, fill = 'Nov. P10 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p10.temp.lsegs$`Dec. P10 Temperature Change` <- p10.temp.lsegs$Dec
png('p10.temp.dec.map.png', width = 800, height = 600)
qtm(p10.temp.lsegs, fill = 'Dec. P10 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()

png('p10.temp.overall.long.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_X, p10.temp.lsegs$Total, xlab = 'Longitude (deg W)', 
     ylab = 'Overall P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Total ~ p10.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.jan.long.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_X, p10.temp.lsegs$Jan, xlab = 'Longitude (deg W)', 
     ylab = 'Jan. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Jan ~ p10.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.feb.long.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_X, p10.temp.lsegs$Feb, xlab = 'Longitude (deg W)', 
     ylab = 'Feb. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Feb ~ p10.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.mar.long.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_X, p10.temp.lsegs$Mar, xlab = 'Longitude (deg W)', 
     ylab = 'Mar. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Mar ~ p10.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.apr.long.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_X, p10.temp.lsegs$Apr, xlab = 'Longitude (deg W)', 
     ylab = 'Apr. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Apr ~ p10.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.may.long.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_X, p10.temp.lsegs$May, xlab = 'Longitude (deg W)', 
     ylab = 'May P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$May ~ p10.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.jun.long.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_X, p10.temp.lsegs$Jun, xlab = 'Longitude (deg W)', 
     ylab = 'Jun. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Jun ~ p10.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.jul.long.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_X, p10.temp.lsegs$Jul, xlab = 'Longitude (deg W)', 
     ylab = 'Jul. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Jul ~ p10.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.aug.long.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_X, p10.temp.lsegs$Aug, xlab = 'Longitude (deg W)', 
     ylab = 'Aug. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Aug ~ p10.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.sep.long.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_X, p10.temp.lsegs$Sep, xlab = 'Longitude (deg W)', 
     ylab = 'Sep. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Sep ~ p10.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.oct.long.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_X, p10.temp.lsegs$Oct, xlab = 'Longitude (deg W)', 
     ylab = 'Oct. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Oct ~ p10.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.nov.long.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_X, p10.temp.lsegs$Nov, xlab = 'Longitude (deg W)', 
     ylab = 'Nov. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Nov ~ p10.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.dec.long.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_X, p10.temp.lsegs$Dec, xlab = 'Longitude (deg W)', 
     ylab = 'Dec. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Dec ~ p10.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()

png('p10.temp.overall.lat.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_Y, p10.temp.lsegs$Total, xlab = 'Latitude (deg N)', 
     ylab = 'Overall P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Total ~ p10.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.jan.lat.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_Y, p10.temp.lsegs$Jan, xlab = 'Latitude (deg N)', 
     ylab = 'Jan. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Jan ~ p10.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.feb.lat.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_Y, p10.temp.lsegs$Feb, xlab = 'Latitude (deg N)', 
     ylab = 'Feb. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Feb ~ p10.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.mar.lat.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_Y, p10.temp.lsegs$Mar, xlab = 'Latitude (deg N)', 
     ylab = 'Mar. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Mar ~ p10.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.apr.lat.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_Y, p10.temp.lsegs$Apr, xlab = 'Latitude (deg N)', 
     ylab = 'Apr. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Apr ~ p10.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.may.lat.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_Y, p10.temp.lsegs$May, xlab = 'Latitude (deg N)', 
     ylab = 'May P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$May ~ p10.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.jun.lat.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_Y, p10.temp.lsegs$Jun, xlab = 'Latitude (deg N)', 
     ylab = 'Jun. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Jun ~ p10.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.jul.lat.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_Y, p10.temp.lsegs$Jul, xlab = 'Latitude (deg N)', 
     ylab = 'Jul. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Jul ~ p10.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.aug.lat.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_Y, p10.temp.lsegs$Aug, xlab = 'Latitude (deg N)', 
     ylab = 'Aug. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Aug ~ p10.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.sep.lat.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_Y, p10.temp.lsegs$Sep, xlab = 'Latitude (deg N)', 
     ylab = 'Sep. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Sep ~ p10.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.oct.lat.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_Y, p10.temp.lsegs$Oct, xlab = 'Latitude (deg N)', 
     ylab = 'Oct. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Oct ~ p10.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.nov.lat.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_Y, p10.temp.lsegs$Nov, xlab = 'Latitude (deg N)', 
     ylab = 'Nov. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Nov ~ p10.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p10.temp.dec.lat.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_Y, p10.temp.lsegs$Dec, xlab = 'Latitude (deg N)', 
     ylab = 'Dec. P10 Temperature Change (%)')
abline(fit <- lm(p10.temp.lsegs$Dec ~ p10.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()

#p50 precip mapping:
p50.prcp.lsegs <- lsegs
p50.prcp.lsegs@data <- merge(x = p50.prcp.lsegs@data, y = PRCP.ENS.50.PCT, by = 'FIPS_NHL', all.x = TRUE)
p50.prcp.lsegs$`Overall P50 Precipitation Change` <- p50.prcp.lsegs$Total
png('p50.prcp.overall.map.png', width = 800, height = 600)
qtm(p50.prcp.lsegs, fill = 'Overall P50 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.prcp.lsegs$`Jan. P50 Precipitation Change` <- p50.prcp.lsegs$Jan
png('p50.prcp.jan.map.png', width = 800, height = 600)
qtm(p50.prcp.lsegs, fill = 'Jan. P50 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.prcp.lsegs$`Feb. P50 Precipitation Change` <- p50.prcp.lsegs$Feb
png('p50.prcp.feb.map.png', width = 800, height = 600)
qtm(p50.prcp.lsegs, fill = 'Feb. P50 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.prcp.lsegs$`Mar. P50 Precipitation Change` <- p50.prcp.lsegs$Mar
png('p50.prcp.mar.map.png', width = 800, height = 600)
qtm(p50.prcp.lsegs, fill = 'Mar. P50 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.prcp.lsegs$`Apr. P50 Precipitation Change` <- p50.prcp.lsegs$Apr
png('p50.prcp.apr.map.png', width = 800, height = 600)
qtm(p50.prcp.lsegs, fill = 'Apr. P50 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.prcp.lsegs$`May P50 Precipitation Change` <- p50.prcp.lsegs$May
png('p50.prcp.may.map.png', width = 800, height = 600)
qtm(p50.prcp.lsegs, fill = 'May P50 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.prcp.lsegs$`Jun. P50 Precipitation Change` <- p50.prcp.lsegs$Jun
png('p50.prcp.jun.map.png', width = 800, height = 600)
qtm(p50.prcp.lsegs, fill = 'Jun. P50 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.prcp.lsegs$`Jul. P50 Precipitation Change` <- p50.prcp.lsegs$Jul
png('p50.prcp.jul.map.png', width = 800, height = 600)
qtm(p50.prcp.lsegs, fill = 'Jul. P50 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.prcp.lsegs$`Aug. P50 Precipitation Change` <- p50.prcp.lsegs$Aug
png('p50.prcp.aug.map.png', width = 800, height = 600)
qtm(p50.prcp.lsegs, fill = 'Aug. P50 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.prcp.lsegs$`Sep. P50 Precipitation Change` <- p50.prcp.lsegs$Sep
png('p50.prcp.sep.map.png', width = 800, height = 600)
qtm(p50.prcp.lsegs, fill = 'Sep. P50 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.prcp.lsegs$`Oct. P50 Precipitation Change` <- p50.prcp.lsegs$Oct
png('p50.prcp.oct.map.png', width = 800, height = 600)
qtm(p50.prcp.lsegs, fill = 'Oct. P50 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.prcp.lsegs$`Nov. P50 Precipitation Change` <- p50.prcp.lsegs$Nov
png('p50.prcp.nov.map.png', width = 800, height = 600)
qtm(p50.prcp.lsegs, fill = 'Nov. P50 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.prcp.lsegs$`Dec. P50 Precipitation Change` <- p50.prcp.lsegs$Dec
png('p50.prcp.dec.map.png', width = 800, height = 600)
qtm(p50.prcp.lsegs, fill = 'Dec. P50 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()

png('p50.prcp.overall.long.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_X, p50.prcp.lsegs$Total, xlab = 'Longitude (deg W)', 
     ylab = 'Overall P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Total ~ p50.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.jan.long.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_X, p50.prcp.lsegs$Jan, xlab = 'Longitude (deg W)', 
     ylab = 'Jan. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Jan ~ p50.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.feb.long.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_X, p50.prcp.lsegs$Feb, xlab = 'Longitude (deg W)', 
     ylab = 'Feb. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Feb ~ p50.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.mar.long.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_X, p50.prcp.lsegs$Mar, xlab = 'Longitude (deg W)', 
     ylab = 'Mar. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Mar ~ p50.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.apr.long.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_X, p50.prcp.lsegs$Apr, xlab = 'Longitude (deg W)', 
     ylab = 'Apr. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Apr ~ p50.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.may.long.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_X, p50.prcp.lsegs$May, xlab = 'Longitude (deg W)', 
     ylab = 'May P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$May ~ p50.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.jun.long.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_X, p50.prcp.lsegs$Jun, xlab = 'Longitude (deg W)', 
     ylab = 'Jun. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Jun ~ p50.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.jul.long.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_X, p50.prcp.lsegs$Jul, xlab = 'Longitude (deg W)', 
     ylab = 'Jul. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Jul ~ p50.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.aug.long.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_X, p50.prcp.lsegs$Aug, xlab = 'Longitude (deg W)', 
     ylab = 'Aug. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Aug ~ p50.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.sep.long.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_X, p50.prcp.lsegs$Sep, xlab = 'Longitude (deg W)', 
     ylab = 'Sep. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Sep ~ p50.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.oct.long.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_X, p50.prcp.lsegs$Oct, xlab = 'Longitude (deg W)', 
     ylab = 'Oct. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Oct ~ p50.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.nov.long.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_X, p50.prcp.lsegs$Nov, xlab = 'Longitude (deg W)', 
     ylab = 'Nov. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Nov ~ p50.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.dec.long.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_X, p50.prcp.lsegs$Dec, xlab = 'Longitude (deg W)', 
     ylab = 'Dec. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Dec ~ p50.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()

png('p50.prcp.overall.lat.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_Y, p50.prcp.lsegs$Total, xlab = 'Latitude (deg N)', 
     ylab = 'Overall P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Total ~ p50.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.jan.lat.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_Y, p50.prcp.lsegs$Jan, xlab = 'Latitude (deg N)', 
     ylab = 'Jan. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Jan ~ p50.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.feb.lat.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_Y, p50.prcp.lsegs$Feb, xlab = 'Latitude (deg N)', 
     ylab = 'Feb. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Feb ~ p50.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.mar.lat.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_Y, p50.prcp.lsegs$Mar, xlab = 'Latitude (deg N)', 
     ylab = 'Mar. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Mar ~ p50.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.apr.lat.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_Y, p50.prcp.lsegs$Apr, xlab = 'Latitude (deg N)', 
     ylab = 'Apr. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Apr ~ p50.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.may.lat.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_Y, p50.prcp.lsegs$May, xlab = 'Latitude (deg N)', 
     ylab = 'May P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$May ~ p50.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.jun.lat.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_Y, p50.prcp.lsegs$Jun, xlab = 'Latitude (deg N)', 
     ylab = 'Jun. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Jun ~ p50.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.jul.lat.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_Y, p50.prcp.lsegs$Jul, xlab = 'Latitude (deg N)', 
     ylab = 'Jul. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Jul ~ p50.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.aug.lat.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_Y, p50.prcp.lsegs$Aug, xlab = 'Latitude (deg N)', 
     ylab = 'Aug. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Aug ~ p50.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.sep.lat.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_Y, p50.prcp.lsegs$Sep, xlab = 'Latitude (deg N)', 
     ylab = 'Sep. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Sep ~ p50.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.oct.lat.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_Y, p50.prcp.lsegs$Oct, xlab = 'Latitude (deg N)', 
     ylab = 'Oct. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Oct ~ p50.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.nov.lat.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_Y, p50.prcp.lsegs$Nov, xlab = 'Latitude (deg N)', 
     ylab = 'Nov. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Nov ~ p50.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.prcp.dec.lat.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_Y, p50.prcp.lsegs$Dec, xlab = 'Latitude (deg N)', 
     ylab = 'Dec. P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Dec ~ p50.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()

#p50 temp mapping:
p50.temp.lsegs <- lsegs
p50.temp.lsegs@data <- merge(x = p50.temp.lsegs@data, y = TEMP.ENS.50.PCT, by = 'FIPS_NHL', all.x = TRUE)
p50.temp.lsegs$`Overall P50 Temperature Change` <- p50.temp.lsegs$Total
png('p50.temp.overall.map.png', width = 800, height = 600)
qtm(p50.temp.lsegs, fill = 'Overall P50 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.temp.lsegs$`Jan. P50 Temperature Change` <- p50.temp.lsegs$Jan
png('p50.temp.jan.map.png', width = 800, height = 600)
qtm(p50.temp.lsegs, fill = 'Jan. P50 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.temp.lsegs$`Feb. P50 Temperature Change` <- p50.temp.lsegs$Feb
png('p50.temp.feb.map.png', width = 800, height = 600)
qtm(p50.temp.lsegs, fill = 'Feb. P50 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.temp.lsegs$`Mar. P50 Temperature Change` <- p50.temp.lsegs$Mar
png('p50.temp.mar.map.png', width = 800, height = 600)
qtm(p50.temp.lsegs, fill = 'Mar. P50 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.temp.lsegs$`Apr. P50 Temperature Change` <- p50.temp.lsegs$Apr
png('p50.temp.apr.map.png', width = 800, height = 600)
qtm(p50.temp.lsegs, fill = 'Apr. P50 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.temp.lsegs$`May P50 Temperature Change` <- p50.temp.lsegs$May
png('p50.temp.may.map.png', width = 800, height = 600)
qtm(p50.temp.lsegs, fill = 'May P50 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.temp.lsegs$`Jun. P50 Temperature Change` <- p50.temp.lsegs$Jun
png('p50.temp.jun.map.png', width = 800, height = 600)
qtm(p50.temp.lsegs, fill = 'Jun. P50 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.temp.lsegs$`Jul. P50 Temperature Change` <- p50.temp.lsegs$Jul
png('p50.temp.jul.map.png', width = 800, height = 600)
qtm(p50.temp.lsegs, fill = 'Jul. P50 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.temp.lsegs$`Aug. P50 Temperature Change` <- p50.temp.lsegs$Aug
png('p50.temp.aug.map.png', width = 800, height = 600)
qtm(p50.temp.lsegs, fill = 'Aug. P50 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.temp.lsegs$`Sep. P50 Temperature Change` <- p50.temp.lsegs$Sep
png('p50.temp.sep.map.png', width = 800, height = 600)
qtm(p50.temp.lsegs, fill = 'Sep. P50 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.temp.lsegs$`Oct. P50 Temperature Change` <- p50.temp.lsegs$Oct
png('p50.temp.oct.map.png', width = 800, height = 600)
qtm(p50.temp.lsegs, fill = 'Oct. P50 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.temp.lsegs$`Nov. P50 Temperature Change` <- p50.temp.lsegs$Nov
png('p50.temp.nov.map.png', width = 800, height = 600)
qtm(p50.temp.lsegs, fill = 'Nov. P50 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p50.temp.lsegs$`Dec. P50 Temperature Change` <- p50.temp.lsegs$Dec
png('p50.temp.dec.map.png', width = 800, height = 600)
qtm(p50.temp.lsegs, fill = 'Dec. P50 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()

png('p50.temp.overall.long.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_X, p50.temp.lsegs$Total, xlab = 'Longitude (deg W)', 
     ylab = 'Overall P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Total ~ p50.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.jan.long.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_X, p50.temp.lsegs$Jan, xlab = 'Longitude (deg W)', 
     ylab = 'Jan. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Jan ~ p50.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.feb.long.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_X, p50.temp.lsegs$Feb, xlab = 'Longitude (deg W)', 
     ylab = 'Feb. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Feb ~ p50.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.mar.long.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_X, p50.temp.lsegs$Mar, xlab = 'Longitude (deg W)', 
     ylab = 'Mar. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Mar ~ p50.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.apr.long.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_X, p50.temp.lsegs$Apr, xlab = 'Longitude (deg W)', 
     ylab = 'Apr. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Apr ~ p50.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.may.long.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_X, p50.temp.lsegs$May, xlab = 'Longitude (deg W)', 
     ylab = 'May P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$May ~ p50.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.jun.long.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_X, p50.temp.lsegs$Jun, xlab = 'Longitude (deg W)', 
     ylab = 'Jun. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Jun ~ p50.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.jul.long.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_X, p50.temp.lsegs$Jul, xlab = 'Longitude (deg W)', 
     ylab = 'Jul. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Jul ~ p50.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.aug.long.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_X, p50.temp.lsegs$Aug, xlab = 'Longitude (deg W)', 
     ylab = 'Aug. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Aug ~ p50.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.sep.long.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_X, p50.temp.lsegs$Sep, xlab = 'Longitude (deg W)', 
     ylab = 'Sep. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Sep ~ p50.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.oct.long.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_X, p50.temp.lsegs$Oct, xlab = 'Longitude (deg W)', 
     ylab = 'Oct. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Oct ~ p50.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.nov.long.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_X, p50.temp.lsegs$Nov, xlab = 'Longitude (deg W)', 
     ylab = 'Nov. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Nov ~ p50.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.dec.long.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_X, p50.temp.lsegs$Dec, xlab = 'Longitude (deg W)', 
     ylab = 'Dec. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Dec ~ p50.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()

png('p50.temp.overall.lat.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_Y, p50.temp.lsegs$Total, xlab = 'Latitude (deg N)', 
     ylab = 'Overall P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Total ~ p50.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.jan.lat.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_Y, p50.temp.lsegs$Jan, xlab = 'Latitude (deg N)', 
     ylab = 'Jan. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Jan ~ p50.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.feb.lat.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_Y, p50.temp.lsegs$Feb, xlab = 'Latitude (deg N)', 
     ylab = 'Feb. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Feb ~ p50.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.mar.lat.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_Y, p50.temp.lsegs$Mar, xlab = 'Latitude (deg N)', 
     ylab = 'Mar. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Mar ~ p50.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.apr.lat.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_Y, p50.temp.lsegs$Apr, xlab = 'Latitude (deg N)', 
     ylab = 'Apr. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Apr ~ p50.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.may.lat.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_Y, p50.temp.lsegs$May, xlab = 'Latitude (deg N)', 
     ylab = 'May P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$May ~ p50.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.jun.lat.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_Y, p50.temp.lsegs$Jun, xlab = 'Latitude (deg N)', 
     ylab = 'Jun. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Jun ~ p50.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.jul.lat.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_Y, p50.temp.lsegs$Jul, xlab = 'Latitude (deg N)', 
     ylab = 'Jul. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Jul ~ p50.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.aug.lat.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_Y, p50.temp.lsegs$Aug, xlab = 'Latitude (deg N)', 
     ylab = 'Aug. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Aug ~ p50.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.sep.lat.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_Y, p50.temp.lsegs$Sep, xlab = 'Latitude (deg N)', 
     ylab = 'Sep. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Sep ~ p50.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.oct.lat.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_Y, p50.temp.lsegs$Oct, xlab = 'Latitude (deg N)', 
     ylab = 'Oct. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Oct ~ p50.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.nov.lat.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_Y, p50.temp.lsegs$Nov, xlab = 'Latitude (deg N)', 
     ylab = 'Nov. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Nov ~ p50.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p50.temp.dec.lat.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_Y, p50.temp.lsegs$Dec, xlab = 'Latitude (deg N)', 
     ylab = 'Dec. P50 Temperature Change (%)')
abline(fit <- lm(p50.temp.lsegs$Dec ~ p50.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()

#p90 precip mapping:
p90.prcp.lsegs <- lsegs
p90.prcp.lsegs@data <- merge(x = p90.prcp.lsegs@data, y = PRCP.ENS.90.PCT, by = 'FIPS_NHL', all.x = TRUE)
p90.prcp.lsegs$`Overall P90 Precipitation Change` <- p90.prcp.lsegs$Total
png('p90.prcp.overall.map.png', width = 800, height = 600)
qtm(p90.prcp.lsegs, fill = 'Overall P90 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.prcp.lsegs$`Jan. P90 Precipitation Change` <- p90.prcp.lsegs$Jan
png('p90.prcp.jan.map.png', width = 800, height = 600)
qtm(p90.prcp.lsegs, fill = 'Jan. P90 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.prcp.lsegs$`Feb. P90 Precipitation Change` <- p90.prcp.lsegs$Feb
png('p90.prcp.feb.map.png', width = 800, height = 600)
qtm(p90.prcp.lsegs, fill = 'Feb. P90 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.prcp.lsegs$`Mar. P90 Precipitation Change` <- p90.prcp.lsegs$Mar
png('p90.prcp.mar.map.png', width = 800, height = 600)
qtm(p90.prcp.lsegs, fill = 'Mar. P90 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.prcp.lsegs$`Apr. P90 Precipitation Change` <- p90.prcp.lsegs$Apr
png('p90.prcp.apr.map.png', width = 800, height = 600)
qtm(p90.prcp.lsegs, fill = 'Apr. P90 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.prcp.lsegs$`May P90 Precipitation Change` <- p90.prcp.lsegs$May
png('p90.prcp.may.map.png', width = 800, height = 600)
qtm(p90.prcp.lsegs, fill = 'May P90 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.prcp.lsegs$`Jun. P90 Precipitation Change` <- p90.prcp.lsegs$Jun
png('p90.prcp.jun.map.png', width = 800, height = 600)
qtm(p90.prcp.lsegs, fill = 'Jun. P90 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.prcp.lsegs$`Jul. P90 Precipitation Change` <- p90.prcp.lsegs$Jul
png('p90.prcp.jul.map.png', width = 800, height = 600)
qtm(p90.prcp.lsegs, fill = 'Jul. P90 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.prcp.lsegs$`Aug. P90 Precipitation Change` <- p90.prcp.lsegs$Aug
png('p90.prcp.aug.map.png', width = 800, height = 600)
qtm(p90.prcp.lsegs, fill = 'Aug. P90 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.prcp.lsegs$`Sep. P90 Precipitation Change` <- p90.prcp.lsegs$Sep
png('p90.prcp.sep.map.png', width = 800, height = 600)
qtm(p90.prcp.lsegs, fill = 'Sep. P90 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.prcp.lsegs$`Oct. P90 Precipitation Change` <- p90.prcp.lsegs$Oct
png('p90.prcp.oct.map.png', width = 800, height = 600)
qtm(p90.prcp.lsegs, fill = 'Oct. P90 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.prcp.lsegs$`Nov. P90 Precipitation Change` <- p90.prcp.lsegs$Nov
png('p90.prcp.nov.map.png', width = 800, height = 600)
qtm(p90.prcp.lsegs, fill = 'Nov. P90 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.prcp.lsegs$`Dec. P90 Precipitation Change` <- p90.prcp.lsegs$Dec
png('p90.prcp.dec.map.png', width = 800, height = 600)
qtm(p90.prcp.lsegs, fill = 'Dec. P90 Precipitation Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()

png('p90.prcp.overall.long.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_X, p90.prcp.lsegs$Total, xlab = 'Longitude (deg W)', 
     ylab = 'Overall P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Total ~ p90.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.jan.long.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_X, p90.prcp.lsegs$Jan, xlab = 'Longitude (deg W)', 
     ylab = 'Jan. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Jan ~ p90.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.feb.long.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_X, p90.prcp.lsegs$Feb, xlab = 'Longitude (deg W)', 
     ylab = 'Feb. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Feb ~ p90.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.mar.long.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_X, p90.prcp.lsegs$Mar, xlab = 'Longitude (deg W)', 
     ylab = 'Mar. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Mar ~ p90.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.apr.long.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_X, p90.prcp.lsegs$Apr, xlab = 'Longitude (deg W)', 
     ylab = 'Apr. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Apr ~ p90.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.may.long.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_X, p90.prcp.lsegs$May, xlab = 'Longitude (deg W)', 
     ylab = 'May P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$May ~ p90.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.jun.long.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_X, p90.prcp.lsegs$Jun, xlab = 'Longitude (deg W)', 
     ylab = 'Jun. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Jun ~ p90.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.jul.long.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_X, p90.prcp.lsegs$Jul, xlab = 'Longitude (deg W)', 
     ylab = 'Jul. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Jul ~ p90.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.aug.long.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_X, p90.prcp.lsegs$Aug, xlab = 'Longitude (deg W)', 
     ylab = 'Aug. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Aug ~ p90.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.sep.long.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_X, p90.prcp.lsegs$Sep, xlab = 'Longitude (deg W)', 
     ylab = 'Sep. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Sep ~ p90.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.oct.long.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_X, p90.prcp.lsegs$Oct, xlab = 'Longitude (deg W)', 
     ylab = 'Oct. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Oct ~ p90.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.nov.long.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_X, p90.prcp.lsegs$Nov, xlab = 'Longitude (deg W)', 
     ylab = 'Nov. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Nov ~ p90.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.dec.long.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_X, p90.prcp.lsegs$Dec, xlab = 'Longitude (deg W)', 
     ylab = 'Dec. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Dec ~ p90.prcp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()

png('p90.prcp.overall.lat.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_Y, p90.prcp.lsegs$Total, xlab = 'Latitude (deg N)', 
     ylab = 'Overall P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Total ~ p90.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.jan.lat.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_Y, p90.prcp.lsegs$Jan, xlab = 'Latitude (deg N)', 
     ylab = 'Jan. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Jan ~ p90.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.feb.lat.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_Y, p90.prcp.lsegs$Feb, xlab = 'Latitude (deg N)', 
     ylab = 'Feb. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Feb ~ p90.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.mar.lat.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_Y, p90.prcp.lsegs$Mar, xlab = 'Latitude (deg N)', 
     ylab = 'Mar. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Mar ~ p90.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.apr.lat.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_Y, p90.prcp.lsegs$Apr, xlab = 'Latitude (deg N)', 
     ylab = 'Apr. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Apr ~ p90.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.may.lat.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_Y, p90.prcp.lsegs$May, xlab = 'Latitude (deg N)', 
     ylab = 'May P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$May ~ p90.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.jun.lat.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_Y, p90.prcp.lsegs$Jun, xlab = 'Latitude (deg N)', 
     ylab = 'Jun. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Jun ~ p90.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.jul.lat.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_Y, p90.prcp.lsegs$Jul, xlab = 'Latitude (deg N)', 
     ylab = 'Jul. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Jul ~ p90.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.aug.lat.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_Y, p90.prcp.lsegs$Aug, xlab = 'Latitude (deg N)', 
     ylab = 'Aug. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Aug ~ p90.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.sep.lat.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_Y, p90.prcp.lsegs$Sep, xlab = 'Latitude (deg N)', 
     ylab = 'Sep. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Sep ~ p90.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.oct.lat.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_Y, p90.prcp.lsegs$Oct, xlab = 'Latitude (deg N)', 
     ylab = 'Oct. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Oct ~ p90.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.nov.lat.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_Y, p90.prcp.lsegs$Nov, xlab = 'Latitude (deg N)', 
     ylab = 'Nov. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Nov ~ p90.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.prcp.dec.lat.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_Y, p90.prcp.lsegs$Dec, xlab = 'Latitude (deg N)', 
     ylab = 'Dec. P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Dec ~ p90.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()

#p90 temp mapping:
p90.temp.lsegs <- lsegs
p90.temp.lsegs@data <- merge(x = p90.temp.lsegs@data, y = TEMP.ENS.90.PCT, by = 'FIPS_NHL', all.x = TRUE)
p90.temp.lsegs$`Overall P90 Temperature Change` <- p90.temp.lsegs$Total
png('p90.temp.overall.map.png', width = 800, height = 600)
qtm(p90.temp.lsegs, fill = 'Overall P90 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.temp.lsegs$`Jan. P90 Temperature Change` <- p90.temp.lsegs$Jan
png('p90.temp.jan.map.png', width = 800, height = 600)
qtm(p90.temp.lsegs, fill = 'Jan. P90 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.temp.lsegs$`Feb. P90 Temperature Change` <- p90.temp.lsegs$Feb
png('p90.temp.feb.map.png', width = 800, height = 600)
qtm(p90.temp.lsegs, fill = 'Feb. P90 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.temp.lsegs$`Mar. P90 Temperature Change` <- p90.temp.lsegs$Mar
png('p90.temp.mar.map.png', width = 800, height = 600)
qtm(p90.temp.lsegs, fill = 'Mar. P90 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.temp.lsegs$`Apr. P90 Temperature Change` <- p90.temp.lsegs$Apr
png('p90.temp.apr.map.png', width = 800, height = 600)
qtm(p90.temp.lsegs, fill = 'Apr. P90 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.temp.lsegs$`May P90 Temperature Change` <- p90.temp.lsegs$May
png('p90.temp.may.map.png', width = 800, height = 600)
qtm(p90.temp.lsegs, fill = 'May P90 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.temp.lsegs$`Jun. P90 Temperature Change` <- p90.temp.lsegs$Jun
png('p90.temp.jun.map.png', width = 800, height = 600)
qtm(p90.temp.lsegs, fill = 'Jun. P90 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.temp.lsegs$`Jul. P90 Temperature Change` <- p90.temp.lsegs$Jul
png('p90.temp.jul.map.png', width = 800, height = 600)
qtm(p90.temp.lsegs, fill = 'Jul. P90 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.temp.lsegs$`Aug. P90 Temperature Change` <- p90.temp.lsegs$Aug
png('p90.temp.aug.map.png', width = 800, height = 600)
qtm(p90.temp.lsegs, fill = 'Aug. P90 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.temp.lsegs$`Sep. P90 Temperature Change` <- p90.temp.lsegs$Sep
png('p90.temp.sep.map.png', width = 800, height = 600)
qtm(p90.temp.lsegs, fill = 'Sep. P90 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.temp.lsegs$`Oct. P90 Temperature Change` <- p90.temp.lsegs$Oct
png('p90.temp.oct.map.png', width = 800, height = 600)
qtm(p90.temp.lsegs, fill = 'Oct. P90 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.temp.lsegs$`Nov. P90 Temperature Change` <- p90.temp.lsegs$Nov
png('p90.temp.nov.map.png', width = 800, height = 600)
qtm(p90.temp.lsegs, fill = 'Nov. P90 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
p90.temp.lsegs$`Dec. P90 Temperature Change` <- p90.temp.lsegs$Dec
png('p90.temp.dec.map.png', width = 800, height = 600)
qtm(p90.temp.lsegs, fill = 'Dec. P90 Temperature Change', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()

png('p90.temp.overall.long.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_X, p90.temp.lsegs$Total, xlab = 'Longitude (deg W)', 
     ylab = 'Overall P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Total ~ p90.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.jan.long.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_X, p90.temp.lsegs$Jan, xlab = 'Longitude (deg W)', 
     ylab = 'Jan. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Jan ~ p90.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.feb.long.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_X, p90.temp.lsegs$Feb, xlab = 'Longitude (deg W)', 
     ylab = 'Feb. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Feb ~ p90.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.mar.long.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_X, p90.temp.lsegs$Mar, xlab = 'Longitude (deg W)', 
     ylab = 'Mar. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Mar ~ p90.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.apr.long.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_X, p90.temp.lsegs$Apr, xlab = 'Longitude (deg W)', 
     ylab = 'Apr. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Apr ~ p90.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.may.long.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_X, p90.temp.lsegs$May, xlab = 'Longitude (deg W)', 
     ylab = 'May P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$May ~ p90.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.jun.long.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_X, p90.temp.lsegs$Jun, xlab = 'Longitude (deg W)', 
     ylab = 'Jun. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Jun ~ p90.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.jul.long.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_X, p90.temp.lsegs$Jul, xlab = 'Longitude (deg W)', 
     ylab = 'Jul. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Jul ~ p90.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.aug.long.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_X, p90.temp.lsegs$Aug, xlab = 'Longitude (deg W)', 
     ylab = 'Aug. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Aug ~ p90.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.sep.long.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_X, p90.temp.lsegs$Sep, xlab = 'Longitude (deg W)', 
     ylab = 'Sep. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Sep ~ p90.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.oct.long.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_X, p90.temp.lsegs$Oct, xlab = 'Longitude (deg W)', 
     ylab = 'Oct. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Oct ~ p90.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.nov.long.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_X, p90.temp.lsegs$Nov, xlab = 'Longitude (deg W)', 
     ylab = 'Nov. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Nov ~ p90.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.dec.long.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_X, p90.temp.lsegs$Dec, xlab = 'Longitude (deg W)', 
     ylab = 'Dec. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Dec ~ p90.temp.lsegs$CENTROID_X), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()

png('p90.temp.overall.lat.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_Y, p90.temp.lsegs$Total, xlab = 'Latitude (deg N)', 
     ylab = 'Overall P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Total ~ p90.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.jan.lat.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_Y, p90.temp.lsegs$Jan, xlab = 'Latitude (deg N)', 
     ylab = 'Jan. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Jan ~ p90.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.feb.lat.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_Y, p90.temp.lsegs$Feb, xlab = 'Latitude (deg N)', 
     ylab = 'Feb. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Feb ~ p90.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.mar.lat.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_Y, p90.temp.lsegs$Mar, xlab = 'Latitude (deg N)', 
     ylab = 'Mar. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Mar ~ p90.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.apr.lat.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_Y, p90.temp.lsegs$Apr, xlab = 'Latitude (deg N)', 
     ylab = 'Apr. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Apr ~ p90.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.may.lat.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_Y, p90.temp.lsegs$May, xlab = 'Latitude (deg N)', 
     ylab = 'May P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$May ~ p90.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.jun.lat.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_Y, p90.temp.lsegs$Jun, xlab = 'Latitude (deg N)', 
     ylab = 'Jun. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Jun ~ p90.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.jul.lat.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_Y, p90.temp.lsegs$Jul, xlab = 'Latitude (deg N)', 
     ylab = 'Jul. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Jul ~ p90.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.aug.lat.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_Y, p90.temp.lsegs$Aug, xlab = 'Latitude (deg N)', 
     ylab = 'Aug. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Aug ~ p90.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.sep.lat.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_Y, p90.temp.lsegs$Sep, xlab = 'Latitude (deg N)', 
     ylab = 'Sep. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Sep ~ p90.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.oct.lat.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_Y, p90.temp.lsegs$Oct, xlab = 'Latitude (deg N)', 
     ylab = 'Oct. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Oct ~ p90.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.nov.lat.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_Y, p90.temp.lsegs$Nov, xlab = 'Latitude (deg N)', 
     ylab = 'Nov. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Nov ~ p90.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()
png('p90.temp.dec.lat.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_Y, p90.temp.lsegs$Dec, xlab = 'Latitude (deg N)', 
     ylab = 'Dec. P90 Temperature Change (%)')
abline(fit <- lm(p90.temp.lsegs$Dec ~ p90.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
dev.off()

# GGMAP ATTEMPT
# p10.prcp.lsegs.df <- tidy(p10.prcp.lsegs)
# ggplot() +
#   geom_polygon(data = p10.prcp.lsegs.df, aes(x = long, y = lat, group = group))+
#   geom_path(data = p10.prcp.lsegs.df, aes(x = long, y = lat, group = group))
# 
# ggplot(p10.prcp.lsegs) +
#   aes(x = long, y = lat, group = group, color = data$Total) +
#   # scale_fill_gradient(scale_name = 'test', low = 'white', high = 'red', values = 'Total')
#   geom_polygon() +
#   geom_path(mapping = NULL) +
#   coord_equal()

library(rgdal)
library(ggplot2)
library(dplyr)

if (va.or.cbw == 'va') {
  lsegs <- readOGR(lseg.loc, 'P6_LSegs_VA')
} else if (va.or.cbw == 'cbw') {
  lsegs <- readOGR(lseg.loc, 'P6_LSegs')
} else {
  print(paste('ERROR: Neither VA nor CBW selected'))
}

lsegs <- spTransform(lsegs, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

lsegs@data$id <- rownames(lsegs@data)

lsegs.df <- fortify(lsegs)

# map + geom_path() # outline of shape
# 
# map + 
#   geom_polygon(aes(fill = id)) #filled

lsegs.df <- merge(lsegs.df, lsegs@data, by = 'id')

# NEEDS DOING FOR P10, P50, P90 AND PRCP/EVAP
lsegs.df <- merge(lsegs.df, PRCP.ENS.10.PCT, by = 'FIPS_NHL')
map <- ggplot(data = lsegs.df, aes(x = long, y = lat, group = group))

# INDIVIDUAL METRIC MAP
map + 
  geom_polygon(aes(fill = Total), color = 'gray', size = 0.1) +
  coord_fixed(1.3)

