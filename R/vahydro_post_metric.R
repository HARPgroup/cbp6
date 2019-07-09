#' Import Post Metric from VAHydro Function
#' @description Imports post metric from VAHydro for a given scenario
#' @param met.varkey input variable key
#' @param met.propcode input prop code
#' @param met.name input name of metric
#' @param seg.or.gage indicate segment name or gage number
#' @param mod.scenario input scenario code
#' @param token input token number for access
#' @param site input site name
#' @return post metric data
#' @import sp
#' @export vahydro_post_metric

vahydro_post_metric <- function(met.varkey, met.propcode, met.name, met.value, seg.or.gage, mod.scenario = "p532cal_062211", token, site) {
  if (nchar(seg.or.gage)==8) {
    # GETTING GAGE DATA FROM VA HYDRO
    hydrocode = paste("usgs_",seg.or.gage,sep="");
    ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
    inputs <- list (
      hydrocode = hydrocode
    )
  } else if (nchar(seg.or.gage)==13) {
    # GETTING MODEL DATA FROM VA HYDRO
    hydrocode = paste("vahydrosw_wshed_",seg.or.gage,sep="");
    ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
    inputs <- list (
      hydrocode = hydrocode,
      bundle = 'watershed',
      ftype = 'vahydro'
    )
  }
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  hydroid <- odata[1,"hydroid"];
  fname <- as.character(odata[1,]$name );
  print(paste("Retrieved hydroid",hydroid,"for", fname,seg.or.gage, sep=' '));
  inputs <- list(
    varkey = "om_model_element",
    featureid = hydroid,
    entity_type = "dh_feature",
    propcode = mod.scenario
  )
  property <- getProperty(inputs, site, property)
  
  metinfo <- list(
    varkey = met.varkey,
    propcode = met.propcode,
    featureid = as.integer(as.character(property$pid)),
    entity_type = "dh_properties"
  )
  metprop <- getProperty(metinfo, site, metprop)
  
  if (identical(metprop, FALSE)) {
    # create
    metprop = metinfo
  }
  
  metprop$propname = met.name
  metprop$varkey = met.varkey
  metprop$propcode = met.propcode
  metprop$propvalue = signif(met.value, digits=3)
  metprop$pid = NULL
  postProperty(metprop,fxn_locations,base_url = site,metprop) 
}