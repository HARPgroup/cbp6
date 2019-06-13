# DOCUMENTATION -----------------------------------------------------------

# Creates plots based on various metrics

# LIBRARIES ---------------------------------------------------------------

library('lfstat')
library('ggplot2')
library('scales')
library('lubridate')
library('IHA')

# INPUTS ------------------------------------------------------------------

# Setting active directory 
# Setting working directory to the source file location
current_path <- rstudioapi::getActiveDocumentContext()$path 

# Setting up output location
split.location <- strsplit(current_path, split = '/')
split.location <- as.vector(split.location[[1]])
basepath.stop <- as.numeric(which(split.location == 'DEQ_Model_vs_Climate_Model'))
container <- paste0(split.location[1:basepath.stop], collapse = "/")

# USGS Gage number
SegID <- "PM7_4820_0001"

# Should new or original data be used?
new.or.original <- "new"

# CARRYOVER IF MASTER IS BEING RUN ----------------------------------------
if (exists("container.master") == TRUE) {
  container <- container.master
  siteNo <- siteNo.master
  new.or.original <- new.or.original.master
}

# NEW OR ORIGINAL DATA SWITCH ---------------------------------------------

if (new.or.original == "new") {
  container.cont <- "\\data\\new_(updated)_data"
} else if (new.or.original == "original") {
  container.cont <- "\\data\\original_(reproducible)_data"
} else {
  print("ERROR: neither new or original data specified")
}

# CREATE FOLDER -----------------------------------------------------------

dir.create(paste0(container,"\\results\\user's_results\\"), showWarnings = FALSE)

# LOADING DATA ------------------------------------------------------------

data <- read.csv(paste0(container, container.cont, "\\derived_data\\trimmed+area-adjusted_data\\", SegID, "_", mod.scenario1, "_vs_", mod.scenario2," - Derived Data.csv"))

# PLOTTING -----
# Creates directory to store plots and tables
dir.create(paste0(container,"\\results\\user's_results\\"), showWarnings = FALSE);
dir.create(paste0(container,"\\results\\user's_results\\",SegID, "_",mod.scenario1, "_vs_", mod.scenario2), showWarnings = FALSE);

# Creating names for plot legends
name_model1 <- paste('Model1: ', mod.scenario1);
name_model2 <- paste('Model2: ', mod.scenario2);

# CREATE FUNCTIONS FOR PLOTTING  ------------------------------------------
base_breaks <- function(n = 10){
  function(x) {
    axisTicks(log10(range(x, na.rm = TRUE)), log = TRUE, n = n)
  }
}
scaleFUN <- function(x) sprintf("%.0f", x)


# Basic hydrograph -----
# Max/min for y axis scaling
max <- max(c(max(data$Model1.Flow), max(data$Model2.Flow)));
min <- min(c(min(data$Model1.Flow), max(data$Model2.Flow)));

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

# Creating and exporting plot
png(filename=paste0(container,"\\results\\user's_results\\",SegID, "_",mod.scenario1, "_vs_", mod.scenario2,
                    "\\Fig. 2 - Hydrograph.png"),
    width = 1400, height = 950, units = "px");

df <- data.frame(as.Date(data$Date), data$Model1.Flow, data$Model2.Flow); 
colnames(df) <- c('Date', 'Model1', 'Model2')
options(scipen=5, width = 1400, height = 950)
myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Model1, color=name_model1), size=1) +
  geom_line(aes(y=Model2, color=name_model2), size=1)+
  fixtheyscale+
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=30),
        axis.text=element_text(size=36, colour="black"),
        axis.title=element_text(size=36, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 1, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank())+
  scale_colour_manual(values=c("black","red"))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(y = "Flow (cfs)")
print(myplot)
dev.off()         

# Setup for Residuals
resid <- (data$Model2.Flow - data$Model1.Flow)
resid <- data.frame(data$Date, resid)

# Residuals plot for hydrograph

zeroline <- rep_len(0, length(data$Date)) 
quantresid <- data.frame(signif(quantile(resid$resid), digits=3))
min <- min(resid$resid)
max <- max(resid$resid)
names(quantresid) <- c('Percentiles')

png(filename=paste0(container,"\\results\\user's_results\\",SegID, "_",mod.scenario1, "_vs_", mod.scenario2,
                    "\\Fig. 3 - Residuals.png"),
    width = 1400, height = 950, units = "px");

df <- data.frame(as.Date(resid$data.Date), resid$resid, zeroline); 
colnames(df) <- c('Date', 'Residual', 'Zeroline')
options(scipen=5, width = 1400, height = 950)
myplot <- ggplot(df, aes(x=Date)) + 
  geom_point(aes(y=Residual, color=name_model1), size=3.5) +
  geom_line(aes(y=Zeroline, color=name_model2), size=1)+
  scale_y_continuous(limits=c(min,max))+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=30),
        axis.text=element_text(size=36, colour="black"),
        axis.title=element_text(size=36, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 1, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank())+
  scale_colour_manual(values=c("dark green","black"))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(y = "Flow Difference(cfs)")
print(myplot)
dev.off()

# text1 <- paste0('Quartiles: ', '0%:',quantresid$Percentiles[1], ',  ',
# '25%:',quantresid$Percentiles[2])
# text2 <- paste0('Quartiles: 50%:',quantresid$Percentiles[3], ',  ', 
# '75%: ',quantresid$Percentiles[4], ',  ', 
# '100%: ',quantresid$Percentiles[5]) 
# mtext(text1, side=1, line=2, outer = FALSE, at = NA,
#       adj = 0, padj = NA, cex = 2, col = 'black', font = NA)
# mtext(text2, side=1, line=3, outer = FALSE, at = NA,
#       adj = 0, padj = NA, cex = 2, col = 'black', font = NA)
#      dev.off();

# Setup for Flow Exceedance Calculations
# Creating vectors of decreasing flow magnitude
dec_flows_model1 <- sort(data$Model1.Flow, decreasing = TRUE)
dec_flows_model2 <- sort(data$Model2.Flow, decreasing = TRUE)

# Determining the "rank" (0-1) of the flow value
num_observations <- as.numeric(length(data$date))
rank_vec <- as.numeric(c(1:num_observations))
# Calculating exceedance probability
prob_exceedance <- 100*((rank_vec) / (num_observations + 1))
# Creating vectors of calculated quantiles

model2_prob_exceedance <- quantile(dec_flows_model2, probs = c(0.01, 0.05, 0.5, 0.95, 0.99))
model1_prob_exceedance <- quantile(dec_flows_model1, probs = c(0.01, 0.05, 0.5, 0.95, 0.99))

# Flow exceedance plot -----
# Determining max flow value for exceedance plot scale
max <- max(c(max(dec_flows_model2), max(dec_flows_model1)));
min <- min(c(min(dec_flows_model2), min(dec_flows_model1)));

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
# Creating and exporting plot
png(filename=paste0(container,"\\results\\user's_results\\",SegID, "_",mod.scenario1, "_vs_", mod.scenario2,
                    "\\Fig. 4  - Prob. Exceedance.png"),
    width = 1400, height = 900, units = "px");

df <- data.frame(prob_exceedance, dec_flows_model2, dec_flows_model1); 
colnames(df) <- c('Date', 'Model2', 'Model1')
options(scipen=5, width = 1400, height = 950)
myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Model1, color=name_model1), size=1) +
  geom_line(aes(y=Model2, color=name_model2), size=1)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=30),
        axis.text=element_text(size=36, colour="black"),
        axis.title=element_text(size=36, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 1, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank())+
  scale_colour_manual(values=c("black","red"))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(x= "Probability of Exceedance (%)", y = "Flow (cfs)")
print(myplot)
dev.off()

# Setup for Baseflow Calculations
data$year <- year(ymd(data$Date))
data$month <- month(ymd(data$Date))
data$day <- day(ymd(data$Date))
model1.data <- data.frame(data$day, data$month, data$year, data$Model1.Flow)
names(model1.data) <- c('day', 'month', 'year', 'flow')
model2.data <- data.frame(data$day, data$month, data$year, data$Model2.Flow)
names(model2.data) <- c('day', 'month', 'year', 'flow')
# Creating lowflow objects
model1river <- createlfobj(model1.data, hyearstart = 10, baseflow = TRUE, meta = NULL)
model2river <- createlfobj(model2.data, hyearstart = 10, baseflow = TRUE, meta = NULL)
baseflowriver<- data.frame(model2river, model1river);
colnames(baseflowriver) <-c ('mday', 'mmonth', 'myear', 'mflow', 'mHyear', 'mBaseflow',
                             'gday', 'gmonth', 'gyear', 'gflow', 'gHyear', 'gBaseflow')
# removing NA values
baseflowriver<-baseflowriver[complete.cases(baseflowriver)==TRUE,]
model1river<- data.frame(baseflowriver$gday, baseflowriver$gmonth, baseflowriver$gyear, 
                       baseflowriver$gflow, baseflowriver$gHyear, baseflowriver$gBaseflow);
model2river<- data.frame(baseflowriver$mday, baseflowriver$mmonth, baseflowriver$myear, 
                        baseflowriver$mflow, baseflowriver$mHyear, baseflowriver$mBaseflow)
names(model1river) <- c('day', 'month', 'year', 'flow', 'hyear', 'baseflow')
names(model2river) <- c('day', 'month', 'year', 'flow', 'hyear', 'baseflow')
# Adding date vectors
model1river$date <- as.Date(paste0(model1river$year,"-",model1river$month,"-",model1river$day))
model2river$date <- as.Date(paste0(model2river$year,"-",model2river$month,"-",model2river$day))

# Baseflow Indiviudal Graph -----
# Determining max flow value for plot scale
max <- max(c(max(model1river$baseflow), max(model2river$baseflow), max(model1river$flow), max(model2river$flow)));
min <- min(c(min(model1river$baseflow), min(model2river$baseflow), min(model1river$flow), min(model2river$flow)));

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
# Creating and exporting plot
png(filename=paste0(container,"\\results\\user's_results\\",SegID, '_',mod.scenario1, "_vs_", mod.scenario2,
                    "\\Fig. 5 - Baseflow.png"),
    width = 1400, height = 900, units = "px");

par(mfrow = c(1,1));

which 
df <- data.frame(as.Date(model2river$date), model2river$baseflow, model1river$baseflow, model2river$flow, model1river$flow); 
colnames(df) <- c('Date', 'Model2Baseflow', 'Model1Baseflow', 'Model2Flow', 'Model1Flow')
options(scipen=5, width = 1400, height = 950)
myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Model1Baseflow, color=name_model1), size=1) +
  geom_line(aes(y=Model2Baseflow, color=name_model2), size=1)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=30),
        axis.text=element_text(size=36, colour="black"),
        axis.title=element_text(size=36, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 1, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank())+
  scale_colour_manual(values=c("black","red"))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(y = "Flow (cfs)")
print(myplot)
dev.off()      



# Baseflow Combined Graph -----

# Creating and exporting plot
png(filename=paste0(container,"\\results\\user's_results\\",SegID, '_',mod.scenario1, "_vs_", mod.scenario2,
                    "\\Fig. 6 - Baseflow and Flow.png"),
    width = 1400, height = 900, units = "px");
par(mfrow = c(1,1));

options(scipen=5, width = 1400, height = 950)
myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Model1Flow, color=paste("Flow:", name_model1)), size=1)+
  geom_line(aes(y=Model2Flow, color=paste("Flow:", name_model2)), size=1)+ 
  geom_line(aes(y=Model1Baseflow, color=paste("Baseflow:", name_model1)), size=1) +
  geom_line(aes(y=Model2Baseflow, color=paste("Baseflow:", name_model2)), size=1)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=20),
        axis.text=element_text(size=36, colour="black"),
        axis.title=element_text(size=36, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 1, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank())+
  scale_colour_manual(values=c("black","red","grey", "light pink"))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(y = "Flow (cfs)")
print(myplot)
dev.off()


# Zoomed hydrograph in year of lowest 90-year flow -----
# Running gage calculations
f3_model1 <- zoo(data$Model1.Flow, order.by = data$Date)
g2_model1 <- group2(f3_model1, year = 'water')
# Running model calculations
f3_model2 <- zoo(data$Model2.Flow, order.by = data$Date)
g2_model2 <- group2(f3_model2, year = 'water')

yearly_Model1_90DayMin <- g2_model1[,c(1,10)];
yearly_Model2_90DayMin <- g2_model2[,c(1,10)];
low.year <- subset(yearly_Model1_90DayMin, yearly_Model1_90DayMin$`90 Day Min`==min(yearly_Model1_90DayMin$`90 Day Min`));
low.year <- low.year$year;
low.year <- subset(data, data$year==low.year);

# Scaling using max/min
max <- max(c(max(low.year$Model1.Flow), max(low.year$Model2.Flow)));
min <- min(c(min(low.year$Model1.Flow), min(low.year$Model2.Flow)));
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
# Creating and exporting plot
png(filename=paste0(container,"\\results\\user's_results\\",SegID, '_',mod.scenario1, "_vs_", mod.scenario2,
                    "\\Fig. 7 - Zoomed Hydrograph.png"),
    width = 1400, height = 600, units = "px");

df <- data.frame(as.Date(low.year$Date), low.year$Model2.Flow, low.year$Model1.Flow); 
colnames(df) <- c('Date', 'Model2', 'Model1')
options(scipen=5, width = 1400, height = 950)
myplot <- ggplot(df, aes(x=Date)) + 
  geom_line(aes(y=Model1, color=name_model1), size=1) +
  geom_line(aes(y=Model2, color=name_model2), size=1)+
  fixtheyscale+ 
  theme_bw()+ 
  theme(legend.position="top", 
        legend.title=element_blank(),
        legend.box = "horizontal", 
        legend.background = element_rect(fill="white",
                                         size=0.5, linetype="solid", 
                                         colour ="white"),
        legend.text=element_text(size=30),
        axis.text=element_text(size=28, colour="black"),
        axis.title=element_text(size=28, colour="black"),
        axis.line = element_line(colour = "black", 
                                 size = 1, linetype = "solid"),
        axis.ticks = element_line(colour="black"),
        panel.grid.major=element_line(colour = "light grey"), 
        panel.grid.minor=element_blank())+
  scale_colour_manual(values=c("black","red"))+
  guides(colour = guide_legend(override.aes = list(size=5)))+
  labs(y = "Flow (cfs)")
print <- try(print(myplot))
if (class(print)=="try-error") {
  low.year2 <- subset(yearly_Model1_90DayMin, yearly_Model1_90DayMin$`90 Day Min`==sort(yearly_Model1_90DayMin$`90 Day Min`, TRUE)[2]);
  low.year2 <- low.year2$year;
  low.year2 <- subset(data, data$year==low.year2);
  
  # Scaling using max/min
  max2 <- max(c(max(low.year2$Model1.Flow), max(low.year2$Model2.Flow)));
  min2 <- min(c(min(low.year2$Model1.Flow), min(low.year2$Model2.Flow)));
  if (max2 > 10000){
    max2 <- 100000
  }else if (max2 > 1000){
    max2 <- 10000
  }else if (max2 > 100){
    max2 <- 1000
  }else if (max2 > 10){
    max2 <- 100
  }
  if (min2>100){
    min2<-100
  }else if (min2>10){ 
    min2<-10
  }else {
    min2<-1
  }
  if (min2==100){
    fixtheyscale2<- scale_y_continuous(trans = log_trans(), 
                                       breaks = c(100, 1000, 10000, 100000), 
                                       limits=c(min2,max2))
  }else if (min2==10){
    fixtheyscale2<- scale_y_continuous(trans = log_trans(), 
                                       breaks = c(10, 100, 1000, 10000), 
                                       limits=c(min2,max2))
  }else if (min2==1){
    fixtheyscale2<- scale_y_continuous(trans = log_trans(), 
                                       breaks = c(1, 10, 100, 1000, 10000), 
                                       limits=c(min2,max2))
  }else {
    fixtheyscale2<- scale_y_continuous(trans = log_trans(), breaks = base_breaks(), 
                                       labels=scaleFUN, limits=c(min2,max2))
  }
  # Creating and exporting plot
  png(filename=paste0(container,"\\results\\user's_results\\",SegID, '_',mod.scenario1, "_vs_", mod.scenario2,
                      "\\Fig. 7 - Zoomed Hydrograph.png"),
      width = 1400, height = 600, units = "px");
  
  df2 <- data.frame(as.Date(low.year2$Date), low.year2$Model2.Flow, low.year2$Model1.Flow); 
  colnames(df2) <- c('Date', 'Model2', 'Model1')
  options(scipen=5, width = 1400, height = 950)
  myplot2 <- ggplot(df2, aes(x=Date)) + 
    geom_line(aes(y=Model1, color=name_model1), size=1) +
    geom_line(aes(y=Model2, color=name_model2), size=1)+
    fixtheyscale2+ 
    theme_bw()+ 
    theme(legend.position="top", 
          legend.title=element_blank(),
          legend.box = "horizontal", 
          legend.background = element_rect(fill="white",
                                           size=0.5, linetype="solid", 
                                           colour ="white"),
          legend.text=element_text(size=30),
          axis.text=element_text(size=28, colour="black"),
          axis.title=element_text(size=28, colour="black"),
          axis.line = element_line(colour = "black", 
                                   size = 1, linetype = "solid"),
          axis.ticks = element_line(colour="black"),
          panel.grid.major=element_line(colour = "light grey"), 
          panel.grid.minor=element_blank())+
    scale_colour_manual(values=c("black","red"))+
    guides(colour = guide_legend(override.aes = list(size=5)))+
    labs(y = "Flow (cfs)")
  dev.off()
  print(myplot2)
} else {
  print(myplot)
}
dev.off()
