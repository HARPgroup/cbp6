figs11to13.smallest.diff.periods <- function(all_data, cn1='Scenario 1', cn2='Scenario 2') {
  # This section will create a hydrograph that will zoom in on 3 month segments where difference is low
  # It does so for the top three lowest difference periods
  
  # find the first date for which data is collected, (in date format)
  # and a date that is roughly one year and two months past the first date
  YearStart <- as.character(as.Date(all_data$Date[1]))     
  fixer <- as.numeric(which(all_data$Date == paste0((year(YearStart)+1),"-11-30")))
  YearEnd <- as.character(as.Date(all_data$Date[fixer]))
  
  # YearStart_Row and YearEnd_Row are the rows corresponding the the YearStart and YearEnd dates
  YearStart_Row <- as.numeric(which(all_data$Date==YearStart)) 
  YearEnd_Row <- as.numeric(which(all_data$Date==YearEnd))
  
  # initalize dataframes and counters, assign names for dataframe columns
  #AvgMonthlyDifference: used within nested for loop to create a 1x12 matrix that holds 1 year of 3 month difference segments
  #Timespan_Difference: used in large loop to store values from AvgMonthlyDifference; holds entire timespan of 3 month difference segments
  AvgMonthlyDifference <- data.frame(matrix(nrow=1,ncol=1));  
  names(AvgMonthlyDifference)<-'Difference' 
  Timespan_Difference <- data.frame(matrix(nrow=1, ncol=1)); 
  names(Timespan_Difference)<-'Difference'
  i <- 1; # used for first for loop to advance a year
  x <- 1 # x and y used to advance dataframes
  y <- 12
  
  # start loops used for yearly and monthly data  -------------------------------------------------------------
  
  loop <- as.numeric(round(length(data1$date)/365, digits = 0))-1
  for (i in 1:loop){                                # run loop for an entire data series
    year <- all_data[YearStart_Row:YearEnd_Row,] # specify year: 10-01-year1 to 11-30-year2
    m <- 1                                        # counter for nested loop
    
    MonthStart <- YearStart  # first date for 3 month timespan                      
    doi <- as.Date(MonthStart) 
    doi <- doi + seq(0,365,31) 
    # doi= date of interest. dummy variable just to create the function next.month
    next.month <- function(doi) as.Date(as.yearmon(doi) + 1/12) +  as.numeric(as.Date(doi)-(as.Date(as.yearmon(doi))))
    
    #(re)initalize variables for the nested loop
    MonthEnd <-data.frame(next.month(doi));  # last date in 3 month timespan - used function to determine 3rd month
    MonthEnd <- MonthEnd[3,1]-2 # specifies end of month 3 as last date
    # (technically specifies 01 of month 4)
    
    # row numbers corresponding with start and end dates, as a number. See note below 
    MonthStart_Row <- as.numeric(which(as.Date(all_data$Date)==as.Date(MonthStart)))
    MonthEnd_Row <- as.numeric(which(as.Date(all_data$Date)==as.Date(MonthEnd)))
    
    # Note: Counter column is used here to specify which row starts MonthStart and MonthEnd_Row.
    # When rows are pulled from year row numbers are also pulled, 
    # so a counter must be used for proper row numbers.
    Start_new <- as.numeric(which(year$Counter==MonthStart_Row))
    End_new <- as.numeric(which(year$Counter==MonthEnd_Row))
    
    # begin nested loop
    for (m in 1:12){
      month_time <- year[Start_new:End_new ,]         #extract data for 3 month timespan within year of interest
      avgmonth_scenario1 <- mean(month_time$`Scenario 1 Flow`)   # find average of scenario 1 flow for 3 months
      avgmonth_scenario2 <- mean(month_time$`Scenario 2 Flow`) # find average of scenario 2 flow for 3 months
      AvgMonthlyDifference[m,1] <- (avgmonth_scenario1 - avgmonth_scenario2)/ avgmonth_scenario1 * 100  # percent difference between scenarios
      
      MonthEnd<-as.Date(MonthEnd)
      MonthEnd<-MonthEnd+1
      MonthEndyear <- year(MonthEnd)   # Year associated with last month of extracted data 
      MonthEndmonth <- month(MonthEnd) # Month associated with last month of extracted data 
      
      # the next three lines are for the difference calculations -- stop on 1st of month 4 (31 of month 3)
      # Note: this DOES include the 1st of the next month in difference calculation
      # Put a control on what date the script advances by - if date is not 1st of month, reset it
      DateCheck <- as.Date(paste0(MonthEndyear,'-',MonthEndmonth,'-01'))
      if (MonthEnd != DateCheck)
        MonthEnd <- as.Date(paste0(MonthEndyear,'-', MonthEndmonth, '-01'))
      
      MonthEnd <- MonthEnd-1
      stopdate <- as.Date(MonthEnd)
      AvgMonthlyDifference[m,2] <- stopdate
      
      # Advance to next month or count
      MonthStart <- next.month(MonthStart)
      MonthEnd <- MonthEnd+1
      MonthEnd <- next.month(MonthEnd)
      MonthEnd <- MonthEnd-1
      StartMonth_Row <- which(as.Date(all_data$Date)==as.Date(MonthStart));     
      StartMonth_Row <- as.numeric(StartMonth_Row)
      EndMonth_Row <- which(as.Date(all_data$Date)==as.Date(MonthEnd));     
      EndMonth_Row <- as.numeric(EndMonth_Row)
      Start_new <- which(year$Counter==StartMonth_Row)
      End_new <- which(year$Counter==EndMonth_Row)
      m <- m + 1
    }
    
    Timespan_Difference[x:y, 1] <- AvgMonthlyDifference[,1] # save the difference entries from AvgMonthlyDifference
    Timespan_Difference[x:y, 2] <- AvgMonthlyDifference[,2] # save the dates 
    
    # advance Timespan_Difference for next run
    x <- x + 12  
    y <- y + 12
    
    YearStart <- as.Date(YearStart) + 365  # Advance 1 year
    YearEnd <- as.Date(YearEnd) + 365     # Advance 1 year & 2 months (from 10-01 to 11-30)
    
    # Put a control on what date the script advances by - if end date is not 11-30, reset it
    # - if begin date is not -10-01, reset it
    YearBeginyear <- year(YearStart)  # pull year of beginning year
    YearBeginCheck <- as.Date(paste0(YearBeginyear,'-10-01'))
    if (YearBeginyear != YearBeginCheck)     
      YearStart <- as.Date(paste0(YearBeginyear,'-10-01'))
    
    YearEndyear <- year(YearEnd)  # pull year of ending year
    YearEndCheck <- as.Date(paste0(YearEndyear,'-11-30'))
    if (YearEnd != YearEndCheck)     
      YearEnd <- as.Date(paste0(YearEndyear,'-11-30'))
    YearStart_Row <- which(as.Date(all_data$Date)== as.Date(YearStart))
    YearEnd_Row <- which(as.Date(all_data$Date) == as.Date(YearEnd))
    
    i <- i + 1
  }
  
  # This section of code will plot timeframes with high difference.
  # count the number of 3 month periods over 20% difference, plot the highest 3 periods.
  
  Timespan_Difference$Logic <- Timespan_Difference$Difference<=20 | Timespan_Difference$Difference>= -20
  less20 <- Timespan_Difference[Timespan_Difference$Logic=='TRUE',]
  HighDifference <- Timespan_Difference[order(abs(Timespan_Difference$Difference), decreasing = FALSE),]
  names(HighDifference)<-c('Difference', 'Date', 'Logic')
  
  # pull data for each of these 3 month segments.
  HighestDifferences <- HighDifference[1:3,]
  HighestDifferences$Date <- as.Date(HighestDifferences$Date)
  
  # initalize variables for loop
  differenceyear <- data.frame(matrix(nrow=1,ncol=6))
  differencedates <- data.frame(matrix(nrow=1, ncol=2))
  names(differenceyear)<- c('endyear', 'endmonth', 'enddate', 'startyear', 'startmonth', 'startdate')
  names(differencedates)<- c('start date row', 'end date row')
  storeplotdata1<- data.frame(matrix(nrow=1, ncol=4))
  names(storeplotdata1)<- c('Date', 'Scenario 1 Flow', 'Scenario 2 Flow', 'Counter')
  storeplotdata2<- data.frame(matrix(nrow=1, ncol=4))
  names(storeplotdata2)<- c('Date', 'Scenario 1 Flow', 'Scenario 2 Flow', 'Counter')
  storeplotdata3<- data.frame(matrix(nrow=1, ncol=4))
  names(storeplotdata3)<- c('Date', 'Scenario 1 Flow', 'Scenario 2 Flow', 'Counter')
  
  q <- 1
  
  for (q in 1:length(HighestDifferences)){
    differenceyear[q,1] <- year(HighestDifferences$Date[q])  # ending year
    differenceyear[q,2]<- month(HighestDifferences$Date[q]) + 1 # ending month
    differenceyear[q,4]<- year(HighestDifferences$Date[q]) #startyear
    differenceyear[q,5]<- month(HighestDifferences$Date[q])-2 #startmonth
    
    if (differenceyear[q,2] > 12) { # if end month is jan, must move year up
      differenceyear[q,4] <- differenceyear[q,1]
      differenceyear[q,1]<- differenceyear[q,1] + 1 # year for jan moves
      differenceyear[q,2] <- 1
    }else if (differenceyear[q,5] == -1) {
      differenceyear[q,4] <- differenceyear[q,4] - 1 # if january, go back a year and start november
      differenceyear[q,5] <- 11
    }else if (differenceyear[q,5] == 0) {
      differenceyear[q,4] <- differenceyear[q,4] - 1 # if january, go back a year and start november
      differenceyear[q,5] <- 12
    } else{
      differenceyear[q,1]<- differenceyear[q,1]  #endyear
      differenceyear[q,2]<- differenceyear[q,2]  #endmonth
      differenceyear[q,4]<- differenceyear[q,4]  #startyear
      differenceyear[q,5]<- differenceyear[q,5]  #startmonth
    }
    differenceyear[q,3]<- paste0(differenceyear[q,1], '-',differenceyear[q,2], '-01') #enddate
    differenceyear$enddate <- as.Date(differenceyear$enddate)
    differenceyear[q,6]<- as.Date(paste0(differenceyear[q,4], '-', differenceyear[q,5], '-01')) #startdate
    differenceyear$startdate <- as.Date(differenceyear$startdate)
    
    differencedates[q,1]<- as.character(differenceyear$startdate[q])
    differencedates[q,2]<- as.character(differenceyear$enddate[q]-1)
    differencedates[q,3]<- which(as.Date(all_data$Date)==as.Date(differencedates$`start date row`[q]))
    differencedates[q,4]<- which(as.Date(all_data$Date)==as.Date(differencedates$`end date row`[q]))
    
    plot1<-all_data[differencedates$V3[q]:differencedates$V4[q],]
    if (q==1){
      storeplotdata1<- plot1
    }else if(q==2){
      storeplotdata2<- plot1
    }else if(q==3){
      storeplotdata3<- plot1
    }
    q <- q+1
  }
  
  # # create and export 3 plots: \plot for info of row q
  
  difference1 <- signif(HighestDifferences$Difference[1], digits=3)     #Create difference variable to display on graph
  difference2 <- signif(HighestDifferences$Difference[2], digits=3)
  difference3 <- signif(HighestDifferences$Difference[3], digits=3)
  
  # CREATES OUTPUT MATRIX -------------------------------------------------------
  avg_scenario1 <- mean(data1$flow)
  avg_scenario2 <- mean(data2$flow)
  
  # also want to list the number of timespans that were over 20% difference.
  less20 <- signif(nrow(less20)/nrow(Timespan_Difference)*100, digits=3)
  OUTPUT_MATRIX_LESS <- matrix(c(avg_scenario1, avg_scenario2, less20), nrow=1, ncol=3)
  rownames(OUTPUT_MATRIX_LESS) = c("Flow")
  colnames(OUTPUT_MATRIX_LESS) = c('Scenario 1', 'Scenario 2', 'Difference<20 (%)')
  overall_difference <- signif((OUTPUT_MATRIX_LESS[1,1]-OUTPUT_MATRIX_LESS[1,2])/OUTPUT_MATRIX_LESS[1,1]*100, digits=3)
  OUTPUT_MATRIX_LESS <- matrix(c(less20, percent_difference[3,]), nrow=1, ncol=2)
  rownames(OUTPUT_MATRIX_LESS) = c("Percent")
  colnames(OUTPUT_MATRIX_LESS) = c('Difference < 20%', 'Overall Difference')
  
  OUTPUT_MATRIX_LESS <- signif(as.numeric(OUTPUT_MATRIX_LESS, digits = 2))
  OUTPUT_MATRIX_LESSsaver <- OUTPUT_MATRIX_LESS
  OUTPUT_MATRIX_LESS <- kable(format(OUTPUT_MATRIX_LESS, digits = 3))
  # plot for highest difference 
  # Max/min for y axis scaling
  max <- max(c(max(storeplotdata1$`Scenario 1 Flow`), max(storeplotdata1$`Scenario 2 Flow`)));
  min <- min(c(max(storeplotdata1$`Scenario 1 Flow`), max(storeplotdata1$`Scenario 2 Flow`)));
  xpos1 <- min(storeplotdata1$Date)+20
  xpos2 <- max(storeplotdata1$Date)-20
  
  # Creating and exporting plot
  df <- data.frame(as.Date(storeplotdata1$Date), storeplotdata1$`Scenario 1 Flow`, storeplotdata1$`Scenario 2 Flow`); 
  colnames(df) <- c('Date', 'Scenario1', 'Scenario2')
  options(scipen=5, width = 1400, height = 950)
  difference1plot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1, color=cn1), size=0.5) +
    geom_line(aes(y=Scenario2, color=cn2), size=0.5)+
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=14),
          axis.text=element_text(size=14, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    annotate("text", x=xpos1, y=1.05*max, label= paste0('Difference:', '',difference1, '', '%'), size=3)+
    annotate("text", x=xpos2, y=1.05*max, label= paste0('Date Range: ', '', 
                                                        min(storeplotdata1$Date),': ', max(storeplotdata1$Date)), size=3)+
    labs(y = "Flow (cfs)")
  ggsave("fig11.png", plot = difference1plot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 11: Smallest Difference Period saved at location ', as.character(getwd()), '/fig11.png', sep = ''))
  
  # plot for second highest difference 
  # Max/min for y axis scaling
  max <- max(c(max(storeplotdata2$`Scenario 1 Flow`), max(storeplotdata2$`Scenario 2 Flow`)));
  min <- max(c(min(storeplotdata2$`Scenario 1 Flow`), max(storeplotdata2$`Scenario 2 Flow`)));
  xpos1 <- min(storeplotdata2$Date)+20
  xpos2 <- max(storeplotdata2$Date)-20
  
  # Creating and exporting plot
  df <- data.frame(as.Date(storeplotdata2$Date), storeplotdata2$`Scenario 1 Flow`, storeplotdata2$`Scenario 2 Flow`); 
  colnames(df) <- c('Date', 'Scenario1', 'Scenario2')
  options(scipen=5, width = 1400, height = 950)
  difference2plot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1, color=cn1), size=0.5) +
    geom_line(aes(y=Scenario2, color=cn2), size=0.5)+
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=14),
          axis.text=element_text(size=14, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    annotate("text", x=xpos1, y=1.05*max, label= paste0('Difference:', '',difference2, '', '%'), size=3)+
    annotate("text", x=xpos2, y=1.05*max, label= paste0('Date Range: ', '', 
                                                        min(storeplotdata2$Date),': ', max(storeplotdata2$Date)), size=3)+
    labs(y = "Flow (cfs)")
  ggsave("fig12.png", plot = difference2plot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 12: Second Smallest Difference Period saved at location ', as.character(getwd()), '/fig12.png', sep = ''))
  
  # plot for third highest difference 
  # Max/min for y axis scaling
  max <- max(c(max(storeplotdata3$`Scenario 1 Flow`), max(storeplotdata3$`Scenario 2 Flow`)));
  min <- min(c(max(storeplotdata3$`Scenario 1 Flow`), max(storeplotdata3$`Scenario 2 Flow`)));
  xpos1 <- min(storeplotdata3$Date)+20
  xpos2 <- max(storeplotdata3$Date)-20
  
  # Creating and exporting plot
  df <- data.frame(as.Date(storeplotdata3$Date), storeplotdata3$`Scenario 1 Flow`, storeplotdata3$`Scenario 2 Flow`); 
  colnames(df) <- c('Date', 'Scenario1', 'Scenario2')
  options(scipen=5, width = 1400, height = 950)
  difference3plot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1, color=cn1), size=0.5) +
    geom_line(aes(y=Scenario2, color=cn2), size=0.5)+
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=14),
          axis.text=element_text(size=14, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    annotate("text", x=xpos1, y=1.05*max, label= paste0('Difference:', '',difference3, '', '%'), size=3)+
    annotate("text", x=xpos2, y=1.05*max, label= paste0('Date Range: ', '', 
                                                        min(storeplotdata3$Date),': ', max(storeplotdata3$Date)), size=3)+
    labs(y = "Flow (cfs)")
  
  ggsave("fig13.png", plot = difference3plot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 13: Third Smallest Difference Period saved at location ', as.character(getwd()), '/fig13.png', sep = ''))
}
