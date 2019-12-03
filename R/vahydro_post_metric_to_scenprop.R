vahydro_post_metric_to_scenprop <- function(scenprop.pid, met.varkey, met.propcode, met.name, met.value, site, token) {
  hydroid = scenprop.pid

  metinfo <- list(
    varkey = met.varkey,
    propcode = met.propcode,
    featureid = as.integer(hydroid),
    entity_type = "dh_properties"
  )
  metprop <- getProperty(metinfo, site, metprop)
  
  if (identical(metprop, FALSE)) {
    # create
    metinfo$pid = NULL
  } else {
    metinfo$pid = metprop$pid
  }
  
  metinfo$propname = met.name
  metinfo$varkey = met.varkey
  metinfo$propcode = met.propcode
  metinfo$propvalue = met.value
  postProperty(metinfo,base_url = site,metprop) 
}
