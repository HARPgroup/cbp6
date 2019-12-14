tab6.nonexceedence.flows <- function(percent_difference, cn1='Scenario 1', cn2='Scenario 2') {
  # Table 6: Non-Exceedance Flows
  Table6 <- matrix(c(percent_difference[1,62], percent_difference[1,63], percent_difference[1,64],percent_difference[1,65], percent_difference[1,66], percent_difference[1,61],percent_difference[2,62], percent_difference[2,63], percent_difference[2,64],percent_difference[2,65], percent_difference[2,66], percent_difference[2,61],percent_difference[3,62], percent_difference[3,63], percent_difference[3,64],percent_difference[3,65], percent_difference[3,66], percent_difference[3,61]), 
                   nrow = 6, ncol = 3);
  colnames(Table6) = c(cn1, cn2, "Pct. Difference");
  rownames(Table6) = c("1% Non-Exceedance", "5% Non-Exceedance",
                       "50% Non-Exceedance", "95% Non-Exceedance",
                       "99% Non-Exceedance", "Sept. 10% Non-Exceedance");
  Table6 <- signif(Table6, digits = 3)
  Table6 <- round(Table6, digits = 2)
  Table6 <- kable(format(Table6, digits = 3, drop0trailing = TRUE))
  return(Table6)
}
