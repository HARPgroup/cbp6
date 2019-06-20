#' Flow Exceedance Probability Metric Function 
#' @description Calculates Flow Exceedance Metrics of dataframe - must be trimmed to water year 
#' @param data a dataframe with hydrologic data 
#' @param prob This will equal 0.01, 0.05, 0.5, 0.95, or 0.99 depending on if you want 1%, 5%, 50%, 95%, or 99% flow exceedance
#' @return The desired flow exceedance probability 
#' @import lubridate
#' @export flow.exceedance

flow.exceedance <- function(data, prob) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  dec_flows <- sort(data$flow, decreasing = TRUE)
  prob_exceedance <- signif(quantile(dec_flows, prob), digits = 3)
  return(prob_exceedance)
}