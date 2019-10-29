library(dataRetrieval)
library(httr)

model_import_data_cfs <- function(riv.seg, mod.phase, mod.scenario, start.date, end.date) {
  # Downloading and exporting hourly model data
  model_hourly <- read.csv(paste0("http://deq2.bse.vt.edu/", mod.phase, "/out/river/", mod.scenario, "/stream/", 
                                  riv.seg, "_0111.csv"), header = FALSE, sep = ",", stringsAsFactors = FALSE); 
  riv.segStr1 <- strsplit(riv.seg, "\\+")
  riv.segStr1 <- riv.segStr1[[1]]
  num.segs1 <- length(riv.segStr1)
  model_days1 <- length(seq(as.Date(start.date):as.Date(end.date)))
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
  model_daily$flow <- signif(model_daily$flow * 0.504167, digits=3) # conversion from acre-feet to cfs
  return(model_daily)
}

model_server_import_data_cfs <- function(riv.seg, mod.phase, mod.scenario, start.date, end.date) {
  # Downloading and exporting hourly model data
  model_hourly <- read.csv(paste0("/opt/model/", mod.phase, "/out/river/", mod.scenario, "/stream/", 
                                  riv.seg, "_0111.csv"), header = FALSE, sep = ",", stringsAsFactors = FALSE); 
  riv.segStr1 <- strsplit(riv.seg, "\\+")
  riv.segStr1 <- riv.segStr1[[1]]
  num.segs1 <- length(riv.segStr1)
  model_days1 <- length(seq(as.Date(start.date):as.Date(end.date)))
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
  model_daily$flow <- signif(model_daily$flow * 0.504167, digits=3) # conversion from acre-feet to cfs
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
  one.pct.non.exceedance <- vahydro.import.metric(met.varkey = "non-exceedance", met.propcode = 'ne1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  five.pct.non.exceedance <- vahydro.import.metric(met.varkey = "non-exceedance", met.propcode = 'ne5', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  fifty.pct.non.exceedance <- vahydro.import.metric(met.varkey = "non-exceedance", met.propcode = 'ne50', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  ninety.five.pct.non.exceedance <- vahydro.import.metric(met.varkey = "non-exceedance", met.propcode = 'ne95', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  ninety.nine.pct.non.exceedance <- vahydro.import.metric(met.varkey = "non-exceedance", met.propcode = 'ne99', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  sep.ten.pct <- vahydro.import.metric(met.varkey = "monthly_non-exceedance", met.propcode = 'mne9_10', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  seven.q.ten <- vahydro.import.metric(met.varkey = "7q10", met.propcode = '', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  drought.of.record.year <- vahydro.import.metric(met.varkey = "dor_year", met.propcode = '', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  drought.of.record.mean <- vahydro.import.metric(met.varkey = "dor_mean", met.propcode = '', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
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
                        one.day.med.high, three.day.med.high, seven.day.med.high, thirty.day.med.high, ninety.day.med.high,
                        one.pct.non.exceedance, five.pct.non.exceedance, fifty.pct.non.exceedance,
                        ninety.five.pct.non.exceedance, ninety.nine.pct.non.exceedance, sep.ten.pct,
                        seven.q.ten, drought.of.record.year, drought.of.record.mean, mean.baseflow)
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
  base <- signif(mean(model1river$baseflow), digits=3);
  return(base)
}

# Monthly High Calculation DONE
monthly_max <- function(data, num.month) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_maxs <- zoo(data$flow, order.by = data$date)
  max_flows <- signif(fn_iha_mhf(monthly_maxs,num.month), digits=3);
  return(max_flows)
}

# Monthly Low Calculation DONE
monthly_min <- function(data, num.month) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_mins <- zoo(data$flow, order.by = data$date)
  min_flows <- signif(fn_iha_mlf(monthly_mins,num.month), digits=3);
  return(min_flows)
}

# Monthly Mean Calculation DONE
monthly_mean <- function(data, num.month) {
  # Setup for Monthly Means Calculations
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_means <- signif(aggregate(data$flow, list(data$month), FUN = mean),digits = 3)
  mean_flows <- monthly_means[num.month,2]
  return(mean_flows)
}

# Flow Exceedance Calculation DONE
flow_exceedance <- function(data, prob) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  dec_flows <- sort(data$flow, decreasing = TRUE)
  prob_exceedance <- signif(quantile(dec_flows, prob), digits = 3)
  return(prob_exceedance)
}

# September 10% Flow Calculation DONE
sept_10_flow <- function(data) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  sept_flows <- subset(data, month == '9')
  sept_10 <- signif(quantile(sept_flows$flow, 0.10), digits = 3)
  return(sept_10)
}

# Overall Mean Flow Calculation DONE
overall_mean_flow <- function(data) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  mean.flow <- signif(mean(data$flow), digits=3);
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
  mod_7Q10 <- signif(fn_iha_7q10(flows_model1), digits=3);
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
      metric <- signif(min(g2$'1 Day Min'), digits=3)}
    else if (num.day == 3){
      metric <- signif(min(g2$'3 Day Min'), digits=3)}
    else if (num.day == 7){
      metric <- signif(min(g2$'7 Day Min'), digits=3)}
    else if (num.day == 30){
      metric <- signif(min(g2$'30 Day Min'), digits=3)}
    else if (num.day == 90){
      metric <- signif(min(g2$'90 Day Min'), digits=3)}
  }
  if (min_or_med == "med"){  
    if (num.day == 1) {
      metric <- signif(median(g2$'1 Day Min'), digits=3)}
    else if (num.day == 3){
      metric <- signif(median(g2$'3 Day Min'), digits=3)}
    else if (num.day == 7){
      metric <- signif(median(g2$'7 Day Min'), digits=3)}
    else if (num.day == 30){
      metric <- signif(median(g2$'30 Day Min'), digits=3)}
    else if (num.day == 90){
      metric <- signif(median(g2$'90 Day Min'), digits=3)}
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
      metric <- signif(max(g2$'1 Day Max'), digits=3)}
    else if (num.day == 3){
      metric <- signif(max(g2$'3 Day Max'), digits=3)}
    else if (num.day == 7){
      metric <- signif(max(g2$'7 Day Max'), digits=3)}
    else if (num.day == 30){
      metric <- signif(max(g2$'30 Day Max'), digits=3)}
    else if (num.day == 90){
      metric <- signif(max(g2$'90 Day Max'), digits=3)}
  }
  if (max_or_med == "med"){  
    if (num.day == 1) {
      metric <- signif(median(g2$'1 Day Max'), digits=3)}
    else if (num.day == 3){
      metric <- signif(median(g2$'3 Day Max'), digits=3)}
    else if (num.day == 7){
      metric <- signif(median(g2$'7 Day Max'), digits=3)}
    else if (num.day == 30){
      metric <- signif(median(g2$'30 Day Max'), digits=3)}
    else if (num.day == 90){
      metric <- signif(median(g2$'90 Day Max'), digits=3)}
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
  lf_model <- signif(lf_model[lf_model_flow,2], digits = 3)
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
  dor_flow = round(loflows[ndx,]$"90 Day Min",1);
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


rest_token <- function(base_url, token, rest_uname = FALSE, rest_pw = FALSE) {
  
  #Cross-site Request Forgery Protection (Token required for POST and PUT operations)
  csrf_url <- paste(base_url,"restws/session/token/",sep="/");
  
  #IF THE OBJECTS 'rest_uname' or 'rest_pw' DONT EXIST, USER INPUT REQUIRED
  if (!is.character(rest_uname) | !(is.character(rest_pw))){
    
    rest_uname <- c() #initialize username object
    rest_pw <- c()    #initialize password object
    
    #currently set up to allow infinite login attempts, but this can easily be restricted to a set # of attempts
    token <- c("rest_uname","rest_pw") #used in while loop below, "length of 2"
    login_attempts <- 1
    if (!is.character(rest_uname)) {
      print(paste("REST AUTH INFO MUST BE SUPPLIED",sep=""))
      while(length(token) == 2  && login_attempts <= 5){
        print(paste("login attempt #",login_attempts,sep=""))
        
        rest_uname <- readline(prompt="Enter REST user name: ")
        rest_pw <- readline(prompt="Password: ")
        csrf <- GET(url=csrf_url,authenticate(rest_uname,rest_pw));
        token <- content(csrf);
        #print(token)
        
        if (length(token)==2){
          print("Sorry, unrecognized username or password")
        }
        login_attempts <- login_attempts + 1
      }
      if (login_attempts > 5){print(paste("ALLOWABLE NUMBER OF LOGIN ATTEMPTS EXCEEDED"))}
    }
    
  } else {
    print(paste("REST AUTH INFO HAS BEEN SUPPLIED",sep=""))
    print(paste("RETRIEVING REST TOKEN",sep=""))
    csrf <- GET(url=csrf_url,authenticate(rest_uname,rest_pw));
    token <- content(csrf);
  }
  
  if (length(token)==1){
    print("Login attempt successful")
    print(paste("token = ",token,sep=""))
  } else {
    print("Login attempt unsuccessful")
  }
  token <- token
} #close function

fn_upstream <- function(riv.seg, AllSegList) {
  library(stringr)
  library(rapportools)
  # Create dataframe for upstream and downstream segments based on code in string
  ModelSegments <- data.frame(matrix(nrow = length(AllSegList), ncol = 5))
  colnames(ModelSegments)<- c('RiverSeg', 'Middle', 'Last', 'Downstream', 'Upstream')
  ModelSegments$RiverSeg <- AllSegList
  
  # Pull out 4 digit codes in middle and end for upstream/downstream segments
  i <- 1
  for (i in 1:nrow(ModelSegments)){
    
    ModelSegments[i,2]<- str_sub(ModelSegments[i,1], start=5L, end=8L)
    ModelSegments[i,3]<- str_sub(ModelSegments[i,1], start=10L, end=-1L)
    i <- i + 1
  }
  
  # Determine Downstream Segment ----------
  j <- 1
  for (j in 1:nrow(ModelSegments)){
    Downstream <- which(ModelSegments$Middle==ModelSegments$Last[j])
    if (length(Downstream)==0){
      ModelSegments[j,4]  <- 'NA'
    }else if (length(Downstream)!=0){
      ModelSegments[j,4] <- as.character(ModelSegments[Downstream,1])
    }
    j<-j+1
  }
  # Determine Upstream Segment ----------
  k<-1
  for (k in 1:nrow(ModelSegments)){
    Upstream <- which(as.character(ModelSegments$Downstream)==as.character(ModelSegments$RiverSeg[k]))
    NumUp <- ModelSegments$RiverSeg[Upstream]
    ModelSegments[k,5]<- paste(NumUp, collapse = '+')
    if (is.empty(ModelSegments[k,5])==TRUE){
      ModelSegments[k,5]<- 'NA'
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

getProperty <- function(inputs, base_url, prop){
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


postProperty <- function(inputs,base_url,prop){
  
  #inputs <-prop_inputs
  #base_url <- site
  #Search for existing property matching supplied varkey, featureid, entity_type 
  dataframe <- getProperty(inputs, base_url, prop)
  if (is.data.frame(dataframe)) {
    pid <- as.character(dataframe$pid)
  } else {
    pid = NULL
  }
  if (!is.null(inputs$varkey)) {
    # this would use REST 
    # getVarDef(list(varkey = inputs$varkey), token, base_url)
    # but it is broken for vardef for now metadatawrapper fatal error
    # EntityMetadataWrapperException: Invalid data value given. Be sure it matches the required data type and format. 
    # in EntityDrupalWrapper->set() 
    # (line 736 of /var/www/html/d.dh/modules/entity/includes/entity.wrapper.inc).
    
    propdef_url<- paste(base_url,"/?q=vardefs.tsv/",inputs$varkey,sep="")
    propdef_table <- read.table(propdef_url,header = TRUE, sep = "\t")    
    varid <- propdef_table[1][which(propdef_table$varkey == inputs$varkey),]
    print(paste("varid: ",varid,sep=""))
    if (is.null(varid)) {
      # we sent a bad variable id so we should return FALSE
      return(FALSE)
    }
  }
  if (!is.null(inputs$varid)) {
    varid = inputs$varid
  }
  
  if (is.null(varid)) {
    print("Variable IS is null - returning.")
    return(FALSE)
  }
  
  pbody = list(
    bundle = 'dh_properties',
    featureid = inputs$featureid,
    varid = varid,
    entity_type = inputs$entity_type,
    proptext = inputs$proptext,
    propvalue = inputs$propvalue,
    propcode = inputs$propcode,
    startdate = inputs$startdate,
    propname = inputs$propname,
    enddate = inputs$enddate
  );
  
  if (is.null(pid)){
    print("Creating Property...")
    prop <- POST(paste(base_url,"/dh_properties/",sep=""), 
                 add_headers(HTTP_X_CSRF_TOKEN = token),
                 body = pbody,
                 encode = "json"
    );
    #content(prop)
    if (prop$status == 201){prop <- paste("Status ",prop$status,", Property Created Successfully",sep="")
    } else {prop <- paste("Status ",prop$status,", Error: Property Not Created Successfully",sep="")}
    
  } else if (length(dataframe$pid) == 1){
    print("Single Property Exists, Updating...")
    print(paste("Posting", pbody$varid )) 
    print(pbody) 
    #pbody$pid = pid
    prop <- PUT(paste(base_url,"/dh_properties/",pid,sep=""), 
                add_headers(HTTP_X_CSRF_TOKEN = token),
                body = pbody,
                encode = "json"
    );
    #content(prop)
    if (prop$status == 200){prop <- paste("Status ",prop$status,", Property Updated Successfully",sep="")
    } else {prop <- paste("Status ",prop$status,", Error: Property Not Updated Successfully",sep="")}
  } else {
    prop <- print("Multiple Properties Exist, Execution Halted")
  }
  
}

getFeature <- function(inputs, token, base_url, feature){
  #inputs <-    conveyance_inputs 
  #base_url <- site
  #print(inputs)
  pbody = list(
    hydroid = inputs$hydroid,
    bundle = inputs$bundle,
    ftype = inputs$ftype,
    hydrocode = inputs$hydrocode
  );
  
  
  if (!is.null(inputs$hydroid)) {
    if (inputs$hydroid > 0) {
      # forget about other attributes, just use hydroid if provided 
      pbody = list(
        hydroid = inputs$hydroid
      )
    }
  }
  
  feature <- GET(
    paste(base_url,"/dh_feature.json",sep=""), 
    add_headers(HTTP_X_CSRF_TOKEN = token),
    query = pbody, 
    encode = "json"
  );
  feature_cont <- content(feature);
  
  if (length(feature_cont$list) != 0) {
    print(paste("Number of features found: ",length(feature_cont$list),sep=""))
    
    feat <- data.frame(hydroid = character(),
                       bundle = character(),
                       ftype = character(),
                       hydrocode = character(),
                       name = character(),
                       fstatus = character(),
                       address1 = character(),
                       address2 = character(),
                       city = character(),
                       state = character(),
                       postal_code = character(),
                       description = character(),
                       uid = character(),
                       status = character(),
                       module = character(),
                       feed_nid = character(),
                       dh_link_facility_mps = character(),
                       dh_nextdown_id = character(),
                       dh_areasqkm = character(),
                       dh_link_admin_location = character(),
                       field_dh_from_entity = character(),
                       field_dh_to_entity = character(),
                       dh_geofield = character(),
                       geom = character(),
                       stringsAsFactors=FALSE) 
    
    #i <- 1
    for (i in 1:length(feature_cont$list)) {
      
      feat_i <- data.frame("hydroid" = if (is.null(feature_cont$list[[i]]$hydroid)){""} else {feature_cont$list[[i]]$hydroid},
                           "bundle" = if (is.null(feature_cont$list[[i]]$bundle)){""} else {feature_cont$list[[i]]$bundle},
                           "ftype" = if (is.null(feature_cont$list[[i]]$ftype)){""} else {feature_cont$list[[i]]$ftype},
                           "hydrocode" = if (is.null(feature_cont$list[[i]]$hydrocode)){""} else {feature_cont$list[[i]]$hydrocode},
                           "name" = if (is.null(feature_cont$list[[i]]$name)){""} else {feature_cont$list[[i]]$name},
                           "fstatus" = if (is.null(feature_cont$list[[i]]$fstatus)){""} else {feature_cont$list[[i]]$fstatus},
                           "address1" = if (is.null(feature_cont$list[[i]]$address1)){""} else {feature_cont$list[[i]]$address1},
                           "address2" = if (is.null(feature_cont$list[[i]]$address2)){""} else {feature_cont$list[[i]]$address2},
                           "city" = if (is.null(feature_cont$list[[i]]$city)){""} else {feature_cont$list[[i]]$city},
                           "state" = if (is.null(feature_cont$list[[i]]$state)){""} else {feature_cont$list[[i]]$state},
                           "postal_code" = if (is.null(feature_cont$list[[i]]$postal_code)){""} else {feature_cont$list[[i]]$postal_code},
                           "description" = if (is.null(feature_cont$list[[i]]$description)){""} else {feature_cont$list[[i]]$description},
                           "uid" = if (is.null(feature_cont$list[[i]]$uid)){""} else {feature_cont$list[[i]]$uid},
                           "status" = if (is.null(feature_cont$list[[i]]$status)){""} else {feature_cont$list[[i]]$status},
                           "module" = if (is.null(feature_cont$list[[i]]$module)){""} else {feature_cont$list[[i]]$module},
                           "feed_nid" = if (is.null(feature_cont$list[[i]]$feed_nid)){""} else {feature_cont$list[[i]]$feed_nid},
                           "dh_link_facility_mps" = if (!length(feature_cont$list[[i]]$dh_link_facility_mps)){""} else {feature_cont$list[[i]]$dh_link_facility_mps[[1]]$id},
                           "dh_nextdown_id" = if (!length(feature_cont$list[[i]]$dh_nextdown_id)){""} else {feature_cont$list[[i]]$dh_nextdown_id[[1]]$id},
                           "dh_areasqkm" = if (is.null(feature_cont$list[[i]]$dh_areasqkm)){""} else {feature_cont$list[[i]]$dh_areasqkm},
                           "dh_link_admin_location" = if (!length(feature_cont$list[[i]]$dh_link_admin_location)){""} else {feature_cont$list[[i]]$dh_link_admin_location[[1]]$id},
                           "field_dh_from_entity" = if (!length(feature_cont$list[[i]]$field_dh_from_entity)){""} else {feature_cont$list[[i]]$field_dh_from_entity$id},
                           "field_dh_to_entity" = if (!length(feature_cont$list[[i]]$field_dh_to_entity)){""} else {feature_cont$list[[i]]$field_dh_to_entity$id},
                           "dh_geofield" = if (is.null(feature_cont$list[[i]]$dh_geofield$geom)){""} else {feature_cont$list[[i]]$dh_geofield$geom},
                           "geom" = if (is.null(feature_cont$list[[i]]$dh_geofield$geom)){""} else {feature_cont$list[[i]]$dh_geofield$geom}
      )
      
      # "dh_link_admin_location" = if (!length(feature_cont$list[[i]]$dh_link_admin_location)){""} else {feature_cont$list[[i]]$dh_link_admin_location[[1]]$id},
      
      
      feat  <- rbind(feat, feat_i)
    }
  } else {
    print("This Feature does not exist")
    return(FALSE)
  }
  feature <- feat
}

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
    north(bbDF, location = 'topleft', symbol = 12, scale=0.1)+
    scalebar(bbDF, location = 'bottomleft', dist = 100, dist_unit = 'km', transform = TRUE, model = 'WGS84', st.bottom=FALSE, st.size = 3.5,
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

vahydro_import_data_cfs <- function(riv.seg, run.id, token, site = "http://deq2.bse.vt.edu/d.dh", start.date = '1984-01-01', end.date) {
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
    varkey = "om_model_element",
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
  
  wshed_summary_tbl = data.frame(
    "Run ID" = character(), 
    "Segment Name (D. Area)" = character(), 
    "7Q10/ALF/LF-90" = character(), 
    "WD (mean/max)" = character(), 
    stringsAsFactors = FALSE) ;
  #pander(odata);
  #pander(odata);
  
  omsite = site <- "http://deq2.bse.vt.edu"
  dat <- fn_get_runfile(elid, run.id, site = omsite,  cached = FALSE);
  
  dat.date <- as.Date(as.character(dat$thisdate))
  dat.flow <- as.numeric(dat$Qout)
  
  dat.trim <- data.frame(dat.date, dat.flow, row.names = NULL)
  colnames(dat.trim) <- c('date','flow')
  
  start.line <- as.numeric(which(dat.trim$date == start.date))
  end.line <- as.numeric(which(dat.trim$date == end.date))
  dat.trim <- dat.trim[start.line:end.line,]
  
  return(dat.trim)
}

vahydro_import_lrseg_data_cfs <- function(riv.seg, run.id, token, site = "http://deq2.bse.vt.edu/d.dh", start.date = '1984-01-01', end.date) {
  hydrocode = paste0("cbp6_", riv.seg);
  ftype = 'cbp6_lrseg'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list (
    hydrocode = hydrocode,
    bundle = 'landunit',
    ftype = 'cbp6_lrseg'
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
  # inputs <- list(
  #   varkey = "wshed_local_area_sqmi",
  #   featureid = featureid,
  #   entity_type = "dh_feature"
  # )
  # da <- getProperty(inputs, site, model)
  
  inputs <- list(
    varkey = "om_class_cbp_eos_file",
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
  
  wshed_summary_tbl = data.frame(
    "Run ID" = character(), 
    "Segment Name (D. Area)" = character(), 
    "7Q10/ALF/LF-90" = character(), 
    "WD (mean/max)" = character(), 
    stringsAsFactors = FALSE) ;
  #pander(odata);
  #pander(odata);
  
  omsite = site <- "http://deq2.bse.vt.edu"
  dat <- fn_get_runfile(elid, run.id, site = omsite,  cached = FALSE);
  
  dat.date <- as.Date(as.character(dat$thisdate))
  dat.flow <- as.numeric(dat$Qout)
  
  dat.trim <- data.frame(dat.date, dat.flow, row.names = NULL)
  colnames(dat.trim) <- c('date','flow')
  
  start.line <- as.numeric(which(dat.trim$date == start.date))
  end.line <- as.numeric(which(dat.trim$date == end.date))
  dat.trim <- dat.trim[start.line:end.line,]
  
  return(dat.trim)
}