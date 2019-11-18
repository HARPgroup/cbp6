tab4.period.low.flows <- function(percent_difference) {
  # Table 4: Period Low Flows
  Table4 <- matrix(c(percent_difference[1,38], percent_difference[1,43],
                     percent_difference[1,39], percent_difference[1,44],
                     percent_difference[1,40], percent_difference[1,45],
                     percent_difference[1,41], percent_difference[1,46],
                     percent_difference[1,42], percent_difference[1,47],
                     percent_difference[1,59], percent_difference[1,60],
                     percent_difference[1,58], percent_difference[1,67], 
                     percent_difference[2,38], percent_difference[2,43],
                     percent_difference[2,39], percent_difference[2,44],
                     percent_difference[2,40], percent_difference[2,45],
                     percent_difference[2,41], percent_difference[2,46],
                     percent_difference[2,42], percent_difference[2,47],
                     percent_difference[2,59], percent_difference[2,60],
                     percent_difference[2,58], percent_difference[2,67],
                     percent_difference[3,38], percent_difference[3,43],
                     percent_difference[3,39], percent_difference[3,44],
                     percent_difference[3,40], percent_difference[3,45],
                     percent_difference[3,41], percent_difference[3,46],
                     percent_difference[3,42], percent_difference[3,47],
                     percent_difference[3,59], percent_difference[3,60],
                     percent_difference[3,58], percent_difference[3,67]), 
                   nrow = 14, ncol = 3);
  colnames(Table4) = c("Scen. 1", "Scen. 2", "Pct. Difference");
  rownames(Table4) = c("Min. 1 Day Min", "Med. 1 Day Min", 
                       "Min. 3 Day Min", "Med. 3 Day Min",
                       "Min. 7 Day Min", "Med. 7 Day Min",
                       "Min. 30 Day Min", "Med. 30 Day Min",
                       "Min. 90 Day Min", "Med. 90 Day Min", 
                       "7Q10", "Year of 90-Day Min. Flow",
                       "Drought Year Mean", "Mean Baseflow");
  Table4 <- signif(Table4, digits = 3)
  Table4 <- round(Table4, digits = 2)
  Table4 <- kable(format(Table4, digits = 3, drop0trailing = TRUE))
  return(Table4)
}
