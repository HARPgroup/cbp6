library(knitr)

tab.means.by.lrseg.flow = function(tmp.data) {
  suro.names <- grep('suro', colnames(tmp.data), value = TRUE)
  suro.cols <- which(colnames(tmp.data) %in% suro.names)
  suro.data <- as.numeric(as.matrix(tmp.data[,suro.cols]))
  suro.mean <- mean(suro.data)
  
  ifwo.names <- grep('ifwo', colnames(tmp.data), value = TRUE)
  ifwo.cols <- which(colnames(tmp.data) %in% ifwo.names)
  ifwo.data <- as.numeric(as.matrix(tmp.data[,ifwo.cols]))
  ifwo.mean <- mean(ifwo.data)
  
  agwo.names <- grep('agwo', colnames(tmp.data), value = TRUE)
  agwo.cols <- which(colnames(tmp.data) %in% agwo.names)
  agwo.data <- as.numeric(as.matrix(tmp.data[,agwo.cols]))
  agwo.mean <- mean(agwo.data)
  
  tmp.tab <- matrix(c(suro.mean, ifwo.mean, agwo.mean), nrow = 3, ncol = 1)
  colnames(tmp.tab) = c('Mean Unit Flow (cfs/sq. mi)')
  rownames(tmp.tab) = c('SURface Outflow   ', 'InterFloW Outflow   ', 'Active GroundWater Outflow   ')
  
  tmp.tab <- signif(tmp.tab, digits = 3)
  tmp.tab <- kable(format(tmp.tab, digits = 3, drop0trailing = TRUE))
  return(tmp.tab)
}
  