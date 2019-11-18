tab1.monthly.low.flows <- function(percent_difference) {
  # Table 1: Monthly Low Flow
  Table1 <- matrix(c(percent_difference[1,2], percent_difference[1,3],
                     percent_difference[1,4], percent_difference[1,5], percent_difference[1,6],
                     percent_difference[1,7], percent_difference[1,8], percent_difference[1,9],
                     percent_difference[1,10], percent_difference[1,11], percent_difference[1,12],
                     percent_difference[1,13], percent_difference[2,2],
                     percent_difference[2,3], percent_difference[2,4], percent_difference[2,5],
                     percent_difference[2,6], percent_difference[2,7], percent_difference[2,8],
                     percent_difference[2,9], percent_difference[2,10], percent_difference[2,11],
                     percent_difference[2,12], percent_difference[2,13], 
                     percent_difference[3,2], percent_difference[3,3], percent_difference[3,4],
                     percent_difference[3,5], percent_difference[3,6], percent_difference[3,7],
                     percent_difference[3,8], percent_difference[3,9], percent_difference[3,10],
                     percent_difference[3,11], percent_difference[3,12], percent_difference[3,13]),
                   nrow = 12, ncol = 3);
  colnames(Table1) = c("Scen. 1", "Scen. 2", "Pct. Difference");
  rownames(Table1) = c("Jan. Low Flow", "Feb. Low Flow",
                       "Mar. Low Flow", "Apr. Low Flow",
                       "May Low Flow", "Jun. Low Flow",
                       "Jul. Low Flow", "Aug. Low Flow",
                       "Sep. Low Flow", "Oct. Low Flow",
                       "Nov. Low Flow", "Dec. Low Flow");
  Table1 <- signif(Table1, digits = 3)
  Table1 <- round(Table1, digits = 2)
  Table1 <- kable(format(Table1, digits = 3, drop0trailing = TRUE))
  return(Table1)
}
