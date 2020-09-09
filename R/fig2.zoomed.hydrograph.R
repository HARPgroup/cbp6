fig2.zoomed.hydrograph <- function(all_data, cn1='Scenario 1', cn2='Scenario 2', export_path = '/tmp/') {
  cn1 <- paste0('1: ', cn1)
  cn2 <- paste0('2: ', cn2)
  # Zoomed hydrograph in year of lowest 90-year flow -----
  # Running scenario 1 calculations
  f3_scenario1 <- zoo(all_data$`Scenario 1 Flow`, order.by = all_data$Date)
  g2_scenario1 <- group2(f3_scenario1, year = 'water')
  # Running scenairo 2 calculations
  f3_scenario2 <- zoo(all_data$`Scenario 2 Flow`, order.by = all_data$Date)
  g2_scenario2 <- group2(f3_scenario2, year = 'water')
  
  yearly_scenario1_90DayMin <- g2_scenario1[,c(1,10)];
  yearly_scenario2_90DayMin <- g2_scenario2[,c(1,10)];
  low.year <- subset(yearly_scenario1_90DayMin, yearly_scenario1_90DayMin$`90 Day Min`==min(yearly_scenario1_90DayMin$`90 Day Min`));
  low.year <- low.year$year;
  low.year <- subset(all_data, year(all_data$Date)==low.year);
  
  # Scaling using max/min
  max <- max(c(max(low.year$`Scenario 1 Flow`), max(low.year$`Scenario 2 Flow`)), na.rm = TRUE);
  min <- min(c(min(low.year$`Scenario 1 Flow`), min(low.year$`Scenario 2 Flow`)), na.rm = TRUE);
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
  df <- data.frame(as.Date(low.year$Date), low.year$`Scenario 1 Flow`, low.year$`Scenario 2 Flow`); 
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
          axis.text=element_text(size=11, colour="black"),
          axis.title=element_text(size=14, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 0.5, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    labs(y = "Flow (cfs)")
  outfile <- paste0(export_path,"fig2.png")
  ggsave(outfile, plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 2: Zoomed Hydrograph saved at location ', outfile, sep = ''))
}
