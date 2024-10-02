# Creates many versions of temperature and precipitation maps, some of which have a more presentable
# layout for use in reports and presentations.

site <- "http://deq2.bse.vt.edu/d.bet"    #Specify the site of interest, either d.bet OR d.dh

basepath <- '/var/www/R'
source(paste(basepath,"config.local.private", sep = "/"))
data.location <- paste0(cbp6_location, '\\Data\\CBP6_Temp_Prcp_Data')
va.or.cbw <- 'va'

library("readxl")
library("kableExtra")

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


# SETUP
source(paste(hydro_tools,"VAHydro-2.0/rest_functions.R", sep = "/")); 
source(paste(hydro_tools,"VAHydro-1.0/fn_vahydro-1.0.R", sep = "/"));  
source(paste(hydro_tools,"LowFlow/fn_iha.R", sep = "/"));
#retrieve rest token
source(paste(hydro_tools,"auth.private", sep = "/"));#load rest username and password, contained in auth.private file
token <- rest_token(site, token, rest_uname, rest_pw);
options(timeout=120); # set timeout to twice default level to avoid abort due to high traffic

library(rgdal)
library(ggplot2)
library(dplyr)
library(rgeos)
library(ggsn)

#--------------------------------------------------------------------------------------------
#LOAD STATE GEOMETRY
#--------------------------------------------------------------------------------------------
STATES <- read.table(file=paste(hydro_tools,"GIS_LAYERS","STATES.tsv",sep="\\"), header=TRUE, sep="\t") #Load state geometries

#specify spatial extent for map
if (va.or.cbw == 'va') {
  extent <- data.frame(x = c(-82, -75), 
                       y = c(36.5, 39.5))
} else if (va.or.cbw == 'cbw') {
  extent <- data.frame(x = c(-85, -73), 
                       y = c(36.5, 45))
} else {
  print(paste('ERROR: Neither VA nor CBW selected'))
}


bb=readWKT(paste0("POLYGON((",extent$x[1]," ",extent$y[1],",",extent$x[2]," ",extent$y[1],",",extent$x[2]," ",extent$y[2],",",extent$x[1]," ",extent$y[2],",",extent$x[1]," ",extent$y[1],"))",sep=""))
bbProjected <- SpatialPolygonsDataFrame(bb,data.frame("id"), match.ID = FALSE)
bbProjected@data$id <- rownames(bbProjected@data)
bbPoints <- fortify(bbProjected, region = "id")
bbDF <- merge(bbPoints, bbProjected@data, by = "id")

VA <- STATES[which(STATES$state == "VA"),]
VA_geom <- readWKT(VA$geom)
VA_geom_clip <- gIntersection(bb, VA_geom)
VAProjected <- SpatialPolygonsDataFrame(VA_geom_clip,data.frame("id"), match.ID = TRUE)
VAProjected@data$id <- rownames(VAProjected@data)
VAPoints <- fortify( VAProjected, region = "id")
VADF <- merge(VAPoints,  VAProjected@data, by = "id")

TN <- STATES[which(STATES$state == "TN"),]
TN_geom <- readWKT(TN$geom)
TN_geom_clip <- gIntersection(bb, TN_geom)
TNProjected <- SpatialPolygonsDataFrame(TN_geom_clip,data.frame("id"), match.ID = TRUE)
TNProjected@data$id <- rownames(TNProjected@data)
TNPoints <- fortify( TNProjected, region = "id")
TNDF <- merge(TNPoints,  TNProjected@data, by = "id")

NC <- STATES[which(STATES$state == "NC"),]
NC_geom <- readWKT(NC$geom)
NC_geom_clip <- gIntersection(bb, NC_geom)
NCProjected <- SpatialPolygonsDataFrame(NC_geom_clip,data.frame("id"), match.ID = TRUE)
NCProjected@data$id <- rownames(NCProjected@data)
NCPoints <- fortify( NCProjected, region = "id")
NCDF <- merge(NCPoints,  NCProjected@data, by = "id")

# KY <- STATES[which(STATES$state == "KY"),]
# KY_geom <- readWKT(KY$geom)
# KY_geom_clip <- gIntersection(bb, KY_geom)
# KYProjected <- SpatialPolygonsDataFrame(KY_geom_clip,data.frame("id"), match.ID = TRUE)
# KYProjected@data$id <- rownames(KYProjected@data)
# KYPoints <- fortify( KYProjected, region = "id")
# KYDF <- merge(KYPoints,  KYProjected@data, by = "id")

WV <- STATES[which(STATES$state == "WV"),]
WV_geom <- readWKT(WV$geom)
WV_geom_clip <- gIntersection(bb, WV_geom)
WVProjected <- SpatialPolygonsDataFrame(WV_geom_clip,data.frame("id"), match.ID = TRUE)
WVProjected@data$id <- rownames(WVProjected@data)
WVPoints <- fortify( WVProjected, region = "id")
WVDF <- merge(WVPoints,  WVProjected@data, by = "id")

MD <- STATES[which(STATES$state == "MD"),]
MD_geom <- readWKT(MD$geom)
MD_geom_clip <- gIntersection(bb, MD_geom)
MDProjected <- SpatialPolygonsDataFrame(MD_geom_clip,data.frame("id"), match.ID = TRUE)
MDProjected@data$id <- rownames(MDProjected@data)
MDPoints <- fortify( MDProjected, region = "id")
MDDF <- merge(MDPoints,  MDProjected@data, by = "id")

DE <- STATES[which(STATES$state == "DE"),]
DE_geom <- readWKT(DE$geom)
DE_geom_clip <- gIntersection(bb, DE_geom)
DEProjected <- SpatialPolygonsDataFrame(DE_geom_clip,data.frame("id"), match.ID = TRUE)
DEProjected@data$id <- rownames(DEProjected@data)
DEPoints <- fortify( DEProjected, region = "id")
DEDF <- merge(DEPoints,  DEProjected@data, by = "id")

# PA <- STATES[which(STATES$state == "PA"),]
# PA_geom <- readWKT(PA$geom)
# PA_geom_clip <- gIntersection(bb, PA_geom)
# PAProjected <- SpatialPolygonsDataFrame(PA_geom_clip,data.frame("id"), match.ID = TRUE)
# PAProjected@data$id <- rownames(PAProjected@data)
# PAPoints <- fortify( PAProjected, region = "id")
# PADF <- merge(PAPoints,  PAProjected@data, by = "id")

NJ <- STATES[which(STATES$state == "NJ"),]
NJ_geom <- readWKT(NJ$geom)
NJ_geom_clip <- gIntersection(bb, NJ_geom)
NJProjected <- SpatialPolygonsDataFrame(NJ_geom_clip,data.frame("id"), match.ID = TRUE)
NJProjected@data$id <- rownames(NJProjected@data)
NJPoints <- fortify( NJProjected, region = "id")
NJDF <- merge(NJPoints,  NJProjected@data, by = "id")

OH <- STATES[which(STATES$state == "OH"),]
OH_geom <- readWKT(OH$geom)
OH_geom_clip <- gIntersection(bb, OH_geom)
OHProjected <- SpatialPolygonsDataFrame(OH_geom_clip,data.frame("id"), match.ID = TRUE)
OHProjected@data$id <- rownames(OHProjected@data)
OHPoints <- fortify( OHProjected, region = "id")
OHDF <- merge(OHPoints,  OHProjected@data, by = "id")

# SC <- STATES[which(STATES$state == "SC"),]
# SC_geom <- readWKT(SC$geom)
# SC_geom_clip <- gIntersection(bb, SC_geom)
# SCProjected <- SpatialPolygonsDataFrame(SC_geom_clip,data.frame("id"), match.ID = TRUE)
# SCProjected@data$id <- rownames(SCProjected@data)
# SCPoints <- fortify( SCProjected, region = "id")
# SCDF <- merge(SCPoints,  SCProjected@data, by = "id")

DC <- STATES[which(STATES$state == "DC"),]
DC_geom <- readWKT(DC$geom)
DC_geom_clip <- gIntersection(bb, DC_geom)
DCProjected <- SpatialPolygonsDataFrame(DC_geom_clip,data.frame("id"), match.ID = TRUE)
DCProjected@data$id <- rownames(DCProjected@data)
DCPoints <- fortify( DCProjected, region = "id")
DCDF <- merge(DCPoints,  DCProjected@data, by = "id")

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

# P10 PRCP MAPS
lsegs.df_p10_prcp <- merge(lsegs.df, PRCP.ENS.10.PCT, by = 'FIPS_NHL')
map_p10_prcp <- ggplot(data = lsegs.df_p10_prcp, aes(x = long, y = lat, group = group))+
  geom_polygon(data = bbDF, color="black", fill = "powderblue",lwd=0.5)+
  geom_polygon(data = VADF, color="gray46", fill = "gray")+
  geom_polygon(data = TNDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = SCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = KYDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = WVDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = MDDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DEDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = PADF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NJDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = OHDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DCDF, color="gray46", fill = "gray", lwd=0.5)

# INDIVIDUAL METRIC MAP -- OVERALL
map_p10_prcp_overall <- map_p10_prcp + 
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.overall.map.v2.png', plot = map_p10_prcp_overall, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jan
map_p10_prcp_jan <- map_p10_prcp + 
  geom_polygon(aes(fill = Jan), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.jan.map.v2.png', plot = map_p10_prcp_jan, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- feb
map_p10_prcp_feb <- map_p10_prcp + 
  geom_polygon(aes(fill = Feb), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.feb.map.v2.png', plot = map_p10_prcp_feb, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- mar
map_p10_prcp_mar <- map_p10_prcp + 
  geom_polygon(aes(fill = Mar), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.mar.map.v2.png', plot = map_p10_prcp_mar, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- apr
map_p10_prcp_apr <- map_p10_prcp + 
  geom_polygon(aes(fill = Apr), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.apr.map.v2.png', plot = map_p10_prcp_apr, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- may
map_p10_prcp_may <- map_p10_prcp + 
  geom_polygon(aes(fill = May), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.may.map.v2.png', plot = map_p10_prcp_may, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jun
map_p10_prcp_jun <- map_p10_prcp + 
  geom_polygon(aes(fill = Jun), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.jun.map.v2.png', plot = map_p10_prcp_jun, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jul
map_p10_prcp_jul <- map_p10_prcp + 
  geom_polygon(aes(fill = Jul), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.jul.map.v2.png', plot = map_p10_prcp_jul, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- aug
map_p10_prcp_aug <- map_p10_prcp + 
  geom_polygon(aes(fill = Aug), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.aug.map.v2.png', plot = map_p10_prcp_aug, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- sep
map_p10_prcp_sep <- map_p10_prcp + 
  geom_polygon(aes(fill = Sep), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.sep.map.v2.png', plot = map_p10_prcp_sep, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- oct
map_p10_prcp_oct <- map_p10_prcp + 
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.oct.map.v2.png', plot = map_p10_prcp_oct, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- nov
map_p10_prcp_nov <- map_p10_prcp + 
  geom_polygon(aes(fill = Nov), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.nov.map.v2.png', plot = map_p10_prcp_nov, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- dec
map_p10_prcp_dec <- map_p10_prcp + 
  geom_polygon(aes(fill = Dec), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.dec.map.v2.png', plot = map_p10_prcp_dec, width = 6.18, height = 3.68, units = 'in')

# P10 TEMP
lsegs.df_p10_temp <- merge(lsegs.df, TEMP.ENS.10.PCT, by = 'FIPS_NHL')
map_p10_temp <- ggplot(data = lsegs.df_p10_temp, aes(x = long, y = lat, group = group))+
  geom_polygon(data = bbDF, color="black", fill = "powderblue",lwd=0.5)+
  geom_polygon(data = VADF, color="gray46", fill = "gray")+
  geom_polygon(data = TNDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = SCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = KYDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = WVDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = MDDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DEDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = PADF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NJDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = OHDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DCDF, color="gray46", fill = "gray", lwd=0.5)

# INDIVIDUAL METRIC MAP -- OVERALL
map_p10_temp_overall <- map_p10_temp + 
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.overall.map.v2.png', plot = map_p10_temp_overall, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jan
map_p10_temp_jan <- map_p10_temp + 
  geom_polygon(aes(fill = Jan), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.jan.map.v2.png', plot = map_p10_temp_jan, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- feb
map_p10_temp_feb <- map_p10_temp + 
  geom_polygon(aes(fill = Feb), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.feb.map.v2.png', plot = map_p10_temp_feb, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- mar
map_p10_temp_mar <- map_p10_temp + 
  geom_polygon(aes(fill = Mar), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.mar.map.v2.png', plot = map_p10_temp_mar, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- apr
map_p10_temp_apr <- map_p10_temp + 
  geom_polygon(aes(fill = Apr), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.apr.map.v2.png', plot = map_p10_temp_apr, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- may
map_p10_temp_may <- map_p10_temp + 
  geom_polygon(aes(fill = May), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.may.map.v2.png', plot = map_p10_temp_may, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jun
map_p10_temp_jun <- map_p10_temp + 
  geom_polygon(aes(fill = Jun), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.jun.map.v2.png', plot = map_p10_temp_jun, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jul
map_p10_temp_jul <- map_p10_temp + 
  geom_polygon(aes(fill = Jul), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.jul.map.v2.png', plot = map_p10_temp_jul, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- aug
map_p10_temp_aug <- map_p10_temp + 
  geom_polygon(aes(fill = Aug), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.aug.map.v2.png', plot = map_p10_temp_aug, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- sep
map_p10_temp_sep <- map_p10_temp + 
  geom_polygon(aes(fill = Sep), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.sep.map.v2.png', plot = map_p10_temp_sep, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- oct
map_p10_temp_oct <- map_p10_temp + 
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.oct.map.v2.png', plot = map_p10_temp_oct, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- nov
map_p10_temp_nov <- map_p10_temp + 
  geom_polygon(aes(fill = Nov), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.nov.map.v2.png', plot = map_p10_temp_nov, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- dec
map_p10_temp_dec <- map_p10_temp + 
  geom_polygon(aes(fill = Dec), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.dec.map.v2.png', plot = map_p10_temp_dec, width = 6.18, height = 3.68, units = 'in')

# NEEDS DOING FOR P10, P50, P90 AND PRCP/EVAP
lsegs.df_p50_prcp <- merge(lsegs.df, PRCP.ENS.50.PCT, by = 'FIPS_NHL')
map_p50_prcp <- ggplot(data = lsegs.df_p50_prcp, aes(x = long, y = lat, group = group))+
  geom_polygon(data = bbDF, color="black", fill = "powderblue",lwd=0.5)+
  geom_polygon(data = VADF, color="gray46", fill = "gray")+
  geom_polygon(data = TNDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = SCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = KYDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = WVDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = MDDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DEDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = PADF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NJDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = OHDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DCDF, color="gray46", fill = "gray", lwd=0.5)

# INDIVIDUAL METRIC MAP -- OVERALL
map_p50_prcp_overall <- map_p50_prcp + 
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.overall.map.v2.png', plot = map_p50_prcp_overall, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jan
map_p50_prcp_jan <- map_p50_prcp + 
  geom_polygon(aes(fill = Jan), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.jan.map.v2.png', plot = map_p50_prcp_jan, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- feb
map_p50_prcp_feb <- map_p50_prcp + 
  geom_polygon(aes(fill = Feb), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.feb.map.v2.png', plot = map_p50_prcp_feb, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- mar
map_p50_prcp_mar <- map_p50_prcp + 
  geom_polygon(aes(fill = Mar), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.mar.map.v2.png', plot = map_p50_prcp_mar, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- apr
map_p50_prcp_apr <- map_p50_prcp + 
  geom_polygon(aes(fill = Apr), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.apr.map.v2.png', plot = map_p50_prcp_apr, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- may
map_p50_prcp_may <- map_p50_prcp + 
  geom_polygon(aes(fill = May), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.may.map.v2.png', plot = map_p50_prcp_may, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jun
map_p50_prcp_jun <- map_p50_prcp + 
  geom_polygon(aes(fill = Jun), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.jun.map.v2.png', plot = map_p50_prcp_jun, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jul
map_p50_prcp_jul <- map_p50_prcp + 
  geom_polygon(aes(fill = Jul), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.jul.map.v2.png', plot = map_p50_prcp_jul, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- aug
map_p50_prcp_aug <- map_p50_prcp + 
  geom_polygon(aes(fill = Aug), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.aug.map.v2.png', plot = map_p50_prcp_aug, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- sep
map_p50_prcp_sep <- map_p50_prcp + 
  geom_polygon(aes(fill = Sep), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.sep.map.v2.png', plot = map_p50_prcp_sep, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- oct
map_p50_prcp_oct <- map_p50_prcp + 
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.oct.map.v2.png', plot = map_p50_prcp_oct, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- nov
map_p50_prcp_nov <- map_p50_prcp + 
  geom_polygon(aes(fill = Nov), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.nov.map.v2.png', plot = map_p50_prcp_nov, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- dec
map_p50_prcp_dec <- map_p50_prcp + 
  geom_polygon(aes(fill = Dec), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.dec.map.v2.png', plot = map_p50_prcp_dec, width = 6.18, height = 3.68, units = 'in')

# p50 TEMP
lsegs.df_p50_temp <- merge(lsegs.df, TEMP.ENS.50.PCT, by = 'FIPS_NHL')
map_p50_temp <- ggplot(data = lsegs.df_p50_temp, aes(x = long, y = lat, group = group))+
  geom_polygon(data = bbDF, color="black", fill = "powderblue",lwd=0.5)+
  geom_polygon(data = VADF, color="gray46", fill = "gray")+
  geom_polygon(data = TNDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = SCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = KYDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = WVDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = MDDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DEDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = PADF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NJDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = OHDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DCDF, color="gray46", fill = "gray", lwd=0.5)

# INDIVIDUAL METRIC MAP -- OVERALL
map_p50_temp_overall <- map_p50_temp + 
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.overall.map.v2.png', plot = map_p50_temp_overall, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jan
map_p50_temp_jan <- map_p50_temp + 
  geom_polygon(aes(fill = Jan), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.jan.map.v2.png', plot = map_p50_temp_jan, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- feb
map_p50_temp_feb <- map_p50_temp + 
  geom_polygon(aes(fill = Feb), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.feb.map.v2.png', plot = map_p50_temp_feb, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- mar
map_p50_temp_mar <- map_p50_temp + 
  geom_polygon(aes(fill = Mar), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.mar.map.v2.png', plot = map_p50_temp_mar, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- apr
map_p50_temp_apr <- map_p50_temp + 
  geom_polygon(aes(fill = Apr), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.apr.map.v2.png', plot = map_p50_temp_apr, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- may
map_p50_temp_may <- map_p50_temp + 
  geom_polygon(aes(fill = May), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.may.map.v2.png', plot = map_p50_temp_may, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jun
map_p50_temp_jun <- map_p50_temp + 
  geom_polygon(aes(fill = Jun), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.jun.map.v2.png', plot = map_p50_temp_jun, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jul
map_p50_temp_jul <- map_p50_temp + 
  geom_polygon(aes(fill = Jul), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.jul.map.v2.png', plot = map_p50_temp_jul, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- aug
map_p50_temp_aug <- map_p50_temp + 
  geom_polygon(aes(fill = Aug), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.aug.map.v2.png', plot = map_p50_temp_aug, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- sep
map_p50_temp_sep <- map_p50_temp + 
  geom_polygon(aes(fill = Sep), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.sep.map.v2.png', plot = map_p50_temp_sep, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- oct
map_p50_temp_oct <- map_p50_temp + 
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.oct.map.v2.png', plot = map_p50_temp_oct, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- nov
map_p50_temp_nov <- map_p50_temp + 
  geom_polygon(aes(fill = Nov), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.nov.map.v2.png', plot = map_p50_temp_nov, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- dec
map_p50_temp_dec <- map_p50_temp + 
  geom_polygon(aes(fill = Dec), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.dec.map.v2.png', plot = map_p50_temp_dec, width = 6.18, height = 3.68, units = 'in')

# NEEDS DOING FOR P10, P50, P90 AND PRCP/EVAP
lsegs.df_p90_prcp <- merge(lsegs.df, PRCP.ENS.90.PCT, by = 'FIPS_NHL')
map_p90_prcp <- ggplot(data = lsegs.df_p90_prcp, aes(x = long, y = lat, group = group))+
  geom_polygon(data = bbDF, color="black", fill = "powderblue",lwd=0.5)+
  geom_polygon(data = VADF, color="gray46", fill = "gray")+
  geom_polygon(data = TNDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = SCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = KYDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = WVDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = MDDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DEDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = PADF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NJDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = OHDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DCDF, color="gray46", fill = "gray", lwd=0.5)

# INDIVIDUAL METRIC MAP -- OVERALL
map_p90_prcp_overall <- map_p90_prcp + 
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.overall.map.v2.png', plot = map_p90_prcp_overall, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jan
map_p90_prcp_jan <- map_p90_prcp + 
  geom_polygon(aes(fill = Jan), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.jan.map.v2.png', plot = map_p90_prcp_jan, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- feb
map_p90_prcp_feb <- map_p90_prcp + 
  geom_polygon(aes(fill = Feb), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.feb.map.v2.png', plot = map_p90_prcp_feb, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- mar
map_p90_prcp_mar <- map_p90_prcp + 
  geom_polygon(aes(fill = Mar), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.mar.map.v2.png', plot = map_p90_prcp_mar, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- apr
map_p90_prcp_apr <- map_p90_prcp + 
  geom_polygon(aes(fill = Apr), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.apr.map.v2.png', plot = map_p90_prcp_apr, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- may
map_p90_prcp_may <- map_p90_prcp + 
  geom_polygon(aes(fill = May), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.may.map.v2.png', plot = map_p90_prcp_may, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jun
map_p90_prcp_jun <- map_p90_prcp + 
  geom_polygon(aes(fill = Jun), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.jun.map.v2.png', plot = map_p90_prcp_jun, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jul
map_p90_prcp_jul <- map_p90_prcp + 
  geom_polygon(aes(fill = Jul), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.jul.map.v2.png', plot = map_p90_prcp_jul, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- aug
map_p90_prcp_aug <- map_p90_prcp + 
  geom_polygon(aes(fill = Aug), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.aug.map.v2.png', plot = map_p90_prcp_aug, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- sep
map_p90_prcp_sep <- map_p90_prcp + 
  geom_polygon(aes(fill = Sep), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.sep.map.v2.png', plot = map_p90_prcp_sep, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- oct
map_p90_prcp_oct <- map_p90_prcp + 
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.oct.map.v2.png', plot = map_p90_prcp_oct, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- nov
map_p90_prcp_nov <- map_p90_prcp + 
  geom_polygon(aes(fill = Nov), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.nov.map.v2.png', plot = map_p90_prcp_nov, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- dec
map_p90_prcp_dec <- map_p90_prcp + 
  geom_polygon(aes(fill = Dec), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.dec.map.v2.png', plot = map_p90_prcp_dec, width = 6.18, height = 3.68, units = 'in')

# p90 TEMP
lsegs.df_p90_temp <- merge(lsegs.df, TEMP.ENS.90.PCT, by = 'FIPS_NHL')
map_p90_temp <- ggplot(data = lsegs.df_p90_temp, aes(x = long, y = lat, group = group))+
  geom_polygon(data = bbDF, color="black", fill = "powderblue",lwd=0.5)+
  geom_polygon(data = VADF, color="gray46", fill = "gray")+
  geom_polygon(data = TNDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = SCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = KYDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = WVDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = MDDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DEDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = PADF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NJDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = OHDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DCDF, color="gray46", fill = "gray", lwd=0.5)

# INDIVIDUAL METRIC MAP -- OVERALL
map_p90_temp_overall <- map_p90_temp + 
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.overall.map.v2.png', plot = map_p90_temp_overall, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jan
map_p90_temp_jan <- map_p90_temp + 
  geom_polygon(aes(fill = Jan), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.jan.map.v2.png', plot = map_p90_temp_jan, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- feb
map_p90_temp_feb <- map_p90_temp + 
  geom_polygon(aes(fill = Feb), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.feb.map.v2.png', plot = map_p90_temp_feb, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- mar
map_p90_temp_mar <- map_p90_temp + 
  geom_polygon(aes(fill = Mar), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.mar.map.v2.png', plot = map_p90_temp_mar, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- apr
map_p90_temp_apr <- map_p90_temp + 
  geom_polygon(aes(fill = Apr), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.apr.map.v2.png', plot = map_p90_temp_apr, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- may
map_p90_temp_may <- map_p90_temp + 
  geom_polygon(aes(fill = May), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.may.map.v2.png', plot = map_p90_temp_may, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jun
map_p90_temp_jun <- map_p90_temp + 
  geom_polygon(aes(fill = Jun), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.jun.map.v2.png', plot = map_p90_temp_jun, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jul
map_p90_temp_jul <- map_p90_temp + 
  geom_polygon(aes(fill = Jul), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.jul.map.v2.png', plot = map_p90_temp_jul, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- aug
map_p90_temp_aug <- map_p90_temp + 
  geom_polygon(aes(fill = Aug), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.aug.map.v2.png', plot = map_p90_temp_aug, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- sep
map_p90_temp_sep <- map_p90_temp + 
  geom_polygon(aes(fill = Sep), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.sep.map.v2.png', plot = map_p90_temp_sep, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- oct
map_p90_temp_oct <- map_p90_temp + 
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.oct.map.v2.png', plot = map_p90_temp_oct, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- nov
map_p90_temp_nov <- map_p90_temp + 
  geom_polygon(aes(fill = Nov), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.nov.map.v2.png', plot = map_p90_temp_nov, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- dec
map_p90_temp_dec <- map_p90_temp + 
  geom_polygon(aes(fill = Dec), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.dec.map.v2.png', plot = map_p90_temp_dec, width = 6.18, height = 3.68, units = 'in')

# VERSION 3 WITH SET SCALES ------
# P10 PRCP MAPS
lsegs.df_p10_prcp <- merge(lsegs.df, PRCP.ENS.10.PCT, by = 'FIPS_NHL')
map_p10_prcp <- ggplot(data = lsegs.df_p10_prcp, aes(x = long, y = lat, group = group))+
  geom_polygon(data = bbDF, color="black", fill = "powderblue",lwd=0.5)+
  geom_polygon(data = VADF, color="gray46", fill = "gray")+
  geom_polygon(data = TNDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = SCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = KYDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = WVDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = MDDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DEDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = PADF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NJDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = OHDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DCDF, color="gray46", fill = "gray", lwd=0.5)

# INDIVIDUAL METRIC MAP -- OVERALL
map_p10_prcp_overall <- map_p10_prcp + 
  ggtitle('P10 Precipitation (Overall)') +
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green',
                       limits = c(-20, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.overall.map.v3.png', plot = map_p10_prcp_overall, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jan
map_p10_prcp_jan <- map_p10_prcp + 
  ggtitle('P10 Precipitation (January)') +
  geom_polygon(aes(fill = Jan), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green',
                       limits = c(-25, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.jan.map.v3.png', plot = map_p10_prcp_jan, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- feb
map_p10_prcp_feb <- map_p10_prcp + 
  ggtitle('P10 Precipitation (February)') +
  geom_polygon(aes(fill = Feb), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-25, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.feb.map.v3.png', plot = map_p10_prcp_feb, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- mar
map_p10_prcp_mar <- map_p10_prcp + 
  ggtitle('P10 Precipitation (March)') +
  geom_polygon(aes(fill = Mar), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-25, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.mar.map.v3.png', plot = map_p10_prcp_mar, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- apr
map_p10_prcp_apr <- map_p10_prcp + 
  ggtitle('P10 Precipitation (April)') +
  geom_polygon(aes(fill = Apr), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-25, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.apr.map.v3.png', plot = map_p10_prcp_apr, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- may
map_p10_prcp_may <- map_p10_prcp + 
  ggtitle('P10 Precipitation (May)') +
  geom_polygon(aes(fill = May), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-25, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.may.map.v3.png', plot = map_p10_prcp_may, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jun
map_p10_prcp_jun <- map_p10_prcp + 
  ggtitle('P10 Precipitation (June)') +
  geom_polygon(aes(fill = Jun), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-25, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.jun.map.v3.png', plot = map_p10_prcp_jun, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jul
map_p10_prcp_jul <- map_p10_prcp + 
  ggtitle('P10 Precipitation (July)') +
  geom_polygon(aes(fill = Jul), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-25, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.jul.map.v3.png', plot = map_p10_prcp_jul, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- aug
map_p10_prcp_aug <- map_p10_prcp + 
  ggtitle('P10 Precipitation (August)') +
  geom_polygon(aes(fill = Aug), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-25, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.aug.map.v3.png', plot = map_p10_prcp_aug, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- sep
map_p10_prcp_sep <- map_p10_prcp + 
  ggtitle('P10 Precipitation (September)') +
  geom_polygon(aes(fill = Sep), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-25, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.sep.map.v3.png', plot = map_p10_prcp_sep, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- oct
map_p10_prcp_oct <- map_p10_prcp + 
  ggtitle('P10 Precipitation (October)') +
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-25, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.oct.map.v3.png', plot = map_p10_prcp_oct, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- nov
map_p10_prcp_nov <- map_p10_prcp + 
  ggtitle('P10 Precipitation (November)') +
  geom_polygon(aes(fill = Nov), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-25, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.nov.map.v3.png', plot = map_p10_prcp_nov, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- dec
map_p10_prcp_dec <- map_p10_prcp + 
  ggtitle('P10 Precipitation (December)') +
  geom_polygon(aes(fill = Dec), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-25, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.dec.map.v3.png', plot = map_p10_prcp_dec, width = 6.18, height = 3.68, units = 'in')

# P10 TEMP
lsegs.df_p10_temp <- merge(lsegs.df, TEMP.ENS.10.PCT, by = 'FIPS_NHL')
map_p10_temp <- ggplot(data = lsegs.df_p10_temp, aes(x = long, y = lat, group = group))+
  geom_polygon(data = bbDF, color="black", fill = "powderblue",lwd=0.5)+
  geom_polygon(data = VADF, color="gray46", fill = "gray")+
  geom_polygon(data = TNDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = SCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = KYDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = WVDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = MDDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DEDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = PADF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NJDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = OHDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DCDF, color="gray46", fill = "gray", lwd=0.5)

# INDIVIDUAL METRIC MAP -- OVERALL
map_p10_temp_overall <- map_p10_temp + 
  ggtitle('P10 Temperature (Overall)') +
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.overall.map.v3.png', plot = map_p10_temp_overall, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jan
map_p10_temp_jan <- map_p10_temp + 
  ggtitle('P10 Temperature (January)') +
  geom_polygon(aes(fill = Jan), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.jan.map.v3.png', plot = map_p10_temp_jan, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- feb
map_p10_temp_feb <- map_p10_temp + 
  ggtitle('P10 Temperature (February)') +
  geom_polygon(aes(fill = Feb), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.feb.map.v3.png', plot = map_p10_temp_feb, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- mar
map_p10_temp_mar <- map_p10_temp + 
  ggtitle('P10 Temperature (March)') +
  geom_polygon(aes(fill = Mar), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.mar.map.v3.png', plot = map_p10_temp_mar, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- apr
map_p10_temp_apr <- map_p10_temp + 
  ggtitle('P10 Temperature (April)') +
  geom_polygon(aes(fill = Apr), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.apr.map.v3.png', plot = map_p10_temp_apr, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- may
map_p10_temp_may <- map_p10_temp + 
  ggtitle('P10 Temperature (May)') +
  geom_polygon(aes(fill = May), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.may.map.v3.png', plot = map_p10_temp_may, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jun
map_p10_temp_jun <- map_p10_temp + 
  ggtitle('P10 Temperature (June)') +
  geom_polygon(aes(fill = Jun), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.jun.map.v3.png', plot = map_p10_temp_jun, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jul
map_p10_temp_jul <- map_p10_temp + 
  ggtitle('P10 Temperature (July)') +
  geom_polygon(aes(fill = Jul), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.jul.map.v3.png', plot = map_p10_temp_jul, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- aug
map_p10_temp_aug <- map_p10_temp + 
  ggtitle('P10 Temperature (August)') +
  geom_polygon(aes(fill = Aug), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.aug.map.v3.png', plot = map_p10_temp_aug, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- sep
map_p10_temp_sep <- map_p10_temp + 
  ggtitle('P10 Temperature (September)') +
  geom_polygon(aes(fill = Sep), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.sep.map.v3.png', plot = map_p10_temp_sep, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- oct
map_p10_temp_oct <- map_p10_temp + 
  ggtitle('P10 Temperature (October)') +
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.oct.map.v3.png', plot = map_p10_temp_oct, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- nov
map_p10_temp_nov <- map_p10_temp + 
  ggtitle('P10 Temperature (November)') +
  geom_polygon(aes(fill = Nov), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.nov.map.v3.png', plot = map_p10_temp_nov, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- dec
map_p10_temp_dec <- map_p10_temp + 
  ggtitle('P10 Temperature (December)') +
  geom_polygon(aes(fill = Dec), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.dec.map.v3.png', plot = map_p10_temp_dec, width = 6.18, height = 3.68, units = 'in')

# NEEDS DOING FOR P10, P50, P90 AND PRCP/EVAP
lsegs.df_p50_prcp <- merge(lsegs.df, PRCP.ENS.50.PCT, by = 'FIPS_NHL')
map_p50_prcp <- ggplot(data = lsegs.df_p50_prcp, aes(x = long, y = lat, group = group))+
  geom_polygon(data = bbDF, color="black", fill = "powderblue",lwd=0.5)+
  geom_polygon(data = VADF, color="gray46", fill = "gray")+
  geom_polygon(data = TNDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = SCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = KYDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = WVDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = MDDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DEDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = PADF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NJDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = OHDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DCDF, color="gray46", fill = "gray", lwd=0.5)

# INDIVIDUAL METRIC MAP -- OVERALL
map_p50_prcp_overall <- map_p50_prcp + 
  ggtitle('P50 Precipitation (Overall)') +
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-20, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.overall.map.v3.png', plot = map_p50_prcp_overall, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jan
map_p50_prcp_jan <- map_p50_prcp + 
  ggtitle('P50 Precipitation (January)') +
  geom_polygon(aes(fill = Jan), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-20, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.jan.map.v3.png', plot = map_p50_prcp_jan, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- feb
map_p50_prcp_feb <- map_p50_prcp + 
  ggtitle('P50 Precipitation (February)') +
  geom_polygon(aes(fill = Feb), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-20, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.feb.map.v3.png', plot = map_p50_prcp_feb, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- mar
map_p50_prcp_mar <- map_p50_prcp + 
  ggtitle('P50 Precipitation (March)') +
  geom_polygon(aes(fill = Mar), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-20, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.mar.map.v3.png', plot = map_p50_prcp_mar, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- apr
map_p50_prcp_apr <- map_p50_prcp + 
  ggtitle('P50 Precipitation (April)') +
  geom_polygon(aes(fill = Apr), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-20, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.apr.map.v3.png', plot = map_p50_prcp_apr, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- may
map_p50_prcp_may <- map_p50_prcp + 
  ggtitle('P50 Precipitation (May)') +
  geom_polygon(aes(fill = May), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-20, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.may.map.v3.png', plot = map_p50_prcp_may, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jun
map_p50_prcp_jun <- map_p50_prcp + 
  ggtitle('P50 Precipitation (June)') +
  geom_polygon(aes(fill = Jun), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-20, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.jun.map.v3.png', plot = map_p50_prcp_jun, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jul
map_p50_prcp_jul <- map_p50_prcp + 
  ggtitle('P50 Precipitation (July)') +
  geom_polygon(aes(fill = Jul), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-20, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.jul.map.v3.png', plot = map_p50_prcp_jul, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- aug
map_p50_prcp_aug <- map_p50_prcp + 
  ggtitle('P50 Precipitation (August)') +
  geom_polygon(aes(fill = Aug), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-20, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.aug.map.v3.png', plot = map_p50_prcp_aug, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- sep
map_p50_prcp_sep <- map_p50_prcp + 
  ggtitle('P50 Precipitation (September)') +
  geom_polygon(aes(fill = Sep), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-20, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.sep.map.v3.png', plot = map_p50_prcp_sep, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- oct
map_p50_prcp_oct <- map_p50_prcp + 
  ggtitle('P50 Precipitation (October)') +
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-20, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.oct.map.v3.png', plot = map_p50_prcp_oct, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- nov
map_p50_prcp_nov <- map_p50_prcp + 
  ggtitle('P50 Precipitation (November)') +
  geom_polygon(aes(fill = Nov), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-20, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.nov.map.v3.png', plot = map_p50_prcp_nov, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- dec
map_p50_prcp_dec <- map_p50_prcp + 
  ggtitle('P50 Precipitation (December)') +
  geom_polygon(aes(fill = Dec), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-20, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.dec.map.v3.png', plot = map_p50_prcp_dec, width = 6.18, height = 3.68, units = 'in')

# p50 TEMP
lsegs.df_p50_temp <- merge(lsegs.df, TEMP.ENS.50.PCT, by = 'FIPS_NHL')
map_p50_temp <- ggplot(data = lsegs.df_p50_temp, aes(x = long, y = lat, group = group))+
  geom_polygon(data = bbDF, color="black", fill = "powderblue",lwd=0.5)+
  geom_polygon(data = VADF, color="gray46", fill = "gray")+
  geom_polygon(data = TNDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = SCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = KYDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = WVDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = MDDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DEDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = PADF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NJDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = OHDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DCDF, color="gray46", fill = "gray", lwd=0.5)

# INDIVIDUAL METRIC MAP -- OVERALL
map_p50_temp_overall <- map_p50_temp + 
  ggtitle('P50 Temperature (Overall)') +
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.overall.map.v3.png', plot = map_p50_temp_overall, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jan
map_p50_temp_jan <- map_p50_temp + 
  ggtitle('P50 Temperature (January)') +
  geom_polygon(aes(fill = Jan), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.jan.map.v3.png', plot = map_p50_temp_jan, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- feb
map_p50_temp_feb <- map_p50_temp + 
  ggtitle('P50 Temperature (February)') +
  geom_polygon(aes(fill = Feb), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.feb.map.v3.png', plot = map_p50_temp_feb, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- mar
map_p50_temp_mar <- map_p50_temp + 
  ggtitle('P50 Temperature (March)') +
  geom_polygon(aes(fill = Mar), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.mar.map.v3.png', plot = map_p50_temp_mar, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- apr
map_p50_temp_apr <- map_p50_temp + 
  ggtitle('P50 Temperature (April)') +
  geom_polygon(aes(fill = Apr), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.apr.map.v3.png', plot = map_p50_temp_apr, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- may
map_p50_temp_may <- map_p50_temp + 
  ggtitle('P50 Temperature (May)') +
  geom_polygon(aes(fill = May), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.may.map.v3.png', plot = map_p50_temp_may, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jun
map_p50_temp_jun <- map_p50_temp + 
  ggtitle('P50 Temperature (June)') +
  geom_polygon(aes(fill = Jun), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.jun.map.v3.png', plot = map_p50_temp_jun, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jul
map_p50_temp_jul <- map_p50_temp + 
  ggtitle('P50 Temperature (July)') +
  geom_polygon(aes(fill = Jul), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.jul.map.v3.png', plot = map_p50_temp_jul, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- aug
map_p50_temp_aug <- map_p50_temp + 
  ggtitle('P50 Temperature (August)') +
  geom_polygon(aes(fill = Aug), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.aug.map.v3.png', plot = map_p50_temp_aug, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- sep
map_p50_temp_sep <- map_p50_temp + 
  ggtitle('P50 Temperature (September)') +
  geom_polygon(aes(fill = Sep), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.sep.map.v3.png', plot = map_p50_temp_sep, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- oct
map_p50_temp_oct <- map_p50_temp + 
  ggtitle('P50 Temperature (October)') +
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.oct.map.v3.png', plot = map_p50_temp_oct, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- nov
map_p50_temp_nov <- map_p50_temp + 
  ggtitle('P50 Temperature (November)') +
  geom_polygon(aes(fill = Nov), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.nov.map.v3.png', plot = map_p50_temp_nov, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- dec
map_p50_temp_dec <- map_p50_temp + 
  ggtitle('P50 Temperature (December)') +
  geom_polygon(aes(fill = Dec), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.dec.map.v3.png', plot = map_p50_temp_dec, width = 6.18, height = 3.68, units = 'in')

# NEEDS DOING FOR P10, P50, P90 AND PRCP/EVAP
lsegs.df_p90_prcp <- merge(lsegs.df, PRCP.ENS.90.PCT, by = 'FIPS_NHL')
map_p90_prcp <- ggplot(data = lsegs.df_p90_prcp, aes(x = long, y = lat, group = group))+
  geom_polygon(data = bbDF, color="black", fill = "powderblue",lwd=0.5)+
  geom_polygon(data = VADF, color="gray46", fill = "gray")+
  geom_polygon(data = TNDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = SCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = KYDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = WVDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = MDDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DEDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = PADF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NJDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = OHDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DCDF, color="gray46", fill = "gray", lwd=0.5)

# INDIVIDUAL METRIC MAP -- OVERALL
map_p90_prcp_overall <- map_p90_prcp + 
  ggtitle('P90 Precipitation (Overall)') +
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 40)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.overall.map.v3.png', plot = map_p90_prcp_overall, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jan
map_p90_prcp_jan <- map_p90_prcp + 
  ggtitle('P90 Precipitation (January)') +
  geom_polygon(aes(fill = Jan), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 40)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.jan.map.v3.png', plot = map_p90_prcp_jan, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- feb
map_p90_prcp_feb <- map_p90_prcp + 
  ggtitle('P90 Precipitation (February)') +
  geom_polygon(aes(fill = Feb), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 40)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.feb.map.v3.png', plot = map_p90_prcp_feb, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- mar
map_p90_prcp_mar <- map_p90_prcp + 
  ggtitle('P90 Precipitation (March)') +
  geom_polygon(aes(fill = Mar), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 40)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.mar.map.v3.png', plot = map_p90_prcp_mar, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- apr
map_p90_prcp_apr <- map_p90_prcp + 
  ggtitle('P90 Precipitation (April)') +
  geom_polygon(aes(fill = Apr), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 40)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.apr.map.v3.png', plot = map_p90_prcp_apr, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- may
map_p90_prcp_may <- map_p90_prcp + 
  ggtitle('P90 Precipitation (May)') +
  geom_polygon(aes(fill = May), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 40)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.may.map.v3.png', plot = map_p90_prcp_may, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jun
map_p90_prcp_jun <- map_p90_prcp + 
  ggtitle('P90 Precipitation (June)') +
  geom_polygon(aes(fill = Jun), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 40)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.jun.map.v3.png', plot = map_p90_prcp_jun, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jul
map_p90_prcp_jul <- map_p90_prcp + 
  ggtitle('P90 Precipitation (July)') +
  geom_polygon(aes(fill = Jul), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 40)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.jul.map.v3.png', plot = map_p90_prcp_jul, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- aug
map_p90_prcp_aug <- map_p90_prcp + 
  ggtitle('P90 Precipitation (August)') +
  geom_polygon(aes(fill = Aug), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 40)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.aug.map.v3.png', plot = map_p90_prcp_aug, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- sep
map_p90_prcp_sep <- map_p90_prcp + 
  ggtitle('P90 Precipitation (September)') +
  geom_polygon(aes(fill = Sep), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 40)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.sep.map.v3.png', plot = map_p90_prcp_sep, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- oct
map_p90_prcp_oct <- map_p90_prcp + 
  ggtitle('P90 Precipitation (October)') +
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 40)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.oct.map.v3.png', plot = map_p90_prcp_oct, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- nov
map_p90_prcp_nov <- map_p90_prcp + 
  ggtitle('P90 Precipitation (November)') +
  geom_polygon(aes(fill = Nov), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 40)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.nov.map.v3.png', plot = map_p90_prcp_nov, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- dec
map_p90_prcp_dec <- map_p90_prcp + 
  ggtitle('P90 Precipitation (December)') +
  geom_polygon(aes(fill = Dec), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 40)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.dec.map.v3.png', plot = map_p90_prcp_dec, width = 6.18, height = 3.68, units = 'in')

# p90 TEMP
lsegs.df_p90_temp <- merge(lsegs.df, TEMP.ENS.90.PCT, by = 'FIPS_NHL')
map_p90_temp <- ggplot(data = lsegs.df_p90_temp, aes(x = long, y = lat, group = group))+
  geom_polygon(data = bbDF, color="black", fill = "powderblue",lwd=0.5)+
  geom_polygon(data = VADF, color="gray46", fill = "gray")+
  geom_polygon(data = TNDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = SCDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = KYDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = WVDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = MDDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DEDF, color="gray46", fill = "gray", lwd=0.5)+
  #geom_polygon(data = PADF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = NJDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = OHDF, color="gray46", fill = "gray", lwd=0.5)+
  geom_polygon(data = DCDF, color="gray46", fill = "gray", lwd=0.5)

# INDIVIDUAL METRIC MAP -- OVERALL
map_p90_temp_overall <- map_p90_temp + 
  ggtitle('P90 Temperature (Overall)') +
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.overall.map.v3.png', plot = map_p90_temp_overall, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jan
map_p90_temp_jan <- map_p90_temp + 
  ggtitle('P90 Temperature (January)') +
  geom_polygon(aes(fill = Jan), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.jan.map.v3.png', plot = map_p90_temp_jan, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- feb
map_p90_temp_feb <- map_p90_temp + 
  ggtitle('P90 Temperature (February)') +
  geom_polygon(aes(fill = Feb), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.feb.map.v3.png', plot = map_p90_temp_feb, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- mar
map_p90_temp_mar <- map_p90_temp + 
  ggtitle('P90 Temperature (March)') +
  geom_polygon(aes(fill = Mar), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.mar.map.v3.png', plot = map_p90_temp_mar, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- apr
map_p90_temp_apr <- map_p90_temp + 
  ggtitle('P90 Temperature (April)') +
  geom_polygon(aes(fill = Apr), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.apr.map.v3.png', plot = map_p90_temp_apr, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- may
map_p90_temp_may <- map_p90_temp + 
  ggtitle('P90 Temperature (May)') +
  geom_polygon(aes(fill = May), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.may.map.v3.png', plot = map_p90_temp_may, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jun
map_p90_temp_jun <- map_p90_temp + 
  ggtitle('P90 Temperature (June)') +
  geom_polygon(aes(fill = Jun), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.jun.map.v3.png', plot = map_p90_temp_jun, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- jul
map_p90_temp_jul <- map_p90_temp + 
  ggtitle('P90 Temperature (July)') +
  geom_polygon(aes(fill = Jul), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.jul.map.v3.png', plot = map_p90_temp_jul, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- aug
map_p90_temp_aug <- map_p90_temp + 
  ggtitle('P90 Temperature (August)') +
  geom_polygon(aes(fill = Aug), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.aug.map.v3.png', plot = map_p90_temp_aug, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- sep
map_p90_temp_sep <- map_p90_temp + 
  ggtitle('P90 Temperature (September)') +
  geom_polygon(aes(fill = Sep), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.sep.map.v3.png', plot = map_p90_temp_sep, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- oct
map_p90_temp_oct <- map_p90_temp + 
  ggtitle('P90 Temperature (October)') +
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.oct.map.v3.png', plot = map_p90_temp_oct, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- nov
map_p90_temp_nov <- map_p90_temp + 
  ggtitle('P90 Temperature (November)') +
  geom_polygon(aes(fill = Nov), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.nov.map.v3.png', plot = map_p90_temp_nov, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- dec
map_p90_temp_dec <- map_p90_temp + 
  ggtitle('P90 Temperature (December)') +
  geom_polygon(aes(fill = Dec), color = 'black', size = 0.1) +
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0, 4)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.dec.map.v3.png', plot = map_p90_temp_dec, width = 6.18, height = 3.68, units = 'in')

library(gridExtra)

jpeg('p10_prcp.jpeg', width = 1300, height = 1548)
p10_prcp <- grid.arrange(grobs = list(
  map_p10_prcp_jan, map_p10_prcp_feb, map_p10_prcp_mar,
  map_p10_prcp_apr, map_p10_prcp_may, map_p10_prcp_jun,
  map_p10_prcp_jul, map_p10_prcp_aug, map_p10_prcp_sep,
  map_p10_prcp_oct, map_p10_prcp_nov, map_p10_prcp_dec,
  map_p10_prcp_overall),
  widths = c(1.25,1.25,1.25,1.25,1.25,1.25),
  layout_matrix = rbind(c(1,1,2,2,3,3),
                        c(4,4,5,5,6,6),
                        c(7,7,8,8,9,9),
                        c(10,10,11,11,12,12),
                        c(NA,13,13,13,13,NA),
                        c(NA,13,13,13,13,NA))
)
dev.off()

jpeg('p10_temp.jpeg', width = 1300, height = 1548)
p10_temp <- grid.arrange(grobs = list(
  map_p10_temp_jan, map_p10_temp_feb, map_p10_temp_mar,
  map_p10_temp_apr, map_p10_temp_may, map_p10_temp_jun,
  map_p10_temp_jul, map_p10_temp_aug, map_p10_temp_sep,
  map_p10_temp_oct, map_p10_temp_nov, map_p10_temp_dec,
  map_p10_temp_overall),
  widths = c(1.25,1.25,1.25,1.25,1.25,1.25),
  layout_matrix = rbind(c(1,1,2,2,3,3),
                        c(4,4,5,5,6,6),
                        c(7,7,8,8,9,9),
                        c(10,10,11,11,12,12),
                        c(NA,13,13,13,13,NA),
                        c(NA,13,13,13,13,NA))
)
dev.off()

jpeg('p50_prcp.jpeg', width = 1300, height = 1548)
p50_prcp <- grid.arrange(grobs = list(
  map_p50_prcp_jan, map_p50_prcp_feb, map_p50_prcp_mar,
  map_p50_prcp_apr, map_p50_prcp_may, map_p50_prcp_jun,
  map_p50_prcp_jul, map_p50_prcp_aug, map_p50_prcp_sep,
  map_p50_prcp_oct, map_p50_prcp_nov, map_p50_prcp_dec,
  map_p50_prcp_overall),
  widths = c(1.25,1.25,1.25,1.25,1.25,1.25),
  layout_matrix = rbind(c(1,1,2,2,3,3),
                        c(4,4,5,5,6,6),
                        c(7,7,8,8,9,9),
                        c(10,10,11,11,12,12),
                        c(NA,13,13,13,13,NA),
                        c(NA,13,13,13,13,NA))
)
dev.off()

jpeg('p50_temp.jpeg', width = 1300, height = 1548)
p50_temp <- grid.arrange(grobs = list(
  map_p50_temp_jan, map_p50_temp_feb, map_p50_temp_mar,
  map_p50_temp_apr, map_p50_temp_may, map_p50_temp_jun,
  map_p50_temp_jul, map_p50_temp_aug, map_p50_temp_sep,
  map_p50_temp_oct, map_p50_temp_nov, map_p50_temp_dec,
  map_p50_temp_overall),
  widths = c(1.25,1.25,1.25,1.25,1.25,1.25),
  layout_matrix = rbind(c(1,1,2,2,3,3),
                        c(4,4,5,5,6,6),
                        c(7,7,8,8,9,9),
                        c(10,10,11,11,12,12),
                        c(NA,13,13,13,13,NA),
                        c(NA,13,13,13,13,NA))
)
dev.off()

jpeg('p90_prcp.jpeg', width = 1300, height = 1548)
p90_prcp <- grid.arrange(grobs = list(
  map_p90_prcp_jan, map_p90_prcp_feb, map_p90_prcp_mar,
  map_p90_prcp_apr, map_p90_prcp_may, map_p90_prcp_jun,
  map_p90_prcp_jul, map_p90_prcp_aug, map_p90_prcp_sep,
  map_p90_prcp_oct, map_p90_prcp_nov, map_p90_prcp_dec,
  map_p90_prcp_overall),
  widths = c(1.25,1.25,1.25,1.25,1.25,1.25),
  layout_matrix = rbind(c(1,1,2,2,3,3),
                        c(4,4,5,5,6,6),
                        c(7,7,8,8,9,9),
                        c(10,10,11,11,12,12),
                        c(NA,13,13,13,13,NA),
                        c(NA,13,13,13,13,NA))
)
dev.off()

jpeg('p90_temp.jpeg', width = 1300, height = 1548)
p90_temp <- grid.arrange(grobs = list(
  map_p90_temp_jan, map_p90_temp_feb, map_p90_temp_mar,
  map_p90_temp_apr, map_p90_temp_may, map_p90_temp_jun,
  map_p90_temp_jul, map_p90_temp_aug, map_p90_temp_sep,
  map_p90_temp_oct, map_p90_temp_nov, map_p90_temp_dec,
  map_p90_temp_overall),
  widths = c(1.25,1.25,1.25,1.25,1.25,1.25),
  layout_matrix = rbind(c(1,1,2,2,3,3),
                        c(4,4,5,5,6,6),
                        c(7,7,8,8,9,9),
                        c(10,10,11,11,12,12),
                        c(NA,13,13,13,13,NA),
                        c(NA,13,13,13,13,NA))
)
dev.off()

uni_map_p10_prcp_overall <- map_p10_prcp + 
  ggtitle('P10 Precipitation (Overall)') +
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-5, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))

uni_map_p50_prcp_overall <- map_p50_prcp + 
  ggtitle('P50 Precipitation (Overall)') +
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-5, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))

uni_map_p90_prcp_overall <- map_p90_prcp + 
  ggtitle('P90 Precipitation (Overall)') +
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-5, 20)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))

uni_map_p10_temp_overall <- map_p10_temp + 
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(1, 3.5)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))

uni_map_p50_temp_overall <- map_p50_temp + 
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(1, 3.5)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))

uni_map_p90_temp_overall <- map_p90_temp + 
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(1, 3.5)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))

jpeg('compare_scen_prcp.jpeg', width = 1300, height = 258)
compare_prcp <- grid.arrange(grobs = list(
  uni_map_p10_prcp_overall, uni_map_p50_prcp_overall, uni_map_p90_prcp_overall),
  widths = c(1.25,1.25,1.25),
  layout_matrix = rbind(c(1,2,3))
)
dev.off()

jpeg('compare_scen_temp.jpeg', width = 1300, height = 258)
compare_temp <- grid.arrange(grobs = list(
  uni_map_p10_temp_overall, uni_map_p50_temp_overall, uni_map_p90_temp_overall),
  widths = c(1.25,1.25,1.25),
  layout_matrix = rbind(c(1,2,3))
)
dev.off()

uni_map_p10_prcp_oct <- map_p10_prcp + 
  ggtitle('P10 Precipitation (October)') +
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-30, 30)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))

uni_map_p50_prcp_oct <- map_p50_prcp + 
  ggtitle('P50 Precipitation (October)') +
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-30, 30)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))

uni_map_p90_prcp_oct <- map_p90_prcp + 
  ggtitle('P90 Precipitation (October)') +
  geom_polygon(aes(fill = Oct), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-30, 30)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))

jpeg('compare_scen_prcp_oct.jpeg', width = 1300, height = 258)
compare_prcp <- grid.arrange(grobs = list(
  uni_map_p10_prcp_oct, uni_map_p50_prcp_oct, uni_map_p90_prcp_oct),
  widths = c(1.25,1.25,1.25),
  layout_matrix = rbind(c(1,2,3))
)
dev.off()

fin_map_p10_temp_feb <- map_p10_temp + 
  ggtitle('P10 Temperature (February)') +
  geom_polygon(aes(fill = Feb), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_continuous(low = 'white', high = 'orange') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.feb.map.v3.fin.png', plot = fin_map_p10_temp_feb, width = 6.18, height = 3.68, units = 'in')

p10_prcp_tab <- as.data.frame(matrix(data = NA, nrow = 13, ncol = 6))
colnames(p10_prcp_tab) <- c('Month', 'Lowest Change (%)', 'Median Change (%)', 'Highest Change (%)', 'Range of Change (%)', 'Average Change (%)')
p10_prcp_tab$Month <- c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Total')
p10_prcp_tab$`Lowest Change (%)` <- c(round(min(lsegs.df_p10_prcp$Jan), 1),
                                  round(min(lsegs.df_p10_prcp$Feb), 1),
                                  round(min(lsegs.df_p10_prcp$Mar), 1),
                                  round(min(lsegs.df_p10_prcp$Apr), 1),
                                  round(min(lsegs.df_p10_prcp$May), 1),
                                  round(min(lsegs.df_p10_prcp$Jun), 1),
                                  round(min(lsegs.df_p10_prcp$Jul), 1),
                                  round(min(lsegs.df_p10_prcp$Aug), 1),
                                  round(min(lsegs.df_p10_prcp$Sep), 1),
                                  round(min(lsegs.df_p10_prcp$Oct), 1),
                                  round(min(lsegs.df_p10_prcp$Nov), 1),
                                  round(min(lsegs.df_p10_prcp$Dec), 1),
                                  round(min(lsegs.df_p10_prcp$Total), 1))
p10_prcp_tab$`Median Change (%)` <- c(round(median(lsegs.df_p10_prcp$Jan), 1),
                                      round(median(lsegs.df_p10_prcp$Feb), 1),
                                      round(median(lsegs.df_p10_prcp$Mar), 1),
                                      round(median(lsegs.df_p10_prcp$Apr), 1),
                                      round(median(lsegs.df_p10_prcp$May), 1),
                                      round(median(lsegs.df_p10_prcp$Jun), 1),
                                      round(median(lsegs.df_p10_prcp$Jul), 1),
                                      round(median(lsegs.df_p10_prcp$Aug), 1),
                                      round(median(lsegs.df_p10_prcp$Sep), 1),
                                      round(median(lsegs.df_p10_prcp$Oct), 1),
                                      round(median(lsegs.df_p10_prcp$Nov), 1),
                                      round(median(lsegs.df_p10_prcp$Dec), 1),
                                      round(median(lsegs.df_p10_prcp$Total), 1))
p10_prcp_tab$`Highest Change (%)` <- c(round(max(lsegs.df_p10_prcp$Jan), 1),
                                  round(max(lsegs.df_p10_prcp$Feb), 1),
                                  round(max(lsegs.df_p10_prcp$Mar), 1),
                                  round(max(lsegs.df_p10_prcp$Apr), 1),
                                  round(max(lsegs.df_p10_prcp$May), 1),
                                  round(max(lsegs.df_p10_prcp$Jun), 1),
                                  round(max(lsegs.df_p10_prcp$Jul), 1),
                                  round(max(lsegs.df_p10_prcp$Aug), 1),
                                  round(max(lsegs.df_p10_prcp$Sep), 1),
                                  round(max(lsegs.df_p10_prcp$Oct), 1),
                                  round(max(lsegs.df_p10_prcp$Nov), 1),
                                  round(max(lsegs.df_p10_prcp$Dec), 1),
                                  round(max(lsegs.df_p10_prcp$Total), 1))
p10_prcp_tab$`Range of Change (%)` <- p10_prcp_tab$`Highest Change (%)` - p10_prcp_tab$`Lowest Change (%)`
p10_prcp_tab$`Average Change (%)` <- c(round(mean(lsegs.df_p10_prcp$Jan), 1),
                                      round(mean(lsegs.df_p10_prcp$Feb), 1),
                                      round(mean(lsegs.df_p10_prcp$Mar), 1),
                                      round(mean(lsegs.df_p10_prcp$Apr), 1),
                                      round(mean(lsegs.df_p10_prcp$May), 1),
                                      round(mean(lsegs.df_p10_prcp$Jun), 1),
                                      round(mean(lsegs.df_p10_prcp$Jul), 1),
                                      round(mean(lsegs.df_p10_prcp$Aug), 1),
                                      round(mean(lsegs.df_p10_prcp$Sep), 1),
                                      round(mean(lsegs.df_p10_prcp$Oct), 1),
                                      round(mean(lsegs.df_p10_prcp$Nov), 1),
                                      round(mean(lsegs.df_p10_prcp$Dec), 1),
                                      round(mean(lsegs.df_p10_prcp$Total), 1))

# OUTPUT TABLE IN KABLE FORMAT
kable(p10_prcp_tab, "latex", booktabs = T,
      caption = paste("P10 Precipitation Changes"), 
      label = paste("P10 Precipitation Changes"),
      col.names = c('Month', 'Lowest Change (%)', 'Median Change (%)', 'Highest Change (%)', 'Range of Change (%)', 'Average Change (%)')) %>%
  kable_styling(latex_options = c("striped", "scale_down")) %>% 
  #column_spec(1, width = "5em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste(dir.location,"/kable_tables/","P10_Precip.tex",sep=""))

p50_prcp_tab <- as.data.frame(matrix(data = NA, nrow = 13, ncol = 6))
colnames(p50_prcp_tab) <- c('Month', 'Lowest Change (%)', 'Median Change (%)', 'Highest Change (%)', 'Range of Change (%)', 'Average Change (%)')
p50_prcp_tab$Month <- c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Total')
p50_prcp_tab$`Lowest Change (%)` <- c(round(min(lsegs.df_p50_prcp$Jan), 1),
                                      round(min(lsegs.df_p50_prcp$Feb), 1),
                                      round(min(lsegs.df_p50_prcp$Mar), 1),
                                      round(min(lsegs.df_p50_prcp$Apr), 1),
                                      round(min(lsegs.df_p50_prcp$May), 1),
                                      round(min(lsegs.df_p50_prcp$Jun), 1),
                                      round(min(lsegs.df_p50_prcp$Jul), 1),
                                      round(min(lsegs.df_p50_prcp$Aug), 1),
                                      round(min(lsegs.df_p50_prcp$Sep), 1),
                                      round(min(lsegs.df_p50_prcp$Oct), 1),
                                      round(min(lsegs.df_p50_prcp$Nov), 1),
                                      round(min(lsegs.df_p50_prcp$Dec), 1),
                                      round(min(lsegs.df_p50_prcp$Total), 1))
p50_prcp_tab$`Median Change (%)` <- c(round(median(lsegs.df_p50_prcp$Jan), 1),
                                      round(median(lsegs.df_p50_prcp$Feb), 1),
                                      round(median(lsegs.df_p50_prcp$Mar), 1),
                                      round(median(lsegs.df_p50_prcp$Apr), 1),
                                      round(median(lsegs.df_p50_prcp$May), 1),
                                      round(median(lsegs.df_p50_prcp$Jun), 1),
                                      round(median(lsegs.df_p50_prcp$Jul), 1),
                                      round(median(lsegs.df_p50_prcp$Aug), 1),
                                      round(median(lsegs.df_p50_prcp$Sep), 1),
                                      round(median(lsegs.df_p50_prcp$Oct), 1),
                                      round(median(lsegs.df_p50_prcp$Nov), 1),
                                      round(median(lsegs.df_p50_prcp$Dec), 1),
                                      round(median(lsegs.df_p50_prcp$Total), 1))
p50_prcp_tab$`Highest Change (%)` <- c(round(max(lsegs.df_p50_prcp$Jan), 1),
                                       round(max(lsegs.df_p50_prcp$Feb), 1),
                                       round(max(lsegs.df_p50_prcp$Mar), 1),
                                       round(max(lsegs.df_p50_prcp$Apr), 1),
                                       round(max(lsegs.df_p50_prcp$May), 1),
                                       round(max(lsegs.df_p50_prcp$Jun), 1),
                                       round(max(lsegs.df_p50_prcp$Jul), 1),
                                       round(max(lsegs.df_p50_prcp$Aug), 1),
                                       round(max(lsegs.df_p50_prcp$Sep), 1),
                                       round(max(lsegs.df_p50_prcp$Oct), 1),
                                       round(max(lsegs.df_p50_prcp$Nov), 1),
                                       round(max(lsegs.df_p50_prcp$Dec), 1),
                                       round(max(lsegs.df_p50_prcp$Total), 1))
p50_prcp_tab$`Range of Change (%)` <- p50_prcp_tab$`Highest Change (%)` - p50_prcp_tab$`Lowest Change (%)`
p50_prcp_tab$`Average Change (%)` <- c(round(mean(lsegs.df_p50_prcp$Jan), 1),
                                       round(mean(lsegs.df_p50_prcp$Feb), 1),
                                       round(mean(lsegs.df_p50_prcp$Mar), 1),
                                       round(mean(lsegs.df_p50_prcp$Apr), 1),
                                       round(mean(lsegs.df_p50_prcp$May), 1),
                                       round(mean(lsegs.df_p50_prcp$Jun), 1),
                                       round(mean(lsegs.df_p50_prcp$Jul), 1),
                                       round(mean(lsegs.df_p50_prcp$Aug), 1),
                                       round(mean(lsegs.df_p50_prcp$Sep), 1),
                                       round(mean(lsegs.df_p50_prcp$Oct), 1),
                                       round(mean(lsegs.df_p50_prcp$Nov), 1),
                                       round(mean(lsegs.df_p50_prcp$Dec), 1),
                                       round(mean(lsegs.df_p50_prcp$Total), 1))

# OUTPUT TABLE IN KABLE FORMAT
kable(p50_prcp_tab, "latex", booktabs = T,
      caption = paste("P50 Precipitation Changes"), 
      label = paste("P50 Precipitation Changes"),
      col.names = c('Month', 'Lowest Change (%)', 'Median Change (%)', 'Highest Change (%)', 'Range of Change (%)', 'Average Change (%)')) %>%
  kable_styling(latex_options = c("striped", "scale_down")) %>% 
  #column_spec(1, width = "5em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste(dir.location,"/kable_tables/","P50_Precip.tex",sep=""))

p90_prcp_tab <- as.data.frame(matrix(data = NA, nrow = 13, ncol = 6))
colnames(p90_prcp_tab) <- c('Month', 'Lowest Change (%)', 'Median Change (%)', 'Highest Change (%)', 'Range of Change (%)', 'Average Change (%)')
p90_prcp_tab$Month <- c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Total')
p90_prcp_tab$`Lowest Change (%)` <- c(round(min(lsegs.df_p90_prcp$Jan), 1),
                                      round(min(lsegs.df_p90_prcp$Feb), 1),
                                      round(min(lsegs.df_p90_prcp$Mar), 1),
                                      round(min(lsegs.df_p90_prcp$Apr), 1),
                                      round(min(lsegs.df_p90_prcp$May), 1),
                                      round(min(lsegs.df_p90_prcp$Jun), 1),
                                      round(min(lsegs.df_p90_prcp$Jul), 1),
                                      round(min(lsegs.df_p90_prcp$Aug), 1),
                                      round(min(lsegs.df_p90_prcp$Sep), 1),
                                      round(min(lsegs.df_p90_prcp$Oct), 1),
                                      round(min(lsegs.df_p90_prcp$Nov), 1),
                                      round(min(lsegs.df_p90_prcp$Dec), 1),
                                      round(min(lsegs.df_p90_prcp$Total), 1))
p90_prcp_tab$`Median Change (%)` <- c(round(median(lsegs.df_p90_prcp$Jan), 1),
                                      round(median(lsegs.df_p90_prcp$Feb), 1),
                                      round(median(lsegs.df_p90_prcp$Mar), 1),
                                      round(median(lsegs.df_p90_prcp$Apr), 1),
                                      round(median(lsegs.df_p90_prcp$May), 1),
                                      round(median(lsegs.df_p90_prcp$Jun), 1),
                                      round(median(lsegs.df_p90_prcp$Jul), 1),
                                      round(median(lsegs.df_p90_prcp$Aug), 1),
                                      round(median(lsegs.df_p90_prcp$Sep), 1),
                                      round(median(lsegs.df_p90_prcp$Oct), 1),
                                      round(median(lsegs.df_p90_prcp$Nov), 1),
                                      round(median(lsegs.df_p90_prcp$Dec), 1),
                                      round(median(lsegs.df_p90_prcp$Total), 1))
p90_prcp_tab$`Highest Change (%)` <- c(round(max(lsegs.df_p90_prcp$Jan), 1),
                                       round(max(lsegs.df_p90_prcp$Feb), 1),
                                       round(max(lsegs.df_p90_prcp$Mar), 1),
                                       round(max(lsegs.df_p90_prcp$Apr), 1),
                                       round(max(lsegs.df_p90_prcp$May), 1),
                                       round(max(lsegs.df_p90_prcp$Jun), 1),
                                       round(max(lsegs.df_p90_prcp$Jul), 1),
                                       round(max(lsegs.df_p90_prcp$Aug), 1),
                                       round(max(lsegs.df_p90_prcp$Sep), 1),
                                       round(max(lsegs.df_p90_prcp$Oct), 1),
                                       round(max(lsegs.df_p90_prcp$Nov), 1),
                                       round(max(lsegs.df_p90_prcp$Dec), 1),
                                       round(max(lsegs.df_p90_prcp$Total), 1))
p90_prcp_tab$`Range of Change (%)` <- p90_prcp_tab$`Highest Change (%)` - p90_prcp_tab$`Lowest Change (%)`
p90_prcp_tab$`Average Change (%)` <- c(round(mean(lsegs.df_p90_prcp$Jan), 1),
                                       round(mean(lsegs.df_p90_prcp$Feb), 1),
                                       round(mean(lsegs.df_p90_prcp$Mar), 1),
                                       round(mean(lsegs.df_p90_prcp$Apr), 1),
                                       round(mean(lsegs.df_p90_prcp$May), 1),
                                       round(mean(lsegs.df_p90_prcp$Jun), 1),
                                       round(mean(lsegs.df_p90_prcp$Jul), 1),
                                       round(mean(lsegs.df_p90_prcp$Aug), 1),
                                       round(mean(lsegs.df_p90_prcp$Sep), 1),
                                       round(mean(lsegs.df_p90_prcp$Oct), 1),
                                       round(mean(lsegs.df_p90_prcp$Nov), 1),
                                       round(mean(lsegs.df_p90_prcp$Dec), 1),
                                       round(mean(lsegs.df_p90_prcp$Total), 1))

# OUTPUT TABLE IN KABLE FORMAT
kable(p90_prcp_tab, "latex", booktabs = T,
      caption = paste("P90 Precipitation Changes"), 
      label = paste("P90 Precipitation Changes"),
      col.names = c('Month', 'Lowest Change (%)', 'Median Change (%)', 'Highest Change (%)', 'Range of Change (%)', 'Average Change (%)')) %>%
  kable_styling(latex_options = c("striped", "scale_down")) %>% 
  #column_spec(1, width = "5em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste(dir.location,"/kable_tables/","P90_Precip.tex",sep=""))


p10_temp_tab <- as.data.frame(matrix(data = NA, nrow = 13, ncol = 6))
colnames(p10_temp_tab) <- c('Month', 'Lowest Change (%)', 'Median Change (%)', 'Highest Change (%)', 'Range of Change (%)', 'Average Change (%)')
p10_temp_tab$Month <- c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Total')
p10_temp_tab$`Lowest Change (%)` <- c(round(min(lsegs.df_p10_temp$Jan), 2),
                                      round(min(lsegs.df_p10_temp$Feb), 2),
                                      round(min(lsegs.df_p10_temp$Mar), 2),
                                      round(min(lsegs.df_p10_temp$Apr), 2),
                                      round(min(lsegs.df_p10_temp$May), 2),
                                      round(min(lsegs.df_p10_temp$Jun), 2),
                                      round(min(lsegs.df_p10_temp$Jul), 2),
                                      round(min(lsegs.df_p10_temp$Aug), 2),
                                      round(min(lsegs.df_p10_temp$Sep), 2),
                                      round(min(lsegs.df_p10_temp$Oct), 2),
                                      round(min(lsegs.df_p10_temp$Nov), 2),
                                      round(min(lsegs.df_p10_temp$Dec), 2),
                                      round(min(lsegs.df_p10_temp$Total), 2))
p10_temp_tab$`Median Change (%)` <- c(round(median(lsegs.df_p10_temp$Jan), 2),
                                      round(median(lsegs.df_p10_temp$Feb), 2),
                                      round(median(lsegs.df_p10_temp$Mar), 2),
                                      round(median(lsegs.df_p10_temp$Apr), 2),
                                      round(median(lsegs.df_p10_temp$May), 2),
                                      round(median(lsegs.df_p10_temp$Jun), 2),
                                      round(median(lsegs.df_p10_temp$Jul), 2),
                                      round(median(lsegs.df_p10_temp$Aug), 2),
                                      round(median(lsegs.df_p10_temp$Sep), 2),
                                      round(median(lsegs.df_p10_temp$Oct), 2),
                                      round(median(lsegs.df_p10_temp$Nov), 2),
                                      round(median(lsegs.df_p10_temp$Dec), 2),
                                      round(median(lsegs.df_p10_temp$Total), 2))
p10_temp_tab$`Highest Change (%)` <- c(round(max(lsegs.df_p10_temp$Jan), 2),
                                       round(max(lsegs.df_p10_temp$Feb), 2),
                                       round(max(lsegs.df_p10_temp$Mar), 2),
                                       round(max(lsegs.df_p10_temp$Apr), 2),
                                       round(max(lsegs.df_p10_temp$May), 2),
                                       round(max(lsegs.df_p10_temp$Jun), 2),
                                       round(max(lsegs.df_p10_temp$Jul), 2),
                                       round(max(lsegs.df_p10_temp$Aug), 2),
                                       round(max(lsegs.df_p10_temp$Sep), 2),
                                       round(max(lsegs.df_p10_temp$Oct), 2),
                                       round(max(lsegs.df_p10_temp$Nov), 2),
                                       round(max(lsegs.df_p10_temp$Dec), 2),
                                       round(max(lsegs.df_p10_temp$Total), 2))
p10_temp_tab$`Range of Change (%)` <- p10_temp_tab$`Highest Change (%)` - p10_temp_tab$`Lowest Change (%)`
p10_temp_tab$`Average Change (%)` <- c(round(mean(lsegs.df_p10_temp$Jan), 2),
                                       round(mean(lsegs.df_p10_temp$Feb), 2),
                                       round(mean(lsegs.df_p10_temp$Mar), 2),
                                       round(mean(lsegs.df_p10_temp$Apr), 2),
                                       round(mean(lsegs.df_p10_temp$May), 2),
                                       round(mean(lsegs.df_p10_temp$Jun), 2),
                                       round(mean(lsegs.df_p10_temp$Jul), 2),
                                       round(mean(lsegs.df_p10_temp$Aug), 2),
                                       round(mean(lsegs.df_p10_temp$Sep), 2),
                                       round(mean(lsegs.df_p10_temp$Oct), 2),
                                       round(mean(lsegs.df_p10_temp$Nov), 2),
                                       round(mean(lsegs.df_p10_temp$Dec), 2),
                                       round(mean(lsegs.df_p10_temp$Total), 2))

# OUTPUT TABLE IN KABLE FORMAT
kable(p10_temp_tab, "latex", booktabs = T,
      caption = paste("P10 Temperature Changes"), 
      label = paste("P10 Temperature Changes"),
      col.names = c('Month', 'Lowest Change (degree C)', 'Median Change (degree C)', 'Highest Change (degree C)', 'Range of Change (degree C)', 'Average Change (degree C)')) %>%
  kable_styling(latex_options = c("striped", "scale_down")) %>% 
  #column_spec(1, width = "5em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste(dir.location,"/kable_tables/","P10_Temp.tex",sep=""))

p50_temp_tab <- as.data.frame(matrix(data = NA, nrow = 13, ncol = 6))
colnames(p50_temp_tab) <- c('Month', 'Lowest Change (%)', 'Median Change (%)', 'Highest Change (%)', 'Range of Change (%)', 'Average Change (%)')
p50_temp_tab$Month <- c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Total')
p50_temp_tab$`Lowest Change (%)` <- c(round(min(lsegs.df_p50_temp$Jan), 2),
                                      round(min(lsegs.df_p50_temp$Feb), 2),
                                      round(min(lsegs.df_p50_temp$Mar), 2),
                                      round(min(lsegs.df_p50_temp$Apr), 2),
                                      round(min(lsegs.df_p50_temp$May), 2),
                                      round(min(lsegs.df_p50_temp$Jun), 2),
                                      round(min(lsegs.df_p50_temp$Jul), 2),
                                      round(min(lsegs.df_p50_temp$Aug), 2),
                                      round(min(lsegs.df_p50_temp$Sep), 2),
                                      round(min(lsegs.df_p50_temp$Oct), 2),
                                      round(min(lsegs.df_p50_temp$Nov), 2),
                                      round(min(lsegs.df_p50_temp$Dec), 2),
                                      round(min(lsegs.df_p50_temp$Total), 2))
p50_temp_tab$`Median Change (%)` <- c(round(median(lsegs.df_p50_temp$Jan), 2),
                                      round(median(lsegs.df_p50_temp$Feb), 2),
                                      round(median(lsegs.df_p50_temp$Mar), 2),
                                      round(median(lsegs.df_p50_temp$Apr), 2),
                                      round(median(lsegs.df_p50_temp$May), 2),
                                      round(median(lsegs.df_p50_temp$Jun), 2),
                                      round(median(lsegs.df_p50_temp$Jul), 2),
                                      round(median(lsegs.df_p50_temp$Aug), 2),
                                      round(median(lsegs.df_p50_temp$Sep), 2),
                                      round(median(lsegs.df_p50_temp$Oct), 2),
                                      round(median(lsegs.df_p50_temp$Nov), 2),
                                      round(median(lsegs.df_p50_temp$Dec), 2),
                                      round(median(lsegs.df_p50_temp$Total), 2))
p50_temp_tab$`Highest Change (%)` <- c(round(max(lsegs.df_p50_temp$Jan), 2),
                                       round(max(lsegs.df_p50_temp$Feb), 2),
                                       round(max(lsegs.df_p50_temp$Mar), 2),
                                       round(max(lsegs.df_p50_temp$Apr), 2),
                                       round(max(lsegs.df_p50_temp$May), 2),
                                       round(max(lsegs.df_p50_temp$Jun), 2),
                                       round(max(lsegs.df_p50_temp$Jul), 2),
                                       round(max(lsegs.df_p50_temp$Aug), 2),
                                       round(max(lsegs.df_p50_temp$Sep), 2),
                                       round(max(lsegs.df_p50_temp$Oct), 2),
                                       round(max(lsegs.df_p50_temp$Nov), 2),
                                       round(max(lsegs.df_p50_temp$Dec), 2),
                                       round(max(lsegs.df_p50_temp$Total), 2))
p50_temp_tab$`Range of Change (%)` <- p50_temp_tab$`Highest Change (%)` - p50_temp_tab$`Lowest Change (%)`
p50_temp_tab$`Average Change (%)` <- c(round(mean(lsegs.df_p50_temp$Jan), 2),
                                       round(mean(lsegs.df_p50_temp$Feb), 2),
                                       round(mean(lsegs.df_p50_temp$Mar), 2),
                                       round(mean(lsegs.df_p50_temp$Apr), 2),
                                       round(mean(lsegs.df_p50_temp$May), 2),
                                       round(mean(lsegs.df_p50_temp$Jun), 2),
                                       round(mean(lsegs.df_p50_temp$Jul), 2),
                                       round(mean(lsegs.df_p50_temp$Aug), 2),
                                       round(mean(lsegs.df_p50_temp$Sep), 2),
                                       round(mean(lsegs.df_p50_temp$Oct), 2),
                                       round(mean(lsegs.df_p50_temp$Nov), 2),
                                       round(mean(lsegs.df_p50_temp$Dec), 2),
                                       round(mean(lsegs.df_p50_temp$Total), 2))

# OUTPUT TABLE IN KABLE FORMAT
kable(p50_temp_tab, "latex", booktabs = T,
      caption = paste("P50 Temperature Changes"), 
      label = paste("P50 Temperature Changes"),
      col.names = c('Month', 'Lowest Change (degree C)', 'Median Change (degree C)', 'Highest Change (degree C)', 'Range of Change (degree C)', 'Average Change (degree C)')) %>%
  kable_styling(latex_options = c("striped", "scale_down")) %>% 
  #column_spec(1, width = "5em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste(dir.location,"/kable_tables/","P50_Temp.tex",sep=""))

p90_temp_tab <- as.data.frame(matrix(data = NA, nrow = 13, ncol = 6))
colnames(p90_temp_tab) <- c('Month', 'Lowest Change (%)', 'Median Change (%)', 'Highest Change (%)', 'Range of Change (%)', 'Average Change (%)')
p90_temp_tab$Month <- c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Total')
p90_temp_tab$`Lowest Change (%)` <- c(round(min(lsegs.df_p90_temp$Jan), 2),
                                      round(min(lsegs.df_p90_temp$Feb), 2),
                                      round(min(lsegs.df_p90_temp$Mar), 2),
                                      round(min(lsegs.df_p90_temp$Apr), 2),
                                      round(min(lsegs.df_p90_temp$May), 2),
                                      round(min(lsegs.df_p90_temp$Jun), 2),
                                      round(min(lsegs.df_p90_temp$Jul), 2),
                                      round(min(lsegs.df_p90_temp$Aug), 2),
                                      round(min(lsegs.df_p90_temp$Sep), 2),
                                      round(min(lsegs.df_p90_temp$Oct), 2),
                                      round(min(lsegs.df_p90_temp$Nov), 2),
                                      round(min(lsegs.df_p90_temp$Dec), 2),
                                      round(min(lsegs.df_p90_temp$Total), 2))
p90_temp_tab$`Median Change (%)` <- c(round(median(lsegs.df_p90_temp$Jan), 2),
                                      round(median(lsegs.df_p90_temp$Feb), 2),
                                      round(median(lsegs.df_p90_temp$Mar), 2),
                                      round(median(lsegs.df_p90_temp$Apr), 2),
                                      round(median(lsegs.df_p90_temp$May), 2),
                                      round(median(lsegs.df_p90_temp$Jun), 2),
                                      round(median(lsegs.df_p90_temp$Jul), 2),
                                      round(median(lsegs.df_p90_temp$Aug), 2),
                                      round(median(lsegs.df_p90_temp$Sep), 2),
                                      round(median(lsegs.df_p90_temp$Oct), 2),
                                      round(median(lsegs.df_p90_temp$Nov), 2),
                                      round(median(lsegs.df_p90_temp$Dec), 2),
                                      round(median(lsegs.df_p90_temp$Total), 2))
p90_temp_tab$`Highest Change (%)` <- c(round(max(lsegs.df_p90_temp$Jan), 2),
                                       round(max(lsegs.df_p90_temp$Feb), 2),
                                       round(max(lsegs.df_p90_temp$Mar), 2),
                                       round(max(lsegs.df_p90_temp$Apr), 2),
                                       round(max(lsegs.df_p90_temp$May), 2),
                                       round(max(lsegs.df_p90_temp$Jun), 2),
                                       round(max(lsegs.df_p90_temp$Jul), 2),
                                       round(max(lsegs.df_p90_temp$Aug), 2),
                                       round(max(lsegs.df_p90_temp$Sep), 2),
                                       round(max(lsegs.df_p90_temp$Oct), 2),
                                       round(max(lsegs.df_p90_temp$Nov), 2),
                                       round(max(lsegs.df_p90_temp$Dec), 2),
                                       round(max(lsegs.df_p90_temp$Total), 2))
p90_temp_tab$`Range of Change (%)` <- p90_temp_tab$`Highest Change (%)` - p90_temp_tab$`Lowest Change (%)`
p90_temp_tab$`Average Change (%)` <- c(round(mean(lsegs.df_p90_temp$Jan), 2),
                                       round(mean(lsegs.df_p90_temp$Feb), 2),
                                       round(mean(lsegs.df_p90_temp$Mar), 2),
                                       round(mean(lsegs.df_p90_temp$Apr), 2),
                                       round(mean(lsegs.df_p90_temp$May), 2),
                                       round(mean(lsegs.df_p90_temp$Jun), 2),
                                       round(mean(lsegs.df_p90_temp$Jul), 2),
                                       round(mean(lsegs.df_p90_temp$Aug), 2),
                                       round(mean(lsegs.df_p90_temp$Sep), 2),
                                       round(mean(lsegs.df_p90_temp$Oct), 2),
                                       round(mean(lsegs.df_p90_temp$Nov), 2),
                                       round(mean(lsegs.df_p90_temp$Dec), 2),
                                       round(mean(lsegs.df_p90_temp$Total), 2))

# OUTPUT TABLE IN KABLE FORMAT
kable(p90_temp_tab, "latex", booktabs = T,
      caption = paste("P90 Temperature Changes"), 
      label = paste("P90 Temperature Changes"),
      col.names = c('Month', 'Lowest Change (degree C)', 'Median Change (degree C)', 'Highest Change (degree C)', 'Range of Change (degree C)', 'Average Change (degree C)')) %>%
  kable_styling(latex_options = c("striped", "scale_down")) %>% 
  #column_spec(1, width = "5em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste(dir.location,"/kable_tables/","P90_Temp.tex",sep=""))

# INDIVIDUAL METRIC MAP -- OVERALL
map_p10_temp_overall <- map_p10_temp + 
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = "white", high = "green", limits = c(1, 1.25), breaks = c(1, 1.25), midpoint = 1) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.temp.overall.map.v4.png', plot = map_p10_temp_overall, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- OVERALL
map_p50_temp_overall <- map_p50_temp + 
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = "white", high = "green", limits = c(1.7, 2.2), midpoint = 1.7) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.temp.overall.map.v4.png', plot = map_p50_temp_overall, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- OVERALL
map_p90_temp_overall <- map_p90_temp + 
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Temperature\nChange (deg C)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = "white", high = "green", limits = c(2.2, 3.2), midpoint = 2.2) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.temp.overall.map.v4.png', plot = map_p90_temp_overall, width = 6.18, height = 3.68, units = 'in')