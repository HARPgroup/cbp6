#' Import USGS Gage Information Function 
#' @description Imports data from the USGS, harvested from their stream gages
#' @param riv.seg Specific river segment of interest 
#' @param run.id the VA hydro run ID of the specified vahydro model run
#' @param token the VA hydro token to access the specified site
#' @param site the specified vahydro site to be accessed
#' @param start.date the starting date of analysis, format 'yyyy-mm-dd'
#' @param end.date the ending date of analysis, format 'yyyy-mm-dd'
#' @return A dataframe containing the specfic river segments vahydro model data
#' @import pander
#' @import httr
#' @import hydroTSM
#' @export vahydro_import_data_cfs

vahydro_import_data_cfs <- function(riv.seg, run.id, token, site = "http://deq2.bse.vt.edu/d.dh", start.date = '1984-01-01', end.date) {
  hydrocode = paste0("vahydrosw_wshed_", riv.seg);
      # creates hydrocode using riv.seg
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list (
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
      # creates a list of 3: hydrocode, bundle, and ftype
  
  # PROPERTY DATAFRAME RETURNED
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
      # makes a dataframe with feature information
  
  # GET DATA FRAME FOR STASHING MULTIRUN DATA
  stash <- data.frame();
  mostash <- data.frame();
  tsstash = FALSE;
  featureid <- odata[1,"hydroid"];
      # defines featureid
  fname <- as.character(odata[1,]$name );
  inputs <- list(
    varkey = "wshed_local_area_sqmi",
    featureid = featureid,
    entity_type = "dh_feature"
  )
      # re-defines list information to make a new dataframe
      # each new dataframe houses information that is pulled from the new lists
  da <- getProperty(inputs, site, model)
      # makes a new dataframe
  
  inputs <- list(
    varkey = "om_water_model_node",
    featureid = featureid,
    entity_type = "dh_feature",
    propcode = "vahydro-1.0"
  )
  model <- getProperty(inputs, site, model)
  mid = as.numeric(as.character(model[1,]$pid))
      # defines pid
  inputs <- list(
    varkey = "om_element_connection",
    featureid = mid,
    entity_type = "dh_properties"
  )
  prop <- getProperty(inputs, site, prop)
  
  # MANUAL ELID
  elid = as.numeric(as.character(prop[1,]$propvalue))
  
  wshed_summary_tbl = data.frame(
    "Run ID" = character(), 
    "Segment Name (D. Area)" = character(), 
    "7Q10/ALF/LF-90" = character(), 
    "WD (mean/max)" = character(), 
    stringsAsFactors = FALSE) ;
      # makes an empty dataframe with column names
  
  #pander(odata);
  #pander(odata);
  
  omsite = site <- "http://deq2.bse.vt.edu"
      # defines VAHydro site URL
  dat <- fn_get_runfile(elid, run.id, site = omsite,  cached = FALSE);
      # creates a zoo file pulling info from VAHydro (ELID, Run_id)
  
  dat.date <- as.Date(as.character(dat$thisdate))
  dat.flow <- as.numeric(dat$Qout)
      # vectors of dates and flows
  
  dat.trim <- data.frame(dat.date, dat.flow, row.names = NULL)
  colnames(dat.trim) <- c('date','flow')
      # combines the two vectors into a dataframe
  
  start.line <- as.numeric(which(dat.trim$date == start.date))
  end.line <- as.numeric(which(dat.trim$date == end.date))
      # defines the row at which the start date and end date are
  dat.trim <- dat.trim[start.line:end.line,]
      # trims the data to within that date range
  
  return(dat.trim)
      # returns dataframe of dates and flows (cfs) within date range
}
