library(knitr)
library(lubridate)

tab.iqr.by.lrseg.lri.annual = function(lri.data) {
  years <- unique(year(as.Date(lri.data$date)))
  
  tmp.tab <- as.data.frame(matrix(nrow = length(years), ncol = 1))
  
  for (i in 1:length(years)) {
    tmp.dat <- lri.data[which(as.numeric(year(as.Date(lri.data$date))) == as.numeric(years[i])),]
    
    tmp.75pct <- signif(as.numeric(quantile(as.numeric(as.matrix(as.data.frame(lri.data$flow))), 0.75)), 3)
    tmp.25pct <- signif(as.numeric(quantile(as.numeric(as.matrix(as.data.frame(lri.data$flow))), 0.25)), 3)
    tmp.iqr <- signif(tmp.75pct - tmp.25pct, 3)
    flow.tabler <- paste0(tmp.iqr, ' [', tmp.25pct, ', ', tmp.75pct, ']')
    
    tmp.tab[i, 1] <- flow.tabler
  }
  
  colnames(tmp.tab) = c('IQR of Runit Flows (cfs/sq. mi) [25th, 75th]')
  rownames(tmp.tab) = c(years)
  
  tmp.tab <- kable(format(tmp.tab, drop0trailing = TRUE))
  return(tmp.tab)
}
