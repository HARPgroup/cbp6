vahydro_post_metric_to_scenprop <- function(scenprop.pid, met.varkey, met.propcode, met.name, met.value, ds = FALSE) {
  hydroid = scenprop.pid
  if (is.logical(ds)) {
    stop("Error: This function has been modified to require a ds (RomDataSource) argument.")
  }
  metinfo <- list(
    varkey = met.varkey,
    propcode = met.propcode,
    propname = met.name,
    featureid = as.integer(hydroid),
    entity_type = "dh_properties"
  )
  metprop <- RomProperty$new( ds, metinfo, TRUE)
  metprop$propname = met.name
  metprop$varkey = met.varkey
  metprop$propcode = met.propcode
  metprop$propvalue = met.value
  metprop$save(TRUE)
}
