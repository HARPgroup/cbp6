#' Percent Difference of Metrics Function
#' @description Calculates percent difference between 65 different hydrologic metrics created from two different inputs 
#' @param metrics1 a dataframe containing the 65 hydrologic metrics from dataframe 1
#' @param metrics2 a dataframe containing the 65 hydrologic metrics from dataframe 2
#' @return A dataframe containing the 65 metrics from both original dataframes, and the percent difference between each metric
#' @export metrics_compare

# Difference Comparisons DONE
metrics_compare <- function(metrics1, metrics2) {
  difference <- 100*((metrics2-metrics1)/metrics1)
  metrics1[2,] <- metrics2
  metrics1[3,] <- difference
  rownames(metrics1) <- c('Scenario1','Scenario2','Percent Difference')
  
  return(metrics1)
}