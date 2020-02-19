library(ggplot2)
library(rgeos)
library(ggsn)
library(rgdal)
library(dplyr)
library(httr)
library(tidyverse)

site <- "http://deq2.bse.vt.edu/d.dh"
github_link <- "C:\\Users\\Kevin D'Andrea\\Desktop\\HARP\\GitHub"
cbp6_link = paste0(github_link, "/cbp6/code");

#Sourcing functions

source(paste0(cbp6_link,"/cbp6_functions.R"))

#retrieve rest token
source(paste0(github_link, "/auth.private"));

#retrieve rest token

token <- rest_token(site, token, rest_uname, rest_pw);

options(timeout=120); # set timeout to twice default level to avoid abort due to high traffic

#Download DoR data from VAHydro
met.varkey <- 'dor_year'
#info <- read.csv(paste0(github_link, "/cbp6/code/data.csv"))
#colnames(info)[3] <- met.varkey
#info[,3] <- NA
#i <- 1

# while (i<=length(info$riv.seg)) {
#   riv.seg <- as.character(info[i,1])
#   info[i,3] <- vahydro_import_metric(met.varkey, met.propcode = '', seg.or.gage = riv.seg, mod.scenario = "CFBASE30Y20180615", token = token, site)
#   i <- i+1
# }

#--------------------------------------------------------------------------------------------
#LOAD STATE GEOMETRY
#--------------------------------------------------------------------------------------------
STATES <- read.table(file = 'https://raw.githubusercontent.com/HARPgroup/cbp6/master/code/GIS_LAYERS/STATES.tsv', sep = '\t', header = TRUE)
# hydro_tools <- '/Users/danie/Documents/HARP/GitHub/hydro-tools';
# STATES <- read.table(file=paste(hydro_tools,"GIS_LAYERS","STATES.tsv",sep="\\"), header=TRUE, sep="\t") #Load state geometries

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

# Loading LandSeg Shape Data -----
lsegs.csv <- read.table(file = 'https://raw.githubusercontent.com/HARPgroup/cbp6/master/code/GIS_LAYERS/P6_RSegs_VA.csv', header = TRUE, sep = '\t')
lsegs.csv$id <- as.character(c(1:nrow(lsegs.csv)))
rownames(lsegs.csv) <- c(1:nrow(lsegs.csv))
# lsegs.csv$dor_year <- NA
lseg.list <- list()
for (i in 1:length(lsegs.csv$id)) {
  # riv.seg <- as.character(lsegs.csv$RiverSeg[i])
  # temp.met <- vahydro_import_metric(met.varkey, met.propcode = '', seg.or.gage = riv.seg, mod.scenario = "CFBASE30Y20180615", token = token, site)
  # if (is.numeric(temp.met) == TRUE) {
  #   lsegs.csv$dor_year[i] <- temp.met
  # }
  #lseg.namer <- paste0('lseg_', i)
  lsegs_geom <- readWKT(lsegs.csv$WKT[as.numeric(lsegs.csv$id[i])])
  lsegs_geom_clip <- gIntersection(bb, lsegs_geom)
  lsegsProjected <- SpatialPolygonsDataFrame(lsegs_geom_clip, data.frame('id'), match.ID = TRUE)
  lsegsProjected@data$id <- as.character(lsegs.csv$id[i])
  #lsegsPoints <- fortify(lsegsProjected, region = 'id')
  #lsegsDF <- merge(lsegsPoints, lsegsProjected@data, by = 'id')
  #assign(lseg.namer, lsegsDF)
  lseg.list[i] <- lsegsProjected
}
lsegs <- do.call('rbind', lseg.list)

lsegs@data <- merge(lsegs@data, lsegs.csv, by = 'id') # IS THIS THE PROBLEM? -- NO

dor.year.df <- data.frame(matrix(NA, nrow = nrow(lsegs@data), ncol = 2))
colnames(dor.year.df) = c('riv.seg', 'dor.year')
dor.year.df$riv.seg <- lsegs.csv$RiverSeg
for (i in 1:length(dor.year.df$riv.seg)) {
  riv.seg <- as.character(dor.year.df$riv.seg[i])
  temp.scen.prop <- get.scen.prop(riv.seg = riv.seg, mod.scenario = 'CFBASE30Y20180615', dat.source = 'vahydro', run.id = '11', start.date = '1984-01-01', end.date = '2014-12-31', site, token = token)
  #temp.met <- vahydro_import_metric(met.varkey, met.propcode = '', seg.or.gage = riv.seg, mod.scenario = "CFBASE30Y20180615", token = token, site)
  if (temp.scen.prop == FALSE) {
    temp.met <- FALSE
  }
  else (
  temp.met <- vahydro_import_metric_from_scenprop(scenprop.pid = temp.scen.prop, met.varkey, met.propcode = '', site, token = token)
  )
  dor.year.df$dor.year[i] <- temp.met
}

lsegs@data <- merge(lsegs@data, dor.year.df, by.x = 'RiverSeg', by.y = 'riv.seg')


#lsegs@data <- lsegs@data[,-c(2:3)]

# plot(lsegs)
# lseg.loc <- '/Users/danie/Documents/HARP/GitHub/cbp6/Data/CBP6_Temp_Prcp_Data/P6_LSegs_VA'
# lsegs.test <- readOGR(lseg.loc, 'P6_LSegs_VA')
# lsegs.test <- spTransform(lsegs.test, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
# lsegs.test@data$id <- rownames(lsegs.test@data)
# lsegs.test.df <- fortify(lsegs.test)
# lsegs.test.df <- merge(lsegs.test.df, lsegs.test@data, by = 'id')
# plot(lsegs.test)

#lsegs@data <- merge(lsegs@data,info, by.x="RiverSeg", by.y="riv.seg", all=TRUE)
lsegs@data <- lsegs@data[order(as.numeric(lsegs@data$id)),]
lsegs.df <- fortify(lsegs, region = 'id') # FORTIFY GIVES A DIFFERENT ID IF LSEGS IS PREVIOUSLY UNORDERED BY A SEPARATE MERGE
lsegs.df <- merge(lsegs.df, lsegs@data, by = 'id') # THIS IS THE ISSUE
lsegs.df$dor.year[lsegs.df$dor.year == 0] <- NA
#lsegs.df <- merge(lsegs.df,info, by.x="RiverSeg", by.y="riv.seg", all=TRUE)

# usually, lsegs.df is then merged with the data frame whose data you want
# to make a choropleth map of, based on the "FIPS_NHL" trait -- that is,
# the name of the land segment


map <- ggplot(data = lsegs.df, aes(x = long, y = lat, group = group))+
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

# CHANGE "SHAPE_AREA" TO WHATEVER COLUMN IN LSEGS.DF YOU WANT A
# CHOROPLETH MAP OF
map + 
  geom_polygon(aes(fill = as.factor(dor.year.y), group=group), color = as.factor('black'), size = 0.1) +
  guides(fill=guide_legend(title=paste0("Legend\n",met.varkey))) +
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_manual(values = c("red4","red", "darkorange", "yellow","greenyellow",
                               "green3","turquoise3", "dodgerblue3","royalblue4",
                               "slateblue3","mediumpurple","violetred","plum","thistle1",
                               "snow1"), na.value = 'grey50') +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
