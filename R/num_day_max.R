#' Specified Day Maximum Metric Function
#' @description Measures maximum of dataframe for given number of days - data must be trimmed to water year
#' @param data dataframe of date and flow data taken from import data functions
#' @param num.day number for days of interest
#' @param max_or_med maximum of maximum data, or median of maximum data
#' @return specified day maximum metric
#' @import lubridate
#' @import zoo
#' @import IHA
#' @export num_day_max

num_day_max <- function(data, num.day, max_or_med) {
  
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  # Setup for ___ Day Max Calculations
  f3 <- zoo(data$flow, order.by = data$date)
  g2 <- group2(f3, year = 'water')
  
  if (max_or_med == "max"){
    if (num.day == 1) {
      metric <- max(g2$'1 Day Max')}
    else if (num.day == 3){
      metric <- max(g2$'3 Day Max')}
    else if (num.day == 7){
      metric <- max(g2$'7 Day Max')}
    else if (num.day == 30){
      metric <- max(g2$'30 Day Max')}
    else if (num.day == 90){
      metric <- max(g2$'90 Day Max')}
  }
  if (max_or_med == "med"){  
    if (num.day == 1) {
      metric <- median(g2$'1 Day Max')}
    else if (num.day == 3){
      metric <- median(g2$'3 Day Max')}
    else if (num.day == 7){
      metric <- median(g2$'7 Day Max')}
    else if (num.day == 30){
      metric <- median(g2$'30 Day Max')}
    else if (num.day == 90){
      metric <- median(g2$'90 Day Max')}
  }
  return(metric)  
}