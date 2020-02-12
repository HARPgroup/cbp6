vahydro_import_metric_from_scenprop <- function(scenprop.pid, met.varkey, met.propcode, site, token) {
  hydroid = scenprop.pid
  
  metinfo <- list(
    varkey = met.varkey,
    propcode = met.propcode,
    featureid = as.integer(hydroid),
    entity_type = "dh_properties"
  )
  metprop <- getProperty(metinfo, site, metprop)

  return(as.numeric(metprop$propvalue))
}
