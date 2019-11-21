# source('C:\\Users\\danie\\Documents\\HARP\\GitHub\\auth.private')
# riv.seg <- 'JU3_7400_7510'
# site <- 'http://deq2.bse.vt.edu/d.dh'
# source('C:\\Users\\danie\\Documents\\HARP\\GitHub\\cbp6\\code\\cbp6_functions.R')
# source('C:\\Users\\danie\\Documents\\HARP\\GitHub\\cbp6\\code\\fn_vahydro-1.0.R')
# token <- rest_token(site, token, rest_uname, rest_pw)

link.cbp6.lrseg.hydrocodes = function(riv.seg, psk, site, token) {
  # Get the hydro ID of the River Segment feature
  hydrocode = paste0("vahydrosw_wshed_", riv.seg);
  ftype = 'vahydro'; # nhd_huc8, nhd_huc10, vahydro
  inputs <- list (
    hydrocode = hydrocode,
    bundle = 'watershed',
    ftype = 'vahydro'
  )
  
  feature = FALSE;
  odata <- getFeature(inputs, token, site, feature);
  riv.seg.hydro.id <- as.character(odata$hydroid)
  
  # create URL and output file for the table of land units linked to the river segment
  dat.url <- paste0(site, '/watershed-contains-wkt/', riv.seg.hydro.id, '/landunit/', psk)
  destfile <- paste0(getwd(), '\\lrsegs.wkt')
  
  # downloading, loading, and deleting table of land units linked to river segment
  download.file(dat.url, destfile, method = 'libcurl')
  land.units <- read.table(destfile, header = TRUE, sep = ',')
  unlink(destfile)
  
  # getting list of cbp6 land-river segments linked to river segment
  cbp6.landunits <- as.vector(land.units$hydrocode[land.units$Bundle..Type == 'Land Unit: cbp6_lrseg'])
  
  return(cbp6.landunits)
}
