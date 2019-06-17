num.day.min <- function(data, num.day, min_or_med) {
  
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  # Setup for ___ Day Max Calculations
  f3 <- zoo(data$flow, order.by = data$date)
  g2 <- group2(f3, year = 'water')
  
  if (min_or_med == "min"){
    if (num.day == 1) {
      metric <- signif(min(g2$'1 Day Min'), digits=3)}
    else if (num.day == 3){
      metric <- signif(min(g2$'3 Day Min'), digits=3)}
    else if (num.day == 7){
      metric <- signif(min(g2$'7 Day Min'), digits=3)}
    else if (num.day == 30){
      metric <- signif(min(g2$'30 Day Min'), digits=3)}
    else if (num.day == 90){
      metric <- signif(min(g2$'90 Day Min'), digits=3)}
  }
  if (min_or_med == "med"){  
    if (num.day == 1) {
      metric <- signif(median(g2$'1 Day Min'), digits=3)}
    else if (num.day == 3){
      metric <- signif(median(g2$'3 Day Min'), digits=3)}
    else if (num.day == 7){
      metric <- signif(median(g2$'7 Day Min'), digits=3)}
    else if (num.day == 30){
      metric <- signif(median(g2$'30 Day Min'), digits=3)}
    else if (num.day == 90){
      metric <- signif(median(g2$'90 Day Min'), digits=3)}
  }
  return(metric)  
}