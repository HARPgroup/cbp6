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
