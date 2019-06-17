sept.10.flow <- function(data) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  sept_flows <- subset(data, month == '9')
  sept_10 <- signif(quantile(sept_flows$flow, 0.10), digits = 3)
  return(sept_10)
}