#' Monthly Minimum Metric Function
#' @description Measures monthly minimum of dataframe - data must be trimmed to water year
#' @param data dataframe of date and flow data taken from import data functions
#' @param num.month number for month of interest
#' @return monthly mean metric
#' @import lubridate
#' @import stats
#' @export monthly_min

monthly_min <- function(data, num.month) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_mins <- zoo(data$flow, order.by = data$date)
  moname = month.name[num.month]
  min_flows <- fn_iha_mlf(monthly_mins,moname);
  return(min_flows)
}