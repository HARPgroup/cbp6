#' Monthly Maximum Metric Function 
#' @description Calculates the maximum flow for a specified month within dataframe - must be trimmed to water year 
#' @param data a dataframe with hydrologic data 
#' @param num.month the number corresponding to the month whose maximum flow value you wish to receive
#' @return The maximum flow for the specified month
#' @import zoo
#' @export monthly_max

monthly_max <- function(data, num.month) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_maxs <- zoo(data$flow, order.by = data$date)
  max_flows <- fn_iha_mhf(monthly_maxs,num.month);
  return(max_flows)
}