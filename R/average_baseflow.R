#' Baseflow Metric Function 
#' @description Calculates baseflow of dataframe - must be trimmed to water year 
#' @param data a dataframe with hydrologic data 
#' @return The average baseflow
#' @import lubridate
#' @import lfstat
#' @import base
#' @export average.baseflow 

average.baseflow <- function(data){
  #setup
  data$year <- year(ymd(data$date))
  data$month <- month(ymd(data$date))
  data$day <- day(ymd(data$date))
  model1.data <- data.frame(data$day, data$month, data$year, data$flow)
  names(model1.data) <- c('day', 'month', 'year', 'flow')
  model1river <- createlfobj(model1.data, hyearstart = 10, baseflow = TRUE, meta = NULL)
  
  baseflowriver<- data.frame(model1river);
  colnames(baseflowriver) <-c ('day', 'month', 'year', 'flow', 'year', 'baseflow')
  baseflowriver<-baseflowriver[complete.cases(baseflowriver)==TRUE,]
  model1river<- data.frame(baseflowriver$day, baseflowriver$month, baseflowriver$year, 
                           baseflowriver$flow, baseflowriver$year, baseflowriver$baseflow);
  names(model1river) <- c('day', 'month', 'year', 'flow', 'hyear', 'baseflow')
  #calculation
  base <- signif(mean(model1river$baseflow), digits=3);
  return(base)
}