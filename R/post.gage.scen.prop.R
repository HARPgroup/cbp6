post.gage.scen.prop <- function(riv.seg, gage.title, site, token) {
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
  
  inputs <- list(
    featureid = hydroid,
    entity_type = "dh_feature",
    propname = gage.title,
    propcode = 'usgs-1.0'
  )
  
  scenario <- getProperty(inputs, site, scenario)
  
  # POST PROPERTY IF IT IS NOT YET CREATED
  if (identical(scenario, FALSE)) {
    # create
    inputs$pid = NULL
    inputs$varkey = "om_model_element"
    postProperty(inputs, site, scenprop) 
  } else {
    inputs$pid = scenario$pid
  }
  
  
  # RETRIEVING PROPERTY ONE LAST TIME TO RETURN HYDROID OF PROP
  scenprop <- getProperty(inputs, site, scenprop)
  
  if (scenprop == FALSE) {
    return(FALSE)
  }
  
  return(as.numeric(scenprop$pid))
}
