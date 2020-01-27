data.location <- 'C:\\Users\\danie\\Documents\\HARP\\GitHub\\cbp6\\Data\\CBP6_Temp_Prcp_Data'
hydro_tools <- '/Users/danie/Documents/HARP/GitHub/hydro-tools';
run.id <- '14'

start.date <- '1990-01-01'
end.date <- '2000-12-31'

github_link <- "C:\\Users\\danie\\Documents\\HARP\\GitHub"
cbp6_link <- paste0(github_link, "/cbp6/code");
source(paste0(cbp6_link,"/cbp6_functions.R"))
source(paste(github_link,"auth.private", sep = "/"));#load rest username and password, contained in
source(paste(cbp6_link, "/fn_vahydro-1.0.R", sep = ''))
site <- 'http://deq2.bse.vt.edu/d.dh'
token <- rest_token(site, token, rest_uname, rest_pw);

# CREATING DIRECTORY TO STORE DATA AND OUTPUTS
dir.create('~/Precip_and_Temp_Mapper')
dir.location <- '~/Precip_and_Temp_Mapper'
setwd(dir.location)

#NEED TO FIND VA RSEG LAYER

# downloading data
download.file('ftp://ftp.chesapeakebay.net/gis/ModelingP6/P6Beta_v3_LRSegs_081516.zip', destfile = '~/p6_lrsegs.zip')
unzip('~/p6_lrsegs.zip', exdir = '.')

library(rgdal)
# reading in lr-seg layer
lrsegs <- readOGR('.', 'P6Beta_v3_LRSegs_081516')
lrsegs.va <- lrsegs[lrsegs@data$ST == 'VA',]

rsegs.va.names <- as.character(unique(lrsegs.va@data$RiverSeg))

avg.runit.vals <- data.frame(matrix(data = NA, ncol = 14, nrow = length(rsegs.va.names)))
colnames(avg.runit.vals) <- c('FIPS_NHL', 'Total', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')

# FOR NOW, WEIRD PROBLEMS WITH SEG 75 --fixed
# rsegs.va.names <- rsegs.va.names[-75]

for (i in 1:length(rsegs.va.names)) {
  # Downloading local runoff inflow data
  rm(lri.dat)
  lri.dat <- vahydro_import_local.runoff.inflows_cfs(rsegs.va.names[i], run.id, token, site, start.date, end.date);
  if (lri.dat == FALSE) {
    lri.dat <- data.frame(matrix(data = NA, ncol = 2, nrow = 1))
    colnames(lri.dat) <- c('date', 'flow.unit')
  }
  lri.dat <- subset(lri.dat, lri.dat$date >= start.date & lri.dat$date <= end.date);
  
  avg.runit.vals[i,1] <- rsegs.va.names[i]
  avg.runit.vals[i,2] <- mean(lri.dat$flow.unit)
  avg.runit.vals[i,3] <- mean(lri.dat$flow.unit[month(lri.dat$date) == 1])
  avg.runit.vals[i,4] <- mean(lri.dat$flow.unit[month(lri.dat$date) == 2])
  avg.runit.vals[i,5] <- mean(lri.dat$flow.unit[month(lri.dat$date) == 3])
  avg.runit.vals[i,6] <- mean(lri.dat$flow.unit[month(lri.dat$date) == 4])
  avg.runit.vals[i,7] <- mean(lri.dat$flow.unit[month(lri.dat$date) == 5])
  avg.runit.vals[i,8] <- mean(lri.dat$flow.unit[month(lri.dat$date) == 6])
  avg.runit.vals[i,9] <- mean(lri.dat$flow.unit[month(lri.dat$date) == 7])
  avg.runit.vals[i,10] <- mean(lri.dat$flow.unit[month(lri.dat$date) == 8])
  avg.runit.vals[i,11] <- mean(lri.dat$flow.unit[month(lri.dat$date) == 9])
  avg.runit.vals[i,12] <- mean(lri.dat$flow.unit[month(lri.dat$date) == 10])
  avg.runit.vals[i,13] <- mean(lri.dat$flow.unit[month(lri.dat$date) == 11])
  avg.runit.vals[i,14] <- mean(lri.dat$flow.unit[month(lri.dat$date) == 12])
}

avg.runit.vals[avg.runit.vals == 'NaN'] <- NA

#--------------------------------------------------------------------------------------------
#LOAD STATE GEOMETRY
#--------------------------------------------------------------------------------------------
STATES <- read.table(file=paste(hydro_tools,"GIS_LAYERS","STATES.tsv",sep="\\"), header=TRUE, sep="\t") #Load state geometries

#specify spatial extent for map  
extent <- data.frame(x = c(-82, -75), 
                     y = c(36.5, 39.5))  


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

rsegs <- readOGR(paste0(data.location, '\\P6_RSegs_VA'), 'P6_RSegs_VA')
rsegs <- spTransform(rsegs, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
rsegs@data$id <- rownames(rsegs@data)
rsegs.df <- fortify(rsegs)
rsegs.df <- merge(rsegs.df, rsegs@data, by = 'id')

rsegs.df <- merge(rsegs.df, avg.runit.vals, by.x = 'RiverSeg', by.y = 'FIPS_NHL')

map <- ggplot(data = rsegs.df, aes(x = long, y = lat, group = group))+
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

library(ggsn)
map + 
  geom_polygon(aes(fill = Total), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Runoff\nUnit Flow\n(cfs/sq.mi.)")) + 
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
