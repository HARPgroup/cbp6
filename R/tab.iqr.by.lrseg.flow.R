library(knitr)

tab.iqr.by.lrseg.flow = function(tmp.data) {
  suro.names <- grep('suro', colnames(tmp.data), value = TRUE)
  suro.cols <- which(colnames(tmp.data) %in% suro.names)
  suro.data <- as.numeric(as.matrix(tmp.data[,suro.cols]))
  suro.75pct <- signif(as.numeric(quantile(suro.data, 0.75)), 3)
  suro.25pct <- signif(as.numeric(quantile(suro.data, 0.25)), 3)
  suro.iqr <- signif(suro.75pct - suro.25pct, 3)
  suro.tabler <- paste0(suro.iqr, ' [', suro.25pct, ', ', suro.75pct, ']')
  
  ifwo.names <- grep('ifwo', colnames(tmp.data), value = TRUE)
  ifwo.cols <- which(colnames(tmp.data) %in% ifwo.names)
  ifwo.data <- as.numeric(as.matrix(tmp.data[,ifwo.cols]))
  ifwo.75pct <- signif(as.numeric(quantile(ifwo.data, 0.75)), 3)
  ifwo.25pct <- signif(as.numeric(quantile(ifwo.data, 0.25)), 3)
  ifwo.iqr <- signif(ifwo.75pct - ifwo.25pct, 3)
  ifwo.tabler <- paste0(ifwo.iqr, ' [', ifwo.25pct, ', ', ifwo.75pct, ']')
  
  agwo.names <- grep('agwo', colnames(tmp.data), value = TRUE)
  agwo.cols <- which(colnames(tmp.data) %in% agwo.names)
  agwo.data <- as.numeric(as.matrix(tmp.data[,agwo.cols]))
  agwo.75pct <- signif(as.numeric(quantile(agwo.data, 0.75)), 3)
  agwo.25pct <- signif(as.numeric(quantile(agwo.data, 0.25)), 3)
  agwo.iqr <- signif(agwo.75pct - agwo.25pct, 3)
  agwo.tabler <- paste0(agwo.iqr, ' [', agwo.25pct, ', ', agwo.75pct, ']')
  
  tmp.tab <- matrix(c(suro.tabler, ifwo.tabler, agwo.tabler), nrow = 3, ncol = 1)
  colnames(tmp.tab) = c('IQR of Unit Flows (cfs/sq. mi) [25th, 75th]')
  rownames(tmp.tab) = c('SURface Outflow   ', 'InterFloW Outflow   ', 'Active GroundWater Outflow   ')
  
  tmp.tab <- kable(format(tmp.tab, drop0trailing = TRUE))
  return(tmp.tab)
}