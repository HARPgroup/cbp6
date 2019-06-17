monthly.max <- function(data, num.month) {
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  monthly_maxs <- zoo(data$flow, order.by = data$date)
  max_flows <- signif(fn_iha_mhf(monthly_maxs,num.month), digits=3);
  return(max_flows)
}