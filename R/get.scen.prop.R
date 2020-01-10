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
      varkey = "om_model_element",
      featureid = hydroid,
      entity_type = "dh_feature",
      propcode = 'vahydro-1.0'
    )
  } else {
    stop('Error: data source is neither "cbp_model" nor "vahydro"')
  }
  
  scenario <- getProperty(inputs, site, scenario)
  
  # DETERMINING PROPNAME AND PROPCODE FOR SCENARIO PROPERTY
  if (dat.source == 'cbp_model') {
    scen.propname <- mod.scenario
    scen.propcode <- mod.scenario
  } else if (dat.source == 'vahydro') {
    scen.propname <- paste0('runid_', run.id)
    scen.propcode <- paste0('vahydro_', mod.scenario)
  } else {
    stop('Error: data source is neither "cbp_model" nor "vahydro"')
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
    sceninfo$pid = NULL
  } else {
    sceninfo$pid = scenprop$pid
  }
  
  postProperty(sceninfo, site, scenprop) 
  
  # RETRIEVING PROPERTY ONE LAST TIME TO RETURN HYDROID OF PROP
  scenprop <- getProperty(sceninfo, site, scenprop)
  
  return(as.numeric(scenprop$pid))
}