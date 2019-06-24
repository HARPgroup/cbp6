#' Drought of Record Metric Function
#' @description Calculates when the Drought of Record occurs in dataframe - must be trimmed to water year
#' @param data a dataframe containing hydrologic information
#' @return The year when the Drought of Record occurs within dataframe
#' @import zoo 
#' @export drought_of_record
drought_of_record <- function(data) {
  flows_model1 <- zoo(data$flow, order.by = data$date)
  DoR <- 0
  #DoR <- fn_iha_DOR_Year(flows_model1)
  return(DoR)
}