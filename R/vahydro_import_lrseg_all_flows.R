library(dplyr)

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
  
  dat.trim <- select(dat,
                     thisdate, Qout, aop_suro, aop_ifwo, aop_agwo, 
                     cch_suro, cch_ifwo, cch_agwo, 
                     cci_suro, cci_ifwo, cci_agwo, 
                     ccn_suro, ccn_ifwo, ccn_agwo, 
                     cfr_suro, cfr_ifwo, cfr_agwo, 
                     cir_suro, cir_ifwo, cir_agwo, 
                     cmo_suro, cmo_ifwo, cmo_agwo, 
                     cnr_suro, cnr_ifwo, cnr_agwo, 
                     ctg_suro, ctg_ifwo, ctg_agwo, 
                     dbl_suro, dbl_ifwo, dbl_agwo, 
                     fnp_suro, fnp_ifwo, fnp_agwo, 
                     for_suro, for_ifwo, for_agwo, 
                     fsp_suro, fsp_ifwo, fsp_agwo, 
                     gom_suro, gom_ifwo, gom_agwo, 
                     gwm_suro, gwm_ifwo, gwm_agwo, 
                     hfr_suro, hfr_ifwo, hfr_agwo, 
                     lhy_suro, lhy_ifwo, lhy_agwo, 
                     mch_suro, mch_ifwo, mch_agwo, 
                     mci_suro, mci_ifwo, mci_agwo, 
                     mcn_suro, mcn_ifwo, mcn_agwo, 
                     mir_suro, mir_ifwo, mir_agwo, 
                     mnr_suro, mnr_ifwo, mnr_agwo, 
                     mtg_suro, mtg_ifwo, mtg_agwo, 
                     nch_suro, nch_ifwo, nch_agwo, 
                     nci_suro, nci_ifwo, nci_agwo, 
                     nir_suro, nir_ifwo, nir_agwo, 
                     nnr_suro, nnr_ifwo, nnr_agwo, 
                     ntg_suro, ntg_ifwo, ntg_agwo, 
                     oac_suro, oac_ifwo, oac_agwo, 
                     ohy_suro, ohy_ifwo, ohy_agwo, 
                     osp_suro, osp_ifwo, osp_agwo, 
                     pas_suro, pas_ifwo, pas_agwo, 
                     sch_suro, sch_ifwo, sch_agwo, 
                     scl_suro, scl_ifwo, scl_agwo, 
                     sgg_suro, sgg_ifwo, sgg_agwo, 
                     sho_suro, sho_ifwo, sho_agwo, 
                     som_suro, som_ifwo, som_agwo, 
                     soy_suro, soy_ifwo, soy_agwo, 
                     stb_suro, stb_ifwo, stb_agwo, 
                     stf_suro, stf_ifwo, stf_agwo, 
                     swm_suro, swm_ifwo, swm_agwo, 
                     wfp_suro, wfp_ifwo, wfp_agwo, 
                     wto_suro, wto_ifwo, wto_agwo)
                     
  #dat.trim <- dat[,c(9,146,15:143)]
  rownames(dat.trim) <- NULL
  
  start.line <- as.numeric(which(dat.trim$thisdate == start.date))
  end.line <- as.numeric(which(dat.trim$thisdate == end.date))
  dat.trim <- dat.trim[start.line:end.line,]

  return(dat.trim)
}
