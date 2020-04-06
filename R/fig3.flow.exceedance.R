fig3.flow.exceedance <- function(all_data, cn1='Scenario 1', cn2='Scenario 2') {
  cn1 <- paste0('1: ', cn1)
  cn2 <- paste0('2: ', cn2)
  #Flow exceedance plot -----
  
  # Determining the "rank" (0-1) of the flow value
  num_observations <- as.numeric(length(all_data$Date))
  rank_vec <- as.numeric(c(1:num_observations))
  # Calculating exceedance probability
  prob_exceedance <- 100*((rank_vec) / (num_observations + 1))
  
  exceed_scenario1 <- sort(all_data$`Scenario 1 Flow`, decreasing = TRUE, na.last = TRUE)
  exceed_scenario2 <- sort(all_data$`Scenario 2 Flow`, decreasing = TRUE, na.last = TRUE)
  
  scenario1_exceedance <- quantile(exceed_scenario1, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
  scenario2_exceedance <- quantile(exceed_scenario2, probs = c(0.01, 0.05, 0.5, 0.95, 0.99), na.rm = TRUE)
  
  # Determining max flow value for exceedance plot scale
  max <- max(c(max(scenario1_exceedance), max(scenario2_exceedance)), na.rm = TRUE);
  min <- min(c(min(scenario1_exceedance), min(scenario2_exceedance)), na.rm = TRUE);
  
  if (max > 10000){
    max <- 100000
  }else if (max > 1000){
    max <- 10000
  }else if (max > 100){
    max <- 1000
  }else if (max > 10){
    max <- 100
  }
  if (min>100){
    min<-100
  }else if (min>10){ 
    min<-10
  }else 
    min<-1
  if (min==100){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(100, 1000, 10000, 100000), 
                                      limits=c(min,max))
  }else if (min==10){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(10, 100, 1000, 10000), 
                                      limits=c(min,max))
  }else if (min==1){
    fixtheyscale<- scale_y_continuous(trans = log_trans(), 
                                      breaks = c(1, 10, 100, 1000, 10000), 
                                      limits=c(min,max))
  }else
    fixtheyscale<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                      labels=scaleFUN, limits=c(min,max))
  df <- data.frame(prob_exceedance, exceed_scenario1, exceed_scenario2); 
  colnames(df) <- c('Date', 'Scenario1', 'Scenario2')
  options(scipen=5, width = 1400, height = 950)
  myplot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1, color=cn1), size=0.5) +
    geom_line(aes(y=Scenario2, color=cn2), size=0.5)+
    fixtheyscale+ 
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=12),
          axis.text=element_text(size=12, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    labs(x= "Probability of Exceedance (%)", y = "Flow (cfs)")
  ggsave("fig3.png", plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 3: Flow Exceedance saved at location ', as.character(getwd()), '/fig3.png', sep = ''))
}
