drought.of.record <- function(data) {
  flows_model1 <- zoo(data$flow, order.by = data$date)
  DoR <- fn_iha_DOR_Year(flows_model1)
  return(DoR)
}