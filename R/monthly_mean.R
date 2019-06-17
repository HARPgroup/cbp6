monthly.mean <- function(data, num.month) {
  # Setup for Monthly Means Calculations
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_means <- signif(aggregate(data$Model2.Flow, list(data$month), FUN = mean),digits = 3)
  mean_flows <- monthly_means[num.month,2]
  return(mean_flows)
}