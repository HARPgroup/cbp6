mod.phase <- 'p6/p6_gb604' #or "p532c-sova" (phase 5)
mod.scenario <- 'vahydro-1.0-gage timespan' #or 'CBASE1808L55CY55R45P50R45P50Y' (climate change) 'CFBASE30Y20180615' (base) 'CBASE1808L55CY55R45P10R45P10Y' (climate change 10%) 'CBASE1808L55CY55R45P90R45P90Y' (climate change 90%)
start.date <- '1998-07-31' #1984-01-01
end.date <- '2014-12-31'
github_link <- "C:\\Users\\Kevin D'Andrea\\Desktop\\HARP\\Github"
site_url <- "http://deq2.bse.vt.edu/d.dh"
site.or.server <- 'site'
riv.seg <- 'YP3_6330_6700'
run.id <- '11'

token <- token
cbp6_link = paste0(github_link, "/cbp6/code");
setwd(cbp6_link)

# Sourcing functions
source(paste0(cbp6_link,"/cbp6_functions.R"))
source(paste0(github_link, "/auth.private"));
source(paste(cbp6_link, "/fn_vahydro-1.0.R", sep = ''))

#load rest username and password, contained in auth.private file

token <- rest_token(site_url, token, rest_uname, rest_pw);
options(timeout=120); # set timeout to twice default level to avoid abort due to high traffic

automated_metric_2_vahydro <- function(riv.seg, run.id, mod.phase, mod.scenario, start.date, end.date, github_link, site_url, site.or.server = 'site', token) {
  
  # LOADING DATA ------------------------------------------------------------
  scenprop.pid <- get.scen.prop(riv.seg, mod.scenario, dat.source = 'vahydro', run.id, start.date, end.date, site_url, token)
  
  data <- vahydro_import_data_cfs(riv.seg, run.id, token, site_url, start.date, end.date)
  data <- water_year_trim(data)
  metrics <- metrics_calc_all(data) #calculate metrics into a matrix
  
  #posts metrics to vahydro
  vahydro_post_metric_to_scenprop(scenprop.pid, 'overall_mean', '', 'Overall Mean Flow', signif(metrics$overall.mean, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml1', 'January Low Flow', signif(metrics$jan.low.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml2', 'February Low Flow', signif(metrics$feb.low.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml3', 'March Low Flow', signif(metrics$mar.low.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml4', 'April Low Flow', signif(metrics$apr.low.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml5', 'May Low Flow', signif(metrics$may.low.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml6', 'June Low Flow', signif(metrics$jun.low.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml7', 'July Low Flow', signif(metrics$jul.low.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml8', 'August Low Flow', signif(metrics$aug.low.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml9', 'September Low Flow', signif(metrics$sep.low.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml10', 'October Low Flow', signif(metrics$oct.low.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml11', 'November Low Flow', signif(metrics$nov.low.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_low_flow', 'ml12', 'December Low Flow', signif(metrics$dec.low.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm1', 'January Mean Flow', signif(metrics$jan.mean.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm2', 'February Mean Flow', signif(metrics$feb.mean.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm3', 'March Mean Flow', signif(metrics$mar.mean.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm4', 'April Mean Flow', signif(metrics$apr.mean.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm5', 'May Mean Flow', signif(metrics$may.mean.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm6', 'June Mean Flow', signif(metrics$jun.mean.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm7', 'July Mean Flow', signif(metrics$jul.mean.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm8', 'August Mean Flow', signif(metrics$aug.mean.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm9', 'September Mean Flow', signif(metrics$sep.mean.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm10', 'October Mean Flow', signif(metrics$oct.mean.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm11', 'November Mean Flow', signif(metrics$nov.mean.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_mean_flow', 'mm12', 'December Mean Flow', signif(metrics$dec.mean.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh1', 'January High Flow', signif(metrics$jan.high.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh2', 'February High Flow', signif(metrics$feb.high.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh3', 'March High Flow', signif(metrics$mar.high.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh4', 'April High Flow', signif(metrics$apr.high.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh5', 'May High Flow', signif(metrics$may.high.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh6', 'June High Flow', signif(metrics$jun.high.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh7', 'July High Flow', signif(metrics$jul.high.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh8', 'August High Flow', signif(metrics$aug.high.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh9', 'September High Flow', signif(metrics$sep.high.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh10', 'October High Flow', signif(metrics$oct.high.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh11', 'November High Flow', signif(metrics$nov.high.flow, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_high_flow', 'mh12', 'December High Flow', signif(metrics$dec.high.flow, digits =3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min1', '1 Day Min Low Flow', signif(metrics$one.day.min, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min3', '3 Day Min Low Flow', signif(metrics$three.day.min, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min7', '7 Day Min Low Flow', signif(metrics$seven.day.min, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min30', '30 Day Min Low Flow', signif(metrics$thirty.day.min, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'min_low_flow', 'min90', '90 Day Min Low Flow', signif(metrics$ninety.day.min, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl1', '1 Day Median Low Flow', signif(metrics$one.day.med.min, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl3', '3 Day Median Low Flow', signif(metrics$three.day.med.min, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl7', '7 Day Median Low Flow', signif(metrics$seven.day.med.min, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl30', '30 Day Median Low Flow', signif(metrics$thirty.day.med.min, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_low_flow', 'medl90', '90 Day Median Low Flow', signif(metrics$ninety.day.med.min, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max1', '1 Day Max High Flow', signif(metrics$one.day.max, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max3', '3 Day Max High Flow', signif(metrics$three.day.max, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max7', '7 Day Max High Flow', signif(metrics$seven.day.max, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max30', '30 Day Max High Flow', signif(metrics$thirty.day.max, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'max_high_flow', 'max90', '90 Day Max High Flow', signif(metrics$ninety.day.max, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh1', '1 Day Median High Flow', signif(metrics$one.day.med.max, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh3', '3 Day Median High Flow', signif(metrics$three.day.med.max, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh7', '7 Day Median High Flow', signif(metrics$seven.day.med.max, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh30', '30 Day Median High Flow', signif(metrics$thirty.day.med.max, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'med_high_flow', 'medh90', '90 Day Median High Flow', signif(metrics$ninety.day.med.max, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne1', '1% Non-Exceedance Flow', signif(metrics$flow.exceedance.1, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne5', '5% Non-Exceedance Flow', signif(metrics$flow.exceedance.5, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne50', '50% Non-Exceedance Flow', signif(metrics$flow.exceedance.50, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne95', '95% Non-Exceedance Flow', signif(metrics$flow.exceedance.95, digits =3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'non-exceedance', 'ne99', '99% Non-Exceedance Flow', signif(metrics$flow.exceedance.99, digits =3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'monthly_non-exceedance', 'mne9_10', 'September 10%', signif(metrics$sept.10.percent, digits =3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, '7q10', '', '7q10', signif(metrics$sevenQ.ten, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'dor_year', '', 'Year of Drought of Record Occurence', metrics$drought.record, site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'dor_mean', '', 'Drought of Record Year Mean Flow', signif(metrics$lowest.yearly.mean, digits = 3), site_url, token)
  vahydro_post_metric_to_scenprop(scenprop.pid, 'baseflow', '', 'Mean Baseflow', signif(metrics$avg.baseflow, digits =3), site_url, token)
}

for (i in length(riv.seg.list)) {
  riv.seg <- riv.seg.list[i]
  automated_metric_2_vahydro(riv.seg, run.id, mod.phase, mod.scenario, start.date, end.date, github_link, site_url, site.or.server = 'site', token)
}
  
