fig9a.residual.plot <- function(all_data, cn1='Scenario 1', cn2='Scenario 2') {
  # Setup for Residuals
  data <- all_data[complete.cases(all_data),]
  resid <- (data$`Scenario 2 Flow` - data$`Scenario 1 Flow`)
  resid <- data.frame(data$Date, resid)
  
  # Residuals plot for hydrograph
  
  zeroline <- rep_len(0, length(data$Date)) 
  quantresid <- data.frame(signif(quantile(resid$resid, na.rm = TRUE), digits=3))
  min <- min(resid$resid)
  max <- max(resid$resid)
  names(quantresid) <- c('Percentiles')
  
  namer <- paste0('Residual (', cn2, ' - ', cn1, ')')
  
  df <- data.frame(as.Date(resid$data.Date), resid$resid, zeroline); 
  colnames(df) <- c('Date', 'Residual', 'Zeroline')
  options(scipen=5, width = 1400, height = 950)
  myplot <- ggplot(df, aes(x=Date)) + 
    geom_point(aes(y=Residual, color=namer), size=1) +
    geom_line(aes(y=Zeroline, color="Zeroline"), size=0.8)+
    scale_y_continuous(limits=c(min,max))+ 
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
    scale_colour_manual(values=c("dark green","black"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    labs(y = "Flow Difference (cfs)")
  ggsave("fig9A.png", plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 9a: Residual Plot saved at location ', as.character(getwd()), '/fig9a.png', sep = ''))
}
