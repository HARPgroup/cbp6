#' September 10pct Metric Function
#' @description Measures the September 10pct of the entire timeseries 
#' @description data must be trimmed to water year
#' @param data dataframe of date and flow data taken from import data functions
#' @return september 10pct metric
#' @import lubridate
#' @import data.table
#' @export sept_10_flow

sept_10_flow <- function(data) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  sept_flows <- subset(data, month == '9')
  sept_10 <- signif(quantile(sept_flows$flow, 0.10), digits = 3)
  return(sept_10)
}