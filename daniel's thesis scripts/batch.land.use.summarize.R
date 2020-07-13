# If given the location of a directory containing SURO, AGWO, and IFWO combined land use files,
# this function will combine the different files and land uses to create one file with all
# land use data.  This function should be run on the deq2 server.

batch.land.use.summarize <- function(dirpath) {
  csv.list <- list.files(path = dirpath, pattern = "_0111-0211-0411\\.csv$", recursive = FALSE)
  land.use.table <- data.frame(matrix(data = NA, nrow = length(csv.list), ncol = 44))
  colnames(land.use.table) = c('segment', 'aop', 'cch', 'cci', 'ccn', 'cfr', 'cir', 'cmo', 'cnr', 
                               'ctg', 'dbl', 'fnp', 'for', 'fsp', 'gom', 'gwm', 'hfr', 'lhy', 
                               'mch', 'mci', 'mcn', 'mir', 'mnr', 'mtg', 'nch', 'nci', 'nir', 
                               'nnr', 'ntg', 'oac', 'ohy', 'osp', 'pas', 'sch', 'scl', 'sgg', 
                               'sho', 'som', 'soy', 'stb', 'stf', 'swm', 'wfp', 'wto')
  for (i in 1:length(csv.list)) {
    data <- try(read.csv(paste(dirpath, csv.list[i], sep = '/')))
    trim <- which(as.Date(data$thisdate) >= as.Date('1991-01-01') & as.Date(data$thisdate) <= as.Date('2000-12-31'))
    data <- data[trim,]
    
    print(paste('Downloading data for segment', i, 'of', length(csv.list), sep = ' '))
    
    segment <- substr(csv.list[i], 1, 6)
    
    if (class(data) == 'try-error') {
      stop(paste0("ERROR: Missing climate .csv files (including ", dirpath, "/", csv.list[i]))
    }
    
    land.use.table$segment[i] <- segment
    land.use.table$aop[i] <- mean(data$aop_suro + data$aop_ifwo + data$aop_agwo)
    land.use.table$cch[i] <- mean(data$cch_suro + data$cch_ifwo + data$cch_agwo)
    land.use.table$cci[i] <- mean(data$cci_suro + data$cci_ifwo + data$cci_agwo)
    land.use.table$ccn[i] <- mean(data$ccn_suro + data$ccn_ifwo + data$ccn_agwo)
    land.use.table$cfr[i] <- mean(data$cfr_suro + data$cfr_ifwo + data$cfr_agwo)
    land.use.table$cir[i] <- mean(data$cir_suro + data$cir_ifwo + data$cir_agwo)
    land.use.table$cmo[i] <- mean(data$cmo_suro + data$cmo_ifwo + data$cmo_agwo)
    land.use.table$cnr[i] <- mean(data$cnr_suro + data$cnr_ifwo + data$cnr_agwo)
    land.use.table$ctg[i] <- mean(data$ctg_suro + data$ctg_ifwo + data$ctg_agwo)
    land.use.table$dbl[i] <- mean(data$dbl_suro + data$dbl_ifwo + data$dbl_agwo)
    land.use.table$fnp[i] <- mean(data$fnp_suro + data$fnp_ifwo + data$fnp_agwo)
    land.use.table$`for`[i] <- mean(data$for_suro + data$for_ifwo + data$for_agwo)
    land.use.table$fsp[i] <- mean(data$fsp_suro + data$fsp_ifwo + data$fsp_agwo)
    land.use.table$gom[i] <- mean(data$gom_suro + data$gom_ifwo + data$gom_agwo)
    land.use.table$gwm[i] <- mean(data$gwm_suro + data$gwm_ifwo + data$gwm_agwo)
    land.use.table$hfr[i] <- mean(data$hfr_suro + data$hfr_ifwo + data$hfr_agwo)
    land.use.table$lhy[i] <- mean(data$lhy_suro + data$lhy_ifwo + data$lhy_agwo)
    land.use.table$mch[i] <- mean(data$mch_suro + data$mch_ifwo + data$mch_agwo)
    land.use.table$mci[i] <- mean(data$mci_suro + data$mci_ifwo + data$mci_agwo)
    land.use.table$mcn[i] <- mean(data$mcn_suro + data$mcn_ifwo + data$mcn_agwo)
    land.use.table$mir[i] <- mean(data$mir_suro + data$mir_ifwo + data$mir_agwo)
    land.use.table$mnr[i] <- mean(data$mnr_suro + data$mnr_ifwo + data$mnr_agwo)
    land.use.table$mtg[i] <- mean(data$mtg_suro + data$mtg_ifwo + data$mtg_agwo)
    land.use.table$nch[i] <- mean(data$nch_suro + data$nch_ifwo + data$nch_agwo)
    land.use.table$nci[i] <- mean(data$nci_suro + data$nci_ifwo + data$nci_agwo)
    land.use.table$nir[i] <- mean(data$nir_suro + data$nir_ifwo + data$nir_agwo)
    land.use.table$nnr[i] <- mean(data$nnr_suro + data$nnr_ifwo + data$nnr_agwo)
    land.use.table$ntg[i] <- mean(data$ntg_suro + data$ntg_ifwo + data$ntg_agwo)
    land.use.table$oac[i] <- mean(data$oac_suro + data$oac_ifwo + data$oac_agwo)
    land.use.table$ohy[i] <- mean(data$ohy_suro + data$ohy_ifwo + data$ohy_agwo)
    land.use.table$osp[i] <- mean(data$osp_suro + data$osp_ifwo + data$osp_agwo)
    land.use.table$pas[i] <- mean(data$pas_suro + data$pas_ifwo + data$pas_agwo)
    land.use.table$sch[i] <- mean(data$sch_suro + data$sch_ifwo + data$sch_agwo)
    land.use.table$scl[i] <- mean(data$scl_suro + data$scl_ifwo + data$scl_agwo)
    land.use.table$sgg[i] <- mean(data$sgg_suro + data$sgg_ifwo + data$sgg_agwo)
    land.use.table$sho[i] <- mean(data$sho_suro + data$sho_ifwo + data$sho_agwo)
    land.use.table$som[i] <- mean(data$som_suro + data$som_ifwo + data$som_agwo)
    land.use.table$soy[i] <- mean(data$soy_suro + data$soy_ifwo + data$soy_agwo)
    land.use.table$stb[i] <- mean(data$stb_suro + data$stb_ifwo + data$stb_agwo)
    land.use.table$stf[i] <- mean(data$stf_suro + data$stf_ifwo + data$stf_agwo)
    land.use.table$swm[i] <- mean(data$swm_suro + data$swm_ifwo + data$swm_agwo)
    land.use.table$wfp[i] <- mean(data$wfp_suro + data$wfp_ifwo + data$wfp_agwo)
    land.use.table$wto[i] <- mean(data$wto_suro + data$wto_ifwo + data$wto_agwo)
  }
  write.csv(land.use.table, paste(dirpath, 'land.use.table.csv', sep = '/'))
}