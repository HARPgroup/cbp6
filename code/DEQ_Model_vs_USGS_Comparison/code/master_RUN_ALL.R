# DOCUMENTATION -----------------------------------------------------------

# Runs all scripts for one or all gages.  Can either use existing data or
# download new data.

# CLEARING ENVIRONMENT ----------------------------------------------------

rm(list = ls())

# LOADING RMARKDOWN -------------------------------------------------------

library(rmarkdown)

# Setting active directory 
# Setting working directory to the source file location
current_path <- rstudioapi::getActiveDocumentContext()$path 

# Setting up output location
split.location <- strsplit(current_path, split = '/')
split.location <- as.vector(split.location[[1]])
basepath.stop <- as.numeric(which(split.location == 'DEQ_Model_vs_USGS_Comparison'))
container.master <- paste0(split.location[1:basepath.stop], collapse = "/")

# INPUTS ------------------------------------------------------------------

# USGS Gage number
# If "all" is inputted as siteNo.master, analysis will be run for ALL gages
# stored in the Gage.To.Segment.csv file.
siteNo.master <- "01646500"

mod.phase.master <- "p6/p6_gb604/tmp" # should be "p6/p6_gb604/tmp" (phase 6) or "p532c-sova" (phase 5)
mod.scenario.master <- "CFBASE30Y20180615" # should be "CFBASE30Y20180615" (phase 6) or "p532cal_062211"

# Should new or original data be used?
new.or.original.master <- "new"

# LINKING MODEL SEGMENT ---------------------------------------------------

gage.to.segment <- read.csv(file.path(container.master, "data", "Gage_To_Segment.csv"),
                            header = TRUE, sep = ',', stringsAsFactors = FALSE)

# IF "ALL", RUNS ALL GAGES THROUGH SCRIPTS --------------------------------
# otherwise, runs one specific gage through the scripts up to spatial analysis
if (siteNo.master == "all") {
  gage.list <- gage.to.segment$gage
  no.gages <- length(gage.list)
  for (i in 1:no.gages) {
    gage.to.segment <- read.csv(file.path(container.master, "data", "Gage_To_Segment.csv"),
                                header = TRUE, sep = ',', stringsAsFactors = FALSE)
    siteNo.master <- paste0("0", as.character(gage.list[i]))
    gage.to.segment <- subset(gage.to.segment, gage.to.segment$gage == as.numeric(siteNo.master))
    RivSeg.master <- gage.to.segment$segment
    if (new.or.original.master == "new") {
      rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
      print(paste0('Downloading data for segment ', i, ' of ', as.numeric(no.gages)))
      source(paste0(container.master,"\\code\\data_downloader.R"))
      rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
      print(paste0('Prepping data for segment ', i, ' of ', as.numeric(no.gages)))
      source(paste0(container.master,"\\code\\data_prepper.R"))
      rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
      print(paste0('Calculating metrics for segment ', i, ' of ', as.numeric(no.gages)))
      source(paste0(container.master,"\\code\\metric_calculator.R"))
      rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
      print(paste0('Creating plots for segment ', i, ' of ', as.numeric(no.gages)))
      source(paste0(container.master,"\\code\\plot_creator.R"))
      rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
      print(paste0('Calculating highest error periods for segment ', i, ' of ', as.numeric(no.gages)))
      source(paste0(container.master,"\\code\\error_calculator.R"))
      rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
      print(paste0('Creating dashboard document for segment ', i, ' of ', as.numeric(no.gages)))
      #rmarkdown::render(paste0(container.master, "\\code\\dashboard_creator.Rmd"), "pdf_document", 
                        #output_dir = paste0(container.master, "\\results\\user's_results\\", siteNo.master, "_vs_", RivSeg.master),
                        #output_file = paste0(siteNo.master, " - Gage vs. Model Dashboard.pdf"))
    } else if (new.or.original.master == "original") {
      rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
      source(paste0(container.master,"\\code\\metric_calculator.R"))
      rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
      source(paste0(container.master,"\\code\\plot_creator.R"))
      rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
      source(paste0(container.master,"\\code\\error_calculator.R"))
      rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
      # rmarkdown::render(paste0(container.master, "\\code\\dashboard_creator.Rmd"), "pdf_document",
      #                   output_dir = paste0(container.master, "\\results\\user's_results\\", siteNo.master, "_vs_", RivSeg.master),
      #                   output_file = paste0(siteNo.master, " - Gage vs. Model Dashboard.pdf"))
    }
  }
  rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
  source(paste0(container.master,"\\code\\all_errors_all_segments_outputter.R"))
  rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
  source(paste0(container.master,"\\code\\spatial_analysis.R"))
} else {
  gage.to.segment <- read.csv(file.path(container.master, "data", "Gage_To_Segment.csv"),
                              header = TRUE, sep = ',', stringsAsFactors = FALSE)
  gage.to.segment <- subset(gage.to.segment, gage.to.segment$gage == as.numeric(siteNo.master))
  RivSeg.master <- gage.to.segment$segment
  if (new.or.original.master == "new") {
    rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
    source(paste0(container.master,"\\code\\data_downloader.R"))
    rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
    source(paste0(container.master,"\\code\\data_prepper.R"))
    rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
    source(paste0(container.master,"\\code\\metric_calculator.R"))
    rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
    source(paste0(container.master,"\\code\\plot_creator.R"))
    rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
    source(paste0(container.master,"\\code\\error_calculator.R"))
    rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
    # rmarkdown::render(paste0(container.master, "\\code\\dashboard_creator.Rmd"), "pdf_document", 
    #                   output_dir = paste0(container.master, "\\results\\user's_results\\", siteNo.master, "_vs_", RivSeg.master),
    #                   output_file = paste0(siteNo.master, " - Gage vs. Model Dashboard.pdf"))
  } else if (new.or.original.master == "original") {
    rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
    source(paste0(container.master,"\\code\\metric_calculator.R"))
    rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
    source(paste0(container.master,"\\code\\plot_creator.R"))
    rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
    source(paste0(container.master,"\\code\\error_calculator.R"))
    rm(list=setdiff(ls(), c("container.master", "container.master.cont", "siteNo.master", "new.or.original.master", "RivSeg.master", "i", "gage.to.segment", "gage.list", "no.gages", "gage.to.segmentsub", "mod.phase.master", "mod.scenario.master")))
    # rmarkdown::render(paste0(container.master, "\\code\\dashboard_creator.Rmd"), "pdf_document", 
    #                  output_dir = paste0(container.master, "\\results\\user's_results\\", siteNo.master, "_vs_", RivSeg.master),
    #                  output_file = paste0(siteNo.master, " - Gage vs. Model Dashboard.pdf"))
  }
}