#' Import All Metrics from VAHydro Function
#' @description Imports all metrics from VAHydro for a given scenario
#' @param seg.or.gage indicate segment name or gage number
#' @param mod.scenario input scenario code
#' @param token input token number for access
#' @param site input site name
#' @return dataframe of all metrics
#' @import base
#' @import from function file
#' @export vahydro.import.all.metrics

vahydro.import.all.metrics <- function(seg.or.gage, mod.scenario, token, site) {
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