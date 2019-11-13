#' Specified Day Minimum Metric Function
#' @description Measures minimum of dataframe for given number of days - data must be trimmed to water year
#' @param data dataframe of date and flow data taken from import data functions
#' @param num.day number for days of interest
#' @param min_or_med minimum of minimum data, or median of minimum data
#' @return specified day minimum metric
#' @import lubridate
#' @import zoo
#' @import IHA
#' @export num_day_min

num_day_min <- function(data, num.day, min_or_med) {
  
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  # Setup for ___ Day Max Calculations
  f3 <- zoo(data$flow, order.by = data$date)
  g2 <- group2(f3, year = 'water')
  
  if (min_or_med == "min"){
    if (num.day == 1) {
      metric <- min(g2$'1 Day Min')}
    else if (num.day == 3){
      metric <- min(g2$'3 Day Min')}
    else if (num.day == 7){
      metric <- min(g2$'7 Day Min')}
    else if (num.day == 30){
      metric <- min(g2$'30 Day Min')}
    else if (num.day == 90){
      metric <- min(g2$'90 Day Min')}
  }
  if (min_or_med == "med"){  
    if (num.day == 1) {
      metric <- median(g2$'1 Day Min')}
    else if (num.day == 3){
      metric <- median(g2$'3 Day Min')}
    else if (num.day == 7){
      metric <- median(g2$'7 Day Min')}
    else if (num.day == 30){
      metric <- median(g2$'30 Day Min')}
    else if (num.day == 90){
      metric <- median(g2$'90 Day Min')}
  }
  return(metric)  
}