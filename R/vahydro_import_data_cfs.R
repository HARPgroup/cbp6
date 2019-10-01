#' Import USGS Gage Information Function 
#' @description Imports data from the USGS, harvested from their stream gages
#' @param riv.seg Specific river segment of interest 
#' @param run.id the VA hydro run ID of the specified vahydro model run
#' @param token the VA hydro token to access the specified site
#' @param site the specified vahydro site to be accessed
#' @return A dataframe containing the specfic river segments vahydro model data
#' @import pander
#' @import httr
#' @import hydroTSM
#' @export model_import_data_cfs

vahydro_import_data_cfs <- function(riv.seg, run.id, token, site = "http://deq2.bse.vt.edu/d.dh") {
  hydrocode = paste0("vahydrosw_wshed_", riv.seg);
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list (
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  
  # Get data frame for stashing multirun data
  stash <- data.frame();
  mostash <- data.frame();
  tsstash = FALSE;
  featureid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name );
  inputs <- list(
    varkey = "wshed_local_area_sqmi",
    featureid = featureid,
    entity_type = "dh_feature"
  )
  da <- getProperty(inputs, site, model)
  
  inputs <- list(
    varkey = "om_model_element",
    featureid = featureid,
    entity_type = "dh_feature",
    propcode = "vahydro-1.0"
  )
  model <- getProperty(inputs, site, model)
  mid = as.numeric(as.character(model[1,]$pid))
  inputs <- list(
    varkey = "om_element_connection",
    featureid = mid,
    entity_type = "dh_properties"
  )
  prop <- getProperty(inputs, site, prop)
  
  # Manual elid
  elid = as.numeric(as.character(prop[1,]$propvalue))
  
  wshed_summary_tbl = data.frame(
    "Run ID" = character(), 
    "Segment Name (D. Area)" = character(), 
    "7Q10/ALF/LF-90" = character(), 
    "WD (mean/max)" = character(), 
    stringsAsFactors = FALSE) ;
  #pander(odata);
  #pander(odata);
  
  omsite = site <- "http://deq2.bse.vt.edu"
  dat <- fn_get_runfile(elid, run.id, site = omsite,  cached = FALSE);
  
  dat.date <- as.Date(as.character(dat$thisdate))
  dat.flow <- as.numeric(dat$Qout)
  
  dat.trim <- data.frame(dat.date, dat.flow, row.names = NULL)
  colnames(dat.trim) <- c('date','flow')
    
  return(dat.trim)
}
