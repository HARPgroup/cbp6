basepath <- '/var/www/R'
source(paste(basepath,"config.local.private", sep = "/"))
data.location <- paste0(cbp6_location, '\\Data\\CBP6_Temp_Prcp_Data')
va.or.cbw <- 'va'

# CREATING DIRECTORY TO STORE DATA AND OUTPUTS
dir.create('~/Precip_and_Temp_Mapper')
dir.location <- '~/Precip_and_Temp_Mapper'
setwd('/var/www/R')

if (va.or.cbw == 'va') {
  lseg.loc <- paste0(data.location, '\\P6_LSegs_VA')
} else if (va.or.cbw == 'cbw') {
  lseg.loc <- paste0(data.location, '\\P6_LSegs')
} else {
  print(paste('ERROR: Neither VA nor CBW selected'))
}

# LOADING DATA -----
land.seg.info <- read.csv(paste0(data.location, '\\Land_Segment_CBWatershed_Area.csv'), header = FALSE)
colnames(land.seg.info) <- c('landseg', 'state', 'county', 'area?')
if (va.or.cbw == 'va') {
  land.seg.info <- land.seg.info[land.seg.info$state == 'VA',]
}

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

# USING LOCALLY STORED, MANUALLY CREATED LAND-SEG GIS LAYER
library(rgdal)

if (va.or.cbw == 'va') {
  lsegs <- readOGR(lseg.loc, 'P6_LSegs_VA')
} else if (va.or.cbw == 'cbw') {
  lsegs <- readOGR(lseg.loc, 'P6_LSegs')
} else {
  print(paste('ERROR: Neither VA nor CBW selected'))
}

# Linking model names
landseg.ens.prcp.data <- data.frame(matrix(NA, nrow = 31, ncol = 15))

colnames(landseg.ens.prcp.data) <- colnames(PRCP.ENS.50.PCT)

model.name.10 <- data.frame(matrix(NA, nrow = length(land.seg.info$landseg), ncol = 2))
colnames(model.name.10) <- c('Land Segment', 'Model')
model.name.10$`Land Segment` <- land.seg.info$landseg

model.name.50 <- data.frame(matrix(NA, nrow = length(land.seg.info$landseg), ncol = 2))
colnames(model.name.50) <- c('Land Segment', 'Model')
model.name.50$`Land Segment` <- land.seg.info$landseg

model.name.90 <- data.frame(matrix(NA, nrow = length(land.seg.info$landseg), ncol = 2))
colnames(model.name.90) <- c('Land Segment', 'Model')
model.name.90$`Land Segment` <- land.seg.info$landseg

for (i2 in 1:length(land.seg.info$landseg)) {
  land.seg <- as.character(land.seg.info$landseg[i2])
  
  for (i in 1:31) {
    tmp.prcp.namer <- paste0('prcp.ens.mod.', i)
    tmp.prcp.data <- get(tmp.prcp.namer)
    tmp.prcp.landseg.ens.data <- tmp.prcp.data[which(tmp.prcp.data$FIPS_NHL == land.seg),]
    landseg.ens.prcp.data[i,] <- tmp.prcp.landseg.ens.data[]
  }
  
  landseg.quant.precip.data <- data.frame(matrix(NA, nrow = 3, ncol = 15))
  colnames(landseg.quant.precip.data) <- colnames(PRCP.ENS.50.PCT)
  landseg.quant.precip.data[1,] <- PRCP.ENS.10.PCT[which(PRCP.ENS.10.PCT$FIPS_NHL == land.seg),]
  landseg.quant.precip.data[2,] <- PRCP.ENS.50.PCT[which(PRCP.ENS.50.PCT$FIPS_NHL == land.seg),]
  landseg.quant.precip.data[3,] <- PRCP.ENS.90.PCT[which(PRCP.ENS.90.PCT$FIPS_NHL == land.seg),]
  
  # Linking model quantile outputs to their respective models
  prcp.10.mod.num <- as.numeric(which(landseg.ens.prcp.data$Total == quantile(landseg.ens.prcp.data$Total, 0.10)))
  prcp.50.mod.num <- as.numeric(which(landseg.ens.prcp.data$Total == quantile(landseg.ens.prcp.data$Total, 0.50)))
  prcp.90.mod.num <- as.numeric(which(landseg.ens.prcp.data$Total == quantile(landseg.ens.prcp.data$Total, 0.90)))
  
  model.name.10$Model[i2] <- mod.names[prcp.10.mod.num]
  model.name.50$Model[i2] <- mod.names[prcp.50.mod.num]
  model.name.90$Model[i2] <- mod.names[prcp.90.mod.num]
}

PRCP.ENS.10.PCT <- merge(PRCP.ENS.10.PCT, model.name.10, by.x = 'FIPS_NHL', by.y = 'Land Segment')
PRCP.ENS.50.PCT <- merge(PRCP.ENS.50.PCT, model.name.50, by.x = 'FIPS_NHL', by.y = 'Land Segment')
PRCP.ENS.90.PCT <- merge(PRCP.ENS.90.PCT, model.name.90, by.x = 'FIPS_NHL', by.y = 'Land Segment')


library(randomcoloR)
cols <- distinctColorPalette(k = length(unique(PRCP.ENS.10.PCT$Model)), altCol = FALSE, runTsne = FALSE)
mods <- unique(PRCP.ENS.10.PCT$Model)
modcols <- data.frame(cols, mods)

PRCP.ENS.10.PCT$Colors <- NA

for (i in 1:length(PRCP.ENS.10.PCT$Model)) {
  test <- as.character(modcols$cols[which(as.character(modcols$mods) == as.character(PRCP.ENS.10.PCT$Model[i]))])
  PRCP.ENS.10.PCT$Colors[i] <- test
}

#p10 precip mapping:
p10.prcp.lsegs <- lsegs
p10.prcp.lsegs@data <- merge(x = p10.prcp.lsegs@data, y = PRCP.ENS.10.PCT, by = 'FIPS_NHL', all.x = TRUE)
png('p10.prcp.overall.lat.png', width = 800, height = 600)
plot(p10.prcp.lsegs$CENTROID_Y, p10.prcp.lsegs$Total, col = p10.prcp.lsegs$Colors, pch = 19, xlab = 'Latitude (deg N)', 
     ylab = 'Overall P10 Precipitation Change (%)')
abline(fit <- lm(p10.prcp.lsegs$Total ~ p10.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
legend('bottomright', legend = unique(p10.prcp.lsegs$Model), fill = unique(p10.prcp.lsegs$Colors))
dev.off()

# P50
cols <- distinctColorPalette(k = length(unique(PRCP.ENS.50.PCT$Model)), altCol = FALSE, runTsne = FALSE)
mods <- unique(PRCP.ENS.50.PCT$Model)
modcols <- data.frame(cols, mods)

PRCP.ENS.50.PCT$Colors <- NA

for (i in 1:length(PRCP.ENS.50.PCT$Model)) {
  test <- as.character(modcols$cols[which(as.character(modcols$mods) == as.character(PRCP.ENS.50.PCT$Model[i]))])
  PRCP.ENS.50.PCT$Colors[i] <- test
}

#p50 precip mapping:
p50.prcp.lsegs <- lsegs
p50.prcp.lsegs@data <- merge(x = p50.prcp.lsegs@data, y = PRCP.ENS.50.PCT, by = 'FIPS_NHL', all.x = TRUE)
png('p50.prcp.overall.lat.png', width = 800, height = 600)
plot(p50.prcp.lsegs$CENTROID_Y, p50.prcp.lsegs$Total, col = p50.prcp.lsegs$Colors, pch = 19, xlab = 'Latitude (deg N)', 
     ylab = 'Overall P50 Precipitation Change (%)')
abline(fit <- lm(p50.prcp.lsegs$Total ~ p50.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
legend('bottomright', legend = unique(p50.prcp.lsegs$Model), fill = unique(p50.prcp.lsegs$Colors))
dev.off()

# P90
cols <- distinctColorPalette(k = length(unique(PRCP.ENS.90.PCT$Model)), altCol = FALSE, runTsne = FALSE)
mods <- unique(PRCP.ENS.90.PCT$Model)
modcols <- data.frame(cols, mods)

PRCP.ENS.90.PCT$Colors <- NA

for (i in 1:length(PRCP.ENS.90.PCT$Model)) {
  test <- as.character(modcols$cols[which(as.character(modcols$mods) == as.character(PRCP.ENS.90.PCT$Model[i]))])
  PRCP.ENS.90.PCT$Colors[i] <- test
}

#p90 precip mapping:
p90.prcp.lsegs <- lsegs
p90.prcp.lsegs@data <- merge(x = p90.prcp.lsegs@data, y = PRCP.ENS.90.PCT, by = 'FIPS_NHL', all.x = TRUE)
png('p90.prcp.overall.lat.png', width = 800, height = 600)
plot(p90.prcp.lsegs$CENTROID_Y, p90.prcp.lsegs$Total, col = p90.prcp.lsegs$Colors, pch = 19, xlab = 'Latitude (deg N)', 
     ylab = 'Overall P90 Precipitation Change (%)')
abline(fit <- lm(p90.prcp.lsegs$Total ~ p90.prcp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
legend('bottomright', legend = unique(p90.prcp.lsegs$Model), fill = unique(p90.prcp.lsegs$Colors))
dev.off()

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

# USING LOCALLY STORED, MANUALLY CREATED LAND-SEG GIS LAYER
library(rgdal)

if (va.or.cbw == 'va') {
  lsegs <- readOGR(lseg.loc, 'P6_LSegs_VA')
} else if (va.or.cbw == 'cbw') {
  lsegs <- readOGR(lseg.loc, 'P6_LSegs')
} else {
  print(paste('ERROR: Neither VA nor CBW selected'))
}

# Linking model names
landseg.ens.temp.data <- data.frame(matrix(NA, nrow = 31, ncol = 15))

colnames(landseg.ens.temp.data) <- colnames(TEMP.ENS.50.PCT)

model.name.10 <- data.frame(matrix(NA, nrow = length(land.seg.info$landseg), ncol = 2))
colnames(model.name.10) <- c('Land Segment', 'Model')
model.name.10$`Land Segment` <- land.seg.info$landseg

model.name.50 <- data.frame(matrix(NA, nrow = length(land.seg.info$landseg), ncol = 2))
colnames(model.name.50) <- c('Land Segment', 'Model')
model.name.50$`Land Segment` <- land.seg.info$landseg

model.name.90 <- data.frame(matrix(NA, nrow = length(land.seg.info$landseg), ncol = 2))
colnames(model.name.90) <- c('Land Segment', 'Model')
model.name.90$`Land Segment` <- land.seg.info$landseg

for (i2 in 1:length(land.seg.info$landseg)) {
  land.seg <- as.character(land.seg.info$landseg[i2])
  
  for (i in 1:31) {
    tmp.temp.namer <- paste0('temp.ens.mod.', i)
    tmp.temp.data <- get(tmp.temp.namer)
    tmp.temp.landseg.ens.data <- tmp.temp.data[which(tmp.temp.data$FIPS_NHL == land.seg),]
    landseg.ens.temp.data[i,] <- tmp.temp.landseg.ens.data[]
  }
  
  landseg.quant.temp.data <- data.frame(matrix(NA, nrow = 3, ncol = 15))
  colnames(landseg.quant.temp.data) <- colnames(TEMP.ENS.50.PCT)
  landseg.quant.temp.data[1,] <- TEMP.ENS.10.PCT[which(TEMP.ENS.10.PCT$FIPS_NHL == land.seg),]
  landseg.quant.temp.data[2,] <- TEMP.ENS.50.PCT[which(TEMP.ENS.50.PCT$FIPS_NHL == land.seg),]
  landseg.quant.temp.data[3,] <- TEMP.ENS.90.PCT[which(TEMP.ENS.90.PCT$FIPS_NHL == land.seg),]
  
  # Linking model quantile outputs to their respective models
  temp.10.mod.num <- as.numeric(which(landseg.ens.temp.data$Total == quantile(landseg.ens.temp.data$Total, 0.10)))
  temp.50.mod.num <- as.numeric(which(landseg.ens.temp.data$Total == quantile(landseg.ens.temp.data$Total, 0.50)))
  temp.90.mod.num <- as.numeric(which(landseg.ens.temp.data$Total == quantile(landseg.ens.temp.data$Total, 0.90)))
  
  model.name.10$Model[i2] <- mod.names[temp.10.mod.num]
  model.name.50$Model[i2] <- mod.names[temp.50.mod.num]
  model.name.90$Model[i2] <- mod.names[temp.90.mod.num]
}

TEMP.ENS.10.PCT <- merge(TEMP.ENS.10.PCT, model.name.10, by.x = 'FIPS_NHL', by.y = 'Land Segment')
TEMP.ENS.50.PCT <- merge(TEMP.ENS.50.PCT, model.name.50, by.x = 'FIPS_NHL', by.y = 'Land Segment')
TEMP.ENS.90.PCT <- merge(TEMP.ENS.90.PCT, model.name.90, by.x = 'FIPS_NHL', by.y = 'Land Segment')


library(randomcoloR)
cols <- distinctColorPalette(k = length(unique(TEMP.ENS.10.PCT$Model)), altCol = FALSE, runTsne = FALSE)
mods <- unique(TEMP.ENS.10.PCT$Model)
modcols <- data.frame(cols, mods)

TEMP.ENS.10.PCT$Colors <- NA

for (i in 1:length(TEMP.ENS.10.PCT$Model)) {
  test <- as.character(modcols$cols[which(as.character(modcols$mods) == as.character(TEMP.ENS.10.PCT$Model[i]))])
  TEMP.ENS.10.PCT$Colors[i] <- test
}

#p10 temp mapping:
p10.temp.lsegs <- lsegs
p10.temp.lsegs@data <- merge(x = p10.temp.lsegs@data, y = TEMP.ENS.10.PCT, by = 'FIPS_NHL', all.x = TRUE)
png('p10.temp.overall.lat2.png', width = 800, height = 600)
plot(p10.temp.lsegs$CENTROID_Y, p10.temp.lsegs$Total, col = p10.temp.lsegs$Colors, pch = 19, xlab = 'Latitude (deg N)', 
     ylab = 'Overall P10 Temperature Change (deg. C)')
abline(fit <- lm(p10.temp.lsegs$Total ~ p10.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
legend('bottomright', legend = unique(p10.temp.lsegs$Model), fill = unique(p10.temp.lsegs$Colors))
dev.off()

# P50
cols <- distinctColorPalette(k = length(unique(TEMP.ENS.50.PCT$Model)), altCol = FALSE, runTsne = FALSE)
mods <- unique(TEMP.ENS.50.PCT$Model)
modcols <- data.frame(cols, mods)

TEMP.ENS.50.PCT$Colors <- NA

for (i in 1:length(TEMP.ENS.50.PCT$Model)) {
  test <- as.character(modcols$cols[which(as.character(modcols$mods) == as.character(TEMP.ENS.50.PCT$Model[i]))])
  TEMP.ENS.50.PCT$Colors[i] <- test
}

#p50 temp mapping:
p50.temp.lsegs <- lsegs
p50.temp.lsegs@data <- merge(x = p50.temp.lsegs@data, y = TEMP.ENS.50.PCT, by = 'FIPS_NHL', all.x = TRUE)
png('p50.temp.overall.lat2.png', width = 800, height = 600)
plot(p50.temp.lsegs$CENTROID_Y, p50.temp.lsegs$Total, col = p50.temp.lsegs$Colors, pch = 19, xlab = 'Latitude (deg N)', 
     ylab = 'Overall P50 Temperature Change (deg. C)')
abline(fit <- lm(p50.temp.lsegs$Total ~ p50.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
legend('bottomright', legend = unique(p50.temp.lsegs$Model), fill = unique(p50.temp.lsegs$Colors))
dev.off()

# P90
cols <- distinctColorPalette(k = length(unique(TEMP.ENS.90.PCT$Model)), altCol = FALSE, runTsne = FALSE)
mods <- unique(TEMP.ENS.90.PCT$Model)
modcols <- data.frame(cols, mods)

TEMP.ENS.90.PCT$Colors <- NA

for (i in 1:length(TEMP.ENS.90.PCT$Model)) {
  test <- as.character(modcols$cols[which(as.character(modcols$mods) == as.character(TEMP.ENS.90.PCT$Model[i]))])
  TEMP.ENS.90.PCT$Colors[i] <- test
}

#p90 temp mapping:
p90.temp.lsegs <- lsegs
p90.temp.lsegs@data <- merge(x = p90.temp.lsegs@data, y = TEMP.ENS.90.PCT, by = 'FIPS_NHL', all.x = TRUE)
png('p90.temp.overall.lat2.png', width = 800, height = 600)
plot(p90.temp.lsegs$CENTROID_Y, p90.temp.lsegs$Total, col = p90.temp.lsegs$Colors, pch = 19, xlab = 'Latitude (deg N)', 
     ylab = 'Overall P90 Temperature Change (deg. C)')
abline(fit <- lm(p90.temp.lsegs$Total ~ p90.temp.lsegs$CENTROID_Y), col = 'red')
legend('topleft', bty = 'n', legend = paste('Rsq =', format(summary(fit)$adj.r.squared, digits = 3)))
legend('bottomright', legend = unique(p90.temp.lsegs$Model), fill = unique(p90.temp.lsegs$Colors))
dev.off()