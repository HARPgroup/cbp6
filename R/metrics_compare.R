# Difference Comparisons DONE
metrics.compare <- function(metrics1, metrics2) {
  difference <- (metrics2-metrics1)/metrics1
  difference <- abs(difference*100)
  metrics1[2,] <- metrics2
  metrics1[3,] <- difference
  rownames(metrics1) <- c('Scenario1','Scenario2','Percent Difference')
  
  return(metrics1)
}