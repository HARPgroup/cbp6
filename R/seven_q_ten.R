#' 7Q10 Metric Function
#' @description Measures the 7Q10 of the entire timeseries - data must be trimmed to water year
#' @param data dataframe of date and flow data taken from import data functions
#' @return 7Q10 metric
#' @import zoo
#' @export seven.q.ten

seven.q.ten <- function(data) {
  flows_model1 <- zoo(data$flow, order.by = data$date)
  mod_7Q10 <- signif(fn_iha_7q10(flows_model1), digits=3);
}