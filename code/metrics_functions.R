# _ Day Min Calculation
etc_day.min <- function(data, num.day, min_or_med) {
  # Setup for ___ Day Min Calculations
  f3 <- zoo(data$flow, order.by = data$date)
  g2 <- group2(f3, year = 'water')
  
  #Calculating _ Day Min
  yearly_DayMin <- g2[,c(1,2)];
  if (min_or_med = "min"){
    metric <- signif(min(yearly_DayMin$`_ Day Min`), digits=3);
  } else {
    metric <- signif(median(yearly_DayMin$`_ Day Min`), digits=3);
  }
  return(metric)
}

# _ Day Max Calculation
etc_day.max <- function(data, num.day, min_or_med) {
  # Setup for ___ Day Max Calculations
  f3 <- zoo(data$flow, order.by = data$date)
  g2 <- group2(f3, year = 'water')
  
  # Calculating _ day max 
  yearly_DayMax <- g2[,c(1,3)];
  if (min_or_med = "min"){
    metric <- signif(max(yearly_DayMax$`_ Day Max`), digits=3);
  } else {
    metric <- signif(median(yearly_DayMax$`_ Day Max`), digits=3);
  }
  return(metric)
}

# Monthly Mean Calculation
monthly.mean <- function(data, num.month) {
  # Setup for Monthly Means Calculations
  monthly_means <- aggregate(data$flow, list(data$month), FUN = mean)
  mean_flows <- signif(monthly_means[2,2], digits=3);
  monthly.mean.flow <- which(mean_flows$month == num.month)
  return(monthly.mean.flow)
}

# Monthly Low Calculation
monthly.min <- function(data, num.month) {
  monthly_mins <- zoo(data$flow, order.by = data$date)
  min_flows <- signif(fn_iha_mlf(flows_model1,1), digits=3);
  monthly.min.flow <- which(min_flows$month == num.month)
  return(monthly.min.flow)
}

# Monthly High Calculation
monthly.max <- function(data, num.month) {
  monthly_maxs <- zoo(data$flow, order.by = data$date)
  max_flows <- signif(fn_iha_mhf(flows_model1,9), digits=3);
  monthly.max.flow <- which(max_flows$month == num.month)
  return(monthly.max.flow)
}

# Flow Exceedance Calculation 
flow.exceedance <- function(data, prob) {
  # Setup for Flow Exceedance Calculations
  # Creating vectors of decreasing flow magnitude
  dec_flows <- sort(data$flow, decreasing = TRUE)
  
  # Determining the "rank" (0-1) of the flow value
  num_observations <- as.numeric(length(data$date))
  rank_vec <- as.numeric(c(1:num_observations))
  
  # Calculating exceedance probability
  prob_exceedance <- 100*((rank_vec) / (num_observations + 1))
  
  # Creating vectors of calculated quantiles
  prob_exceedance <- quantile(data, probs = prob)
  return(prob_exceedance)
}

# September 10% Flow Calculation 
sept.10.flow <- function(data) {
  sept_flows <- subset(data, month == '9')
  sept_10 <- quantile(sept_flows$flow, 0.10)
  return(sept_10)
}

# Overall Mean Flow Calculation 
overall.mean.flow <- function(data) {
  mean.flow <- signif(mean(data$flow), digits=3);
  return(mean.flow)
}

# DROUGHT OF RECORD (MIN. 90 DAY MIN.) YEAR Calculation
drought.of.record <- function(data) {
  DoR <- fn_iha_DOR_Year(data);
  return(DoR)
}

# Baseflow (Average)
average.baseflow <- function(data){
  # Setup for Baseflow Calculations
  data <- data.frame(data$day, data$month, data$year, data$flow)
  names(data) <- c('day', 'month', 'year', 'flow')
  
  # Creating lowflow objects
  modelriver <- createlfobj(data, hyearstart = 10, baseflow = TRUE, meta = NULL)
  baseflowriver<- data.frame(modelriver);
  colnames(baseflowriver) <-c ('mday', 'mmonth', 'myear', 'mflow', 'mHyear', 'mBaseflow',
                               'gday', 'gmonth', 'gyear', 'gflow', 'gHyear', 'gBaseflow')
  # removing NA values
  baseflowriver<-baseflowriver[complete.cases(baseflowriver)==TRUE,]
  modelriver<- data.frame(baseflowriver$gday, baseflowriver$gmonth, baseflowriver$gyear, 
                           baseflowriver$gflow, baseflowriver$gHyear, baseflowriver$gBaseflow);
  names(modelriver) <- c('day', 'month', 'year', 'flow', 'hyear', 'baseflow')
  
  # Adding date vectors
  modelriver$Date <- as.Date(paste0(modelriver$year,"-",modelriver$month,"-",modelriver$day))
  
  base <- signif(mean(modelriver$baseflow), digits=3);
  return(base)
}

# LOW YEARLY MEAN
low.yearly.mean <- function(data) { 
  DoR <- fn_iha_DOR_Year(data)
  # Setup for Baseflow Calculations
  data <- data.frame(data$day, data$month, data$year, data$flow)
  names(data) <- c('day', 'month', 'year', 'flow')
  
  # Creating lowflow objects
  modelriver <- createlfobj(data, hyearstart = 10, baseflow = TRUE, meta = NULL)
  baseflowriver<- data.frame(modelriver);
  colnames(baseflowriver) <-c ('mday', 'mmonth', 'myear', 'mflow', 'mHyear', 'mBaseflow',
                               'gday', 'gmonth', 'gyear', 'gflow', 'gHyear', 'gBaseflow')
  # removing NA values
  baseflowriver<-baseflowriver[complete.cases(baseflowriver)==TRUE,]
  modelriver<- data.frame(baseflowriver$gday, baseflowriver$gmonth, baseflowriver$gyear, 
                          baseflowriver$gflow, baseflowriver$gHyear, baseflowriver$gBaseflow);
  names(modelriver) <- c('day', 'month', 'year', 'flow', 'hyear', 'baseflow')
  
  # Adding date vectors
  modelriver$Date <- as.Date(paste0(modelriver$year,"-",modelriver$month,"-",modelriver$day))
  
  # Setup for Low Flows
  lf_model <- aggregate(modelriver$flow, by = list(modelriver$hyear), FUN = mean)
  colnames(lf_model) <- c('Water_Year', 'Mean_Flow')
  lf_model <- which(lf_model["Water_Year"] == DoR)
  lf_model <- lf_model["Mean_Flow"][lf_model]
  lfmin <- lf_model
  return(lfmin)
}

  