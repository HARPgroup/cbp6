vahydro_import_all_metrics_from_scenprop <- function(scenprop.pid, site, token) {
  
  metrics <- data.frame(matrix(data=NA, 1,67))
  
  colnames(metrics) <- (c('overall.mean','jan.low.flow','feb.low.flow','mar.low.flow','apr.low.flow','may.low.flow','jun.low.flow','jul.low.flow','aug.low.flow','sep.low.flow','oct.low.flow','nov.low.flow','dec.low.flow',
                          'jan.mean.flow','feb.mean.flow','mar.mean.flow','apr.mean.flow','may.mean.flow','jun.mean.flow','jul.mean.flow','aug.mean.flow','sep.mean.flow','oct.mean.flow','nov.mean.flow','dec.mean.flow',
                          'jan.high.flow','feb.high.flow','mar.high.flow','apr.high.flow','may.high.flow','jun.high.flow','jul.high.flow','aug.high.flow','sep.high.flow','oct.high.flow','nov.high.flow','dec.high.flow',
                          'one.day.min','three.day.min','seven.day.min','thirty.day.min','ninety.day.min','one.day.med.min','three.day.med.min','seven.day.med.min','thirty.day.med.min','ninety.day.med.min',
                          'one.day.max','three.day.max','seven.day.max','thirty.day.max','ninety.day.max','one.day.med.max','three.day.med.max','seven.day.med.max','thirty.day.med.max','ninety.day.med.max',
                          'flow.exceedance.1','flow.exceedance.5','flow.exceedance.50','flow.exceedance.95','flow.exceedance.99','sept.10.percent','sevenQ.ten','drought.record','lowest.yearly.mean','avg.baseflow'))
  
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
  neflow1 <- vahydro_import_metric_from_scenprop(scenprop.pid, 'non-exceedance', 'ne1', site, token)
  neflow5 <- vahydro_import_metric_from_scenprop(scenprop.pid, 'non-exceedance', 'ne5', site, token)
  neflow50 <- vahydro_import_metric_from_scenprop(scenprop.pid, 'non-exceedance', 'ne50', site, token)
  neflow95 <- vahydro_import_metric_from_scenprop(scenprop.pid, 'non-exceedance', 'ne95', site, token)
  neflow99 <- vahydro_import_metric_from_scenprop(scenprop.pid, 'non-exceedance', 'ne99', site, token)
  sept10 <- vahydro_import_metric_from_scenprop(scenprop.pid, 'monthly_non-exceedance', 'mne9_10', site, token)
  sevenq10 <- vahydro_import_metric_from_scenprop(scenprop.pid, '7q10', '', site, token)
  droughtyear <- vahydro_import_metric_from_scenprop(scenprop.pid, 'dor_year', '', site, token)
  droughtmeanflow <- vahydro_import_metric_from_scenprop(scenprop.pid, 'dor_mean', '', site, token)
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
  metrics[1,58]=neflow1
  metrics[1,59]=neflow5
  metrics[1,60]=neflow50
  metrics[1,61]=neflow95
  metrics[1,62]=neflow99
  metrics[1,63]=sept10
  metrics[1,64]=sevenq10
  metrics[1,65]=droughtyear
  metrics[1,66]=droughtmeanflow
  metrics[1,67]=meanbaseflow
  
  return(metrics)
}
  






