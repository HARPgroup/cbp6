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
source(paste0(container, "/DEQ_Model_vs_USGS_Comparison/code/function_holder.R"))

# Inputs
riv.seg <- 'YP4_6720_6750'
#gage.num <- ''
start.date <- '1984-01-01'
end.date <- '2000-12-31'

# Phase Options
    # "p532c-sova"        (phase 5)
    # "p6/p6_gb604/tmp"   (phase 6)
mod.phase1 <- 'p6/p6_gb604/tmp'      
mod.phase2 <- 'p6/p6_gb604/tmp'       

# Scenario Options
    # "p532cal_062211"                (phase 5)
    # "CFBASE30Y20180615"             (phase 6)
    # "CBASE1808L55CY55R45P50R45P50Y" (phase 6)
mod.scenario1 <- 'CBASE1808L55CY55R45P50R45P50Y'
mod.scenario2 <- 'CFBASE30Y20180615'

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
data1_metrics <- metrics.calc.all(data1_trim)
data2_metrics <- metrics.calc.all(data2_trim)

# Metrics for VAHydro



# Comparison Table
comparison <- metrics.compare(data1_metrics, data2_metrics)

# Write csv
write.csv(comparison, paste0(container,"\\Results\\Tables\\",riv.seg, "_", mod.scenario1, "_vs_", mod.scenario2,
                         "_Comparison Results.csv"))

