#' Import USGS Gage Information Function 
#' @description Imports data from the USGS, harvested from their stream gages
#' @param site_number character USGS site number.  This is usually an 8 digit number.
#' @param start.date character starting date for data retrieval in the form YYYY-MM-DD.
#' @param end.date character ending date for data retrieval in the form YYYY-MM-DD.
#' @return A dataframe containing the specfic gage's data for the specified time period
#' @import dataRetrieval
#' @export import_gage_data_cfs

gage_import_data_cfs <- function(site_number, start.date, end.date) {
  #Download and export raw USGS data
  pCode <- "00060"
  USGS_daily <- readNWISdv(site_number, pCode, start.date, end.date)
  
  #Format USGS data to date and flow
  USGS_daily <- USGS_daily[,c(3,4)]
  colnames(USGS_daily) <- c('date','flow') 
  return(USGS_daily)
}  
