vahydro_import_om_class_constant_from_scenprop <- function(scenprop.pid, met.varkey, met.propcode, met.propname, site, token) {
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
