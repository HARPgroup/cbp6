basepath <- '/var/www/R'
source(paste(basepath,"config.local.private", sep = "/"))
source(paste0(cbp6_location,"/code/cbp6_functions.R"))
source(paste0(github_location, "/auth.private"));
source(paste(cbp6_location, "/code/fn_vahydro-1.0.R", sep = ''))
site <- "http://deq2.bse.vt.edu/d.dh"
token <- rest_token(site, token, rest_uname, rest_pw)
va.or.cbw = 'va'

data.location <- paste0(cbp6_location, '\\Data\\CBP6_Temp_Prcp_Data')
lseg.loc <- paste0(data.location, '\\P6_LSegs_VA')
rseg.loc <- paste0(data.location, '\\P6_RSegs_VA')

dat.climate.base <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/N20150521J96_and_PRC20170731/evap.prcp.table.csv')
dat.climate.base <- dat.climate.base[,-1]
dat.climate.10 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/5545HS10CA2_and_55R45KK1095/evap.prcp.table.csv')
dat.climate.10 <- dat.climate.10[,-1]
dat.climate.50 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/5545HS50CA2_and_5545KK50AA/evap.prcp.table.csv')
dat.climate.50 <- dat.climate.50[,-1]
dat.climate.90 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/5545HS90CA2_and_55R45KK9095/evap.prcp.table.csv')
dat.climate.90 <- dat.climate.90[,-1]

dat.landuse.base <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CFBASE30Y20180615/eos/land.use.table.csv')
dat.landuse.base <- dat.landuse.base[,-1]
dat.landuse.10 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P10R45P10Y/eos/land.use.table.csv')
dat.landuse.10 <- dat.landuse.10[,-1]
dat.landuse.50 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P50R45P50Y/eos/land.use.table.csv')
dat.landuse.50 <- dat.landuse.50[,-1]
dat.landuse.90 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P90R45P90Y/eos/land.use.table.csv')
dat.landuse.90 <- dat.landuse.90[,-1]

library(dplyr)
dat.base <- as.data.frame(inner_join(dat.climate.base, dat.landuse.base, by = 'segment'))
dat.10 <- as.data.frame(inner_join(dat.climate.10, dat.landuse.10, by = 'segment'))
dat.50 <- as.data.frame(inner_join(dat.climate.50, dat.landuse.50, by = 'segment'))
dat.90 <- as.data.frame(inner_join(dat.climate.90, dat.landuse.90, by = 'segment'))

pct.changes.10 <- as.data.frame(matrix(data = NA, nrow = nrow(dat.base), ncol = ncol(dat.base)))
pct.changes.10[,1] <- dat.base[,1]
colnames(pct.changes.10) <- colnames(dat.base)
pct.changes.10[,2:ncol(pct.changes.10)] <- 100*(dat.10[,2:ncol(pct.changes.10)]-dat.base[,2:ncol(pct.changes.10)])/dat.base[,2:ncol(pct.changes.10)]

pct.changes.50 <- as.data.frame(matrix(data = NA, nrow = nrow(dat.base), ncol = ncol(dat.base)))
pct.changes.50[,1] <- dat.base[,1]
colnames(pct.changes.50) <- colnames(dat.base)
pct.changes.50[,2:ncol(pct.changes.50)] <- 100*(dat.50[,2:ncol(pct.changes.50)]-dat.base[,2:ncol(pct.changes.50)])/dat.base[,2:ncol(pct.changes.50)]

pct.changes.90 <- as.data.frame(matrix(data = NA, nrow = nrow(dat.base), ncol = ncol(dat.base)))
pct.changes.90[,1] <- dat.base[,1]
colnames(pct.changes.90) <- colnames(dat.base)
pct.changes.90[,2:ncol(pct.changes.90)] <- 100*(dat.90[,2:ncol(pct.changes.90)]-dat.base[,2:ncol(pct.changes.90)])/dat.base[,2:ncol(pct.changes.90)]


# Following the creation of the pct.changes scenario data frames, this script will create radar
# charts showing the land use unit flows for each land use group.

min.change.10 <- vector()
min.change.50 <- vector()
min.change.90 <- vector()

max.change.10 <- vector()
max.change.50 <- vector()
max.change.90 <- vector()

for (i in 1:length(pct.changes.10$segment)) {
  min.change.10[i] <- colnames(pct.changes.10[which(as.numeric(pct.changes.10[i,8:50]) == as.numeric(min(pct.changes.10[i,8:50])))+3])
  min.change.50[i] <- colnames(pct.changes.50[which(as.numeric(pct.changes.50[i,8:50]) == as.numeric(min(pct.changes.50[i,8:50])))+3])
  min.change.90[i] <- colnames(pct.changes.90[which(as.numeric(pct.changes.90[i,8:50]) == as.numeric(min(pct.changes.90[i,8:50])))+3])
  
  max.change.10[i] <- colnames(pct.changes.10[which(as.numeric(pct.changes.10[i,8:50]) == as.numeric(max(pct.changes.10[i,8:50])))+3])
  max.change.50[i] <- colnames(pct.changes.50[which(as.numeric(pct.changes.50[i,8:50]) == as.numeric(max(pct.changes.50[i,8:50])))+3])
  max.change.90[i] <- colnames(pct.changes.90[which(as.numeric(pct.changes.90[i,8:50]) == as.numeric(max(pct.changes.90[i,8:50])))+3])
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

# P10 MAPS

lsegs.df_p10 <- merge(lsegs.df, pct.changes.10, by.x = 'FIPS_NHL', by.y = 'segment')
lsegs.df_p10 <- arrange(lsegs.df_p10, id, order) # fixes ordering issue (causes lots of jagged lines)

# P50 MAPS

lsegs.df_p50 <- merge(lsegs.df, pct.changes.50, by.x = 'FIPS_NHL', by.y = 'segment')
lsegs.df_p50 <- arrange(lsegs.df_p50, id, order) # fixes ordering issue (causes lots of jagged lines)

# P90 MAPS

lsegs.df_p90 <- merge(lsegs.df, pct.changes.90, by.x = 'FIPS_NHL', by.y = 'segment')
lsegs.df_p90 <- arrange(lsegs.df_p90, id, order) # fixes ordering issue (causes lots of jagged lines)

pct.changes.10 <- pct.changes.10[which(pct.changes.10$segment %in% lsegs.df_p10$FIPS_NHL),]
pct.changes.50 <- pct.changes.50[which(pct.changes.50$segment %in% lsegs.df_p50$FIPS_NHL),]
pct.changes.90 <- pct.changes.90[which(pct.changes.90$segment %in% lsegs.df_p90$FIPS_NHL),]

library(fmsb)
mean.change.10 <- as.data.frame(matrix(colMeans(pct.changes.10[,c(12,19,14,38,39,8,45,23,9,11,18,10)]), ncol = 12))
max.change.10 <- sapply(pct.changes.10[,c(12,19,14,38,39,8,45,23,9,11,18,10)], max)
min.change.10 <- sapply(pct.changes.10[,c(12,19,14,38,39,8,45,23,9,11,18,10)], min)
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

mean.change.50 <- as.data.frame(matrix(colMeans(pct.changes.50[,c(12,19,14,38,39,8,45,23,9,11,18,10)]), ncol = 12))
max.change.50 <- sapply(pct.changes.50[,c(12,19,14,38,39,8,45,23,9,11,18,10)], max)
min.change.50 <- sapply(pct.changes.50[,c(12,19,14,38,39,8,45,23,9,11,18,10)], min)
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

mean.change.90 <- as.data.frame(matrix(colMeans(pct.changes.90[,c(12,19,14,38,39,8,45,23,9,11,18,10)]), ncol = 12))
max.change.90 <- sapply(pct.changes.90[,c(12,19,14,38,39,8,45,23,9,11,18,10)], max)
min.change.90 <- sapply(pct.changes.90[,c(12,19,14,38,39,8,45,23,9,11,18,10)], min)
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

dat.climate.base <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/N20150521J96_and_PRC20170731/evap.prcp.table.csv')
dat.climate.base <- dat.climate.base[,-1]
dat.climate.10 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/5545HS10CA2_and_55R45KK1095/evap.prcp.table.csv')
dat.climate.10 <- dat.climate.10[,-1]
dat.climate.50 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/5545HS50CA2_and_5545KK50AA/evap.prcp.table.csv')
dat.climate.50 <- dat.climate.50[,-1]
dat.climate.90 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/climate/5545HS90CA2_and_55R45KK9095/evap.prcp.table.csv')
dat.climate.90 <- dat.climate.90[,-1]

dat.landuse.base <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CFBASE30Y20180615/eos/land.use.table.l30.csv')
dat.landuse.base <- dat.landuse.base[,-1]
dat.landuse.10 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P10R45P10Y/eos/land.use.table.l30.csv')
dat.landuse.10 <- dat.landuse.10[,-1]
dat.landuse.50 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P50R45P50Y/eos/land.use.table.l30.csv')
dat.landuse.50 <- dat.landuse.50[,-1]
dat.landuse.90 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P90R45P90Y/eos/land.use.table.l30.csv')
dat.landuse.90 <- dat.landuse.90[,-1]

library(dplyr)
dat.base <- as.data.frame(inner_join(dat.climate.base, dat.landuse.base, by = 'segment'))
dat.10 <- as.data.frame(inner_join(dat.climate.10, dat.landuse.10, by = 'segment'))
dat.50 <- as.data.frame(inner_join(dat.climate.50, dat.landuse.50, by = 'segment'))
dat.90 <- as.data.frame(inner_join(dat.climate.90, dat.landuse.90, by = 'segment'))

pct.changes.10 <- as.data.frame(matrix(data = NA, nrow = nrow(dat.base), ncol = ncol(dat.base)))
pct.changes.10[,1] <- dat.base[,1]
colnames(pct.changes.10) <- colnames(dat.base)
pct.changes.10[,2:ncol(pct.changes.10)] <- 100*(dat.10[,2:ncol(pct.changes.10)]-dat.base[,2:ncol(pct.changes.10)])/dat.base[,2:ncol(pct.changes.10)]

pct.changes.50 <- as.data.frame(matrix(data = NA, nrow = nrow(dat.base), ncol = ncol(dat.base)))
pct.changes.50[,1] <- dat.base[,1]
colnames(pct.changes.50) <- colnames(dat.base)
pct.changes.50[,2:ncol(pct.changes.50)] <- 100*(dat.50[,2:ncol(pct.changes.50)]-dat.base[,2:ncol(pct.changes.50)])/dat.base[,2:ncol(pct.changes.50)]

pct.changes.90 <- as.data.frame(matrix(data = NA, nrow = nrow(dat.base), ncol = ncol(dat.base)))
pct.changes.90[,1] <- dat.base[,1]
colnames(pct.changes.90) <- colnames(dat.base)
pct.changes.90[,2:ncol(pct.changes.90)] <- 100*(dat.90[,2:ncol(pct.changes.90)]-dat.base[,2:ncol(pct.changes.90)])/dat.base[,2:ncol(pct.changes.90)]


pct.changes.10 <- pct.changes.10[which(pct.changes.10$segment %in% lsegs.df_p10$FIPS_NHL),]
pct.changes.50 <- pct.changes.50[which(pct.changes.50$segment %in% lsegs.df_p50$FIPS_NHL),]
pct.changes.90 <- pct.changes.90[which(pct.changes.90$segment %in% lsegs.df_p90$FIPS_NHL),]

mean.change.10 <- as.data.frame(matrix(colMeans(pct.changes.10[,c(12,19,14,38,39,8,45,23,9,11,18,10)]), ncol = 12))
max.change.10 <- sapply(pct.changes.10[,c(12,19,14,38,39,8,45,23,9,11,18,10)], max)
min.change.10 <- sapply(pct.changes.10[,c(12,19,14,38,39,8,45,23,9,11,18,10)], min)
radar.changes.10 <- rbind(min.change.10, mean.change.10, max.change.10)
data.10 <- rbind(rep(100,length(colnames(mean.change.10))), rep(-100, length(colnames(mean.change.10))), radar.changes.10)
data.10 <- apply(data.10, 2, function(x) ifelse(x > 100, 100, x))
data.10 <- apply(data.10, 2, function(x) ifelse(x < -100, -100, x))
data.10 <- apply(data.10, 2, function(x) ifelse(is.na(x), 0, x))
data.10 <- as.data.frame(data.10)
colnames(data.10) <- c('CSS True Forest', 'Natural Pervious', 'CSS Mixed Open', 'Natural Mixed Open',
                       'Hay and Forage', 'Ag Open Space', 'Commodity Crops', 'Harvested Forest',
                       'Turf Grass', 'Construction', 'Feeding Space', 'Impervious')
radarchart(data.10, axistype = 1, axislabcol = 'grey30',
           cglcol = 'grey', cglty = 1, plty = 1, plwd = 2,
           caxislabels = c('<-100%', '-50%', '0%', '+50%', '>+100%'),
           pcol = c('red', 'green', 'blue'))
legend(x = 1, y = 1.25, legend = c('Minimum', 'Mean', 'Maximum'), col = c('red', 'green', 'blue'), lty = 1, lwd = 2)

mean.change.50 <- as.data.frame(matrix(colMeans(pct.changes.50[,c(12,19,14,38,39,8,45,23,9,11,18,10)]), ncol = 12))
max.change.50 <- sapply(pct.changes.50[,c(12,19,14,38,39,8,45,23,9,11,18,10)], max)
min.change.50 <- sapply(pct.changes.50[,c(12,19,14,38,39,8,45,23,9,11,18,10)], min)
radar.changes.50 <- rbind(min.change.50, mean.change.50, max.change.50)
data.50 <- rbind(rep(100,length(colnames(mean.change.50))), rep(-100, length(colnames(mean.change.50))), radar.changes.50)
data.50 <- apply(data.50, 2, function(x) ifelse(x > 100, 100, x))
data.50 <- apply(data.50, 2, function(x) ifelse(x < -100, -100, x))
data.50 <- apply(data.50, 2, function(x) ifelse(is.na(x), 0, x))
data.50 <- as.data.frame(data.50)
colnames(data.50) <- c('CSS True Forest', 'Natural Pervious', 'CSS Mixed Open', 'Natural Mixed Open',
                       'Hay and Forage', 'Ag Open Space', 'Commodity Crops', 'Harvested Forest',
                       'Turf Grass', 'Construction', 'Feeding Space', 'Impervious')
radarchart(data.50, axistype = 1, axislabcol = 'grey30',
           cglcol = 'grey', cglty = 1, plty = 1, plwd = 2,
           caxislabels = c('<-100%', '-50%', '0%', '+50%', '>+100%'),
           pcol = c('red', 'green', 'blue'))
legend(x = 1, y = 1.25, legend = c('Minimum', 'Mean', 'Maximum'), col = c('red', 'green', 'blue'), lty = 1, lwd = 2)

mean.change.90 <- as.data.frame(matrix(colMeans(pct.changes.90[,c(12,19,14,38,39,8,45,23,9,11,18,10)]), ncol = 12))
max.change.90 <- sapply(pct.changes.90[,c(12,19,14,38,39,8,45,23,9,11,18,10)], max)
min.change.90 <- sapply(pct.changes.90[,c(12,19,14,38,39,8,45,23,9,11,18,10)], min)
radar.changes.90 <- rbind(min.change.90, mean.change.90, max.change.90)
data.90 <- rbind(rep(100,length(colnames(mean.change.90))), rep(-100, length(colnames(mean.change.90))), radar.changes.90)
data.90 <- apply(data.90, 2, function(x) ifelse(x > 100, 100, x))
data.90 <- apply(data.90, 2, function(x) ifelse(x < -100, -100, x))
data.90 <- apply(data.90, 2, function(x) ifelse(is.na(x), 0, x))
data.90 <- as.data.frame(data.90)
colnames(data.90) <- c('CSS True Forest', 'Natural Pervious', 'CSS Mixed Open', 'Natural Mixed Open',
                       'Hay and Forage', 'Ag Open Space', 'Commodity Crops', 'Harvested Forest',
                       'Turf Grass', 'Construction', 'Feeding Space', 'Impervious')
radarchart(data.90, axistype = 1, axislabcol = 'grey30',
           cglcol = 'grey', cglty = 1, plty = 1, plwd = 2,
           caxislabels = c('<-100%', '-50%', '0%', '+50%', '>+100%'),
           pcol = c('red', 'green', 'blue'))
legend(x = 1, y = 1.25, legend = c('Minimum', 'Mean', 'Maximum'), col = c('red', 'green', 'blue'), lty = 1, lwd = 2)

radar.means <- rbind(mean.change.10, mean.change.50, mean.change.90)
data.means <- rbind(rep(100,length(colnames(radar.means))), rep(-100, length(colnames(radar.means))), radar.means)
data.means <- apply(data.means, 2, function(x) ifelse(x > 100, 100, x))
data.means <- apply(data.means, 2, function(x) ifelse(x < -100, -100, x))
data.means <- apply(data.means, 2, function(x) ifelse(is.na(x), 0, x))
data.means <- as.data.frame(data.means)
colnames(data.means) <- c('CSS True Forest', 'Natural Pervious', 'CSS Mixed Open', 'Natural Mixed Open',
                          'Hay and Forage', 'Ag Open Space', 'Commodity Crops', 'Harvested Forest',
                          'Turf Grass', 'Construction', 'Feeding Space', 'Impervious')
radarchart(data.means, axistype = 1, axislabcol = 'grey30',
           cglcol = 'grey', cglty = 1, plty = 1, plwd = 2,
           caxislabels = c('<-100%', '-50%', '0%', '+50%', '>+100%'),
           pcol = c('chocolate2', 'green3', 'blueviolet'))
legend(x = 1, y = 1.25, legend = c('ccP10T10', 'ccP50T50', 'ccP90T90'), col = c('chocolate2', 'green3', 'blueviolet'), lty = 1, lwd = 2)


# same for P90, even though it has messed up segment naming at the second
segs.base <- dat.landuse.base$segment
segs.10 <- dat.landuse.10$segment
segs.50 <- dat.landuse.50$segment
segs.90 <- dat.landuse.90$segment
dat.landuse.base <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CFBASE30Y20180615/eos/land.use.table.l90.csv')
dat.landuse.base <- dat.landuse.base[,-1]
dat.landuse.10 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P10R45P10Y/eos/land.use.table.l90.csv')
dat.landuse.10 <- dat.landuse.10[,-1]
dat.landuse.50 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P50R45P50Y/eos/land.use.table.l90.csv')
dat.landuse.50 <- dat.landuse.50[,-1]
dat.landuse.90 <- read.csv('http://deq2.bse.vt.edu/p6/p6_gb604/out/land/CBASE1808L55CY55R45P90R45P90Y/eos/land.use.table.l90.csv')
dat.landuse.90 <- dat.landuse.90[,-1]
dat.landuse.base$segment <- segs.base
dat.landuse.10$segment <- segs.10
dat.landuse.50$segment <- segs.50
dat.landuse.90$segment <- segs.90


library(dplyr)
dat.base <- as.data.frame(inner_join(dat.climate.base, dat.landuse.base, by = 'segment'))
dat.10 <- as.data.frame(inner_join(dat.climate.10, dat.landuse.10, by = 'segment'))
dat.50 <- as.data.frame(inner_join(dat.climate.50, dat.landuse.50, by = 'segment'))
dat.90 <- as.data.frame(inner_join(dat.climate.90, dat.landuse.90, by = 'segment'))

pct.changes.10 <- as.data.frame(matrix(data = NA, nrow = nrow(dat.base), ncol = ncol(dat.base)))
pct.changes.10[,1] <- dat.base[,1]
colnames(pct.changes.10) <- colnames(dat.base)
pct.changes.10[,2:ncol(pct.changes.10)] <- 100*(dat.10[,2:ncol(pct.changes.10)]-dat.base[,2:ncol(pct.changes.10)])/dat.base[,2:ncol(pct.changes.10)]

pct.changes.50 <- as.data.frame(matrix(data = NA, nrow = nrow(dat.base), ncol = ncol(dat.base)))
pct.changes.50[,1] <- dat.base[,1]
colnames(pct.changes.50) <- colnames(dat.base)
pct.changes.50[,2:ncol(pct.changes.50)] <- 100*(dat.50[,2:ncol(pct.changes.50)]-dat.base[,2:ncol(pct.changes.50)])/dat.base[,2:ncol(pct.changes.50)]

pct.changes.90 <- as.data.frame(matrix(data = NA, nrow = nrow(dat.base), ncol = ncol(dat.base)))
pct.changes.90[,1] <- dat.base[,1]
colnames(pct.changes.90) <- colnames(dat.base)
pct.changes.90[,2:ncol(pct.changes.90)] <- 100*(dat.90[,2:ncol(pct.changes.90)]-dat.base[,2:ncol(pct.changes.90)])/dat.base[,2:ncol(pct.changes.90)]

pct.changes.10 <- pct.changes.10[which(pct.changes.10$segment %in% lsegs.df_p10$FIPS_NHL),]
pct.changes.50 <- pct.changes.50[which(pct.changes.50$segment %in% lsegs.df_p50$FIPS_NHL),]
pct.changes.90 <- pct.changes.90[which(pct.changes.90$segment %in% lsegs.df_p90$FIPS_NHL),]

mean.change.10 <- as.data.frame(matrix(colMeans(pct.changes.10[,c(12,19,14,38,39,8,45,23,9,11,18,10)]), ncol = 12))
max.change.10 <- sapply(pct.changes.10[,c(12,19,14,38,39,8,45,23,9,11,18,10)], max)
min.change.10 <- sapply(pct.changes.10[,c(12,19,14,38,39,8,45,23,9,11,18,10)], min)
radar.changes.10 <- rbind(min.change.10, mean.change.10, max.change.10)
data.10 <- rbind(rep(100,length(colnames(mean.change.10))), rep(-100, length(colnames(mean.change.10))), radar.changes.10)
data.10 <- apply(data.10, 2, function(x) ifelse(x > 100, 100, x))
data.10 <- apply(data.10, 2, function(x) ifelse(x < -100, -100, x))
data.10 <- apply(data.10, 2, function(x) ifelse(is.na(x), 0, x))
data.10 <- as.data.frame(data.10)
colnames(data.10) <- c('CSS True Forest', 'Natural Pervious', 'CSS Mixed Open', 'Natural Mixed Open',
                       'Hay and Forage', 'Ag Open Space', 'Commodity Crops', 'Harvested Forest',
                       'Turf Grass', 'Construction', 'Feeding Space', 'Impervious')
radarchart(data.10, axistype = 1, axislabcol = 'grey30',
           cglcol = 'grey', cglty = 1, plty = 1, plwd = 2,
           caxislabels = c('<-100%', '-50%', '0%', '+50%', '>+100%'),
           pcol = c('red', 'green', 'blue'))
legend(x = 1, y = 1.25, legend = c('Minimum', 'Mean', 'Maximum'), col = c('red', 'green', 'blue'), lty = 1, lwd = 2)

mean.change.50 <- as.data.frame(matrix(colMeans(pct.changes.50[,c(12,19,14,38,39,8,45,23,9,11,18,10)]), ncol = 12))
max.change.50 <- sapply(pct.changes.50[,c(12,19,14,38,39,8,45,23,9,11,18,10)], max)
min.change.50 <- sapply(pct.changes.50[,c(12,19,14,38,39,8,45,23,9,11,18,10)], min)
radar.changes.50 <- rbind(min.change.50, mean.change.50, max.change.50)
data.50 <- rbind(rep(100,length(colnames(mean.change.50))), rep(-100, length(colnames(mean.change.50))), radar.changes.50)
data.50 <- apply(data.50, 2, function(x) ifelse(x > 100, 100, x))
data.50 <- apply(data.50, 2, function(x) ifelse(x < -100, -100, x))
data.50 <- apply(data.50, 2, function(x) ifelse(is.na(x), 0, x))
data.50 <- as.data.frame(data.50)
colnames(data.50) <- c('CSS True Forest', 'Natural Pervious', 'CSS Mixed Open', 'Natural Mixed Open',
                       'Hay and Forage', 'Ag Open Space', 'Commodity Crops', 'Harvested Forest',
                       'Turf Grass', 'Construction', 'Feeding Space', 'Impervious')
radarchart(data.50, axistype = 1, axislabcol = 'grey30',
           cglcol = 'grey', cglty = 1, plty = 1, plwd = 2,
           caxislabels = c('<-100%', '-50%', '0%', '+50%', '>+100%'),
           pcol = c('red', 'green', 'blue'))
legend(x = 1, y = 1.25, legend = c('Minimum', 'Mean', 'Maximum'), col = c('red', 'green', 'blue'), lty = 1, lwd = 2)

mean.change.90 <- as.data.frame(matrix(colMeans(pct.changes.90[,c(12,19,14,38,39,8,45,23,9,11,18,10)]), ncol = 12))
max.change.90 <- sapply(pct.changes.90[,c(12,19,14,38,39,8,45,23,9,11,18,10)], max)
min.change.90 <- sapply(pct.changes.90[,c(12,19,14,38,39,8,45,23,9,11,18,10)], min)
radar.changes.90 <- rbind(min.change.90, mean.change.90, max.change.90)
data.90 <- rbind(rep(100,length(colnames(mean.change.90))), rep(-100, length(colnames(mean.change.90))), radar.changes.90)
data.90 <- apply(data.90, 2, function(x) ifelse(x > 100, 100, x))
data.90 <- apply(data.90, 2, function(x) ifelse(x < -100, -100, x))
data.90 <- apply(data.90, 2, function(x) ifelse(is.na(x), 0, x))
data.90 <- as.data.frame(data.90)
colnames(data.90) <- c('CSS True Forest', 'Natural Pervious', 'CSS Mixed Open', 'Natural Mixed Open',
                       'Hay and Forage', 'Ag Open Space', 'Commodity Crops', 'Harvested Forest',
                       'Turf Grass', 'Construction', 'Feeding Space', 'Impervious')
radarchart(data.90, axistype = 1, axislabcol = 'grey30',
           cglcol = 'grey', cglty = 1, plty = 1, plwd = 2,
           caxislabels = c('<-100%', '-50%', '0%', '+50%', '>+100%'),
           pcol = c('red', 'green', 'blue'))
legend(x = 1, y = 1.25, legend = c('Minimum', 'Mean', 'Maximum'), col = c('red', 'green', 'blue'), lty = 1, lwd = 2)

radar.means <- rbind(mean.change.10, mean.change.50, mean.change.90)
data.means <- rbind(rep(100,length(colnames(radar.means))), rep(-100, length(colnames(radar.means))), radar.means)
data.means <- apply(data.means, 2, function(x) ifelse(x > 100, 100, x))
data.means <- apply(data.means, 2, function(x) ifelse(x < -100, -100, x))
data.means <- apply(data.means, 2, function(x) ifelse(is.na(x), 0, x))
data.means <- as.data.frame(data.means)
colnames(data.means) <- c('CSS True Forest', 'Natural Pervious', 'CSS Mixed Open', 'Natural Mixed Open',
                          'Hay and Forage', 'Ag Open Space', 'Commodity Crops', 'Harvested Forest',
                          'Turf Grass', 'Construction', 'Feeding Space', 'Impervious')
radarchart(data.means, axistype = 1, axislabcol = 'grey30',
           cglcol = 'grey', cglty = 1, plty = 1, plwd = 2,
           caxislabels = c('<-100%', '-50%', '0%', '+50%', '>+100%'),
           pcol = c('chocolate2', 'green3', 'blueviolet'))
legend(x = 1, y = 1.25, legend = c('ccP10T10', 'ccP50T50', 'ccP90T90'), col = c('chocolate2', 'green3', 'blueviolet'), lty = 1, lwd = 2)
