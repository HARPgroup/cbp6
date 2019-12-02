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
  
  # GETTING SCENARIO MODEL ELEMENT FROM VA HYDRO
  inputs <- list(
    varkey = "om_model_element",
    featureid = hydroid,
    entity_type = "dh_feature",
    propcode = mod.scenario
  )
  scenario <- getProperty(inputs, site, scenario)
  
  # DETERMINING PROPNAME AND PROPCODE FOR SCENARIO PROPERTY
  if (dat.source == 'cbp_model') {
    scen.propname <- mod.scenario
    scen.propcode <- mod.scenario
  } else if (dat.source == 'vahydro') {
    scen.propname <- paste0('run_', run.id)
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
    # propvalue = 'finished',
    propvalue = 0,
    propcode = scen.propcode,
    startdate = NULL,
    enddate = NULL
    # startdate = start.date,
    # enddate = end.date
  )
  scenprop <- getProperty(sceninfo, site, scenprop)
  
  # POST PROPERTY IF IT IS NOT YET CREATED
  if (identical(scenprop, FALSE)) {
    # create
    sceninfo = sceninfo
    sceninfo$pid = NULL
  } else {
    sceninfo$pid = scenprop$pid
  }
  
  postProperty(sceninfo,base_url = site,sceninfo) 
}