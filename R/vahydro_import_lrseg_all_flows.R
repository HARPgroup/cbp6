vahydro_import_lrseg_all_flows <- function(lr.seg.hydrocode, run.id, token, site = "http://deq2.bse.vt.edu/d.dh", start.date = '1984-01-01', end.date) {
  #set hydrocode equal to the ith hydrocode in the lrseg list
  hydrocode = lr.seg.hydrocode
  
  #set inputs for lrseg property
  ftype = 'cbp6_lrseg'
  bundle = 'landunit'
  inputs <- list (
    hydrocode = hydrocode,
    bundle = bundle,
    ftype = ftype
  )
  
  #property dataframe returned
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);

  featureid <- odata[1,"hydroid"];
  inputs <- list(
    varkey = "om_class_cbp_eos_file",
    featureid = featureid,
    entity_type = "dh_feature",
    propcode = "vahydro-1.0"
  )
  model <- getProperty(inputs, site, model)
  
  fin = as.numeric(as.character(model[1,]$pid))
  inputs <- list(
    varkey = "om_element_connection",
    featureid = fin,
    entity_type = "dh_properties"
  )
  prop <- getProperty(inputs, site, prop)
  
  # Manual elid
  elid = as.numeric(as.character(prop[1,]$propvalue))
  
  omsite = site <- "http://deq2.bse.vt.edu"
  dat <- fn_get_runfile(elid, run.id, site = omsite,  cached = FALSE);
  
  dat <- as.data.frame(dat)
  
  dat.trim <- dat[,c(9,146,15:143)]
  rownames(dat.trim) <- NULL
  
  start.line <- as.numeric(which(dat.trim$thisdate == start.date))
  end.line <- as.numeric(which(dat.trim$thisdate == end.date))
  dat.trim <- dat.trim[start.line:end.line,]

  return(dat.trim)
}
