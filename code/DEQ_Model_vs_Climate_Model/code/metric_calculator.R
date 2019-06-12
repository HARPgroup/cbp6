# DOCUMENTATION -----------------------------------------------------------

# Calculates all flow metrics for model and gage data, exports a table
# containing all metrics to the "results" folder

# LIBRARIES ---------------------------------------------------------------

library('IHA')
library('PearsonDS')
library('zoo')
library('lubridate')
library('lfstat')

# Setting active directory 
# Setting working directory to the source file location
current_path <- rstudioapi::getActiveDocumentContext()$path 

# Setting up output location
split.location <- strsplit(current_path, split = '/')
split.location <- as.vector(split.location[[1]])
basepath.stop <- as.numeric(which(split.location == 'DEQ_Model_vs_Climate_Model'))
container <- paste0(split.location[1:basepath.stop], collapse = "/")

# INPUTS ------------------------------------------------------------------
# USGS Gage number
SegID <- "PM7_4820_0001"

# Should new or original data be used?
new.or.original <- "new"

# CARRYOVER IF MASTER IS BEING RUN ----------------------------------------
if (exists("container.master") == TRUE) {
  container <- container.master
  SegID <- SegID.master
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

# SOURCING CALCULATING FUNCTION -------------------------------------------

source(paste0(container, "\\code\\function_holder.R"));

# CREATE FOLDER -----------------------------------------------------------

dir.create(paste0(container,"\\results\\user's_results\\", SegID, "_", mod.scenario1, "_vs_", mod.scenario2), showWarnings = TRUE)

# LOADING DATA ------------------------------------------------------------

data <- read.csv(paste0(container, container.cont, "\\derived_data\\trimmed_data\\", SegID, "_", mod.scenario1, "_vs_", mod.scenario2," - Derived Data.csv"))

# ADDING ADDITIONAL DATA COLUMNS ------------------------------------------
data$year <- year(ymd(data$Date))
data$month <- month(ymd(data$Date))
data$day <- day(ymd(data$Date))

# SETUP FOR CALCULATIONS --------------------------------------------------

# Setup for ___ Day Min Calculations
# Running model 1 calculations
f3_model1 <- zoo(data$Model1.Flow, order.by = data$Date)
g2_model1 <- group2(f3_model1, year = 'water')
# Running model 2 calculations
f3_model2 <- zoo(data$Model2.Flow, order.by = data$Date)
g2_model2 <- group2(f3_model2, year = 'water')

# Setup for Monthly Means Calculations
Model2_Monthly_Means <- aggregate(data$Model1.Flow, list(data$month), FUN = mean)
Model1_Monthly_Means <- aggregate(data$Model2.Flow, list(data$month), FUN = mean)

# Setup for Montly Mins Calculations
flows_model1 <- zoo(data$Model1.Flow, order.by = data$Date)
flows_model2 <- zoo(data$Model2.Flow, order.by = data$Date)

# Setup for Flow Exceedance Calculations
# Creating vectors of decreasing flow magnitude
dec_flows_model1 <- sort(data$Model1.Flow, decreasing = TRUE)
dec_flows_model2 <- sort(data$Model2.Flow, decreasing = TRUE)

# Determining the "rank" (0-1) of the flow value
num_observations <- as.numeric(length(data$Date))
rank_vec <- as.numeric(c(1:num_observations))

# Calculating exceedance probability
prob_exceedance <- 100*((rank_vec) / (num_observations + 1))

# Creating vectors of calculated quantiles
model2_prob_exceedance <- quantile(dec_flows_model2, probs = c(0.01, 0.05, 0.5, 0.95, 0.99))
model1_prob_exceedance <- quantile(dec_flows_model1, probs = c(0.01, 0.05, 0.5, 0.95, 0.99))

# Setup for Sept. 10% Flow
sept_flows <- subset(data, month == '9')
sept_quant_model1 <- quantile(sept_flows$Model1.Flow, 0.10)
sept_quant_model2 <- quantile(sept_flows$Model2.Flow, 0.10)

# Setup for Baseflow Calculations
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
model1river$Date <- as.Date(paste0(model1river$year,"-",model1river$month,"-",model1river$day))
model2river$Date <- as.Date(paste0(model2river$year,"-",model2river$month,"-",model2river$day))

# Setup for Low Flows
lf_model2 <- aggregate(model2river$flow, by = list(model2river$hyear), FUN = mean)
lf_model1 <- aggregate(model1river$flow, by = list(model1river$hyear), FUN = mean)
colnames(lf_model2) <- c('Water_Year', 'Mean_Flow')
colnames(lf_model1) <- c('Water_Year', 'Mean_Flow')

# Setup for Residuals
resid <- (data$Model2.Flow - data$Model1.Flow)
resid <- data.frame(data$Date, resid)

# CALCULATIONS ------------------------------------------------------------

# OVERALL MEAN FLOW
met00_mod1_MeanFlow <- signif(mean(data$Model1.Flow), digits=3);
met00_mod2_MeanFlow <- signif(mean(data$Model2.Flow), digits=3);
met00_PctError <- (signif(((met00_mod2_MeanFlow - met00_mod1_MeanFlow) / met00_mod1_MeanFlow)*100, digits=3));

# JANUARY LOW FLOW
met01_mod1_JanLF <- signif(fn_iha_mlf(flows_model1,1), digits=3);
met01_mod2_JanLF <- signif(fn_iha_mlf(flows_model2,1), digits=3);
met01_PctError <- (signif(((met01_mod2_JanLF - met01_mod1_JanLF) / met01_mod1_JanLF)*100, digits=3));

# FEBRUARY LOW FLOW
met02_mod1_FebLF <- signif(fn_iha_mlf(flows_model1,2), digits=3);
met02_mod2_FebLF <- signif(fn_iha_mlf(flows_model2,2), digits=3);
met02_PctError <- (signif(((met02_mod2_FebLF - met02_mod1_FebLF) / met02_mod1_FebLF)*100, digits=3));

# MARCH LOW FLOW
met03_mod1_MarLF <- signif(fn_iha_mlf(flows_model1,3), digits=3);
met03_mod2_MarLF <- signif(fn_iha_mlf(flows_model2,3), digits=3);
met03_PctError <- (signif(((met03_mod2_MarLF - met03_mod1_MarLF) / met03_mod1_MarLF)*100, digits=3));

# APRIL LOW FLOW
met04_mod1_AprLF <- signif(fn_iha_mlf(flows_model1,4), digits=3);
met04_mod2_AprLF <- signif(fn_iha_mlf(flows_model2,4), digits=3);
met04_PctError <- (signif(((met04_mod2_AprLF - met04_mod1_AprLF) / met04_mod1_AprLF)*100, digits=3));

# MAY LOW FLOW
met05_mod1_MayLF <- signif(fn_iha_mlf(flows_model1,5), digits=3);
met05_mod2_MayLF <- signif(fn_iha_mlf(flows_model2,5), digits=3);
met05_PctError <- (signif(((met05_mod2_MayLF - met05_mod1_MayLF) / met05_mod1_MayLF)*100, digits=3));

# JUNE LOW FLOW
met06_mod1_JunLF <- signif(fn_iha_mlf(flows_model1,6), digits=3);
met06_mod2_JunLF <- signif(fn_iha_mlf(flows_model2,6), digits=3);
met06_PctError <- (signif(((met06_mod2_JunLF - met06_mod1_JunLF) / met06_mod1_JunLF)*100, digits=3));

# JULY LOW FLOW
met07_mod1_JulLF <- signif(fn_iha_mlf(flows_model1,7), digits=3);
met07_mod2_JulLF <- signif(fn_iha_mlf(flows_model2,7), digits=3);
met07_PctError <- (signif(((met07_mod2_JulLF - met07_mod1_JulLF) / met07_mod1_JulLF)*100, digits=3));

# AUGUST LOW FLOW
met08_mod1_AugLF <- signif(fn_iha_mlf(flows_model1,8), digits=3);
met08_mod2_AugLF <- signif(fn_iha_mlf(flows_model2,8), digits=3);
met08_PctError <- (signif(((met08_mod2_AugLF - met08_mod1_AugLF) / met08_mod1_AugLF)*100, digits=3));

# SEPTEMBER LOW FLOW
met09_mod1_SepLF <- signif(fn_iha_mlf(flows_model1,9), digits=3);
met09_mod2_SepLF <- signif(fn_iha_mlf(flows_model2,9), digits=3);
met09_PctError <- (signif(((met09_mod2_SepLF - met09_mod1_SepLF) / met09_mod1_SepLF)*100, digits=3));

# OCTOBER LOW FLOW
met10_mod1_OctLF <- signif(fn_iha_mlf(flows_model1,10), digits=3);
met10_mod2_OctLF <- signif(fn_iha_mlf(flows_model2,10), digits=3);
met10_PctError <- (signif(((met10_mod2_OctLF - met10_mod1_OctLF) / met10_mod1_OctLF)*100, digits=3));

# NOVEMBER LOW FLOW
met11_mod1_NovLF <- signif(fn_iha_mlf(flows_model1,11), digits=3);
met11_mod2_NovLF <- signif(fn_iha_mlf(flows_model2,11), digits=3);
met11_PctError <- (signif(((met11_mod2_NovLF - met11_mod1_NovLF) / met11_mod1_NovLF)*100, digits=3));

# DECEMBER LOW FLOW
met12_mod1_DecLF <- signif(fn_iha_mlf(flows_model1,12), digits=3);
met12_mod2_DecLF <- signif(fn_iha_mlf(flows_model2,12), digits=3);
met12_PctError <- (signif(((met12_mod2_DecLF - met12_mod1_DecLF) / met12_mod1_DecLF)*100, digits=3));

# JANUARY MEAN FLOW
met13_mod1_JanMF <- signif(Model1_Monthly_Means[1,2], digits=3);
met13_mod2_JanMF <- signif(Model2_Monthly_Means[1,2], digits=3);
met13_PctError <- (signif(((met13_mod2_JanMF - met13_mod1_JanMF) / met13_mod1_JanMF)*100, digits=3));

# FEBRUARY MEAN FLOW
met14_mod1_FebMF <- signif(Model1_Monthly_Means[2,2], digits=3);
met14_mod2_FebMF <- signif(Model2_Monthly_Means[2,2], digits=3);
met14_PctError <- (signif(((met14_mod2_FebMF - met14_mod1_FebMF) / met14_mod1_FebMF)*100, digits=3));

# MARCH MEAN FLOW
met15_mod1_MarMF <- signif(Model1_Monthly_Means[3,2], digits=3);
met15_mod2_MarMF <- signif(Model2_Monthly_Means[3,2], digits=3);
met15_PctError <- (signif(((met15_mod2_MarMF - met15_mod1_MarMF) / met15_mod1_MarMF)*100, digits=3));

# APRIL MEAN FLOW
met16_mod1_AprMF <- signif(Model1_Monthly_Means[4,2], digits=3);
met16_mod2_AprMF <- signif(Model2_Monthly_Means[4,2], digits=3);
met16_PctError <- (signif(((met16_mod2_AprMF - met16_mod1_AprMF) / met16_mod1_AprMF)*100, digits=3));

# MAY MEAN FLOW
met17_mod1_MayMF <- signif(Model1_Monthly_Means[5,2], digits=3);
met17_mod2_MayMF <- signif(Model2_Monthly_Means[5,2], digits=3);
met17_PctError <- (signif(((met17_mod2_MayMF - met17_mod1_MayMF) / met17_mod1_MayMF)*100, digits=3));

# JUNE MEAN FLOW
met18_mod1_JunMF <- signif(Model1_Monthly_Means[6,2], digits=3);
met18_mod2_JunMF <- signif(Model2_Monthly_Means[6,2], digits=3);
met18_PctError <- (signif(((met18_mod2_JunMF - met18_mod1_JunMF) / met18_mod1_JunMF)*100, digits=3));

# JULY MEAN FLOW
met19_mod1_JulMF <- signif(Model1_Monthly_Means[7,2], digits=3);
met19_mod2_JulMF <- signif(Model2_Monthly_Means[7,2], digits=3);
met19_PctError <- (signif(((met19_mod2_JulMF - met19_mod1_JulMF) / met19_mod1_JulMF)*100, digits=3));

# AUGUST MEAN FLOW
met20_mod1_AugMF <- signif(Model1_Monthly_Means[8,2], digits=3);
met20_mod2_AugMF <- signif(Model2_Monthly_Means[8,2], digits=3);
met20_PctError <- (signif(((met20_mod2_AugMF - met20_mod1_AugMF) / met20_mod1_AugMF)*100, digits=3));

# SEPTEMBER MEAN FLOW
met21_mod1_SepMF <- signif(Model1_Monthly_Means[9,2], digits=3);
met21_mod2_SepMF <- signif(Model2_Monthly_Means[9,2], digits=3);
met21_PctError <- (signif(((met21_mod2_SepMF - met21_mod1_SepMF) / met21_mod1_SepMF)*100, digits=3));

# OCTOBER MEAN FLOW
met22_mod1_OctMF <- signif(Model1_Monthly_Means[10,2], digits=3);
met22_mod2_OctMF <- signif(Model2_Monthly_Means[10,2], digits=3);
met22_PctError <- (signif(((met22_mod2_OctMF - met22_mod1_OctMF) / met22_mod1_OctMF)*100, digits=3));

# NOVEMBER MEAN FLOW
met23_mod1_NovMF <- signif(Model1_Monthly_Means[11,2], digits=3);
met23_mod2_NovMF <- signif(Model2_Monthly_Means[11,2], digits=3);
met23_PctError <- (signif(((met23_mod2_NovMF - met23_mod1_NovMF) / met23_mod1_NovMF)*100, digits=3));

# DECEMBER MEAN FLOW
met24_mod1_DecMF <- signif(Model1_Monthly_Means[12,2], digits=3);
met24_mod2_DecMF <- signif(Model2_Monthly_Means[12,2], digits=3);
met24_PctError <- (signif(((met24_mod2_DecMF - met24_mod1_DecMF) / met24_mod1_DecMF)*100, digits=3));

# 1 DAY MIN
yearly_mod1_1DayMin <- g2_model1[,c(1,2)];
met25_mod1_1DayMinMin <- signif(min(yearly_mod1_1DayMin$`1 Day Min`), digits=3);
yearly_mod2_1DayMin <- g2_model2[,c(1,2)];
met25_mod2_1DayMinMin <- signif(min(yearly_mod2_1DayMin$`1 Day Min`), digits=3);
met25_PctError <- (signif(((met25_mod2_1DayMinMin - met25_mod1_1DayMinMin) / met25_mod1_1DayMinMin)*100, digits=3));
met26_mod1_1DayMinMed <- signif(median(yearly_mod1_1DayMin$`1 Day Min`), digits=3);
met26_mod2_1DayMinMed <- signif(median(yearly_mod2_1DayMin$`1 Day Min`), digits=3);
met26_PctError <- (signif(((met26_mod2_1DayMinMed - met26_mod1_1DayMinMed) / met26_mod1_1DayMinMed)*100, digits=3));

# 3 DAY MIN
yearly_mod1_3DayMin <- g2_model1[,c(1,4)];
met27_mod1_3DayMinMin <- signif(min(yearly_mod1_3DayMin$`3 Day Min`), digits=3);
yearly_mod2_3DayMin <- g2_model2[,c(1,4)];
met27_mod2_3DayMinMin <- signif(min(yearly_mod2_3DayMin$`3 Day Min`), digits=3);
met27_PctError <- (signif(((met27_mod2_3DayMinMin - met27_mod1_3DayMinMin) / met27_mod1_3DayMinMin)*100, digits=3));
met28_mod1_3DayMinMed <- signif(median(yearly_mod1_3DayMin$`3 Day Min`), digits=3);
met28_mod2_3DayMinMed <- signif(median(yearly_mod2_3DayMin$`3 Day Min`), digits=3);
met28_PctError <- (signif(((met28_mod2_3DayMinMed - met28_mod1_3DayMinMed) / met28_mod1_3DayMinMed)*100, digits=3));

# 7 DAY MIN
yearly_mod1_7DayMin <- g2_model1[,c(1,6)];
met29_mod1_7DayMinMin <- signif(min(yearly_mod1_7DayMin$`7 Day Min`), digits=3);
yearly_mod2_7DayMin <- g2_model2[,c(1,6)];
met29_mod2_7DayMinMin <- signif(min(yearly_mod2_7DayMin$`7 Day Min`), digits=3);
met29_PctError <- (signif(((met29_mod2_7DayMinMin - met29_mod1_7DayMinMin) / met29_mod1_7DayMinMin)*100, digits=3));
met30_mod1_7DayMinMed <- signif(median(yearly_mod1_7DayMin$`7 Day Min`), digits=3);
met30_mod2_7DayMinMed <- signif(median(yearly_mod2_7DayMin$`7 Day Min`), digits=3);
met30_PctError <- (signif(((met30_mod2_7DayMinMed - met30_mod1_7DayMinMed) / met30_mod1_7DayMinMed)*100, digits=3));

# 30 DAY MIN
yearly_mod1_30DayMin <- g2_model1[,c(1,8)];
met31_mod1_30DayMinMin <- signif(min(yearly_mod1_30DayMin$`30 Day Min`), digits=3);
yearly_mod2_30DayMin <- g2_model2[,c(1,8)];
met31_mod2_30DayMinMin <- signif(min(yearly_mod2_30DayMin$`30 Day Min`), digits=3);
met31_PctError <- (signif(((met31_mod2_30DayMinMin - met31_mod1_30DayMinMin) / met31_mod1_30DayMinMin)*100, digits=3));
met32_mod1_30DayMinMed <- signif(median(yearly_mod1_30DayMin$`30 Day Min`), digits=3);
met32_mod2_30DayMinMed <- signif(median(yearly_mod2_30DayMin$`30 Day Min`), digits=3);
met32_PctError <- (signif(((met32_mod2_30DayMinMed - met32_mod1_30DayMinMed) / met32_mod1_30DayMinMed)*100, digits=3));

# 90 DAY MIN
yearly_mod1_90DayMin <- g2_model1[,c(1,10)];
met33_mod1_90DayMinMin <- signif(min(yearly_mod1_90DayMin$`90 Day Min`), digits=3);
yearly_mod2_90DayMin <- g2_model2[,c(1,10)];
met33_mod2_90DayMinMin <- signif(min(yearly_mod2_90DayMin$`90 Day Min`), digits=3);
met33_PctError <- (signif(((met33_mod2_90DayMinMin - met33_mod1_90DayMinMin) / met33_mod1_90DayMinMin)*100, digits=3));
met34_mod1_90DayMinMed <- signif(median(yearly_mod1_90DayMin$`90 Day Min`), digits=3);
met34_mod2_90DayMinMed <- signif(median(yearly_mod2_90DayMin$`90 Day Min`), digits=3);
met34_PctError <- (signif(((met34_mod2_90DayMinMed - met34_mod1_90DayMinMed) / met34_mod1_90DayMinMed)*100, digits=3));

# 7Q10
met35_mod1_7Q10 <- signif(fn_iha_7q10(flows_model1), digits=3);
met35_mod2_7Q10 <- signif(fn_iha_7q10(flows_model2), digits=3);
met35_PctError <- (signif(((met35_mod2_7Q10 - met35_mod1_7Q10) / met35_mod1_7Q10)*100, digits=3));

# DROUGHT OF RECORD (MIN. 90 DAY MIN.) YEAR
met37_mod1_DoR <- fn_iha_DOR_Year(flows_model1);
met37_mod2_DoR <- fn_iha_DOR_Year(flows_model2);
if (met37_mod1_DoR == met37_mod2_DoR) {
  met37_PctError <- 0;
} else {
  met37_PctError <- 100;
}

# 1% Non-exceedance Flow
met38_mod1_1NonEx <- signif(model1_prob_exceedance[["1%"]], digits=3);
met38_mod2_1NonEx <- signif(model2_prob_exceedance[["1%"]], digits=3);
met38_PctError <- (signif(((met38_mod2_1NonEx - met38_mod1_1NonEx) / met38_mod1_1NonEx)*100, digits=3));

# 5% Non-exceedance Flow
met39_mod1_5NonEx <- signif(model1_prob_exceedance[["5%"]], digits=3);
met39_mod2_5NonEx <- signif(model2_prob_exceedance[["5%"]], digits=3);
met39_PctError <- (signif(((met39_mod2_5NonEx - met39_mod1_5NonEx) / met39_mod1_5NonEx)*100, digits=3));

# 50% Non-exceedance Flow
met40_mod1_50NonEx <- signif(model1_prob_exceedance[["50%"]], digits=3);
met40_mod2_50NonEx <- signif(model2_prob_exceedance[["50%"]], digits=3);
met40_PctError <- (signif(((met40_mod2_50NonEx - met40_mod1_50NonEx) / met40_mod1_50NonEx)*100, digits=3));

# 95% Non-exceedance Flow
met41_mod1_95NonEx <- signif(model1_prob_exceedance[["95%"]], digits=3);
met41_mod2_95NonEx <- signif(model2_prob_exceedance[["95%"]], digits=3);
met41_PctError <- (signif(((met41_mod2_95NonEx - met41_mod1_95NonEx) / met41_mod1_95NonEx)*100, digits=3));

# 99% Non-exceedance Flow
met42_mod1_99NonEx <- signif(model1_prob_exceedance[["99%"]], digits=3);
met42_mod2_99NonEx <- signif(model2_prob_exceedance[["99%"]], digits=3);
met42_PctError <- (signif(((met42_mod2_99NonEx - met42_mod1_99NonEx) / met42_mod1_99NonEx)*100, digits=3));

# Sept. 10% Flow
met43_mod1_Sep10 <- signif(sept_quant_model1[["10%"]], digits=3);
met43_mod2_Sep10 <- signif(sept_quant_model2[["10%"]], digits=3);
met43_PctError <- (signif(((met43_mod2_Sep10 - met43_mod1_Sep10) / met43_mod1_Sep10)*100, digits=3));

# Baseflow (Average)
met44_mod1_Base <- signif(mean(model1river$baseflow), digits=3);
met44_mod2_Base <- signif(mean(model2river$baseflow), digits=3);
met44_PctError <- (signif(((met44_mod2_Base - met44_mod1_Base) / met44_mod1_Base)*100, digits=3));

# JANUARY HIGH FLOW
met45_mod1_JanHF <- signif(fn_iha_mhf(flows_model1,1), digits=3);
met45_mod2_JanHF <- signif(fn_iha_mhf(flows_model2,1), digits=3);
met45_PctError <- (signif(((met45_mod2_JanHF - met45_mod1_JanHF) / met45_mod1_JanHF)*100, digits=3));

# FEBRUARY HIGH FLOW
met46_mod1_FebHF <- signif(fn_iha_mhf(flows_model1,2), digits=3);
met46_mod2_FebHF <- signif(fn_iha_mhf(flows_model2,2), digits=3);
met46_PctError <- (signif(((met46_mod2_FebHF - met46_mod1_FebHF) / met46_mod1_FebHF)*100, digits=3));

# MARCH HIGH FLOW
met47_mod1_MarHF <- signif(fn_iha_mhf(flows_model1,3), digits=3);
met47_mod2_MarHF <- signif(fn_iha_mhf(flows_model2,3), digits=3);
met47_PctError <- (signif(((met47_mod2_MarHF - met47_mod1_MarHF) / met47_mod1_MarHF)*100, digits=3));

# APRIL HIGH FLOW
met48_mod1_AprHF <- signif(fn_iha_mhf(flows_model1,4), digits=3);
met48_mod2_AprHF <- signif(fn_iha_mhf(flows_model2,4), digits=3);
met48_PctError <- (signif(((met48_mod2_AprHF - met48_mod1_AprHF) / met48_mod1_AprHF)*100, digits=3));

# MAY HIGH FLOW
met49_mod1_MayHF <- signif(fn_iha_mhf(flows_model1,5), digits=3);
met49_mod2_MayHF <- signif(fn_iha_mhf(flows_model2,5), digits=3);
met49_PctError <- (signif(((met49_mod2_MayHF - met49_mod1_MayHF) / met49_mod1_MayHF)*100, digits=3));

# JUNE HIGH FLOW
met50_mod1_JunHF <- signif(fn_iha_mhf(flows_model1,6), digits=3);
met50_mod2_JunHF <- signif(fn_iha_mhf(flows_model2,6), digits=3);
met50_PctError <- (signif(((met50_mod2_JunHF - met50_mod1_JunHF) / met50_mod1_JunHF)*100, digits=3));

# JULY HIGH FLOW
met51_mod1_JulHF <- signif(fn_iha_mhf(flows_model1,7), digits=3);
met51_mod2_JulHF <- signif(fn_iha_mhf(flows_model2,7), digits=3);
met51_PctError <- (signif(((met51_mod2_JulHF - met51_mod1_JulHF) / met51_mod1_JulHF)*100, digits=3));

# AUGUST HIGH FLOW
met52_mod1_AugHF <- signif(fn_iha_mhf(flows_model1,8), digits=3);
met52_mod2_AugHF <- signif(fn_iha_mhf(flows_model2,8), digits=3);
met52_PctError <- (signif(((met52_mod2_AugHF - met52_mod1_AugHF) / met52_mod1_AugHF)*100, digits=3));

# SEPTEMBER HIGH FLOW
met53_mod1_SepHF <- signif(fn_iha_mhf(flows_model1,9), digits=3);
met53_mod2_SepHF <- signif(fn_iha_mhf(flows_model2,9), digits=3);
met53_PctError <- (signif(((met53_mod2_SepHF - met53_mod1_SepHF) / met53_mod1_SepHF)*100, digits=3));

# OCTOBER HIGH FLOW
met54_mod1_OctHF <- signif(fn_iha_mhf(flows_model1,10), digits=3);
met54_mod2_OctHF <- signif(fn_iha_mhf(flows_model2,10), digits=3);
met54_PctError <- (signif(((met54_mod2_OctHF - met54_mod1_OctHF) / met54_mod1_OctHF)*100, digits=3));

# NOVEMBER HIGH FLOW
met55_mod1_NovHF <- signif(fn_iha_mhf(flows_model1,11), digits=3);
met55_mod2_NovHF <- signif(fn_iha_mhf(flows_model2,11), digits=3);
met55_PctError <- (signif(((met55_mod2_NovHF - met55_mod1_NovHF) / met55_mod1_NovHF)*100, digits=3));

# DECEMBER HIGH FLOW
met56_mod1_DecHF <- signif(fn_iha_mhf(flows_model1,12), digits=3);
met56_mod2_DecHF <- signif(fn_iha_mhf(flows_model2,12), digits=3);
met56_PctError <- (signif(((met56_mod2_DecHF - met56_mod1_DecHF) / met56_mod1_DecHF)*100, digits=3));

# 1 DAY MAX
yearly_mod1_1DayMax <- g2_model1[,c(1,3)];
met57_mod1_1DayMaxMax <- signif(max(yearly_mod1_1DayMax$`1 Day Max`), digits=3);
yearly_mod2_1DayMax <- g2_model2[,c(1,3)];
met57_mod2_1DayMaxMax <- signif(max(yearly_mod2_1DayMax$`1 Day Max`), digits=3);
met57_PctError <- (signif(((met57_mod2_1DayMaxMax - met57_mod1_1DayMaxMax) / met57_mod1_1DayMaxMax)*100, digits=3));
met58_mod1_1DayMaxMed <- signif(median(yearly_mod1_1DayMax$`1 Day Max`), digits=3);
met58_mod2_1DayMaxMed <- signif(median(yearly_mod2_1DayMax$`1 Day Max`), digits=3);
met58_PctError <- (signif(((met58_mod2_1DayMaxMed - met58_mod1_1DayMaxMed) / met58_mod1_1DayMaxMed)*100, digits=3));

# 3 DAY MAX
yearly_mod1_3DayMax <- g2_model1[,c(1,5)];
met59_mod1_3DayMaxMax <- signif(max(yearly_mod1_3DayMax$`3 Day Max`), digits=3);
yearly_mod2_3DayMax <- g2_model2[,c(1,5)];
met59_mod2_3DayMaxMax <- signif(max(yearly_mod2_3DayMax$`3 Day Max`), digits=3);
met59_PctError <- (signif(((met59_mod2_3DayMaxMax - met59_mod1_3DayMaxMax) / met59_mod1_3DayMaxMax)*100, digits=3));
met60_mod1_3DayMaxMed <- signif(median(yearly_mod1_3DayMax$`3 Day Max`), digits=3);
met60_mod2_3DayMaxMed <- signif(median(yearly_mod2_3DayMax$`3 Day Max`), digits=3);
met60_PctError <- (signif(((met60_mod2_3DayMaxMed - met60_mod1_3DayMaxMed) / met60_mod1_3DayMaxMed)*100, digits=3));

# 7 DAY MAX
yearly_mod1_7DayMax <- g2_model1[,c(1,7)];
met61_mod1_7DayMaxMax <- signif(max(yearly_mod1_7DayMax$`7 Day Max`), digits=3);
yearly_mod2_7DayMax <- g2_model2[,c(1,7)];
met61_mod2_7DayMaxMax <- signif(max(yearly_mod2_7DayMax$`7 Day Max`), digits=3);
met61_PctError <- (signif(((met61_mod2_7DayMaxMax - met61_mod1_7DayMaxMax) / met61_mod1_7DayMaxMax)*100, digits=3));
met62_mod1_7DayMaxMed <- signif(median(yearly_mod1_7DayMax$`7 Day Max`), digits=3);
met62_mod2_7DayMaxMed <- signif(median(yearly_mod2_7DayMax$`7 Day Max`), digits=3);
met62_PctError <- (signif(((met62_mod2_7DayMaxMed - met62_mod1_7DayMaxMed) / met62_mod1_7DayMaxMed)*100, digits=3));

# 30 DAY MAX
yearly_mod1_30DayMax <- g2_model1[,c(1,9)];
met63_mod1_30DayMaxMax <- signif(max(yearly_mod1_30DayMax$`30 Day Max`), digits=3);
yearly_mod2_30DayMax <- g2_model2[,c(1,9)];
met63_mod2_30DayMaxMax <- signif(max(yearly_mod2_30DayMax$`30 Day Max`), digits=3);
met63_PctError <- (signif(((met63_mod2_30DayMaxMax - met63_mod1_30DayMaxMax) / met63_mod1_30DayMaxMax)*100, digits=3));
met64_mod1_30DayMaxMed <- signif(median(yearly_mod1_30DayMax$`30 Day Max`), digits=3);
met64_mod2_30DayMaxMed <- signif(median(yearly_mod2_30DayMax$`30 Day Max`), digits=3);
met64_PctError <- (signif(((met64_mod2_30DayMaxMed - met64_mod1_30DayMaxMed) / met64_mod1_30DayMaxMed)*100, digits=3));

# 90 DAY MAX
yearly_mod1_90DayMax <- g2_model1[,c(1,11)];
met65_mod1_90DayMaxMax <- signif(max(yearly_mod1_90DayMax$`90 Day Max`), digits=3);
yearly_mod2_90DayMax <- g2_model2[,c(1,11)];
met65_mod2_90DayMaxMax <- signif(max(yearly_mod2_90DayMax$`90 Day Max`), digits=3);
met65_PctError <- (signif(((met65_mod2_90DayMaxMax - met65_mod1_90DayMaxMax) / met65_mod1_90DayMaxMax)*100, digits=3));
met66_mod1_90DayMaxMed <- signif(median(yearly_mod1_90DayMax$`90 Day Max`), digits=3);
met66_mod2_90DayMaxMed <- signif(median(yearly_mod2_90DayMax$`90 Day Max`), digits=3);
met66_PctError <- (signif(((met66_mod2_90DayMaxMed - met66_mod1_90DayMaxMed) / met66_mod1_90DayMaxMed)*100, digits=3));

# LOW YEARLY MEAN
lf_model1 <- which(lf_model1["Water_Year"] == met37_mod1_DoR)
lf_model1 <- lf_model1["Mean_Flow"][lf_model1]
lf_model2 <- which(lf_model2["Water_Year"] == met37_mod1_DoR)
lf_model2 <- lf_model2["Mean_Flow"][lf_model2]
met67_model2_lfmin <- lf_model2
met67_model1_lfmin <- lf_model1
met67_PctError <- (signif(((met67_model2_lfmin - met67_model1_lfmin) / met67_model1_lfmin)*100, digits=3));

# OUTPUTTING MATRICES -----
# Creating directory to store output tables in
# CREATE FOLDER -----------------------------------------------------------
dir.create(paste0(container,"\\results\\user's_results\\",SegID, "_", mod.scenario1, "_vs_", mod.scenario2,"\\Tables"), showWarnings = TRUE)

# All metrics, in a row
ALL_METRICS <- matrix(c(met00_mod1_MeanFlow, met00_mod2_MeanFlow, met00_PctError,
                        met01_mod1_JanLF, met01_mod2_JanLF, met01_PctError,
                        met02_mod1_FebLF, met02_mod2_FebLF, met02_PctError,
                        met03_mod1_MarLF, met03_mod2_MarLF, met03_PctError,
                        met04_mod1_AprLF, met04_mod2_AprLF, met04_PctError,
                        met05_mod1_MayLF, met05_mod2_MayLF, met05_PctError,
                        met06_mod1_JunLF, met06_mod2_JunLF, met06_PctError,
                        met07_mod1_JulLF, met07_mod2_JulLF, met07_PctError,
                        met08_mod1_AugLF, met08_mod2_AugLF, met08_PctError,
                        met09_mod1_SepLF, met09_mod2_SepLF, met09_PctError,
                        met10_mod1_OctLF, met10_mod2_OctLF, met10_PctError,
                        met11_mod1_NovLF, met11_mod2_NovLF, met11_PctError,
                        met12_mod1_DecLF, met12_mod2_DecLF, met12_PctError,
                        met13_mod1_JanMF, met13_mod2_JanMF, met13_PctError,
                        met14_mod1_FebMF, met14_mod2_FebMF, met14_PctError,
                        met15_mod1_MarMF, met15_mod2_MarMF, met15_PctError,
                        met16_mod1_AprMF, met16_mod2_AprMF, met16_PctError,
                        met17_mod1_MayMF, met17_mod2_MayMF, met17_PctError,
                        met18_mod1_JunMF, met18_mod2_JunMF, met18_PctError,
                        met19_mod1_JulMF, met19_mod2_JulMF, met19_PctError,
                        met20_mod1_AugMF, met20_mod2_AugMF, met20_PctError,
                        met21_mod1_SepMF, met21_mod2_SepMF, met21_PctError,
                        met22_mod1_OctMF, met22_mod2_OctMF, met22_PctError,
                        met23_mod1_NovMF, met23_mod2_NovMF, met23_PctError,
                        met24_mod1_DecMF, met24_mod2_DecMF, met24_PctError,
                        met25_mod1_1DayMinMin, met25_mod2_1DayMinMin, met25_PctError,
                        met26_mod1_1DayMinMed, met26_mod2_1DayMinMed, met26_PctError,
                        met27_mod1_3DayMinMin, met27_mod2_3DayMinMin, met27_PctError,
                        met28_mod1_3DayMinMed, met28_mod2_3DayMinMed, met28_PctError,
                        met29_mod1_7DayMinMin, met29_mod2_7DayMinMin, met29_PctError,
                        met30_mod1_7DayMinMed, met30_mod2_7DayMinMed, met30_PctError,
                        met31_mod1_30DayMinMin, met31_mod2_30DayMinMin, met31_PctError,
                        met32_mod1_30DayMinMed, met32_mod2_30DayMinMed, met32_PctError,
                        met33_mod1_90DayMinMin, met33_mod2_90DayMinMin, met33_PctError,
                        met34_mod1_90DayMinMed, met34_mod2_90DayMinMed, met34_PctError,
                        met35_mod1_7Q10, met35_mod2_7Q10, met35_PctError,
                        met37_mod1_DoR, met37_mod2_DoR, met37_PctError,
                        met38_mod1_1NonEx, met38_mod2_1NonEx, met38_PctError,
                        met39_mod1_5NonEx, met39_mod2_5NonEx, met39_PctError,
                        met40_mod1_50NonEx, met40_mod2_50NonEx, met40_PctError,
                        met41_mod1_95NonEx, met41_mod2_95NonEx, met41_PctError,
                        met42_mod1_99NonEx, met42_mod2_99NonEx, met42_PctError,
                        met43_mod1_Sep10, met43_mod2_Sep10, met43_PctError,
                        met44_mod1_Base, met44_mod2_Base, met44_PctError,
                        met45_mod1_JanHF, met45_mod2_JanHF, met45_PctError,
                        met46_mod1_FebHF, met46_mod2_FebHF, met46_PctError,
                        met47_mod1_MarHF, met47_mod2_MarHF, met47_PctError,
                        met48_mod1_AprHF, met48_mod2_AprHF, met48_PctError,
                        met49_mod1_MayHF, met49_mod2_MayHF, met49_PctError,
                        met50_mod1_JunHF, met50_mod2_JunHF, met50_PctError,
                        met51_mod1_JulHF, met51_mod2_JulHF, met51_PctError,
                        met52_mod1_AugHF, met52_mod2_AugHF, met52_PctError,
                        met53_mod1_SepHF, met53_mod2_SepHF, met53_PctError,
                        met54_mod1_OctHF, met54_mod2_OctHF, met54_PctError,
                        met55_mod1_NovHF, met55_mod2_NovHF, met55_PctError,
                        met56_mod1_DecHF, met56_mod2_DecHF, met56_PctError,
                        met57_mod1_1DayMaxMax, met57_mod2_1DayMaxMax, met57_PctError,
                        met58_mod1_1DayMaxMed, met58_mod2_1DayMaxMed, met58_PctError,
                        met59_mod1_3DayMaxMax, met59_mod2_3DayMaxMax, met59_PctError,
                        met60_mod1_3DayMaxMed, met60_mod2_3DayMaxMed, met60_PctError,
                        met61_mod1_7DayMaxMax, met61_mod2_7DayMaxMax, met61_PctError,
                        met62_mod1_7DayMaxMed, met62_mod2_7DayMaxMed, met62_PctError,
                        met63_mod1_30DayMaxMax, met63_mod2_30DayMaxMax, met63_PctError,
                        met64_mod1_30DayMaxMed, met64_mod2_30DayMaxMed, met64_PctError,
                        met65_mod1_90DayMaxMax, met65_mod2_90DayMaxMax, met65_PctError,
                        met66_mod1_90DayMaxMed, met66_mod2_90DayMaxMed, met66_PctError,
                        met67_model1_lfmin, met67_model2_lfmin, met67_PctError),
                      nrow = 3, ncol = 67);
rownames(ALL_METRICS) = c("Model 1", "Model 2", "Pct. Error");
colnames(ALL_METRICS) = c("Overall Mean Flow", "Jan. Low Flow", 
                          "Feb. Low Flow",
                          "Mar. Low Flow", "Apr. Low Flow",
                          "May Low Flow", "Jun. Low Flow",
                          "Jul. Low Flow", "Aug. Low Flow",
                          "Sep. Low Flow", "Oct. Low Flow",
                          "Nov. Low Flow", "Dec. Low Flow",
                          "Jan. Mean Flow", "Feb. Mean Flow",
                          "Mar. Mean Flow", "Apr. Mean Flow",
                          "May Mean Flow", "Jun. Mean Flow",
                          "Jul. Mean Flow", "Aug. Mean Flow",
                          "Sep. Mean Flow", "Oct. Mean Flow",
                          "Nov. Mean Flow", "Dec. Mean Flow",
                          "Min. 1 Day Min", "Med. 1 Day Min.", 
                          "Min. 3 Day Min", "Med. 3 Day Min.",
                          "Min. 7 Day Min", "Med. 7 Day Min.",
                          "Min. 30 Day Min", "Med. 30 Day Min.",
                          "Min. 90 Day Min", "Med. 90 Day Min.", 
                          "7Q10", "Year of 90-Day Low Flow",
                          "1% Non-Exceedance", "5% Non-Exceedance",
                          "50% Non-Exceedance", "95% Non-Exceedance",
                          "99% Non-Exceedance", "Sept. 10% Non-Exceedance",
                          "Mean Baseflow", "Jan. High Flow", 
                          "Feb. High Flow",
                          "Mar. High Flow", "Apr. High Flow",
                          "May High Flow", "Jun. High Flow",
                          "Jul. High Flow", "Aug. High Flow",
                          "Sep. High Flow", "Oct. High Flow",
                          "Nov. High Flow", "Dec. High Flow",
                          "Max. 1 Day Max", "Med. 1 Day Max.", 
                          "Max. 3 Day Max", "Med. 3 Day Max.",
                          "Max. 7 Day Max", "Med. 7 Day Max.",
                          "Max. 30 Day Max", "Med. 30 Day Max.",
                          "Max. 90 Day Max", "Med. 90 Day Max.",
                          "Drought Year Mean");
write.csv(ALL_METRICS, paste0(container,"\\results\\user's_results\\",SegID, "_", mod.scenario1, "_vs_", mod.scenario2,"\\Tables",
                              "\\All_Metrics.csv"));

# Table 1: Monthly Average Flow
Table1 <- matrix(c(met00_mod1_MeanFlow, met13_mod1_JanMF, met14_mod1_FebMF,
                   met15_mod1_MarMF, met16_mod1_AprMF, met17_mod1_MayMF,
                   met18_mod1_JunMF, met19_mod1_JulMF, met20_mod1_AugMF,
                   met21_mod1_SepMF, met22_mod1_OctMF, met23_mod1_NovMF,
                   met24_mod1_DecMF, met00_mod2_MeanFlow, met13_mod2_JanMF,
                   met14_mod2_FebMF, met15_mod2_MarMF, met16_mod2_AprMF,
                   met17_mod2_MayMF, met18_mod2_JunMF, met19_mod2_JulMF,
                   met20_mod2_AugMF, met21_mod2_SepMF, met22_mod2_OctMF,
                   met23_mod2_NovMF, met24_mod2_DecMF, met00_PctError,
                   met13_PctError, met14_PctError, met15_PctError,
                   met16_PctError, met17_PctError, met18_PctError,
                   met19_PctError, met20_PctError, met21_PctError,
                   met22_PctError, met23_PctError, met24_PctError),
                 nrow = 13, ncol = 3);
colnames(Table1) = c("Model 1", "Model 2", "Pct. Error");
rownames(Table1) = c("Overall Mean Flow", 
                     "Jan. Mean Flow", "Feb. Mean Flow",
                     "Mar. Mean Flow", "Apr. Mean Flow",
                     "May Mean Flow", "Jun. Mean Flow",
                     "Jul. Mean Flow", "Aug. Mean Flow",
                     "Sep. Mean Flow", "Oct. Mean Flow",
                     "Nov. Mean Flow", "Dec. Mean Flow");
write.csv(Table1, paste0(container,"\\results\\user's_results\\",SegID, "_", mod.scenario1, "_vs_", mod.scenario2,"\\Tables",
                         "\\Tab. 3 - Monthly Mean Flows.csv"));

# Table 2: Monthly Low Flow
Table2 <- matrix(c(met01_mod1_JanLF, met02_mod1_FebLF, met03_mod1_MarLF,
                   met04_mod1_AprLF, met05_mod1_MayLF, met06_mod1_JunLF,
                   met07_mod1_JulLF, met08_mod1_AugLF, met09_mod1_SepLF,
                   met10_mod1_OctLF, met11_mod1_NovLF, met12_mod1_DecLF,
                   met01_mod2_JanLF, met02_mod2_FebLF, met03_mod2_MarLF, 
                   met04_mod2_AprLF, met05_mod2_MayLF, met06_mod2_JunLF,
                   met07_mod2_JulLF, met08_mod2_AugLF, met09_mod2_SepLF,
                   met10_mod2_OctLF, met11_mod2_NovLF, met12_mod2_DecLF,
                   met01_PctError, met02_PctError, met03_PctError,
                   met04_PctError, met05_PctError, met06_PctError,
                   met07_PctError, met08_PctError, met09_PctError,
                   met10_PctError, met11_PctError, met12_PctError),
                 nrow = 12, ncol = 3);
colnames(Table2) = c("Model 1", "Model 2", "Pct. Error");
rownames(Table2) = c("Jan. Low Flow", "Feb. Low Flow",
                     "Mar. Low Flow", "Apr. Low Flow",
                     "May Low Flow", "Jun. Low Flow",
                     "Jul. Low Flow", "Aug. Low Flow",
                     "Sep. Low Flow", "Oct. Low Flow",
                     "Nov. Low Flow", "Dec. Low Flow");
write.csv(Table2, paste0(container,"\\results\\user's_results\\",SegID, "_", mod.scenario1, "_vs_", mod.scenario2,"\\Tables",
                         "\\Tab. 2 - Monthly Low Flows.csv"));

# Table 3: Monthly High Flow
Table3 <- matrix(c(met45_mod1_JanHF, met46_mod1_FebHF, met47_mod1_MarHF,
                   met48_mod1_AprHF, met49_mod1_MayHF, met50_mod1_JunHF,
                   met51_mod1_JulHF, met52_mod1_AugHF, met53_mod1_SepHF,
                   met54_mod1_OctHF, met55_mod1_NovHF, met56_mod1_DecHF,
                   met45_mod2_JanHF, met46_mod2_FebHF, met47_mod2_MarHF,
                   met48_mod2_AprHF, met49_mod2_MayHF, met50_mod2_JunHF,
                   met51_mod2_JulHF, met52_mod2_AugHF, met53_mod2_SepHF,
                   met54_mod2_OctHF, met55_mod2_NovHF, met56_mod2_DecHF,
                   met45_PctError, met46_PctError, met47_PctError,
                   met48_PctError, met49_PctError, met50_PctError,
                   met51_PctError, met52_PctError, met53_PctError,
                   met54_PctError, met55_PctError, met56_PctError),
                 nrow = 12, ncol = 3);
colnames(Table3) = c("Model 1", "Model 2", "Pct. Error");
rownames(Table3) = c("Jan. High Flow", "Feb. High Flow",
                     "Mar. High Flow", "Apr. High Flow",
                     "May High Flow", "Jun. High Flow",
                     "Jul. High Flow", "Aug. High Flow",
                     "Sep. High Flow", "Oct. High Flow",
                     "Nov. High Flow", "Dec. High Flow");
write.csv(Table3, paste0(container,"\\results\\user's_results\\",SegID, "_", mod.scenario1, "_vs_", mod.scenario2,"\\Tables",
                         "\\Tab. 5 - Monthly High Flows.csv"));

# Table 4: Period Low Flows
Table4 <- matrix(c(met25_mod1_1DayMinMin, met26_mod1_1DayMinMed,
                   met27_mod1_3DayMinMin, met28_mod1_3DayMinMed,
                   met29_mod1_7DayMinMin, met30_mod1_7DayMinMed,
                   met31_mod1_30DayMinMin, met32_mod1_30DayMinMed,
                   met33_mod1_90DayMinMin, met34_mod1_90DayMinMed,
                   met35_mod1_7Q10, met37_mod1_DoR, met67_model1_lfmin,
                   met44_mod1_Base, met25_mod2_1DayMinMin, met26_mod2_1DayMinMed,
                   met27_mod2_3DayMinMin, met28_mod2_3DayMinMed,
                   met29_mod2_7DayMinMin, met30_mod2_7DayMinMed,
                   met31_mod2_30DayMinMin, met32_mod2_30DayMinMed,
                   met33_mod2_90DayMinMin, met34_mod2_90DayMinMed,
                   met35_mod2_7Q10, met37_mod2_DoR,
                   met67_model2_lfmin,  met44_mod2_Base,
                   met25_PctError, met26_PctError, met27_PctError,
                   met28_PctError, met29_PctError, met30_PctError,
                   met31_PctError, met32_PctError, met33_PctError,
                   met34_PctError, met35_PctError,
                   met37_PctError, met67_PctError, met44_PctError), nrow = 14, ncol = 3);
colnames(Table4) = c("Model 1", "Model 2", "Pct. Error");
rownames(Table4) = c("Min. 1 Day Min", "Med. 1 Day Min", 
                     "Min. 3 Day Min", "Med. 3 Day Min",
                     "Min. 7 Day Min", "Med. 7 Day Min",
                     "Min. 30 Day Min", "Med. 30 Day Min",
                     "Min. 90 Day Min", "Med. 90 Day Min", 
                     "7Q10", "Year of 90-Day Low Flow", "Drought Year Mean",
                     "Mean Baseflow");
write.csv(Table4, paste0(container,"\\results\\user's_results\\",SegID, "_", mod.scenario1, "_vs_", mod.scenario2,"\\Tables",
                         "\\Tab. 1 - Low Flow Calculations.csv"));

# Table 5: Period High Flows
Table5 <- matrix(c(met57_mod1_1DayMaxMax, met58_mod1_1DayMaxMed,
                   met59_mod1_3DayMaxMax, met60_mod1_3DayMaxMed,
                   met61_mod1_7DayMaxMax, met62_mod1_7DayMaxMed,
                   met63_mod1_30DayMaxMax, met64_mod1_30DayMaxMed,
                   met65_mod1_90DayMaxMax, met66_mod1_90DayMaxMed,
                   met57_mod2_1DayMaxMax, met58_mod2_1DayMaxMed,
                   met59_mod2_3DayMaxMax, met60_mod2_3DayMaxMed,
                   met61_mod2_7DayMaxMax, met62_mod2_7DayMaxMed,
                   met63_mod2_30DayMaxMax, met64_mod2_30DayMaxMed,
                   met65_mod2_90DayMaxMax, met66_mod2_90DayMaxMed,
                   met57_PctError, met58_PctError,
                   met59_PctError, met60_PctError,
                   met61_PctError, met62_PctError,
                   met63_PctError, met64_PctError,
                   met65_PctError, met66_PctError), 
                 nrow = 10, ncol = 3);
colnames(Table5) = c("Model 1", "Model 2", "Pct. Error");
rownames(Table5) = c("Max. 1 Day Max", "Med. 1 Day Max", 
                     "Max. 3 Day Max", "Med. 3 Day Max",
                     "Max. 7 Day Max", "Med. 7 Day Max",
                     "Max. 30 Day Max", "Med. 30 Day Max",
                     "Max. 90 Day Max", "Med. 90 Day Max");
write.csv(Table5, paste0(container,"\\results\\user's_results\\",SegID, "_", mod.scenario1, "_vs_", mod.scenario2,"\\Tables",
                         "\\Tab. 4 - High Flow Calculations.csv"));

# Table 6: Non-Exceedance Flows
Table6 <- matrix(c(met38_mod1_1NonEx, met39_mod1_5NonEx, met40_mod1_50NonEx,
                   met41_mod1_95NonEx, met42_mod1_99NonEx, met43_mod1_Sep10,
                   met38_mod2_1NonEx, met39_mod2_5NonEx, met40_mod2_50NonEx,
                   met41_mod2_95NonEx, met42_mod2_99NonEx, met43_mod2_Sep10,
                   met38_PctError, met39_PctError, met40_PctError,
                   met41_PctError, met42_PctError, met43_PctError), nrow = 6, ncol = 3);
colnames(Table6) = c("Model 1", "Model 2", "Pct. Error");
rownames(Table6) = c("1% Non-Exceedance", "5% Non-Exceedance",
                     "50% Non-Exceedance", "95% Non-Exceedance",
                     "99% Non-Exceedance", "Sept. 10% Non-Exceedance");
write.csv(Table6, paste0(container,"\\results\\user's_results\\",SegID, "_", mod.scenario1, "_vs_", mod.scenario2,"\\Tables",
                         "\\Tab. 6 - Non-Exceedance Flows.csv"))