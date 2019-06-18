#' September 10% Metric Function
#' @description Measures the September 10% of the entire timeseries - data must be trimmed to water year
#' @param data dataframe of date and flow data taken from import data functions
#' @return september 10% metric
#' @import lubridate
#' @import base
#' @import data.table
#' @export sept.10.flow

sept.10.flow <- function(data) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  sept_flows <- subset(data, month == '9')
  sept_10 <- signif(quantile(sept_flows$flow, 0.10), digits = 3)
  return(sept_10)
}