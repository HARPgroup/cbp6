import.model.data.cfs <- function(riv.seg, mod.phase, mod.scenario, start.date, end.date) {
  # Downloading and exporting hourly model data
  model_hourly <- read.csv(paste0("http://deq2.bse.vt.edu/", mod.phase, "/wdm/river/", mod.scenario, "/stream/", 
                                  RivSeg, "_0111.csv"), header = FALSE, sep = ",", stringsAsFactors = FALSE);  
  # Converting hourly to daily data and exporting daily data
  model_hourly <- model_hourly[-1,]
  model_hourly$V1 <- trimws(model_hourly$V1, which = "both")
  colnames(model_hourly) <- c("year","month","day","hour","ovol")
  model_hourly$date <- as.Date(paste0(model_hourly$year,"-",model_hourly$month,"-",model_hourly$day))
  model_daily <- aggregate(model_hourly$ovol, list(model_hourly$date), FUN = sum)
  colnames(model_daily) <- c("date","flow")
  model_daily$flow <- model_daily$flow * 0.504167 # conversion from acre-feet to cfs
  return(model_daily)
}

import.gage.data.cfs <- function(siteNo, start.date, end.date) {
  #Download and export raw USGS data
  pCode <- "00060"
  USGS_daily <- readNWISdv(siteNo, pCode, start.date, end.date)
  
  #Format USGS data to date and flow
  USGS_daily <- USGS_daily[,c(3,4)]
  colnames(USGS_daily) <- c('date','flow') 
  return(USGS_daily)
}  

import.vahydro.metric <- function(met.varkey, met.propcode, seg.or.gage, mod.scenario = "p532cal_062211", token, site) {
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

import.all.vahydro.metrics <- function(seg.or.gage, mod.scenario, token, site) {
  overall.mean <- import.vahydro.metric(met.varkey = "overall_mean", met.propcode = '', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jan.low.flow <- import.vahydro.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  feb.low.flow <- import.vahydro.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml2', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  mar.low.flow <- import.vahydro.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml3', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  apr.low.flow <- import.vahydro.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml4', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  may.low.flow <- import.vahydro.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml5', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jun.low.flow <- import.vahydro.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml6', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jul.low.flow <- import.vahydro.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml7', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  aug.low.flow <- import.vahydro.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml8', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  sep.low.flow <- import.vahydro.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml9', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  oct.low.flow <- import.vahydro.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml10', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  nov.low.flow <- import.vahydro.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml11', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  dec.low.flow <- import.vahydro.metric(met.varkey = "monthly_low_flow", met.propcode = 'ml12', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jan.mean.flow <- import.vahydro.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  feb.mean.flow <- import.vahydro.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm2', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  mar.mean.flow <- import.vahydro.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm3', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  apr.mean.flow <- import.vahydro.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm4', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  may.mean.flow <- import.vahydro.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm5', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jun.mean.flow <- import.vahydro.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm6', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jul.mean.flow <- import.vahydro.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm7', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  aug.mean.flow <- import.vahydro.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm8', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  sep.mean.flow <- import.vahydro.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm9', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  oct.mean.flow <- import.vahydro.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm10', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  nov.mean.flow <- import.vahydro.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm11', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  dec.mean.flow <- import.vahydro.metric(met.varkey = "monthly_mean_flow", met.propcode = 'mm12', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jan.high.flow <- import.vahydro.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  feb.high.flow <- import.vahydro.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh2', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  mar.high.flow <- import.vahydro.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh3', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  apr.high.flow <- import.vahydro.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh4', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  may.high.flow <- import.vahydro.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh5', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jun.high.flow <- import.vahydro.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh6', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  jul.high.flow <- import.vahydro.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh7', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  aug.high.flow <- import.vahydro.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh8', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  sep.high.flow <- import.vahydro.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh9', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  oct.high.flow <- import.vahydro.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh10', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  nov.high.flow <- import.vahydro.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh11', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  dec.high.flow <- import.vahydro.metric(met.varkey = "monthly_high_flow", met.propcode = 'mh12', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  one.day.min <- import.vahydro.metric(met.varkey = "min_low_flow", met.propcode = 'min1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  three.day.min <- import.vahydro.metric(met.varkey = "min_low_flow", met.propcode = 'min3', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  seven.day.min <- import.vahydro.metric(met.varkey = "min_low_flow", met.propcode = 'min7', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  thirty.day.min <- import.vahydro.metric(met.varkey = "min_low_flow", met.propcode = 'min30', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  ninety.day.min <- import.vahydro.metric(met.varkey = "min_low_flow", met.propcode = 'min90', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  one.day.med.low <- import.vahydro.metric(met.varkey = "med_low_flow", met.propcode = 'medl1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  three.day.med.low <- import.vahydro.metric(met.varkey = "med_low_flow", met.propcode = 'medl3', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  seven.day.med.low <- import.vahydro.metric(met.varkey = "med_low_flow", met.propcode = 'medl7', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  thirty.day.med.low <- import.vahydro.metric(met.varkey = "med_low_flow", met.propcode = 'medl30', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  ninety.day.med.low <- import.vahydro.metric(met.varkey = "med_low_flow", met.propcode = 'medl90', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  one.day.max <- import.vahydro.metric(met.varkey = "max_high_flow", met.propcode = 'max1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  three.day.max <- import.vahydro.metric(met.varkey = "max_high_flow", met.propcode = 'max3', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  seven.day.max <- import.vahydro.metric(met.varkey = "max_high_flow", met.propcode = 'max7', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  thirty.day.max <- import.vahydro.metric(met.varkey = "max_high_flow", met.propcode = 'max30', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  ninety.day.max <- import.vahydro.metric(met.varkey = "max_high_flow", met.propcode = 'max90', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  one.day.med.high <- import.vahydro.metric(met.varkey = "med_high_flow", met.propcode = 'medh1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  three.day.med.high <- import.vahydro.metric(met.varkey = "med_high_flow", met.propcode = 'medh3', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  seven.day.med.high <- import.vahydro.metric(met.varkey = "med_high_flow", met.propcode = 'medh7', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  thirty.day.med.high <- import.vahydro.metric(met.varkey = "med_high_flow", met.propcode = 'medh30', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  ninety.day.med.high <- import.vahydro.metric(met.varkey = "med_high_flow", met.propcode = 'medh90', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  one.pct.non.exceedance <- import.vahydro.metric(met.varkey = "non-exceedance", met.propcode = 'ne1', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  five.pct.non.exceedance <- import.vahydro.metric(met.varkey = "non-exceedance", met.propcode = 'ne5', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  fifty.pct.non.exceedance <- import.vahydro.metric(met.varkey = "non-exceedance", met.propcode = 'ne50', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  ninety.five.pct.non.exceedance <- import.vahydro.metric(met.varkey = "non-exceedance", met.propcode = 'ne95', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  ninety.nine.pct.non.exceedance <- import.vahydro.metric(met.varkey = "non-exceedance", met.propcode = 'ne99', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  sep.ten.pct <- import.vahydro.metric(met.varkey = "monthly_non-exceedance", met.propcode = 'mne9_10', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  seven.q.ten <- import.vahydro.metric(met.varkey = "7q10", met.propcode = '', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  drought.of.record.year <- import.vahydro.metric(met.varkey = "dor_year", met.propcode = '', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  drought.of.record.mean <- import.vahydro.metric(met.varkey = "dor_mean", met.propcode = '', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)
  mean.baseflow <- import.vahydro.metric(met.varkey = "baseflow", met.propcode = '', seg.or.gage = seg.or.gage, mod.scenario = mod.scenario, token = token, site = site)

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

water.year.trim <- function(data) {
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

metric.calculation <- function(data, vahydro.upload = F) {

  # for: number of metrics:
    # Calculates flow metric
    # Uploads metric to VA Hydro
    # Puts calculated metric in "all metric" dataframe
  
  # Returns dataframe of all calculated metrics
  return()
}

scenario.comparison <- function(metrics1, metrics2) {
  # Calculates percent change for all metrics (mod2-mod1/mod1, since mod1 is considered basis of comparison)
  
  # Returns dataframe of pct changes for all metrics
  return()
}

# calculating metrics functions

# Baseflow (Average) DONE
average.baseflow <- function(data){
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
monthly.max <- function(data, num.month) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_maxs <- zoo(data$flow, order.by = data$date)
  max_flows <- signif(fn_iha_mhf(monthly_maxs,num.month), digits=3);
  return(max_flows)
}

# Monthly Low Calculation DONE
monthly.min <- function(data, num.month) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_mins <- zoo(data$flow, order.by = data$date)
  min_flows <- signif(fn_iha_mlf(monthly_mins,num.month), digits=3);
  return(min_flows)
}

# Monthly Mean Calculation DONE
monthly.mean <- function(data, num.month) {
  # Setup for Monthly Means Calculations
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_means <- signif(aggregate(data$Model2.Flow, list(data$month), FUN = mean),digits = 3)
  mean_flows <- monthly_means[num.month,2]
  return(mean_flows)
}

# Flow Exceedance Calculation DONE
flow.exceedance <- function(data, prob) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  dec_flows <- sort(data$flow, decreasing = TRUE)
  prob_exceedance <- signif(quantile(dec_flows, prob), digits = 3)
  return(prob_exceedance)
}

# September 10% Flow Calculation DONE
sept.10.flow <- function(data) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  sept_flows <- subset(data, month == '9')
  sept_10 <- signif(quantile(sept_flows$flow, 0.10), digits = 3)
  return(sept_10)
}

# Overall Mean Flow Calculation DONE
overall.mean.flow <- function(data) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  mean.flow <- signif(mean(data$flow), digits=3);
  return(mean.flow)
}

# DROUGHT OF RECORD (MIN. 90 DAY MIN.) YEAR Calculation DONE
drought.of.record <- function(data) {
  flows_model1 <- zoo(data$flow, order.by = data$date)
  DoR <- fn_iha_DOR_Year(flows_model1)
  return(DoR)
}

# 7Q10 DONE
seven.q.ten <- function(data) {
  flows_model1 <- zoo(data$flow, order.by = data$date)
  mod_7Q10 <- signif(fn_iha_7q10(flows_model1), digits=3);
}

# _ Day Min Calculation DONE
num.day.min <- function(data, num.day, min_or_med) {
  
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
num.day.max <- function(data, num.day, max_or_med) {
  
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
low.yearly.mean <- function(data) {
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
  lf_model <- which(lf_model["Water_Year"] == DoR)
  lf_model <- lf_model["Mean_Flow"][lf_model]
  lfmin <- lf_model
  return(lfmin)
}

