#' Monthly Mean Metric Function
#' @description Measures monthly mean of dataframe - data must be trimmed to water year
#' @param data dataframe of date and flow data taken from import data functions
#' @param num.month number for month of interest
#' @return monthly mean metric
#' @import lubridate
#' @import stats
#' @export monthly.mean

monthly.mean <- function(data, num.month) {
  # Setup for Monthly Means Calculations
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_means <- signif(aggregate(data$Model2.Flow, list(data$month), FUN = mean),digits = 3)
  mean_flows <- monthly_means[num.month,2]
  return(mean_flows)
}