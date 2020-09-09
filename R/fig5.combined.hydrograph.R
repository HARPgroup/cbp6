fig5.combined.hydrograph <- function(all_data, export_path = '/tmp/') {
  data1$year <- year(ymd(data1$date))
  data1$month <- month(ymd(data1$date))
  data1$day <- day(ymd(data1$date))
  data2$year <- year(ymd(data2$date))
  data2$month <- month(ymd(data2$date))
  data2$day <- day(ymd(data2$date))
  
  
  scenario1river <- createlfobj(data1, hyearstart = 10, baseflow = TRUE, meta = NULL)
  scenario2river <- createlfobj(data2, hyearstart = 10, baseflow = TRUE, meta = NULL)
  baseflowriver<- data.frame(scenario1river, scenario2river);
  colnames(baseflowriver) <-c ('mday', 'mmonth', 'myear', 'mflow', 'mHyear', 'mBaseflow',
                               'gday', 'gmonth', 'gyear', 'gflow', 'gHyear', 'gBaseflow')
  
  # removing NA values
  baseflowriver<-baseflowriver[complete.cases(baseflowriver)==TRUE,]
  scenario2river<- data.frame(baseflowriver$gday, baseflowriver$gmonth, baseflowriver$gyear, 
                              baseflowriver$gflow, baseflowriver$gHyear, baseflowriver$gBaseflow);
  scenario1river<- data.frame(baseflowriver$mday, baseflowriver$mmonth, baseflowriver$myear, 
                              baseflowriver$mflow, baseflowriver$mHyear, baseflowriver$mBaseflow)
  names(scenario1river) <- c('day', 'month', 'year', 'flow', 'hyear', 'baseflow')
  names(scenario2river) <- c('day', 'month', 'year', 'flow', 'hyear', 'baseflow')
  # Adding date vectors
  scenario1river$date <- as.Date(paste0(scenario1river$year,"-",scenario1river$month,"-",scenario1river$day))
  scenario2river$date <- as.Date(paste0(scenario2river$year,"-",scenario2river$month,"-",scenario2river$day))
  
  # Determining max flow value for plot scale
  max <- max(c(max(scenario1river$baseflow), max(scenario2river$baseflow), max(scenario1river$flow), max(scenario2river$flow)), na.rm = TRUE);
  min <- min(c(min(scenario1river$baseflow), min(scenario2river$baseflow), min(scenario1river$flow), min(scenario2river$flow)), na.rm = TRUE);
  
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
  
  df <- data.frame(as.Date(scenario1river$date), scenario1river$baseflow, scenario2river$baseflow, scenario1river$flow, scenario2river$flow); 
  colnames(df) <- c('Date', 'Scenario1Baseflow', 'Scenario2Baseflow','Scenario1Flow', 'Scenario2Flow')
  
  par(mfrow = c(1,1));
  options(scipen=5, width = 1400, height = 950)
  myplot <- ggplot(df, aes(x=Date)) + 
    geom_line(aes(y=Scenario1Flow, color=paste("Scen. 1 Flow")), size=1)+
    geom_line(aes(y=Scenario2Flow, color=paste("Scen. 2 Flow")), size=0.5)+ 
    geom_line(aes(y=Scenario1Baseflow, color=paste("Scen. 1 Baseflow")), size=0.5) +
    geom_line(aes(y=Scenario2Baseflow, color=paste("Scen. 2 Baseflow")), size=1)+
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
    scale_colour_manual(values=c("black","red","grey", "light pink"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    labs(y = "Flow (cfs)")
  outfile <- paste0(export_path,"fig5.png")
  ggsave(outfile, plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 5: Combined Hydrograph saved at location ', outfile, sep = ''))
}
