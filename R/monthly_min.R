monthly.min <- function(data, num.month) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_mins <- zoo(data$flow, order.by = data$date)
  min_flows <- signif(fn_iha_mlf(monthly_mins,num.month), digits=3);
  return(min_flows)
}