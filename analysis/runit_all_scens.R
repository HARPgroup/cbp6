data.location <- 'C:\\Users\\danie\\Documents\\HARP\\GitHub\\cbp6\\Data\\CBP6_Temp_Prcp_Data'
hydro_tools <- '/Users/danie/Documents/HARP/GitHub/hydro-tools';

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
library(ggplot2)
library(dplyr)
library(rgeos)
library(ggsn)
library(gridExtra)

# reading in lr-seg layer
lrsegs <- readOGR('.', 'P6Beta_v3_LRSegs_081516')
lrsegs.va <- lrsegs[lrsegs@data$ST == 'VA',]

rsegs.va.names <- as.character(unique(lrsegs.va@data$RiverSeg))

avg.runit.vals <- data.frame(matrix(data = NA, ncol = 5, nrow = length(rsegs.va.names)))
colnames(avg.runit.vals) <- c('FIPS_NHL', 'run15', 'run14', 'run16', 'run11')

# FOR NOW, WEIRD PROBLEMS WITH SEG 75 --fixed
# rsegs.va.names <- rsegs.va.names[-75]

for (i in 1:length(rsegs.va.names)) {
  # Downloading local runoff inflow data
  rm(lri.dat15)
  lri.dat15 <- vahydro_import_local.runoff.inflows_cfs(rsegs.va.names[i], '15', token, site, start.date, end.date);
  if (lri.dat15 == FALSE) {
    lri.dat15 <- data.frame(matrix(data = NA, ncol = 2, nrow = 1))
    colnames(lri.dat15) <- c('date', 'flow.unit')
  }
  lri.dat15 <- subset(lri.dat15, lri.dat15$date >= start.date & lri.dat15$date <= end.date);
  
  avg.runit.vals[i,1] <- rsegs.va.names[i]
  avg.runit.vals[i,2] <- mean(lri.dat15$flow.unit)
  
  # Downloading local runoff inflow data
  rm(lri.dat14)
  lri.dat14 <- vahydro_import_local.runoff.inflows_cfs(rsegs.va.names[i], '14', token, site, start.date, end.date);
  if (lri.dat14 == FALSE) {
    lri.dat14 <- data.frame(matrix(data = NA, ncol = 2, nrow = 1))
    colnames(lri.dat14) <- c('date', 'flow.unit')
  }
  lri.dat14 <- subset(lri.dat14, lri.dat14$date >= start.date & lri.dat14$date <= end.date);
  avg.runit.vals[i,3] <- mean(lri.dat14$flow.unit)
  
  # Downloading local runoff inflow data
  rm(lri.dat16)
  lri.dat16 <- vahydro_import_local.runoff.inflows_cfs(rsegs.va.names[i], '16', token, site, start.date, end.date);
  if (lri.dat16 == FALSE) {
    lri.dat16 <- data.frame(matrix(data = NA, ncol = 2, nrow = 1))
    colnames(lri.dat16) <- c('date', 'flow.unit')
  }
  lri.dat16 <- subset(lri.dat16, lri.dat16$date >= start.date & lri.dat16$date <= end.date);
  avg.runit.vals[i,4] <- mean(lri.dat16$flow.unit)
  
  # Downloading local runoff inflow data
  rm(lri.dat11)
  lri.dat11 <- vahydro_import_local.runoff.inflows_cfs(rsegs.va.names[i], '11', token, site, start.date, end.date);
  if (lri.dat11 == FALSE) {
    lri.dat11 <- data.frame(matrix(data = NA, ncol = 2, nrow = 1))
    colnames(lri.dat11) <- c('date', 'flow.unit')
  }
  lri.dat11 <- subset(lri.dat11, lri.dat11$date >= start.date & lri.dat11$date <= end.date);
  avg.runit.vals[i,5] <- mean(lri.dat11$flow.unit)
}

avg.runit.vals[avg.runit.vals == 'NaN'] <- NA

write.csv(avg.runit.vals, "avg.runit.vals.csv")
avg.runit.vals <- avg.runit.vals[complete.cases(avg.runit.vals),]

runit.percent.difference <- data.frame(matrix(data = NA, ncol = 4, nrow = length(avg.runit.vals$FIPS_NHL)))
colnames(runit.percent.difference) <- c('FIPS_NHL', 'run15', 'run14', 'run16')
runit.percent.difference$FIPS_NHL <- avg.runit.vals$FIPS_NHL
runit.percent.difference$run15 <- 100*(avg.runit.vals$run15-avg.runit.vals$run11)/(avg.runit.vals$run11)
runit.percent.difference$run14 <- 100*(avg.runit.vals$run14-avg.runit.vals$run11)/(avg.runit.vals$run11)
runit.percent.difference$run16 <- 100*(avg.runit.vals$run16-avg.runit.vals$run11)/(avg.runit.vals$run11)

write.csv(runit.percent.difference, "runit.percent.difference.csv")

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

run15_runit_overall <- map + 
  ggtitle('Runoff Unit Flow (Overall, Run 15)') +
  geom_polygon(aes(fill = run15), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Runoff\nUnit Flow\n(cfs/sq.mi.)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0.5, 3)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave(paste0('run15_runit.overall.png'), plot = run15_runit_overall, width = 6.18, height = 3.68, units = 'in')

run14_runit_overall <- map + 
  ggtitle('Runoff Unit Flow (Overall, Run 14)') +
  geom_polygon(aes(fill = run14), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Runoff\nUnit Flow\n(cfs/sq.mi.)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0.5, 3)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave(paste0('run14_runit.overall.png'), plot = run14_runit_overall, width = 6.18, height = 3.68, units = 'in')

run16_runit_overall <- map + 
  ggtitle('Runoff Unit Flow (Overall, Run 16)') +
  geom_polygon(aes(fill = run16), color = 'black', size = 0.1) +
  guides(fill=guide_colorbar(title="Runoff\nUnit Flow\n(cfs/sq.mi.)")) + 
  theme(legend.justification=c(0,1), legend.position=c(0,1)) +
  xlab('Longitude (deg W)') + ylab('Latitude (deg N)')+
  scale_fill_gradient2(low = 'brown', mid = 'white', high = 'green', limits = c(0.5, 3)) +
  north(bbDF, location = 'topright', symbol = 12, scale=0.1)+
  scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', 
           transform = TRUE, model = 'WGS84',st.bottom=FALSE, 
           st.size = 3.5, st.dist = 0.0285,
           anchor = c(
             x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
             y = extent$y[1]+(extent$y[1])*0.001
           ))
ggsave(paste0('run16_runit.overall.png'), plot = run16_runit_overall, width = 6.18, height = 3.68, units = 'in')

jpeg(paste0('compare_scen_runit.jpeg'), width = 1300, height = 258)
runit <- grid.arrange(grobs = list(
  run15_runit_overall, run14_runit_overall, run16_runit_overall),
  widths = c(1.25,1.25,1.25,1.25,1.25,1.25),
  layout_matrix = rbind(c(1,1,2,2,3,3))
)
dev.off()

avg.runit.vals$run15[which(avg.runit.vals$run15 == 0)] <- NA
avg.runit.vals$run14[which(avg.runit.vals$run14 == 0)] <- NA
avg.runit.vals$run16[which(avg.runit.vals$run16 == 0)] <- NA

runit_avgs <- as.data.frame(matrix(data = NA, nrow = 3, ncol = 5))
colnames(runit_avgs) <- c('Lowest Flow (cfs/sq mi)', 'Median Flow (cfs/sq mi)', 
                          'Highest Flow (cfs/sq mi)', 'Range of Flows (cfs/sq mi)',
                          'Average Flow (cfs/sq mi)')
rownames(runit_avgs) <- c('Run 15', 'Run 14', 'Run 16')
runit_avgs$`Lowest Flow (cfs/sq mi)` <- c(round(min(avg.runit.vals$run15, na.rm = TRUE), 2),
                                          round(min(avg.runit.vals$run14, na.rm = TRUE), 2),
                                          round(min(avg.runit.vals$run16, na.rm = TRUE), 2))
runit_avgs$`Median Flow (cfs/sq mi)` <- c(round(median(avg.runit.vals$run15, na.rm = TRUE), 2),
                                          round(median(avg.runit.vals$run14, na.rm = TRUE), 2),
                                          round(median(avg.runit.vals$run16, na.rm = TRUE), 2))
runit_avgs$`Highest Flow (cfs/sq mi)` <- c(round(max(avg.runit.vals$run15, na.rm = TRUE), 2),
                                           round(max(avg.runit.vals$run14, na.rm = TRUE), 2),
                                           round(max(avg.runit.vals$run16, na.rm = TRUE), 2))
runit_avgs$`Range of Flows (cfs/sq mi)` <- runit_avgs$`Highest Flow (cfs/sq mi)` - runit_avgs$`Lowest Flow (cfs/sq mi)`
runit_avgs$`Average Flow (cfs/sq mi)` <- c(round(mean(avg.runit.vals$run15, na.rm = TRUE), 2),
                                           round(mean(avg.runit.vals$run14, na.rm = TRUE), 2),
                                           round(mean(avg.runit.vals$run16, na.rm = TRUE), 2))

library(readxl)
library(kableExtra)

# OUTPUT TABLE IN KABLE FORMAT
kable(runit_avgs, "latex", booktabs = T,
      caption = paste("P10, P50, and P90 Runoff Unit Flows"), 
      label = paste("P10, P50, and P90 Runoff Unit Flows"),
      col.names = c('Lowest Flow (cfs/sq mi)', 'Median Flow (cfs/sq mi)', 
                    'Highest Flow (cfs/sq mi)', 'Range of Flows (cfs/sq mi)',
                    'Average Flow (cfs/sq mi)')) %>%
  kable_styling(latex_options = c("striped", "scale_down")) %>% 
  #column_spec(1, width = "5em") %>%
  #column_spec(2, width = "5em") %>%
  #column_spec(3, width = "5em") %>%
  #column_spec(4, width = "4em") %>%
  cat(., file = paste(dir.location,"/kable_tables/","runit_avgs.tex",sep=""))
