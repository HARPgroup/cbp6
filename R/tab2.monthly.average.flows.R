tab2.monthly.average.flows <- function(percent_difference) {
  # Table 2: Monthly Average Flow
  Table2 <- matrix(c(percent_difference[1,1], percent_difference[1,14], percent_difference[1,15], percent_difference[1,16], percent_difference[1,17], percent_difference[1,18], percent_difference[1,19], percent_difference[1,20], percent_difference[1,21], percent_difference[1,22], percent_difference[1,23], percent_difference[1,24], percent_difference[1,25], percent_difference[2,1], percent_difference[2,14], percent_difference[2,15], percent_difference[2,16], percent_difference[2,17], percent_difference[2,18], percent_difference[2,19], percent_difference[2,20], percent_difference[2,21], percent_difference[2,22], percent_difference[2,23], percent_difference[2,24], percent_difference[2,25], percent_difference[3,1], percent_difference[3,14], percent_difference[3,15], percent_difference[3,16], percent_difference[3,17], percent_difference[3,18], percent_difference[3,19], percent_difference[3,20], percent_difference[3,21], percent_difference[3,22], percent_difference[3,23], percent_difference[3,24], percent_difference[3,25]),
                   nrow = 13, ncol = 3);
  colnames(Table2) = c("Scen. 1", "Scen. 2", "Pct. Difference");
  rownames(Table2) = c("Overall Mean Flow", 
                       "Jan. Mean Flow", "Feb. Mean Flow",
                       "Mar. Mean Flow", "Apr. Mean Flow",
                       "May Mean Flow", "Jun. Mean Flow",
                       "Jul. Mean Flow", "Aug. Mean Flow",
                       "Sep. Mean Flow", "Oct. Mean Flow",
                       "Nov. Mean Flow", "Dec. Mean Flow");
  Table2 <- signif(Table2, digits = 3)
  Table2 <- round(Table2, digits = 2)
  Table2 <- kable(format(Table2, digits = 3, drop0trailing = TRUE))
  return(Table2)
}
