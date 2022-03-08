# INPUTS TO ALTER
# land.segment <- 'A10003'
# wdmpath <- '/opt/model/p53/p532c-sova'
# mod.scenario <- 'p532cal_062211'
# start.year <- '1984'
# end.year <- '2005'

wdm_export_land_flow <- function(land.segment, wdmpath, mod.scenario, start.year, end.year) {
  # land.use.list <- c('afo', 'alf', 'ccn', 'cex', 'cfo', 'cid', 'cpd', 'for', 'hom', 'hvf',
  #                    'hwm', 'hyo', 'hyw', 'lwm', 'nal', 'nex', 'nhi', 'nho', 'nhy', 'nid',
  #                    'nlo', 'npa', 'npd', 'pas', 'rcn', 'rex', 'rid', 'rpd', 'trp', 'urs')
  land.use.list <- list.dirs(paste0(wdmpath, "/tmp/wdm/land"), full.name = FALSE, recursive = FALSE)
  dsn.list <- c('111','211','411')
  
  # SETTING UP LOOPS TO GENERATE ALL LAND USE UNIT FLOWS
  counter <- 1
  total.files <- as.integer(length(land.use.list)*length(dsn.list))

  for (i in 1:length(dsn.list)) {
    for (j in 1:length(land.use.list)) {
      wdm.location <- paste(wdmpath, '/tmp/wdm/land/', land.use.list[j], '/', mod.scenario, sep = '')
      wdm.name <- paste0(land.use.list[j],land.segment,'.wdm')
      
      # SETTING UP AND RUNNING COMMAND LINE COMMANDS
      setwd(wdm.location)
      # cd.to.wdms <- paste('cd ', wdm.location, sep = '')
      # exec_wait(cmd = cd.to.wdms)
      
      print(paste("Creating unit flow .csv for ", counter, "of", total.files))
      
      quick.wdm.2.txt.inputs <- paste(paste0(land.use.list[j],land.segment,'.wdm'), start.year, end.year, dsn.list[i], sep = ',')
      # note: this version expects the executable wdm2text (alias of quick_wdm_2_txt_hour_2_hour) to be in exec PATH
      run.quick.wdm.2.txt <- paste("echo", quick.wdm.2.txt.inputs, "| wdm2text", sep = ' ')
      system(command = run.quick.wdm.2.txt)
      
      # INCREMENTING COUNTER
      counter <- counter+1
    }
  }
}


#' Land Use Unit Flow at Edge of Stream for All Uses Compiler Function 
#' @description Compiles .csv files for all land uses unit flows into one .csv 
#' @param land.segment a string containing the name of a CBP land segment
#' @param wdmpath a string giving the filepath to within the model phase directory
#' @param mod.scenario a string of the model scenario -- ex. "p532cal_062211"
#' @param outpath the location where the output .csv file should be created
#' @return The location of the exported .csv land use unit flow file 
#' @import lubridate
#' @export land.use.eos.all

# DOCUMENTATION ----------
# Daniel Hildebrand
# 6-11-19
# This script generates a single .csv file named "[cbp_scenario][landsegment]_eos_all" containing columns for 
# [luname_suro], [luname_ifwo], [luname_agwo] for all land uses.

# LOADING LIBRARIES ----------
library(lubridate)

wdm_merge_land_flow <- function(land.segment, wdmpath, mod.scenario, outpath, use_fread = TRUE, clean = TRUE) {
  # INPUTS ----------
  land.use.list <- list.dirs(paste0(wdmpath, "/tmp/wdm/land"), full.name = FALSE, recursive = FALSE)
  dsn.list <- data.frame(dsn = c('0111', '0211', '0411'), dsn.label = c('suro', 'ifwo', 'agwo'))
  
  # READING IN AND DELETING READ-IN LAND USE DATA FROM MODEL ----------
  counter <- 1
  total.files <- as.integer(length(land.use.list)*length(dsn.list$dsn))
  for (i in 1:length(dsn.list$dsn)) {
    for (j in 1:length(land.use.list)) {
      input.data.namer <- paste0(land.segment,land.use.list[j],dsn.list$dsn[i])
      print(paste("Downloading", counter, "of", total.files))
      counter <- counter+1
      tfname = paste0(wdmpath, "/tmp/wdm/land/",land.use.list[j],"/",mod.scenario,"/",land.use.list[j],land.segment,"_",dsn.list$dsn[i],".csv")
      if (use_fread == TRUE) {
        temp.data.input <- try(data.table::fread(tfname))
        temp.data.input <= as.data.frame(temp.data.input)
      } else {     
        temp.data.input <- try(read.csv(tfname))
      }
      if (class(temp.data.input) == 'try-error') {
        stop(paste0("ERROR: Missing land use .csv files (including ", wdmpath, "/tmp/wdm/land/",land.use.list[j],"/",mod.scenario,"/",land.use.list[j],land.segment,"_",dsn.list$dsn[i],".csv", ")"))
      }
      colnames(temp.data.input) <- c('Year', 'Month', 'Day', 'Hour', as.character(dsn.list$dsn.label[i]))
      temp.data.input$thisdate <- strptime(paste(temp.data.input$Year, "-", temp.data.input$Month, "-", temp.data.input$Day, ":", temp.data.input$Hour, sep = ""), format = "%Y-%m-%d:%H")
      temp.data.formatter <- data.frame(temp.data.input$thisdate, temp.data.input[5])
      colnames(temp.data.formatter) <- c('thisdate', colnames(temp.data.input[5]))
      assign(input.data.namer,temp.data.formatter)
      # Deleting read in file:
      if (clean == TRUE) {
        command <- paste0('rm ', wdmpath, "/tmp/wdm/land/",land.use.list[j],"/",mod.scenario,"/",land.use.list[j],land.segment,"_",dsn.list$dsn[i],".csv")
        system(command)
      }
    }
  }
  
  # COMBINING DATA FROM EACH TYPE OF FLOW INTO A SINGLE DATA FRAME ----------
  dsn.namer <- ''
  for (i in 1:length(dsn.list$dsn)) {
    dsn.namer <- paste0(dsn.namer, dsn.list$dsn[i], '-')
  }
  dsn.namer <- substr(dsn.namer, 1, nchar(dsn.namer)-1) 
  overall.data.namer <- paste(land.segment, "_", dsn.namer, sep = '')
  counter <- 1
  for (i in 1:length(land.use.list)) {
    for (j in 1:length(dsn.list$dsn)) {
      input.data.namer <- paste0(land.segment,land.use.list[i],dsn.list$dsn[j])
      temp.data.holder <- get(input.data.namer)
      if (counter == 1) {
        overall.data.builder <- temp.data.holder
        names(overall.data.builder)[2] <- paste(land.use.list[i], colnames(temp.data.holder[2]), sep = "_") 
      } else {
        overall.data.builder[,counter+1] <- temp.data.holder[,2]
        names(overall.data.builder)[names(overall.data.builder) == paste0('V', counter+1)] <- paste(land.use.list[i], colnames(temp.data.holder[2]), sep = '_')
      }
      counter <- counter + 1
    }
  }
  return(overall.data.builder)
}
