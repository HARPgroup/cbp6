import.gage.data.cfs <- function(siteNo, start.date, end.date) {
  #Download and export raw USGS data
  pCode <- "00060"
  USGS_daily <- readNWISdv(siteNo, pCode, start.date, end.date)
  
  #Format USGS data to date and flow
  USGS_daily <- USGS_daily[,c(3,4)]
  colnames(USGS_daily) <- c('date','flow') 
  return(USGS_daily)
}  
