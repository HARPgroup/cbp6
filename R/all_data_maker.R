all_data_maker <- function(data1, data2) {
  #all_data puts scenario flows and corresponding dates in one data frame
  all_data <- data.frame(data1$date, data1$flow, data2$flow) 
  all_data$counter <- 1:length(all_data$data1.date) # counter fixes issues with row numbers later on in script
  colnames(all_data) <- c('Date', 'Scenario 1 Flow', 'Scenario 2 Flow', 'Counter')
  return(all_data)
}