#' Flow Exceedance Probability Metric Function 
#' @description Calculates a specific flow exceedance probability 
#' @param data a dataframe with hydrologic data 
#' @param prob This will equal 0.01, 0.05, 0.5, 0.95, or 0.99
#' @return The desired flow exceedance probability 
#' @import lubridate
#' @export flow_exceedance
flow_exceedance <- function(data, prob) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  dec_flows <- sort(data$flow, decreasing = TRUE)
  prob_exceedance <- quantile(dec_flows, prob)
  return(prob_exceedance)
}