library(dataRetrieval)
library(lubridate)
library(plyr)
library(zoo)
library(ggplot2)
library(lfstat)
library(IHA)
library(PearsonDS)
library(scales)
library(readr)
library(httr)
library(dplyr)
library(stringr)
library(RCurl)
library(rgeos)
library(ggmap)
library(ggsn)
library(sp)
library(rlist)


model_import_data_cfs <- function(riv.seg, mod.phase, mod.scenario, start.date = NULL, end.date = NULL, site = "http://deq2.bse.vt.edu/") {
  # Downloading and exporting hourly model data
  model_hourly <- read.csv(paste0(site, mod.phase, "/out/river/", mod.scenario, "/stream/", 
                                  riv.seg, "_0111.csv"), header = FALSE, sep = ",", stringsAsFactors = FALSE); 
  riv.segStr1 <- strsplit(riv.seg, "\\+")
  riv.segStr1 <- riv.segStr1[[1]]
  num.segs1 <- length(riv.segStr1)
  # Converting hourly to daily data and exporting daily data
  model_hourly <- model_hourly[-1,]
  model_hourly$V1 <- trimws(model_hourly$V1, which = "both")
  colnames(model_hourly) <- c("year","month","day","hour","ovol")
  model_hourly$date <- as.Date(paste0(model_hourly$year,"-",model_hourly$month,"-",model_hourly$day))
  model_daily <- aggregate(model_hourly$ovol, list(model_hourly$date), FUN = sum)
  colnames(model_daily) <- c("date","flow")
  if (is.null(start.date)) {
    start.date <- min(model_daily$date)
  }
  if (is.null(end.date)) {
    end.date <- max(model_daily$date)
  }
  start.line <- as.numeric(which(model_daily$date == start.date))
  end.line <- as.numeric(which(model_daily$date == end.date))
  model_daily <- model_daily[start.line:end.line,]
  model_daily$flow <- model_daily$flow * 0.504167 # conversion from acre-feet to cfs
  return(model_daily)
}

model_server_import_data_cfs <- function(riv.seg, mod.phase, mod.scenario, start.date, end.date) {
  # Downloading and exporting hourly model data
  model_hourly <- read.csv(paste0("/opt/model/", mod.phase, "/out/river/", mod.scenario, "/stream/", 
                                  riv.seg, "_0111.csv"), header = FALSE, sep = ",", stringsAsFactors = FALSE); 
  riv.segStr1 <- strsplit(riv.seg, "\\+")
  riv.segStr1 <- riv.segStr1[[1]]
  num.segs1 <- length(riv.segStr1)
  # Converting hourly to daily data and exporting daily data
  model_hourly <- model_hourly[-1,]
  model_hourly$V1 <- trimws(model_hourly$V1, which = "both")
  colnames(model_hourly) <- c("year","month","day","hour","ovol")
  model_hourly$date <- as.Date(paste0(model_hourly$year,"-",model_hourly$month,"-",model_hourly$day))
  model_daily <- aggregate(model_hourly$ovol, list(model_hourly$date), FUN = sum)
  colnames(model_daily) <- c("date","flow")
  start.line <- as.numeric(which(model_daily$date == start.date))
  end.line <- as.numeric(which(model_daily$date == end.date))
  model_daily <- model_daily[start.line:end.line,]
  model_daily$flow <- model_daily$flow * 0.504167 # conversion from acre-feet to cfs
  return(model_daily)
}

gage_import_data_cfs <- function(site_number, start.date, end.date) {
  #Download and export raw USGS data
  pCode <- "00060"
  USGS_daily <- readNWISdv(site_number, pCode, start.date, end.date)
  
  #Format USGS data to date and flow
  USGS_daily <- USGS_daily[,c(3,4)]
  colnames(USGS_daily) <- c('date','flow') 
  return(USGS_daily)
}  

#' Import USGS Gage Information Function 
#' @description Imports data from the USGS, harvested from their stream gages
#' @param riv.seg Specific river segment of interest 
#' @param run.id the VA hydro run ID of the specified vahydro model run
#' @param token the VA hydro token to access the specified site
#' @param site the specified vahydro site to be accessed
#' @param start.date the starting date of analysis, format 'yyyy-mm-dd'
#' @param end.date the ending date of analysis, format 'yyyy-mm-dd'
#' @return A dataframe containing the specfic river segments vahydro model data
#' @import pander
#' @import httr
#' @import hydroTSM
#' @export vahydro_import_data_cfs

vahydro_import_data_cfs <- function(riv.seg, run.id, token, site = "http://deq2.bse.vt.edu/d.dh", start.date = '1984-01-01', end.date = '2005-12-31') {
  hydrocode = paste0("vahydrosw_wshed_", riv.seg);
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list (
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  
  # Get data frame for stashing multirun data
  stash <- data.frame();
  mostash <- data.frame();
  tsstash = FALSE;
  featureid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name );
  inputs <- list(
    varkey = "wshed_local_area_sqmi",
    featureid = featureid,
    entity_type = "dh_feature"
  )
  da <- getProperty(inputs, site, model)
  
  inputs <- list(
    varkey = "om_water_model_node",
    featureid = featureid,
    entity_type = "dh_feature",
    propcode = "vahydro-1.0"
  )
  model <- getProperty(inputs, site, model)
  mid = as.numeric(as.character(model[1,]$pid))
  inputs <- list(
    varkey = "om_element_connection",
    featureid = mid,
    entity_type = "dh_properties"
  )
  prop <- getProperty(inputs, site, prop)
  
  # Manual elid
  elid = as.numeric(as.character(prop[1,]$propvalue))
  
  omsite <- "http://deq2.bse.vt.edu"
  dat <- fn_get_runfile(elid, run.id, site = omsite,  cached = FALSE);
  
  dat.date <- as.Date(as.character(dat$thisdate))
  dat.flow <- as.numeric(dat$Qout)
  
  dat.trim <- data.frame(dat.date, dat.flow, row.names = NULL)
  colnames(dat.trim) <- c('date','flow')
  
  
  start.line <- as.numeric(which(dat.trim$date == start.date))
  end.line <- as.numeric(which(dat.trim$date == end.date))
  dat.trim <- dat.trim[start.line:end.line,]
  
  #dat.trim <- zoo(dat.trim, order.by = dat.trim$date)
  #dat.trim <- window(dat.trim, start = start.date, end = end.date);
  return(dat.trim)
}

vahydro_format_flow_cfs <- function(dat) {
  
  dat.date <- as.Date(as.character(dat$thisdate))
  dat.flow <- as.numeric(dat$Qout)
  
  dat.trim <- data.frame(dat.date, dat.flow, row.names = NULL)
  colnames(dat.trim) <- c('date','flow')
  
  return(dat.trim)
}

vahydro_trim_for_iha <- function(dat, start.date, end.date) {
  # a helper function that uses zoo to filter by date range, but still returns an iha OK format
  dat_formatted <- zoo(dat, order.by = dat$date)
  dat_formatted <- window(dat_formatted, start = start.date, end = end.date)
  ddf.date <- as.Date(as.character(dat_formatted$date))
  ddf.flow <- as.numeric(dat_formatted$flow)
  ddf.trim <- data.frame(ddf.date, ddf.flow, row.names = NULL)
  colnames(ddf.trim) <- c('date','flow')
  return(ddf.trim)
}

vahydro_post_metric <- function(met.varkey, met.propcode, met.name, met.value, seg.or.gage, mod.scenario = "p532cal_062211", token, site) {
  if (nchar(seg.or.gage)==8) {
    # GETTING GAGE DATA FROM VA HYDRO
    hydrocode = paste("usgs_",seg.or.gage,sep="");
    ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
    inputs <- list (
      hydrocode = hydrocode
    )
  } else if (nchar(seg.or.gage)==13) {
    # GETTING MODEL DATA FROM VA HYDRO
    hydrocode = paste("vahydrosw_wshed_",seg.or.gage,sep="");
    ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
    inputs <- list (
      hydrocode = hydrocode,
      bundle = 'watershed',
      ftype = 'vahydro'
    )
  }
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  hydroid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name );
  print(paste("Retrieved hydroid",hydroid,"for", fname,seg.or.gage, sep=' '));
  inputs <- list(
    varkey = "om_model_element",
    featureid = hydroid,
    entity_type = "dh_feature",
    propcode = mod.scenario
  )
  property <- getProperty(inputs, site, property)
  
  metinfo <- list(
    varkey = met.varkey,
    propcode = met.propcode,
    featureid = as.integer(as.character(property$pid)),
    entity_type = "dh_properties"
  )
  metprop <- getProperty(metinfo, site, metprop)
  
  if (identical(metprop, FALSE)) {
    # create
    metprop = metinfo
  }
  
  metprop$propname = met.name
  metprop$varkey = met.varkey
  metprop$propcode = met.propcode
  metprop$propvalue = met.value
  metprop$pid = NULL
  postProperty(metprop,base_url = site,metprop) 
}

vahydro_post_scenario <- function(scen.varkey = 'om_model_element', scen.value = 0, seg.or.gage, mod.scenario, token, site) {
  if (nchar(seg.or.gage)==8) {
    # GETTING GAGE DATA FROM VA HYDRO
    hydrocode = paste("usgs_",seg.or.gage,sep="");
    ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
    inputs <- list (
      hydrocode = hydrocode
    )
  } else if (nchar(seg.or.gage)==13) {
    # GETTING MODEL DATA FROM VA HYDRO
    hydrocode = paste("vahydrosw_wshed_",seg.or.gage,sep="");
    ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
    inputs <- list (
      hydrocode = hydrocode,
      bundle = 'watershed',
      ftype = 'vahydro'
    )
  }
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  hydroid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name);
  print(paste("Retrieved hydroid",hydroid,"for", fname,seg.or.gage, sep=' '));
  inputs <- list(
    varkey = "om_model_element",
    featureid = hydroid,
    entity_type = "dh_feature",
    propcode = mod.scenario
  )
  property <- getProperty(inputs, site, property)
  
  if (identical(property, FALSE)) {
    # create
    property = inputs
  }
  scen.propcode = mod.scenario
  scen.name = paste0(mod.scenario, ':',fname)
  
  property$propname = scen.name
  property$varkey = scen.varkey
  property$propcode = scen.propcode
  property$propvalue = signif(scen.value, digits=3)
  property$pid = NULL
  postProperty(property,base_url = site,property) 
}


vahydro_import_all_metrics <- function(seg.or.gage, mod.scenario, token, site) {
  overall.mean <- vahydro.import.metric(met.varkey = "overall_mean", met.propcode = '', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jan.low.flow <- vahydro.import.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  feb.low.flow <- vahydro.import.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml2', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  mar.low.flow <- vahydro.import.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml3', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  apr.low.flow <- vahydro.import.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml4', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  may.low.flow <- vahydro.import.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml5', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jun.low.flow <- vahydro.import.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml6', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jul.low.flow <- vahydro.import.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml7', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  aug.low.flow <- vahydro.import.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml8', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  sep.low.flow <- vahydro.import.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml9', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  oct.low.flow <- vahydro.import.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml10', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  nov.low.flow <- vahydro.import.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml11', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  dec.low.flow <- vahydro.import.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml12', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jan.mean.flow <- vahydro.import.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  feb.mean.flow <- vahydro.import.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm2', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  mar.mean.flow <- vahydro.import.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm3', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  apr.mean.flow <- vahydro.import.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm4', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  may.mean.flow <- vahydro.import.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm5', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jun.mean.flow <- vahydro.import.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm6', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jul.mean.flow <- vahydro.import.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm7', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  aug.mean.flow <- vahydro.import.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm8', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  sep.mean.flow <- vahydro.import.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm9', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  oct.mean.flow <- vahydro.import.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm10', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  nov.mean.flow <- vahydro.import.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm11', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  dec.mean.flow <- vahydro.import.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm12', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jan.high.flow <- vahydro.import.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  feb.high.flow <- vahydro.import.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh2', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  mar.high.flow <- vahydro.import.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh3', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  apr.high.flow <- vahydro.import.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh4', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  may.high.flow <- vahydro.import.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh5', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jun.high.flow <- vahydro.import.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh6', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jul.high.flow <- vahydro.import.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh7', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  aug.high.flow <- vahydro.import.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh8', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  sep.high.flow <- vahydro.import.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh9', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  oct.high.flow <- vahydro.import.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh10', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  nov.high.flow <- vahydro.import.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh11', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  dec.high.flow <- vahydro.import.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh12', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  one.day.min <- vahydro.import.metric(met.varkey = "min_low_flow", met.propcode = 'min1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  three.day.min <- vahydro.import.metric(met.varkey = "min_low_flow", met.propcode = 'min3', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  seven.day.min <- vahydro.import.metric(met.varkey = "min_low_flow", met.propcode = 'min7', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  thirty.day.min <- vahydro.import.metric(met.varkey = "min_low_flow", met.propcode = 'min30', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  ninety.day.min <- vahydro.import.metric(met.varkey = "min_low_flow", met.propcode = 'min90', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  one.day.med.low <- vahydro.import.metric(met.varkey = "med_low_flow", met.propcode = 'medl1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  three.day.med.low <- vahydro.import.metric(met.varkey = "med_low_flow", met.propcode = 'medl3', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  seven.day.med.low <- vahydro.import.metric(met.varkey = "med_low_flow", met.propcode = 'medl7', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  thirty.day.med.low <- vahydro.import.metric(met.varkey = "med_low_flow", met.propcode = 'medl30', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  ninety.day.med.low <- vahydro.import.metric(met.varkey = "med_low_flow", met.propcode = 'medl90', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  one.day.max <- vahydro.import.metric(met.varkey = "max_high_flow", met.propcode = 'max1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  three.day.max <- vahydro.import.metric(met.varkey = "max_high_flow", met.propcode = 'max3', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  seven.day.max <- vahydro.import.metric(met.varkey = "max_high_flow", met.propcode = 'max7', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  thirty.day.max <- vahydro.import.metric(met.varkey = "max_high_flow", met.propcode = 'max30', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  ninety.day.max <- vahydro.import.metric(met.varkey = "max_high_flow", met.propcode = 'max90', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  one.day.med.high <- vahydro.import.metric(met.varkey = "med_high_flow", met.propcode = 'medh1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  three.day.med.high <- vahydro.import.metric(met.varkey = "med_high_flow", met.propcode = 'medh3', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  seven.day.med.high <- vahydro.import.metric(met.varkey = "med_high_flow", met.propcode = 'medh7', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  thirty.day.med.high <- vahydro.import.metric(met.varkey = "med_high_flow", met.propcode = 'medh30', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  ninety.day.med.high <- vahydro.import.metric(met.varkey = "med_high_flow", met.propcode = 'medh90', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  drought.of.record.mean <- vahydro.import.metric(met.varkey = "dor_mean", met.propcode = '', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  seven.q.ten <- vahydro.import.metric(met.varkey = "7q10", met.propcode = '', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  drought.of.record.year <- vahydro.import.metric(met.varkey = "dor_year", met.propcode = '', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  sep.ten.pct <- vahydro.import.metric(met.varkey = "monthly_non-exceedance", met.propcode = 'mne9_10', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  one.pct.non.exceedance <- vahydro.import.metric(met.varkey = "non-exceedance", met.propcode = 'ne1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  five.pct.non.exceedance <- vahydro.import.metric(met.varkey = "non-exceedance", met.propcode = 'ne5', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  fifty.pct.non.exceedance <- vahydro.import.metric(met.varkey = "non-exceedance", met.propcode = 'ne50', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  ninety.five.pct.non.exceedance <- vahydro.import.metric(met.varkey = "non-exceedance", met.propcode = 'ne95', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  ninety.nine.pct.non.exceedance <- vahydro.import.metric(met.varkey = "non-exceedance", met.propcode = 'ne99', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  mean.baseflow <- vahydro.import.metric(met.varkey = "baseflow", met.propcode = '', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)

  metrics <- data.frame(overall.mean, jan.low.flow, feb.low.flow, mar.low.flow, apr.low.flow, may.low.flow,
                        jun.low.flow, jul.low.flow, aug.low.flow, sep.low.flow, oct.low.flow, nov.low.flow,
                        dec.low.flow, jan.mean.flow, feb.mean.flow, mar.mean.flow, apr.mean.flow,
                        may.mean.flow, jun.mean.flow, jul.mean.flow, aug.mean.flow, sep.mean.flow,
                        oct.mean.flow, nov.mean.flow, dec.mean.flow, jan.high.flow, feb.high.flow,
                        mar.high.flow, apr.high.flow, may.high.flow, jun.high.flow, jul.high.flow,
                        aug.high.flow, sep.high.flow, oct.high.flow, nov.high.flow, dec.high.flow,
                        one.day.min, three.day.min, seven.day.min, thirty.day.min, ninety.day.min,
                        one.day.med.low, three.day.med.low, seven.day.med.low, thirty.day.med.low, ninety.day.med.low,
                        one.day.max, three.day.max, seven.day.max, thirty.day.max, ninety.day.max,
                        one.day.med.high, three.day.med.high, seven.day.med.high, thirty.day.med.high, 
                        ninety.day.med.high, drought.of.record.mean, seven.q.ten, drought.of.record.year, sep.ten.pct,
                        one.pct.non.exceedance, five.pct.non.exceedance, fifty.pct.non.exceedance,
                        ninety.five.pct.non.exceedance, ninety.nine.pct.non.exceedance, mean.baseflow)
  return(metrics)
}

water_year_trim <- function(data) {
  library(lubridate)
  data.length <- length(data$date)
  start.month <- month(data$date[1])
  end.month <- month(data$date[data.length])
  start.day <- day(data$date[1])
  end.day <- day(data$date[data.length])
  
  if (start.month <= 9) {
    start.year <- year(data$date[1])
  } else if (start.month == 10 & start.day == 1) {
    start.year <- year(data$date[1])
  } else {
    start.year <- year(data$date[1]) + 1
  }
  
  if (end.month >= 10) {
    end.year <- year(data$date[data.length])
  } else if (end.month == 9 & end.day == 30) {
    end.year <- year(data$date[data.length])
  } else {
    end.year <- year(data$date[data.length]) - 1
  }
  
  start.date <- paste0(start.year, "-10-01")
  end.date <- paste0(end.year, "-09-30")

  start.line <- which(data$date == start.date)
  end.line <- which(data$date == end.date)
  
  data <- data[start.line:end.line,]
  return(data)
}

# calculating metrics functions

# Baseflow (Average) DONE
average_baseflow <- function(data){
  #setup
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  model1.data <- data.frame(data$day, data$month, data$year, data$flow)
  names(model1.data) <- c('day', 'month', 'year', 'flow')
  model1river <- createlfobj(model1.data, hyearstart = 10, baseflow = TRUE, meta = NULL)
  
  baseflowriver<- data.frame(model1river);
  colnames(baseflowriver) <-c ('day', 'month', 'year', 'flow', 'year', 'baseflow')
  baseflowriver<-baseflowriver[complete.cases(baseflowriver)==TRUE,]
  model1river<- data.frame(baseflowriver$day, baseflowriver$month, baseflowriver$year, 
                           baseflowriver$flow, baseflowriver$year, baseflowriver$baseflow);
  names(model1river) <- c('day', 'month', 'year', 'flow', 'hyear', 'baseflow')
  #calculation
  base <- mean(model1river$baseflow);
  return(base)
}

# Monthly High Calculation DONE
monthly_max <- function(data, num.month) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_maxs <- zoo(data$flow, order.by = data$date)
  moname = month.name[num.month]
  max_flows <- fn_iha_mhf(monthly_maxs,moname);
  return(max_flows)
}

# Monthly Low Calculation DONE
monthly_min <- function(data, num.month) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_mins <- zoo(data$flow, order.by = data$date)
  moname = month.name[num.month]
  min_flows <- fn_iha_mlf(monthly_mins,moname);
  return(min_flows)
}

# Monthly Mean Calculation DONE
monthly_mean <- function(data, num.month) {
  # Setup for Monthly Means Calculations
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_means <- aggregate(data$flow, list(data$month), FUN = mean)
  mean_flows <- monthly_means[num.month,2]
  return(mean_flows)
}

# Flow Exceedance Calculation DONE
flow_exceedance <- function(data, prob) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  dec_flows <- sort(data$flow, decreasing = TRUE)
  prob_exceedance <- quantile(dec_flows, prob)
  return(prob_exceedance)
}

# September 10% Flow Calculation DONE
sept_10_flow <- function(data) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  sept_flows <- subset(data, month == '9')
  sept_10 <- quantile(sept_flows$flow, 0.10)
  return(sept_10)
}

# Overall Mean Flow Calculation DONE
overall_mean_flow <- function(data) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  mean.flow <- mean(data$flow);
  return(mean.flow)
}

# DROUGHT OF RECORD (MIN. 90 DAY MIN.) YEAR Calculation DONE
drought_of_record <- function(data) {
  flows_model1 <- zoo(data$flow, order.by = data$date)
  DoR <- fn_iha_DOR_Year(flows_model1)
  return(DoR)
}

# # DROUGHT OF RECORD (MIN. 90 DAY MIN.) FLOW Calculation DONE
# drought_of_record_flow <- function(data) {
#   flows_model1 <- zoo(data$flow, order.by = data$date)
#   DoR <- fn_iha_DOR(flows_model1)
#   return(DoR)
# }

# 7Q10 DONE
seven_q_ten <- function(data) {
  flows_model1 <- zoo(data$flow, order.by = data$date)
  mod_7Q10 <- fn_iha_7q10(flows_model1);
}

# _ Day Min Calculation DONE
num_day_min <- function(data, num.day, min_or_med) {
  
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  # Setup for ___ Day Max Calculations
  f3 <- zoo(data$flow, order.by = data$date)
  g2 <- group2(f3, year = 'water')
  
  if (min_or_med == "min"){
    if (num.day == 1) {
      metric <- min(g2$'1 Day Min')}
    else if (num.day == 3){
      metric <- min(g2$'3 Day Min')}
    else if (num.day == 7){
      metric <- min(g2$'7 Day Min')}
    else if (num.day == 30){
      metric <- min(g2$'30 Day Min')}
    else if (num.day == 90){
      metric <- min(g2$'90 Day Min')}
  }
  if (min_or_med == "med"){  
    if (num.day == 1) {
      metric <- median(g2$'1 Day Min')}
    else if (num.day == 3){
      metric <- median(g2$'3 Day Min')}
    else if (num.day == 7){
      metric <- median(g2$'7 Day Min')}
    else if (num.day == 30){
      metric <- median(g2$'30 Day Min')}
    else if (num.day == 90){
      metric <- median(g2$'90 Day Min')}
  }
  return(metric)  
}

# _ Day Max Calculation DONE
num_day_max <- function(data, num.day, max_or_med) {
  
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  # Setup for ___ Day Max Calculations
  f3 <- zoo(data$flow, order.by = data$date)
  g2 <- group2(f3, year = 'water')
  
  if (max_or_med == "max"){
    if (num.day == 1) {
      metric <- max(g2$'1 Day Max')}
    else if (num.day == 3){
      metric <- max(g2$'3 Day Max')}
    else if (num.day == 7){
      metric <- max(g2$'7 Day Max')}
    else if (num.day == 30){
      metric <- max(g2$'30 Day Max')}
    else if (num.day == 90){
      metric <- max(g2$'90 Day Max')}
  }
  if (max_or_med == "med"){  
    if (num.day == 1) {
      metric <- median(g2$'1 Day Max')}
    else if (num.day == 3){
      metric <- median(g2$'3 Day Max')}
    else if (num.day == 7){
      metric <- median(g2$'7 Day Max')}
    else if (num.day == 30){
      metric <- median(g2$'30 Day Max')}
    else if (num.day == 90){
      metric <- median(g2$'90 Day Max')}
  }
  return(metric)  
}

# LOW YEARLY MEAN DONE
low_yearly_mean <- function(data) {
  #setup
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  
  flows_model1 <- zoo(data$flow, order.by = data$date)
  DoR <- fn_iha_DOR_Year(flows_model1);
  
  model1.data <- data.frame(data$day, data$month, data$year, data$flow)
  names(model1.data) <- c('day', 'month', 'year', 'flow')
  model1river <- createlfobj(model1.data, hyearstart = 10, baseflow = TRUE, meta = NULL)
  lf_model <- aggregate(model1river$flow, by = list(model1river$hyear), FUN = mean)
  colnames(lf_model) <- c('Water_Year', 'Mean_Flow')
  #calculation
  lf_model_flow <- as.numeric(which(lf_model$'Water_Year' == DoR))
  lf_model <- lf_model[lf_model_flow,2]
  return(lf_model)
}

# Creating Data Frame with calculated metrics 
metrics_calc_all <- function(data) {
  overall.mean <- overall_mean_flow(data)
  jan.low.flow <- monthly_min(data, num.month = 1)
  feb.low.flow <- monthly_min(data, num.month = 2)
  mar.low.flow <- monthly_min(data, num.month = 3)
  apr.low.flow <- monthly_min(data, num.month = 4)
  may.low.flow <- monthly_min(data, num.month = 5)
  jun.low.flow <- monthly_min(data, num.month = 6)
  jul.low.flow <- monthly_min(data, num.month = 7)
  aug.low.flow <- monthly_min(data, num.month = 8)
  sep.low.flow <- monthly_min(data, num.month = 9)
  oct.low.flow <- monthly_min(data, num.month = 10)
  nov.low.flow <- monthly_min(data, num.month = 11)
  dec.low.flow <- monthly_min(data, num.month = 12)
  jan.mean.flow <- monthly_mean(data, num.month = 1)
  feb.mean.flow <- monthly_mean(data, num.month = 2)
  mar.mean.flow <- monthly_mean(data, num.month = 3)
  apr.mean.flow <- monthly_mean(data, num.month = 4)
  may.mean.flow <- monthly_mean(data, num.month = 5)
  jun.mean.flow <- monthly_mean(data, num.month = 6)
  jul.mean.flow <- monthly_mean(data, num.month = 7)
  aug.mean.flow <- monthly_mean(data, num.month = 8)
  sep.mean.flow <- monthly_mean(data, num.month = 9)
  oct.mean.flow <- monthly_mean(data, num.month = 10)
  nov.mean.flow <- monthly_mean(data, num.month = 11)
  dec.mean.flow <- monthly_mean(data, num.month = 12)
  jan.high.flow <- monthly_max(data, num.month = 1)
  feb.high.flow <- monthly_max(data, num.month = 2)
  mar.high.flow <- monthly_max(data, num.month = 3)
  apr.high.flow <- monthly_max(data, num.month = 4)
  may.high.flow <- monthly_max(data, num.month = 5)
  jun.high.flow <- monthly_max(data, num.month = 6)
  jul.high.flow <- monthly_max(data, num.month = 7)
  aug.high.flow <- monthly_max(data, num.month = 8)
  sep.high.flow <- monthly_max(data, num.month = 9)
  oct.high.flow <- monthly_max(data, num.month = 10)
  nov.high.flow <- monthly_max(data, num.month = 11)
  dec.high.flow <- monthly_max(data, num.month = 12)
  one.day.min <- num_day_min(data, num.day = 1, min_or_med = "min")
  three.day.min <- num_day_min(data, num.day = 3, min_or_med = "min")
  seven.day.min <- num_day_min(data, num.day = 7, min_or_med = "min")
  thirty.day.min <- num_day_min(data, num.day = 30, min_or_med = "min")
  ninety.day.min <- num_day_min(data, num.day = 90, min_or_med = "min")
  one.day.med.min <- num_day_min(data, num.day = 1, min_or_med = "med")
  three.day.med.min <- num_day_min(data, num.day = 3, min_or_med = "med")
  seven.day.med.min <- num_day_min(data, num.day = 7, min_or_med = "med")
  thirty.day.med.min <- num_day_min(data, num.day = 30, min_or_med = "med")
  ninety.day.med.min <- num_day_min(data, num.day = 90, min_or_med = "med")
  one.day.max <- num_day_max(data, num.day = 1, max_or_med = "max")
  three.day.max <- num_day_max(data, num.day = 3, max_or_med = "max")
  seven.day.max <- num_day_max(data, num.day = 7, max_or_med = "max")
  thirty.day.max <- num_day_max(data, num.day = 30, max_or_med = "max")
  ninety.day.max <- num_day_max(data, num.day = 90, max_or_med = "max")
  one.day.med.max <- num_day_max(data, num.day = 1, max_or_med = "med")
  three.day.med.max <- num_day_max(data, num.day = 3, max_or_med = "med")
  seven.day.med.max <- num_day_max(data, num.day = 7, max_or_med = "med")
  thirty.day.med.max <- num_day_max(data, num.day = 30, max_or_med = "med")
  ninety.day.med.max <- num_day_max(data, num.day = 90, max_or_med = "med")
  lowest.yearly.mean <- low_yearly_mean(data)
  sevenQ.ten <- seven_q_ten(data)
  drought.record <- drought_of_record(data)
  sept.10.percent <- sept_10_flow(data)
  flow.exceedance.1 <- flow_exceedance(data, prob = 0.01)
  flow.exceedance.5 <- flow_exceedance(data, prob = 0.05)
  flow.exceedance.50 <- flow_exceedance(data, prob = 0.5)
  flow.exceedance.95 <- flow_exceedance(data, prob = 0.95)
  flow.exceedance.99 <- flow_exceedance(data, prob = 0.99)
  avg.baseflow <- average_baseflow(data)
  
  all_metrics <- data.frame(overall.mean, jan.low.flow, feb.low.flow, mar.low.flow, apr.low.flow, may.low.flow,jun.low.flow, jul.low.flow, aug.low.flow, sep.low.flow, oct.low.flow, nov.low.flow, dec.low.flow, jan.mean.flow, feb.mean.flow, mar.mean.flow, apr.mean.flow, may.mean.flow, jun.mean.flow, jul.mean.flow, aug.mean.flow, sep.mean.flow, oct.mean.flow, nov.mean.flow, dec.mean.flow, jan.high.flow, feb.high.flow, mar.high.flow, apr.high.flow, may.high.flow, jun.high.flow, jul.high.flow, aug.high.flow, sep.high.flow, oct.high.flow, nov.high.flow, dec.high.flow, one.day.min, three.day.min, seven.day.min, thirty.day.min, ninety.day.min, one.day.med.min, three.day.med.min, seven.day.med.min, thirty.day.med.min, ninety.day.med.min, one.day.max, three.day.max, seven.day.max, thirty.day.max, ninety.day.max, one.day.med.max, three.day.med.max, seven.day.med.max, thirty.day.med.max, ninety.day.med.max, lowest.yearly.mean, sevenQ.ten, drought.record, sept.10.percent, flow.exceedance.1, flow.exceedance.5, flow.exceedance.50, flow.exceedance.95, flow.exceedance.99, avg.baseflow)
  rownames(all_metrics) <- 'analysis'
  return(all_metrics)
}

# Difference Comparisons DONE
metrics_compare <- function(metrics1, metrics2, riv.seg) {
  difference <- (100*(metrics2-metrics1)/metrics1)
  metrics1[2,] <- metrics2
  metrics1[3,] <- difference
  rownames(metrics1) <- c(paste0(riv.seg, ' Scenario1'), paste0(riv.seg, ' Scenario2'), paste0(riv.seg, ' Percent Difference'))
  return(metrics1)
}

fn_gage_and_seg_mapper <- function(riv.seg, site_number, site_url, cbp6_link) {
  
  #----------Define function for watershedDF-----------------------
  getWatershedDF <- function(geom){
    
    watershed_geom <- readWKT(geom)
    watershed_geom_clip <- gIntersection(bb, watershed_geom)
    if (is.null(watershed_geom_clip)) {
      watershed_geom_clip = watershed_geom
    }
    wsdataProjected <- SpatialPolygonsDataFrame(watershed_geom_clip,data.frame("id"), match.ID = FALSE)
    wsdataProjected@data$id <- rownames(wsdataProjected@data)
    watershedPoints <- fortify(wsdataProjected, region = "id")
    watershedDF <- merge(watershedPoints, wsdataProjected@data, by = "id")
    
    return(watershedDF)
  }
  
  AllSegList <- c('OR5_7980_8200', 'OR2_8020_8130', 'OR2_8070_8120', 'OR4_8120_7890',
                  'OR2_8130_7900', 'OR5_8200_8370', 'OR4_8271_8120', 'TU3_8480_8680',
                  'TU1_8570_8680', 'TU3_8650_8800', 'TU4_8680_8810', 'TU2_8790_9070',
                  'TU4_8800_9290', 'TU4_8810_9000', 'BS4_8540_8441', 'BS3_8580_8440',
                  'BS2_8590_8440', 'BS1_8730_8540', 'MN2_8250_8190', 'MN4_8260_8400',
                  'MN0_8300_0001', 'MN4_8400_8380', 'MN4_8510_8380', 'MN2_8530_8510',
                  'NR6_7820_7960', 'NR1_7880_8050', 'BS3_8350_8330', 'BS4_8440_8441',
                  'MN3_7540_7680', 'MN1_7590_7860', 'MN1_7620_7710', 'MN3_7680_7860',
                  'MN4_7710_8161', 'MN2_7720_7830', 'MN1_7730_8160', 'MN3_7770_7930',
                  'MN4_7810_8080', 'MN2_7830_7950', 'MN3_7860_8080', 'MN3_7930_8010',
                  'MN4_7950_7710', 'MN1_7990_8100', 'MN3_8010_7950', 'MN4_8080_8110',
                  'MN2_8100_8190', 'MN5_8161_8160', 'MN3_8190_8260', 'MN5_8230_8161',
                  'NR6_7960_8050', 'NR1_8030_8051', 'NR6_8050_8051', 'NR6_8051_8000',
                  'NR6_8170_7960', 'NR6_8180_8051', 'NR2_8210_8180', 'NR3_8290_8170',
                  'NR3_8420_8430', 'NR3_8430_7820', 'NR6_8640_8500', 'NR3_8690_8500',
                  'NR5_8700_8640', 'NR3_8740_8500', 'NR5_8760_8640', 'NR1_8820_8760',
                  'NR5_8870_8760', 'NR1_8960_8870', 'NR1_9030_9080', 'NR5_9050_8870',
                  'NR5_9080_9050', 'NR4_9130_9080', 'NR1_9150_9050', 'NR3_9170_9130',
                  'NR3_9190_9170', 'NR3_9240_9130', 'NR2_9250_9170', 'NR3_9310_9240',
                  'OD3_8340_8520', 'OD3_8520_8621', 'OD2_8560_8630', 'OD6_8621_8470',
                  'OD3_8630_8720', 'OD6_8660_8621', 'OD2_8670_8890', 'OD3_8710_8470',
                  'OD3_8720_8900', 'OD5_8770_8780', 'OD5_8780_8660', 'OD2_8830_8710',
                  'OD2_8840_9020', 'OD3_8850_8931', 'OD5_8890_8770', 'OD5_8900_8770',
                  'OD1_8910_8930', 'OD2_8920_8830', 'OD3_8930_8931', 'OD3_8931_9140',
                  'OD5_8940_8780', 'OD4_8990_8900', 'OD3_9020_9110', 'OD4_9110_9140',
                  'OD4_9140_8990', 'OD1_9270_9110', 'OR2_7610_7780', 'OR2_7650_8070',
                  'OR2_7670_7840', 'OR1_7700_7980', 'OR3_7740_8271', 'OR2_7780_7890',
                  'OR2_7840_7970', 'OR5_7890_7970', 'OR2_7900_7740', 'OR5_7910_8410',
                  'OR5_7970_8200', 'OR1_8280_8020', 'OR1_8320_8271', 'OR5_8370_8410',
                  'OR5_8410_8470', 'OR2_8450_8490', 'OR2_8460_8271', 'OR7_8470_8490',
                  'TU2_8860_9000', 'TU3_8880_9230', 'TU2_8950_9040', 'TU2_8970_9280',
                  'TU5_9000_9280', 'TU1_9010_9290', 'TU3_9040_9180', 'TU3_9060_9230',
                  'TU2_9070_9090', 'TU2_9100_9200', 'TU3_9180_9090', 'TU2_9200_9180',
                  'TU1_9220_9200', 'TU3_9230_9260', 'NR2_8600_8700', 'NR6_8500_7820',
                  'EL0_4560_4562','EL0_4561_4562','EL0_4562_0001','EL2_4400_4590',
                  'EL2_4590_0001','EL2_5110_5270','EL2_5270_0001','PM0_4640_4820',
                  'PM1_3120_3400','PM1_3450_3400','PM1_3510_4000','PM1_3710_4040',
                  'PM1_4000_4290','PM1_4250_4500','PM1_4430_4200','PM1_4500_4580',
                  'PM2_2860_3040','PM2_3400_3340','PM2_4860_4670','PM3_3040_3340',
                  'PM3_4660_4620','PM3_4670_4660','PM4_3340_3341','PM4_3341_4040',
                  'PM4_4040_4410','PM7_4150_4290','PM7_4200_4410','PM7_4290_4200',
                  'PM7_4410_4620','PM7_4580_4820','PM7_4620_4580','PM7_4820_0001',
                  'PS0_6150_6160','PS0_6160_6161','PS1_4790_4830','PS1_4830_5080',
                  'PS2_5550_5560','PS2_5560_5100','PS2_6420_6360','PS2_6490_6420',
                  'PS2_6660_6490','PS2_6730_6660','PS3_5100_5080','PS3_5990_6161',
                  'PS3_6161_6280','PS3_6280_6230','PS3_6460_6230','PS4_5080_4380',
                  'PS4_5840_5240','PS4_6230_6360','PS4_6360_5840','PS5_4370_4150',
                  'PS5_4380_4370','PS5_5200_4380','PS5_5240_5200','PU0_3000_3090',
                  'PU0_3601_3602','PU0_3611_3530','PU0_3751_3752','PU0_3871_3690',
                  'PU0_5620_5380','PU0_6080_5620','PU1_3030_3440','PU1_3100_3690',
                  'PU1_3170_3580','PU1_3580_3780','PU1_3850_4190','PU1_3940_3970',
                  'PU1_4190_4300','PU1_4300_4440','PU1_4840_4760',
                  'PU1_5380_5050','PU1_5520_5210','PU1_5820_5380','PU2_2790_3290',
                  'PU2_2840_3080','PU2_3080_3640','PU2_3090_4050','PU2_3140_3680',
                  'PU2_3180_3370','PU2_3370_4020','PU2_3630_3590','PU2_3770_3600',
                  'PU2_3900_3750','PU2_4050_4180','PU2_4160_3930','PU2_4220_3900',
                  'PU2_4340_3860','PU2_4360_4160','PU2_4720_4750','PU2_4730_4220',
                  'PU2_5190_4310','PU2_5700_5210','PU2_6050_5190',
                  'PU3_2510_3290','PU3_3290_3390','PU3_3390_3730','PU3_3680_3890',
                  'PU3_3860_3610','PU3_4280_3860','PU3_4450_4440','PU3_5210_5050',
                  'PU4_3780_3930','PU4_3890_3990','PU4_3970_3890','PU4_3990_3780',
                  'PU4_4210_4170','PU4_4310_4210','PU4_4440_3970','PU4_5050_4310',
                  'PU5_3930_4170','PU5_4170_4020','PU6_3440_3590','PU6_3530_3440',
                  'PU6_3590_3640','PU6_3600_3602','PU6_3602_3730','PU6_3610_3530',
                  'PU6_3640_3600','PU6_3690_3610','PU6_3730_3750','PU6_3750_3752',
                  'PU6_3752_4080','PU6_3870_3690','PU6_4020_3870','PU6_4080_4180',
                  'PU6_4180_4150','JA0_7291_7290','JA2_7290_0001','JA1_7600_7570',
                  'JA1_7640_7280','JA2_7410_7470','JA2_7550_7280','JA2_7570_7480',
                  'JA4_7280_7340','JA4_7340_7470','JA4_7470_7480','JA5_7480_0001',
                  'JB3_6820_7053','JB3_7053_0001','PL1_4460_4780','PL1_4780_0001',
                  'JL1_6560_6440','JL1_6760_6910','JL1_6770_6850','JL1_6910_6960',
                  'JL1_6940_7200','JL1_7080_7190','JL1_7170_6800','JL1_7190_7250',
                  'JL1_7200_7250','JL1_7530_7430','JL2_6240_6520','JL2_6440_6441',
                  'JL2_6441_6520','JL2_6850_6890','JL2_7110_7120','JL2_7120_6970',
                  'JL2_7240_7350','JL2_7250_7090','JL2_7350_7090','JL3_7020_7100',
                  'JL3_7090_7150','JL4_6520_6710','JL4_6710_6740','JL6_6740_7100',
                  'JL6_6890_6990','JL6_6960_6970','JL6_6970_6740','JL6_6990_6960',
                  'JL6_7150_6890','JL6_7160_7440','JL6_7320_7150','JL6_7430_7320',
                  'JL6_7440_7430','JL7_6800_7070','JL7_7030_6800','JL7_7070_0001',
                  'JL7_7100_7030','JU1_6290_6590','JU1_6300_6650','JU1_6340_6650',
                  'JU1_6590_6600','JU1_6880_7260','JU1_7560_7500','JU1_7630_7490',
                  'JU1_7690_7490','JU1_7750_7560','JU2_6410_6640','JU2_6600_6810',
                  'JU2_6810_6900','JU2_7140_7330','JU2_7180_7380','JU2_7360_7000',
                  'JU2_7450_7360','JU3_6380_6900','JU3_6640_6790','JU3_6650_7300',
                  'JU3_6790_7260','JU3_6900_6950','JU3_6950_7330','JU3_7400_7510',
                  'JU3_7490_7400','JU4_7000_7300','JU4_7260_7380','JU4_7330_7000',
                  'JU4_7380_7160','JU5_7300_7510','JU5_7420_7160','JU5_7500_7420',
                  'JU5_7510_7500','PL0_5141_5140','PL1_5370_5470','PL2_4970_5250',
                  'PL2_5140_5360','PL2_5470_5360','PL3_5250_0001','PL3_5360_5250',
                  'PL0_5010_5130','PL1_5130_0001','PL0_5490_0001','PL0_5540_5490',
                  'PL2_5300_5630','PL2_5630_0001','PL0_5730_5690','PL1_5690_0001',
                  'PL0_5530_5710','PL0_5710_0001','RU2_5220_5640','RU2_5500_5610',
                  'RU2_5810_5610','RU2_5940_6200','RU2_6090_6220','RU2_6200_6170',
                  'RU2_6220_6170','RU3_5610_5640','RU3_6170_6040','RU4_5640_6030',
                  'RU4_6040_6030','RU5_6030_0001','XU0_4090_4270','XU0_4091_4270',
                  'XU0_4130_4070','XU2_4070_4330','XU2_4270_4650','XU2_4330_4480',
                  'XU2_4480_4650','XU3_4650_0001','YM1_6370_6620','YM2_6120_6430',
                  'YM3_6430_6620','YM4_6620_0001','YP1_6570_6680','YP1_6680_6670',
                  'YP2_6390_6330','YP3_6330_6700','YP3_6470_6690','YP3_6670_6720',
                  'YP3_6690_6720','YP3_6700_6670','YP4_6720_6750','YP4_6750_0001',
                  'YP0_6840_0001','YP0_6860_6840',
                  'EL0_5400_0001','EL1_5150_0001',
                  'EL1_5430_0001','EL1_5570_0001','EL1_6000_0001','JB0_7051_0001',
                  'JB0_7052_0001','JB1_8090_0001','JB2_7800_0001','PL0_4510_0001',
                  'PL0_5000_0001','PL0_5070_0001','PL0_5510_0001','PL0_5720_0001',
                  'PL0_5750_0001','PL0_5830_0001','PL1_4540_0001','PL1_5230_0001',
                  'PL1_5910_0001','RL0_6540_0001','RL1_6180_0001','YL2_6580_0001', 
                  'PU1_4760_4451','PU2_4750_4451','PU3_4451_4450','PM1_3711_3710',
                  'PM1_4251_4250','PM1_4252_4250' 
  )
  
  # Splitting the River Segment string into each segment name
  riv.segStr <- strsplit(riv.seg, "\\+")
  riv.segStr <- riv.segStr[[1]]
  num.segs <- as.numeric(length(riv.segStr))
  
  # Getting all upstream segments for each of the linked segs, combining
  # to form a vector of all upstream segments.
  AllUpstreamSegs <- vector()
  for (i in 1:num.segs) {
    riv.seg <- riv.segStr[i]
    UpstreamSegs <- fn_ALL.upstream(riv.seg, AllSegList)
    AllUpstreamSegs <- c(AllUpstreamSegs, UpstreamSegs)
  }
  AllUpstreamSegs <- c(riv.seg, AllUpstreamSegs)
  eliminate <- which(AllUpstreamSegs=="NA")
  if (is.empty(eliminate) == FALSE) {
    AllUpstreamSegs <- AllUpstreamSegs[-eliminate]
  }
  AllUpstreamSegs <- unique(AllUpstreamSegs)
  num.upstream <- as.numeric(length(AllUpstreamSegs))
  
  STATES <- read.table(file=paste(cbp6_link,"GIS_LAYERS","STATES.tsv",sep="\\"), header=TRUE, sep="\t") #Load state geometries
  RIVDF <- read.table(file=paste(cbp6_link,"GIS_LAYERS","RIVDF.csv",sep="/"), header=TRUE, sep=",") #Load state geometries
  WBDF <- read.table(file=paste(cbp6_link,"GIS_LAYERS","WBDF.csv",sep="/"), header=TRUE, sep=",") #Load state geometries
  
  # first specify bounding box / extent of map: -----------------------------
  extent <- data.frame(x = c(-84, -75), 
                       y = c(35, 41))  
  
  bb=readWKT(paste0("POLYGON((",extent$x[1]," ",extent$y[1],",",extent$x[2]," ",extent$y[1],",",extent$x[2]," ",extent$y[2],",",extent$x[1]," ",extent$y[2],",",extent$x[1]," ",extent$y[1],"))",sep=""))
  bbProjected <- SpatialPolygonsDataFrame(bb,data.frame("id"), match.ID = FALSE)
  bbProjected@data$id <- rownames(bbProjected@data)
  bbPoints <- fortify(bbProjected, region = "id")
  bbDF <- merge(bbPoints, bbProjected@data, by = "id")
  
  
  # specify states info: LOAD STATE GEOMETRY --------------------------------
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
  
  KY <- STATES[which(STATES$state == "KY"),]
  KY_geom <- readWKT(KY$geom)
  KY_geom_clip <- gIntersection(bb, KY_geom)
  KYProjected <- SpatialPolygonsDataFrame(KY_geom_clip,data.frame("id"), match.ID = TRUE)
  KYProjected@data$id <- rownames(KYProjected@data)
  KYPoints <- fortify( KYProjected, region = "id")
  KYDF <- merge(KYPoints,  KYProjected@data, by = "id")
  
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
  
  PA <- STATES[which(STATES$state == "PA"),]
  PA_geom <- readWKT(PA$geom)
  PA_geom_clip <- gIntersection(bb, PA_geom)
  PAProjected <- SpatialPolygonsDataFrame(PA_geom_clip,data.frame("id"), match.ID = TRUE)
  PAProjected@data$id <- rownames(PAProjected@data)
  PAPoints <- fortify( PAProjected, region = "id")
  PADF <- merge(PAPoints,  PAProjected@data, by = "id")
  
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
  
  SC <- STATES[which(STATES$state == "SC"),]
  SC_geom <- readWKT(SC$geom)
  SC_geom_clip <- gIntersection(bb, SC_geom)
  SCProjected <- SpatialPolygonsDataFrame(SC_geom_clip,data.frame("id"), match.ID = TRUE)
  SCProjected@data$id <- rownames(SCProjected@data)
  SCPoints <- fortify( SCProjected, region = "id")
  SCDF <- merge(SCPoints,  SCProjected@data, by = "id")
  
  DC <- STATES[which(STATES$state == "DC"),]
  DC_geom <- readWKT(DC$geom)
  DC_geom_clip <- gIntersection(bb, DC_geom)
  DCProjected <- SpatialPolygonsDataFrame(DC_geom_clip,data.frame("id"), match.ID = TRUE)
  DCProjected@data$id <- rownames(DCProjected@data)
  DCPoints <- fortify( DCProjected, region = "id")
  DCDF <- merge(DCPoints,  DCProjected@data, by = "id")
  
  if (num.upstream > 0) {
    for (i in 1:num.upstream) {  
      riv.seg <- AllUpstreamSegs[i]
      namer <- paste0("upstream.watershedDF", i)
      
      # Retrieve Riversegment Feature From VAHydro  -----------------------------
      
      inputs <- list (
        bundle = 'watershed',
        ftype = 'vahydro',
        hydrocode = paste0('vahydrosw_wshed_', riv.seg)
      )
      
      dataframe <- getFeature(inputs, token, site_url)
      #print(dataframe)
      hydroid <- dataframe$hydroid
      inputs <- list(
        varkey = "wshed_drainage_area_sqmi",
        featureid = hydroid,
        entity_type = "dh_properties"
      )
      prop <- getProperty(inputs, site_url, prop)
      
      inputs <- list(
        varkey = "wshed_local_area_sqmi",
        featureid = hydroid,
        entity_type = "dh_feature"
      )
      local_da_prop <- getProperty(inputs, site_url, prop)
      #postProperty(inputs = local_da_prop, base_url = site_url, prop = prop)
      
      geom <- dataframe$geom
      watershedDF <- getWatershedDF(geom)
      assign(namer, watershedDF)
    }
  }
  
  
  for (i in 1:num.segs) {  
    riv.seg <- riv.segStr[i]
    namer <- paste0("seg.watershedDF", i)
    
    # Retrieve Riversegment Feature From VAHydro  -----------------------------
    
    inputs <- list (
      bundle = 'watershed',
      ftype = 'vahydro',
      hydrocode = paste0('vahydrosw_wshed_', riv.seg)
    )
    
    dataframe <- getFeature(inputs, token, site_url)
    #print(dataframe)
    hydroid <- dataframe$hydroid
    inputs <- list(
      varkey = "wshed_drainage_area_sqmi",
      featureid = hydroid,
      entity_type = "dh_properties"
    )
    prop <- getProperty(inputs, site_url, prop)
    
    inputs <- list(
      varkey = "wshed_local_area_sqmi",
      featureid = hydroid,
      entity_type = "dh_feature"
    )
    local_da_prop <- getProperty(inputs, site_url, prop)
    #postProperty(inputs = local_da_prop, base_url = site_url, prop = prop)
    
    geom <- dataframe$geom
    watershedDF <- getWatershedDF(geom)
    assign(namer, watershedDF)
  }
  
  # set up ggplot for states ---------------
  statemap <- ggplot(data = VADF, aes(x=long, y=lat, group = group))+
    geom_polygon(data = bbDF, color="black", fill = "powderblue",lwd=0.5)+
    geom_polygon(data = VADF, color="gray46", fill = "gray")+
    geom_polygon(data = TNDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = NCDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = SCDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = KYDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = WVDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = MDDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = DEDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = PADF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = NJDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = OHDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = DCDF, color="gray46", fill = "gray", lwd=0.5)+
    
    
    geom_polygon(data = watershedDF, color="khaki4", fill = "green", alpha = 0.25,lwd=0.5)+
    
    # ADD RIVERS ####################################################################
  geom_point(data = RIVDF, aes(x = long, y = lat), color="steelblue1", size=0.09)+
    #################################################################################
  
  # ADD WATERBODIES ###############################################################
  geom_point(data = WBDF, aes(x = long, y = lat), color="steelblue1", size=0.09)
  #################################################################################
  # Create gage dataframe (gage_linked?) ---------------------
  library(dataRetrieval)
  
  gage <- try(readNWISsite(site_number))
  if (class(gage) == "try-error") {
    gage <- ""
  }
  GAGEDF <- try(data.frame(x=as.numeric(gage$dec_long_va),y=as.numeric(gage$dec_lat_va),X.id.="id",id="1"))
  if (class(GAGEDF) == "try-error") {
    GAGEDF <- ""
  }
  
  #--------------------------------------------------------------------------------------------
  #--------------------------------------------------------------------------------------------
  
  map <- statemap
  if (num.upstream > 0) {
    for (i in 1:num.upstream) {
      namer <- paste0("upstream.watershedDF", i)
      map <- map +
        geom_polygon(data = eval(parse(text = namer)), color="gray35", fill = "lightgreen",alpha = 0.25,lwd=0.5)
    }      
  }
  for (i in 1:num.segs) {
    namer <- paste0("seg.watershedDF", i)
    map <- map +
      geom_polygon(data = eval(parse(text = namer)), color="black", fill = "green3",alpha = 0.25,lwd=0.5)
  }
  
  map <- map + geom_polygon(data = bbDF, color="black", fill = NA,lwd=0.5)
  save.map <- map
  map <- try(map + geom_point(aes(x = x, y = y, group = id), data = GAGEDF, fill="red", color="black", size = 2.75, shape=24))
  if (site_number == "0NA") {
    map <- save.map
  }
  
  #additions to map -------------
  map <- map + 
    #ADD NORTH ARROW AND SCALE BAR
    north(bbDF, location = 'topleft', symbol = 12, scale=0.1)+
    scalebar(data = bbDF, transform = TRUE, dist_unit = "km", location = 'bottomleft', dist = 100, model = 'WGS84',st.bottom=FALSE, st.size = 3.5,
             anchor = c(
               x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
               y = extent$y[1]+(extent$y[1])*0.001
             ))+
    scale_x_continuous(limits = c(extent$x))+
    scale_y_continuous(limits = c(extent$y))+
    
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.title.y=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank(),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          panel.border = element_blank()) 
  
  inputs <- list (
    bundle = 'watershed',
    ftype = 'vahydro',
    hydrocode = paste0('vahydrosw_wshed_', riv.seg)
  )
  print(map)
  return(map)
}


fn_iha_7q10 <- function(zoots) {
  g2 <- group2(zoots) 
  #print("Group 2, 7-day low flow results ")
  #print(g2["7 Day Min"])
  x <- as.vector(as.matrix(g2["7 Day Min"]))
  # fudge 0 values
  # correct for zeroes?? If so, use this loop:
  # This is not an "approved" method - we need to see how the GS/other authorities handles this
  for (k in 1:length(x)) {
    if (x[k] <= 0) {
      x[k] <- 0.00000001
      print (paste("Found 0.0 average in year", g2["year"], sep = " "))
    }
  }
  x <- log(x)
  pars <- PearsonDS:::pearsonIIIfitML(x)
  x7q10 <- exp(qpearsonIII(0.1, params = pars$par))
  return(x7q10);
}

fn_iha_mlf <- function(zoots, targetmo) {
  modat <- group1(zoots,'water','min')  # IHA function that calculates minimum monthly statistics for our data by water year	 
  print(paste("Grabbing ", targetmo, " values ", sep=''))
  g1vec <- as.vector(as.matrix(modat[,targetmo]))  # gives only August statistics
  
  # calculates the 50th percentile - this is the August Low Flow
  # August Low Flow = median flow of the annual minimum flows in August for a chosen time period
  print("Performing quantile analysis")
  x <- quantile(g1vec, 0.5, na.rm = TRUE);
  return(as.numeric(x));
}

fn_iha_mhf <- function(zoots, targetmo) {
  modat <- group1(zoots,'water','max')  # IHA function that calculates maximum monthly statistics for our data by water year	 
  print(paste("Grabbing ", targetmo, " values ", sep=''))
  g1vec <- as.vector(as.matrix(modat[,targetmo]))  # gives only August statistics, if 8
  
  # calculates the 50th percentile - this is the August High Flow
  # August High Flow = median flow of the annual maximum flows in August for a chosen time period
  print("Performing quantile analysis")
  x <- quantile(g1vec, 0.5, na.rm = TRUE);
  return(as.numeric(x));
}

#Calculates the Drought of record Flow
fn_iha_DOR <- function(flows){
  #flows <- flows$flow
  loflows <- group2(flows);
  l90 <- loflows["90 Day Min"];
  ndx = which.min(as.numeric(l90[,"90 Day Min"]));
  dor_flow = loflows[ndx,]$"90 Day Min";
  #dor_year = loflows[ndx,]$"year";
}

#Returns the Drought of Record Year
fn_iha_DOR_Year <- function(flows){
  loflows <- group2(flows);
  l90 <- loflows["90 Day Min"];
  ndx = which.min(as.numeric(l90[,"90 Day Min"]));
  #}dor_flow = round(loflows[ndx,]$"90 Day Min",1);
  dor_year = loflows[ndx,]$"year";
}


# rest_token <- function(base_url, token, rest_uname = FALSE, rest_pw = FALSE) {
#   
#   #Cross-site Request Forgery Protection (Token required for POST and PUT operations)
#   csrf_url <- paste(base_url,"restws/session/token/",sep="/");
#   
#   #IF THE OBJECTS 'rest_uname' or 'rest_pw' DONT EXIST, USER INPUT REQUIRED
#   if (!is.character(rest_uname) | !(is.character(rest_pw))){
#     
#     rest_uname <- c() #initialize username object
#     rest_pw <- c()    #initialize password object
#     
#     #currently set up to allow infinite login attempts, but this can easily be restricted to a set # of attempts
#     token <- c("rest_uname","rest_pw") #used in while loop below, "length of 2"
#     login_attempts <- 1
#     if (!is.character(rest_uname)) {
#       print(paste("REST AUTH INFO MUST BE SUPPLIED",sep=""))
#       while(length(token) == 2  && login_attempts <= 5){
#         print(paste("login attempt #",login_attempts,sep=""))
#         
#         rest_uname <- readline(prompt="Enter REST user name: ")
#         rest_pw <- readline(prompt="Password: ")
#         csrf <- GET(url=csrf_url,authenticate(rest_uname,rest_pw));
#         token <- content(csrf);
#         #print(token)
#         
#         if (length(token)==2){
#           print("Sorry, unrecognized username or password")
#         }
#         login_attempts <- login_attempts + 1
#       }
#       if (login_attempts > 5){print(paste("ALLOWABLE NUMBER OF LOGIN ATTEMPTS EXCEEDED"))}
#     }
#     
#   } else {
#     print(paste("REST AUTH INFO HAS BEEN SUPPLIED",sep=""))
#     print(paste("RETRIEVING REST TOKEN",sep=""))
#     csrf <- GET(url=csrf_url,authenticate(rest_uname,rest_pw));
#     token <- content(csrf);
#   }
#   
#   if (length(token)==1){
#     print("Login attempt successful")
#     print(paste("token = ",token,sep=""))
#   } else {
#     print("Login attempt unsuccessful")
#   }
#   token <- token
# } #close function

fn_upstream <- function(riv.seg, AllSegList) {
  library(stringr)
  library(rapportools)
  # Create dataframe for upstream and downstream segments based on code in string
  ModelSegments <- data.frame(matrix(nrow = length(AllSegList), ncol = 6))
  colnames(ModelSegments)<- c('RiverSeg', 'Middle', 'Last', 'AdditionalName', 'Downstream', 'Upstream')
  ModelSegments$RiverSeg <- AllSegList
  
  # Pull out 4 digit codes in middle and end for upstream/downstream segments
  i <- 1
  for (i in 1:nrow(ModelSegments)){
    
    ModelSegments[i,2]<- str_sub(ModelSegments[i,1], start=5L, end=8L)
    ModelSegments[i,3]<- str_sub(ModelSegments[i,1], start=10L, end=13L)
    ModelSegments[i,4]<- str_sub(ModelSegments[i,1], start=15L, end=-1L)
    i <- i + 1
  }
  
  # Determine Downstream Segment ----------
  j <- 1
  for (j in 1:nrow(ModelSegments)){
    if (ModelSegments[j,4] != ""){
      Downstream <- which((ModelSegments$Middle==ModelSegments$Middle[j]) & (ModelSegments$Last==ModelSegments$Last[j]) & (ModelSegments$AdditionalName==""))
      if (length(Downstream)==0){
        ModelSegments[j,5]  <- 'NA'
      }else if (length(Downstream)==1){
        ModelSegments[j,5] <- as.character(ModelSegments[Downstream,1])
      }
    }else if (ModelSegments[j,4]==""){
      Downstream <- which((ModelSegments$Middle==ModelSegments$Last[j]) & (ModelSegments$AdditionalName==""))
      if (length(Downstream)==0){
        ModelSegments[j,5]  <- 'NA'
      }else if (length(Downstream)==1){
        ModelSegments[j,5] <- as.character(ModelSegments[Downstream,1])
      }else if (length(Downstream)>1){
        ModelSegments[j,5] <- 'NA'
      }
    }
    j<-j+1
  }
  # Determine Upstream Segment ----------
  k<-1
  for (k in 1:nrow(ModelSegments)){
    Upstream <- which(as.character(ModelSegments$Downstream)==as.character(ModelSegments$RiverSeg[k]))
    NumUp <- ModelSegments$RiverSeg[Upstream]
    ModelSegments[k,6]<- paste(NumUp, collapse = '+')
    if (is.empty(ModelSegments[k,6])==TRUE){
      ModelSegments[k,6]<- 'NA'
    } 
    k<-k+1
  }
  SegUpstream <- as.numeric(which(as.character(ModelSegments$RiverSeg)==as.character(riv.seg)))
  SegUpstream <- ModelSegments$Upstream[SegUpstream]
  SegUpstream <- strsplit(as.character(SegUpstream), "\\+")
  SegUpstream <- try(SegUpstream[[1]], silent = TRUE)
  if (class(SegUpstream)=='try-error') {
    SegUpstream <- NA
  }
  return(SegUpstream)
}

fn_ALL.upstream <- function(riv.seg, AllSegList) {
  UpstreamSeg <- fn_upstream(riv.seg, AllSegList)
  AllUpstream <- character(0)
  BranchedSegs <- character(0)
  while (is.na(UpstreamSeg[1])==FALSE || is.empty(BranchedSegs) == FALSE) {
    while (is.na(UpstreamSeg[1])==FALSE) {
      num.segs <- as.numeric(length(UpstreamSeg))
      if (num.segs > 1) {
        BranchedSegs[(length(BranchedSegs)+1):(length(BranchedSegs)+num.segs-1)] <- UpstreamSeg[2:num.segs]
        UpstreamSeg <- UpstreamSeg[1]
      }
      AllUpstream[length(AllUpstream)+1] <- UpstreamSeg
      UpstreamSeg <- fn_upstream(UpstreamSeg, AllSegList)
    }
    num.branched <- as.numeric(length(BranchedSegs))
    UpstreamSeg <- BranchedSegs[1]
    BranchedSegs <- BranchedSegs[-1]
  }
  AllUpstream <- AllUpstream[which(AllUpstream != 'NA')]
  if (is.empty(AllUpstream[1])==TRUE) {
    AllUpstream <- 'NA'
  }
  return(AllUpstream)
}

# getProperty <- function(inputs, base_url, prop){
#   print(inputs)
#   #Convert varkey to varid - needed for REST operations 
#   if (!is.null(inputs$varkey)) {
#     # this would use REST 
#     # getVarDef(list(varkey = inputs$varkey), token, base_url)
#     # but it is broken for vardef for now metadatawrapper fatal error
#     # EntityMetadataWrapperException: Invalid data value given. Be sure it matches the required data type and format. 
#     # in EntityDrupalWrapper->set() 
#     # (line 736 of /var/www/html/d.dh/modules/entity/includes/entity.wrapper.inc).
#     
#     propdef_url<- paste(base_url,"/?q=vardefs.tsv/",inputs$varkey,sep="")
#     print(paste("Trying", propdef_url))
#     propdef_table <- read.table(propdef_url,header = TRUE, sep = "\t")    
#     varid <- propdef_table[1][which(propdef_table$varkey == inputs$varkey),]
#     print(paste("varid: ",varid,sep=""))
#     if (is.null(varid)) {
#       # we sent a bad variable id so we should return FALSE
#       return(FALSE)
#     }
#     inputs$varid = varid
#   }
#   # now, verify that we have either a proper varid OR a propname
#   if (is.null(inputs$varid) & is.null(inputs$propname)) {
#     # we were sent a bad variable id so we should return FALSE
#     return(FALSE)
#   }
#   
#   pbody = list(
#     #bundle = 'dh_properties',
#     featureid = inputs$featureid,
#     entity_type = inputs$entity_type 
#   );
#   if (!is.null(inputs$varid)) {
#     pbody$varid = inputs$varid
#   }
#   if (!is.null(inputs$bundle)) {
#     pbody$bundle = inputs$bundle
#   }
#   if (!is.null(inputs$propcode)) {
#     pbody$propcode = inputs$propcode
#   }
#   if (!is.null(inputs$propname)) {
#     pbody$propname = inputs$propname
#   }
#   if (!is.null(inputs$pid)) {
#     if (inputs$pid > 0) {
#       # forget about other attributes, just use pid
#       pbody = list(
#         pid = inputs$pid
#       )
#     }
#   }
#   
#   prop <- GET(
#     paste(base_url,"/dh_properties.json",sep=""), 
#     add_headers(HTTP_X_CSRF_TOKEN = token),
#     query = pbody, 
#     encode = "json"
#   );
#   prop_cont <- content(prop);
#   
#   if (length(prop_cont$list) != 0) {
#     print(paste("Number of properties found: ",length(prop_cont$list),sep=""))
#     
#     prop <- data.frame(proptext=character(),
#                        pid=character(),
#                        propname=character(), 
#                        propvalue=character(),
#                        propcode=character(),
#                        startdate=character(),
#                        enddate=character(),
#                        featureid=character(),
#                        modified=character(),
#                        entity_type=character(),
#                        bundle=character(),
#                        varid=character(),
#                        uid=character(),
#                        vid=character(),
#                        status=character(),
#                        module=character(),
#                        field_dh_matrix=character(),
#                        stringsAsFactors=FALSE) 
#     
#     i <- 1
#     for (i in 1:length(prop_cont$list)) {
#       
#       prop_i <- data.frame(
#         "proptext" = if (is.null(prop_cont$list[[i]]$proptext)){""} else {prop_cont$list[[i]]$proptext},
#         "pid" = if (is.null(prop_cont$list[[i]]$pid)){""} else {as.integer(prop_cont$list[[i]]$pid)},
#         "propname" = if (is.null(prop_cont$list[[i]]$propname)){""} else {prop_cont$list[[i]]$propname},
#         "propvalue" = if (is.null(prop_cont$list[[i]]$propvalue)){""} else {as.numeric(prop_cont$list[[i]]$propvalue)},
#         "propcode" = if (is.null(prop_cont$list[[i]]$propcode)){""} else {prop_cont$list[[i]]$propcode},
#         "startdate" = if (is.null(prop_cont$list[[i]]$startdate)){""} else {prop_cont$list[[i]]$startdate},
#         "enddate" = if (is.null(prop_cont$list[[i]]$enddate)){""} else {prop_cont$list[[i]]$enddate},
#         "featureid" = if (is.null(prop_cont$list[[i]]$featureid)){""} else {prop_cont$list[[i]]$featureid},
#         "modified" = if (is.null(prop_cont$list[[i]]$modified)){""} else {prop_cont$list[[i]]$modified},
#         "entity_type" = if (is.null(prop_cont$list[[i]]$entity_type)){""} else {prop_cont$list[[i]]$entity_type},
#         "bundle" = if (is.null(prop_cont$list[[i]]$bundle)){""} else {prop_cont$list[[i]]$bundle},
#         "varid" = if (is.null(prop_cont$list[[i]]$varid)){""} else {prop_cont$list[[i]]$varid},
#         "uid" = if (is.null(prop_cont$list[[i]]$uid)){""} else {prop_cont$list[[i]]$uid},
#         "vid" = if (is.null(prop_cont$list[[i]]$vid)){""} else {prop_cont$list[[i]]$vid},
#         "field_dh_matrix" = "",
#         "status" = if (is.null(prop_cont$list[[i]]$status)){""} else {prop_cont$list[[i]]$status},
#         "module" = if (is.null(prop_cont$list[[i]]$module)){""} else {prop_cont$list[[i]]$module},
#         stringsAsFactors=FALSE
#       )
#       # handle data_matrix
#       if (!is.null(prop_cont$list[[i]]$field_dh_matrix$value)) {
#         dfl = prop_cont$list[[i]]$field_dh_matrix$value
#         df <- data.frame(matrix(unlist(dfl), nrow=length(dfl), byrow=T))
#         prop_i$field_dh_matrix <- jsonlite::serializeJSON(df);
#       }
#       prop  <- rbind(prop, prop_i)
#     }
#   } else {
#     print("This property does not exist")
#     return(FALSE)
#   }
#   prop <- prop
# }


# postProperty <- function(inputs,base_url,prop){
#   
#   #inputs <-prop_inputs
#   #base_url <- site
#   #Search for existing property matching supplied varkey, featureid, entity_type 
#   dataframe <- getProperty(inputs, base_url, prop)
#   if (is.data.frame(dataframe)) {
#     pid <- as.character(dataframe$pid)
#   } else {
#     pid = NULL
#   }
#   if (!is.null(inputs$varkey)) {
#     # this would use REST 
#     # getVarDef(list(varkey = inputs$varkey), token, base_url)
#     # but it is broken for vardef for now metadatawrapper fatal error
#     # EntityMetadataWrapperException: Invalid data value given. Be sure it matches the required data type and format. 
#     # in EntityDrupalWrapper->set() 
#     # (line 736 of /var/www/html/d.dh/modules/entity/includes/entity.wrapper.inc).
#     
#     propdef_url<- paste(base_url,"/?q=vardefs.tsv/",inputs$varkey,sep="")
#     propdef_table <- read.table(propdef_url,header = TRUE, sep = "\t")    
#     varid <- propdef_table[1][which(propdef_table$varkey == inputs$varkey),]
#     print(paste("varid: ",varid,sep=""))
#     if (is.null(varid)) {
#       # we sent a bad variable id so we should return FALSE
#       return(FALSE)
#     }
#   }
#   if (!is.null(inputs$varid)) {
#     varid = inputs$varid
#   }
#   
#   if (is.null(varid)) {
#     print("Variable IS is null - returning.")
#     return(FALSE)
#   }
#   
#   pbody = list(
#     bundle = 'dh_properties',
#     featureid = inputs$featureid,
#     varid = varid,
#     entity_type = inputs$entity_type,
#     proptext = inputs$proptext,
#     propvalue = inputs$propvalue,
#     propcode = inputs$propcode,
#     startdate = inputs$startdate,
#     propname = inputs$propname,
#     enddate = inputs$enddate
#   );
#   
#   if (is.null(pid)){
#     print("Creating Property...")
#     prop <- POST(paste(base_url,"/dh_properties/",sep=""), 
#                  add_headers(HTTP_X_CSRF_TOKEN = token),
#                  body = pbody,
#                  encode = "json"
#     );
#     #content(prop)
#     if (prop$status == 201){prop <- paste("Status ",prop$status,", Property Created Successfully",sep="")
#     } else {prop <- paste("Status ",prop$status,", Error: Property Not Created Successfully",sep="")}
#     
#   } else if (length(dataframe$pid) == 1){
#     print("Single Property Exists, Updating...")
#     print(paste("Posting", pbody$varid )) 
#     print(pbody) 
#     #pbody$pid = pid
#     prop <- PUT(paste(base_url,"/dh_properties/",pid,sep=""), 
#                 add_headers(HTTP_X_CSRF_TOKEN = token),
#                 body = pbody,
#                 encode = "json"
#     );
#     #content(prop)
#     if (prop$status == 200){prop <- paste("Status ",prop$status,", Property Updated Successfully",sep="")
#     } else {prop <- paste("Status ",prop$status,", Error: Property Not Updated Successfully",sep="")}
#   } else {
#     prop <- print("Multiple Properties Exist, Execution Halted")
#   }
#   return(prop)
# }

# getFeature <- function(inputs, token, base_url, feature){
#   #inputs <-    conveyance_inputs 
#   #base_url <- site
#   #print(inputs)
#   pbody = list(
#     hydroid = inputs$hydroid,
#     bundle = inputs$bundle,
#     ftype = inputs$ftype,
#     hydrocode = inputs$hydrocode
#   );
#   
#   
#   if (!is.null(inputs$hydroid)) {
#     if (inputs$hydroid > 0) {
#       # forget about other attributes, just use hydroid if provided 
#       pbody = list(
#         hydroid = inputs$hydroid
#       )
#     }
#   }
#   
#   feature <- GET(
#     paste(base_url,"/dh_feature.json",sep=""), 
#     add_headers(HTTP_X_CSRF_TOKEN = token),
#     query = pbody, 
#     encode = "json"
#   );
#   feature_cont <- content(feature);
#   
#   if (length(feature_cont$list) != 0) {
#     print(paste("Number of features found: ",length(feature_cont$list),sep=""))
#     
#     feat <- data.frame(hydroid = character(),
#                        bundle = character(),
#                        ftype = character(),
#                        hydrocode = character(),
#                        name = character(),
#                        fstatus = character(),
#                        address1 = character(),
#                        address2 = character(),
#                        city = character(),
#                        state = character(),
#                        postal_code = character(),
#                        description = character(),
#                        uid = character(),
#                        status = character(),
#                        module = character(),
#                        feed_nid = character(),
#                        dh_link_facility_mps = character(),
#                        dh_nextdown_id = character(),
#                        dh_areasqkm = character(),
#                        dh_link_admin_location = character(),
#                        field_dh_from_entity = character(),
#                        field_dh_to_entity = character(),
#                        dh_geofield = character(),
#                        geom = character(),
#                        stringsAsFactors=FALSE) 
#     
#     #i <- 1
#     for (i in 1:length(feature_cont$list)) {
#       
#       feat_i <- data.frame("hydroid" = if (is.null(feature_cont$list[[i]]$hydroid)){""} else {feature_cont$list[[i]]$hydroid},
#                            "bundle" = if (is.null(feature_cont$list[[i]]$bundle)){""} else {feature_cont$list[[i]]$bundle},
#                            "ftype" = if (is.null(feature_cont$list[[i]]$ftype)){""} else {feature_cont$list[[i]]$ftype},
#                            "hydrocode" = if (is.null(feature_cont$list[[i]]$hydrocode)){""} else {feature_cont$list[[i]]$hydrocode},
#                            "name" = if (is.null(feature_cont$list[[i]]$name)){""} else {feature_cont$list[[i]]$name},
#                            "fstatus" = if (is.null(feature_cont$list[[i]]$fstatus)){""} else {feature_cont$list[[i]]$fstatus},
#                            "address1" = if (is.null(feature_cont$list[[i]]$address1)){""} else {feature_cont$list[[i]]$address1},
#                            "address2" = if (is.null(feature_cont$list[[i]]$address2)){""} else {feature_cont$list[[i]]$address2},
#                            "city" = if (is.null(feature_cont$list[[i]]$city)){""} else {feature_cont$list[[i]]$city},
#                            "state" = if (is.null(feature_cont$list[[i]]$state)){""} else {feature_cont$list[[i]]$state},
#                            "postal_code" = if (is.null(feature_cont$list[[i]]$postal_code)){""} else {feature_cont$list[[i]]$postal_code},
#                            "description" = if (is.null(feature_cont$list[[i]]$description)){""} else {feature_cont$list[[i]]$description},
#                            "uid" = if (is.null(feature_cont$list[[i]]$uid)){""} else {feature_cont$list[[i]]$uid},
#                            "status" = if (is.null(feature_cont$list[[i]]$status)){""} else {feature_cont$list[[i]]$status},
#                            "module" = if (is.null(feature_cont$list[[i]]$module)){""} else {feature_cont$list[[i]]$module},
#                            "feed_nid" = if (is.null(feature_cont$list[[i]]$feed_nid)){""} else {feature_cont$list[[i]]$feed_nid},
#                            "dh_link_facility_mps" = if (!length(feature_cont$list[[i]]$dh_link_facility_mps)){""} else {feature_cont$list[[i]]$dh_link_facility_mps[[1]]$id},
#                            "dh_nextdown_id" = if (!length(feature_cont$list[[i]]$dh_nextdown_id)){""} else {feature_cont$list[[i]]$dh_nextdown_id[[1]]$id},
#                            "dh_areasqkm" = if (is.null(feature_cont$list[[i]]$dh_areasqkm)){""} else {feature_cont$list[[i]]$dh_areasqkm},
#                            "dh_link_admin_location" = if (!length(feature_cont$list[[i]]$dh_link_admin_location)){""} else {feature_cont$list[[i]]$dh_link_admin_location[[1]]$id},
#                            "field_dh_from_entity" = if (!length(feature_cont$list[[i]]$field_dh_from_entity)){""} else {feature_cont$list[[i]]$field_dh_from_entity$id},
#                            "field_dh_to_entity" = if (!length(feature_cont$list[[i]]$field_dh_to_entity)){""} else {feature_cont$list[[i]]$field_dh_to_entity$id},
#                            "dh_geofield" = if (is.null(feature_cont$list[[i]]$dh_geofield$geom)){""} else {feature_cont$list[[i]]$dh_geofield$geom},
#                            "geom" = if (is.null(feature_cont$list[[i]]$dh_geofield$geom)){""} else {feature_cont$list[[i]]$dh_geofield$geom}
#       )
#       
#       # "dh_link_admin_location" = if (!length(feature_cont$list[[i]]$dh_link_admin_location)){""} else {feature_cont$list[[i]]$dh_link_admin_location[[1]]$id},
#       
#       
#       feat  <- rbind(feat, feat_i)
#     }
#   } else {
#     print("This Feature does not exist")
#     return(FALSE)
#   }
#   feature <- feat
# }

getPropertyALT <- function(inputs, base_url, prop, token){
  print(inputs)
  #Convert varkey to varid - needed for REST operations 
  if (!is.null(inputs$varkey)) {
    # this would use REST 
    # getVarDef(list(varkey = inputs$varkey), token, base_url)
    # but it is broken for vardef for now metadatawrapper fatal error
    # EntityMetadataWrapperException: Invalid data value given. Be sure it matches the required data type and format. 
    # in EntityDrupalWrapper->set() 
    # (line 736 of /var/www/html/d.dh/modules/entity/includes/entity.wrapper.inc).
    
    propdef_url<- paste(base_url,"/?q=vardefs.tsv/",inputs$varkey,sep="")
    print(paste("Trying", propdef_url))
    propdef_table <- read.table(propdef_url,header = TRUE, sep = "\t")    
    varid <- propdef_table[1][which(propdef_table$varkey == inputs$varkey),]
    print(paste("varid: ",varid,sep=""))
    if (is.null(varid)) {
      # we sent a bad variable id so we should return FALSE
      return(FALSE)
    }
    inputs$varid = varid
  }
  # now, verify that we have either a proper varid OR a propname
  if (is.null(inputs$varid) & is.null(inputs$propname)) {
    # we were sent a bad variable id so we should return FALSE
    return(FALSE)
  }
  
  pbody = list(
    #bundle = 'dh_properties',
    featureid = inputs$featureid,
    entity_type = inputs$entity_type 
  );
  if (!is.null(inputs$varid)) {
    pbody$varid = inputs$varid
  }
  if (!is.null(inputs$bundle)) {
    pbody$bundle = inputs$bundle
  }
  if (!is.null(inputs$propcode)) {
    pbody$propcode = inputs$propcode
  }
  if (!is.null(inputs$propname)) {
    pbody$propname = inputs$propname
  }
  if (!is.null(inputs$pid)) {
    if (inputs$pid > 0) {
      # forget about other attributes, just use pid
      pbody = list(
        pid = inputs$pid
      )
    }
  }
  
  prop <- GET(
    paste(base_url,"/dh_properties.json",sep=""), 
    add_headers(HTTP_X_CSRF_TOKEN = token),
    query = pbody, 
    encode = "json"
  );
  prop_cont <- content(prop);
  
  if (length(prop_cont$list) != 0) {
    print(paste("Number of properties found: ",length(prop_cont$list),sep=""))
    
    prop <- data.frame(proptext=character(),
                       pid=character(),
                       propname=character(), 
                       propvalue=character(),
                       propcode=character(),
                       startdate=character(),
                       enddate=character(),
                       featureid=character(),
                       modified=character(),
                       entity_type=character(),
                       bundle=character(),
                       varid=character(),
                       uid=character(),
                       vid=character(),
                       status=character(),
                       module=character(),
                       field_dh_matrix=character(),
                       stringsAsFactors=FALSE) 
    
    i <- 1
    for (i in 1:length(prop_cont$list)) {
      
      prop_i <- data.frame(
        "proptext" = if (is.null(prop_cont$list[[i]]$proptext)){""} else {prop_cont$list[[i]]$proptext},
        "pid" = if (is.null(prop_cont$list[[i]]$pid)){""} else {as.integer(prop_cont$list[[i]]$pid)},
        "propname" = if (is.null(prop_cont$list[[i]]$propname)){""} else {prop_cont$list[[i]]$propname},
        "propvalue" = if (is.null(prop_cont$list[[i]]$propvalue)){""} else {as.numeric(prop_cont$list[[i]]$propvalue)},
        "propcode" = if (is.null(prop_cont$list[[i]]$propcode)){""} else {prop_cont$list[[i]]$propcode},
        "startdate" = if (is.null(prop_cont$list[[i]]$startdate)){""} else {prop_cont$list[[i]]$startdate},
        "enddate" = if (is.null(prop_cont$list[[i]]$enddate)){""} else {prop_cont$list[[i]]$enddate},
        "featureid" = if (is.null(prop_cont$list[[i]]$featureid)){""} else {prop_cont$list[[i]]$featureid},
        "modified" = if (is.null(prop_cont$list[[i]]$modified)){""} else {prop_cont$list[[i]]$modified},
        "entity_type" = if (is.null(prop_cont$list[[i]]$entity_type)){""} else {prop_cont$list[[i]]$entity_type},
        "bundle" = if (is.null(prop_cont$list[[i]]$bundle)){""} else {prop_cont$list[[i]]$bundle},
        "varid" = if (is.null(prop_cont$list[[i]]$varid)){""} else {prop_cont$list[[i]]$varid},
        "uid" = if (is.null(prop_cont$list[[i]]$uid)){""} else {prop_cont$list[[i]]$uid},
        "vid" = if (is.null(prop_cont$list[[i]]$vid)){""} else {prop_cont$list[[i]]$vid},
        "field_dh_matrix" = "",
        "status" = if (is.null(prop_cont$list[[i]]$status)){""} else {prop_cont$list[[i]]$status},
        "module" = if (is.null(prop_cont$list[[i]]$module)){""} else {prop_cont$list[[i]]$module},
        stringsAsFactors=FALSE
      )
      # handle data_matrix
      if (!is.null(prop_cont$list[[i]]$field_dh_matrix$value)) {
        dfl = prop_cont$list[[i]]$field_dh_matrix$value
        df <- data.frame(matrix(unlist(dfl), nrow=length(dfl), byrow=T))
        prop_i$field_dh_matrix <- jsonlite::serializeJSON(df);
      }
      prop  <- rbind(prop, prop_i)
    }
  } else {
    print("This property does not exist")
    return(FALSE)
  }
  prop <- prop
}

fn_gage_and_seg_mapperALT <- function(riv.seg, site_number, site_url, cbp6_link, token) {
  
  #----------Define function for watershedDF-----------------------
  getWatershedDF <- function(geom){
    
    watershed_geom <- readWKT(geom)
    watershed_geom_clip <- gIntersection(bb, watershed_geom)
    if (is.null(watershed_geom_clip)) {
      watershed_geom_clip = watershed_geom
    }
    wsdataProjected <- SpatialPolygonsDataFrame(watershed_geom_clip,data.frame("id"), match.ID = FALSE)
    wsdataProjected@data$id <- rownames(wsdataProjected@data)
    watershedPoints <- fortify(wsdataProjected, region = "id")
    watershedDF <- merge(watershedPoints, wsdataProjected@data, by = "id")
    
    return(watershedDF)
  }
  
  AllSegList <- c('OR5_7980_8200', 'OR2_8020_8130', 'OR2_8070_8120', 'OR4_8120_7890',
                  'OR2_8130_7900', 'OR5_8200_8370', 'OR4_8271_8120', 'TU3_8480_8680',
                  'TU1_8570_8680', 'TU3_8650_8800', 'TU4_8680_8810', 'TU2_8790_9070',
                  'TU4_8800_9290', 'TU4_8810_9000', 'BS4_8540_8441', 'BS3_8580_8440',
                  'BS2_8590_8440', 'BS1_8730_8540', 'MN2_8250_8190', 'MN4_8260_8400',
                  'MN0_8300_0001', 'MN4_8400_8380', 'MN4_8510_8380', 'MN2_8530_8510',
                  'NR6_7820_7960', 'NR1_7880_8050', 'BS3_8350_8330', 'BS4_8440_8441',
                  'MN3_7540_7680', 'MN1_7590_7860', 'MN1_7620_7710', 'MN3_7680_7860',
                  'MN4_7710_8161', 'MN2_7720_7830', 'MN1_7730_8160', 'MN3_7770_7930',
                  'MN4_7810_8080', 'MN2_7830_7950', 'MN3_7860_8080', 'MN3_7930_8010',
                  'MN4_7950_7710', 'MN1_7990_8100', 'MN3_8010_7950', 'MN4_8080_8110',
                  'MN2_8100_8190', 'MN5_8161_8160', 'MN3_8190_8260', 'MN5_8230_8161',
                  'NR6_7960_8050', 'NR1_8030_8051', 'NR6_8050_8051', 'NR6_8051_8000',
                  'NR6_8170_7960', 'NR6_8180_8051', 'NR2_8210_8180', 'NR3_8290_8170',
                  'NR3_8420_8430', 'NR3_8430_7820', 'NR6_8640_8500', 'NR3_8690_8500',
                  'NR5_8700_8640', 'NR3_8740_8500', 'NR5_8760_8640', 'NR1_8820_8760',
                  'NR5_8870_8760', 'NR1_8960_8870', 'NR1_9030_9080', 'NR5_9050_8870',
                  'NR5_9080_9050', 'NR4_9130_9080', 'NR1_9150_9050', 'NR3_9170_9130',
                  'NR3_9190_9170', 'NR3_9240_9130', 'NR2_9250_9170', 'NR3_9310_9240',
                  'OD3_8340_8520', 'OD3_8520_8621', 'OD2_8560_8630', 'OD6_8621_8470',
                  'OD3_8630_8720', 'OD6_8660_8621', 'OD2_8670_8890', 'OD3_8710_8470',
                  'OD3_8720_8900', 'OD5_8770_8780', 'OD5_8780_8660', 'OD2_8830_8710',
                  'OD2_8840_9020', 'OD3_8850_8931', 'OD5_8890_8770', 'OD5_8900_8770',
                  'OD1_8910_8930', 'OD2_8920_8830', 'OD3_8930_8931', 'OD3_8931_9140',
                  'OD5_8940_8780', 'OD4_8990_8900', 'OD3_9020_9110', 'OD4_9110_9140',
                  'OD4_9140_8990', 'OD1_9270_9110', 'OR2_7610_7780', 'OR2_7650_8070',
                  'OR2_7670_7840', 'OR1_7700_7980', 'OR3_7740_8271', 'OR2_7780_7890',
                  'OR2_7840_7970', 'OR5_7890_7970', 'OR2_7900_7740', 'OR5_7910_8410',
                  'OR5_7970_8200', 'OR1_8280_8020', 'OR1_8320_8271', 'OR5_8370_8410',
                  'OR5_8410_8470', 'OR2_8450_8490', 'OR2_8460_8271', 'OR7_8470_8490',
                  'TU2_8860_9000', 'TU3_8880_9230', 'TU2_8950_9040', 'TU2_8970_9280',
                  'TU5_9000_9280', 'TU1_9010_9290', 'TU3_9040_9180', 'TU3_9060_9230',
                  'TU2_9070_9090', 'TU2_9100_9200', 'TU3_9180_9090', 'TU2_9200_9180',
                  'TU1_9220_9200', 'TU3_9230_9260', 'NR2_8600_8700', 'NR6_8500_7820',
                  'EL0_4560_4562','EL0_4561_4562','EL0_4562_0001','EL2_4400_4590',
                  'EL2_4590_0001','EL2_5110_5270','EL2_5270_0001','PM0_4640_4820',
                  'PM1_3120_3400','PM1_3450_3400','PM1_3510_4000','PM1_3710_4040',
                  'PM1_4000_4290','PM1_4250_4500','PM1_4430_4200','PM1_4500_4580',
                  'PM2_2860_3040','PM2_3400_3340','PM2_4860_4670','PM3_3040_3340',
                  'PM3_4660_4620','PM3_4670_4660','PM4_3340_3341','PM4_3341_4040',
                  'PM4_4040_4410','PM7_4150_4290','PM7_4200_4410','PM7_4290_4200',
                  'PM7_4410_4620','PM7_4580_4820','PM7_4620_4580','PM7_4820_0001',
                  'PS0_6150_6160','PS0_6160_6161','PS1_4790_4830','PS1_4830_5080',
                  'PS2_5550_5560','PS2_5560_5100','PS2_6420_6360','PS2_6490_6420',
                  'PS2_6660_6490','PS2_6730_6660','PS3_5100_5080','PS3_5990_6161',
                  'PS3_6161_6280','PS3_6280_6230','PS3_6460_6230','PS4_5080_4380',
                  'PS4_5840_5240','PS4_6230_6360','PS4_6360_5840','PS5_4370_4150',
                  'PS5_4380_4370','PS5_5200_4380','PS5_5240_5200','PU0_3000_3090',
                  'PU0_3601_3602','PU0_3611_3530','PU0_3751_3752','PU0_3871_3690',
                  'PU0_5620_5380','PU0_6080_5620','PU1_3030_3440','PU1_3100_3690',
                  'PU1_3170_3580','PU1_3580_3780','PU1_3850_4190','PU1_3940_3970',
                  'PU1_4190_4300','PU1_4300_4440','PU1_4840_4760',
                  'PU1_5380_5050','PU1_5520_5210','PU1_5820_5380','PU2_2790_3290',
                  'PU2_2840_3080','PU2_3080_3640','PU2_3090_4050','PU2_3140_3680',
                  'PU2_3180_3370','PU2_3370_4020','PU2_3630_3590','PU2_3770_3600',
                  'PU2_3900_3750','PU2_4050_4180','PU2_4160_3930','PU2_4220_3900',
                  'PU2_4340_3860','PU2_4360_4160','PU2_4720_4750','PU2_4730_4220',
                  'PU2_5190_4310','PU2_5700_5210','PU2_6050_5190',
                  'PU3_2510_3290','PU3_3290_3390','PU3_3390_3730','PU3_3680_3890',
                  'PU3_3860_3610','PU3_4280_3860','PU3_4450_4440','PU3_5210_5050',
                  'PU4_3780_3930','PU4_3890_3990','PU4_3970_3890','PU4_3990_3780',
                  'PU4_4210_4170','PU4_4310_4210','PU4_4440_3970','PU4_5050_4310',
                  'PU5_3930_4170','PU5_4170_4020','PU6_3440_3590','PU6_3530_3440',
                  'PU6_3590_3640','PU6_3600_3602','PU6_3602_3730','PU6_3610_3530',
                  'PU6_3640_3600','PU6_3690_3610','PU6_3730_3750','PU6_3750_3752',
                  'PU6_3752_4080','PU6_3870_3690','PU6_4020_3870','PU6_4080_4180',
                  'PU6_4180_4150','JA0_7291_7290','JA2_7290_0001','JA1_7600_7570',
                  'JA1_7640_7280','JA2_7410_7470','JA2_7550_7280','JA2_7570_7480',
                  'JA4_7280_7340','JA4_7340_7470','JA4_7470_7480','JA5_7480_0001',
                  'JB3_6820_7053','JB3_7053_0001','PL1_4460_4780','PL1_4780_0001',
                  'JL1_6560_6440','JL1_6760_6910','JL1_6770_6850','JL1_6910_6960',
                  'JL1_6940_7200','JL1_7080_7190','JL1_7170_6800','JL1_7190_7250',
                  'JL1_7200_7250','JL1_7530_7430','JL2_6240_6520','JL2_6440_6441',
                  'JL2_6441_6520','JL2_6850_6890','JL2_7110_7120','JL2_7120_6970',
                  'JL2_7240_7350','JL2_7250_7090','JL2_7350_7090','JL3_7020_7100',
                  'JL3_7090_7150','JL4_6520_6710','JL4_6710_6740','JL6_6740_7100',
                  'JL6_6890_6990','JL6_6960_6970','JL6_6970_6740','JL6_6990_6960',
                  'JL6_7150_6890','JL6_7160_7440','JL6_7320_7150','JL6_7430_7320',
                  'JL6_7440_7430','JL7_6800_7070','JL7_7030_6800','JL7_7070_0001',
                  'JL7_7100_7030','JU1_6290_6590','JU1_6300_6650','JU1_6340_6650',
                  'JU1_6590_6600','JU1_6880_7260','JU1_7560_7500','JU1_7630_7490',
                  'JU1_7690_7490','JU1_7750_7560','JU2_6410_6640','JU2_6600_6810',
                  'JU2_6810_6900','JU2_7140_7330','JU2_7180_7380','JU2_7360_7000',
                  'JU2_7450_7360','JU3_6380_6900','JU3_6640_6790','JU3_6650_7300',
                  'JU3_6790_7260','JU3_6900_6950','JU3_6950_7330','JU3_7400_7510',
                  'JU3_7490_7400','JU4_7000_7300','JU4_7260_7380','JU4_7330_7000',
                  'JU4_7380_7160','JU5_7300_7510','JU5_7420_7160','JU5_7500_7420',
                  'JU5_7510_7500','PL0_5141_5140','PL1_5370_5470','PL2_4970_5250',
                  'PL2_5140_5360','PL2_5470_5360','PL3_5250_0001','PL3_5360_5250',
                  'PL0_5010_5130','PL1_5130_0001','PL0_5490_0001','PL0_5540_5490',
                  'PL2_5300_5630','PL2_5630_0001','PL0_5730_5690','PL1_5690_0001',
                  'PL0_5530_5710','PL0_5710_0001','RU2_5220_5640','RU2_5500_5610',
                  'RU2_5810_5610','RU2_5940_6200','RU2_6090_6220','RU2_6200_6170',
                  'RU2_6220_6170','RU3_5610_5640','RU3_6170_6040','RU4_5640_6030',
                  'RU4_6040_6030','RU5_6030_0001','XU0_4090_4270','XU0_4091_4270',
                  'XU0_4130_4070','XU2_4070_4330','XU2_4270_4650','XU2_4330_4480',
                  'XU2_4480_4650','XU3_4650_0001','YM1_6370_6620','YM2_6120_6430',
                  'YM3_6430_6620','YM4_6620_0001','YP1_6570_6680','YP1_6680_6670',
                  'YP2_6390_6330','YP3_6330_6700','YP3_6470_6690','YP3_6670_6720',
                  'YP3_6690_6720','YP3_6700_6670','YP4_6720_6750','YP4_6750_0001',
                  'YP0_6840_0001','YP0_6860_6840',
                  'EL0_5400_0001','EL1_5150_0001',
                  'EL1_5430_0001','EL1_5570_0001','EL1_6000_0001','JB0_7051_0001',
                  'JB0_7052_0001','JB1_8090_0001','JB2_7800_0001','PL0_4510_0001',
                  'PL0_5000_0001','PL0_5070_0001','PL0_5510_0001','PL0_5720_0001',
                  'PL0_5750_0001','PL0_5830_0001','PL1_4540_0001','PL1_5230_0001',
                  'PL1_5910_0001','RL0_6540_0001','RL1_6180_0001','YL2_6580_0001',
                  'PU1_4760_4451','PU2_4750_4451','PU3_4451_4450','PM1_3711_3710',
                  'PM1_4251_4250','PM1_4252_4250') 
  
  # Splitting the River Segment string into each segment name
  riv.segStr <- strsplit(riv.seg, "\\+")
  riv.segStr <- riv.segStr[[1]]
  num.segs <- as.numeric(length(riv.segStr))
  
  # Getting all upstream segments for each of the linked segs, combining
  # to form a vector of all upstream segments.
  AllUpstreamSegs <- vector()
  for (i in 1:num.segs) {
    riv.seg <- riv.segStr[i]
    UpstreamSegs <- fn_ALL.upstream(riv.seg, AllSegList)
    AllUpstreamSegs <- c(AllUpstreamSegs, UpstreamSegs)
  }
  AllUpstreamSegs <- c(riv.seg, AllUpstreamSegs)
  eliminate <- which(AllUpstreamSegs=="NA")
  if (is.empty(eliminate) == FALSE) {
    AllUpstreamSegs <- AllUpstreamSegs[-eliminate]
  }
  AllUpstreamSegs <- unique(AllUpstreamSegs)
  num.upstream <- as.numeric(length(AllUpstreamSegs))
  
  STATES <- read.table(file=paste(cbp6_link,"GIS_LAYERS","STATES.tsv",sep="/"), header=TRUE, sep="\t") #Load state geometries
  RIVDF <- read.table(file=paste(cbp6_link,"GIS_LAYERS","RIVDF.csv",sep="/"), header=TRUE, sep=",") #Load state geometries
  WBDF <- read.table(file=paste(cbp6_link,"GIS_LAYERS","WBDF.csv",sep="/"), header=TRUE, sep=",") #Load state geometries
  
  # first specify bounding box / extent of map: -----------------------------
  extent <- data.frame(x = c(-84, -75), 
                       y = c(35, 41))  
  
  bb=readWKT(paste0("POLYGON((",extent$x[1]," ",extent$y[1],",",extent$x[2]," ",extent$y[1],",",extent$x[2]," ",extent$y[2],",",extent$x[1]," ",extent$y[2],",",extent$x[1]," ",extent$y[1],"))",sep=""))
  bbProjected <- SpatialPolygonsDataFrame(bb,data.frame("id"), match.ID = FALSE)
  bbProjected@data$id <- rownames(bbProjected@data)
  bbPoints <- fortify(bbProjected, region = "id")
  bbDF <- merge(bbPoints, bbProjected@data, by = "id")
  
  
  # specify states info: LOAD STATE GEOMETRY --------------------------------
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
  
  KY <- STATES[which(STATES$state == "KY"),]
  KY_geom <- readWKT(KY$geom)
  KY_geom_clip <- gIntersection(bb, KY_geom)
  KYProjected <- SpatialPolygonsDataFrame(KY_geom_clip,data.frame("id"), match.ID = TRUE)
  KYProjected@data$id <- rownames(KYProjected@data)
  KYPoints <- fortify( KYProjected, region = "id")
  KYDF <- merge(KYPoints,  KYProjected@data, by = "id")
  
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
  
  PA <- STATES[which(STATES$state == "PA"),]
  PA_geom <- readWKT(PA$geom)
  PA_geom_clip <- gIntersection(bb, PA_geom)
  PAProjected <- SpatialPolygonsDataFrame(PA_geom_clip,data.frame("id"), match.ID = TRUE)
  PAProjected@data$id <- rownames(PAProjected@data)
  PAPoints <- fortify( PAProjected, region = "id")
  PADF <- merge(PAPoints,  PAProjected@data, by = "id")
  
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
  
  SC <- STATES[which(STATES$state == "SC"),]
  SC_geom <- readWKT(SC$geom)
  SC_geom_clip <- gIntersection(bb, SC_geom)
  SCProjected <- SpatialPolygonsDataFrame(SC_geom_clip,data.frame("id"), match.ID = TRUE)
  SCProjected@data$id <- rownames(SCProjected@data)
  SCPoints <- fortify( SCProjected, region = "id")
  SCDF <- merge(SCPoints,  SCProjected@data, by = "id")
  
  DC <- STATES[which(STATES$state == "DC"),]
  DC_geom <- readWKT(DC$geom)
  DC_geom_clip <- gIntersection(bb, DC_geom)
  DCProjected <- SpatialPolygonsDataFrame(DC_geom_clip,data.frame("id"), match.ID = TRUE)
  DCProjected@data$id <- rownames(DCProjected@data)
  DCPoints <- fortify( DCProjected, region = "id")
  DCDF <- merge(DCPoints,  DCProjected@data, by = "id")
  
  if (num.upstream > 0) {
    for (i in 1:num.upstream) {  
      riv.seg <- AllUpstreamSegs[i]
      namer <- paste0("upstream.watershedDF", i)
      
      # Retrieve Riversegment Feature From VAHydro  -----------------------------
      
      inputs <- list (
        bundle = 'watershed',
        ftype = 'vahydro',
        hydrocode = paste0('vahydrosw_wshed_', riv.seg)
      )
      
      dataframe <- getFeature(inputs, token, site_url)
      #print(dataframe)
      hydroid <- dataframe$hydroid
      inputs <- list(
        varkey = "wshed_drainage_area_sqmi",
        featureid = hydroid,
        entity_type = "dh_properties"
      )
      prop <- getPropertyALT(inputs, site_url, prop, token)
      
      inputs <- list(
        varkey = "wshed_local_area_sqmi",
        featureid = hydroid,
        entity_type = "dh_feature"
      )
      local_da_prop <- getPropertyALT(inputs, site_url, prop, token)
      #postProperty(inputs = local_da_prop, base_url = site_url, prop = prop)
      
      geom <- dataframe$geom
      watershedDF <- getWatershedDF(geom)
      assign(namer, watershedDF)
    }
  }
  
  
  for (i in 1:num.segs) {  
    riv.seg <- riv.segStr[i]
    namer <- paste0("seg.watershedDF", i)
    
    # Retrieve Riversegment Feature From VAHydro  -----------------------------
    
    inputs <- list (
      bundle = 'watershed',
      ftype = 'vahydro',
      hydrocode = paste0('vahydrosw_wshed_', riv.seg)
    )
    
    dataframe <- getFeature(inputs, token, site_url)
    #print(dataframe)
    hydroid <- dataframe$hydroid
    inputs <- list(
      varkey = "wshed_drainage_area_sqmi",
      featureid = hydroid,
      entity_type = "dh_properties"
    )
    prop <- getPropertyALT(inputs, site_url, prop, token)
    
    inputs <- list(
      varkey = "wshed_local_area_sqmi",
      featureid = hydroid,
      entity_type = "dh_feature"
    )
    local_da_prop <- getPropertyALT(inputs, site_url, prop, token)
    #postProperty(inputs = local_da_prop, base_url = site_url, prop = prop)
    
    geom <- dataframe$geom
    watershedDF <- getWatershedDF(geom)
    assign(namer, watershedDF)
  }
  
  # set up ggplot for states ---------------
  statemap <- ggplot(data = VADF, aes(x=long, y=lat, group = group))+
    geom_polygon(data = bbDF, color="black", fill = "powderblue",lwd=0.5)+
    geom_polygon(data = VADF, color="gray46", fill = "gray")+
    geom_polygon(data = TNDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = NCDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = SCDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = KYDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = WVDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = MDDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = DEDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = PADF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = NJDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = OHDF, color="gray46", fill = "gray", lwd=0.5)+
    geom_polygon(data = DCDF, color="gray46", fill = "gray", lwd=0.5)+
    
    
    geom_polygon(data = watershedDF, color="khaki4", fill = "green", alpha = 0.25,lwd=0.5)+
    
    # ADD RIVERS ####################################################################
  geom_point(data = RIVDF, aes(x = long, y = lat), color="steelblue1", size=0.09)+
    #################################################################################
  
  # ADD WATERBODIES ###############################################################
  geom_point(data = WBDF, aes(x = long, y = lat), color="steelblue1", size=0.09)
  #################################################################################
  # Create gage dataframe (gage_linked?) ---------------------
  library(dataRetrieval)
  
  gage <- try(readNWISsite(site_number))
  if (class(gage) == "try-error") {
    gage <- ""
  }
  GAGEDF <- try(data.frame(x=as.numeric(gage$dec_long_va),y=as.numeric(gage$dec_lat_va),X.id.="id",id="1"))
  if (class(GAGEDF) == "try-error") {
    GAGEDF <- ""
  }
  
  #--------------------------------------------------------------------------------------------
  #--------------------------------------------------------------------------------------------
  
  map <- statemap
  if (num.upstream > 0) {
    for (i in 1:num.upstream) {
      namer <- paste0("upstream.watershedDF", i)
      map <- map +
        geom_polygon(data = eval(parse(text = namer)), color="gray35", fill = "lightgreen",alpha = 0.25,lwd=0.5)
    }      
  }
  for (i in 1:num.segs) {
    namer <- paste0("seg.watershedDF", i)
    map <- map +
      geom_polygon(data = eval(parse(text = namer)), color="black", fill = "green3",alpha = 0.25,lwd=0.5)
  }
  
  map <- map + geom_polygon(data = bbDF, color="black", fill = NA,lwd=0.5)
  save.map <- map
  map <- try(map + geom_point(aes(x = x, y = y, group = id), data = GAGEDF, fill="red", color="black", size = 2.75, shape=24))
  if (site_number == "0NA") {
    map <- save.map
  }
  
  #additions to map -------------
  map <- map + 
    #ADD NORTH ARROW AND SCALE BAR
    scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', transform = TRUE, model = 'WGS84', st.bottom=FALSE, st.size = 3.5,
             anchor = c(
               x = (((extent$x[2] - extent$x[1])/2)+extent$x[1])-1.1,
               y = extent$y[1]+(extent$y[1])*0.001
             ))+
    north(bbDF, location = 'topleft', symbol = 12, scale=0.1)+
    scale_x_continuous(limits = c(extent$x))+
    scale_y_continuous(limits = c(extent$y))+
    
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.title.y=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank(),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          panel.border = element_blank()) 
  
  inputs <- list (
    bundle = 'watershed',
    ftype = 'vahydro',
    hydrocode = paste0('vahydrosw_wshed_', riv.seg)
  )
  print(map)
  return(map)
}

library(dplyr)

vahydro_import_lrseg_all_flows <- function(lr.seg.hydrocode, run.id, token, site = "http://deq2.bse.vt.edu/d.dh", start.date = '1984-01-01', end.date) {
  #set hydrocode equal to the ith hydrocode in the lrseg list
  hydrocode = lr.seg.hydrocode
  
  #set inputs for lrseg property
  ftype = 'cbp6_lrseg'
  bundle = 'landunit'
  inputs <- list (
    hydrocode = hydrocode,
    bundle = bundle,
    ftype = ftype
  )
  
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  
  featureid <- odata[1,"hydroid"];
  inputs <- list(
    varkey = "om_class_cbp_eos_file",
    featureid = featureid,
    entity_type = "dh_feature",
    propcode = "vahydro-1.0"
  )
  model <- getProperty(inputs, site, model)
  
  fin = as.numeric(as.character(model[1,]$pid))
  inputs <- list(
    varkey = "om_element_connection",
    featureid = fin,
    entity_type = "dh_properties"
  )
  prop <- getProperty(inputs, site, prop)
  
  # Manual elid
  elid = as.numeric(as.character(prop[1,]$propvalue))
  
  omsite = site <- "http://deq2.bse.vt.edu"
  dat <- fn_get_runfile(elid, run.id, site = omsite,  cached = FALSE);
  
  dat <- as.data.frame(dat)
  
  dat.trim <- select(dat,
                     thisdate, Qout, aop_suro, aop_ifwo, aop_agwo, 
                     cch_suro, cch_ifwo, cch_agwo, 
                     cci_suro, cci_ifwo, cci_agwo, 
                     ccn_suro, ccn_ifwo, ccn_agwo, 
                     cfr_suro, cfr_ifwo, cfr_agwo, 
                     cir_suro, cir_ifwo, cir_agwo, 
                     cmo_suro, cmo_ifwo, cmo_agwo, 
                     cnr_suro, cnr_ifwo, cnr_agwo, 
                     ctg_suro, ctg_ifwo, ctg_agwo, 
                     dbl_suro, dbl_ifwo, dbl_agwo, 
                     fnp_suro, fnp_ifwo, fnp_agwo, 
                     for_suro, for_ifwo, for_agwo, 
                     fsp_suro, fsp_ifwo, fsp_agwo, 
                     gom_suro, gom_ifwo, gom_agwo, 
                     gwm_suro, gwm_ifwo, gwm_agwo, 
                     hfr_suro, hfr_ifwo, hfr_agwo, 
                     lhy_suro, lhy_ifwo, lhy_agwo, 
                     mch_suro, mch_ifwo, mch_agwo, 
                     mci_suro, mci_ifwo, mci_agwo, 
                     mcn_suro, mcn_ifwo, mcn_agwo, 
                     mir_suro, mir_ifwo, mir_agwo, 
                     mnr_suro, mnr_ifwo, mnr_agwo, 
                     mtg_suro, mtg_ifwo, mtg_agwo, 
                     nch_suro, nch_ifwo, nch_agwo, 
                     nci_suro, nci_ifwo, nci_agwo, 
                     nir_suro, nir_ifwo, nir_agwo, 
                     nnr_suro, nnr_ifwo, nnr_agwo, 
                     ntg_suro, ntg_ifwo, ntg_agwo, 
                     oac_suro, oac_ifwo, oac_agwo, 
                     ohy_suro, ohy_ifwo, ohy_agwo, 
                     osp_suro, osp_ifwo, osp_agwo, 
                     pas_suro, pas_ifwo, pas_agwo, 
                     sch_suro, sch_ifwo, sch_agwo, 
                     scl_suro, scl_ifwo, scl_agwo, 
                     sgg_suro, sgg_ifwo, sgg_agwo, 
                     sho_suro, sho_ifwo, sho_agwo, 
                     som_suro, som_ifwo, som_agwo, 
                     soy_suro, soy_ifwo, soy_agwo, 
                     stb_suro, stb_ifwo, stb_agwo, 
                     stf_suro, stf_ifwo, stf_agwo, 
                     swm_suro, swm_ifwo, swm_agwo, 
                     wfp_suro, wfp_ifwo, wfp_agwo, 
                     wto_suro, wto_ifwo, wto_agwo)
  
  #dat.trim <- dat[,c(9,146,15:143)]
  rownames(dat.trim) <- NULL
  
  start.line <- as.numeric(which(dat.trim$thisdate == start.date))
  end.line <- as.numeric(which(dat.trim$thisdate == end.date))
  dat.trim <- dat.trim[start.line:end.line,]
  
  return(dat.trim)
}

vahydro_import_local.runoff.inflows_cfs <- function(riv.seg, run.id, token, site = "http://deq2.bse.vt.edu/d.dh", start.date = '1984-01-01', end.date) {
  hydrocode = paste0("vahydrosw_wshed_", riv.seg);
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list (
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  
  if (odata == FALSE) {
    return(odata)
  }
  
  # Get data frame for stashing multirun data
  stash <- data.frame();
  mostash <- data.frame();
  tsstash = FALSE;
  featureid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name );
  inputs <- list(
    varkey = "wshed_local_area_sqmi",
    featureid = featureid,
    entity_type = "dh_feature"
  )
  da <- getProperty(inputs, site, model)
  
  inputs <- list(
    varkey = "om_water_model_node",
    featureid = featureid,
    entity_type = "dh_feature",
    propcode = "vahydro-1.0"
  )
  model <- getProperty(inputs, site, model)
  mid = as.numeric(as.character(model[1,]$pid))
  inputs <- list(
    propname = "1. Local Runoff Inflows",
    featureid = mid,
    entity_type = "dh_properties"
  )
  midprop <- getProperty(inputs, site, midprop)
  
  if (midprop == FALSE) {
    return(midprop)
  }
  
  fin = as.numeric(as.character(midprop[1,]$pid))
  inputs <- list(
    varkey = "om_element_connection",
    featureid = fin,
    entity_type = "dh_properties"
  )
  prop <- getProperty(inputs, site, prop)
  
  # Manual elid
  elid = as.numeric(as.character(prop[1,]$propvalue))
  
  wshed_summary_tbl = data.frame(
    "Run ID" = character(), 
    "Segment Name (D. Area)" = character(), 
    "7Q10/ALF/LF-90" = character(), 
    "WD (mean/max)" = character(), 
    stringsAsFactors = FALSE) ;
  #pander(odata);
  #pander(odata);
  
  omsite = site <- "http://deq2.bse.vt.edu"
  dat <- fn_get_runfile_mod(elid, run.id, site = omsite,  cached = FALSE);
  
  if(is.na(dat) != TRUE) {
    if (dat == FALSE) {
      return(dat)
    }
  }  
  
  dat.date <- as.Date(as.character(dat$thisdate))
  dat.flow.unit <- as.numeric(dat$Runit)
  
  dat.trim <- data.frame(dat.date, dat.flow.unit, row.names = NULL)
  colnames(dat.trim) <- c('date','flow.unit')
  
  start.line <- as.numeric(which(dat.trim$date == start.date))
  end.line <- as.numeric(which(dat.trim$date == end.date))
  dat.trim <- dat.trim[start.line:end.line,]
  
  return(dat.trim)
}

figs11to13.smallest.diff.periods <- function(all_data, cn1='Scenario 1', cn2='Scenario 2', export_path = '/tmp/') {
  cn1 <- paste0('1: ', cn1)
  cn2 <- paste0('2: ', cn2)
  
  # This section will create a hydrograph that will zoom in on 3 month segments where difference is low
  # It does so for the top three lowest difference periods
  
  # find the first date for which data is collected, (in date format)
  # and a date that is roughly one year and two months past the first date
  YearStart <- as.character(as.Date(all_data$Date[1]))     
  fixer <- as.numeric(which(all_data$Date == paste0((year(YearStart)+1),"-11-30")))
  fixer <- fixer[1] # in case we are sub-daily timestep
  YearEnd <- as.character(as.Date(all_data$Date[fixer]))
  
  # YearStart_Row and YearEnd_Row are the rows corresponding the the YearStart and YearEnd dates
  YearStart_Row <- as.numeric(min(which(all_data$Date==YearStart)) )
  YearEnd_Row <- as.numeric(max(which(all_data$Date==YearEnd)))
  
  
  # initalize dataframes and counters, assign names for dataframe columns
  #AvgMonthlyDifference: used within nested for loop to create a 1x12 matrix that holds 1 year of 3 month difference segments
  #Timespan_Difference: used in large loop to store values from AvgMonthlyDifference; holds entire timespan of 3 month difference segments
  AvgMonthlyDifference <- data.frame(matrix(nrow=1,ncol=1));  
  names(AvgMonthlyDifference)<-'Difference' 
  Timespan_Difference <- data.frame(matrix(nrow=1, ncol=1)); 
  names(Timespan_Difference)<-'Difference'
  i <- 1; # used for first for loop to advance a year
  x <- 1 # x and y used to advance dataframes
  y <- 12
  
  # start loops used for yearly and monthly data  -------------------------------------------------------------
  
  loop <- as.numeric(round(length(unique(all_data$Date) )/365, digits = 0))-1
  for (i in 1:loop){                                # run loop for an entire data series
    year <- all_data[YearStart_Row:YearEnd_Row,] # specify year: 10-01-year1 to 11-30-year2
    m <- 1                                        # counter for nested loop
    
    MonthStart <- YearStart  # first date for 3 month timespan                      
    doi <- as.Date(MonthStart) 
    doi <- doi + seq(0,365,31) 
    # doi= date of interest. dummy variable just to create the function next.month
    next.month <- function(doi) as.Date(as.yearmon(doi) + 1/12) +  as.numeric(as.Date(doi)-(as.Date(as.yearmon(doi))))
    
    #(re)initalize variables for the nested loop
    MonthEnd <-data.frame(next.month(doi));  # last date in 3 month timespan - used function to determine 3rd month
    MonthEnd <- MonthEnd[3,1]-2 # specifies end of month 3 as last date
    # (technically specifies 01 of month 4)
    
    # row numbers corresponding with start and end dates, as a number. See note below 
    MonthStart_Row <- min(as.numeric(which(as.Date(all_data$Date)==as.Date(MonthStart))))
    MonthEnd_Row <- max(as.numeric(which(as.Date(all_data$Date)==as.Date(MonthEnd))) )
    
    # Note: Counter column is used here to specify which row starts MonthStart and MonthEnd_Row.
    # When rows are pulled from year row numbers are also pulled, 
    # so a counter must be used for proper row numbers.
    Start_new <- as.numeric(min(which(year$Counter==MonthStart_Row)))
    End_new <- as.numeric(max(which(year$Counter==MonthEnd_Row)))
    
    # begin nested loop
    for (m in 1:12){
      month_time <- year[Start_new:End_new ,]         #extract data for 3 month timespan within year of interest
      avgmonth_scenario1 <- mean(month_time$`Scenario 1 Flow`)   # find average of scenario 1 flow for 3 months
      avgmonth_scenario2 <- mean(month_time$`Scenario 2 Flow`) # find average of scenario 2 flow for 3 months
      AvgMonthlyDifference[m,1] <- (avgmonth_scenario1 - avgmonth_scenario2)/ avgmonth_scenario1 * 100  # percent difference between scenarios
      
      MonthEnd<-as.Date(MonthEnd)
      MonthEnd<-MonthEnd+1
      MonthEndyear <- year(MonthEnd)   # Year associated with last month of extracted data 
      MonthEndmonth <- month(MonthEnd) # Month associated with last month of extracted data 
      
      # the next three lines are for the difference calculations -- stop on 1st of month 4 (31 of month 3)
      # Note: this DOES include the 1st of the next month in difference calculation
      # Put a control on what date the script advances by - if date is not 1st of month, reset it
      DateCheck <- as.Date(paste0(MonthEndyear,'-',MonthEndmonth,'-01'))
      if (MonthEnd != DateCheck)
        MonthEnd <- as.Date(paste0(MonthEndyear,'-', MonthEndmonth, '-01'))
      
      MonthEnd <- MonthEnd-1
      stopdate <- as.Date(MonthEnd)
      AvgMonthlyDifference[m,2] <- stopdate
      
      # Advance to next month or count
      MonthStart <- next.month(MonthStart)
      MonthEnd <- MonthEnd+1
      MonthEnd <- next.month(MonthEnd)
      MonthEnd <- MonthEnd-1
      StartMonth_Row <- min(which(as.Date(all_data$Date)==as.Date(MonthStart)) )
      StartMonth_Row <- as.numeric(StartMonth_Row)
      EndMonth_Row <- max(which(as.Date(all_data$Date)==as.Date(MonthEnd)) )
      EndMonth_Row <- as.numeric(EndMonth_Row)
      if (!(EndMonth_Row > 0)) {
        EndMonth_Row <- max(index(all_data$Date))
      }
      Start_new <- which(year$Counter==StartMonth_Row)
      End_new <- which(year$Counter==EndMonth_Row)
      m <- m + 1
    }
    
    Timespan_Difference[x:y, 1] <- AvgMonthlyDifference[,1] # save the difference entries from AvgMonthlyDifference
    Timespan_Difference[x:y, 2] <- AvgMonthlyDifference[,2] # save the dates 
    
    # advance Timespan_Difference for next run
    x <- x + 12  
    y <- y + 12
    
    YearStart <- as.Date(YearStart) + 365  # Advance 1 year
    YearEnd <- as.Date(YearEnd) + 365     # Advance 1 year & 2 months (from 10-01 to 11-30)
    
    # Put a control on what date the script advances by - if end date is not 11-30, reset it
    # - if begin date is not -10-01, reset it
    YearBeginyear <- year(YearStart)  # pull year of beginning year
    YearBeginCheck <- as.Date(paste0(YearBeginyear,'-10-01'))
    if (YearBeginyear != YearBeginCheck)     
      YearStart <- as.Date(paste0(YearBeginyear,'-10-01'))
    
    YearEndyear <- year(YearEnd)  # pull year of ending year
    YearEndCheck <- as.Date(paste0(YearEndyear,'-11-30'))
    if (YearEnd != YearEndCheck)     
      YearEnd <- as.Date(paste0(YearEndyear,'-11-30'))
    YearStart_Row <- min(which(as.Date(all_data$Date)== as.Date(YearStart)) )
    YearEnd_Row <- max(which(as.Date(all_data$Date) == as.Date(YearEnd)) )
    if (!(YearEnd_Row > 0)) {
      YearEnd_Row <- max(index(all_data$Date))
    }
    
    i <- i + 1
  }
  
  # This section of code will plot timeframes with high difference.
  # count the number of 3 month periods over 20% difference, plot the highest 3 periods.
  
  Timespan_Difference$Logic <- Timespan_Difference$Difference<=20 | Timespan_Difference$Difference>= -20
  less20 <- Timespan_Difference[Timespan_Difference$Logic=='TRUE',]
  HighDifference <- Timespan_Difference[order(abs(Timespan_Difference$Difference), decreasing = FALSE),]
  names(HighDifference)<-c('Difference', 'Date', 'Logic')
  
  # pull data for each of these 3 month segments.
  HighestDifferences <- HighDifference[1:3,]
  HighestDifferences$Date <- as.Date(HighestDifferences$Date)
  
  # initalize variables for loop
  differenceyear <- data.frame(matrix(nrow=1,ncol=6))
  differencedates <- data.frame(matrix(nrow=1, ncol=2))
  names(differenceyear)<- c('endyear', 'endmonth', 'enddate', 'startyear', 'startmonth', 'startdate')
  names(differencedates)<- c('start date row', 'end date row')
  storeplotdata1<- data.frame(matrix(nrow=1, ncol=4))
  names(storeplotdata1)<- c('Date', 'Scenario 1 Flow', 'Scenario 2 Flow', 'Counter')
  storeplotdata2<- data.frame(matrix(nrow=1, ncol=4))
  names(storeplotdata2)<- c('Date', 'Scenario 1 Flow', 'Scenario 2 Flow', 'Counter')
  storeplotdata3<- data.frame(matrix(nrow=1, ncol=4))
  names(storeplotdata3)<- c('Date', 'Scenario 1 Flow', 'Scenario 2 Flow', 'Counter')
  
  q <- 1
  
  for (q in 1:length(HighestDifferences)){
    differenceyear[q,1] <- year(HighestDifferences$Date[q])  # ending year
    differenceyear[q,2]<- month(HighestDifferences$Date[q]) + 1 # ending month
    differenceyear[q,4]<- year(HighestDifferences$Date[q]) #startyear
    differenceyear[q,5]<- month(HighestDifferences$Date[q])-2 #startmonth
    
    if (differenceyear[q,2] > 12) { # if end month is jan, must move year up
      differenceyear[q,4] <- differenceyear[q,1]
      differenceyear[q,1]<- differenceyear[q,1] + 1 # year for jan moves
      differenceyear[q,2] <- 1
    }else if (differenceyear[q,5] == -1) {
      differenceyear[q,4] <- differenceyear[q,4] - 1 # if january, go back a year and start november
      differenceyear[q,5] <- 11
    }else if (differenceyear[q,5] == 0) {
      differenceyear[q,4] <- differenceyear[q,4] - 1 # if january, go back a year and start november
      differenceyear[q,5] <- 12
    } else{
      differenceyear[q,1]<- differenceyear[q,1]  #endyear
      differenceyear[q,2]<- differenceyear[q,2]  #endmonth
      differenceyear[q,4]<- differenceyear[q,4]  #startyear
      differenceyear[q,5]<- differenceyear[q,5]  #startmonth
    }
    differenceyear[q,3]<- paste0(differenceyear[q,1], '-',differenceyear[q,2], '-01') #enddate
    differenceyear$enddate <- as.Date(differenceyear$enddate)
    differenceyear[q,6]<- as.Date(paste0(differenceyear[q,4], '-', differenceyear[q,5], '-01')) #startdate
    differenceyear$startdate <- as.Date(differenceyear$startdate)
    
    differencedates[q,1]<- as.character(differenceyear$startdate[q])
    differencedates[q,2]<- as.character(differenceyear$enddate[q]-1)
    differencedates[q,3]<- min(which(as.Date(all_data$Date)==as.Date(differencedates$`start date row`[q])))
    differencedates[q,4]<- max(which(as.Date(all_data$Date)==as.Date(differencedates$`end date row`[q])))
    
    plot1<-all_data[differencedates$V3[q]:differencedates$V4[q],]
    if (q==1){
      storeplotdata1<- plot1
    }else if(q==2){
      storeplotdata2<- plot1
    }else if(q==3){
      storeplotdata3<- plot1
    }
    q <- q+1
  }
  
  # # create and export 3 plots: \plot for info of row q
  
  difference1 <- signif(HighestDifferences$Difference[1], digits=3)     #Create difference variable to display on graph
  difference2 <- signif(HighestDifferences$Difference[2], digits=3)
  difference3 <- signif(HighestDifferences$Difference[3], digits=3)
  
  # CREATES OUTPUT MATRIX -------------------------------------------------------
  avg_scenario1 <- mean(all_data$"Scenario 1 Flow")
  avg_scenario2 <- mean(all_data$"Scenario 2 Flow")
  
  # also want to list the number of timespans that were over 20% difference.
  less20 <- signif(nrow(less20)/nrow(Timespan_Difference)*100, digits=3)
  OUTPUT_MATRIX_LESS <- matrix(c(avg_scenario1, avg_scenario2, less20), nrow=1, ncol=3)
  rownames(OUTPUT_MATRIX_LESS) = c("Flow")
  colnames(OUTPUT_MATRIX_LESS) = c('Scenario 1', 'Scenario 2', 'Difference<20 (%)')
  overall_difference <- signif((OUTPUT_MATRIX_LESS[1,1]-OUTPUT_MATRIX_LESS[1,2])/OUTPUT_MATRIX_LESS[1,1]*100, digits=3)
  OUTPUT_MATRIX_LESS <- matrix(c(less20, percent_difference[3,]), nrow=1, ncol=2)
  rownames(OUTPUT_MATRIX_LESS) = c("Percent")
  colnames(OUTPUT_MATRIX_LESS) = c('Difference < 20%', 'Overall Difference')
  
  OUTPUT_MATRIX_LESS <- signif(as.numeric(OUTPUT_MATRIX_LESS, digits = 2))
  OUTPUT_MATRIX_LESSsaver <- OUTPUT_MATRIX_LESS
  OUTPUT_MATRIX_LESS <- kable(format(OUTPUT_MATRIX_LESS, digits = 3))
  # plot for highest difference 
  # Max/min for y axis scaling
  max <- max(c(max(storeplotdata1$`Scenario 1 Flow`), max(storeplotdata1$`Scenario 2 Flow`)));
  min <- min(c(max(storeplotdata1$`Scenario 1 Flow`), max(storeplotdata1$`Scenario 2 Flow`)));
  xpos1 <- min(storeplotdata1$Date)+20
  xpos2 <- max(storeplotdata1$Date)-20
  
  # Creating and exporting plot
  df <- data.frame(as.Date(storeplotdata1$Date), storeplotdata1$`Scenario 1 Flow`, storeplotdata1$`Scenario 2 Flow`); 
  colnames(df) <- c('Date', 'Scenario1', 'Scenario2')
  options(scipen=5, width = 1400, height = 950)
  difference1plot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1, color=cn1), size=0.5) +
    geom_line(aes(y=Scenario2, color=cn2), size=0.5)+
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=14),
          axis.text=element_text(size=14, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    annotate("text", x=xpos1, y=1.05*max, label= paste0('Difference:', '',difference1, '', '%'), size=3)+
    annotate("text", x=xpos2, y=1.05*max, label= paste0('Date Range: ', '', 
                                                        min(storeplotdata1$Date),': ', max(storeplotdata1$Date)), size=3)+
    labs(y = "Flow (cfs)")
  outfile <- paste0(export_path,"fig11.png")
  ggsave(outfile, plot = difference1plot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 11: Smallest Difference Period saved at location ', outfile, sep = ''))
  
  # plot for second highest difference 
  # Max/min for y axis scaling
  max <- max(c(max(storeplotdata2$`Scenario 1 Flow`), max(storeplotdata2$`Scenario 2 Flow`)));
  min <- max(c(min(storeplotdata2$`Scenario 1 Flow`), max(storeplotdata2$`Scenario 2 Flow`)));
  xpos1 <- min(storeplotdata2$Date)+20
  xpos2 <- max(storeplotdata2$Date)-20
  
  # Creating and exporting plot
  df <- data.frame(as.Date(storeplotdata2$Date), storeplotdata2$`Scenario 1 Flow`, storeplotdata2$`Scenario 2 Flow`); 
  colnames(df) <- c('Date', 'Scenario1', 'Scenario2')
  options(scipen=5, width = 1400, height = 950)
  difference2plot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1, color=cn1), size=0.5) +
    geom_line(aes(y=Scenario2, color=cn2), size=0.5)+
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=14),
          axis.text=element_text(size=14, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    annotate("text", x=xpos1, y=1.05*max, label= paste0('Difference:', '',difference2, '', '%'), size=3)+
    annotate("text", x=xpos2, y=1.05*max, label= paste0('Date Range: ', '', 
                                                        min(storeplotdata2$Date),': ', max(storeplotdata2$Date)), size=3)+
    labs(y = "Flow (cfs)")
  outfile <- paste0(export_path,"fig12.png")
  ggsave(outfile, plot = difference2plot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 12: Second Smallest Difference Period saved at location ', outfile, sep = ''))
  
  # plot for third highest difference 
  # Max/min for y axis scaling
  max <- max(c(max(storeplotdata3$`Scenario 1 Flow`), max(storeplotdata3$`Scenario 2 Flow`)));
  min <- min(c(max(storeplotdata3$`Scenario 1 Flow`), max(storeplotdata3$`Scenario 2 Flow`)));
  xpos1 <- min(storeplotdata3$Date)+20
  xpos2 <- max(storeplotdata3$Date)-20
  
  # Creating and exporting plot
  df <- data.frame(as.Date(storeplotdata3$Date), storeplotdata3$`Scenario 1 Flow`, storeplotdata3$`Scenario 2 Flow`); 
  colnames(df) <- c('Date', 'Scenario1', 'Scenario2')
  options(scipen=5, width = 1400, height = 950)
  difference3plot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1, color=cn1), size=0.5) +
    geom_line(aes(y=Scenario2, color=cn2), size=0.5)+
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=14),
          axis.text=element_text(size=14, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    annotate("text", x=xpos1, y=1.05*max, label= paste0('Difference:', '',difference3, '', '%'), size=3)+
    annotate("text", x=xpos2, y=1.05*max, label= paste0('Date Range: ', '', 
                                                        min(storeplotdata3$Date),': ', max(storeplotdata3$Date)), size=3)+
    labs(y = "Flow (cfs)")
  
  outfile <- paste0(export_path,"fig13.png")
  ggsave(outfile, plot = difference3plot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 13: Third Smallest Difference Period saved at location ', outfile, sep = ''))
}

findDiffPeriodSQL <- function(all_data) {
  # an alternative using sqldf
  
  adata <- all_data
  names(adata) <- c('thisdate', 'Qa', 'Qb', 'idx')
  #adata$thisdate <- as.POSIXct(adata$thisdate)
  # we do this using R instead of sqlite because we were unable to figure out 
  # correct date syntax with these dates stored as numbers in R
  adata$thisyear <- year(adata$thisdate)
  diff90 <- sqldf(
    "select a.thisdate, a.thisyear,
      avg(b.Qa) as Qa, 
      avg(b.Qb) as Qb,
      count(b.Qb) as numdays,
      avg(b.Qb - b.Qa) as dQ,
      CASE WHEN avg(b.Qa) > 0 THEN (avg(b.Qb - b.Qa) / avg(b.Qa)) 
      ELSE NULL 
      END as dQ_pct
    from adata as a 
    left outer join adata as b 
    on (
      b.idx >= a.idx 
      and b.idx < a.idx + 90
    ) 
    group by a.thisdate 
    order by a.thisdate
    "
  )
  
  D90 <- sqldf(
    "select a.*
     from diff90 as a 
     left outer join (
       select max(abs(dQ_pct)) as dQ_pct from 
       diff90
     ) as b
     on (abs(a.dQ_pct) = b.dQ_pct)
     where abs(a.dQ_pct) = b.dQ_pct
    "
  )
  d90_year <- year(D90$thisdate[1])
  D90second <- sqldf(
    paste0("select a.* 
     from diff90 as a 
     left outer join (
       select max(abs(diff90.dQ_pct)) as dQ_pct 
       from diff90 
       WHERE diff90.thisyear <> ", d90_year,
           ") as b
     on (a.dQ_pct = b.dQ_pct)
     where abs(a.dQ_pct) = b.dQ_pct
    ")
  )
  
}

figs6to8.largest.diff.periods <- function(all_data, cn1='Scenario 1', cn2='Scenario 2', export_path = '/tmp/') {
  cn1 <- paste0('1: ', cn1)
  cn2 <- paste0('2: ', cn2)
  # This section will create a hydrograph that will zoom in on 3 month segments where difference is high
  # It does so for the top three highest difference periods
  
  # find the first date for which data is collected, (in date format)
  # and a date that is roughly one year and two months past the first date
  YearStart <- as.character(as.Date(all_data$Date[1]))     
  fixer <- as.numeric(which(all_data$Date == paste0((year(YearStart)+1),"-11-30")))
  fixer <- fixer[1] # in case we are sub-daily timestep
  YearEnd <- as.character(as.Date(all_data$Date[fixer]))
  
  # YearStart_Row and YearEnd_Row are the rows corresponding the the YearStart and YearEnd dates
  YearStart_Row <- as.numeric(min(which(all_data$Date==YearStart)) )
  YearEnd_Row <- as.numeric(max(which(all_data$Date==YearEnd)))
  
  # initalize dataframes and counters, assign names for dataframe columns
  #AvgMonthlyDifference: used within nested for loop to create a 1x12 matrix that holds 1 year of 3 month difference segments
  #Timespan_Difference: used in large loop to store values from AvgMonthlyDifference; holds entire timespan of 3 month difference segments
  AvgMonthlyDifference <- data.frame(matrix(nrow=1,ncol=1));  
  names(AvgMonthlyDifference)<-'Difference' 
  Timespan_Difference <- data.frame(matrix(nrow=1, ncol=1)); 
  names(Timespan_Difference)<-'Difference'
  i <- 1; # used for first for loop to advance a year
  x <- 1 # x and y used to advance dataframes
  y <- 12
  
  # start loops used for yearly and monthly data  -------------------------------------------------------------
  
  loop <- as.numeric(round(length(unique(all_data$Date) )/365, digits = 0))-1
  for (i in 1:loop){                                # run loop for an entire data series
    year <- all_data[YearStart_Row:YearEnd_Row,] # specify year: 10-01-year1 to 11-30-year2
    m <- 1                                        # counter for nested loop
    
    MonthStart <- YearStart  # first date for 3 month timespan                      
    doi <- as.Date(MonthStart) 
    doi <- doi + seq(0,365,31) 
    # doi= date of interest. dummy variable just to create the function next.month
    next.month <- function(doi) as.Date(as.yearmon(doi) + 1/12) +  as.numeric(as.Date(doi)-(as.Date(as.yearmon(doi))))
    
    #(re)initalize variables for the nested loop
    MonthEnd <-data.frame(next.month(doi));  # last date in 3 month timespan - used function to determine 3rd month
    MonthEnd <- MonthEnd[3,1]-2 # specifies end of month 3 as last date
    # (technically specifies 01 of month 4)
    
    # row numbers corresponding with start and end dates, as a number. See note below 
    MonthStart_Row <- min(as.numeric(which(as.Date(all_data$Date)==as.Date(MonthStart))))
    MonthEnd_Row <- max(as.numeric(which(as.Date(all_data$Date)==as.Date(MonthEnd))) )
    
    # Note: Counter column is used here to specify which row starts MonthStart and MonthEnd_Row.
    # When rows are pulled from year row numbers are also pulled, 
    # so a counter must be used for proper row numbers.
    Start_new <- as.numeric(min(which(year$Counter==MonthStart_Row)))
    End_new <- as.numeric(max(which(year$Counter==MonthEnd_Row)))
    
    # begin nested loop
    for (m in 1:12){
      month_time <- year[Start_new:End_new ,]         #extract data for 3 month timespan within year of interest
      avgmonth_scenario1 <- mean(month_time$`Scenario 1 Flow`)   # find average of scenario 1 flow for 3 months
      avgmonth_scenario2 <- mean(month_time$`Scenario 2 Flow`) # find average of scenario 2 flow for 3 months
      AvgMonthlyDifference[m,1] <- (avgmonth_scenario1 - avgmonth_scenario2)/ avgmonth_scenario1 * 100  # percent difference between scenarios
      
      MonthEnd<-as.Date(MonthEnd)
      MonthEnd<-MonthEnd+1
      MonthEndyear <- year(MonthEnd)   # Year associated with last month of extracted data 
      MonthEndmonth <- month(MonthEnd) # Month associated with last month of extracted data 
      
      # the next three lines are for the difference calculations -- stop on 1st of month 4 (31 of month 3)
      # Note: this DOES include the 1st of the next month in difference calculation
      # Put a control on what date the script advances by - if date is not 1st of month, reset it
      DateCheck <- as.Date(paste0(MonthEndyear,'-',MonthEndmonth,'-01'))
      if (MonthEnd != DateCheck)
        MonthEnd <- as.Date(paste0(MonthEndyear,'-', MonthEndmonth, '-01'))
      
      MonthEnd <- MonthEnd-1
      stopdate <- as.Date(MonthEnd)
      AvgMonthlyDifference[m,2] <- stopdate
      
      # Advance to next month or count
      MonthStart <- next.month(MonthStart)
      MonthEnd <- MonthEnd+1
      MonthEnd <- next.month(MonthEnd)
      MonthEnd <- MonthEnd-1
      StartMonth_Row <- min(which(as.Date(all_data$Date)==as.Date(MonthStart)) )
      StartMonth_Row <- as.numeric(StartMonth_Row)
      EndMonth_Row <- max(which(as.Date(all_data$Date)==as.Date(MonthEnd)) )
      EndMonth_Row <- as.numeric(EndMonth_Row)
      if (!(EndMonth_Row > 0)) {
        EndMonth_Row <- max(index(all_data$Date))
      }
      Start_new <- which(year$Counter==StartMonth_Row)
      End_new <- which(year$Counter==EndMonth_Row)
      m <- m + 1
    }
    
    Timespan_Difference[x:y, 1] <- AvgMonthlyDifference[,1] # save the difference entries from AvgMonthlyDifference
    Timespan_Difference[x:y, 2] <- AvgMonthlyDifference[,2] # save the dates 
    
    # advance Timespan_Difference for next run
    x <- x + 12  
    y <- y + 12
    
    YearStart <- as.Date(YearStart) + 365  # Advance 1 year
    YearEnd <- as.Date(YearEnd) + 365     # Advance 1 year & 2 months (from 10-01 to 11-30)
    
    # Put a control on what date the script advances by - if end date is not 11-30, reset it
    # - if begin date is not -10-01, reset it
    YearBeginyear <- year(YearStart)  # pull year of beginning year
    YearBeginCheck <- as.Date(paste0(YearBeginyear,'-10-01'))
    if (YearBeginyear != YearBeginCheck)     
      YearStart <- as.Date(paste0(YearBeginyear,'-10-01'))
    
    YearEndyear <- year(YearEnd)  # pull year of ending year
    YearEndCheck <- as.Date(paste0(YearEndyear,'-11-30'))
    if (YearEnd != YearEndCheck)     
      YearEnd <- as.Date(paste0(YearEndyear,'-11-30'))
    YearStart_Row <- min(which(as.Date(all_data$Date)== as.Date(YearStart)) )
    YearEnd_Row <- max(which(as.Date(all_data$Date) == as.Date(YearEnd)) )
    if (!(YearEnd_Row > 0)) {
      YearEnd_Row <- max(index(all_data$Date))
    }
    i <- i + 1
  }
  
  # This section of code will plot timeframes with high difference.
  # count the number of 3 month periods over 20% difference, plot the highest 3 periods.
  
  Timespan_Difference$Logic <- Timespan_Difference$Difference>=20 | Timespan_Difference$Difference<= -20
  over20 <- Timespan_Difference[Timespan_Difference$Logic=='TRUE',]
  HighDifference <- Timespan_Difference[order(abs(Timespan_Difference$Difference), decreasing = TRUE),]
  names(HighDifference)<-c('Difference', 'Date', 'Logic')
  
  # pull data for each of these 3 month segments.
  HighestDifferences <- HighDifference[1:3,]
  HighestDifferences$Date <- as.Date(HighestDifferences$Date)
  
  # initalize variables for loop
  differenceyear <- data.frame(matrix(nrow=1,ncol=6))
  differencedates <- data.frame(matrix(nrow=1, ncol=2))
  names(differenceyear)<- c('endyear', 'endmonth', 'enddate', 'startyear', 'startmonth', 'startdate')
  names(differencedates)<- c('start date row', 'end date row')
  storeplotdata1<- data.frame(matrix(nrow=1, ncol=4))
  names(storeplotdata1)<- c('Date', 'Scenario 1 Flow', 'Scenario 2 Flow', 'Counter')
  storeplotdata2<- data.frame(matrix(nrow=1, ncol=4))
  names(storeplotdata2)<- c('Date', 'Scenario 1 Flow', 'Scenario 2 Flow', 'Counter')
  storeplotdata3<- data.frame(matrix(nrow=1, ncol=4))
  names(storeplotdata3)<- c('Date', 'Scenario 1 Flow', 'Scenario 2 Flow', 'Counter')
  
  q <- 1
  
  for (q in 1:length(HighestDifferences)){
    differenceyear[q,1] <- year(HighestDifferences$Date[q])  # ending year
    differenceyear[q,2]<- month(HighestDifferences$Date[q]) + 1 # ending month
    differenceyear[q,4]<- year(HighestDifferences$Date[q]) #startyear
    differenceyear[q,5]<- month(HighestDifferences$Date[q])-2 #startmonth
    
    if (differenceyear[q,2] > 12) { # if end month is jan, must move year up
      differenceyear[q,4] <- differenceyear[q,1]
      differenceyear[q,1]<- differenceyear[q,1] + 1 # year for jan moves
      differenceyear[q,2] <- 1
    }else if (differenceyear[q,5] == -1) {
      differenceyear[q,4] <- differenceyear[q,4] - 1 # if january, go back a year and start november
      differenceyear[q,5] <- 11
    }else if (differenceyear[q,5] == 0) {
      differenceyear[q,4] <- differenceyear[q,4] - 1 # if january, go back a year and start november
      differenceyear[q,5] <- 12
    } else{
      differenceyear[q,1]<- differenceyear[q,1]  #endyear
      differenceyear[q,2]<- differenceyear[q,2]  #endmonth
      differenceyear[q,4]<- differenceyear[q,4]  #startyear
      differenceyear[q,5]<- differenceyear[q,5]  #startmonth
    }
    differenceyear[q,3]<- paste0(differenceyear[q,1], '-',differenceyear[q,2], '-01') #enddate
    differenceyear$enddate <- as.Date(differenceyear$enddate)
    differenceyear[q,6]<- as.Date(paste0(differenceyear[q,4], '-', differenceyear[q,5], '-01')) #startdate
    differenceyear$startdate <- as.Date(differenceyear$startdate)
    
    differencedates[q,1]<- as.character(differenceyear$startdate[q])
    differencedates[q,2]<- as.character(differenceyear$enddate[q]-1)
    differencedates[q,3]<- min(which(as.Date(all_data$Date)==as.Date(differencedates$`start date row`[q])))
    differencedates[q,4]<- max(which(as.Date(all_data$Date)==as.Date(differencedates$`end date row`[q])))
    
    plot1<-all_data[differencedates$V3[q]:differencedates$V4[q],]
    if (q==1){
      storeplotdata1<- plot1
    }else if(q==2){
      storeplotdata2<- plot1
    }else if(q==3){
      storeplotdata3<- plot1
    }
    q <- q+1
  }
  
  # # create and export 3 plots: \plot for info of row q
  
  difference1 <- signif(HighestDifferences$Difference[1], digits=3)     #Create difference variable to display on graph
  difference2 <- signif(HighestDifferences$Difference[2], digits=3)
  difference3 <- signif(HighestDifferences$Difference[3], digits=3)
  
  # CREATES OUTPUT MATRIX -------------------------------------------------------
  avg_scenario1 <- mean(all_data$"Scenario 1 Flow")
  avg_scenario2 <- mean(all_data$"Scenario 2 Flow")
  
  # also want to list the number of timespans that were over 20% difference.
  over20 <- signif(nrow(over20)/nrow(Timespan_Difference)*100, digits=3)
  OUTPUT_MATRIX <- matrix(c(avg_scenario1, avg_scenario2, over20), nrow=1, ncol=3)
  rownames(OUTPUT_MATRIX) = c("Flow")
  colnames(OUTPUT_MATRIX) = c('Scenario 1', 'Scenario 2', 'Difference>20 (%)')
  overall_difference <- signif((OUTPUT_MATRIX[1,1]-OUTPUT_MATRIX[1,2])/OUTPUT_MATRIX[1,1]*100, digits=3)
  OUTPUT_MATRIX <- matrix(c(over20, percent_difference[3,]), nrow=1, ncol=2)
  rownames(OUTPUT_MATRIX) = c("Percent")
  colnames(OUTPUT_MATRIX) = c('Difference > 20%', 'Overall Difference')
  
  OUTPUT_MATRIX <- signif(as.numeric(OUTPUT_MATRIX, digits = 2))
  OUTPUT_MATRIXsaver <- OUTPUT_MATRIX
  OUTPUT_MATRIX <- kable(format(OUTPUT_MATRIX, digits = 3))
  # plot for highest difference 
  # Max/min for y axis scaling
  max <- max(c(max(storeplotdata1$`Scenario 1 Flow`), max(storeplotdata1$`Scenario 2 Flow`)));
  min <- min(c(max(storeplotdata1$`Scenario 1 Flow`), max(storeplotdata1$`Scenario 2 Flow`)));
  xpos1 <- min(storeplotdata1$Date)+20
  xpos2 <- max(storeplotdata1$Date)-20
  
  # Creating and exporting plot
  df <- data.frame(as.Date(storeplotdata1$Date), storeplotdata1$`Scenario 1 Flow`, storeplotdata1$`Scenario 2 Flow`); 
  colnames(df) <- c('Date', 'Scenario1', 'Scenario2')
  options(scipen=5, width = 1400, height = 950)
  difference1plot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1, color=cn1), size=0.5) +
    geom_line(aes(y=Scenario2, color=cn2), size=0.5)+
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=14),
          axis.text=element_text(size=14, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    annotate("text", x=xpos1, y=1.05*max, label= paste0('Difference:', '',difference1, '', '%'), size=3)+
    annotate("text", x=xpos2, y=1.05*max, label= paste0('Date Range: ', '', 
                                                        min(storeplotdata1$Date),': ', max(storeplotdata1$Date)), size=3)+
    labs(y = "Flow (cfs)")
  outfile <- paste0(export_path,"fig6.png")
  ggsave(outfile, plot = difference1plot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 6: Highest Difference Period saved at location ', outfile, sep = ''))
  
  # plot for second highest difference 
  # Max/min for y axis scaling
  max <- max(c(max(storeplotdata2$`Scenario 1 Flow`), max(storeplotdata2$`Scenario 2 Flow`)));
  min <- min(c(max(storeplotdata2$`Scenario 1 Flow`), max(storeplotdata2$`Scenario 2 Flow`)));
  xpos1 <- min(storeplotdata2$Date)+20
  xpos2 <- max(storeplotdata2$Date)-20
  
  # Creating and exporting plot
  df <- data.frame(as.Date(storeplotdata2$Date), storeplotdata2$`Scenario 1 Flow`, storeplotdata2$`Scenario 2 Flow`); 
  colnames(df) <- c('Date', 'Scenario1', 'Scenario2')
  options(scipen=5, width = 1400, height = 950)
  difference2plot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1, color=cn1), size=0.5) +
    geom_line(aes(y=Scenario2, color=cn2), size=0.5)+
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=14),
          axis.text=element_text(size=14, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    annotate("text", x=xpos1, y=1.05*max, label= paste0('Difference:', '',difference2, '', '%'), size=3)+
    annotate("text", x=xpos2, y=1.05*max, label= paste0('Date Range: ', '', 
                                                        min(storeplotdata2$Date),': ', max(storeplotdata2$Date)), size=3)+
    labs(y = "Flow (cfs)")
  outfile <- paste0(export_path,"fig7.png")
  ggsave(outfile, plot = difference2plot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 7: Second Highest Difference Period saved at location ', outfile, sep = ''))
  
  # plot for third highest difference 
  # Max/min for y axis scaling
  max <- max(c(max(storeplotdata3$`Scenario 1 Flow`), max(storeplotdata3$`Scenario 2 Flow`)));
  min <- min(c(max(storeplotdata3$`Scenario 1 Flow`), max(storeplotdata3$`Scenario 2 Flow`)));
  xpos1 <- min(storeplotdata3$Date)+20
  xpos2 <- max(storeplotdata3$Date)-20
  
  # Creating and exporting plot
  df <- data.frame(as.Date(storeplotdata3$Date), storeplotdata3$`Scenario 1 Flow`, storeplotdata3$`Scenario 2 Flow`); 
  colnames(df) <- c('Date', 'Scenario1', 'Scenario2')
  options(scipen=5, width = 1400, height = 950)
  difference3plot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1, color=cn1), size=0.5) +
    geom_line(aes(y=Scenario2, color=cn2), size=0.5)+
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=14),
          axis.text=element_text(size=14, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    annotate("text", x=xpos1, y=1.05*max, label= paste0('Difference:', '',difference3, '', '%'), size=3)+
    annotate("text", x=xpos2, y=1.05*max, label= paste0('Date Range: ', '', 
                                                        min(storeplotdata3$Date),': ', max(storeplotdata3$Date)), size=3)+
    labs(y = "Flow (cfs)")
  
  outfile <- paste0(export_path,"fig8.png")
  ggsave(outfile, plot = difference3plot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 8: Third Highest Difference Period saved at location ', outfile, sep = ''))
  return(OUTPUT_MATRIXsaver)
}

tab6.nonexceedence.flows <- function(percent_difference, cn1='Scenario 1', cn2='Scenario 2') {
  # Table 6: Non-Exceedance Flows
  Table6 <- matrix(c(percent_difference[1,62], percent_difference[1,63], percent_difference[1,64],percent_difference[1,65], percent_difference[1,66], percent_difference[1,61],percent_difference[2,62], percent_difference[2,63], percent_difference[2,64],percent_difference[2,65], percent_difference[2,66], percent_difference[2,61],percent_difference[3,62], percent_difference[3,63], percent_difference[3,64],percent_difference[3,65], percent_difference[3,66], percent_difference[3,61]), 
                   nrow = 6, ncol = 3);
  colnames(Table6) = c(cn1, cn2, "Pct. Difference");
  rownames(Table6) = c("1% Non-Exceedance", "5% Non-Exceedance",
                       "50% Non-Exceedance", "95% Non-Exceedance",
                       "99% Non-Exceedance", "Sept. 10% Non-Exceedance");
  Table6 <- signif(Table6, digits = 3)
  Table6 <- round(Table6, digits = 2)
  Table6 <- kable(format(Table6, digits = 3, drop0trailing = TRUE))
  return(Table6)
}

tab5.period.high.flows <- function(percent_difference, cn1='Scenario 1', cn2='Scenario 2') {
  # Table 5: Period High Flows
  Table5 <- matrix(c(percent_difference[1,48], percent_difference[1,53],
                     percent_difference[1,49], percent_difference[1,54],
                     percent_difference[1,50], percent_difference[1,55],
                     percent_difference[1,51], percent_difference[1,56],
                     percent_difference[1,52], percent_difference[1,57],
                     percent_difference[2,48], percent_difference[2,53],
                     percent_difference[2,49], percent_difference[2,54],
                     percent_difference[2,50], percent_difference[2,55],
                     percent_difference[2,51], percent_difference[2,56],
                     percent_difference[2,52], percent_difference[2,57],
                     percent_difference[3,48], percent_difference[3,53],
                     percent_difference[3,49], percent_difference[3,54],
                     percent_difference[3,50], percent_difference[3,55],
                     percent_difference[3,51], percent_difference[3,56],
                     percent_difference[3,52], percent_difference[3,57]), 
                   nrow = 10, ncol = 3);
  colnames(Table5) = c(cn1, cn2, "Pct. Difference");
  rownames(Table5) = c("Max. 1 Day Max", "Med. 1 Day Max", 
                       "Max. 3 Day Max", "Med. 3 Day Max",
                       "Max. 7 Day Max", "Med. 7 Day Max",
                       "Max. 30 Day Max", "Med. 30 Day Max",
                       "Max. 90 Day Max", "Med. 90 Day Max");
  Table5 <- signif(Table5, digits = 3)
  Table5 <- round(Table5, digits = 2)
  Table5 <- kable(format(Table5, digits = 3, drop0trailing = TRUE))
  return(Table5)
}

tab4.period.low.flows <- function(percent_difference, cn1='Scenario 1', cn2='Scenario 2') {
  # Table 4: Period Low Flows
  Table4 <- matrix(c(signif(percent_difference[1,38], 3), signif(percent_difference[1,43], 3),
                     signif(percent_difference[1,39], 3), signif(percent_difference[1,44], 3),
                     signif(percent_difference[1,40], 3), signif(percent_difference[1,45], 3),
                     signif(percent_difference[1,41], 3), signif(percent_difference[1,46], 3),
                     signif(percent_difference[1,42], 3), signif(percent_difference[1,47], 3),
                     signif(percent_difference[1,59], 3), signif(percent_difference[1,60], 4),
                     signif(percent_difference[1,58], 3), signif(percent_difference[1,67], 3), 
                     signif(percent_difference[2,38], 3), signif(percent_difference[2,43], 3),
                     signif(percent_difference[2,39], 3), signif(percent_difference[2,44], 3),
                     signif(percent_difference[2,40], 3), signif(percent_difference[2,45], 3),
                     signif(percent_difference[2,41], 3), signif(percent_difference[2,46], 3),
                     signif(percent_difference[2,42], 3), signif(percent_difference[2,47], 3),
                     signif(percent_difference[2,59], 3), signif(percent_difference[2,60], 4),
                     signif(percent_difference[2,58], 3), signif(percent_difference[2,67], 3),
                     signif(percent_difference[3,38], 3), signif(percent_difference[3,43], 3),
                     signif(percent_difference[3,39], 3), signif(percent_difference[3,44], 3),
                     signif(percent_difference[3,40], 3), signif(percent_difference[3,45], 3),
                     signif(percent_difference[3,41], 3), signif(percent_difference[3,46], 3),
                     signif(percent_difference[3,42], 3), signif(percent_difference[3,47], 3),
                     signif(percent_difference[3,59], 3), signif(percent_difference[3,60], 3),
                     signif(percent_difference[3,58], 3), signif(percent_difference[3,67], 3)), 
                   nrow = 14, ncol = 3);
  colnames(Table4) = c(cn1, cn2, "Pct. Difference");
  rownames(Table4) = c("Min. 1 Day Min", "Med. 1 Day Min", 
                       "Min. 3 Day Min", "Med. 3 Day Min",
                       "Min. 7 Day Min", "Med. 7 Day Min",
                       "Min. 30 Day Min", "Med. 30 Day Min",
                       "Min. 90 Day Min", "Med. 90 Day Min", 
                       "7Q10", "Year of 90-Day Min. Flow",
                       "Drought Year Mean", "Mean Baseflow");
  #Table4 <- signif(Table4, digits = 3)
  Table4 <- round(Table4, digits = 2)
  Table4 <- kable(format(Table4, digits = 4, drop0trailing = TRUE))
  return(Table4)
}

tab3.monthly.high.flows <- function(percent_difference, cn1='Scenario 1', cn2='Scenario 2') {
  # Table 3: Monthly High Flow
  Table3 <- matrix(c(percent_difference[1,26], percent_difference[1,27], percent_difference[1,28],percent_difference[1,29], percent_difference[1,30], percent_difference[1,31],percent_difference[1,32], percent_difference[1,33], percent_difference[1,34],percent_difference[1,35], percent_difference[1,36], percent_difference[1,37],percent_difference[2,26],percent_difference[2,27], percent_difference[2,28], percent_difference[2,29],percent_difference[2,30], percent_difference[2,31], percent_difference[2,32],percent_difference[2,33], percent_difference[2,34], percent_difference[2,35],percent_difference[2,36], percent_difference[2,37],percent_difference[3,26], percent_difference[3,27], percent_difference[3,28],percent_difference[3,29], percent_difference[3,30], percent_difference[3,31],percent_difference[3,32], percent_difference[3,33], percent_difference[3,34],percent_difference[3,35], percent_difference[3,36], percent_difference[3,37]),
                   nrow = 12, ncol = 3);
  colnames(Table3) = c(cn1, cn2, "Pct. Difference");
  rownames(Table3) = c("Jan. High Flow", "Feb. High Flow",
                       "Mar. High Flow", "Apr. High Flow",
                       "May High Flow", "Jun. High Flow",
                       "Jul. High Flow", "Aug. High Flow",
                       "Sep. High Flow", "Oct. High Flow",
                       "Nov. High Flow", "Dec. High Flow");
  Table3 <- signif(Table3, digits = 3)
  Table3 <- round(Table3, digits = 2)
  Table3 <- kable(format(Table3, digits = 3, drop0trailing = TRUE))
  return(Table3)
}

tab2.monthly.average.flows <- function(percent_difference, cn1='Scenario 1', cn2='Scenario 2') {
  # Table 2: Monthly Average Flow
  Table2 <- matrix(c(percent_difference[1,1], percent_difference[1,14], percent_difference[1,15], percent_difference[1,16], percent_difference[1,17], percent_difference[1,18], percent_difference[1,19], percent_difference[1,20], percent_difference[1,21], percent_difference[1,22], percent_difference[1,23], percent_difference[1,24], percent_difference[1,25], percent_difference[2,1], percent_difference[2,14], percent_difference[2,15], percent_difference[2,16], percent_difference[2,17], percent_difference[2,18], percent_difference[2,19], percent_difference[2,20], percent_difference[2,21], percent_difference[2,22], percent_difference[2,23], percent_difference[2,24], percent_difference[2,25], percent_difference[3,1], percent_difference[3,14], percent_difference[3,15], percent_difference[3,16], percent_difference[3,17], percent_difference[3,18], percent_difference[3,19], percent_difference[3,20], percent_difference[3,21], percent_difference[3,22], percent_difference[3,23], percent_difference[3,24], percent_difference[3,25]),
                   nrow = 13, ncol = 3);
  colnames(Table2) = c(cn1, cn2, "Pct. Difference");
  rownames(Table2) = c("Overall Mean Flow", 
                       "Jan. Mean Flow", "Feb. Mean Flow",
                       "Mar. Mean Flow", "Apr. Mean Flow",
                       "May Mean Flow", "Jun. Mean Flow",
                       "Jul. Mean Flow", "Aug. Mean Flow",
                       "Sep. Mean Flow", "Oct. Mean Flow",
                       "Nov. Mean Flow", "Dec. Mean Flow");
  Table2 <- signif(Table2, digits = 3)
  Table2 <- round(Table2, digits = 2)
  Table2 <- kable(format(Table2, digits = 3, drop0trailing = TRUE))
  return(Table2)
}

tab1.monthly.low.flows <- function(percent_difference, cn1='Scenario 1', cn2='Scenario 2') {
  # Table 1: Monthly Low Flow
  Table1 <- matrix(c(percent_difference[1,2], percent_difference[1,3],
                     percent_difference[1,4], percent_difference[1,5], percent_difference[1,6],
                     percent_difference[1,7], percent_difference[1,8], percent_difference[1,9],
                     percent_difference[1,10], percent_difference[1,11], percent_difference[1,12],
                     percent_difference[1,13], percent_difference[2,2],
                     percent_difference[2,3], percent_difference[2,4], percent_difference[2,5],
                     percent_difference[2,6], percent_difference[2,7], percent_difference[2,8],
                     percent_difference[2,9], percent_difference[2,10], percent_difference[2,11],
                     percent_difference[2,12], percent_difference[2,13], 
                     percent_difference[3,2], percent_difference[3,3], percent_difference[3,4],
                     percent_difference[3,5], percent_difference[3,6], percent_difference[3,7],
                     percent_difference[3,8], percent_difference[3,9], percent_difference[3,10],
                     percent_difference[3,11], percent_difference[3,12], percent_difference[3,13]),
                   nrow = 12, ncol = 3);
  colnames(Table1) = c(cn1, cn2, "Pct. Difference");
  rownames(Table1) = c("Jan. Low Flow", "Feb. Low Flow",
                       "Mar. Low Flow", "Apr. Low Flow",
                       "May Low Flow", "Jun. Low Flow",
                       "Jul. Low Flow", "Aug. Low Flow",
                       "Sep. Low Flow", "Oct. Low Flow",
                       "Nov. Low Flow", "Dec. Low Flow");
  Table1 <- signif(Table1, digits = 3)
  Table1 <- round(Table1, digits = 2)
  Table1 <- kable(format(Table1, digits = 3, drop0trailing = TRUE))
  return(Table1)
}

fig.gis <- function(riv.seg, site_number, site_url, cbp6_link, token, export_path = '/tmp/') {
  # Generating gage location maps
  gis_img <- fn_gage_and_seg_mapperALT(riv.seg, site_number, site_url, cbp6_link, token)
  outfile <- paste0(export_path,"gis.png")
  ggsave(outfile, plot = gis_img, device = 'png', width = 8, height = 5.5, units = 'in')
}

all_data_maker <- function(data1, data2) {
  #all_data puts scenario flows and corresponding dates in one data frame
  all_data <- full_join(data1, data2, by = 'date')
  all_data <- all_data[order(as.Date(all_data$date)),]
  all_data$counter <- 1:length(all_data$date) # counter fixes issues with row numbers later on in script
  colnames(all_data) <- c('Date', 'Scenario 1 Flow', 'Scenario 2 Flow', 'Counter')
  return(all_data)
}

fig10.runit.boxplot <- function(lri.dat, export_path = '/tmp/') {
  boxplot(as.numeric(lri.dat$flow.unit) ~ year(lri.dat$date), outline = FALSE, ylab = 'Runit Flow (cfs)', xlab = 'Date')
  outfile <- paste0(export_path,"fig10.png")
  dev.copy(png, outfile)
  dev.off()
  print(paste('Fig. 10: Runit Boxplot saved at location ', outfile, sep = ''))
}


fig9b.area.weighted.residual.plot <- function(all_data, riv.seg, token, site_url, cn1='Scenario 1', cn2='Scenario 2', export_path = '/tmp/') {
  
  hydrocode = paste("vahydrosw_wshed_",riv.seg,sep="");
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list (
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site_url, feature);
  hydroid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name );
  print(paste("Retrieved hydroid",hydroid,"for", fname,riv.seg, sep=' '));
  
  # Getting the local drainage area feature
  areainfo <- list(
    varkey = "wshed_drainage_area_sqmi",
    featureid = as.integer(as.character(hydroid)),
    entity_type = "dh_feature"
  )
  
  model.area <- getPropertyALT(areainfo, site_url, model.area, token)
  area <- model.area$propvalue
  area <- area*27878400 #sq ft
  
  # Setup for Residuals
  data <- all_data[complete.cases(all_data),]
  #data_weighted <- data/area
  resid <- 1000000*((data$`Scenario 2 Flow` - data$`Scenario 1 Flow`)/area)
  resid <- data.frame(data$Date, resid)
  
  # Residuals plot for hydrograph
  zeroline <- rep_len(0, length(data$Date))
  quantresid <- data.frame(signif(quantile(resid$resid, na.rm =TRUE), digits=3))
  min <- min(resid$resid)
  max <- max(resid$resid)
  names(quantresid) <- c('Percentiles')
  
  namer <- paste0('Residual (', cn2, ' - ', cn1, ')')
  
  df <- data.frame(as.Date(resid$data.Date), resid$resid, zeroline);
  colnames(df) <- c('Date', 'Residual', 'Zeroline')
  options(scipen=5, width = 1400, height = 950)
  myplot <- ggplot(df, aes(x=Date)) +
    geom_point(aes(y=Residual, color=namer), size=1) +
    geom_line(aes(y=Zeroline, color="Zeroline"), size=0.8)+
    scale_y_continuous(limits=c(min,max))+
    theme_bw()+
    theme(legend.position="top",
          legend.title=element_blank(),
          legend.box = "horizontal",
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid",
                                           colour ="white"),
          legend.text=element_text(size=12),
          axis.text=element_text(size=12, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black",
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"),
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("dark green","black"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    labs(y = "Area Weighted Flow Difference*10^6 (ft/s)")
  outfile <- paste0(export_path,"fig9B.png")
  ggsave(outfile, plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 9b: Area-Weighted Residual Plot saved at location ', outfile, sep = ''))
}

fig9a.residual.plot <- function(all_data, cn1='Scenario 1', cn2='Scenario 2', export_path = '/tmp/') {
  
  # Setup for Residuals
  data <- all_data[complete.cases(all_data),]
  resid <- (data$`Scenario 2 Flow` - data$`Scenario 1 Flow`)
  resid <- data.frame(data$Date, resid)
  
  # Residuals plot for hydrograph
  
  zeroline <- rep_len(0, length(data$Date)) 
  quantresid <- data.frame(signif(quantile(resid$resid, na.rm = TRUE), digits=3))
  min <- min(resid$resid)
  max <- max(resid$resid)
  names(quantresid) <- c('Percentiles')
  
  namer <- paste0('Residual (', cn2, ' - ', cn1, ')')
  
  df <- data.frame(as.Date(resid$data.Date), resid$resid, zeroline); 
  colnames(df) <- c('Date', 'Residual', 'Zeroline')
  options(scipen=5, width = 1400, height = 950)
  myplot <- ggplot(df, aes(x=Date)) + 
    geom_point(aes(y=Residual, color=namer), size=1) +
    geom_line(aes(y=Zeroline, color="Zeroline"), size=0.8)+
    scale_y_continuous(limits=c(min,max))+ 
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=12),
          axis.text=element_text(size=12, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("dark green","black"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    labs(y = "Flow Difference (cfs)")
  outfile <- paste0(export_path,"fig9A.png")
  ggsave(outfile, plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 9a: Residual Plot saved at location ', outfile, sep = ''))
}

fig5.combined.hydrograph <- function(all_data, export_path = '/tmp/') {
  data1 <- all_data[,c('Date','Scenario 1 Flow')]
  names(data1) <- c('date', 'flow')
  data2 <- all_data[,c('Date','Scenario 2 Flow')]
  names(data2) <- c('date', 'flow')
  data1$year <- year(ymd(data1$date))
  data1$month <- month(ymd(data1$date))
  data1$day <- day(ymd(data1$date))
  data2$year <- year(ymd(data2$date))
  data2$month <- month(ymd(data2$date))
  data2$day <- day(ymd(data2$date))
  
  
  scenario1river <- createlfobj(data1, hyearstart = 10, baseflow = TRUE, meta = NULL)
  scenario2river <- createlfobj(data2, hyearstart = 10, baseflow = TRUE, meta = NULL)
  baseflowriver<- data.frame(scenario1river, scenario2river);
  colnames(baseflowriver) <-c ('mday', 'mmonth', 'myear', 'mflow', 'mHyear', 'mBaseflow',
                               'gday', 'gmonth', 'gyear', 'gflow', 'gHyear', 'gBaseflow')
  
  # removing NA values
  baseflowriver<-baseflowriver[complete.cases(baseflowriver)==TRUE,]
  scenario2river<- data.frame(baseflowriver$gday, baseflowriver$gmonth, baseflowriver$gyear, 
                              baseflowriver$gflow, baseflowriver$gHyear, baseflowriver$gBaseflow);
  scenario1river<- data.frame(baseflowriver$mday, baseflowriver$mmonth, baseflowriver$myear, 
                              baseflowriver$mflow, baseflowriver$mHyear, baseflowriver$mBaseflow)
  names(scenario1river) <- c('day', 'month', 'year', 'flow', 'hyear', 'baseflow')
  names(scenario2river) <- c('day', 'month', 'year', 'flow', 'hyear', 'baseflow')
  # Adding date vectors
  scenario1river$date <- as.Date(paste0(scenario1river$year,"-",scenario1river$month,"-",scenario1river$day))
  scenario2river$date <- as.Date(paste0(scenario2river$year,"-",scenario2river$month,"-",scenario2river$day))
  
  # Determining max flow value for plot scale
  max <- max(c(max(scenario1river$baseflow), max(scenario2river$baseflow), max(scenario1river$flow), max(scenario2river$flow)), na.rm = TRUE);
  min <- min(c(min(scenario1river$baseflow), min(scenario2river$baseflow), min(scenario1river$flow), min(scenario2river$flow)), na.rm = TRUE);
  
  if (max > 10000){
    max <- 100000
  }else if (max > 1000){
    max <- 10000
  }else if (max > 100){
    max <- 1000
  }else if (max > 10){
    max <- 100
  }
  if (min>100){
    min<-100
  }else if (min>10){ 
    min<-10
  }else 
    min<-1
  if (min==100){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(100, 1000, 10000, 100000), 
                                      limits=c(min,max))
  }else if (min==10){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(10, 100, 1000, 10000), 
                                      limits=c(min,max))
  }else if (min==1){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(1, 10, 100, 1000, 10000), 
                                      limits=c(min,max))
  }else
    fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                      labels=scaleFUN, limits=c(min,max))
  
  df <- data.frame(as.Date(scenario1river$date), scenario1river$baseflow, scenario2river$baseflow, scenario1river$flow, scenario2river$flow); 
  colnames(df) <- c('Date', 'Scenario1Baseflow', 'Scenario2Baseflow','Scenario1Flow', 'Scenario2Flow')
  
  par(mfrow = c(1,1));
  options(scipen=5, width = 1400, height = 950)
  myplot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1Flow, color=paste("Scen. 1 Flow")), size=1)+
    geom_line(aes(y=Scenario2Flow, color=paste("Scen. 2 Flow")), size=0.5)+ 
    geom_line(aes(y=Scenario1Baseflow, color=paste("Scen. 1 Baseflow")), size=0.5) +
    geom_line(aes(y=Scenario2Baseflow, color=paste("Scen. 2 Baseflow")), size=1)+
    fixtheyscale+ 
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=12),
          axis.text=element_text(size=12, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red","grey", "light pink"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    labs(y = "Flow (cfs)")
  outfile <- paste0(export_path,"fig5.png")
  ggsave(outfile, plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 5: Combined Hydrograph saved at location ', outfile, sep = ''))
}

fig4.baseflow.hydrograph <- function(all_data, cn1='Scenario 1', cn2='Scenario 2', export_path = '/tmp/') {
  cn1 <- paste0('1: ', cn1)
  cn2 <- paste0('2: ', cn2)
  
  # Baseflow Indiviuda[l Graph -----
  data1 <- all_data[,c('Date','Scenario 1 Flow')]
  names(data1) <- c('date', 'flow')
  data2 <- all_data[,c('Date','Scenario 2 Flow')]
  names(data2) <- c('date', 'flow')
  
  data1$year <- year(ymd(data1$date))
  data1$month <- month(ymd(data1$date))
  data1$day <- day(ymd(data1$date))
  data2$year <- year(ymd(data2$date))
  data2$month <- month(ymd(data2$date))
  data2$day <- day(ymd(data2$date))
  
  
  scenario1river <- createlfobj(data1, hyearstart = 10, baseflow = TRUE, meta = NULL)
  scenario2river <- createlfobj(data2, hyearstart = 10, baseflow = TRUE, meta = NULL)
  baseflowriver<- data.frame(scenario1river, scenario2river);
  colnames(baseflowriver) <-c ('mday', 'mmonth', 'myear', 'mflow', 'mHyear', 'mBaseflow',
                               'gday', 'gmonth', 'gyear', 'gflow', 'gHyear', 'gBaseflow')
  
  # removing NA values
  baseflowriver<-baseflowriver[complete.cases(baseflowriver)==TRUE,]
  scenario2river<- data.frame(baseflowriver$gday, baseflowriver$gmonth, baseflowriver$gyear, 
                              baseflowriver$gflow, baseflowriver$gHyear, baseflowriver$gBaseflow);
  scenario1river<- data.frame(baseflowriver$mday, baseflowriver$mmonth, baseflowriver$myear, 
                              baseflowriver$mflow, baseflowriver$mHyear, baseflowriver$mBaseflow)
  names(scenario1river) <- c('day', 'month', 'year', 'flow', 'hyear', 'baseflow')
  names(scenario2river) <- c('day', 'month', 'year', 'flow', 'hyear', 'baseflow')
  # Adding date vectors
  scenario1river$date <- as.Date(paste0(scenario1river$year,"-",scenario1river$month,"-",scenario1river$day))
  scenario2river$date <- as.Date(paste0(scenario2river$year,"-",scenario2river$month,"-",scenario2river$day))
  
  # Determining max flow value for plot scale
  max <- max(c(max(scenario1river$baseflow), max(scenario2river$baseflow), max(scenario1river$flow), max(scenario2river$flow)), na.rm = TRUE);
  min <- min(c(min(scenario1river$baseflow), min(scenario2river$baseflow), min(scenario1river$flow), min(scenario2river$flow)), na.rm = TRUE);
  
  if (max > 10000){
    max <- 100000
  }else if (max > 1000){
    max <- 10000
  }else if (max > 100){
    max <- 1000
  }else if (max > 10){
    max <- 100
  }
  if (min>100){
    min<-100
  }else if (min>10){ 
    min<-10
  }else 
    min<-1
  if (min==100){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(100, 1000, 10000, 100000), 
                                      limits=c(min,max))
  }else if (min==10){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(10, 100, 1000, 10000), 
                                      limits=c(min,max))
  }else if (min==1){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(1, 10, 100, 1000, 10000), 
                                      limits=c(min,max))
  }else
    fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                      labels=scaleFUN, limits=c(min,max))
  df <- data.frame(as.Date(scenario1river$date), scenario1river$baseflow, scenario2river$baseflow, scenario1river$flow, scenario2river$flow); 
  colnames(df) <- c('Date', 'Scenario1Baseflow', 'Scenario2Baseflow','Scenario1Flow', 'Scenario2Flow')
  options(scipen=5, width = 1400, height = 950)
  myplot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1Baseflow, color=cn1), size=0.5) +
    geom_line(aes(y=Scenario2Baseflow, color=cn2), size=0.5)+
    fixtheyscale+ 
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=12),
          axis.text=element_text(size=12, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    labs(y = "Flow (cfs)")
  outfile <- paste0(export_path,"fig4.png")
  ggsave(outfile, plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 4: Baseflow Hydrograph saved at location ', outfile, sep = ''))
}

fig3.flow.exceedance <- function(all_data, cn1='Scenario 1', cn2='Scenario 2', export_path = '/tmp/') {
  cn1 <- paste0('1: ', cn1)
  cn2 <- paste0('2: ', cn2)
  #Flow exceedance plot -----
  
  # Determining the "rank" (0-1) of the flow value
  num_observations <- as.numeric(length(all_data$Date))
  rank_vec <- as.numeric(c(1:num_observations))
  # Calculating exceedance probability
  prob_exceedance <- 100*((rank_vec) / (num_observations + 1))
  
  exceed_scenario1 <- sort(all_data$`Scenario 1 Flow`, decreasing = TRUE, na.last = TRUE)
  exceed_scenario2 <- sort(all_data$`Scenario 2 Flow`, decreasing = TRUE, na.last = TRUE)
  
  scenario1_exceedance <- quantile(exceed_scenario1, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
  scenario2_exceedance <- quantile(exceed_scenario2, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
  
  # Determining max flow value for exceedance plot scale
  max <- max(c(max(scenario1_exceedance), max(scenario2_exceedance)), na.rm = TRUE);
  min <- min(c(min(scenario1_exceedance), min(scenario2_exceedance)), na.rm = TRUE);
  
  if (max > 10000){
    max <- 100000
  }else if (max > 1000){
    max <- 10000
  }else if (max > 100){
    max <- 1000
  }else if (max > 10){
    max <- 100
  }
  if (min>100){
    min<-100
  }else if (min>10){ 
    min<-10
  }else 
    min<-1
  if (min==100){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(100, 1000, 10000, 100000), 
                                      limits=c(min,max))
  }else if (min==10){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(10, 100, 1000, 10000), 
                                      limits=c(min,max))
  }else if (min==1){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(1, 10, 100, 1000, 10000), 
                                      limits=c(min,max))
  }else
    fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                      labels=scaleFUN, limits=c(min,max))
  df <- data.frame(prob_exceedance, exceed_scenario1, exceed_scenario2); 
  colnames(df) <- c('Date', 'Scenario1', 'Scenario2')
  options(scipen=5, width = 1400, height = 950)
  myplot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1, color=cn1), size=0.5) +
    geom_line(aes(y=Scenario2, color=cn2), size=0.5)+
    fixtheyscale+ 
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=12),
          axis.text=element_text(size=12, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    labs(x= "Probability of Exceedance (%)", y = "Flow (cfs)")
  outfile <- paste0(export_path,"fig3.png")
  ggsave(outfile, plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 3: Flow Exceedance saved at location ', outfile, sep = ''))
}

fig2.zoomed.hydrograph <- function(all_data, cn1='Scenario 1', cn2='Scenario 2', export_path = '/tmp/') {
  cn1 <- paste0('1: ', cn1)
  cn2 <- paste0('2: ', cn2)
  # Zoomed hydrograph in year of lowest 90-year flow -----
  # Running scenario 1 calculations
  f3_scenario1 <- zoo(all_data$`Scenario 1 Flow`, order.by = all_data$Date)
  g2_scenario1 <- group2(f3_scenario1, year = 'water')
  # Running scenairo 2 calculations
  f3_scenario2 <- zoo(all_data$`Scenario 2 Flow`, order.by = all_data$Date)
  g2_scenario2 <- group2(f3_scenario2, year = 'water')
  
  yearly_scenario1_90DayMin <- g2_scenario1[,c(1,10)];
  yearly_scenario2_90DayMin <- g2_scenario2[,c(1,10)];
  low.year <- subset(yearly_scenario1_90DayMin, yearly_scenario1_90DayMin$`90 Day Min`==min(yearly_scenario1_90DayMin$`90 Day Min`));
  low.year <- low.year$year;
  low.year <- subset(all_data, year(all_data$Date)==low.year);
  
  # Scaling using max/min
  max <- max(c(max(low.year$`Scenario 1 Flow`), max(low.year$`Scenario 2 Flow`)), na.rm = TRUE);
  min <- min(c(min(low.year$`Scenario 1 Flow`), min(low.year$`Scenario 2 Flow`)), na.rm = TRUE);
  if (max > 10000){
    max <- 100000
  }else if (max > 1000){
    max <- 10000
  }else if (max > 100){
    max <- 1000
  }else if (max > 10){
    max <- 100
  }
  if (min>100){
    min<-100
  }else if (min>10){ 
    min<-10
  }else 
    min<-1
  if (min==100){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(100, 1000, 10000, 100000), 
                                      limits=c(min,max))
  }else if (min==10){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(10, 100, 1000, 10000), 
                                      limits=c(min,max))
  }else if (min==1){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(1, 10, 100, 1000, 10000), 
                                      limits=c(min,max))
  }else
    fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                      labels=scaleFUN, limits=c(min,max))
  df <- data.frame(as.Date(low.year$Date), low.year$`Scenario 1 Flow`, low.year$`Scenario 2 Flow`); 
  colnames(df) <- c('Date', 'Scenario1', 'Scenario2')
  options(scipen=5, width = 1400, height = 950)
  myplot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1, color=cn1), size=0.5) +
    geom_line(aes(y=Scenario2, color=cn2), size=0.5)+
    fixtheyscale+ 
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=12),
          axis.text=element_text(size=11, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    labs(y = "Flow (cfs)")
  outfile <- paste0(export_path,"fig2.png")
  ggsave(outfile, plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 2: Zoomed Hydrograph saved at location ', outfile, sep = ''))
}

fig1.hydrograph <- function(all_data, cn1='Scenario 1', cn2='Scenario 2', export_path = '/tmp/') {
  cn1 <- paste0('1: ', cn1)
  cn2 <- paste0('2: ', cn2)
  
  # SETTING UP PLOTS
  # Basic hydrograph -----
  # Max/min for y axis scaling
  max <- max(c(max(all_data$`Scenario 1 Flow`), max(all_data$`Scenario 2 Flow`)), na.rm = TRUE);
  min <- min(c(min(all_data$`Scenario 1 Flow`), min(all_data$`Scenario 2 Flow`)), na.rm = TRUE);
  if (max > 10000){
    max <- 100000
  }else if (max > 1000){
    max <- 10000
  }else if (max > 100){
    max <- 1000
  }else if (max > 10){
    max <- 100
  }
  if (min>100){
    min<-100
  }else if (min>10){ 
    min<-10
  }else 
    min<-1
  if (min==100){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(100, 1000, 10000, 100000), 
                                      limits=c(min,max))
  }else if (min==10){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(10, 100, 1000, 10000), 
                                      limits=c(min,max))
  }else if (min==1){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(1, 10, 100, 1000, 10000), 
                                      limits=c(min,max))
  }else
    fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                      labels=scaleFUN, limits=c(min,max))
  df <- data.frame(as.Date(all_data$Date), all_data$`Scenario 1 Flow`, all_data$`Scenario 2 Flow`); 
  #colnames(df) <- c('Date', cn1, cn2)
  colnames(df) <- c('Date', 'Scenario1', 'Scenario2')
  options(scipen=5, width = 1400, height = 950)
  myplot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1, color=cn1), size=0.5) +
    geom_line(aes(y=Scenario2, color=cn2), size=0.5)+
    fixtheyscale+
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=12),
          axis.text=element_text(size=12, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    labs(y = "Flow (cfs)")
  outfile <- paste0(export_path,"fig1.png")
  ggsave(outfile, plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 1: Hydrograph saved at location ', outfile, sep = ''))
}

fn_downstream <- function(riv.seg, AllSegList) {
  library(stringr)
  library(rapportools)
  # Create dataframe for upstream and downstream segments based on code in string
  ModelSegments <- data.frame(matrix(nrow = length(AllSegList), ncol = 6))
  colnames(ModelSegments)<- c('RiverSeg', 'Middle', 'Last', 'AdditionalName', 'Downstream', 'Upstream')
  ModelSegments$RiverSeg <- AllSegList
  
  # Pull out 4 digit codes in middle and end for upstream/downstream segments
  i <- 1
  for (i in 1:nrow(ModelSegments)){
    
    ModelSegments[i,2]<- str_sub(ModelSegments[i,1], start=5L, end=8L)
    ModelSegments[i,3]<- str_sub(ModelSegments[i,1], start=10L, end=13L)
    ModelSegments[i,4]<- str_sub(ModelSegments[i,1], start=15L, end=-1L)
    i <- i + 1
  }
  
  # Determine Downstream Segment ----------
  j <- 1
  for (j in 1:nrow(ModelSegments)){
    if (ModelSegments[j,4] != ""){
      Downstream <- which((ModelSegments$Middle==ModelSegments$Middle[j]) & (ModelSegments$Last==ModelSegments$Last[j]) & (ModelSegments$AdditionalName==""))
      if (length(Downstream)==0){
        ModelSegments[j,5]  <- 'NA'
      }else if (length(Downstream)==1){
        ModelSegments[j,5] <- as.character(ModelSegments[Downstream,1])
      }
    }else if (ModelSegments[j,4]==""){
      Downstream <- which((ModelSegments$Middle==ModelSegments$Last[j]) & (ModelSegments$AdditionalName==""))
      if (length(Downstream)==0){
        ModelSegments[j,5]  <- 'NA'
      }else if (length(Downstream)==1){
        ModelSegments[j,5] <- as.character(ModelSegments[Downstream,1])
      }else if (length(Downstream)>1){
        ModelSegments[j,5] <- 'NA'
      }
    }
    j<-j+1
  }
  # Determine Upstream Segment ----------
  k<-1
  for (k in 1:nrow(ModelSegments)){
    Upstream <- which(as.character(ModelSegments$Downstream)==as.character(ModelSegments$RiverSeg[k]))
    NumUp <- ModelSegments$RiverSeg[Upstream]
    ModelSegments[k,6]<- paste(NumUp, collapse = '+')
    if (is.empty(ModelSegments[k,6])==TRUE){
      ModelSegments[k,6]<- 'NA'
    } 
    k<-k+1
  }
  SegDownstream <- as.numeric(which(as.character(ModelSegments$RiverSeg)==as.character(riv.seg)))
  SegDownstream <- ModelSegments$Downstream[SegDownstream]
  SegDownstream <- strsplit(as.character(SegDownstream), "\\+")
  SegDownstream <- try(SegDownstream[[1]], silent = TRUE)
  if (class(SegDownstream)=='try-error') {
    SegDownstream <- NA
  }
  return(SegDownstream)
}


fn_ALL.downstream <- function(riv.seg, AllSegList) {
  downstreamSeg <- fn_downstream(riv.seg, AllSegList)
  Alldownstream <- character(0)
  BranchedSegs <- character(0)
  while (is.na(downstreamSeg[1])==FALSE || is.empty(BranchedSegs) == FALSE) {
    while (is.na(downstreamSeg[1])==FALSE) {
      num.segs <- as.numeric(length(downstreamSeg))
      if (num.segs > 1) {
        BranchedSegs[(length(BranchedSegs)+1):(length(BranchedSegs)+num.segs-1)] <- downstreamSeg[2:num.segs]
        downstreamSeg <- downstreamSeg[1]
      }
      Alldownstream[length(Alldownstream)+1] <- downstreamSeg
      downstreamSeg <- fn_downstream(downstreamSeg, AllSegList)
    }
    num.branched <- as.numeric(length(BranchedSegs))
    downstreamSeg <- BranchedSegs[1]
    BranchedSegs <- BranchedSegs[-1]
  }
  Alldownstream <- Alldownstream[which(Alldownstream != 'NA')]
  if (is.empty(Alldownstream[1])==TRUE) {
    Alldownstream <- 'NA'
  }
  return(Alldownstream)
}

link.cbp6.lrseg.hydrocodes = function(riv.seg, psk, site, token) {
  # Get the hydro ID of the River Segment feature
  hydrocode = paste0("vahydrosw_wshed_", riv.seg);
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list (
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  riv.seg.hydro.id <- as.character(odata$hydroid)
  
  # create URL and output file for the table of land units linked to the river segment
  dat.url <- paste0(site, '/watershed-contains-wkt/', riv.seg.hydro.id, '/landunit/', psk)
  destfile <- paste0(getwd(), '\\lrsegs.wkt')
  
  # downloading, loading, and deleting table of land units linked to river segment
  download.file(dat.url, destfile, method = 'libcurl')
  land.units <- read.table(destfile, header = TRUE, sep = ',')
  unlink(destfile)
  
  # getting list of cbp6 land-river segments linked to river segment
  cbp6.landunits <- as.vector(land.units$hydrocode[land.units$Bundle..Type == 'Land Unit: cbp6_lrseg'])
  
  return(cbp6.landunits)
}

link.cbp6.lrseg.hydrocodes = function(riv.seg, psk, site, token) {
  # Get the hydro ID of the River Segment feature
  hydrocode = paste0("vahydrosw_wshed_", riv.seg);
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list (
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  riv.seg.hydro.id <- as.character(odata$hydroid)
  
  # create URL and output file for the table of land units linked to the river segment
  dat.url <- paste0(site, '/watershed-contains-wkt/', riv.seg.hydro.id, '/landunit/', psk)
  destfile <- paste0(getwd(), '\\lrsegs.wkt')
  
  # downloading, loading, and deleting table of land units linked to river segment
  download.file(dat.url, destfile, method = 'libcurl')
  land.units <- read.table(destfile, header = TRUE, sep = ',')
  unlink(destfile)
  
  # getting list of cbp6 land-river segments linked to river segment
  cbp6.landunits <- as.vector(land.units$hydrocode[land.units$Bundle..Type == 'Land Unit: cbp6_lrseg'])
  
  return(cbp6.landunits)
}

nse = function(gage.dat, scen.dat) {
  gage.mean <- mean(gage.dat$flow)
  nse <- 1 - (sum((scen.dat$flow - gage.dat$flow)^2)/sum((gage.dat$flow - gage.mean)^2))
  nse <- round(nse, digits = 3)
  return(nse)
}

tab.means.by.lrseg.flow = function(tmp.data) {
  suro.names <- grep('suro', colnames(tmp.data), value = TRUE)
  suro.cols <- which(colnames(tmp.data) %in% suro.names)
  suro.data <- as.numeric(as.matrix(tmp.data[,suro.cols]))
  suro.mean <- mean(suro.data)
  
  ifwo.names <- grep('ifwo', colnames(tmp.data), value = TRUE)
  ifwo.cols <- which(colnames(tmp.data) %in% ifwo.names)
  ifwo.data <- as.numeric(as.matrix(tmp.data[,ifwo.cols]))
  ifwo.mean <- mean(ifwo.data)
  
  agwo.names <- grep('agwo', colnames(tmp.data), value = TRUE)
  agwo.cols <- which(colnames(tmp.data) %in% agwo.names)
  agwo.data <- as.numeric(as.matrix(tmp.data[,agwo.cols]))
  agwo.mean <- mean(agwo.data)
  
  tmp.tab <- matrix(c(suro.mean, ifwo.mean, agwo.mean), nrow = 3, ncol = 1)
  colnames(tmp.tab) = c('Mean Unit Flow (cfs/sq. mi)')
  rownames(tmp.tab) = c('SURface Outflow   ', 'InterFloW Outflow   ', 'Active GroundWater Outflow   ')
  
  tmp.tab <- signif(tmp.tab, digits = 3)
  tmp.tab <- kable(format(tmp.tab, digits = 3, drop0trailing = TRUE))
  return(tmp.tab)
}

tab.means.by.lrseg.land.use = function(tmp.data) {
  aop.names <- grep('aop', colnames(tmp.data), value = TRUE)
  aop.cols <- which(colnames(tmp.data) %in% aop.names)
  aop.data <- as.numeric(as.matrix(tmp.data[,aop.cols]))
  aop.mean <- mean(aop.data)
  
  ccn.names <- grep('ccn', colnames(tmp.data), value = TRUE)
  ccn.cols <- which(colnames(tmp.data) %in% ccn.names)
  ccn.data <- as.numeric(as.matrix(tmp.data[,ccn.cols]))
  ccn.mean <- mean(ccn.data)
  
  cmo.names <- grep('cmo', colnames(tmp.data), value = TRUE)
  cmo.cols <- which(colnames(tmp.data) %in% cmo.names)
  cmo.data <- as.numeric(as.matrix(tmp.data[,cmo.cols]))
  cmo.mean <- mean(cmo.data)
  
  dbl.names <- grep('dbl', colnames(tmp.data), value = TRUE)
  dbl.cols <- which(colnames(tmp.data) %in% dbl.names)
  dbl.data <- as.numeric(as.matrix(tmp.data[,dbl.cols]))
  dbl.mean <- mean(dbl.data)
  
  fsp.names <- grep('fsp', colnames(tmp.data), value = TRUE)
  fsp.cols <- which(colnames(tmp.data) %in% fsp.names)
  fsp.data <- as.numeric(as.matrix(tmp.data[,fsp.cols]))
  fsp.mean <- mean(fsp.data)
  
  hfr.names <- grep('hfr', colnames(tmp.data), value = TRUE)
  hfr.cols <- which(colnames(tmp.data) %in% hfr.names)
  hfr.data <- as.numeric(as.matrix(tmp.data[,hfr.cols]))
  hfr.mean <- mean(hfr.data)
  
  mci.names <- grep('mci', colnames(tmp.data), value = TRUE)
  mci.cols <- which(colnames(tmp.data) %in% mci.names)
  mci.data <- as.numeric(as.matrix(tmp.data[,mci.cols]))
  mci.mean <- mean(mci.data)
  
  mnr.names <- grep('mnr', colnames(tmp.data), value = TRUE)
  mnr.cols <- which(colnames(tmp.data) %in% mnr.names)
  mnr.data <- as.numeric(as.matrix(tmp.data[,mnr.cols]))
  mnr.mean <- mean(mnr.data)
  
  nci.names <- grep('nci', colnames(tmp.data), value = TRUE)
  nci.cols <- which(colnames(tmp.data) %in% nci.names)
  nci.data <- as.numeric(as.matrix(tmp.data[,nci.cols]))
  nci.mean <- mean(nci.data)
  
  ntg.names <- grep('ntg', colnames(tmp.data), value = TRUE)
  ntg.cols <- which(colnames(tmp.data) %in% ntg.names)
  ntg.data <- as.numeric(as.matrix(tmp.data[,ntg.cols]))
  ntg.mean <- mean(ntg.data)
  
  osp.names <- grep('osp', colnames(tmp.data), value = TRUE)
  osp.cols <- which(colnames(tmp.data) %in% osp.names)
  osp.data <- as.numeric(as.matrix(tmp.data[,osp.cols]))
  osp.mean <- mean(osp.data)
  
  scl.names <- grep('scl', colnames(tmp.data), value = TRUE)
  scl.cols <- which(colnames(tmp.data) %in% scl.names)
  scl.data <- as.numeric(as.matrix(tmp.data[,scl.cols]))
  scl.mean <- mean(scl.data)
  
  som.names <- grep('som', colnames(tmp.data), value = TRUE)
  som.cols <- which(colnames(tmp.data) %in% som.names)
  som.data <- as.numeric(as.matrix(tmp.data[,som.cols]))
  som.mean <- mean(som.data)
  
  stf.names <- grep('stf', colnames(tmp.data), value = TRUE)
  stf.cols <- which(colnames(tmp.data) %in% stf.names)
  stf.data <- as.numeric(as.matrix(tmp.data[,stf.cols]))
  stf.mean <- mean(stf.data)
  
  wto.names <- grep('wto', colnames(tmp.data), value = TRUE)
  wto.cols <- which(colnames(tmp.data) %in% wto.names)
  wto.data <- as.numeric(as.matrix(tmp.data[,wto.cols]))
  wto.mean <- mean(wto.data)
  
  cch.names <- grep('cch', colnames(tmp.data), value = TRUE)
  cch.cols <- which(colnames(tmp.data) %in% cch.names)
  cch.data <- as.numeric(as.matrix(tmp.data[,cch.cols]))
  cch.mean <- mean(cch.data)
  
  cfr.names <- grep('cfr', colnames(tmp.data), value = TRUE)
  cfr.cols <- which(colnames(tmp.data) %in% cfr.names)
  cfr.data <- as.numeric(as.matrix(tmp.data[,cfr.cols]))
  cfr.mean <- mean(cfr.data)
  
  cnr.names <- grep('cnr', colnames(tmp.data), value = TRUE)
  cnr.cols <- which(colnames(tmp.data) %in% cnr.names)
  cnr.data <- as.numeric(as.matrix(tmp.data[,cnr.cols]))
  cnr.mean <- mean(cnr.data)
  
  fnp.names <- grep('fnp', colnames(tmp.data), value = TRUE)
  fnp.cols <- which(colnames(tmp.data) %in% fnp.names)
  fnp.data <- as.numeric(as.matrix(tmp.data[,fnp.cols]))
  fnp.mean <- mean(fnp.data)
  
  gom.names <- grep('gom', colnames(tmp.data), value = TRUE)
  gom.cols <- which(colnames(tmp.data) %in% gom.names)
  gom.data <- as.numeric(as.matrix(tmp.data[,gom.cols]))
  gom.mean <- mean(gom.data)
  
  lhy.names <- grep('lhy', colnames(tmp.data), value = TRUE)
  lhy.cols <- which(colnames(tmp.data) %in% lhy.names)
  lhy.data <- as.numeric(as.matrix(tmp.data[,lhy.cols]))
  lhy.mean <- mean(lhy.data)
  
  mcn.names <- grep('mcn', colnames(tmp.data), value = TRUE)
  mcn.cols <- which(colnames(tmp.data) %in% mcn.names)
  mcn.data <- as.numeric(as.matrix(tmp.data[,mcn.cols]))
  mcn.mean <- mean(mcn.data)
  
  mtg.names <- grep('mtg', colnames(tmp.data), value = TRUE)
  mtg.cols <- which(colnames(tmp.data) %in% mtg.names)
  mtg.data <- as.numeric(as.matrix(tmp.data[,mtg.cols]))
  mtg.mean <- mean(mtg.data)
  
  nir.names <- grep('nir', colnames(tmp.data), value = TRUE)
  nir.cols <- which(colnames(tmp.data) %in% nir.names)
  nir.data <- as.numeric(as.matrix(tmp.data[,nir.cols]))
  nir.mean <- mean(nir.data)
  
  oac.names <- grep('oac', colnames(tmp.data), value = TRUE)
  oac.cols <- which(colnames(tmp.data) %in% oac.names)
  oac.data <- as.numeric(as.matrix(tmp.data[,oac.cols]))
  oac.mean <- mean(oac.data)
  
  pas.names <- grep('pas', colnames(tmp.data), value = TRUE)
  pas.cols <- which(colnames(tmp.data) %in% pas.names)
  pas.data <- as.numeric(as.matrix(tmp.data[,pas.cols]))
  pas.mean <- mean(pas.data)
  
  sgg.names <- grep('sgg', colnames(tmp.data), value = TRUE)
  sgg.cols <- which(colnames(tmp.data) %in% sgg.names)
  sgg.data <- as.numeric(as.matrix(tmp.data[,sgg.cols]))
  sgg.mean <- mean(sgg.data)
  
  soy.names <- grep('soy', colnames(tmp.data), value = TRUE)
  soy.cols <- which(colnames(tmp.data) %in% soy.names)
  soy.data <- as.numeric(as.matrix(tmp.data[,soy.cols]))
  soy.mean <- mean(soy.data)
  
  swm.names <- grep('swm', colnames(tmp.data), value = TRUE)
  swm.cols <- which(colnames(tmp.data) %in% swm.names)
  swm.data <- as.numeric(as.matrix(tmp.data[,swm.cols]))
  swm.mean <- mean(swm.data)
  
  cci.names <- grep('cci', colnames(tmp.data), value = TRUE)
  cci.cols <- which(colnames(tmp.data) %in% cci.names)
  cci.data <- as.numeric(as.matrix(tmp.data[,cci.cols]))
  cci.mean <- mean(cci.data)
  
  cir.names <- grep('cir', colnames(tmp.data), value = TRUE)
  cir.cols <- which(colnames(tmp.data) %in% cir.names)
  cir.data <- as.numeric(as.matrix(tmp.data[,cir.cols]))
  cir.mean <- mean(cir.data)
  
  ctg.names <- grep('ctg', colnames(tmp.data), value = TRUE)
  ctg.cols <- which(colnames(tmp.data) %in% ctg.names)
  ctg.data <- as.numeric(as.matrix(tmp.data[,ctg.cols]))
  ctg.mean <- mean(ctg.data)
  
  for.names <- grep('for', colnames(tmp.data), value = TRUE)
  for.cols <- which(colnames(tmp.data) %in% for.names)
  for.data <- as.numeric(as.matrix(tmp.data[,for.cols]))
  for.mean <- mean(for.data)
  
  gwm.names <- grep('gwm', colnames(tmp.data), value = TRUE)
  gwm.cols <- which(colnames(tmp.data) %in% gwm.names)
  gwm.data <- as.numeric(as.matrix(tmp.data[,gwm.cols]))
  gwm.mean <- mean(gwm.data)
  
  mch.names <- grep('mch', colnames(tmp.data), value = TRUE)
  mch.cols <- which(colnames(tmp.data) %in% mch.names)
  mch.data <- as.numeric(as.matrix(tmp.data[,mch.cols]))
  mch.mean <- mean(mch.data)
  
  mir.names <- grep('mir', colnames(tmp.data), value = TRUE)
  mir.cols <- which(colnames(tmp.data) %in% mir.names)
  mir.data <- as.numeric(as.matrix(tmp.data[,mir.cols]))
  mir.mean <- mean(mir.data)
  
  nch.names <- grep('nch', colnames(tmp.data), value = TRUE)
  nch.cols <- which(colnames(tmp.data) %in% nch.names)
  nch.data <- as.numeric(as.matrix(tmp.data[,nch.cols]))
  nch.mean <- mean(nch.data)
  
  nnr.names <- grep('nnr', colnames(tmp.data), value = TRUE)
  nnr.cols <- which(colnames(tmp.data) %in% nnr.names)
  nnr.data <- as.numeric(as.matrix(tmp.data[,nnr.cols]))
  nnr.mean <- mean(nnr.data)
  
  ohy.names <- grep('ohy', colnames(tmp.data), value = TRUE)
  ohy.cols <- which(colnames(tmp.data) %in% ohy.names)
  ohy.data <- as.numeric(as.matrix(tmp.data[,ohy.cols]))
  ohy.mean <- mean(ohy.data)
  
  sch.names <- grep('sch', colnames(tmp.data), value = TRUE)
  sch.cols <- which(colnames(tmp.data) %in% sch.names)
  sch.data <- as.numeric(as.matrix(tmp.data[,sch.cols]))
  sch.mean <- mean(sch.data)
  
  sho.names <- grep('sho', colnames(tmp.data), value = TRUE)
  sho.cols <- which(colnames(tmp.data) %in% sho.names)
  sho.data <- as.numeric(as.matrix(tmp.data[,sho.cols]))
  sho.mean <- mean(sho.data)
  
  stb.names <- grep('stb', colnames(tmp.data), value = TRUE)
  stb.cols <- which(colnames(tmp.data) %in% stb.names)
  stb.data <- as.numeric(as.matrix(tmp.data[,stb.cols]))
  stb.mean <- mean(stb.data)
  
  wfp.names <- grep('wfp', colnames(tmp.data), value = TRUE)
  wfp.cols <- which(colnames(tmp.data) %in% wfp.names)
  wfp.data <- as.numeric(as.matrix(tmp.data[,wfp.cols]))
  wfp.mean <- mean(wfp.data)
  
  tmp.tab <- matrix(c(aop.mean, cch.mean, cci.mean, ccn.mean, cfr.mean, cir.mean, cmo.mean, cnr.mean,
                      ctg.mean, dbl.mean, fnp.mean, for.mean, fsp.mean, gom.mean, gwm.mean, hfr.mean,
                      lhy.mean, mch.mean, mci.mean, mcn.mean, mir.mean, mnr.mean, mtg.mean, nch.mean,
                      nci.mean, nir.mean, nnr.mean, ntg.mean, oac.mean, ohy.mean, osp.mean, pas.mean, 
                      sch.mean, scl.mean, sgg.mean, sho.mean, som.mean, soy.mean, stb.mean, stf.mean, 
                      swm.mean, wfp.mean, wto.mean), nrow = 43, ncol = 1)
  colnames(tmp.tab) = c('Mean Unit Flow (cfs/sq. mi)')
  rownames(tmp.tab) = c('aop', 'cch', 'cci', 'ccn', 'cfr', 'cir', 'cmo', 'cnr',
                        'ctg', 'dbl', 'fnp', 'for', 'fsp', 'gom', 'gwm', 'hfr',
                        'lhy', 'mch', 'mci', 'mcn', 'mir', 'mnr', 'mtg', 'nch',
                        'nci', 'nir', 'nnr', 'ntg', 'oac', 'ohy', 'osp', 'pas',
                        'sch', 'scl', 'sgg', 'sho', 'som', 'soy', 'stb', 'stf',
                        'swm', 'wfp', 'wto')
  
  tmp.tab <- signif(tmp.tab, digits = 3)
  tmp.tab <- kable(format(tmp.tab, digits = 3, drop0trailing = TRUE))
  return(tmp.tab)
}

tab.zero.day.ratios.by.lrseg.flow = function(tmp.data) {
  suro.names <- grep('suro', colnames(tmp.data), value = TRUE)
  suro.cols <- which(colnames(tmp.data) %in% suro.names)
  suro.data <- as.numeric(as.matrix(tmp.data[,suro.cols]))
  suro.ratio <- length(which(suro.data == 0))/length(suro.data)
  
  ifwo.names <- grep('ifwo', colnames(tmp.data), value = TRUE)
  ifwo.cols <- which(colnames(tmp.data) %in% ifwo.names)
  ifwo.data <- as.numeric(as.matrix(tmp.data[,ifwo.cols]))
  ifwo.ratio <- length(which(ifwo.data == 0))/length(ifwo.data)
  
  agwo.names <- grep('agwo', colnames(tmp.data), value = TRUE)
  agwo.cols <- which(colnames(tmp.data) %in% agwo.names)
  agwo.data <- as.numeric(as.matrix(tmp.data[,agwo.cols]))
  agwo.ratio <- length(which(agwo.data == 0))/length(agwo.data)
  
  tmp.tab <- matrix(c(suro.ratio, ifwo.ratio, agwo.ratio), nrow = 3, ncol = 1)
  colnames(tmp.tab) = c('Ratio of Days with Zero Flow to Total Days')
  rownames(tmp.tab) = c('SURface Outflow   ', 'InterFloW Outflow   ', 'Active GroundWater Outflow   ')
  
  tmp.tab <- signif(tmp.tab, digits = 3)
  tmp.tab <- kable(format(tmp.tab, digits = 3, drop0trailing = TRUE))
  return(tmp.tab)
}

tab.zero.day.ratios.by.lrseg.land.use = function(tmp.data) {
  aop.names <- grep('aop', colnames(tmp.data), value = TRUE)
  aop.cols <- which(colnames(tmp.data) %in% aop.names)
  aop.data <- as.numeric(as.matrix(tmp.data[,aop.cols]))
  aop.ratio <- length(which(aop.data == 0))/length(aop.data)
  
  ccn.names <- grep('ccn', colnames(tmp.data), value = TRUE)
  ccn.cols <- which(colnames(tmp.data) %in% ccn.names)
  ccn.data <- as.numeric(as.matrix(tmp.data[,ccn.cols]))
  ccn.ratio <- length(which(ccn.data == 0))/length(ccn.data)
  
  cmo.names <- grep('cmo', colnames(tmp.data), value = TRUE)
  cmo.cols <- which(colnames(tmp.data) %in% cmo.names)
  cmo.data <- as.numeric(as.matrix(tmp.data[,cmo.cols]))
  cmo.ratio <- length(which(cmo.data == 0))/length(cmo.data)
  
  dbl.names <- grep('dbl', colnames(tmp.data), value = TRUE)
  dbl.cols <- which(colnames(tmp.data) %in% dbl.names)
  dbl.data <- as.numeric(as.matrix(tmp.data[,dbl.cols]))
  dbl.ratio <- length(which(dbl.data == 0))/length(dbl.data)
  
  fsp.names <- grep('fsp', colnames(tmp.data), value = TRUE)
  fsp.cols <- which(colnames(tmp.data) %in% fsp.names)
  fsp.data <- as.numeric(as.matrix(tmp.data[,fsp.cols]))
  fsp.ratio <- length(which(fsp.data == 0))/length(fsp.data)
  
  hfr.names <- grep('hfr', colnames(tmp.data), value = TRUE)
  hfr.cols <- which(colnames(tmp.data) %in% hfr.names)
  hfr.data <- as.numeric(as.matrix(tmp.data[,hfr.cols]))
  hfr.ratio <- length(which(hfr.data == 0))/length(hfr.data)
  
  mci.names <- grep('mci', colnames(tmp.data), value = TRUE)
  mci.cols <- which(colnames(tmp.data) %in% mci.names)
  mci.data <- as.numeric(as.matrix(tmp.data[,mci.cols]))
  mci.ratio <- length(which(mci.data == 0))/length(mci.data)
  
  mnr.names <- grep('mnr', colnames(tmp.data), value = TRUE)
  mnr.cols <- which(colnames(tmp.data) %in% mnr.names)
  mnr.data <- as.numeric(as.matrix(tmp.data[,mnr.cols]))
  mnr.ratio <- length(which(mnr.data == 0))/length(mnr.data)
  
  nci.names <- grep('nci', colnames(tmp.data), value = TRUE)
  nci.cols <- which(colnames(tmp.data) %in% nci.names)
  nci.data <- as.numeric(as.matrix(tmp.data[,nci.cols]))
  nci.ratio <- length(which(nci.data == 0))/length(nci.data)
  
  ntg.names <- grep('ntg', colnames(tmp.data), value = TRUE)
  ntg.cols <- which(colnames(tmp.data) %in% ntg.names)
  ntg.data <- as.numeric(as.matrix(tmp.data[,ntg.cols]))
  ntg.ratio <- length(which(ntg.data == 0))/length(ntg.data)
  
  osp.names <- grep('osp', colnames(tmp.data), value = TRUE)
  osp.cols <- which(colnames(tmp.data) %in% osp.names)
  osp.data <- as.numeric(as.matrix(tmp.data[,osp.cols]))
  osp.ratio <- length(which(osp.data == 0))/length(osp.data)
  
  scl.names <- grep('scl', colnames(tmp.data), value = TRUE)
  scl.cols <- which(colnames(tmp.data) %in% scl.names)
  scl.data <- as.numeric(as.matrix(tmp.data[,scl.cols]))
  scl.ratio <- length(which(scl.data == 0))/length(scl.data)
  
  som.names <- grep('som', colnames(tmp.data), value = TRUE)
  som.cols <- which(colnames(tmp.data) %in% som.names)
  som.data <- as.numeric(as.matrix(tmp.data[,som.cols]))
  som.ratio <- length(which(som.data == 0))/length(som.data)
  
  stf.names <- grep('stf', colnames(tmp.data), value = TRUE)
  stf.cols <- which(colnames(tmp.data) %in% stf.names)
  stf.data <- as.numeric(as.matrix(tmp.data[,stf.cols]))
  stf.ratio <- length(which(stf.data == 0))/length(stf.data)
  
  wto.names <- grep('wto', colnames(tmp.data), value = TRUE)
  wto.cols <- which(colnames(tmp.data) %in% wto.names)
  wto.data <- as.numeric(as.matrix(tmp.data[,wto.cols]))
  wto.ratio <- length(which(wto.data == 0))/length(wto.data)
  
  cch.names <- grep('cch', colnames(tmp.data), value = TRUE)
  cch.cols <- which(colnames(tmp.data) %in% cch.names)
  cch.data <- as.numeric(as.matrix(tmp.data[,cch.cols]))
  cch.ratio <- length(which(cch.data == 0))/length(cch.data)
  
  cfr.names <- grep('cfr', colnames(tmp.data), value = TRUE)
  cfr.cols <- which(colnames(tmp.data) %in% cfr.names)
  cfr.data <- as.numeric(as.matrix(tmp.data[,cfr.cols]))
  cfr.ratio <- length(which(cfr.data == 0))/length(cfr.data)
  
  cnr.names <- grep('cnr', colnames(tmp.data), value = TRUE)
  cnr.cols <- which(colnames(tmp.data) %in% cnr.names)
  cnr.data <- as.numeric(as.matrix(tmp.data[,cnr.cols]))
  cnr.ratio <- length(which(cnr.data == 0))/length(cnr.data)
  
  fnp.names <- grep('fnp', colnames(tmp.data), value = TRUE)
  fnp.cols <- which(colnames(tmp.data) %in% fnp.names)
  fnp.data <- as.numeric(as.matrix(tmp.data[,fnp.cols]))
  fnp.ratio <- length(which(fnp.data == 0))/length(fnp.data)
  
  gom.names <- grep('gom', colnames(tmp.data), value = TRUE)
  gom.cols <- which(colnames(tmp.data) %in% gom.names)
  gom.data <- as.numeric(as.matrix(tmp.data[,gom.cols]))
  gom.ratio <- length(which(gom.data == 0))/length(gom.data)
  
  lhy.names <- grep('lhy', colnames(tmp.data), value = TRUE)
  lhy.cols <- which(colnames(tmp.data) %in% lhy.names)
  lhy.data <- as.numeric(as.matrix(tmp.data[,lhy.cols]))
  lhy.ratio <- length(which(lhy.data == 0))/length(lhy.data)
  
  mcn.names <- grep('mcn', colnames(tmp.data), value = TRUE)
  mcn.cols <- which(colnames(tmp.data) %in% mcn.names)
  mcn.data <- as.numeric(as.matrix(tmp.data[,mcn.cols]))
  mcn.ratio <- length(which(mcn.data == 0))/length(mcn.data)
  
  mtg.names <- grep('mtg', colnames(tmp.data), value = TRUE)
  mtg.cols <- which(colnames(tmp.data) %in% mtg.names)
  mtg.data <- as.numeric(as.matrix(tmp.data[,mtg.cols]))
  mtg.ratio <- length(which(mtg.data == 0))/length(mtg.data)
  
  nir.names <- grep('nir', colnames(tmp.data), value = TRUE)
  nir.cols <- which(colnames(tmp.data) %in% nir.names)
  nir.data <- as.numeric(as.matrix(tmp.data[,nir.cols]))
  nir.ratio <- length(which(nir.data == 0))/length(nir.data)
  
  oac.names <- grep('oac', colnames(tmp.data), value = TRUE)
  oac.cols <- which(colnames(tmp.data) %in% oac.names)
  oac.data <- as.numeric(as.matrix(tmp.data[,oac.cols]))
  oac.ratio <- length(which(oac.data == 0))/length(oac.data)
  
  pas.names <- grep('pas', colnames(tmp.data), value = TRUE)
  pas.cols <- which(colnames(tmp.data) %in% pas.names)
  pas.data <- as.numeric(as.matrix(tmp.data[,pas.cols]))
  pas.ratio <- length(which(pas.data == 0))/length(pas.data)
  
  sgg.names <- grep('sgg', colnames(tmp.data), value = TRUE)
  sgg.cols <- which(colnames(tmp.data) %in% sgg.names)
  sgg.data <- as.numeric(as.matrix(tmp.data[,sgg.cols]))
  sgg.ratio <- length(which(sgg.data == 0))/length(sgg.data)
  
  soy.names <- grep('soy', colnames(tmp.data), value = TRUE)
  soy.cols <- which(colnames(tmp.data) %in% soy.names)
  soy.data <- as.numeric(as.matrix(tmp.data[,soy.cols]))
  soy.ratio <- length(which(soy.data == 0))/length(soy.data)
  
  swm.names <- grep('swm', colnames(tmp.data), value = TRUE)
  swm.cols <- which(colnames(tmp.data) %in% swm.names)
  swm.data <- as.numeric(as.matrix(tmp.data[,swm.cols]))
  swm.ratio <- length(which(swm.data == 0))/length(swm.data)
  
  cci.names <- grep('cci', colnames(tmp.data), value = TRUE)
  cci.cols <- which(colnames(tmp.data) %in% cci.names)
  cci.data <- as.numeric(as.matrix(tmp.data[,cci.cols]))
  cci.ratio <- length(which(cci.data == 0))/length(cci.data)
  
  cir.names <- grep('cir', colnames(tmp.data), value = TRUE)
  cir.cols <- which(colnames(tmp.data) %in% cir.names)
  cir.data <- as.numeric(as.matrix(tmp.data[,cir.cols]))
  cir.ratio <- length(which(cir.data == 0))/length(cir.data)
  
  ctg.names <- grep('ctg', colnames(tmp.data), value = TRUE)
  ctg.cols <- which(colnames(tmp.data) %in% ctg.names)
  ctg.data <- as.numeric(as.matrix(tmp.data[,ctg.cols]))
  ctg.ratio <- length(which(ctg.data == 0))/length(ctg.data)
  
  for.names <- grep('for', colnames(tmp.data), value = TRUE)
  for.cols <- which(colnames(tmp.data) %in% for.names)
  for.data <- as.numeric(as.matrix(tmp.data[,for.cols]))
  for.ratio <- length(which(for.data == 0))/length(for.data)
  
  gwm.names <- grep('gwm', colnames(tmp.data), value = TRUE)
  gwm.cols <- which(colnames(tmp.data) %in% gwm.names)
  gwm.data <- as.numeric(as.matrix(tmp.data[,gwm.cols]))
  gwm.ratio <- length(which(gwm.data == 0))/length(gwm.data)
  
  mch.names <- grep('mch', colnames(tmp.data), value = TRUE)
  mch.cols <- which(colnames(tmp.data) %in% mch.names)
  mch.data <- as.numeric(as.matrix(tmp.data[,mch.cols]))
  mch.ratio <- length(which(mch.data == 0))/length(mch.data)
  
  mir.names <- grep('mir', colnames(tmp.data), value = TRUE)
  mir.cols <- which(colnames(tmp.data) %in% mir.names)
  mir.data <- as.numeric(as.matrix(tmp.data[,mir.cols]))
  mir.ratio <- length(which(mir.data == 0))/length(mir.data)
  
  nch.names <- grep('nch', colnames(tmp.data), value = TRUE)
  nch.cols <- which(colnames(tmp.data) %in% nch.names)
  nch.data <- as.numeric(as.matrix(tmp.data[,nch.cols]))
  nch.ratio <- length(which(nch.data == 0))/length(nch.data)
  
  nnr.names <- grep('nnr', colnames(tmp.data), value = TRUE)
  nnr.cols <- which(colnames(tmp.data) %in% nnr.names)
  nnr.data <- as.numeric(as.matrix(tmp.data[,nnr.cols]))
  nnr.ratio <- length(which(nnr.data == 0))/length(nnr.data)
  
  ohy.names <- grep('ohy', colnames(tmp.data), value = TRUE)
  ohy.cols <- which(colnames(tmp.data) %in% ohy.names)
  ohy.data <- as.numeric(as.matrix(tmp.data[,ohy.cols]))
  ohy.ratio <- length(which(ohy.data == 0))/length(ohy.data)
  
  sch.names <- grep('sch', colnames(tmp.data), value = TRUE)
  sch.cols <- which(colnames(tmp.data) %in% sch.names)
  sch.data <- as.numeric(as.matrix(tmp.data[,sch.cols]))
  sch.ratio <- length(which(sch.data == 0))/length(sch.data)
  
  sho.names <- grep('sho', colnames(tmp.data), value = TRUE)
  sho.cols <- which(colnames(tmp.data) %in% sho.names)
  sho.data <- as.numeric(as.matrix(tmp.data[,sho.cols]))
  sho.ratio <- length(which(sho.data == 0))/length(sho.data)
  
  stb.names <- grep('stb', colnames(tmp.data), value = TRUE)
  stb.cols <- which(colnames(tmp.data) %in% stb.names)
  stb.data <- as.numeric(as.matrix(tmp.data[,stb.cols]))
  stb.ratio <- length(which(stb.data == 0))/length(stb.data)
  
  wfp.names <- grep('wfp', colnames(tmp.data), value = TRUE)
  wfp.cols <- which(colnames(tmp.data) %in% wfp.names)
  wfp.data <- as.numeric(as.matrix(tmp.data[,wfp.cols]))
  wfp.ratio <- length(which(wfp.data == 0))/length(wfp.data)
  
  tmp.tab <- matrix(c(aop.ratio, cch.ratio, cci.ratio, ccn.ratio, cfr.ratio, cir.ratio, cmo.ratio, cnr.ratio,
                      ctg.ratio, dbl.ratio, fnp.ratio, for.ratio, fsp.ratio, gom.ratio, gwm.ratio, hfr.ratio,
                      lhy.ratio, mch.ratio, mci.ratio, mcn.ratio, mir.ratio, mnr.ratio, mtg.ratio, nch.ratio,
                      nci.ratio, nir.ratio, nnr.ratio, ntg.ratio, oac.ratio, ohy.ratio, osp.ratio, pas.ratio, 
                      sch.ratio, scl.ratio, sgg.ratio, sho.ratio, som.ratio, soy.ratio, stb.ratio, stf.ratio, 
                      swm.ratio, wfp.ratio, wto.ratio), nrow = 43, ncol = 1)
  colnames(tmp.tab) = c('Ratio of Days with Zero Flow to Total Days')
  rownames(tmp.tab) = c('aop', 'cch', 'cci', 'ccn', 'cfr', 'cir', 'cmo', 'cnr',
                        'ctg', 'dbl', 'fnp', 'for', 'fsp', 'gom', 'gwm', 'hfr',
                        'lhy', 'mch', 'mci', 'mcn', 'mir', 'mnr', 'mtg', 'nch',
                        'nci', 'nir', 'nnr', 'ntg', 'oac', 'ohy', 'osp', 'pas',
                        'sch', 'scl', 'sgg', 'sho', 'som', 'soy', 'stb', 'stf',
                        'swm', 'wfp', 'wto')
  
  tmp.tab <- signif(tmp.tab, digits = 3)
  tmp.tab <- kable(format(tmp.tab, digits = 3, drop0trailing = TRUE))
  return(tmp.tab)
}

tab.iqr.by.lrseg.flow.annual = function(tmp.data, flow.abbreviation) {
  flow.names <- grep(flow.abbreviation, colnames(tmp.data), value = TRUE)
  date.names <- grep('thisdate', colnames(tmp.data), value = TRUE)
  flow.cols <- which(colnames(tmp.data) %in% flow.names)
  date.cols <- which(colnames(tmp.data) %in% date.names)
  all.cols <- c(date.cols, flow.cols)
  flow.data <- as.data.frame(tmp.data[,all.cols])
  
  years <- unique(year(as.Date(flow.data$thisdate)))
  
  tmp.tab <- as.data.frame(matrix(nrow = length(years), ncol = 1))
  
  for (i in 1:length(years)) {
    tmp.dat <- flow.data[which(as.numeric(year(as.Date(flow.data$thisdate))) == as.numeric(years[i])),]
    
    tmp.75pct <- signif(as.numeric(quantile(as.numeric(as.matrix(as.data.frame(tmp.dat[,-1]))), 0.75)), 3)
    tmp.25pct <- signif(as.numeric(quantile(as.numeric(as.matrix(as.data.frame(tmp.dat[,-1]))), 0.25)), 3)
    tmp.iqr <- signif(tmp.75pct - tmp.25pct, 3)
    flow.tabler <- paste0(tmp.iqr, ' [', tmp.25pct, ', ', tmp.75pct, ']')
    
    tmp.tab[i, 1] <- flow.tabler
  }
  
  colnames(tmp.tab) = c('IQR of Unit Flows (cfs/sq. mi) [25th, 75th]')
  rownames(tmp.tab) = c(years)
  
  tmp.tab <- kable(format(tmp.tab, drop0trailing = TRUE))
  return(tmp.tab)
}

tab.iqr.by.lrseg.lri.annual = function(lri.data) {
  years <- unique(year(as.Date(lri.data$date)))
  
  tmp.tab <- as.data.frame(matrix(nrow = length(years), ncol = 1))
  
  for (i in 1:length(years)) {
    tmp.dat <- lri.data[which(as.numeric(year(as.Date(lri.data$date))) == as.numeric(years[i])),]
    
    tmp.75pct <- signif(as.numeric(quantile(as.numeric(as.matrix(as.data.frame(tmp.dat$flow))), 0.75)), 3)
    tmp.25pct <- signif(as.numeric(quantile(as.numeric(as.matrix(as.data.frame(tmp.dat$flow))), 0.25)), 3)
    tmp.iqr <- signif(tmp.75pct - tmp.25pct, 3)
    flow.tabler <- paste0(tmp.iqr, ' [', tmp.25pct, ', ', tmp.75pct, ']')
    
    tmp.tab[i, 1] <- flow.tabler
  }
  
  colnames(tmp.tab) = c('IQR of Runit Flows (cfs/sq. mi) [25th, 75th]')
  rownames(tmp.tab) = c(years)
  
  tmp.tab <- kable(format(tmp.tab, drop0trailing = TRUE))
  return(tmp.tab)
}

fig.boxplot.by.flow <- function(tmp.data, flow.abbreviation, lrseg.name, export_path = '/tmp/') {
  flow.names <- grep(flow.abbreviation, colnames(tmp.data), value = TRUE)
  date.names <- grep('thisdate', colnames(tmp.data), value = TRUE)
  flow.cols <- which(colnames(tmp.data) %in% flow.names)
  date.cols <- which(colnames(tmp.data) %in% date.names)
  all.cols <- c(date.cols, flow.cols)
  flow.data <- as.data.frame(tmp.data[,all.cols])
  
  date.col <- as.Date(flow.data$thisdate)
  flow.matrix <- flow.data[,-1]
  for (i in 1:ncol(flow.matrix)) {
    flow.matrix[,i] <- as.numeric(levels(flow.matrix[,i]))[flow.matrix[,i]]
  }
  sum.flow.col <- rowSums(flow.matrix)
  summed.data <- data.frame(date.col, sum.flow.col)
  colnames(summed.data) <- c('date', 'flow')
  
  boxplot(as.numeric(summed.data$flow) ~ year(summed.data$date), outline = FALSE, ylab = 'Unit Flow (cfs)', xlab = 'Date')
  outfile <- paste0(export_path, paste0('/fig', flow.abbreviation, '.', lrseg.name, '.png')) 
  dev.copy(png, outfile)
  dev.off()
  print(paste('Fig.: ',  flow.abbreviation, ' Boxplot for lrseg ', lrseg.name, ' saved at location ', outfile, sep = ''))
}

fig.boxplot.by.flow.for.dash <- function(tmp.data, flow.abbreviation) {
  flow.names <- grep(flow.abbreviation, colnames(tmp.data), value = TRUE)
  date.names <- grep('thisdate', colnames(tmp.data), value = TRUE)
  flow.cols <- which(colnames(tmp.data) %in% flow.names)
  date.cols <- which(colnames(tmp.data) %in% date.names)
  all.cols <- c(date.cols, flow.cols)
  flow.data <- as.data.frame(tmp.data[,all.cols])
  
  date.col <- as.Date(flow.data$thisdate)
  flow.matrix <- flow.data[,-1]
  for (i in 1:ncol(flow.matrix)) {
    flow.matrix[,i] <- as.numeric(levels(flow.matrix[,i]))[flow.matrix[,i]]
  }
  sum.flow.col <- rowSums(flow.matrix)
  summed.data <- data.frame(date.col, sum.flow.col)
  colnames(summed.data) <- c('date', 'flow')
  
  plot <- boxplot(as.numeric(summed.data$flow) ~ year(summed.data$date), outline = FALSE, ylab = 'Unit Flow (cfs)', xlab = 'Date')
  return(plot)
}

# This function gets the unique ID of a scenario property posted to the 
# vahydro property on a watershed feature
# Inputs: 
#   riv.seg - last portion of certain river segment hydrocode on vahydro. ex: 'TU3_9180_9090'
#   mod.scenario - specific model scenario of interest, default mod.scenario is 'vahydro - 1.0'
#   dat.source - either 'vahydro' or 'cbp_model' 
#   run.id - unique runid for desired model run. ex: run.id = '11' for runid_11 scenario run
#   start.date - starting date for analysis, format = 'yyyy-mm-dd'
#   end.date - ending date for analysis, format = 'yyyy-mm-dd'
#   site - specified vahydro site to be accessed
#   token - vahydro token to access this specific site
# Outputs: Unique ID for scenario property

get.scen.prop <- function(riv.seg, mod.scenario, dat.source, run.id, start.date, end.date, site, token) {
  # GETTING MODEL DATA FROM VA HYDRO
  hydrocode = paste("vahydrosw_wshed_", riv.seg, sep="");
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list(
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  
  if (odata == FALSE) {
    return(FALSE)
  }
  
  hydroid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name);
  print(paste("Retrieved hydroid", hydroid, "for", fname, riv.seg, sep=' '));
  
  # @todo: all of this logic needs to go, the request should understand
  #        the data model sufficiently to prevent this necessity.
  #        similarly, all models should share the same structure.
  if (dat.source == 'cbp_model') {
    # GETTING SCENARIO MODEL ELEMENT FROM VA HYDRO
    inputs <- list(
      varkey = "om_model_element",
      featureid = hydroid,
      entity_type = "dh_feature",
      propcode = mod.scenario
    )
  } else if (dat.source == 'vahydro') {
    # GETTING VA HYDRO MODEL ELEMENT FROM VA HYDRO
    inputs <- list(
      varkey = "om_water_model_node",
      featureid = hydroid,
      entity_type = "dh_feature",
      propcode = 'vahydro-1.0'
    )
  } else if (dat.source == 'gage') {
    # GETTING VA HYDRO MODEL ELEMENT FROM VA HYDRO
    #varkey = "om_model_element",
    inputs <- list(
      featureid = hydroid,
      varkey = "om_model_element",
      entity_type = "dh_feature",
      propcode = 'usgs-1.0'
    )
  } else {
    print('Error: data source is neither "cbp_model", "gage" nor "vahydro"')
    return(FALSE)
  }
  
  scenario <- getProperty(inputs, site, scenario)
  
  if (scenario == FALSE) {
    return(FALSE)
  }
  
  # DETERMINING PROPNAME AND PROPCODE FOR SCENARIO PROPERTY
  if (dat.source == 'cbp_model') {
    scen.propname <- mod.scenario
    scen.propcode <- mod.scenario
  } else if (dat.source == 'vahydro') {
    scen.propname <- paste0('runid_', run.id)
    scen.propcode <- ''
  } else if (dat.source == 'gage') {
    scen.propname <- paste0('runid_', run.id)
    scen.propcode <- ''
  } else {
    print('Error: data source is neither "cbp_model" nor "vahydro"')
    return(FALSE)
  }
  
  # GETTING SCENARIO PROPERTY FROM VA HYDRO
  sceninfo <- list(
    varkey = 'om_scenario',
    propname = scen.propname,
    featureid = as.integer(as.character(scenario$pid)),
    entity_type = "dh_properties",
    propvalue = 0,
    propcode = scen.propcode,
    startdate = NULL,
    enddate = NULL
    # startdate = as.numeric(as.POSIXct(start.date, origin = "1970-01-01", tz = "GMT")),
    # enddate = as.numeric(as.POSIXct(end.date, origin = "1970-01-01", tz = "GMT"))
    # at the moment, there are bugs in startdate and enddate on vahydro
  )
  scenprop <- getProperty(sceninfo, site, scenprop)
  
  # POST PROPERTY IF IT IS NOT YET CREATED
  if (identical(scenprop, FALSE)) {
    # create
    message("Creating scenario property")
    inputs$pid = NULL
    postProperty(sceninfo, site, scenprop) 
  } else {
    inputs$pid = scenario$pid
  }
  
  # RETRIEVING PROPERTY ONE LAST TIME TO RETURN HYDROID OF PROP
  scenprop <- getProperty(sceninfo, site, scenprop)
  
  if (scenprop == FALSE) {
    return(FALSE)
  }
  
  return(as.numeric(scenprop$pid))
}


vahydro_post_metric_to_scenprop <- function(scenprop.pid, met.varkey, met.propcode, met.name, met.value, site, token) {
  hydroid = scenprop.pid
  
  metinfo <- list(
    varkey = met.varkey,
    propcode = met.propcode,
    propname = met.name,
    featureid = as.integer(hydroid),
    entity_type = "dh_properties"
  )
  metprop <- getProperty(metinfo, site, metprop)
  
  if (identical(metprop, FALSE)) {
    # create
    metinfo$pid = NULL
  } else {
    metinfo$pid = metprop$pid
  }
  
  metinfo$propname = met.name
  metinfo$varkey = met.varkey
  metinfo$propcode = met.propcode
  metinfo$propvalue = met.value
  postProperty(metinfo,base_url = site,metprop) 
}


vahydro_post_all_metrics_to_scenprop <- function(scenprop.pid, metrics, site, token) {
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'overall_mean', 
                                  met.propcode = '', met.name = 'Overall Mean Flow', 
                                  met.value = signif(metrics$overall.mean, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_low_flow', 
                                  met.propcode = 'ml1', met.name = 'January Low Flow', 
                                  met.value = signif(metrics$jan.low.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_low_flow', 
                                  met.propcode = 'ml2', met.name = 'February Low Flow', 
                                  met.value = signif(metrics$feb.low.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_low_flow', 
                                  met.propcode = 'ml3', met.name = 'March Low Flow', 
                                  met.value = signif(metrics$mar.low.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_low_flow', 
                                  met.propcode = 'ml4', met.name = 'April Low Flow', 
                                  met.value = signif(metrics$apr.low.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_low_flow', 
                                  met.propcode = 'ml5', met.name = 'May Low Flow', 
                                  met.value = signif(metrics$may.low.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_low_flow', 
                                  met.propcode = 'ml6', met.name = 'June Low Flow', 
                                  met.value = signif(metrics$jun.low.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_low_flow', 
                                  met.propcode = 'ml7', met.name = 'July Low Flow', 
                                  met.value = signif(metrics$jul.low.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_low_flow', 
                                  met.propcode = 'ml8', met.name = 'August Low Flow', 
                                  met.value = signif(metrics$aug.low.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_low_flow', 
                                  met.propcode = 'ml9', met.name = 'September Low Flow', 
                                  met.value = signif(metrics$sep.low.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_low_flow', 
                                  met.propcode = 'ml10', met.name = 'October Low Flow', 
                                  met.value = signif(metrics$oct.low.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_low_flow', 
                                  met.propcode = 'ml11', met.name = 'November Low Flow', 
                                  met.value = signif(metrics$nov.low.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_low_flow', 
                                  met.propcode = 'ml12', met.name = 'December Low Flow', 
                                  met.value = signif(metrics$dec.low.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_mean_flow', 
                                  met.propcode = 'mm1', met.name = 'January Mean Flow', 
                                  met.value = signif(metrics$jan.mean.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_mean_flow', 
                                  met.propcode = 'mm2', met.name = 'February Mean Flow', 
                                  met.value = signif(metrics$feb.mean.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_mean_flow', 
                                  met.propcode = 'mm3', met.name = 'March Mean Flow', 
                                  met.value = signif(metrics$mar.mean.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_mean_flow', 
                                  met.propcode = 'mm4', met.name = 'April Mean Flow', 
                                  met.value = signif(metrics$apr.mean.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_mean_flow', 
                                  met.propcode = 'mm5', met.name = 'May Mean Flow', 
                                  met.value = signif(metrics$may.mean.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_mean_flow', 
                                  met.propcode = 'mm6', met.name = 'June Mean Flow', 
                                  met.value = signif(metrics$jun.mean.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_mean_flow', 
                                  met.propcode = 'mm7', met.name = 'July Mean Flow', 
                                  met.value = signif(metrics$jul.mean.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_mean_flow', 
                                  met.propcode = 'mm8', met.name = 'August Mean Flow', 
                                  met.value = signif(metrics$aug.mean.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_mean_flow', 
                                  met.propcode = 'mm9', met.name = 'September Mean Flow', 
                                  met.value = signif(metrics$sep.mean.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_mean_flow', 
                                  met.propcode = 'mm10', met.name = 'October Mean Flow', 
                                  met.value = signif(metrics$oct.mean.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_mean_flow', 
                                  met.propcode = 'mm11', met.name = 'November Mean Flow', 
                                  met.value = signif(metrics$nov.mean.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_mean_flow', 
                                  met.propcode = 'mm12', met.name = 'December Mean Flow', 
                                  met.value = signif(metrics$dec.mean.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_high_flow', 
                                  met.propcode = 'mh1', met.name = 'January High Flow', 
                                  met.value = signif(metrics$jan.high.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_high_flow', 
                                  met.propcode = 'mh2', met.name = 'February High Flow', 
                                  met.value = signif(metrics$feb.high.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_high_flow', 
                                  met.propcode = 'mh3', met.name = 'March High Flow', 
                                  met.value = signif(metrics$mar.high.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_high_flow', 
                                  met.propcode = 'mh4', met.name = 'April High Flow', 
                                  met.value = signif(metrics$apr.high.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_high_flow', 
                                  met.propcode = 'mh5', met.name = 'May High Flow', 
                                  met.value = signif(metrics$may.high.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_high_flow', 
                                  met.propcode = 'mh6', met.name = 'June High Flow', 
                                  met.value = signif(metrics$jun.high.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_high_flow', 
                                  met.propcode = 'mh7', met.name = 'July High Flow', 
                                  met.value = signif(metrics$jul.high.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_high_flow', 
                                  met.propcode = 'mh8', met.name = 'August High Flow', 
                                  met.value = signif(metrics$aug.high.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_high_flow', 
                                  met.propcode = 'mh9', met.name = 'September High Flow', 
                                  met.value = signif(metrics$sep.high.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_high_flow', 
                                  met.propcode = 'mh10', met.name = 'October High Flow', 
                                  met.value = signif(metrics$oct.high.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_high_flow', 
                                  met.propcode = 'mh11', met.name = 'November High Flow', 
                                  met.value = signif(metrics$nov.high.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_high_flow', 
                                  met.propcode = 'mh12', met.name = 'December High Flow', 
                                  met.value = signif(metrics$dec.high.flow, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'min_low_flow', 
                                  met.propcode = 'min1', met.name = '1 Day Min Low Flow', 
                                  met.value = signif(metrics$one.day.min, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'min_low_flow', 
                                  met.propcode = 'min3', met.name = '3 Day Min Low Flow', 
                                  met.value = signif(metrics$three.day.min, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'min_low_flow', 
                                  met.propcode = 'min7', met.name = '7 Day Min Low Flow', 
                                  met.value = signif(metrics$seven.day.min, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'min_low_flow', 
                                  met.propcode = 'min30', met.name = '30 Day Min Low Flow', 
                                  met.value = signif(metrics$thirty.day.min, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'min_low_flow', 
                                  met.propcode = 'min90', met.name = '90 Day Min Low Flow', 
                                  met.value = signif(metrics$ninety.day.min, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'med_low_flow', 
                                  met.propcode = 'medl1', met.name = '1 Day Median Low Flow', 
                                  met.value = signif(metrics$one.day.med.min, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'med_low_flow', 
                                  met.propcode = 'medl3', met.name = '3 Day Median Low Flow', 
                                  met.value = signif(metrics$three.day.med.min, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'med_low_flow', 
                                  met.propcode = 'medl7', met.name = '7 Day Median Low Flow', 
                                  met.value = signif(metrics$seven.day.med.min, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'med_low_flow', 
                                  met.propcode = 'medl30', met.name = '30 Day Median Low Flow', 
                                  met.value = signif(metrics$thirty.day.med.min, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'med_low_flow', 
                                  met.propcode = 'medl90', met.name = '90 Day Median Low Flow', 
                                  met.value = signif(metrics$ninety.day.med.min, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'max_high_flow', 
                                  met.propcode = 'max1', met.name = '1 Day Max High Flow', 
                                  met.value = signif(metrics$one.day.max, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'max_high_flow', 
                                  met.propcode = 'max3', met.name = '3 Day Max High Flow', 
                                  met.value = signif(metrics$three.day.max, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'max_high_flow', 
                                  met.propcode = 'max7', met.name = '7 Day Max High Flow', 
                                  met.value = signif(metrics$seven.day.max, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'max_high_flow', 
                                  met.propcode = 'max30', met.name = '30 Day Max High Flow', 
                                  met.value = signif(metrics$thirty.day.max, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'max_high_flow', 
                                  met.propcode = 'max90', met.name = '90 Day Max High Flow', 
                                  met.value = signif(metrics$ninety.day.max, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'med_high_flow', 
                                  met.propcode = 'medh1', met.name = '1 Day Median High Flow', 
                                  met.value = signif(metrics$one.day.med.max, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'med_high_flow', 
                                  met.propcode = 'medh3', met.name = '3 Day Median High Flow', 
                                  met.value = signif(metrics$three.day.med.max, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'med_high_flow', 
                                  met.propcode = 'medh7', met.name = '7 Day Median High Flow', 
                                  met.value = signif(metrics$seven.day.med.max, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'med_high_flow', 
                                  met.propcode = 'medh30', met.name = '30 Day Median High Flow', 
                                  met.value = signif(metrics$thirty.day.med.max, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'med_high_flow', 
                                  met.propcode = 'medh90', met.name = '90 Day Median High Flow', 
                                  met.value = signif(metrics$ninety.day.med.max, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'non-exceedance', 
                                  met.propcode = 'ne1', met.name = '1% Non-Exceedance Flow', 
                                  met.value = signif(metrics$flow.exceedance.1, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'non-exceedance', 
                                  met.propcode = 'ne5', met.name = '5% Non-Exceedance Flow', 
                                  met.value = signif(metrics$flow.exceedance.5, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'non-exceedance', 
                                  met.propcode = 'ne50', met.name = '50% Non-Exceedance Flow', 
                                  met.value = signif(metrics$flow.exceedance.50, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'non-exceedance', 
                                  met.propcode = 'ne95', met.name = '95% Non-Exceedance Flow', 
                                  met.value = signif(metrics$flow.exceedance.95, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'non-exceedance', 
                                  met.propcode = 'ne99', met.name = '99% Non-Exceedance Flow', 
                                  met.value = signif(metrics$flow.exceedance.99, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'monthly_non-exceedance', 
                                  met.propcode = 'mne9_10', met.name = 'September 10%', 
                                  met.value = signif(metrics$sept.10.percent, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = '7q10', 
                                  met.propcode = '', met.name = '7q10', 
                                  met.value = signif(metrics$sevenQ.ten, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'dor_year', 
                                  met.propcode = '', met.name = 'Year of Drought of Record Occurence', 
                                  met.value = signif(metrics$drought.record, 4), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'dor_mean', 
                                  met.propcode = '', met.name = 'Drought of Record Year Mean Flow', 
                                  met.value = signif(metrics$lowest.yearly.mean, 3), 
                                  site = site, token = token)
  vahydro_post_metric_to_scenprop(scenprop.pid = scenprop.pid, met.varkey = 'baseflow', 
                                  met.propcode = '', met.name = 'Mean Baseflow', 
                                  met.value = signif(metrics$avg.baseflow, 3), 
                                  site = site, token = token)
}

get.overall.vahydro.prop <- function(riv.seg, site, token) {
  # GETTING MODEL DATA FROM VA HYDRO
  hydrocode = paste("vahydrosw_wshed_", riv.seg, sep="");
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list(
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  hydroid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name);
  print(paste("Retrieved hydroid", hydroid, "for", fname, riv.seg, sep=' '));
  
  # GETTING VA HYDRO MODEL ELEMENT FROM VA HYDRO
  inputs <- list(
    varkey = "om_water_model_node",
    featureid = hydroid,
    entity_type = "dh_feature",
    propcode = 'vahydro-1.0'
  )
  
  scenario <- getProperty(inputs, site, scenario)
  
  return(as.numeric(scenario$pid))
}

fn_get_runfile_mod <- function(
  elementid = -1, runid = -1, scenid = 37,
  site = "http://deq2.bse.vt.edu", cached = TRUE, outaszoo=TRUE
) {
  if (elementid == -1 ) {
    return(FALSE);
  }
  if (runid == -1 ) {
    return(FALSE);
  }
  # may be obsolete
  #setInternet2(TRUE)
  
  # just get the run file
  finfo = fn_get_runfile_info(elementid, runid, scenid, site)
  if (!is.list(finfo)) {
    return(FALSE);
  }
  filename = as.character(finfo$remote_url);
  if (filename == '.zip') {
    return(FALSE)
  }
  localname = basename(as.character(finfo$output_file));
  if (cached & file.exists(localname)) {
    linfo = file.info(localname)
    if (as.Date(finfo$run_date) > as.Date(linfo$mtime)) {
      # re-download if the remote is newer than the local
      if (finfo$compressed == 1) {
        print(paste("Downloading Compressed Run File ", filename));
        download.file(filename,'tempfile',mode="wb", method = "libcurl");
        filename <-  unzip ('tempfile');
      } else {
        print(paste("Downloading Un-compressed Run File ", filename));
      }
    } else {
      # not new, so just use the local copy
      print(paste("Remote file date ", as.Date(finfo$run_date), " <= run date ", as.Date(linfo$mtime), "Using cached copy "));
      filename = localname
    }
  } else {
    # does not exist locally
    if (finfo$compressed == 1) {
      print(paste("Downloading Compressed Run File ", filename));
      download.file(filename,'tempfile',mode="wb", method = "libcurl");
      filename <-  unzip ('tempfile');
    }
  }
  dat = try(read.table( filename, header = TRUE, sep = ",")) ;
  if (class(dat)=='try-error') { 
    # what to do if file empty 
    print(paste("Error: empty file ", filename))
    return (FALSE);
  } else { 
    #dat<-read.table(filename, header = TRUE, sep = ",")   #  reads the csv-formatted data from the url	
    print(paste("Data obtained, found ", length(dat[,1]), " lines - formatting for IHA analysis"))
    datv<-as.vector(dat)  # stores the data as a vector     
    datv$timestamp <- as.POSIXct(datv$timestamp,origin="1970-01-01")
    f3 <- zoo(datv, order.by = datv$timestamp)
  }
  unlink('tempfile')
  if(outaszoo){
    return(f3)  
  }else{
    return(datv)  
  }
}

#' Import Metric from VAHydro Function
#' @description Imports metric from VAHydro for a given scenario
#' @param met.varkey input variable key
#' @param met.propcode input prop code
#' @param seg.or.gage indicate segment name or gage number
#' @param mod.scenario input scenario code
#' @param token input token number for access
#' @param site input site name
#' @return metric data
#' @import sp
#' @export vahydro_import_metric

vahydro_import_metric <- function(met.varkey, met.propcode, seg.or.gage, mod.scenario = "p532cal_062211", token, site) {
  if (nchar(seg.or.gage)==8) {
    # GETTING GAGE DATA FROM VA HYDRO
    hydrocode = paste("usgs_",seg.or.gage,sep="");
    ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
    inputs <- list (
      hydrocode = hydrocode
    )
  } else if (nchar(seg.or.gage)==13) {
    # GETTING MODEL DATA FROM VA HYDRO
    hydrocode = paste("vahydrosw_wshed_",seg.or.gage,sep="");
    ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
    inputs <- list (
      hydrocode = hydrocode,
      bundle = 'watershed',
      ftype = 'vahydro'
    )
  }
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  if (odata == FALSE) {
    return(FALSE)
  }
  hydroid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name );
  print(paste("Retrieved hydroid",hydroid,"for", fname,seg.or.gage, sep=' '));
  # get the scenario model segment attached to this river feature
  inputs <- list(
    varkey = "om_model_element",
    featureid = hydroid,
    entity_type = "dh_feature",
    propcode = mod.scenario
  )
  property <- getProperty(inputs, site, property)
  if (property == FALSE) {
    return(FALSE)
  }
  
  metinfo <- list(
    varkey = met.varkey,
    propcode = met.propcode,
    featureid = as.integer(as.character(property$pid)),
    entity_type = "dh_properties"
  )
  metprop <- getProperty(metinfo, site, metprop)
  metric <- metprop$propvalue
  return(metric)
}

vahydro_import_metric_from_scenprop <- function(scenprop.pid, met.varkey, met.propcode, site, token) {
  hydroid = scenprop.pid
  
  metinfo <- list(
    varkey = met.varkey,
    propcode = met.propcode,
    featureid = as.integer(hydroid),
    entity_type = "dh_properties"
  )
  metprop <- getProperty(metinfo, site, metprop)
  
  if (metprop == FALSE) {
    return(FALSE)
  }
  
  return(as.numeric(metprop$propvalue))
}

all_flow_metrics_2_vahydro <- function(scenprop.pid, data, token) {
  
  data <- water_year_trim(data)
  
  # All of this is because this routine does handle sub-daily simulations.
  # and none of this works reliably.
  # Latest testing code does not work:
  #data1 <- zoo(data$flow, order.by = data$date)
  #data2 <- aggregate(data1,as.Date(time(data1)), 'mean')
  #data_dates <- as.character(index(data2))
  #data2 <- as.data.frame(data2)
  #data2$date <- data_dates 
  #names(data2) <- c('flow', 'date')
  #data <- as.zoo(data2, order.by = as.Date(data2$dat))
  #data <- as.zoo(data2, order.by = data2$dat)
  # Previous rtesting code *seemed* to work with hourly data, but fails with daily:
  #data <- aggregate(
  #  data,
  #  as.POSIXct(
  #    format(
  #      time(data), 
  #      format='%Y/%m/%d'),
  #    tz='UTC'
  #  ),
  #  'mean'
  #)
  metrics <- metrics_calc_all(data) #calculate metrics into a matrix
  
  #posts metrics to vahydro
  vahydro_post_metric_to_scenprop(scenprop.pid, 'overall_mean', '', 'Overall Mean Flow', signif(metrics$overall.mean, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml1', 'January Low Flow', signif(metrics$jan.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml2', 'February Low Flow', signif(metrics$feb.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml3', 'March Low Flow', signif(metrics$mar.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml4', 'April Low Flow', signif(metrics$apr.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml5', 'May Low Flow', signif(metrics$may.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml6', 'June Low Flow', signif(metrics$jun.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml7', 'July Low Flow', signif(metrics$jul.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml8', 'August Low Flow', signif(metrics$aug.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml9', 'September Low Flow', signif(metrics$sep.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml10', 'October Low Flow', signif(metrics$oct.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml11', 'November Low Flow', signif(metrics$nov.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml12', 'December Low Flow', signif(metrics$dec.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm1', 'January Mean Flow', signif(metrics$jan.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm2', 'February Mean Flow', signif(metrics$feb.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm3', 'March Mean Flow', signif(metrics$mar.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm4', 'April Mean Flow', signif(metrics$apr.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm5', 'May Mean Flow', signif(metrics$may.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm6', 'June Mean Flow', signif(metrics$jun.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm7', 'July Mean Flow', signif(metrics$jul.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm8', 'August Mean Flow', signif(metrics$aug.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm9', 'September Mean Flow', signif(metrics$sep.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm10', 'October Mean Flow', signif(metrics$oct.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm11', 'November Mean Flow', signif(metrics$nov.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm12', 'December Mean Flow', signif(metrics$dec.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh1', 'January High Flow', signif(metrics$jan.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh2', 'February High Flow', signif(metrics$feb.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh3', 'March High Flow', signif(metrics$mar.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh4', 'April High Flow', signif(metrics$apr.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh5', 'May High Flow', signif(metrics$may.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh6', 'June High Flow', signif(metrics$jun.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh7', 'July High Flow', signif(metrics$jul.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh8', 'August High Flow', signif(metrics$aug.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh9', 'September High Flow', signif(metrics$sep.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh10', 'October High Flow', signif(metrics$oct.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh11', 'November High Flow', signif(metrics$nov.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh12', 'December High Flow', signif(metrics$dec.high.flow, digits =3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min1', '1 Day Min Low Flow', signif(metrics$one.day.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min3', '3 Day Min Low Flow', signif(metrics$three.day.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min7', '7 Day Min Low Flow', signif(metrics$seven.day.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min30', '30 Day Min Low Flow', signif(metrics$thirty.day.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min90', '90 Day Min Low Flow', signif(metrics$ninety.day.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl1', '1 Day Median Low Flow', signif(metrics$one.day.med.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl3', '3 Day Median Low Flow', signif(metrics$three.day.med.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl7', '7 Day Median Low Flow', signif(metrics$seven.day.med.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl30', '30 Day Median Low Flow', signif(metrics$thirty.day.med.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl90', '90 Day Median Low Flow', signif(metrics$ninety.day.med.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max1', '1 Day Max High Flow', signif(metrics$one.day.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max3', '3 Day Max High Flow', signif(metrics$three.day.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max7', '7 Day Max High Flow', signif(metrics$seven.day.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max30', '30 Day Max High Flow', signif(metrics$thirty.day.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max90', '90 Day Max High Flow', signif(metrics$ninety.day.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh1', '1 Day Median High Flow', signif(metrics$one.day.med.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh3', '3 Day Median High Flow', signif(metrics$three.day.med.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh7', '7 Day Median High Flow', signif(metrics$seven.day.med.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh30', '30 Day Median High Flow', signif(metrics$thirty.day.med.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh90', '90 Day Median High Flow', signif(metrics$ninety.day.med.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne1', '1% Non-Exceedance Flow', signif(metrics$flow.exceedance.1, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne5', '5% Non-Exceedance Flow', signif(metrics$flow.exceedance.5, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne50', '50% Non-Exceedance Flow', signif(metrics$flow.exceedance.50, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne95', '95% Non-Exceedance Flow', signif(metrics$flow.exceedance.95, digits =3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne99', '99% Non-Exceedance Flow', signif(metrics$flow.exceedance.99, digits =3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_non-exceedance', 'mne9_10', 'September 10%', signif(metrics$sept.10.percent, digits =3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, '7q10', '', '7q10', signif(metrics$sevenQ.ten, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'dor_year', '', 'Year of Drought of Record Occurence', metrics$drought.record, site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'dor_mean', '', 'Drought of Record Year Mean Flow', signif(metrics$lowest.yearly.mean, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'baseflow', '', 'Mean Baseflow', signif(metrics$avg.baseflow, digits =3), site, token)
}

vahydro_import_all_metrics_from_scenprop <- function(scenprop.pid, site, token) {
  
  metrics <- data.frame(matrix(data=NA, 1,67))
  
  colnames(metrics) <- (c('overall.mean','jan.low.flow','feb.low.flow','mar.low.flow','apr.low.flow','may.low.flow','jun.low.flow','jul.low.flow','aug.low.flow','sep.low.flow','oct.low.flow','nov.low.flow','dec.low.flow',
                          'jan.mean.flow','feb.mean.flow','mar.mean.flow','apr.mean.flow','may.mean.flow','jun.mean.flow','jul.mean.flow','aug.mean.flow','sep.mean.flow','oct.mean.flow','nov.mean.flow','dec.mean.flow',
                          'jan.high.flow','feb.high.flow','mar.high.flow','apr.high.flow','may.high.flow','jun.high.flow','jul.high.flow','aug.high.flow','sep.high.flow','oct.high.flow','nov.high.flow','dec.high.flow',
                          'one.day.min','three.day.min','seven.day.min','thirty.day.min','ninety.day.min','one.day.med.min','three.day.med.min','seven.day.med.min','thirty.day.med.min','ninety.day.med.min',
                          'one.day.max','three.day.max','seven.day.max','thirty.day.max','ninety.day.max','one.day.med.max','three.day.med.max','seven.day.med.max','thirty.day.med.max','ninety.day.med.max', 'lowest.yearly.mean', 
                          'sevenQ.ten', 'drought.record', 'sept.10.percent','flow.exceedance.1','flow.exceedance.5','flow.exceedance.50','flow.exceedance.95','flow.exceedance.99','avg.baseflow'))
  
  overallmean <- vahydro_import_metric_from_scenprop(scenprop.pid, 'overall_mean', '', site, token)
  janlow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_low_flow', 'ml1', site, token)
  feblow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_low_flow', 'ml2', site, token)
  marlow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_low_flow', 'ml3', site, token)
  aprlow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_low_flow', 'ml4', site, token)
  maylow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_low_flow', 'ml5', site, token)
  junlow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_low_flow', 'ml6', site, token)
  jullow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_low_flow', 'ml7', site, token)
  auglow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_low_flow', 'ml8', site, token)
  seplow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_low_flow', 'ml9', site, token)
  octlow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_low_flow', 'ml10', site, token)
  novlow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_low_flow', 'ml11', site, token)
  declow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_low_flow', 'ml12', site, token)
  janmean <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm1', site, token)
  febmean <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm2', site, token)
  marmean <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm3', site, token)
  aprmean <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm4', site, token)
  maymean <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm5', site, token)
  junmean <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm6', site, token)
  julmean <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm7', site, token)
  augmean <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm8', site, token)
  sepmean <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm9', site, token)
  octmean <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm10', site, token)
  novmean <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm11', site, token)
  decmean <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm12', site, token)
  janhigh <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_high_flow', 'mh1', site, token)
  febhigh <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_high_flow', 'mh2', site, token)
  marhigh <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_high_flow', 'mh3', site, token)
  aprhigh <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_high_flow', 'mh4', site, token)
  mayhigh <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_high_flow', 'mh5', site, token)
  junhigh <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_high_flow', 'mh6', site, token)
  julhigh <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_high_flow', 'mh7', site, token)
  aughigh <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_high_flow', 'mh8', site, token)
  sephigh <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_high_flow', 'mh9', site, token)
  octhigh <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_high_flow', 'mh10', site, token)
  novhigh <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_high_flow', 'mh11', site, token)
  dechigh <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_high_flow', 'mh12', site, token)
  minlow1day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'min_low_flow', 'min1', site, token)
  minlow3day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'min_low_flow', 'min3', site, token)
  minlow7day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'min_low_flow', 'min7', site, token)
  minlow30day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'min_low_flow', 'min30', site, token)
  minlow90day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'min_low_flow', 'min90', site, token)
  medlow1day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'med_low_flow', 'medl1', site, token)
  medlow3day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'med_low_flow', 'medl3', site, token)
  medlow7day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'med_low_flow', 'medl7', site, token)
  medlow30day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'med_low_flow', 'medl30', site, token)
  medlow90day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'med_low_flow', 'medl90', site, token)
  maxhigh1day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'max_high_flow', 'max1', site, token)
  maxhigh3day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'max_high_flow', 'max3', site, token)
  maxhigh7day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'max_high_flow', 'max7', site, token)
  maxhigh30day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'max_high_flow', 'max30', site, token)
  maxhigh90day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'max_high_flow', 'max90', site, token)
  medhigh1day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'med_high_flow', 'medh1', site, token)
  medhigh3day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'med_high_flow', 'medh3', site, token)
  medhigh7day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'med_high_flow', 'medh7', site, token)
  medhigh30day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'med_high_flow', 'medh30', site, token)
  medhigh90day <- vahydro_import_metric_from_scenprop(scenprop.pid, 'med_high_flow', 'medh90', site, token)
  droughtmeanflow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'dor_mean', '', site, token)
  sevenq10 <- vahydro_import_metric_from_scenprop(scenprop.pid, '7q10', '', site, token)
  droughtyear <- vahydro_import_metric_from_scenprop(scenprop.pid, 'dor_year', '', site, token)
  sept10 <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_non-exceedance', 'mne9_10', site, token)
  neflow1 <- vahydro_import_metric_from_scenprop(scenprop.pid, 'non-exceedance', 'ne1', site, token)
  neflow5 <- vahydro_import_metric_from_scenprop(scenprop.pid, 'non-exceedance', 'ne5', site, token)
  neflow50 <- vahydro_import_metric_from_scenprop(scenprop.pid, 'non-exceedance', 'ne50', site, token)
  neflow95 <- vahydro_import_metric_from_scenprop(scenprop.pid, 'non-exceedance', 'ne95', site, token)
  neflow99 <- vahydro_import_metric_from_scenprop(scenprop.pid, 'non-exceedance', 'ne99', site, token)
  meanbaseflow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'baseflow', '', site, token)
  
  
  metrics[1,1]=overallmean
  metrics[1,2]=janlow
  metrics[1,3]=feblow
  metrics[1,4]=marlow
  metrics[1,5]=aprlow
  metrics[1,6]=maylow
  metrics[1,7]=junlow
  metrics[1,8]=jullow
  metrics[1,9]=auglow
  metrics[1,10]=seplow
  metrics[1,11]=octlow
  metrics[1,12]=novlow
  metrics[1,13]=declow
  metrics[1,14]=janmean
  metrics[1,15]=febmean
  metrics[1,16]=marmean
  metrics[1,17]=aprmean
  metrics[1,18]=maymean
  metrics[1,19]=junmean
  metrics[1,20]=julmean
  metrics[1,21]=augmean
  metrics[1,22]=sepmean
  metrics[1,23]=octmean
  metrics[1,24]=novmean
  metrics[1,25]=decmean
  metrics[1,26]=janhigh
  metrics[1,27]=febhigh
  metrics[1,28]=marhigh
  metrics[1,29]=aprhigh
  metrics[1,30]=mayhigh
  metrics[1,31]=junhigh
  metrics[1,32]=julhigh
  metrics[1,33]=aughigh
  metrics[1,34]=sephigh
  metrics[1,35]=octhigh
  metrics[1,36]=novhigh
  metrics[1,37]=dechigh
  metrics[1,38]=minlow1day
  metrics[1,39]=minlow3day
  metrics[1,40]=minlow7day
  metrics[1,41]=minlow30day
  metrics[1,42]=minlow90day
  metrics[1,43]=medlow1day
  metrics[1,44]=medlow3day
  metrics[1,45]=medlow7day
  metrics[1,46]=medlow30day
  metrics[1,47]=medlow90day
  metrics[1,48]=maxhigh1day
  metrics[1,49]=maxhigh3day
  metrics[1,50]=maxhigh7day
  metrics[1,51]=maxhigh30day
  metrics[1,52]=maxhigh90day
  metrics[1,53]=medhigh1day
  metrics[1,54]=medhigh3day
  metrics[1,55]=medhigh7day
  metrics[1,56]=medhigh30day
  metrics[1,57]=medhigh90day
  metrics[1,58]=droughtmeanflow
  metrics[1,59]=sevenq10
  metrics[1,60]=droughtyear
  metrics[1,61]=sept10
  metrics[1,62]=neflow1
  metrics[1,63]=neflow5
  metrics[1,64]=neflow50
  metrics[1,65]=neflow95
  metrics[1,66]=neflow99
  metrics[1,67]=meanbaseflow
  
  return(metrics)
}

get.gage.timespan.scen.prop <- function(riv.seg, run.id, site, token) {
  # GETTING MODEL DATA FROM VA HYDRO
  hydrocode = paste("vahydrosw_wshed_", riv.seg, sep="");
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list(
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  
  if (odata == FALSE) {
    return(FALSE)
  }
  
  hydroid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name);
  message(paste("Retrieved hydroid", hydroid, "for", fname, riv.seg, sep=' '));
  
  # GETTING VA HYDRO MODEL ELEMENT FROM VA HYDRO
  inputs <- list(
    varkey = "om_water_model_node",
    featureid = hydroid,
    entity_type = "dh_feature",
    propcode = 'vahydro-1.0')
  
  
  scenario <- getProperty(inputs, site, scenario)
  
  if (scenario == FALSE) {
    return(FALSE)
  }
  
  # DETERMINING PROPNAME AND PROPCODE FOR SCENARIO PROPERTY
  scen.propname <- paste0('runid_', run.id, "_gage_timespan")
  scen.propcode <- ''
  
  # GETTING SCENARIO PROPERTY FROM VA HYDRO
  sceninfo <- list(
    varkey = 'om_scenario',
    propname = scen.propname,
    featureid = as.integer(as.character(scenario$pid)),
    entity_type = "dh_properties",
    propvalue = 0,
    propcode = scen.propcode,
    startdate = NULL,
    enddate = NULL
    # startdate = as.numeric(as.POSIXct(start.date, origin = "1970-01-01", tz = "GMT")),
    # enddate = as.numeric(as.POSIXct(end.date, origin = "1970-01-01", tz = "GMT"))
    # at the moment, there are bugs in startdate and enddate on vahydro
  )
  scenprop <- getProperty(sceninfo, site, scenprop)
  
  # POST PROPERTY IF IT IS NOT YET CREATED
  if (identical(scenprop, FALSE)) {
    message("Creating scenario property to store gage period data")
    # create
    sceninfo$pid = NULL
    postProperty(sceninfo, site, scenprop) 
    message("Reloading Property to get pid")
    scenprop <- getProperty(sceninfo, site, scenprop)
  } else {
    sceninfo$pid = scenprop$pid
  }
  
  
  # RETRIEVING PROPERTY ONE LAST TIME TO RETURN HYDROID OF PROP
  
  if (scenprop == FALSE) {
    return(FALSE)
  }
  
  return(as.numeric(scenprop$pid))
}

get.cbp.scen.prop <- function(riv.seg, mod.scenario, dat.source, run.id, start.date, end.date, site, token) {
  # GETTING MODEL DATA FROM VA HYDRO
  hydrocode = paste("vahydrosw_wshed_", riv.seg, sep="");
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list(
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  
  if (odata == FALSE) {
    return(FALSE)
  }
  
  hydroid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name);
  print(paste("Retrieved hydroid", hydroid, "for", fname, riv.seg, sep=' '));
  
  if (dat.source == 'cbp_model') {
    # GETTING SCENARIO MODEL ELEMENT FROM VA HYDRO
    inputs <- list(
      varkey = "om_model_element",
      featureid = hydroid,
      entity_type = "dh_feature",
      propcode = mod.scenario
    )
  } else if (dat.source == 'vahydro') {
    # GETTING VA HYDRO MODEL ELEMENT FROM VA HYDRO
    inputs <- list(
      varkey = "om_water_model_node",
      featureid = hydroid,
      entity_type = "dh_feature",
      propcode = 'vahydro-1.0'
    )
  } else {
    stop('Error: data source is neither "cbp_model" nor "vahydro"')
  }
  
  scenario <- getProperty(inputs, site, scenario)
  
  if (scenario == FALSE) {
    return(FALSE)
  }
  
  # DETERMINING PROPNAME AND PROPCODE FOR SCENARIO PROPERTY
  if (dat.source == 'cbp_model') {
    scen.propname <- mod.scenario
    scen.propcode <- mod.scenario
  } else if (dat.source == 'vahydro') {
    scen.propname <- paste0('runid_', run.id)
    scen.propcode <- ''
  } else {
    stop('Error: data source is neither "cbp_model" nor "vahydro"')
  }
  
  return(as.numeric(scenario$pid))
}

automated_metric_2_vahydro <- function(dat.source, riv.seg, gage_number, run.id, gage.timespan.trimmed, mod.phase, mod.scenario, start.date, end.date, github_link, site, site.or.server = 'site', token) {
  # NOTE! This function is deprecated because it retrieves data, calcs and stores in one
  #    This reduces flexibility since function calcution routines should be agnostic 
  #    as to their data source, they should just expect properly formattted data and 
  #    calculate metrics
  # Use "all_flow_metrics_2_vahydro" instead
  # LOADING DATA ------------------------------------------------------------
  if (dat.source == 'vahydro') {
    data <- vahydro_import_data_cfs(riv.seg, run.id, token, site, start.date, end.date)
    if (gage.timespan.trimmed == TRUE) {
      scenprop.pid <- get.gage.timespan.scen.prop(riv.seg, run.id, site, token)
    } else if (gage.timespan.trimmed == FALSE) {
      scenprop.pid <- get.scen.prop(riv.seg, 'vahydro-1.0', dat.source, run.id, start.date, end.date, site, token)
    }
  } else if (dat.source == 'gage') {
    data <- gage_import_data_cfs(gage_number, start.date, end.date)
    scenprop.pid <- get.scen.prop(riv.seg, 'usgs-1.0', 'gage', run.id, start.date, end.date, site, token)
  } else if (dat.source == 'cbp_model') {
    scenprop.pid <- get.cbp.scen.prop(riv.seg, mod.scenario, dat.source, run.id, start.date, end.date, site, token)
    if (site.or.server == 'site') {
      data <- model_import_data_cfs(riv.seg, mod.phase, mod.scenario, start.date, end.date)
    } else if (site.or.server == 'server') {
      data <- model_server_import_data_cfs(riv.seg, mod.phase, mod.scenario, start.date, end.date)
    }
  }
  
  data <- water_year_trim(data)
  metrics <- metrics_calc_all(data) #calculate metrics into a matrix
  
  #posts metrics to vahydro
  vahydro_post_metric_to_scenprop(scenprop.pid, 'overall_mean', '', 'Overall Mean Flow', signif(metrics$overall.mean, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml1', 'January Low Flow', signif(metrics$jan.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml2', 'February Low Flow', signif(metrics$feb.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml3', 'March Low Flow', signif(metrics$mar.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml4', 'April Low Flow', signif(metrics$apr.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml5', 'May Low Flow', signif(metrics$may.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml6', 'June Low Flow', signif(metrics$jun.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml7', 'July Low Flow', signif(metrics$jul.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml8', 'August Low Flow', signif(metrics$aug.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml9', 'September Low Flow', signif(metrics$sep.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml10', 'October Low Flow', signif(metrics$oct.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml11', 'November Low Flow', signif(metrics$nov.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml12', 'December Low Flow', signif(metrics$dec.low.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm1', 'January Mean Flow', signif(metrics$jan.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm2', 'February Mean Flow', signif(metrics$feb.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm3', 'March Mean Flow', signif(metrics$mar.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm4', 'April Mean Flow', signif(metrics$apr.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm5', 'May Mean Flow', signif(metrics$may.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm6', 'June Mean Flow', signif(metrics$jun.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm7', 'July Mean Flow', signif(metrics$jul.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm8', 'August Mean Flow', signif(metrics$aug.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm9', 'September Mean Flow', signif(metrics$sep.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm10', 'October Mean Flow', signif(metrics$oct.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm11', 'November Mean Flow', signif(metrics$nov.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm12', 'December Mean Flow', signif(metrics$dec.mean.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh1', 'January High Flow', signif(metrics$jan.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh2', 'February High Flow', signif(metrics$feb.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh3', 'March High Flow', signif(metrics$mar.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh4', 'April High Flow', signif(metrics$apr.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh5', 'May High Flow', signif(metrics$may.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh6', 'June High Flow', signif(metrics$jun.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh7', 'July High Flow', signif(metrics$jul.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh8', 'August High Flow', signif(metrics$aug.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh9', 'September High Flow', signif(metrics$sep.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh10', 'October High Flow', signif(metrics$oct.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh11', 'November High Flow', signif(metrics$nov.high.flow, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh12', 'December High Flow', signif(metrics$dec.high.flow, digits =3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min1', '1 Day Min Low Flow', signif(metrics$one.day.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min3', '3 Day Min Low Flow', signif(metrics$three.day.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min7', '7 Day Min Low Flow', signif(metrics$seven.day.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min30', '30 Day Min Low Flow', signif(metrics$thirty.day.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min90', '90 Day Min Low Flow', signif(metrics$ninety.day.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl1', '1 Day Median Low Flow', signif(metrics$one.day.med.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl3', '3 Day Median Low Flow', signif(metrics$three.day.med.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl7', '7 Day Median Low Flow', signif(metrics$seven.day.med.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl30', '30 Day Median Low Flow', signif(metrics$thirty.day.med.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl90', '90 Day Median Low Flow', signif(metrics$ninety.day.med.min, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max1', '1 Day Max High Flow', signif(metrics$one.day.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max3', '3 Day Max High Flow', signif(metrics$three.day.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max7', '7 Day Max High Flow', signif(metrics$seven.day.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max30', '30 Day Max High Flow', signif(metrics$thirty.day.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max90', '90 Day Max High Flow', signif(metrics$ninety.day.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh1', '1 Day Median High Flow', signif(metrics$one.day.med.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh3', '3 Day Median High Flow', signif(metrics$three.day.med.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh7', '7 Day Median High Flow', signif(metrics$seven.day.med.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh30', '30 Day Median High Flow', signif(metrics$thirty.day.med.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh90', '90 Day Median High Flow', signif(metrics$ninety.day.med.max, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne1', '1% Non-Exceedance Flow', signif(metrics$flow.exceedance.1, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne5', '5% Non-Exceedance Flow', signif(metrics$flow.exceedance.5, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne50', '50% Non-Exceedance Flow', signif(metrics$flow.exceedance.50, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne95', '95% Non-Exceedance Flow', signif(metrics$flow.exceedance.95, digits =3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne99', '99% Non-Exceedance Flow', signif(metrics$flow.exceedance.99, digits =3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_non-exceedance', 'mne9_10', 'September 10%', signif(metrics$sept.10.percent, digits =3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, '7q10', '', '7q10', signif(metrics$sevenQ.ten, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'dor_year', '', 'Year of Drought of Record Occurence', metrics$drought.record, site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'dor_mean', '', 'Drought of Record Year Mean Flow', signif(metrics$lowest.yearly.mean, digits = 3), site, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'baseflow', '', 'Mean Baseflow', signif(metrics$avg.baseflow, digits =3), site, token)
}
get.gage.timespan <- function(gage_number, start.date = '1984-01-01', end.date = '2014-12-31') {
  temp.dat <- gage_import_data_cfs(site_number = gage_number, start.date = start.date, end.date = end.date)
  
  gage.start.date <- temp.dat$date[1]
  gage.end.date <- temp.dat$date[length(temp.dat$date)]
  
  return(list(gage.start.date, gage.end.date))
}

post.gage.scen.prop <- function(riv.seg, gage.title, site, token) {
  # GETTING MODEL DATA FROM VA HYDRO
  hydrocode = paste("vahydrosw_wshed_", riv.seg, sep="");
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list(
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  
  if (odata == FALSE) {
    return(FALSE)
  }
  
  hydroid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name);
  print(paste("Retrieved hydroid", hydroid, "for", fname, riv.seg, sep=' '));
  
  inputs <- list(
    featureid = hydroid,
    entity_type = "dh_feature",
    propname = gage.title,
    propcode = 'usgs-1.0'
  )
  
  scenario <- getProperty(inputs, site, scenario)
  
  # POST PROPERTY IF IT IS NOT YET CREATED
  if (identical(scenario, FALSE)) {
    # create
    inputs$pid = NULL
    inputs$varkey = "om_model_element"
    postProperty(inputs, site, scenprop) 
  } else {
    inputs$pid = scenario$pid
  }
  
  
  # RETRIEVING PROPERTY ONE LAST TIME TO RETURN HYDROID OF PROP
  scenprop <- getProperty(inputs, site, scenprop)
  
  if (scenprop == FALSE) {
    return(FALSE)
  }
  
  return(as.numeric(scenprop$pid))
}


vahydro_import_om_class_constant_from_scenprop <- function(scenprop.pid, met.varkey, met.propcode, met.propname, site, token) {
  hydroid = scenprop.pid
  
  metinfo <- list(
    varkey = met.varkey,
    propcode = met.propcode,
    propname = met.propname,
    featureid = as.integer(hydroid),
    entity_type = "dh_properties"
  )
  metprop <- getProperty(metinfo, site, metprop)
  
  if (metprop == FALSE) {
    return(FALSE)
  }
  
  return(as.numeric(metprop$propvalue))
}

get.riv.chan.prop <- function(riv.seg, site, token) {
  # GETTING MODEL DATA FROM VA HYDRO
  hydrocode = paste("vahydrosw_wshed_", riv.seg, sep="");
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list(
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  
  if (odata == FALSE) {
    return(FALSE)
  }
  
  hydroid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name);
  print(paste("Retrieved hydroid", hydroid, "for", fname, riv.seg, sep=' '));
  
  # GETTING VA HYDRO MODEL ELEMENT FROM VA HYDRO
  inputs <- list(
    varkey = "om_water_model_node",
    featureid = hydroid,
    entity_type = "dh_feature",
    propcode = 'vahydro-1.0')
  
  
  scenario <- getProperty(inputs, site, scenario)
  
  if (scenario == FALSE) {
    return(FALSE)
  }
  
  # DETERMINING PROPNAME AND PROPCODE FOR SCENARIO PROPERTY
  scen.propname <- '0. River Channel'
  scen.propcode <- 'vahydro-1.0'
  
  # GETTING SCENARIO PROPERTY FROM VA HYDRO
  sceninfo <- list(
    varkey = 'om_USGSChannelGeomObject',
    propname = scen.propname,
    featureid = as.integer(as.character(scenario$pid)),
    entity_type = "dh_properties",
    propvalue = 0,
    propcode = scen.propcode,
    startdate = NULL,
    enddate = NULL
    # startdate = as.numeric(as.POSIXct(start.date, origin = "1970-01-01", tz = "GMT")),
    # enddate = as.numeric(as.POSIXct(end.date, origin = "1970-01-01", tz = "GMT"))
    # at the moment, there are bugs in startdate and enddate on vahydro
  )
  scenprop <- getProperty(sceninfo, site, scenprop)
  
  if (scenprop == FALSE) {
    return(FALSE)
  }
  
  return(as.numeric(scenprop$pid))
}


vahydro_import_metric_from_scenprop_propname <- function(scenprop.pid, met.varkey, met.propcode, site, token, met.propname) {
  hydroid = scenprop.pid
  
  metinfo <- list(
    varkey = met.varkey,
    propcode = met.propcode,
    propname = met.propname,
    featureid = as.integer(hydroid),
    entity_type = "dh_properties"
  )
  metprop <- getProperty(metinfo, site, metprop)
  
  if (metprop == FALSE) {
    return(FALSE)
  }
  
  return(as.numeric(metprop$propvalue))
}

getWatershedDF <- function(geom){
  
  watershed_geom <- readWKT(geom)
  watershed_geom_clip <- gIntersection(bb, watershed_geom)
  if (is.null(watershed_geom_clip)) {
    watershed_geom_clip = watershed_geom
  }
  wsdataProjected <- SpatialPolygonsDataFrame(watershed_geom_clip,data.frame("id"), match.ID = FALSE)
  wsdataProjected@data$id <- rownames(wsdataProjected@data)
  watershedPoints <- fortify(wsdataProjected, region = "id")
  watershedDF <- merge(watershedPoints, wsdataProjected@data, by = "id")
  
  return(watershedDF)
}

lutablegen <- function(land.segment, basepath, lu.scenario, ccextra = FALSE) {
  # INPUTS ----------
  lufile.list <- list.files(paste0(basepath, '/input/scenario/river/land_use/'),pattern=lu.scenario)
  if (!is.logical(ccextra)) {
    lufile.list <- rbind(lufile.list, ccextra)
  }
  lutable_yrs = FALSE
  for (i in 1:length(lufile.list)) {
    lufile <- lufile.list[i]
    luyear <- substr(lufile, 10,13)
    luyearfile <- paste0(basepath,'/input/scenario/river/land_use/', lufile)
    print(paste("Opening", luyearfile))
    luyeardata <- read.csv(luyearfile)
    q = paste0(
      "select ", luyear, " as thisyear, ",
      "luyeardata.* ",
      "from luyeardata where ",
      "landseg = '", land.segment, 
      "' and riverseg = '", river.segment, "'"
    )
    lutable <- sqldf(q)
    if (!is.logical(lutable_yrs)) {
      lutable <- lutable[,names(lutable_yrs)]
      q <- "select * from lutable_yrs UNION select * from lutable "
    } else {
      q <- " select * from lutable "
    }
    lutable_yrs <- sqldf(q)
  }
  lus <- names(lutable_yrs) 
  # Fix the funky "for." on the forest column name 
  # do it on all in case there are other odd ones 
  lus <- lapply(lus, function(x) gsub("[.]", "", x)) 
  names(lutable_yrs) <- lus 
  return(lutable_yrs)
}

land.use.eos.all <- function(land.segment, wdmpath, mod.scenario, outpath) {
  # INPUTS ----------
  land.use.list <- list.dirs(paste0(wdmpath, "/tmp/wdm/land"), full.name = FALSE, recursive = FALSE)
  dsn.list <- data.frame(dsn = c('0111', '0211', '0411'), dsn.label = c('suro', 'ifwo', 'agwo'))
  
  # READING IN AND DELETING READ-IN LAND USE DATA FROM MODEL ----------
  counter <- 1
  total.files <- as.integer(length(land.use.list)*length(dsn.list$dsn))
  for (i in 1:length(dsn.list$dsn)) {
    for (j in 1:length(land.use.list)) {
      input.data.namer <- paste0(land.segment,land.use.list[j],dsn.list$dsn[i])
      print(paste("Downloading", counter, "of", total.files))
      counter <- counter+1
      temp.data.input <- try(read.csv(paste0(wdmpath, "/tmp/wdm/land/",land.use.list[j],"/",mod.scenario,"/",land.use.list[j],land.segment,"_",dsn.list$dsn[i],".csv")))
      if (class(temp.data.input) == 'try-error') {
        stop(paste0("ERROR: Missing land use .csv files (including ", wdmpath, "/tmp/wdm/land/",land.use.list[j],"/",mod.scenario,"/",land.use.list[j],land.segment,"_",dsn.list$dsn[i],".csv", ")"))
      }
      colnames(temp.data.input) <- c('Year', 'Month', 'Day', 'Hour', as.character(dsn.list$dsn.label[i]))
      temp.data.input$thisdate <- strptime(paste(temp.data.input$Year, "-", temp.data.input$Month, "-", temp.data.input$Day, ":", temp.data.input$Hour, sep = ""), format = "%Y-%m-%d:%H")
      temp.data.formatter <- data.frame(temp.data.input$thisdate, temp.data.input[5])
      colnames(temp.data.formatter) <- c('thisdate', colnames(temp.data.input[5]))
      assign(input.data.namer,temp.data.formatter)
      # Deleting read in file:
      command <- paste0('rm ', wdmpath, "/tmp/wdm/land/",land.use.list[j],"/",mod.scenario,"/",land.use.list[j],land.segment,"_",dsn.list$dsn[i],".csv")
      system(command)
    }
  }
  
  # COMBINING DATA FROM EACH TYPE OF FLOW INTO A SINGLE DATA FRAME ----------
  dsn.namer <- ''
  for (i in 1:length(dsn.list$dsn)) {
    dsn.namer <- paste0(dsn.namer, dsn.list$dsn[i], '-')
  }
  dsn.namer <- substr(dsn.namer, 1, nchar(dsn.namer)-1) 
  overall.data.namer <- paste(land.segment, "_", dsn.namer, sep = '')
  counter <- 1
  for (i in 1:length(land.use.list)) {
    for (j in 1:length(dsn.list$dsn)) {
      input.data.namer <- paste0(land.segment,land.use.list[i],dsn.list$dsn[j])
      temp.data.holder <- get(input.data.namer)
      if (counter == 1) {
        overall.data.builder <- temp.data.holder
        names(overall.data.builder)[2] <- paste(land.use.list[i], colnames(temp.data.holder[2]), sep = "_") 
      } else {
        overall.data.builder[,counter+1] <- temp.data.holder[,2]
        names(overall.data.builder)[names(overall.data.builder) == paste0('V', counter+1)] <- paste(land.use.list[i], colnames(temp.data.holder[2]), sep = '_')
      }
      counter <- counter + 1
    }
  }
  assign(overall.data.namer,overall.data.builder)
  saved.file <- paste0(outpath, "/", overall.data.namer, ".csv")
  write.csv(overall.data.builder, saved.file, row.names = FALSE)
  return(saved.file)
}

land.use.wdm.export.all <- function(land.segment, wdmpath, mod.scenario, start.year, end.year) {
  # land.use.list <- c('afo', 'alf', 'ccn', 'cex', 'cfo', 'cid', 'cpd', 'for', 'hom', 'hvf',
  #                    'hwm', 'hyo', 'hyw', 'lwm', 'nal', 'nex', 'nhi', 'nho', 'nhy', 'nid',
  #                    'nlo', 'npa', 'npd', 'pas', 'rcn', 'rex', 'rid', 'rpd', 'trp', 'urs')
  land.use.list <- list.dirs(paste0(wdmpath, "/tmp/wdm/land"), full.name = FALSE, recursive = FALSE)
  dsn.list <- c('111','211','411')
  
  # SETTING UP LOOPS TO GENERATE ALL LAND USE UNIT FLOWS
  counter <- 1
  total.files <- as.integer(length(land.use.list)*length(dsn.list))
  
  for (i in 1:length(dsn.list)) {
    for (j in 1:length(land.use.list)) {
      wdm.location <- paste(wdmpath, '/tmp/wdm/land/', land.use.list[j], '/', mod.scenario, sep = '')
      wdm.name <- paste0(land.use.list[j],land.segment,'.wdm')
      
      # SETTING UP AND RUNNING COMMAND LINE COMMANDS
      setwd(wdm.location)
      # cd.to.wdms <- paste('cd ', wdm.location, sep = '')
      # exec_wait(cmd = cd.to.wdms)
      
      print(paste("Creating unit flow .csv for ", counter, "of", total.files))
      
      quick.wdm.2.txt.inputs <- paste(paste0(land.use.list[j],land.segment,'.wdm'), start.year, end.year, dsn.list[i], sep = ',')
      run.quick.wdm.2.txt <- paste("echo", quick.wdm.2.txt.inputs, "| /opt/model/p6-devel/p6-4.2018/code/bin/quick_wdm_2_txt_hour_2_hour", sep = ' ')
      system(command = run.quick.wdm.2.txt)
      
      # INCREMENTING COUNTER
      counter <- counter+1
    }
  }
}
