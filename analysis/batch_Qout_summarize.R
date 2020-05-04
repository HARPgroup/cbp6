batch.Qout.summarize <- function(dirpath) {
  csv.list <- list.files(path = dirpath, pattern = "_0111\\.csv$", recursive = FALSE)
  
  qout.table <- data.frame(matrix(data = NA, nrow = length(csv.list), ncol = 2))
  colnames(qout.table) = c('segment', 'Qout.mean')
  for (i in 1:length(csv.list)) {
    data <- try(read.csv(paste(dirpath, csv.list[i], sep = '/')))
    data$thisdate <- as.Date(paste(data[,1], data[,2], data[,3], sep = '-'))
    trim <- which(as.Date(data$thisdate) >= as.Date('1991-01-01') & as.Date(data$thisdate) <= as.Date('2000-12-31'))
    data <- data[trim,]
    
    print(paste('Downloading data for segment', i, 'of', length(csv.list), sep = ' '))
    
    segment <- substr(csv.list[i], 1, 13)
    
    if (class(data) == 'try-error') {
      stop(paste0("ERROR: Missing Qout .csv files (including ", dirpath, "/", csv.list[i]))
    }
    
    qout.table$segment[i] <- segment
    qout.table$Qout.mean[i] <- mean(as.numeric(data[,5]))
  }
  
  write.csv(qout.table, paste(dirpath, 'Qout.table.csv', sep = '/'))
}