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
    varkey = "om_water_model_node",
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
  
  omsite = site <- "http://deq2.bse.vt.edu"
  dat <- fn_get_runfile(elid, run.id, site = omsite,  cached = FALSE);
  
  dat.date <- as.Date(as.character(dat$thisdate))
  dat.flow <- as.numeric(dat$Qout)
  
  dat.trim <- data.frame(dat.date, dat.flow, row.names = NULL)
  colnames(dat.trim) <- c('date','flow')
  dat.trim <- window(dat, start = start.date, end = end.date);
  
  return(dat.trim)
}