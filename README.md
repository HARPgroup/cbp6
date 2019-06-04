# cbp6
# This is an example of modifying files 
``` r  
## Download data for gage (2008-2017 Q subdaily (15 minute intervals))
library(dataRetrieval)
library(lubridate)
library(dplyr)
gage_id <- '02073000'
start_date <- '2008-10-01'
end_date <- '2017-09-30'
pCode <- '00060'
USGS_flow <- readNWISuv(gage_id, pCode, start_date, end_date)
``` 
