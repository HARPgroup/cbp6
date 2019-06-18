#' Drought of Record Metric Function
#' @description Calculates when the Drought of Record occurs in dataframe - must be trimmed to water year
#' @param data 
#' @return The year when the Drought of Record occurs within dataframe
#' @import base
#' @import zoo 
#' @export drought.of.record

drought.of.record <- function(data) {
  flows_model1 <- zoo(data$flow, order.by = data$date)
  DoR <- fn_iha_DOR_Year(flows_model1)
  return(DoR)
}