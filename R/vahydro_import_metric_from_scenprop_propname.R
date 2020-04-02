vahydro_import_metric_from_scenprop_propname <- function(scenprop.pid, met.varkey, met.propcode, site, token, met.propname) {
  hydroid = scenprop.pid
  
  metinfo <- list(
    varkey = met.varkey,
    propcode = met.propcode,
    propname = met.propname,
    featureid = as.integer(hydroid),
    entity_type = "dh_properties"
  )
  metprop <- getProperty(metinfo, site, metprop)
  
  if (metprop == FALSE) {
    return(FALSE)
  }
  
  return(as.numeric(metprop$propvalue))
}