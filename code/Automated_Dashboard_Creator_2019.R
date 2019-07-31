mod.phase1 <- 'p6/p6_gb604' #or "p532c-sova" (phase 5)
mod.scenario1 <- 'CFBASE30Y20180615' #or "p532cal_062211" (phase 5)
mod.phase2 <- 'p6/p6_gb604' #or "p532c-sova" (phase 5)
mod.scenario2 <- 'CBASE1808L55CY55R45P50R45P50Y' #or "p532cal_062211" (phase 5)
start.date <- '1984-01-01'
end.date <- '2000-12-31'
cbp6_link <- "C:\\Users\\Kevin D'Andrea\\Desktop\\HARP\\Github\\cbp6\\code"
site_url <- "http://deq2.bse.vt.edu/d.dh"

automated_dashboard <- function(mod.phase1, mod.scenario1, mod.phase2, mod.scenario2, start.date, end.date, cbp6_link, site_url) {

# SETUP
# SETUP
# Setting active directory 
# Setting working directory to the source file location


container1 ="C:\\Users\\Kevin D'Andrea\\Desktop\\HARP\\Github";
container2 = "C:\\Users\\Kevin D'Andrea\\Desktop\\HARP\\Github\\cbp6\\code";

# Sourcing functions
source(paste0(container2,"/cbp6_functions.R"))

#retrieve rest token
source(paste0(container1, "/auth.private"));

#load rest username and password, contained in auth.private file

token <- rest_token(site_url, token, rest_uname, rest_pw);
options(timeout=120); # set timeout to twice default level to avoid abort due to high traffic

info <- read.csv("C:\\Users\\Kevin D'Andrea\\Desktop\\HARP\\Github\\cbp6\\code\\data.csv")
master.table <- data.frame()

counter <- 1

while (counter <= 1) { #change to number of rows on full csv
  riv.seg <- as.character(info[counter,1]) #input for model data import
  site_number <- paste0("0",info[counter,2]) #input for model data import
  rmarkdown::render(paste0("Working_Dashboard_2019.Rmd"), "pdf_document", output_dir = "C:\\Users\\Kevin D'Andrea\\Desktop\\HARP\\Github\\cbp6\\code", output_file = paste0(riv.seg, ".pdf"))
  # LOADING DATA ------------------------------------------------------------
  
  data1 <- model_import_data_cfs(riv.seg, mod.phase1, mod.scenario1, start.date, end.date)
  data2 <- model_import_data_cfs(riv.seg, mod.phase2, mod.scenario2, start.date, end.date)
  
  data1 <- water_year_trim(data1)
  data2 <- water_year_trim(data2)
  
  metrics1 <- metrics_calc_all(data1) #calculate metrics into a matrix
  metrics2 <- metrics_calc_all(data2)
  all_metrics <- metrics_compare(metrics1, metrics2)
  # table.metrics1 <- data.frame(riv.seg,metrics1[1,1],metrics1[1,67],metrics1[1,61],metrics1[1,59]) #create row to add to overall dataframe
  # table.metrics2 <- data.frame(riv.seg,metrics2[1,1],metrics2[1,67],metrics2[1,61],metrics2[1,59]) #create row to add to overall dataframe
  # colnames(table.metrics1) <- c('River Segment', 'Overall Mean Flow', 'Mean Baseflow', 'September 10%', '7Q10') 
  # colnames(table.metrics2) <- c('River Segment', 'Overall Mean Flow', 'Mean Baseflow', 'September 10%', '7Q10') 
  master.table <- rbind(master.table, all_metrics, stringsAsFactors = FALSE)
  counter <- counter + 1
}

}
