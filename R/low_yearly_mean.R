low.yearly.mean <- function(data) {
  #setup
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  
  flows_model1 <- zoo(data$flow, order.by = data$date)
  DoR <- fn_iha_DOR_Year(flows_model1);
  
  model1.data <- data.frame(data$day, data$month, data$year, data$flow)
  names(model1.data) <- c('day', 'month', 'year', 'flow')
  model1river <- createlfobj(model1.data, hyearstart = 10, baseflow = TRUE, meta = NULL)
  lf_model <- aggregate(model1river$flow, by = list(model1river$hyear), FUN = mean)
  colnames(lf_model) <- c('Water_Year', 'Mean_Flow')
  #calculation
  lf_model <- which(lf_model["Water_Year"] == DoR)
  lf_model <- lf_model["Mean_Flow"][lf_model]
  lfmin <- lf_model
  return(lfmin)
}