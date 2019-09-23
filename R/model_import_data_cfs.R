#' Import USGS Gage Information Function 
#' @description Imports data from the USGS, harvested from their stream gages
#' @param riv.seg Specific river segment of interest 
#' @param mod.phase should be "p6/p6_gb604/tmp" (phase 6) or "p532c-sova" (phase 5)
#' @param mod.scenario should be "CFBASE30Y20180615" (phase 6) or "p532cal_062211"
#' @param start.date character starting date for data retrieval in the form YYYY-MM-DD.
#' @param end.date character ending date for data retrieval in the form YYYY-MM-DD.
#' @return A dataframe containing the specfic river segments model data for the specified time period
#' @import stats
#' @import utils
#' @export model_import_data_cfs

model_import_data_cfs <- function(riv.seg, mod.phase, mod.scenario, start.date, end.date) {
  # Downloading and exporting hourly model data
  model_hourly <- read.csv(paste0("http://deq2.bse.vt.edu/", mod.phase, "/river/", mod.scenario, "/stream/", 
                                  riv.seg, "_0111.csv"), header = FALSE, sep = ",", stringsAsFactors = FALSE); 
  RivSegStr1 <- strsplit(riv.seg, "\\+")
  RivSegStr1 <- RivSegStr1[[1]]
  num.segs1 <- length(RivSegStr1)
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
