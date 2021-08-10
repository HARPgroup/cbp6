vahydro_post_metric_to_scenprop <- function(scenprop.pid, met.varkey, met.propcode, met.name, met.value, ds = FALSE) {
  if (is.logical(ds)) {
    stop("Error: This function has been modified to require a ds (RomDataSource) argument.")
  }
  if (is.null(met.propcode)) {
    met.propcode <- ''
  }
  metinfo <- list(
    varkey = met.varkey,
    propname = met.name,
    featureid = as.integer(scenprop.pid),
    entity_type = "dh_properties",
    bundle = "dh_properties"
  )
  metprop <- RomProperty$new( ds, metinfo, TRUE)
  metprop$propcode <- met.propcode
  metprop$propvalue <- as.numeric(met.value)
  metprop$save(TRUE)
}

