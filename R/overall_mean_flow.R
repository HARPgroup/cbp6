#' Overall Mean Flow Metric Function
#' @description Measures the mean flow of the entire timeseries - data must be trimmed to water year
#' @param data dataframe of date and flow data taken from import data functions
#' @return overall mean flow metric
#' @import lubridate
#' @import base
#' @export overall.mean.flow

overall.mean.flow <- function(data) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  mean.flow <- signif(mean(data$flow), digits=3);
  return(mean.flow)
}