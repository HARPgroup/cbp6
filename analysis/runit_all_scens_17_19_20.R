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
colnames(avg.runit.vals) <- c('FIPS_NHL', 'run17', 'run19', 'run20', 'run11')

# FOR NOW, WEIRD PROBLEMS WITH SEG 75 --fixed
# rsegs.va.names <- rsegs.va.names[-75]

for (i in 1:length(rsegs.va.names)) {
  # Downloading local runoff inflow data
  rm(lri.dat17)
  lri.dat17 <- vahydro_import_local.runoff.inflows_cfs(rsegs.va.names[i], '17', token, site, start.date, end.date);
  if (lri.dat17 == FALSE) {
    lri.dat17 <- data.frame(matrix(data = NA, ncol = 2, nrow = 1))
    colnames(lri.dat17) <- c('date', 'flow.unit')
  }
  lri.dat17 <- subset(lri.dat17, lri.dat17$date >= start.date & lri.dat17$date <= end.date);
  
  avg.runit.vals[i,1] <- rsegs.va.names[i]
  avg.runit.vals[i,2] <- mean(lri.dat17$flow.unit)
  
  # Downloading local runoff inflow data
  rm(lri.dat19)
  lri.dat19 <- vahydro_import_local.runoff.inflows_cfs(rsegs.va.names[i], '19', token, site, start.date, end.date);
  if (lri.dat19 == FALSE) {
    lri.dat19 <- data.frame(matrix(data = NA, ncol = 2, nrow = 1))
    colnames(lri.dat19) <- c('date', 'flow.unit')
  }
  lri.dat19 <- subset(lri.dat19, lri.dat19$date >= start.date & lri.dat19$date <= end.date);
  avg.runit.vals[i,3] <- mean(lri.dat19$flow.unit)
  
  # Downloading local runoff inflow data
  rm(lri.dat20)
  lri.dat20 <- vahydro_import_local.runoff.inflows_cfs(rsegs.va.names[i], '20', token, site, start.date, end.date);
  if (lri.dat20 == FALSE) {
    lri.dat20 <- data.frame(matrix(data = NA, ncol = 2, nrow = 1))
    colnames(lri.dat20) <- c('date', 'flow.unit')
  }
  lri.dat20 <- subset(lri.dat20, lri.dat20$date >= start.date & lri.dat20$date <= end.date);
  avg.runit.vals[i,4] <- mean(lri.dat20$flow.unit)
  
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

write.csv(avg.runit.vals, "avg.runit.vals2.csv")

runit.percent.difference <- data.frame(matrix(data = NA, ncol = 4, nrow = length(avg.runit.vals$FIPS_NHL)))
colnames(runit.percent.difference) <- c('FIPS_NHL', 'run17', 'run19', 'run20')
runit.percent.difference$FIPS_NHL <- avg.runit.vals$FIPS_NHL
runit.percent.difference$run17 <- 100*(avg.runit.vals$run17-avg.runit.vals$run11)/(avg.runit.vals$run11)
runit.percent.difference$run19 <- 100*(avg.runit.vals$run19-avg.runit.vals$run11)/(avg.runit.vals$run11)
runit.percent.difference$run20 <- 100*(avg.runit.vals$run20-avg.runit.vals$run11)/(avg.runit.vals$run11)

write.csv(runit.percent.difference, "runit.percent.difference2.csv")
