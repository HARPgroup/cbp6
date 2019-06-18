# DOCUMENTATION -----------------------------------------------------------

# downloads model data from DEQ2, downloads climate change scenario from

# LIBRARIES ---------------------------------------------------------------

library(dataRetrieval)
library(lubridate)
library(plyr)
library(rstudioapi)

# Setting active directory 
# Setting working directory to the source file location
current_path <- rstudioapi::getActiveDocumentContext()$path 

# Setting up output location
split.location <- strsplit(current_path, split = '/')
split.location <- as.vector(split.location[[1]])
basepath.stop <- as.numeric(which(split.location == 'DEQ_Model_vs_Climate_Model'))
container <- paste0(split.location[1:basepath.stop], collapse = "/")

# INPUTS ------------------------------------------------------------------

# Input River Segment ID number
SegID <- "BS1_8730_8540"

# Model phase and scenario
mod.phase1 <- "p532c-sova" # should be "p6/p6_gb604/tmp" (phase 6) or "p532c-sova" (phase 5)
mod.scenario1 <- "p532cal_062211" # should be "CFBASE30Y20180615" (phase 6) or "p532cal_062211"

# Model phase and scenario
mod.phase2 <- "p532c-sova" # should be "p6/p6_gb604/tmp" (phase 6) or "p532c-sova" (phase 5)
mod.scenario2 <- "p532cal_062211" # should be "CFBASE30Y20180615" (phase 6) or "p532cal_062211"


# Start and end dates of data (Model: Has data from 1984-01-01 to 2005-12-31)
start.date <- "1984-01-01"
end.date <- "2005-12-31"

# CARRYOVER IF MASTER IS BEING RUN ----------------------------------------
if (exists("container.master") == TRUE) {
  container <- container.master
  SegID <- SegID.master
  new.or.original <- new.or.original.master
}

# CREATING DIRECTORIES FOR DATA STORAGE
dir.create(paste0(container, "\\data\\new_(updated)_data"), showWarnings = FALSE)
dir.create(paste0(container,"\\data\\new_(updated)_data\\raw_data"), showWarnings = FALSE);
dir.create(paste0(container,"\\data\\new_(updated)_data\\raw_data\\gage_data"), showWarnings = FALSE)
dir.create(paste0(container,"\\data\\new_(updated)_data\\raw_data\\merged_data"), showWarnings = FALSE)
dir.create(paste0(container,"\\data\\new_(updated)_data\\raw_data\\model_data"), showWarnings = FALSE)
dir.create(paste0(container,"\\data\\new_(updated)_data\\raw_data\\model_data\\hourly_data"), showWarnings = FALSE)
dir.create(paste0(container,"\\data\\new_(updated)_data\\raw_data\\model_data\\daily_data"), showWarnings = FALSE)

# IMPORTING AND EXPORTING MODEL DATA ----------------------------------------------------

# Splitting the River Segment string into each segment name
RivSegStr1 <- strsplit(SegID, "\\+")
RivSegStr1 <- RivSegStr1[[1]]
num.segs1 <- length(RivSegStr1)
model_days1 <- length(seq(as.Date(start.date):as.Date(end.date)))

#Reads data into data frame "ovols", exports each seg's data
# Downloading and exporting hourly model data
model_hourly1 <- read.csv(paste0("http://deq2.bse.vt.edu/", mod.phase1, "/wdm/river/", mod.scenario1, "/stream/", 
                                  SegID, "_0111.csv"), header = FALSE, sep = ",", stringsAsFactors = FALSE);  
write.csv(model_hourly1, file = paste0(container, "/data/new_(updated)_data/raw_data/model_data/hourly_data/",mod.scenario1," - Hourly Raw Data.csv"))
  
# Converting hourly to daily data and exporting daily data
model_hourly1 <- model_hourly1[-1,]
model_hourly1$V1 <- trimws(model_hourly1$V1, which = "both")
colnames(model_hourly1) <- c("year","month","day","hour","ovol")
model_hourly1$date <- as.Date(paste0(model_hourly1$year,"-",model_hourly1$month,"-",model_hourly1$day))
model_daily1 <- aggregate(model_hourly1$ovol, list(model_hourly1$date), FUN = sum)
colnames(model_daily1) <- c("date","mod1.flow")
write.csv(model_daily1, file = paste0(container, "/data/new_(updated)_data/raw_data/model_data/daily_data/", mod.scenario1," - Daily Raw Data.csv"))
  
# IMPORTING AND EXPORTING CLIMATE MODEL DATA ----------------------------------------------------

# Splitting the River Segment string into each segment name
RivSegStr2 <- strsplit(SegID, "\\+")
RivSegStr2 <- RivSegStr2[[1]]
num.segs2 <- length(RivSegStr2)
model_days2 <- length(seq(as.Date(start.date):as.Date(end.date)))

#Reads data into data frame "ovols", exports each seg's data
# Downloading and exporting hourly model data
model_hourly2 <- read.csv(paste0("http://deq2.bse.vt.edu/", mod.phase2, "/wdm/river/", mod.scenario2, "/stream/", 
                                  SegID, "_0111.csv"), header = FALSE, sep = ",", stringsAsFactors = FALSE);  
write.csv(model_hourly2, file = paste0(container, "/data/new_(updated)_data/raw_data/model_data/hourly_data/", mod.scenario2," - Hourly Raw Data.csv"))

# Converting hourly to daily data and exporting daily data
model_hourly2 <- model_hourly2[-1,]
model_hourly2$V1 <- trimws(model_hourly2$V1, which = "both")
colnames(model_hourly2) <- c("year","month","day","hour","ovol")
model_hourly2$date <- as.Date(paste0(model_hourly2$year,"-",model_hourly2$month,"-",model_hourly2$day))
model_daily2 <- aggregate(model_hourly2$ovol, list(model_hourly2$date), FUN = sum)
colnames(model_daily2) <- c("date","mod2.flow")
write.csv(model_daily2, file = paste0(container, "/data/new_(updated)_data/raw_data/model_data/daily_data/", mod.scenario2," - Daily Raw Data.csv"))
  
# Merging data and exporting merged data
combined.flows <- merge(model_daily1, model_daily2, by.x = "date", by.y = "date", all = TRUE)
write.csv(combined.flows, file = paste0(container, "/data/", SegID, "_", mod.scenario1, "_vs_", mod.scenario2," - Raw Data.csv"))


