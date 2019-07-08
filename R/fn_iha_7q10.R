#' 7Q10 Metric Function 
#' @description Calculates 7Q10 of dataframe - must be trimmed to water year 
#' @param data a dataframe with hydrologic data 
#' @return The 7Q10 of the dataframe
#' @import IHA
#' @import PearsonDS
#' @export fn_iha_7q10

fn_iha_7q10 <- function(data) {
  g2 <- group2(data) 
  #print("Group 2, 7-day low flow results ")
  #print(g2["7 Day Min"])
  x <- as.vector(as.matrix(g2["7 Day Min"]))
  # fudge 0 values
  # correct for zeroes?? If so, use this loop:
  # This is not an "approved" method - we need to see how the GS/other authorities handles this
  for (k in 1:length(x)) {
    if (x[k] <= 0) {
      x[k] <- 0.00000001
      print (paste("Found 0.0 average in year", g2["year"], sep = " "))
    }
  }
  x <- log(x)
  pars <- PearsonDS:::pearsonIIIfitML(x)
  x7q10 <- exp(qpearsonIII(0.1, params = pars$par)) #1 note
  return(x7q10);
}