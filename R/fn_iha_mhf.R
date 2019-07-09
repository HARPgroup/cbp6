#' Monthly High Flow Metric Function 
#' @description Calculates the monthly high flows of dataframe - must be trimmed to water year 
#' @param data a dataframe with hydrologic data 
#' @param month specified month of interest
#' @return The monthly high flow
#' @import IHA
#' @import stats
#' @export fn_iha_mhf 

fn_iha_mhf <- function(data, month) {
  modat <- group1(data,'water','max')  # IHA function that calculates maximum monthly statistics for our data by water year	 
  print(paste("Grabbing ", month, " values ", sep=''))
  g1vec <- as.vector(as.matrix(modat[,month]))  # gives only August statistics, if 8
  
  # calculates the 50th percentile - this is the August High Flow
  # August High Flow = median flow of the annual maximum flows in August for a chosen time period
  print("Performing quantile analysis")
  x <- quantile(g1vec, 0.5, na.rm = TRUE);
  return(as.numeric(x));
}