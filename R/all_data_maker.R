library(dplyr)

all_data_maker <- function(data1, data2) {
  #all_data puts scenario flows and corresponding dates in one data frame
  all_data <- full_join(data1, data2, by = 'date')
  all_data <- all_data[order(as.Date(all_data$date)),]
  all_data$counter <- 1:length(all_data$date) # counter fixes issues with row numbers later on in script
  colnames(all_data) <- c('Date', 'Scenario 1 Flow', 'Scenario 2 Flow', 'Counter')
  return(all_data)
}
