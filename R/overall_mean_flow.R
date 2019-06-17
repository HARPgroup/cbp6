overall.mean.flow <- function(data) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  mean.flow <- signif(mean(data$flow), digits=3);
  return(mean.flow)
}