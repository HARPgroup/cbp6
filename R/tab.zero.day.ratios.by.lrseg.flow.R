library(knitr)

tab.zero.day.ratios.by.lrseg.flow = function(tmp.data) {
  suro.names <- grep('suro', colnames(tmp.data), value = TRUE)
  suro.cols <- which(colnames(tmp.data) %in% suro.names)
  suro.data <- as.numeric(as.matrix(tmp.data[,suro.cols]))
  suro.ratio <- length(which(suro.data == 0))/length(suro.data)
  
  ifwo.names <- grep('ifwo', colnames(tmp.data), value = TRUE)
  ifwo.cols <- which(colnames(tmp.data) %in% ifwo.names)
  ifwo.data <- as.numeric(as.matrix(tmp.data[,ifwo.cols]))
  ifwo.ratio <- length(which(ifwo.data == 0))/length(ifwo.data)
  
  agwo.names <- grep('agwo', colnames(tmp.data), value = TRUE)
  agwo.cols <- which(colnames(tmp.data) %in% agwo.names)
  agwo.data <- as.numeric(as.matrix(tmp.data[,agwo.cols]))
  agwo.ratio <- length(which(agwo.data == 0))/length(agwo.data)
  
  tmp.tab <- matrix(c(suro.ratio, ifwo.ratio, agwo.ratio), nrow = 3, ncol = 1)
  colnames(tmp.tab) = c('Ratio of Days with Zero Flow to Total Days')
  rownames(tmp.tab) = c('SURface Outflow   ', 'InterFloW Outflow   ', 'Active GroundWater Outflow   ')
  
  tmp.tab <- signif(tmp.tab, digits = 3)
  tmp.tab <- kable(format(tmp.tab, digits = 3, drop0trailing = TRUE))
  return(tmp.tab)
}
