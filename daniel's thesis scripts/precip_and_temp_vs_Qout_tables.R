# Creates output .csv files describing GCM precipitation and temperature as well as climate change 
# scenario precipitation, evapotranspiration, and flow quantity/change from baseline scenario.

basepath <- '/var/www/R'
source(paste(basepath,"config.local.private", sep = "/"))
source(paste0(cbp6_location,"/code/cbp6_functions.R"))
source(paste0(github_location, "/auth.private"));
source(paste(cbp6_location, "/code/fn_vahydro-1.0.R", sep = ''))
site <- "http://deq2.bse.vt.edu/d.dh"
token <- rest_token(site, token, rest_uname, rest_pw)

# CREATING DIRECTORY TO STORE DATA AND OUTPUTS
dir.create('~/Precip_and_Temp_Mapper')
dir.location <- '~/Precip_and_Temp_Mapper'
setwd(dir.location)

data.location <- paste0(cbp6_location, '\\Data\\CBP6_Temp_Prcp_Data')
lseg.loc <- paste0(data.location, '\\P6_LSegs_VA')
rseg.loc <- paste0(data.location, '\\P6_RSegs_VA')

PRCP.ENS.10.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_Ensemble_CRT_2041_2070_P10.csv'), nrows = 244)
PRCP.ENS.50.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_Ensemble_CRT_2041_2070_P50.csv'), nrows = 244)
PRCP.ENS.90.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Precipitation\\lseg_delta_pr_RCP45_Ensemble_CRT_2041_2070_P90.csv'), nrows = 244)
TEMP.ENS.10.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_Ensemble_CRT_2041_2070_P10.csv'), nrows = 244)
TEMP.ENS.50.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_Ensemble_CRT_2041_2070_P50.csv'), nrows = 244)
TEMP.ENS.90.PCT <- read.csv(paste0(data.location, '\\20121220_CC_Delta\\Temperature\\lseg_delta_tas_RCP45_Ensemble_CRT_2041_2070_P90.csv'), nrows = 244)

dat.climate.base <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/N20150521J96_and_PRC20170731/evap.prcp.table.csv')
dat.climate.base <- dat.climate.base[,-1]
dat.climate.10 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/5545HS10CA2_and_55R45KK1095/evap.prcp.table.csv')
dat.climate.10 <- dat.climate.10[,-1]
dat.climate.50 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/5545HS50CA2_and_5545KK50AA/evap.prcp.table.csv')
dat.climate.50 <- dat.climate.50[,-1]
dat.climate.90 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/5545HS90CA2_and_55R45KK9095/evap.prcp.table.csv')
dat.climate.90 <- dat.climate.90[,-1]

library(rgdal)
lsegs <- readOGR(lseg.loc, 'P6_LSegs_VA')
rsegs <- readOGR(rseg.loc, 'P6_RSegs_VA')

library(RCurl)
download.file('ftp://ftp.chesapeakebay.net/gis/ModelingP6/P6Beta_v3_LRSegs_081516.zip', destfile = paste0(dir.location, 'P6_LRSegs.zip'))
unzip(zipfile = paste0(dir.location, 'P6_LRSegs.zip'), overwrite = TRUE, exdir = 'P6_LRSegs')

lrsegs <- readOGR(paste0(dir.location, '\\P6_LRSegs'), 'P6Beta_v3_LRSegs_081516')

rseg.info.10 <- data.frame(matrix(data = NA, nrow = length(rsegs@data$RiverSeg), ncol = 12))
colnames(rseg.info.10) = c('River Segment', 'Prcp. Change', 'Temp. Change', 'Flow Change', 'Runid 11 Qout', 'Runid 15 Qout', 'Prcp. Change (VA Hydro)', 'Base Scen. Prcp', 'CC Scen. Prcp', 'Evap. Change (VA Hydro)', 'Base Scen. Evap', 'CC Scen. Evap')
rseg.info.10$`River Segment` <- rsegs@data$RiverSeg
rseg.info.50 <- data.frame(matrix(data = NA, nrow = length(rsegs@data$RiverSeg), ncol = 12))
colnames(rseg.info.50) = c('River Segment', 'Prcp. Change', 'Temp. Change', 'Flow Change', 'Runid 11 Qout', 'Runid 14 Qout', 'Prcp. Change (VA Hydro)', 'Base Scen. Prcp', 'CC Scen. Prcp', 'Evap. Change (VA Hydro)', 'Base Scen. Evap', 'CC Scen. Evap')
rseg.info.50$`River Segment` <- rsegs@data$RiverSeg
rseg.info.90 <- data.frame(matrix(data = NA, nrow = length(rsegs@data$RiverSeg), ncol = 12))
colnames(rseg.info.90) = c('River Segment', 'Prcp. Change', 'Temp. Change', 'Flow Change', 'Runid 11 Qout', 'Runid 16 Qout', 'Prcp. Change (VA Hydro)', 'Base Scen. Prcp', 'CC Scen. Prcp', 'Evap. Change (VA Hydro)', 'Base Scen. Evap', 'CC Scen. Evap')
rseg.info.90$`River Segment` <- rsegs@data$RiverSeg

for (i in 1:length(rsegs@data$RiverSeg)) {
  lrseg.nums <- which(lrsegs@data$RiverSeg == as.character(rsegs@data$RiverSeg[i]))
  lrseg.areas <- as.numeric(lrsegs@data$Acres[lrseg.nums])
  lsegs.in.rseg <- as.character(lrsegs@data$FIPS_NHL[lrseg.nums])
  total.area <- sum(lrseg.areas)
  
  weighted.prcp.10 <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.prcp.50 <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.prcp.90 <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.temp.10 <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.temp.50 <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.temp.90 <- vector(mode = 'numeric', length = length(lrseg.nums))
  
  weighted.prcp.base.vahydro <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.prcp.10.vahydro <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.prcp.50.vahydro <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.prcp.90.vahydro <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.evap.base.vahydro <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.evap.10.vahydro <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.evap.50.vahydro <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.evap.90.vahydro <- vector(mode = 'numeric', length = length(lrseg.nums))
  
  for (j in 1:length(lrseg.nums)) {
    lseg <- as.character(lsegs.in.rseg[j])
    
    lseg.prcp.10 <- PRCP.ENS.10.PCT$Total[which(PRCP.ENS.10.PCT$FIPS_NHL == lseg)]
    lseg.prcp.50 <- PRCP.ENS.50.PCT$Total[which(PRCP.ENS.50.PCT$FIPS_NHL == lseg)]
    lseg.prcp.90 <- PRCP.ENS.90.PCT$Total[which(PRCP.ENS.90.PCT$FIPS_NHL == lseg)]
    lseg.temp.10 <- TEMP.ENS.10.PCT$Total[which(TEMP.ENS.10.PCT$FIPS_NHL == lseg)]
    lseg.temp.50 <- TEMP.ENS.50.PCT$Total[which(TEMP.ENS.50.PCT$FIPS_NHL == lseg)]
    lseg.temp.90 <- TEMP.ENS.90.PCT$Total[which(TEMP.ENS.90.PCT$FIPS_NHL == lseg)]
    
    lseg.prcp.base.vahydro <- dat.climate.base$prcp.mean[which(dat.climate.base$segment == lseg)]    
    lseg.prcp.10.vahydro <- dat.climate.10$prcp.mean[which(dat.climate.10$segment == lseg)]
    lseg.prcp.50.vahydro <- dat.climate.50$prcp.mean[which(dat.climate.50$segment == lseg)]
    lseg.prcp.90.vahydro <- dat.climate.90$prcp.mean[which(dat.climate.90$segment == lseg)]
    lseg.evap.base.vahydro <- dat.climate.base$evap.mean[which(dat.climate.base$segment == lseg)]    
    lseg.evap.10.vahydro <- dat.climate.10$evap.mean[which(dat.climate.10$segment == lseg)]
    lseg.evap.50.vahydro <- dat.climate.50$evap.mean[which(dat.climate.50$segment == lseg)]
    lseg.evap.90.vahydro <- dat.climate.90$evap.mean[which(dat.climate.90$segment == lseg)]
    
    if(length(lseg.prcp.base.vahydro) == 0) {lseg.prcp.base.vahydro <- NA}
    if(length(lseg.prcp.10.vahydro) == 0) {lseg.prcp.10.vahydro <- NA}
    if(length(lseg.prcp.50.vahydro) == 0) {lseg.prcp.50.vahydro <- NA}
    if(length(lseg.prcp.90.vahydro) == 0) {lseg.prcp.90.vahydro <- NA}
    if(length(lseg.evap.base.vahydro) == 0) {lseg.evap.base.vahydro <- NA}
    if(length(lseg.evap.10.vahydro) == 0) {lseg.evap.10.vahydro <- NA}
    if(length(lseg.evap.50.vahydro) == 0) {lseg.evap.50.vahydro <- NA}
    if(length(lseg.evap.90.vahydro) == 0) {lseg.evap.90.vahydro <- NA}
    
    fraction.of.area <- lrseg.areas[j]/total.area
    
    weighted.prcp.10[j] <- lseg.prcp.10*fraction.of.area
    weighted.prcp.50[j] <- lseg.prcp.50*fraction.of.area
    weighted.prcp.90[j] <- lseg.prcp.90*fraction.of.area
    weighted.temp.10[j] <- lseg.temp.10*fraction.of.area
    weighted.temp.50[j] <- lseg.temp.50*fraction.of.area
    weighted.temp.90[j] <- lseg.temp.90*fraction.of.area
    weighted.prcp.base.vahydro[j] <- lseg.prcp.base.vahydro*fraction.of.area
    weighted.prcp.10.vahydro[j] <- lseg.prcp.10.vahydro*fraction.of.area
    weighted.prcp.50.vahydro[j] <- lseg.prcp.50.vahydro*fraction.of.area
    weighted.prcp.90.vahydro[j] <- lseg.prcp.90.vahydro*fraction.of.area
    weighted.evap.base.vahydro[j] <- lseg.evap.base.vahydro*fraction.of.area
    weighted.evap.10.vahydro[j] <- lseg.evap.10.vahydro*fraction.of.area
    weighted.evap.50.vahydro[j] <- lseg.evap.50.vahydro*fraction.of.area
    weighted.evap.90.vahydro[j] <- lseg.evap.90.vahydro*fraction.of.area
    
    rm(lseg, lseg.prcp.10, lseg.prcp.50, lseg.prcp.90, lseg.temp.10, lseg.temp.50, lseg.temp.90,
       fraction.of.area, lseg.prcp.base.vahydro, lseg.prcp.10.vahydro, lseg.prcp.50.vahydro,
       lseg.prcp.90.vahydro, lseg.evap.base.vahydro, lseg.evap.10.vahydro, lseg.evap.50.vahydro,
       lseg.evap.90.vahydro)
  }
  
  rseg.info.10$`Prcp. Change`[i] <- sum(weighted.prcp.10)
  rseg.info.50$`Prcp. Change`[i] <- sum(weighted.prcp.50)
  rseg.info.90$`Prcp. Change`[i] <- sum(weighted.prcp.90)
  rseg.info.10$`Temp. Change`[i] <- sum(weighted.temp.10)
  rseg.info.50$`Temp. Change`[i] <- sum(weighted.temp.50)
  rseg.info.90$`Temp. Change`[i] <- sum(weighted.temp.90)
  rseg.info.10$`Base Scen. Prcp`[i] <- sum(weighted.prcp.base.vahydro)
  rseg.info.50$`Base Scen. Prcp`[i] <- sum(weighted.prcp.base.vahydro)
  rseg.info.90$`Base Scen. Prcp`[i] <- sum(weighted.prcp.base.vahydro)
  rseg.info.10$`CC Scen. Prcp`[i] <- sum(weighted.prcp.10.vahydro)
  rseg.info.50$`CC Scen. Prcp`[i] <- sum(weighted.prcp.50.vahydro)
  rseg.info.90$`CC Scen. Prcp`[i] <- sum(weighted.prcp.90.vahydro)
  rseg.info.10$`Base Scen. Evap`[i] <- sum(weighted.evap.base.vahydro)
  rseg.info.50$`Base Scen. Evap`[i] <- sum(weighted.evap.base.vahydro)
  rseg.info.90$`Base Scen. Evap`[i] <- sum(weighted.evap.base.vahydro)
  rseg.info.10$`CC Scen. Evap`[i] <- sum(weighted.evap.10.vahydro)
  rseg.info.50$`CC Scen. Evap`[i] <- sum(weighted.evap.50.vahydro)
  rseg.info.90$`CC Scen. Evap`[i] <- sum(weighted.evap.90.vahydro)
  
  rm(weighted.prcp.10, weighted.prcp.50, weighted.prcp.90,
     weighted.temp.10, weighted.temp.50, weighted.temp.90,
     weighted.prcp.base.vahydro, weighted.prcp.10.vahydro,
     weighted.prcp.50.vahydro, weighted.prcp.90.vahydro,
     weighted.evap.base.vahydro, weighted.evap.10.vahydro,
     weighted.evap.50.vahydro, weighted.evap.90.vahydro)
  
  scen.prop.11 <- get.scen.prop(rsegs@data$RiverSeg[i], 'vahydro-1.0', 'vahydro', 11, '1984-01-01', '2014-12-31', site, token)
  scen.prop.14 <- get.scen.prop(rsegs@data$RiverSeg[i], 'vahydro-1.0', 'vahydro', 14, '1984-01-01', '2014-12-31', site, token)
  scen.prop.15 <- get.scen.prop(rsegs@data$RiverSeg[i], 'vahydro-1.0', 'vahydro', 15, '1984-01-01', '2014-12-31', site, token)
  scen.prop.16 <- get.scen.prop(rsegs@data$RiverSeg[i], 'vahydro-1.0', 'vahydro', 16, '1984-01-01', '2014-12-31', site, token)
  
  Qout_11 <- vahydro_import_om_class_constant_from_scenprop(scen.prop.11, 'om_class_Constant', '', 'Qout', site, token)
  Qout_14 <- vahydro_import_om_class_constant_from_scenprop(scen.prop.14, 'om_class_Constant', '', 'Qout', site, token)
  Qout_15 <- vahydro_import_om_class_constant_from_scenprop(scen.prop.15, 'om_class_Constant', '', 'Qout', site, token)
  Qout_16 <- vahydro_import_om_class_constant_from_scenprop(scen.prop.16, 'om_class_Constant', '', 'Qout', site, token)
  
  print(paste('Obtained VA Hydro run data for segment', i, 'of', length(rsegs@data$RiverSeg), sep = ' '))
  
  rseg.info.10$`Runid 11 Qout`[i] <- Qout_11
  rseg.info.50$`Runid 11 Qout`[i] <- Qout_11
  rseg.info.90$`Runid 11 Qout`[i] <- Qout_11
  rseg.info.10$`Runid 15 Qout`[i] <- Qout_15
  rseg.info.50$`Runid 14 Qout`[i] <- Qout_14
  rseg.info.90$`Runid 16 Qout`[i] <- Qout_16
  
  rm(scen.prop.11, scen.prop.14, scen.prop.15, scen.prop.16,
     Qout_11, Qout_14, Qout_15, Qout_16)
}

rseg.info.10$`Flow Change` <- (rseg.info.10$`Runid 15 Qout` - rseg.info.10$`Runid 11 Qout`) / rseg.info.10$`Runid 11 Qout` * 100
rseg.info.10$`Flow Change`[rseg.info.10$`Runid 15 Qout` == FALSE | rseg.info.10$`Runid 11 Qout` == FALSE] <- NA
rseg.info.10$`Prcp. Change (VA Hydro)` <- (rseg.info.10$`CC Scen. Prcp` - rseg.info.10$`Base Scen. Prcp`) / rseg.info.10$`Base Scen. Prcp` * 100
rseg.info.10$`Evap. Change (VA Hydro)` <- (rseg.info.10$`CC Scen. Evap` - rseg.info.10$`Base Scen. Evap`) / rseg.info.10$`Base Scen. Evap` * 100
rseg.info.50$`Flow Change` <- (rseg.info.50$`Runid 14 Qout` - rseg.info.50$`Runid 11 Qout`) / rseg.info.50$`Runid 11 Qout` * 100
rseg.info.50$`Flow Change`[rseg.info.50$`Runid 14 Qout` == FALSE | rseg.info.50$`Runid 11 Qout` == FALSE] <- NA
rseg.info.50$`Prcp. Change (VA Hydro)` <- (rseg.info.50$`CC Scen. Prcp` - rseg.info.50$`Base Scen. Prcp`) / rseg.info.50$`Base Scen. Prcp` * 100
rseg.info.50$`Evap. Change (VA Hydro)` <- (rseg.info.50$`CC Scen. Evap` - rseg.info.50$`Base Scen. Evap`) / rseg.info.50$`Base Scen. Evap` * 100
rseg.info.90$`Flow Change` <- (rseg.info.90$`Runid 16 Qout` - rseg.info.90$`Runid 11 Qout`) / rseg.info.90$`Runid 11 Qout` * 100
rseg.info.90$`Flow Change`[rseg.info.90$`Runid 16 Qout` == FALSE | rseg.info.90$`Runid 11 Qout` == FALSE] <- NA
rseg.info.90$`Prcp. Change (VA Hydro)` <- (rseg.info.90$`CC Scen. Prcp` - rseg.info.90$`Base Scen. Prcp`) / rseg.info.90$`Base Scen. Prcp` * 100
rseg.info.90$`Evap. Change (VA Hydro)` <- (rseg.info.90$`CC Scen. Evap` - rseg.info.90$`Base Scen. Evap`) / rseg.info.90$`Base Scen. Evap` * 100

rseg.info.10 <- rseg.info.10[which(is.na(rseg.info.10$`Flow Change`) == FALSE),]
rseg.info.50 <- rseg.info.50[which(is.na(rseg.info.50$`Flow Change`) == FALSE),]
rseg.info.90 <- rseg.info.90[which(is.na(rseg.info.90$`Flow Change`) == FALSE),]

write.csv(rseg.info.10, "precip_and_temp_vs_Qout_rseg.info.10.csv")
write.csv(rseg.info.50, "precip_and_temp_vs_Qout_rseg.info.50.csv")
write.csv(rseg.info.90, "precip_and_temp_vs_Qout_rseg.info.90.csv")