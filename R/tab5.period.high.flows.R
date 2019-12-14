tab5.period.high.flows <- function(percent_difference, cn1='Scenario 1', cn2='Scenario 2') {
  # Table 5: Period High Flows
  Table5 <- matrix(c(percent_difference[1,48], percent_difference[1,53],
                     percent_difference[1,49], percent_difference[1,54],
                     percent_difference[1,50], percent_difference[1,55],
                     percent_difference[1,51], percent_difference[1,56],
                     percent_difference[1,52], percent_difference[1,57],
                     percent_difference[2,48], percent_difference[2,53],
                     percent_difference[2,49], percent_difference[2,54],
                     percent_difference[2,50], percent_difference[2,55],
                     percent_difference[2,51], percent_difference[2,56],
                     percent_difference[2,52], percent_difference[2,57],
                     percent_difference[3,48], percent_difference[3,53],
                     percent_difference[3,49], percent_difference[3,54],
                     percent_difference[3,50], percent_difference[3,55],
                     percent_difference[3,51], percent_difference[3,56],
                     percent_difference[3,52], percent_difference[3,57]), 
                   nrow = 10, ncol = 3);
  colnames(Table5) = c(cn1, cn2, "Pct. Difference");
  rownames(Table5) = c("Max. 1 Day Max", "Med. 1 Day Max", 
                       "Max. 3 Day Max", "Med. 3 Day Max",
                       "Max. 7 Day Max", "Med. 7 Day Max",
                       "Max. 30 Day Max", "Med. 30 Day Max",
                       "Max. 90 Day Max", "Med. 90 Day Max");
  Table5 <- signif(Table5, digits = 3)
  Table5 <- round(Table5, digits = 2)
  Table5 <- kable(format(Table5, digits = 3, drop0trailing = TRUE))
  return(Table5)
}
