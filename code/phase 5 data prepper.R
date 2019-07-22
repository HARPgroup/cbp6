basepath="C:\\Users\\Kevin D'Andrea\\Desktop\\HARP\\GitHub\\hydro-tools"

combined.flows <- read.csv(paste0(basepath, "\\HARP-2018\\DEQ_Model_vs_USGS_Comparison\\data\\original_(reproducible)_data\\derived_data\\trimmed+area-adjusted_data\\", site_number, "_vs_", riv.seg, " - Derived Data.csv"))
combined.flows$Date <- as.Date(combined.flows$date, format="%Y-%m-%d")

# REMOVING NA DATA --------------------------------------------------------

data <- combined.flows[complete.cases(combined.flows),]

# TRIMMING TO WATER YEAR --------------------------------------------------

data.length <- length(data$Date)
start.month <- month(data$Date[1])
end.month <- month(data$Date[data.length])
start.day <- day(data$Date[1])
end.day <- day(data$Date[data.length])

if (start.month <= 9) {
  start.year <- year(data$Date[1])
} else if (start.month == 10 & start.day == 1) {
  start.year <- year(data$Date[1])
} else {
  start.year <- year(data$Date[1]) + 1
}

if (end.month >= 10) {
  end.year <- year(data$Date[data.length])
} else if (end.month == 9 & end.day == 30) {
  end.year <- year(data$Date[data.length])
} else {
  end.year <- year(data$Date[data.length]) - 1
}

start.date <- paste0(start.year, "-10-01")
end.date <- paste0(end.year, "-09-30")

start.line <- which(data$Date == start.date)
end.line <- which(data$Date == end.date)

data <- data[start.line:end.line,]

data1 <- data
data1 <- data1[,-1]
data1 <- data1[,-2]
data1 <- data1[,-3]
data2 <- data
data2 <- data2[,-1]
data2 <- data2[,-2]
data2 <- data2[,-3]
colnames(data1) <- c('date', 'flow')
colnames(data2) <- c('date', 'flow')