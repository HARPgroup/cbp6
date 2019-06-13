library(rstudioapi)

# Setting active directory 
current_path <- rstudioapi::getActiveDocumentContext()$path 

# Setting up output location
split.location <- strsplit(current_path, split = '/')
split.location <- as.vector(split.location[[1]])
basepath.stop <- as.numeric(which(split.location == 'code'))
container <- paste0(split.location[1:basepath.stop], collapse = "/")

source(paste0(container, "/cbp6_functions.R"))

RivSeg = "JA5_7480_0001"
# Model phase and scenario
mod.phase <- "p532c-sova" # should be "p6/p6_gb604/tmp" (phase 6) or "p532c-sova" (phase 5)
mod.scenario <- "p532cal_062211" # should be "CFBASE30Y20180615" (phase 6) or "p532cal_062211" (phase 5)
# Start and end dates of data (p5 Model: Has data from 1984-01-01 to 2005-12-31, p6 to 2015-12-31)
start.date <- "1984-01-01"
end.date <- "2005-12-31"

mod.data <- import.model.data(RivSeg, mod.phase, mod.scenario, start.date, end.date)

trimmed.data <- water.year.trim(mod.data)

test <- water.year.trim(import.model.data(RivSeg, mod.phase, mod.scenario, start.date, end.date))
which(test!=trimmed.data)
