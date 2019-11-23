library(knitr)
library(lubridate)

tab.iqr.by.lrseg.flow.annual = function(tmp.data, flow.abbreviation) {
  flow.names <- grep(flow.abbreviation, colnames(tmp.data), value = TRUE)
  date.names <- grep('thisdate', colnames(tmp.data), value = TRUE)
  flow.cols <- which(colnames(tmp.data) %in% flow.names)
  date.cols <- which(colnames(tmp.data) %in% date.names)
  all.cols <- c(date.cols, flow.cols)
  flow.data <- as.data.frame(tmp.data[,all.cols])
  
  years <- unique(year(as.Date(flow.data$thisdate)))
  
  tmp.tab <- as.data.frame(matrix(nrow = length(years), ncol = 1))

  for (i in 1:length(years)) {
    tmp.dat <- flow.data[which(as.numeric(year(as.Date(flow.data$thisdate))) == as.numeric(years[i])),]
    
    tmp.75pct <- signif(as.numeric(quantile(as.numeric(as.matrix(as.data.frame(tmp.dat[,-1]))), 0.75)), 3)
    tmp.25pct <- signif(as.numeric(quantile(as.numeric(as.matrix(as.data.frame(tmp.dat[,-1]))), 0.25)), 3)
    tmp.iqr <- signif(tmp.75pct - tmp.25pct, 3)
    flow.tabler <- paste0(tmp.iqr, ' [', tmp.25pct, ', ', tmp.75pct, ']')
    
    tmp.tab[i, 1] <- flow.tabler
  }
  
  colnames(tmp.tab) = c('IQR of Unit Flows (cfs/sq. mi) [25th, 75th]')
  rownames(tmp.tab) = c(years)
  
  tmp.tab <- kable(format(tmp.tab, drop0trailing = TRUE))
  return(tmp.tab)
}
