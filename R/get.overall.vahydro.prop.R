# This functions purpose is to get a specific PID for a certain property of a feature on vahydro.
# Inputs required:
#   riv.seg - last portion of certain river segment hydrocode on vahydro. ex: 'TU3_9180_9090'
#   site - specified vahydro site to be accessed
#   token - vahydro token to access this specific site
# Output: Unique property PID as a numeric value
# Other functions within function:
#   getFeature - base level function of getting a feature from VA Hydro
#   getProperty - base level function of getting a property from VA Hydro

get.overall.vahydro.prop <- function(riv.seg, site, token) {
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
  
    # GETTING VA HYDRO MODEL ELEMENT FROM VA HYDRO
    inputs <- list(
      varkey = "om_water_model_node",
      featureid = hydroid,
      entity_type = "dh_feature",
      propcode = 'vahydro-1.0'
    )
  
  scenario <- getProperty(inputs, site, scenario)
  
  return(as.numeric(scenario$pid))
}