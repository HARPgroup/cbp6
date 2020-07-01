# This function assigns the gage timespan of available data to a list that 
# consists of a start and end date. If there is not data available from the full
# default timespan of 1984-01-01 to 2014-12-31, the span will be trimmed to the
# first and last dates of available data.

get.gage.timespan <- function(gage_number, start.date = '1984-01-01', end.date = '2014-12-31') {
  # Imports all of the gage data data over the default timespan
  temp.dat <- gage_import_data_cfs(site_number = gage_number, start.date = start.date, end.date = end.date)
  
  # Assigns start and end date based on the first and last dates of available data
  gage.start.date <- temp.dat$date[1]    
  gage.end.date <- temp.dat$date[length(temp.dat$date)] 
  
  return(list(gage.start.date, gage.end.date)) 
}
