tab3.monthly.high.flows <- function(percent_difference) {
  # Table 3: Monthly High Flow
  Table3 <- matrix(c(percent_difference[1,26], percent_difference[1,27], percent_difference[1,28],percent_difference[1,29], percent_difference[1,30], percent_difference[1,31],percent_difference[1,32], percent_difference[1,33], percent_difference[1,34],percent_difference[1,35], percent_difference[1,36], percent_difference[1,37],percent_difference[2,26],percent_difference[2,27], percent_difference[2,28], percent_difference[2,29],percent_difference[2,30], percent_difference[2,31], percent_difference[2,32],percent_difference[2,33], percent_difference[2,34], percent_difference[2,35],percent_difference[2,36], percent_difference[2,37],percent_difference[3,26], percent_difference[3,27], percent_difference[3,28],percent_difference[3,29], percent_difference[3,30], percent_difference[3,31],percent_difference[3,32], percent_difference[3,33], percent_difference[3,34],percent_difference[3,35], percent_difference[3,36], percent_difference[3,37]),
                   nrow = 12, ncol = 3);
  colnames(Table3) = c("VAHydro Scen. 1", "VAHydro Scen. 2", "Pct. Difference");
  rownames(Table3) = c("Jan. High Flow", "Feb. High Flow",
                       "Mar. High Flow", "Apr. High Flow",
                       "May High Flow", "Jun. High Flow",
                       "Jul. High Flow", "Aug. High Flow",
                       "Sep. High Flow", "Oct. High Flow",
                       "Nov. High Flow", "Dec. High Flow");
  Table3 <- signif(Table3, digits = 3)
  Table3 <- round(Table3, digits = 2)
  Table3 <- kable(format(Table3, digits = 3, drop0trailing = TRUE))
  return(Table3)
}
