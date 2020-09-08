# This function returns the unique ID of a scenario property for a container storing 
# metrics of a raw CBP data run as a number.

get.cbp.scen.prop <- function(riv.seg, mod.scenario, dat.source, run.id, start.date, end.date, site, token) {
  # GETTING MODEL DATA FROM VA HYDRO
  hydrocode = paste("vahydrosw_wshed_", riv.seg, sep="");
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list(
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  #property dataframe returned for above inputs
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
  } else {
    print('Error: data source is neither "cbp_model" nor "vahydro"')
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
  } else {
    print('Error: data source is neither "cbp_model" nor "vahydro"')
    return(FALSE)
  }
  
  return(as.numeric(scenario$pid))
}
