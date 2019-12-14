fig9b.area.weighted.residual.plot <- function(all_data, riv.seg, token, site_url, cn1='Scenario 1', cn2='Scenario 2') {
  
  hydrocode = paste("vahydrosw_wshed_",riv.seg,sep="");
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list (
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site_url, feature);
  hydroid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name );
  print(paste("Retrieved hydroid",hydroid,"for", fname,riv.seg, sep=' '));
  
  # Getting the local drainage area feature
  areainfo <- list(
    varkey = "wshed_drainage_area_sqmi",
    featureid = as.integer(as.character(hydroid)),
    entity_type = "dh_feature"
  )
  
  model.area <- getPropertyALT(areainfo, site_url, model.area, token)
  area <- model.area$propvalue
  area <- area*27878400 #sq ft
  
  # Setup for Residuals
  data <- all_data[complete.cases(all_data),]
  #data_weighted <- data/area
  resid <- 1000000*((data$`Scenario 2 Flow` - data$`Scenario 1 Flow`)/area)
  resid <- data.frame(data$Date, resid)
  
  # Residuals plot for hydrograph
  zeroline <- rep_len(0, length(data$Date))
  quantresid <- data.frame(signif(quantile(resid$resid, na.rm =TRUE), digits=3))
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
    labs(y = "Area Weighted Flow Difference*10^6 (ft/s)")
  ggsave("fig9B.png", plot = myplot, device = 'png', width = 8, height = 5.5, units = 'in')
  print(paste('Fig. 9b: Area-Weighted Residual Plot saved at location ', as.character(getwd()), '/fig9b.png', sep = ''))
}
