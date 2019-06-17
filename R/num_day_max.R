num.day.max <- function(data, num.day, max_or_med) {
  
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  # Setup for ___ Day Max Calculations
  f3 <- zoo(data$flow, order.by = data$date)
  g2 <- group2(f3, year = 'water')
  
  if (max_or_med == "max"){
    if (num.day == 1) {
      metric <- signif(max(g2$'1 Day Max'), digits=3)}
    else if (num.day == 3){
      metric <- signif(max(g2$'3 Day Max'), digits=3)}
    else if (num.day == 7){
      metric <- signif(max(g2$'7 Day Max'), digits=3)}
    else if (num.day == 30){
      metric <- signif(max(g2$'30 Day Max'), digits=3)}
    else if (num.day == 90){
      metric <- signif(max(g2$'90 Day Max'), digits=3)}
  }
  if (max_or_med == "med"){  
    if (num.day == 1) {
      metric <- signif(median(g2$'1 Day Max'), digits=3)}
    else if (num.day == 3){
      metric <- signif(median(g2$'3 Day Max'), digits=3)}
    else if (num.day == 7){
      metric <- signif(median(g2$'7 Day Max'), digits=3)}
    else if (num.day == 30){
      metric <- signif(median(g2$'30 Day Max'), digits=3)}
    else if (num.day == 90){
      metric <- signif(median(g2$'90 Day Max'), digits=3)}
  }
  return(metric)  
}