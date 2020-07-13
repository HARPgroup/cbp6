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

# CREATING DIRECTORY TO STORE DATA AND OUTPUTS
dir.create('~/Precip_and_Temp_Mapper/Land_Use')
dir.location <- '~/Precip_and_Temp_Mapper/Land_Use'
setwd(dir.location)

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

library(segmented)
rsq <- function (x, y) cor(x, y) ^ 2



plot(pct.changes.10$evap.mean, pct.changes.10$prcp.mean, ylim = c(-10,30), xlim = c(3, 13))
points(pct.changes.50$evap.mean, pct.changes.50$prcp.mean, col = 'red')
points(pct.changes.90$evap.mean, pct.changes.90$prcp.mean, col = 'blue')

plot(pct.changes.10$evap.mean, pct.changes.10$prcp.mean)
abline(lm(prcp.mean~evap.mean, data = pct.changes.10), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ evap.mean, data = pct.changes.10))$r.squared, 3), sep = ' '))

plot(pct.changes.50$evap.mean, pct.changes.50$prcp.mean)
abline(lm(prcp.mean~evap.mean, data = pct.changes.50), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ evap.mean, data = pct.changes.50))$r.squared, 3), sep = ' '))

plot(pct.changes.90$evap.mean, pct.changes.90$prcp.mean)
abline(lm(prcp.mean~evap.mean, data = pct.changes.90), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ evap.mean, data = pct.changes.90))$r.squared, 3), sep = ' '))


plot(pct.changes.10$evap.mean, pct.changes.10$for.)
abline(lm(for. ~ evap.mean, data = pct.changes.10), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(evap.mean ~ for., data = pct.changes.10))$r.squared, 3), sep = ' '))
plot(pct.changes.10$evap.mean, pct.changes.10$pas)
abline(lm(pas ~ evap.mean, data = pct.changes.10), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(evap.mean ~ pas, data = pct.changes.10))$r.squared, 3), sep = ' '))
plot(pct.changes.10$evap.mean, pct.changes.10$cir)
abline(lm(cir ~ evap.mean, data = pct.changes.10), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(evap.mean ~ cir, data = pct.changes.10))$r.squared, 3), sep = ' '))
plot(pct.changes.10$prcp.mean, pct.changes.10$for.)
abline(lm(for. ~ prcp.mean, data = pct.changes.10), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ for., data = pct.changes.10))$r.squared, 3), sep = ' '))
plot(pct.changes.10$prcp.mean, pct.changes.10$pas)
abline(lm(pas ~ prcp.mean, data = pct.changes.10), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ pas, data = pct.changes.10))$r.squared, 3), sep = ' '))
plot(pct.changes.10$prcp.mean, pct.changes.10$cir)
abline(lm(cir ~ prcp.mean, data = pct.changes.10), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ cir, data = pct.changes.10))$r.squared, 3), sep = ' '))

plot(pct.changes.50$evap.mean, pct.changes.50$for.)
# abline(lm(for. ~ evap.mean, data = pct.changes.50), col = 'red')
segmentation <- segmented(lm(for. ~ evap.mean, data = pct.changes.50))
breakpoint <- segmentation$psi[2]
plot(segmentation, add = TRUE, col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(segmented.lm(lm(evap.mean ~ for., data = pct.changes.50)))$r.squared, 3), sep = ' '))
plot(pct.changes.50$evap.mean, pct.changes.50$pas)
#abline(lm(pas ~ evap.mean, data = pct.changes.50), col = 'red')
segmentation <- segmented(lm(pas ~ evap.mean, data = pct.changes.50))
breakpoint <- segmentation$psi[2]
plot(segmentation, add = TRUE, col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(segmented.lm(lm(evap.mean ~ pas, data = pct.changes.50)))$r.squared, 3), sep = ' '))
plot(pct.changes.50$evap.mean, pct.changes.50$cir)
#abline(lm(cir ~ evap.mean, data = pct.changes.50), col = 'red')
segmentation <- segmented(lm(cir ~ evap.mean, data = pct.changes.50))
breakpoint <- segmentation$psi[2]
plot(segmentation, add = TRUE, col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(segmented.lm(lm(evap.mean ~ cir, data = pct.changes.50)))$r.squared, 3), sep = ' '))
plot(pct.changes.50$prcp.mean, pct.changes.50$for.)
abline(lm(for. ~ prcp.mean, data = pct.changes.50), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ for., data = pct.changes.50))$r.squared, 3), sep = ' '))
plot(pct.changes.50$prcp.mean, pct.changes.50$pas)
abline(lm(pas ~ prcp.mean, data = pct.changes.50), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ pas, data = pct.changes.50))$r.squared, 3), sep = ' '))
plot(pct.changes.50$prcp.mean, pct.changes.50$cir)
abline(lm(cir ~ prcp.mean, data = pct.changes.50), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ cir, data = pct.changes.50))$r.squared, 3), sep = ' '))

plot(pct.changes.90$evap.mean, pct.changes.90$for.)
abline(lm(for. ~ evap.mean, data = pct.changes.90), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(evap.mean ~ for., data = pct.changes.90))$r.squared, 3), sep = ' '))
plot(pct.changes.90$evap.mean, pct.changes.90$pas)
abline(lm(pas ~ evap.mean, data = pct.changes.90), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(evap.mean ~ pas, data = pct.changes.90))$r.squared, 3), sep = ' '))
plot(pct.changes.90$evap.mean, pct.changes.90$cir)
abline(lm(cir ~ evap.mean, data = pct.changes.90), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(evap.mean ~ cir, data = pct.changes.90))$r.squared, 3), sep = ' '))
plot(pct.changes.90$prcp.mean, pct.changes.90$for.)
abline(lm(for. ~ prcp.mean, data = pct.changes.90), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ for., data = pct.changes.90))$r.squared, 3), sep = ' '))
plot(pct.changes.90$prcp.mean, pct.changes.90$pas)
abline(lm(pas ~ prcp.mean, data = pct.changes.90), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ pas, data = pct.changes.90))$r.squared, 3), sep = ' '))
plot(pct.changes.90$prcp.mean, pct.changes.90$cir)
abline(lm(cir ~ prcp.mean, data = pct.changes.90), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ cir, data = pct.changes.90))$r.squared, 3), sep = ' '))

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

# P10 MAPS

lsegs.df_p10 <- merge(lsegs.df, pct.changes.10, by.x = 'FIPS_NHL', by.y = 'segment')
lsegs.df_p10 <- arrange(lsegs.df_p10, id, order) # fixes ordering issue (causes lots of jagged lines)

map_p10 <- ggplot(data = lsegs.df_p10, aes(x = long, y = lat, group = group))+
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

map_p10_evap <- map_p10 + 
  geom_polygon(aes(fill = evap.mean), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Evapotranspiration\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'white', high = 'green', limits = c(0,15)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p10_1_evap_change.png', plot = map_p10_evap, width = 6.18, height = 3.68, units = 'in')

map_p10_prcp <- map_p10 + 
  geom_polygon(aes(fill = prcp.mean), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-15,30)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p10_1_prcp_change.png', plot = map_p10_prcp, width = 6.18, height = 3.68, units = 'in')

map_p10_for <- map_p10 + 
  geom_polygon(aes(fill = for.), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="True Forest\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-50,75)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p10_for_change.png', plot = map_p10_for, width = 6.18, height = 3.68, units = 'in')

map_p10_pas <- map_p10 + 
  geom_polygon(aes(fill = pas), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Pasture\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-50,75)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p10_pas_change.png', plot = map_p10_pas, width = 6.18, height = 3.68, units = 'in')

map_p10_cir <- map_p10 + 
  geom_polygon(aes(fill = cir), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Roads\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-50,75)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p10_cir_change.png', plot = map_p10_cir, width = 6.18, height = 3.68, units = 'in')

# P50 MAPS

lsegs.df_p50 <- merge(lsegs.df, pct.changes.50, by.x = 'FIPS_NHL', by.y = 'segment')
lsegs.df_p50 <- arrange(lsegs.df_p50, id, order) # fixes ordering issue (causes lots of jagged lines)

map_p50 <- ggplot(data = lsegs.df_p50, aes(x = long, y = lat, group = group))+
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

map_p50_evap <- map_p50 + 
  geom_polygon(aes(fill = evap.mean), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Evapotranspiration\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'white', high = 'green', limits = c(0,15)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p50_1_evap_change.png', plot = map_p50_evap, width = 6.18, height = 3.68, units = 'in')

map_p50_prcp <- map_p50 + 
  geom_polygon(aes(fill = prcp.mean), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-15,30)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p50_1_prcp_change.png', plot = map_p50_prcp, width = 6.18, height = 3.68, units = 'in')


map_p50_for <- map_p50 + 
  geom_polygon(aes(fill = for.), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="True Forest\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-50,75)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p50_for_change.png', plot = map_p50_for, width = 6.18, height = 3.68, units = 'in')

map_p50_pas <- map_p50 + 
  geom_polygon(aes(fill = pas), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Pasture\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-50,75)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p50_pas_change.png', plot = map_p50_pas, width = 6.18, height = 3.68, units = 'in')

map_p50_cir <- map_p50 + 
  geom_polygon(aes(fill = cir), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Roads\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-50,75)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p50_cir_change.png', plot = map_p50_cir, width = 6.18, height = 3.68, units = 'in')

# P90 MAPS

lsegs.df_p90 <- merge(lsegs.df, pct.changes.90, by.x = 'FIPS_NHL', by.y = 'segment')
lsegs.df_p90 <- arrange(lsegs.df_p90, id, order) # fixes ordering issue (causes lots of jagged lines)

map_p90 <- ggplot(data = lsegs.df_p90, aes(x = long, y = lat, group = group))+
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

map_p90_evap <- map_p90 + 
  geom_polygon(aes(fill = evap.mean), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Evapotranspiration\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'white', high = 'green', limits = c(0,15)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p90_1_evap_change.png', plot = map_p90_evap, width = 6.18, height = 3.68, units = 'in')

map_p90_prcp <- map_p90 + 
  geom_polygon(aes(fill = prcp.mean), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-15,30)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p90_1_prcp_change.png', plot = map_p90_prcp, width = 6.18, height = 3.68, units = 'in')


map_p90_for <- map_p90 + 
  geom_polygon(aes(fill = for.), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="True Forest\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-50,75)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p90_for_change.png', plot = map_p90_for, width = 6.18, height = 3.68, units = 'in')

map_p90_pas <- map_p90 + 
  geom_polygon(aes(fill = pas), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Pasture\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-50,75)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p90_pas_change.png', plot = map_p90_pas, width = 6.18, height = 3.68, units = 'in')

map_p90_cir <- map_p90 + 
  geom_polygon(aes(fill = cir), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Roads\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(-50,75)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p90_cir_change.png', plot = map_p90_cir, width = 6.18, height = 3.68, units = 'in')

# INDIVIDUAL METRIC MAP -- OVERALL
map_p10_temp_overall <- map_p10 + 
  geom_polygon(aes(fill = evap.mean), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="PET\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = "white", high = "green", limits = c(2.8, 4), midpoint = 2.8) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.evap.overall.map.v4.png', plot = map_p10_temp_overall, width = 6.18, height = 3.68, units = 'in')

map_p50_temp_overall <- map_p50 + 
  geom_polygon(aes(fill = evap.mean), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="PET\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = "white", high = "green", limits = c(4.5, 7), midpoint = 4.5) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.evap.overall.map.v4.png', plot = map_p50_temp_overall, width = 6.18, height = 3.68, units = 'in')

map_p90_temp_overall <- map_p90 + 
  geom_polygon(aes(fill = evap.mean), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="PET\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = "white", high = "green", limits = c(6, 11), midpoint = 6) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.evap.overall.map.v4.png', plot = map_p90_temp_overall, width = 6.18, height = 3.68, units = 'in')

map_p10_temp_overall <- map_p10 + 
  geom_polygon(aes(fill = prcp.mean), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = "red", high = "white", limits = c(-11, -7), midpoint = -7) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p10.prcp.overall.map.v4.png', plot = map_p10_temp_overall, width = 6.18, height = 3.68, units = 'in')

map_p50_temp_overall <- map_p50 + 
  geom_polygon(aes(fill = prcp.mean), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = "white", high = "green", limits = c(3, 8), midpoint = 3) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p50.prcp.overall.map.v4.png', plot = map_p50_temp_overall, width = 6.18, height = 3.68, units = 'in')

map_p90_temp_overall <- map_p90 + 
  geom_polygon(aes(fill = prcp.mean), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Precipitation\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = "white", high = "green", limits = c(22, 29), midpoint = 22) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('p90.prcp.overall.map.v4.png', plot = map_p90_temp_overall, width = 6.18, height = 3.68, units = 'in')

# for more detailed trend analysis
# CREATING DIRECTORY TO STORE DATA AND OUTPUTS
dir.create('~/Precip_and_Temp_Mapper/Land_Use/diagnostic_maps')
dir.location <- '~/Precip_and_Temp_Mapper/Land_Use/diagnostic_maps'
setwd(dir.location)
library(tmap)

p10.landuse.change <- lsegs
p10.landuse.change@data <- merge(x = p10.landuse.change@data, y = pct.changes.10, by.x = 'FIPS_NHL', all.x = TRUE, by.y = 'segment')

png('p10.1.evap.png', width = 800, height = 600)
qtm(p10.landuse.change, fill = 'evap.mean', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
png('p10.1.prcp.png', width = 800, height = 600)
qtm(p10.landuse.change, fill = 'prcp.mean', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
png('p10.for.png', width = 800, height = 600)
qtm(p10.landuse.change, fill = 'for.', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
png('p10.pas.png', width = 800, height = 600)
qtm(p10.landuse.change, fill = 'pas', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
png('p10.cir.png', width = 800, height = 600)
qtm(p10.landuse.change, fill = 'cir', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()

p50.landuse.change <- lsegs
p50.landuse.change@data <- merge(x = p50.landuse.change@data, y = pct.changes.50, by.x = 'FIPS_NHL', all.x = TRUE, by.y = 'segment')

png('p50.1.evap.png', width = 800, height = 600)
qtm(p50.landuse.change, fill = 'evap.mean', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
png('p50.1.prcp.png', width = 800, height = 600)
qtm(p50.landuse.change, fill = 'prcp.mean', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
png('p50.for.png', width = 800, height = 600)
qtm(p50.landuse.change, fill = 'for.', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
png('p50.pas.png', width = 800, height = 600)
qtm(p50.landuse.change, fill = 'pas', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
png('p50.cir.png', width = 800, height = 600)
qtm(p50.landuse.change, fill = 'cir', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()

p90.landuse.change <- lsegs
p90.landuse.change@data <- merge(x = p90.landuse.change@data, y = pct.changes.90, by.x = 'FIPS_NHL', all.x = TRUE, by.y = 'segment')

png('p90.1.evap.png', width = 800, height = 600)
qtm(p90.landuse.change, fill = 'evap.mean', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
png('p90.1.prcp.png', width = 800, height = 600)
qtm(p90.landuse.change, fill = 'prcp.mean', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
png('p90.for.png', width = 800, height = 600)
qtm(p90.landuse.change, fill = 'for.', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
png('p90.pas.png', width = 800, height = 600)
qtm(p90.landuse.change, fill = 'pas', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()
png('p90.cir.png', width = 800, height = 600)
qtm(p90.landuse.change, fill = 'cir', legend.title.size = 1.8, legend.text.size = 1.4)
dev.off()

# Comparative graphs
library(gridExtra)

dir.create('~/Precip_and_Temp_Mapper/Land_Use/comparative_maps')
dir.location <- '~/Precip_and_Temp_Mapper/Land_Use/comparative_maps'
setwd(dir.location)

jpeg('compare_evap.jpeg', width = 1300, height = 258)
compare_evap <- grid.arrange(grobs = list(
  map_p10_evap, map_p50_evap, map_p90_evap),
  widths = c(1.25,1.25,1.25),
  layout_matrix = rbind(c(1,2,3))
)
dev.off()

jpeg('compare_prcp.jpeg', width = 1300, height = 258)
compare_prcp <- grid.arrange(grobs = list(
  map_p10_prcp, map_p50_prcp, map_p90_prcp),
  widths = c(1.25,1.25,1.25),
  layout_matrix = rbind(c(1,2,3))
)
dev.off()

jpeg('compare_for.jpeg', width = 1300, height = 258)
compare_for <- grid.arrange(grobs = list(
  map_p10_for, map_p50_for, map_p90_for),
  widths = c(1.25,1.25,1.25),
  layout_matrix = rbind(c(1,2,3))
)
dev.off()

jpeg('compare_pas.jpeg', width = 1300, height = 258)
compare_pas <- grid.arrange(grobs = list(
  map_p10_pas, map_p50_pas, map_p90_pas),
  widths = c(1.25,1.25,1.25),
  layout_matrix = rbind(c(1,2,3))
)
dev.off()

jpeg('compare_cir.jpeg', width = 1300, height = 258)
compare_cir <- grid.arrange(grobs = list(
  map_p10_cir, map_p50_cir, map_p90_cir),
  widths = c(1.25,1.25,1.25),
  layout_matrix = rbind(c(1,2,3))
)
dev.off()

# plots by latitude and longitude
dir.create('~/Precip_and_Temp_Mapper/Land_Use/long_and_lat')
dir.location <- '~/Precip_and_Temp_Mapper/Land_Use/long_and_lat'
setwd(dir.location)

png('prcp.lat.png', width = 800, height = 600)
min <- min(min(p10.landuse.change$prcp.mean, na.rm = TRUE), min(p50.landuse.change$prcp.mean, na.rm = TRUE), min(p90.landuse.change$prcp.mean, na.rm = TRUE))
max <- max(max(p10.landuse.change$prcp.mean, na.rm = TRUE), max(p50.landuse.change$prcp.mean, na.rm = TRUE), max(p90.landuse.change$prcp.mean, na.rm = TRUE))
plot(p10.landuse.change$CENTROID_Y, p10.landuse.change$prcp.mean, xlab = 'Latitude (deg N)', 
     ylab = 'Mean Precipitation Change (%)', col = 'red', ylim = c(floor(min), ceiling(max)))
points(p50.landuse.change$CENTROID_Y, p50.landuse.change$prcp.mean, col = 'black')
points(p90.landuse.change$CENTROID_Y, p90.landuse.change$prcp.mean, col = 'blue')
legend('topright', legend = c('ccP10T10', 'ccP50T50', 'ccP90T90'), fill = c('red', 'black', 'blue'))
dev.off()

png('prcp.lon.png', width = 800, height = 600)
min <- min(min(p10.landuse.change$prcp.mean, na.rm = TRUE), min(p50.landuse.change$prcp.mean, na.rm = TRUE), min(p90.landuse.change$prcp.mean, na.rm = TRUE))
max <- max(max(p10.landuse.change$prcp.mean, na.rm = TRUE), max(p50.landuse.change$prcp.mean, na.rm = TRUE), max(p90.landuse.change$prcp.mean, na.rm = TRUE))
plot(p10.landuse.change$CENTROID_X, p10.landuse.change$prcp.mean, xlab = 'Longitude (deg W)', 
     ylab = 'Mean Precipitation Change (%)', col = 'red', ylim = c(floor(min), ceiling(max)))
points(p50.landuse.change$CENTROID_X, p50.landuse.change$prcp.mean, col = 'black')
points(p90.landuse.change$CENTROID_X, p90.landuse.change$prcp.mean, col = 'blue')
legend('topright', legend = c('ccP10T10', 'ccP50T50', 'ccP90T90'), fill = c('red', 'black', 'blue'))
dev.off()

png('prcp.p10.lat.png', width = 800, height = 600)
plot(p10.landuse.change$CENTROID_Y, p10.landuse.change$prcp.mean, xlab = 'Latitude (deg N)', 
     ylab = 'Mean P10 Precipitation Change (%)')
abline(lm(prcp.mean ~ CENTROID_Y, data = p10.landuse.change), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ CENTROID_Y, data = p10.landuse.change))$r.squared, 2), sep = ' '))
dev.off()

png('prcp.p10.lon.png', width = 800, height = 600)
plot(p10.landuse.change$CENTROID_X, p10.landuse.change$prcp.mean, xlab = 'Longitude (deg W)', 
     ylab = 'Mean P10 Precipitation Change (%)')
abline(lm(prcp.mean ~ CENTROID_X, data = p10.landuse.change), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ CENTROID_X, data = p10.landuse.change))$r.squared, 2), sep = ' '))
dev.off()

png('prcp.p50.lat.png', width = 800, height = 600)
plot(p50.landuse.change$CENTROID_Y, p50.landuse.change$prcp.mean, xlab = 'Latitude (deg N)', 
     ylab = 'Mean P50 Precipitation Change (%)')
abline(lm(prcp.mean ~ CENTROID_Y, data = p50.landuse.change), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ CENTROID_Y, data = p50.landuse.change))$r.squared, 2), sep = ' '))
dev.off()

png('prcp.p50.lon.png', width = 800, height = 600)
plot(p50.landuse.change$CENTROID_X, p50.landuse.change$prcp.mean, xlab = 'Longitude (deg W)', 
     ylab = 'Mean P50 Precipitation Change (%)')
abline(lm(prcp.mean ~ CENTROID_X, data = p50.landuse.change), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ CENTROID_X, data = p50.landuse.change))$r.squared, 2), sep = ' '))
dev.off()

png('prcp.p90.lat.png', width = 800, height = 600)
plot(p90.landuse.change$CENTROID_Y, p90.landuse.change$prcp.mean, xlab = 'Latitude (deg N)', 
     ylab = 'Mean P90 Precipitation Change (%)')
abline(lm(prcp.mean ~ CENTROID_Y, data = p90.landuse.change), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ CENTROID_Y, data = p90.landuse.change))$r.squared, 2), sep = ' '))
dev.off()

png('prcp.p90.lon.png', width = 800, height = 600)
plot(p90.landuse.change$CENTROID_X, p90.landuse.change$prcp.mean, xlab = 'Longitude (deg W)', 
     ylab = 'Mean P90 Precipitation Change (%)')
abline(lm(prcp.mean ~ CENTROID_X, data = p90.landuse.change), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(prcp.mean ~ CENTROID_X, data = p90.landuse.change))$r.squared, 2), sep = ' '))
dev.off()

# Evap
png('evap.lat.png', width = 800, height = 600)
min <- min(min(p10.landuse.change$evap.mean, na.rm = TRUE), min(p50.landuse.change$evap.mean, na.rm = TRUE), min(p90.landuse.change$evap.mean, na.rm = TRUE))
max <- max(max(p10.landuse.change$evap.mean, na.rm = TRUE), max(p50.landuse.change$evap.mean, na.rm = TRUE), max(p90.landuse.change$evap.mean, na.rm = TRUE))
plot(p10.landuse.change$CENTROID_Y, p10.landuse.change$evap.mean, xlab = 'Latitude (deg N)', 
     ylab = 'Mean Evaporation Change (%)', col = 'red', ylim = c(floor(min), ceiling(max)))
points(p50.landuse.change$CENTROID_Y, p50.landuse.change$evap.mean, col = 'black')
points(p90.landuse.change$CENTROID_Y, p90.landuse.change$evap.mean, col = 'blue')
legend('topright', legend = c('ccP10T10', 'ccP50T50', 'ccP90T90'), fill = c('red', 'black', 'blue'))
dev.off()

png('evap.lon.png', width = 800, height = 600)
min <- min(min(p10.landuse.change$evap.mean, na.rm = TRUE), min(p50.landuse.change$evap.mean, na.rm = TRUE), min(p90.landuse.change$evap.mean, na.rm = TRUE))
max <- max(max(p10.landuse.change$evap.mean, na.rm = TRUE), max(p50.landuse.change$evap.mean, na.rm = TRUE), max(p90.landuse.change$evap.mean, na.rm = TRUE))
plot(p10.landuse.change$CENTROID_X, p10.landuse.change$evap.mean, xlab = 'Longitude (deg W)', 
     ylab = 'Mean Evaporation Change (%)', col = 'red', ylim = c(floor(min), ceiling(max)))
points(p50.landuse.change$CENTROID_X, p50.landuse.change$evap.mean, col = 'black')
points(p90.landuse.change$CENTROID_X, p90.landuse.change$evap.mean, col = 'blue')
legend('topright', legend = c('ccP10T10', 'ccP50T50', 'ccP90T90'), fill = c('red', 'black', 'blue'))
dev.off()

png('evap.p10.lat.png', width = 800, height = 600)
plot(p10.landuse.change$CENTROID_Y, p10.landuse.change$evap.mean, xlab = 'Latitude (deg N)', 
     ylab = 'Mean P10 Evaporation Change (%)')
abline(lm(evap.mean ~ CENTROID_Y, data = p10.landuse.change), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(evap.mean ~ CENTROID_Y, data = p10.landuse.change))$r.squared, 2), sep = ' '))
dev.off()

png('evap.p10.lon.png', width = 800, height = 600)
plot(p10.landuse.change$CENTROID_X, p10.landuse.change$evap.mean, xlab = 'Longitude (deg W)', 
     ylab = 'Mean P10 Evaporation Change (%)')
abline(lm(evap.mean ~ CENTROID_X, data = p10.landuse.change), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(evap.mean ~ CENTROID_X, data = p10.landuse.change))$r.squared, 2), sep = ' '))
dev.off()

png('evap.p50.lat.png', width = 800, height = 600)
plot(p50.landuse.change$CENTROID_Y, p50.landuse.change$evap.mean, xlab = 'Latitude (deg N)', 
     ylab = 'Mean P50 Evaporation Change (%)')
abline(lm(evap.mean ~ CENTROID_Y, data = p50.landuse.change), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(evap.mean ~ CENTROID_Y, data = p50.landuse.change))$r.squared, 2), sep = ' '))
dev.off()

png('evap.p50.lon.png', width = 800, height = 600)
plot(p50.landuse.change$CENTROID_X, p50.landuse.change$evap.mean, xlab = 'Longitude (deg W)', 
     ylab = 'Mean P50 Evaporation Change (%)')
abline(lm(evap.mean ~ CENTROID_X, data = p50.landuse.change), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(evap.mean ~ CENTROID_X, data = p50.landuse.change))$r.squared, 2), sep = ' '))
dev.off()

png('evap.p90.lat.png', width = 800, height = 600)
plot(p90.landuse.change$CENTROID_Y, p90.landuse.change$evap.mean, xlab = 'Latitude (deg N)', 
     ylab = 'Mean P90 Evaporation Change (%)')
abline(lm(evap.mean ~ CENTROID_Y, data = p90.landuse.change), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(evap.mean ~ CENTROID_Y, data = p90.landuse.change))$r.squared, 2), sep = ' '))
dev.off()

png('evap.p90.lon.png', width = 800, height = 600)
plot(p90.landuse.change$CENTROID_X, p90.landuse.change$evap.mean, xlab = 'Longitude (deg W)', 
     ylab = 'Mean P90 Evaporation Change (%)')
abline(lm(evap.mean ~ CENTROID_X, data = p90.landuse.change), col = 'red')
legend('bottomright', legend = paste('Rsq =', round(summary(lm(evap.mean ~ CENTROID_X, data = p90.landuse.change))$r.squared, 2), sep = ' '))
dev.off()

png('evap.vs.prcp.png', width = 800, height = 600)
plot(pct.changes.10$evap.mean, pct.changes.10$prcp.mean, ylim = c(-10,30), xlim = c(3, 11), col = 'red',
     xlab = 'Mean Evaporation Change (%)', ylab = 'Mean Precipitation Change (%)')
points(pct.changes.50$evap.mean, pct.changes.50$prcp.mean, col = 'black')
points(pct.changes.90$evap.mean, pct.changes.90$prcp.mean, col = 'blue')
legend('bottomright', legend = c('ccP10T10', 'ccP50T50', 'ccP90T90'), fill = c('red', 'black', 'blue'))
dev.off()

# Calculating correlation coefficients
# Evap and Prcp
cor(pct.changes.10$evap.mean, pct.changes.10$prcp.mean)
#0.52 for P10
cor(pct.changes.50$evap.mean, pct.changes.50$prcp.mean)
#0.60 for P50
cor(pct.changes.90$evap.mean, pct.changes.90$prcp.mean)
#-0.49 for P90

pct.changes.10.corr <- merge(pct.changes.10, TEMP.ENS.10.PCT, by.x = 'segment', by.y = 'FIPS_NHL', all.x = TRUE)
pct.changes.50.corr <- merge(pct.changes.50, TEMP.ENS.50.PCT, by.x = 'segment', by.y = 'FIPS_NHL', all.x = TRUE)
pct.changes.90.corr <- merge(pct.changes.90, TEMP.ENS.90.PCT, by.x = 'segment', by.y = 'FIPS_NHL', all.x = TRUE)

# # Evap and Temp
# cor(pct.changes.10.corr$evap.mean, pct.changes.10.corr$Total)
# #0.64 for P10
# cor(pct.changes.50.corr$evap.mean, pct.changes.50.corr$Total)
# #0.85 for P50
# cor(pct.changes.90.corr$evap.mean, pct.changes.90.corr$Total)
# #0.92 for P90
# 
# # Prcp and Temp
# cor(pct.changes.10.corr$prcp.mean, pct.changes.10.corr$Total)
# #0.14 for P10
# cor(pct.changes.50.corr$prcp.mean, pct.changes.50.corr$Total)
# #0.73 for P50
# cor(pct.changes.90.corr$prcp.mean, pct.changes.90.corr$Total)
# #-0.29 for P90

dir.create('~/Precip_and_Temp_Mapper/Land_Use_Thesis')
dir.location <- '~/Precip_and_Temp_Mapper/Land_Use_Thesis'
setwd(dir.location)

map_p10_for <- map_p10 + 
  geom_polygon(aes(fill = for.), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Natural Pervious\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'lightsalmon3', mid = 'white', high = 'green', limits = c(-40,-15),
                       midpoint = -10) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p10_for.png', plot = map_p10_for, width = 6.18, height = 3.68, units = 'in')

map_p10_pas <- map_p10 + 
  geom_polygon(aes(fill = pas), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Hay and Forage\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'lightsalmon3', mid = 'white', high = 'green', limits = c(-30,-15),
                       midpoint = -10) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p10_pas.png', plot = map_p10_pas, width = 6.18, height = 3.68, units = 'in')

map_p10_soy <- map_p10 + 
  geom_polygon(aes(fill = soy), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Commodity Crops\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'lightsalmon3', mid = 'white', high = 'green', limits = c(-25,-10),
                       midpoint = -10) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p10_soy.png', plot = map_p10_soy, width = 6.18, height = 3.68, units = 'in')

map_p10_cch <- map_p10 + 
  geom_polygon(aes(fill = cch), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Turf Grass\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'lightsalmon3', mid = 'white', high = 'green', limits = c(-20,-10),
                       midpoint = -10) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p10_cch.png', plot = map_p10_cch, width = 6.18, height = 3.68, units = 'in')

map_p10_cci <- map_p10 + 
  geom_polygon(aes(fill = cci), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Impervious\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'lightsalmon3', mid = 'white', high = 'green', limits = c(-15,-5),
                       midpoint = -5) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p10_cci.png', plot = map_p10_cci, width = 6.18, height = 3.68, units = 'in')

map_p50_for <- map_p50 + 
  geom_polygon(aes(fill = for.), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Natural Pervious\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green3', limits = c(0,15),
                       midpoint = 0) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p50_for.png', plot = map_p50_for, width = 6.18, height = 3.68, units = 'in')

map_p50_pas <- map_p50 + 
  geom_polygon(aes(fill = pas), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Hay and Forage\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green3', limits = c(0,15),
                       midpoint = 0) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p50_pas.png', plot = map_p50_pas, width = 6.18, height = 3.68, units = 'in')

map_p50_soy <- map_p50 + 
  geom_polygon(aes(fill = soy), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Commodity Crops\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green3', limits = c(0,15),
                       midpoint = 0) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p50_soy.png', plot = map_p50_soy, width = 6.18, height = 3.68, units = 'in')

map_p50_cch <- map_p50 + 
  geom_polygon(aes(fill = cch), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Turf Grass\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green3', limits = c(5,12),
                       midpoint = 0) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p50_cch.png', plot = map_p50_cch, width = 6.18, height = 3.68, units = 'in')

map_p50_cci <- map_p50 + 
  geom_polygon(aes(fill = cci), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Impervious\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green3', limits = c(0,10),
                       midpoint = 0) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p50_cci.png', plot = map_p50_cci, width = 6.18, height = 3.68, units = 'in')

map_p90_for <- map_p90 + 
  geom_polygon(aes(fill = for.), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Natural Pervious\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'darkorchid3', limits = c(30,75),
                       midpoint = 25) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p90_for.png', plot = map_p90_for, width = 6.18, height = 3.68, units = 'in')

map_p90_pas <- map_p90 + 
  geom_polygon(aes(fill = pas), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Hay and Forage\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'darkorchid3', limits = c(30,70),
                       midpoint = 25) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p90_pas.png', plot = map_p90_pas, width = 6.18, height = 3.68, units = 'in')

map_p90_soy <- map_p90 + 
  geom_polygon(aes(fill = soy), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Commodity Crops\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'darkorchid3', limits = c(30,65),
                       midpoint = 25) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p90_soy.png', plot = map_p90_soy, width = 6.18, height = 3.68, units = 'in')

map_p90_cch <- map_p90 + 
  geom_polygon(aes(fill = cch), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Turf Grass\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'darkorchid3', limits = c(25,50),
                       midpoint = 25) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p90_cch.png', plot = map_p90_cch, width = 6.18, height = 3.68, units = 'in')

map_p90_cci <- map_p90 + 
  geom_polygon(aes(fill = cci), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Impervious\nRunoff\nChange (%)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'darkorchid3', limits = c(20,35),
                       midpoint = 20) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave('map_p90_cci.png', plot = map_p90_cci, width = 6.18, height = 3.68, units = 'in')

jpeg('compare_scen_for.jpeg', width = 1300, height = 258)
compare_prcp <- grid.arrange(grobs = list(
  map_p10_for, map_p50_for, map_p90_for),
  widths = c(1.25,1.25,1.25),
  layout_matrix = rbind(c(1,2,3))
)
dev.off()

jpeg('compare_scen_pas.jpeg', width = 1300, height = 258)
compare_prcp <- grid.arrange(grobs = list(
  map_p10_pas, map_p50_pas, map_p90_pas),
  widths = c(1.25,1.25,1.25),
  layout_matrix = rbind(c(1,2,3))
)
dev.off()

jpeg('compare_scen_soy.jpeg', width = 1300, height = 258)
compare_prcp <- grid.arrange(grobs = list(
  map_p10_soy, map_p50_soy, map_p90_soy),
  widths = c(1.25,1.25,1.25),
  layout_matrix = rbind(c(1,2,3))
)
dev.off()

jpeg('compare_scen_cch.jpeg', width = 1300, height = 258)
compare_prcp <- grid.arrange(grobs = list(
  map_p10_cch, map_p50_cch, map_p90_cch),
  widths = c(1.25,1.25,1.25),
  layout_matrix = rbind(c(1,2,3))
)
dev.off()

jpeg('compare_scen_cci.jpeg', width = 1300, height = 258)
compare_prcp <- grid.arrange(grobs = list(
  map_p10_cci, map_p50_cci, map_p90_cci),
  widths = c(1.25,1.25,1.25),
  layout_matrix = rbind(c(1,2,3))
)
dev.off()

min(lsegs.df_p10$for.)
as.character(unique(lsegs.df_p10$FIPS_NHL[which(lsegs.df_p10$for. == min(lsegs.df_p10$for.))]))
max(lsegs.df_p10$for.)
as.character(unique(lsegs.df_p10$FIPS_NHL[which(lsegs.df_p10$for. == max(lsegs.df_p10$for.))]))
min(lsegs.df_p50$for.)
as.character(unique(lsegs.df_p50$FIPS_NHL[which(lsegs.df_p50$for. == min(lsegs.df_p50$for.))]))
max(lsegs.df_p50$for.)
as.character(unique(lsegs.df_p50$FIPS_NHL[which(lsegs.df_p50$for. == max(lsegs.df_p50$for.))]))
min(lsegs.df_p90$for.)
as.character(unique(lsegs.df_p90$FIPS_NHL[which(lsegs.df_p90$for. == min(lsegs.df_p90$for.))]))
max(lsegs.df_p90$for.)
as.character(unique(lsegs.df_p90$FIPS_NHL[which(lsegs.df_p90$for. == max(lsegs.df_p90$for.))]))

min(lsegs.df_p10$pas)
as.character(unique(lsegs.df_p10$FIPS_NHL[which(lsegs.df_p10$pas == min(lsegs.df_p10$pas))]))
max(lsegs.df_p10$pas)
as.character(unique(lsegs.df_p10$FIPS_NHL[which(lsegs.df_p10$pas == max(lsegs.df_p10$pas))]))
min(lsegs.df_p50$pas)
as.character(unique(lsegs.df_p50$FIPS_NHL[which(lsegs.df_p50$pas == min(lsegs.df_p50$pas))]))
max(lsegs.df_p50$pas)
as.character(unique(lsegs.df_p50$FIPS_NHL[which(lsegs.df_p50$pas == max(lsegs.df_p50$pas))]))
min(lsegs.df_p90$pas)
as.character(unique(lsegs.df_p90$FIPS_NHL[which(lsegs.df_p90$pas == min(lsegs.df_p90$pas))]))
max(lsegs.df_p90$pas)
as.character(unique(lsegs.df_p90$FIPS_NHL[which(lsegs.df_p90$pas == max(lsegs.df_p90$pas))]))

min(lsegs.df_p10$soy)
as.character(unique(lsegs.df_p10$FIPS_NHL[which(lsegs.df_p10$soy == min(lsegs.df_p10$soy))]))
max(lsegs.df_p10$soy)
as.character(unique(lsegs.df_p10$FIPS_NHL[which(lsegs.df_p10$soy == max(lsegs.df_p10$soy))]))
min(lsegs.df_p50$soy)
as.character(unique(lsegs.df_p50$FIPS_NHL[which(lsegs.df_p50$soy == min(lsegs.df_p50$soy))]))
max(lsegs.df_p50$soy)
as.character(unique(lsegs.df_p50$FIPS_NHL[which(lsegs.df_p50$soy == max(lsegs.df_p50$soy))]))
min(lsegs.df_p90$soy)
as.character(unique(lsegs.df_p90$FIPS_NHL[which(lsegs.df_p90$soy == min(lsegs.df_p90$soy))]))
max(lsegs.df_p90$soy)
as.character(unique(lsegs.df_p90$FIPS_NHL[which(lsegs.df_p90$soy == max(lsegs.df_p90$soy))]))

min(lsegs.df_p10$cch)
as.character(unique(lsegs.df_p10$FIPS_NHL[which(lsegs.df_p10$cch == min(lsegs.df_p10$cch))]))
max(lsegs.df_p10$cch)
as.character(unique(lsegs.df_p10$FIPS_NHL[which(lsegs.df_p10$cch == max(lsegs.df_p10$cch))]))
min(lsegs.df_p50$cch)
as.character(unique(lsegs.df_p50$FIPS_NHL[which(lsegs.df_p50$cch == min(lsegs.df_p50$cch))]))
max(lsegs.df_p50$cch)
as.character(unique(lsegs.df_p50$FIPS_NHL[which(lsegs.df_p50$cch == max(lsegs.df_p50$cch))]))
min(lsegs.df_p90$cch)
as.character(unique(lsegs.df_p90$FIPS_NHL[which(lsegs.df_p90$cch == min(lsegs.df_p90$cch))]))
max(lsegs.df_p90$cch)
as.character(unique(lsegs.df_p90$FIPS_NHL[which(lsegs.df_p90$cch == max(lsegs.df_p90$cch))]))

min(lsegs.df_p10$cci)
as.character(unique(lsegs.df_p10$FIPS_NHL[which(lsegs.df_p10$cci == min(lsegs.df_p10$cci))]))
max(lsegs.df_p10$cci)
as.character(unique(lsegs.df_p10$FIPS_NHL[which(lsegs.df_p10$cci == max(lsegs.df_p10$cci))]))
min(lsegs.df_p50$cci)
as.character(unique(lsegs.df_p50$FIPS_NHL[which(lsegs.df_p50$cci == min(lsegs.df_p50$cci))]))
max(lsegs.df_p50$cci)
as.character(unique(lsegs.df_p50$FIPS_NHL[which(lsegs.df_p50$cci == max(lsegs.df_p50$cci))]))
min(lsegs.df_p90$cci)
as.character(unique(lsegs.df_p90$FIPS_NHL[which(lsegs.df_p90$cci == min(lsegs.df_p90$cci))]))
max(lsegs.df_p90$cci)
as.character(unique(lsegs.df_p90$FIPS_NHL[which(lsegs.df_p90$cci == max(lsegs.df_p90$cci))]))
