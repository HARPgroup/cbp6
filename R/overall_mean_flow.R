#' Overall Mean Flow Metric Function
#' @description Measures the mean flow of the entire timeseries
#' @param data dataframe of date and flow data taken from import data functions
#' @return overall mean flow metric
#' @import lubridate
#' @export overall_mean_flow

overall_mean_flow <- function(data) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  mean.flow <- mean(data$flow);
  return(mean.flow)
}