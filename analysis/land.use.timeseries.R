land.use.timeseries <- function(dirpath, segname) {
  csv.file <- paste(dirpath, '/', segname, '_0111-0211-0411.csv')
  data <- try(read.csv(csv.file))
  if (class(data) == 'try-error') {
    stop(paste0("ERROR: Missing climate .csv files (including ", dirpath, "/", segname, '_0111-0211-0411.csv)'))
  }
  trim <- which(as.Date(data$thisdate) >= as.Date('1991-01-01') & as.Date(data$thisdate) <= as.Date('2000-12-31'))
  data <- data[trim,]
  land.use.timeseries <- data.frame(matrix(data = NA, nrow = length(as.Date('1991-01-01'):as.Date('2000-12-31')), ncol = 6))
  colnames(land.use.timeseries) = c('date', 'cch', 'cci', 'for', 'pas', 'soy')
  land.use.timeseries$date <- as.Date('1991-01-01'):as.Date('2000-12-31')
  data$cch <- data$cch_suro + data$cch_ifwo + data$cch_agwo
  data$cci <- data$cci_suro + data$cci_ifwo + data$cci_agwo
  data$`for` <- data$for_suro + data$for_ifwo + data$for_agwo
  data$pas <- data$pas_suro + data$pas_ifwo + data$pas_agwo
  data$soy <- data$soy_suro + data$soy_ifwo + data$soy_agwo
  land.use.timeseries <- aggregate(x = list(cch = data$cch, cci = data$cci, `for` = data$`for`,
                                   pas = data$pas, soy = data$soy),
                                   FUN = sum, by = list(date = as.Date(data$thisdate)))
  write.csv(land.use.timeseries, paste(dirpath, paste0('land.use.timeseries_', segname, '.csv'), sep = '/'))
}