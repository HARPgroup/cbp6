import.model.data <- function(riv.seg, mod.phase, mod.scenario, start.date, end.date) {
  # Downloading and exporting hourly model data
  model_hourly <- read.csv(paste0("http://deq2.bse.vt.edu/", mod.phase, "/wdm/river/", mod.scenario, "/stream/", 
                                  RivSeg, "_0111.csv"), header = FALSE, sep = ",", stringsAsFactors = FALSE);  
  # Converting hourly to daily data and exporting daily data
  model_hourly <- model_hourly[-1,]
  model_hourly$V1 <- trimws(model_hourly$V1, which = "both")
  colnames(model_hourly) <- c("year","month","day","hour","ovol")
  model_hourly$date <- as.Date(paste0(model_hourly$year,"-",model_hourly$month,"-",model_hourly$day))
  model_daily <- aggregate(model_hourly$ovol, list(model_hourly$date), FUN = sum)
  colnames(model_daily) <- c("date","mod.flow")
  return(model_daily)
}

water.year.trim <- function(data) {
  library(lubridate)
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
  return(data)
}

metric.calculation <- function() { #inputs: trimmed data converted to cfs

  # for: number of metrics:
    # Calculates flow metric
    # Uploads metric to VA Hydro
    # Puts calculated metric in "all metric" dataframe
  
  # Returns dataframe of all calculated metrics
  return()
}

scenario.comparison <- function() { #inputs: dataframe of all calculated metrics from scenario 1, #dataframe of all calculated metrics from scenario 2
  # Calculates percent change for all metrics (but should it be mod1-mod2/mod2 or mod2-mod1/mod1)?
  
  # Returns dataframe of pct changes for all metrics
  return()
}


monthly.min.flow <- function() {
  
  return(monthly.min)
}

