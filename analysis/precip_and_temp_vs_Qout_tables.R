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

library(rgdal)
lsegs <- readOGR(lseg.loc, 'P6_LSegs_VA')
rsegs <- readOGR(rseg.loc, 'P6_RSegs_VA')

library(RCurl)
download.file('ftp://ftp.chesapeakebay.net/gis/ModelingP6/P6Beta_v3_LRSegs_081516.zip', destfile = paste0(dir.location, 'P6_LRSegs.zip'))
unzip(zipfile = paste0(dir.location, 'P6_LRSegs.zip'), overwrite = TRUE, exdir = 'P6_LRSegs')

lrsegs <- readOGR(paste0(dir.location, '\\P6_LRSegs'), 'P6Beta_v3_LRSegs_081516')

rseg.info.10 <- data.frame(matrix(data = NA, nrow = length(rsegs@data$RiverSeg), ncol = 6))
colnames(rseg.info.10) = c('River Segment', 'Prcp. Change', 'Temp. Change', 'Flow Change', 'Runid 11 Average', 'Runid 15 Average')
rseg.info.10$`River Segment` <- rsegs@data$RiverSeg
rseg.info.50 <- data.frame(matrix(data = NA, nrow = length(rsegs@data$RiverSeg), ncol = 6))
colnames(rseg.info.50) = c('River Segment', 'Prcp. Change', 'Temp. Change', 'Flow Change', 'Runid 11 Average', 'Runid 14 Average')
rseg.info.50$`River Segment` <- rsegs@data$RiverSeg
rseg.info.90 <- data.frame(matrix(data = NA, nrow = length(rsegs@data$RiverSeg), ncol = 6))
colnames(rseg.info.90) = c('River Segment', 'Prcp. Change', 'Temp. Change', 'Flow Change', 'Runid 11 Average', 'Runid 16 Average')
rseg.info.90$`River Segment` <- rsegs@data$RiverSeg

for (i in 1:length(rsegs@data$RiverSeg)) {
  lrseg.nums <- which(lrsegs@data$RiverSeg == as.character(rsegs@data$RiverSeg[i]))
  lrseg.areas <- as.numeric(lrsegs@data$Acres[lrseg.nums])
  total.area <- sum(lrseg.areas)
  
  weighted.prcp.10 <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.prcp.50 <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.prcp.90 <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.temp.10 <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.temp.50 <- vector(mode = 'numeric', length = length(lrseg.nums))
  weighted.temp.90 <- vector(mode = 'numeric', length = length(lrseg.nums))
  for (j in 1:length(lrseg.nums)) {
    lseg <- as.character(lrsegs@data$FIPS_NHL[j])
    
    lseg.prcp.10 <- PRCP.ENS.10.PCT$Total[which(PRCP.ENS.10.PCT$FIPS_NHL == lseg)]
    lseg.prcp.50 <- PRCP.ENS.50.PCT$Total[which(PRCP.ENS.50.PCT$FIPS_NHL == lseg)]
    lseg.prcp.90 <- PRCP.ENS.90.PCT$Total[which(PRCP.ENS.90.PCT$FIPS_NHL == lseg)]
    lseg.temp.10 <- TEMP.ENS.10.PCT$Total[which(TEMP.ENS.10.PCT$FIPS_NHL == lseg)]
    lseg.temp.50 <- TEMP.ENS.50.PCT$Total[which(TEMP.ENS.50.PCT$FIPS_NHL == lseg)]
    lseg.temp.90 <- TEMP.ENS.90.PCT$Total[which(TEMP.ENS.90.PCT$FIPS_NHL == lseg)]
    
    fraction.of.area <- lrseg.areas[j]/total.area
    
    weighted.prcp.10[j] <- lseg.prcp.10*fraction.of.area
    weighted.prcp.50[j] <- lseg.prcp.50*fraction.of.area
    weighted.prcp.90[j] <- lseg.prcp.90*fraction.of.area
    weighted.temp.10[j] <- lseg.temp.10*fraction.of.area
    weighted.temp.50[j] <- lseg.temp.50*fraction.of.area
    weighted.temp.90[j] <- lseg.temp.90*fraction.of.area
    
    rm(lseg, lseg.prcp.10, lseg.prcp.50, lseg.prcp.90, lseg.temp.10, lseg.temp.50, lseg.temp.90,
       fraction.of.area)
  }
  
  rseg.info.10$`Prcp. Change`[i] <- sum(weighted.prcp.10)
  rseg.info.50$`Prcp. Change`[i] <- sum(weighted.prcp.50)
  rseg.info.90$`Prcp. Change`[i] <- sum(weighted.prcp.90)
  rseg.info.10$`Temp. Change`[i] <- sum(weighted.temp.10)
  rseg.info.50$`Temp. Change`[i] <- sum(weighted.temp.50)
  rseg.info.90$`Temp. Change`[i] <- sum(weighted.temp.90)
  
  rm(weighted.prcp.10, weighted.prcp.50, weighted.prcp.90,
     weighted.temp.10, weighted.temp.50, weighted.temp.90)
  
  scen.prop.11 <- get.scen.prop(rsegs@data$RiverSeg[i], 'vahydro-1.0', 'vahydro', 11, '1984-01-01', '2014-12-31', site, token)
  scen.prop.14 <- get.scen.prop(rsegs@data$RiverSeg[i], 'vahydro-1.0', 'vahydro', 14, '1984-01-01', '2014-12-31', site, token)
  scen.prop.15 <- get.scen.prop(rsegs@data$RiverSeg[i], 'vahydro-1.0', 'vahydro', 15, '1984-01-01', '2014-12-31', site, token)
  scen.prop.16 <- get.scen.prop(rsegs@data$RiverSeg[i], 'vahydro-1.0', 'vahydro', 16, '1984-01-01', '2014-12-31', site, token)
  
  Qout_11 <- vahydro_import_om_class_constant_from_scenprop(scen.prop.11, 'om_class_Constant', '', 'Qout', site, token)
  Qout_14 <- vahydro_import_om_class_constant_from_scenprop(scen.prop.14, 'om_class_Constant', '', 'Qout', site, token)
  Qout_15 <- vahydro_import_om_class_constant_from_scenprop(scen.prop.15, 'om_class_Constant', '', 'Qout', site, token)
  Qout_16 <- vahydro_import_om_class_constant_from_scenprop(scen.prop.16, 'om_class_Constant', '', 'Qout', site, token)
  
  rseg.info.10$`Runid 11 Average`[i] <- Qout_11
  rseg.info.50$`Runid 11 Average`[i] <- Qout_11
  rseg.info.90$`Runid 11 Average`[i] <- Qout_11
  rseg.info.10$`Runid 15 Average`[i] <- Qout_15
  rseg.info.50$`Runid 14 Average`[i] <- Qout_14
  rseg.info.90$`Runid 16 Average`[i] <- Qout_16
  
  rm(scen.prop.11, scen.prop.14, scen.prop.15, scen.prop.16,
     Qout_11, Qout_14, Qout_15, Qout_16)
}

rseg.info.10$`Flow Change` <- (rseg.info.10$`Runid 15 Average` - rseg.info.10$`Runid 11 Average`) / rseg.info.10$`Runid 11 Average` * 100
rseg.info.10$`Flow Change`[rseg.info.10$`Runid 15 Average` == FALSE | rseg.info.10$`Runid 11 Average` == FALSE] <- NA
rseg.info.50$`Flow Change` <- (rseg.info.50$`Runid 14 Average` - rseg.info.50$`Runid 11 Average`) / rseg.info.50$`Runid 11 Average` * 100
rseg.info.50$`Flow Change`[rseg.info.50$`Runid 14 Average` == FALSE | rseg.info.50$`Runid 11 Average` == FALSE] <- NA
rseg.info.90$`Flow Change` <- (rseg.info.90$`Runid 16 Average` - rseg.info.90$`Runid 11 Average`) / rseg.info.90$`Runid 11 Average` * 100
rseg.info.90$`Flow Change`[rseg.info.90$`Runid 16 Average` == FALSE | rseg.info.90$`Runid 11 Average` == FALSE] <- NA

rseg.info.10 <- rseg.info.10[which(is.na(rseg.info.10$`Flow Change`) == FALSE),]
rseg.info.50 <- rseg.info.50[which(is.na(rseg.info.50$`Flow Change`) == FALSE),]
rseg.info.90 <- rseg.info.90[which(is.na(rseg.info.90$`Flow Change`) == FALSE),]
