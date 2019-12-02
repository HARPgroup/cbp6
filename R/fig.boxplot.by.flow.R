fig.boxplot.by.flow <- function(tmp.data, flow.abbreviation, lrseg.name) {
  flow.names <- grep(flow.abbreviation, colnames(tmp.data), value = TRUE)
  date.names <- grep('thisdate', colnames(tmp.data), value = TRUE)
  flow.cols <- which(colnames(tmp.data) %in% flow.names)
  date.cols <- which(colnames(tmp.data) %in% date.names)
  all.cols <- c(date.cols, flow.cols)
  flow.data <- as.data.frame(tmp.data[,all.cols])
  
  date.col <- as.Date(flow.data$thisdate)
  flow.matrix <- flow.data[,-1]
  for (i in 1:ncol(flow.matrix)) {
    flow.matrix[,i] <- as.numeric(levels(flow.matrix[,i]))[flow.matrix[,i]]
  }
  sum.flow.col <- rowSums(flow.matrix)
  summed.data <- data.frame(date.col, sum.flow.col)
  colnames(summed.data) <- c('date', 'flow')
  
  boxplot(as.numeric(summed.data$flow) ~ year(summed.data$date), outline = FALSE, ylab = 'Unit Flow (cfs)', xlab = 'Date')
  dev.copy(png, paste0('fig.', flow.abbreviation, '.', lrseg.name, '.png'))
  dev.off()
  print(paste('Fig.: ',  flow.abbreviation, ' Boxplot for lrseg ', lrseg.name, ' saved at location ', as.character(getwd()), '/fig', flow.abbreviation, '.', lrseg.name, '.png', sep = ''))
}
