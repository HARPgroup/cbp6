seven.q.ten <- function(data) {
  flows_model1 <- zoo(data$flow, order.by = data$date)
  mod_7Q10 <- signif(fn_iha_7q10(flows_model1), digits=3);
}