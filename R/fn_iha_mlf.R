#' Monthly Low Flow Metric Function 
#' @description Calculates the monthly low flow of dataframe - must be trimmed to water year 
#' @param data a dataframe with hydrologic data 
#' @param month specified month of interest
#' @return The monthly low flow
#' @import IHA
#' @import stats
#' @export fn_iha_mlf

fn_iha_mlf <- function(data, month) {
  modat <- group1(data,'water','min')  # IHA function that calculates minimum monthly statistics for our data by water year	 
  print(paste("Grabbing ", month, " values ", sep=''))
  g1vec <- as.vector(as.matrix(modat[,month]))  # gives only August statistics
  
  # calculates the 50th percentile - this is the August Low Flow
  # August Low Flow = median flow of the annual minimum flows in August for a chosen time period
  print("Performing quantile analysis")
  x <- quantile(g1vec, 0.5, na.rm = TRUE);
  return(as.numeric(x));
}