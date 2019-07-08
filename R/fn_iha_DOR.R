#' Drought of Record Flow Metric Function 
#' @description Calculates drought of record flow of dataframe - must be trimmed to water year 
#' @param data a dataframe with hydrologic data 
#' @return The drought of record flow
#' @import IHA
#' @export fn_iha_DOR

#Calculates the Drought of record Flow
fn_iha_DOR <- function(data){
  loflows <- group2(data);
  l90 <- loflows["90 Day Min"];
  ndx = which.min(as.numeric(l90[,"90 Day Min"]));
  dor_flow = round(loflows[ndx,]$"90 Day Min",1);
  #dor_year = loflows[ndx,]$"year";
}
