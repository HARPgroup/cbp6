get.gage.timespan <- function(gage_number, start.date = '1984-01-01', end.date = '2014-12-31') {
  temp.dat <- gage_import_data_cfs(site_number = gage_number, start.date = start.date, end.date = end.date)
  
  gage.start.date <- temp.dat$date[1]
  gage.end.date <- temp.dat$date[length(temp.dat$date)]
  
  return(list(gage.start.date, gage.end.date))
}
