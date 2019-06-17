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
