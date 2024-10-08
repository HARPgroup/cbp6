#' Import vahydro local runoff inflow model run data
#' @description Imports data from the vahydro site about a model run's local runoff inflow property
#' @param riv.seg Specific river segment of interest 
#' @param run.id the VA hydro run ID of the specified vahydro model run
#' @param token the VA hydro token to access the specified site
#' @param site the specified vahydro site to be accessed
#' @param start.date the starting date of analysis, format 'yyyy-mm-dd'
#' @param end.date the ending date of analysis, format 'yyyy-mm-dd'
#' @return A dataframe containing the specfic vahydro model data for the local runoff inflow property
#' @import pander
#' @import httr
#' @import hydroTSM
#' @export vahydro_import_local.runoff.inflows_cfs

vahydro_import_local.runoff.inflows_cfs <- function(riv.seg, run.id, token, site = "http://deq2.bse.vt.edu/d.dh", start.date = '1984-01-01', end.date) {
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
  
  if (odata == FALSE) {
    return(odata)
  }
  
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
    propname = "1. Local Runoff Inflows",
    featureid = mid,
    entity_type = "dh_properties"
  )
  midprop <- getProperty(inputs, site, midprop)
  
  if (midprop == FALSE) {
    return(midprop)
  }
  
  fin = as.numeric(as.character(midprop[1,]$pid))
  inputs <- list(
    varkey = "om_element_connection",
    featureid = fin,
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
  dat <- fn_get_runfile_mod(elid, run.id, site = omsite,  cached = FALSE);
  
  if(is.na(dat) != TRUE) {
    if (dat == FALSE) {
      return(dat)
    }
  }  
    
  dat.date <- as.Date(as.character(dat$thisdate))
  dat.flow.unit <- as.numeric(dat$Runit)
  
  dat.trim <- data.frame(dat.date, dat.flow.unit, row.names = NULL)
  colnames(dat.trim) <- c('date','flow.unit')
  
  start.line <- as.numeric(which(dat.trim$date == start.date))
  end.line <- as.numeric(which(dat.trim$date == end.date))
  dat.trim <- dat.trim[start.line:end.line,]
  
  return(dat.trim)
}
