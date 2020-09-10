# This function gets the unique ID of a scenario property posted to the 
# vahydro property on a watershed feature
# Inputs: 
#   riv.seg - last portion of certain river segment hydrocode on vahydro. ex: 'TU3_9180_9090'
#   mod.scenario - specific model scenario of interest, default mod.scenario is 'vahydro - 1.0'
#   dat.source - either 'vahydro' or 'cbp_model' 
#   run.id - unique runid for desired model run. ex: run.id = '11' for runid_11 scenario run
#   start.date - starting date for analysis, format = 'yyyy-mm-dd'
#   end.date - ending date for analysis, format = 'yyyy-mm-dd'
#   site - specified vahydro site to be accessed
#   token - vahydro token to access this specific site
# Outputs: Unique ID for scenario property

get.scen.prop <- function(riv.seg, mod.scenario, dat.source, run.id, start.date, end.date, site, token) {
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
  
  if (dat.source == 'cbp_model') {
    # GETTING SCENARIO MODEL ELEMENT FROM VA HYDRO
    inputs <- list(
      varkey = "om_model_element",
      featureid = hydroid,
      entity_type = "dh_feature",
      propcode = mod.scenario
    )
  } else if (dat.source == 'vahydro') {
    # GETTING VA HYDRO MODEL ELEMENT FROM VA HYDRO
    inputs <- list(
      varkey = "om_water_model_node",
      featureid = hydroid,
      entity_type = "dh_feature",
      propcode = 'vahydro-1.0'
    )
  } else if (dat.source == 'gage') {
    # GETTING VA HYDRO MODEL ELEMENT FROM VA HYDRO
    #varkey = "om_model_element",
    inputs <- list(
      featureid = hydroid,
      varkey = "om_model_element",
      entity_type = "dh_feature",
      propcode = 'usgs-1.0'
    )
  } else {
    print('Error: data source is neither "cbp_model", "gage" nor "vahydro"')
    return(FALSE)
  }
  
  scenario <- getProperty(inputs, site, scenario)
  
  if (scenario == FALSE) {
    return(FALSE)
  }
  
  # DETERMINING PROPNAME AND PROPCODE FOR SCENARIO PROPERTY
  if (dat.source == 'cbp_model') {
    scen.propname <- mod.scenario
    scen.propcode <- mod.scenario
  } else if (dat.source == 'vahydro') {
    scen.propname <- paste0('runid_', run.id)
    scen.propcode <- ''
  } else if (dat.source == 'gage') {
    scen.propname <- paste0('runid_', run.id)
    scen.propcode <- ''
  } else {
    print('Error: data source is neither "cbp_model" nor "vahydro"')
    return(FALSE)
  }
  
  
  
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
  
  # POST PROPERTY IF IT IS NOT YET CREATED
  if (identical(scenprop, FALSE)) {
    # create
    message("Creating scenario property")
    inputs$pid = NULL
    postProperty(sceninfo, site, scenprop) 
  } else {
    inputs$pid = scenario$pid
  }
  
  # RETRIEVING PROPERTY ONE LAST TIME TO RETURN HYDROID OF PROP
  scenprop <- getProperty(sceninfo, site, scenprop)
  
  if (scenprop == FALSE) {
    return(FALSE)
  }
  
  return(as.numeric(scenprop$pid))
}