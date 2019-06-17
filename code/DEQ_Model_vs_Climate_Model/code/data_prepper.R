# DOCUMENTATION -----------------------------------------------------------

# Loads previously downloaded data, trims it to proper time frame, removes
# lines of code where gage or model data is NA, area-adjusts data.

# LOADING LIBRARIES -------------------------------------------------------

library('lubridate')
library('dataRetrieval')

# Setting active directory 
# Setting working directory to the source file location
current_path <- rstudioapi::getActiveDocumentContext()$path 

# Setting up output location
split.location <- strsplit(current_path, split = '/')
split.location <- as.vector(split.location[[1]])
basepath.stop <- as.numeric(which(split.location == 'GitHub'))
basepath <- paste0(split.location[1:basepath.stop], collapse = "/")
container <- paste0(basepath,"/cbp6/code/DEQ_Model_vs_Climate_Model")

# INPUTS ------------------------------------------------------------------

# Input River Segment ID number
SegID <- "PM7_4820_0001"

# Should new or original data be used?
new.or.original <- "new"

site <- "http://deq2.bse.vt.edu/d.dh"    #Specify the site of interest, either d.bet OR d.dh

# SETUP

#retrieve rest token
source(paste(basepath,"auth.private", sep = "/")); #load rest username and password, contained in auth.private file
source(paste(basepath, "rest_functions.R", sep = '/')) # loading REST functions, like token generator
token <- rest_token(site, token, rest_uname, rest_pw);
options(timeout=120); # set timeout to twice default level to avoid abort due to high traffic

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

# CREATING DIRECTORIES FOR DATA STORAGE -----------------------------------
dir.create(paste0(container,"\\data\\new_(updated)_data\\derived_data"), showWarnings = FALSE)
dir.create(paste0(container,"\\data\\new_(updated)_data\\derived_data\\trimmed_data"), showWarnings = FALSE)
dir.create(paste0(container,"\\data\\new_(updated)_data\\derived_data\\trimmed+area-adjusted_data"), showWarnings = FALSE)

# LOADING DATA ------------------------------------------------------------

data <- read.csv(paste0(container, "/data/",  SegID, "_", mod.scenario1, "_vs_", mod.scenario2," - Raw Data.csv"))
data <- data[,-1]

# REMOVING NA DATA --------------------------------------------------------

data <- data[complete.cases(data),]

# TRIMMING TO WATER YEAR --------------------------------------------------

data.length <- length(data$date)
start.month <- month(data$date[1])
end.month <- month(data$date[data.length])
start.day <- day(data$date[1])
end.day <- day(data$date[data.length])

if (start.month <= 9) {
  start.year <- year(data$date[1])
} else if (start.month == 10 & start.day == 1) {
  start.year <- year(data$date[1])
} else {
  start.year <- year(data$date[1]) + 1
}

if (end.month >= 10) {
  end.year <- year(data$date[data.length])
} else if (end.month == 9 & end.day == 30) {
  end.year <- year(data$date[data.length])
} else {
  end.year <- year(data$date[data.length]) - 1
}

start.date <- paste0(start.year, "-10-01")
end.date <- paste0(end.year, "-09-30")

start.line <- which(data$date == start.date)
end.line <- which(data$date == end.date)

data <- data[start.line:end.line,]

# ELIMINATING UNNECCESARY COLUMNS -----------------------------------------

data <- data[,c("date", "mod1.flow", "mod2.flow")]
data <- setNames(data, c("Date", "Model1.Flow", "Model2.Flow"))

# ADJUSTING MODEL FLOW -----------------------------------------------

# Model data is in acre-feet
# USGS gage data is in cfs
# The conversion factor from acre-feet to cfs is 0.504167

data$Model1.Flow <- data$`Model1.Flow`* 0.504167
data$Model2.Flow <- data$`Model2.Flow`* 0.504167

# EXPORTING "TRIMMED FLOW" ------------------------------------------------

# Exporting "trimmed flow"
write.csv(data, file = paste0(container, container.cont, "/derived_data/trimmed+area-adjusted_data/",  SegID, "_", mod.scenario1, "_vs_", mod.scenario2," - Derived Data.csv"))

# AREA-ADJUSTING FLOW -----------------------------------------------------

# Splitting the River Segment string into each segment name
RivSegStr <- strsplit(RivSeg, "\\+")
RivSegStr <- RivSegStr[[1]]
num.segs <- length(RivSegStr)
sum.model.area <- 0

for (i in 1:num.segs) {

# GETTING MODEL DATA FROM VA HYDRO
hydrocode = paste("vahydrosw_wshed_",RivSegStr[i],sep="");
ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
inputs <- list (
  hydrocode = hydrocode,
  bundle = 'watershed',
  ftype = 'vahydro'
)
#property dataframe returned
feature = FALSE;
odata <- getFeature(inputs, token, site, feature);
hydroid <- odata[1,"hydroid"];
fname <- as.character(odata[1,]$name );
print(paste("Retrieved hydroid",hydroid,"for", fname,RivSegStr[i], sep=' '));

# Getting the local drainage area feature
areainfo <- list(
  varkey = "wshed_drainage_area_sqmi",
  featureid = as.integer(as.character(hydroid)),
  entity_type = "dh_feature"
)
model.area <- getProperty(areainfo, site, model.area)
model.area <- model.area$propvalue
sum.model.area <- sum.model.area + model.area
}

ratio <- gage.area/sum.model.area

data$model.flow <- data$model.flow*(gage.area/sum.model.area)
