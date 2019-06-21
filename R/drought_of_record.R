#' Drought of Record Metric Function
#' @description Calculates when the Drought of Record occurs in dataframe - must be trimmed to water year
#' @param data a dataframe containing hydrologic information
#' @return The year when the Drought of Record occurs within dataframe
#' @import zoo 
#' @import IHA 
#' @export drought_of_record
drought_of_record <- function(data) {
  loflows <- group2(data);
  l90 <- loflows["90 Day Min"];
  ndx = which.min(as.numeric(l90[,"90 Day Min"]));
  #}dor_flow = round(loflows[ndx,]$"90 Day Min",1);
  dor_year = loflows[ndx,]$"year";
  flows_model1 <- zoo(data$flow, order.by = data$date)
  DoR <- fn_iha_DOR_Year(flows_model1)
  return(DoR)
}