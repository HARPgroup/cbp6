#This function gets the unique ID of a scenario property for a container 
# storing metrics of a VA Hydro model run with the timespan trimmed to 
# that of the associated USGS gage
#It is similar to get.scen.prop.R, with the exception of the trimmed timespan

riv.seg <- "YP3_6330_6700"
site <- 'http://deq2.bse.vt.edu/d.dh'
token <- rest_token(site, token, rest_uname, rest_pw)
run.id <- 11

elid <- get.gage.timespan.scen.prop(riv.seg, run.id, site, token)


get.gage.timespan.scen.prop <- function(riv.seg, run.id, site, token) {
  # GETTING MODEL DATA FROM VA HYDRO
  hydrocode = paste("vahydrosw_wshed_", riv.seg, sep="");
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list(
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  
  if (odata == FALSE) {
    return(FALSE)
  }
  
  hydroid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name);
  print(paste("Retrieved hydroid", hydroid, "for", fname, riv.seg, sep=' '));
  
  # GETTING VA HYDRO MODEL ELEMENT FROM VA HYDRO
  inputs <- list(
    varkey = "om_water_model_node",
    featureid = hydroid,
    entity_type = "dh_feature",
    propcode = 'vahydro-1.0')
  
  
  scenario <- getProperty(inputs, site, scenario)
  
  if (scenario == FALSE) {
    return(FALSE)
  }
  
  # DETERMINING PROPNAME AND PROPCODE FOR SCENARIO PROPERTY
  scen.propname <- paste0('runid_', run.id, "_gage_timespan")
  scen.propcode <- ''
  
  # GETTING SCENARIO PROPERTY FROM VA HYDRO
  sceninfo <- list(
    varkey = 'om_scenario',
    propname = scen.propname,
    featureid = as.integer(as.character(scenario$pid)),
    entity_type = "dh_properties",
    propvalue = 0,
    propcode = scen.propcode,
    startdate = NULL,
    enddate = NULL
    # startdate = as.numeric(as.POSIXct(start.date, origin = "1970-01-01", tz = "GMT")),
    # enddate = as.numeric(as.POSIXct(end.date, origin = "1970-01-01", tz = "GMT"))
    # at the moment, there are bugs in startdate and enddate on vahydro
  )
  scenprop <- getProperty(sceninfo, site, scenprop)
  
  if (scenprop == FALSE) {
    return(FALSE)
  }
  
  return(as.numeric(scenprop$pid))
}
