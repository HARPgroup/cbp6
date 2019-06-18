## Load and Format Data -------------------------------------------------------------------------------------------

# Libraries

library(dataRetrieval)
library(lubridate)
library(plyr)
library(rstudioapi)
library(IHA)
library(PearsonDS)
library(zoo)
library(lfstat)

# Setting active directory 
current_path <- rstudioapi::getActiveDocumentContext()$path 

# Setting up output location
split.location <- strsplit(current_path, split = '/')
split.location <- as.vector(split.location[[1]])
basepath.stop <- as.numeric(which(split.location == 'code'))
container <- paste0(split.location[1:basepath.stop], collapse = "/")

source(paste0(container, "/cbp6_functions.R"))

# Inputs
riv.seg <- 'JA5_7480_0001'
#gage.num <- ''
start.date <- '1984-01-01'
end.date <- '2005-12-31'

mod.phase1 <- 'p532c-sova'        # should be "p6/p6_gb604/tmp" (phase 6) or "p532c-sova" (phase 5)
mod.phase2 <- 'p6/p6_gb604/tmp'        # should be "p6/p6_gb604/tmp" (phase 6) or "p532c-sova" (phase 5)
mod.scenario1 <- 'p532cal_062211' # should be "CFBASE30Y20180615" (phase 6) or "p532cal_062211"
mod.scenario2 <- 'CFBASE30Y20180615' # should be "CFBASE30Y20180615" (phase 6) or "p532cal_062211"

# Loading data for models
data1 <- model.import.data.cfs(riv.seg, mod.phase1, mod.scenario1, start.date, end.date)
data2 <- model.import.data.cfs(riv.seg, mod.phase2, mod.scenario2, start.date, end.date)

# Loading data for gages
#data1 <- gage.import.data.cfs(riv.seg, start.date, end.date)
#data2 <- gage.import.data.cfs(riv.seg, start.date, end.date)

# Trim to water year
data1_trim <- water.year.trim(data1)
data2_trim <- water.year.trim(data2)

## Calculate and Compare Metrics ----------------------------------------------------------------------------------

# Individual calculations for models and gages
data1_metrics <- metric.compile(data1_trim)
data2_metrics <- metric.compile(data2_trim)

# Metrics for VAHydro



# Comparison Table
comparison <- compare.models(data1_metrics, data2_metrics)



