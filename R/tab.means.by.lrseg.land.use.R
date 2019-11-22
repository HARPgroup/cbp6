library(knitr)

tab.means.by.lrseg.land.use = function(tmp.data) {
  aop.names <- grep('aop', colnames(tmp.data), value = TRUE)
  aop.cols <- which(colnames(tmp.data) %in% aop.names)
  aop.data <- as.numeric(as.matrix(tmp.data[,aop.cols]))
  aop.mean <- mean(aop.data)
  
  ccn.names <- grep('ccn', colnames(tmp.data), value = TRUE)
  ccn.cols <- which(colnames(tmp.data) %in% ccn.names)
  ccn.data <- as.numeric(as.matrix(tmp.data[,ccn.cols]))
  ccn.mean <- mean(ccn.data)
  
  cmo.names <- grep('cmo', colnames(tmp.data), value = TRUE)
  cmo.cols <- which(colnames(tmp.data) %in% cmo.names)
  cmo.data <- as.numeric(as.matrix(tmp.data[,cmo.cols]))
  cmo.mean <- mean(cmo.data)
  
  dbl.names <- grep('dbl', colnames(tmp.data), value = TRUE)
  dbl.cols <- which(colnames(tmp.data) %in% dbl.names)
  dbl.data <- as.numeric(as.matrix(tmp.data[,dbl.cols]))
  dbl.mean <- mean(dbl.data)
  
  fsp.names <- grep('fsp', colnames(tmp.data), value = TRUE)
  fsp.cols <- which(colnames(tmp.data) %in% fsp.names)
  fsp.data <- as.numeric(as.matrix(tmp.data[,fsp.cols]))
  fsp.mean <- mean(fsp.data)
  
  hfr.names <- grep('hfr', colnames(tmp.data), value = TRUE)
  hfr.cols <- which(colnames(tmp.data) %in% hfr.names)
  hfr.data <- as.numeric(as.matrix(tmp.data[,hfr.cols]))
  hfr.mean <- mean(hfr.data)
  
  mci.names <- grep('mci', colnames(tmp.data), value = TRUE)
  mci.cols <- which(colnames(tmp.data) %in% mci.names)
  mci.data <- as.numeric(as.matrix(tmp.data[,mci.cols]))
  mci.mean <- mean(mci.data)
  
  mnr.names <- grep('mnr', colnames(tmp.data), value = TRUE)
  mnr.cols <- which(colnames(tmp.data) %in% mnr.names)
  mnr.data <- as.numeric(as.matrix(tmp.data[,mnr.cols]))
  mnr.mean <- mean(mnr.data)
  
  nci.names <- grep('nci', colnames(tmp.data), value = TRUE)
  nci.cols <- which(colnames(tmp.data) %in% nci.names)
  nci.data <- as.numeric(as.matrix(tmp.data[,nci.cols]))
  nci.mean <- mean(nci.data)
  
  ntg.names <- grep('ntg', colnames(tmp.data), value = TRUE)
  ntg.cols <- which(colnames(tmp.data) %in% ntg.names)
  ntg.data <- as.numeric(as.matrix(tmp.data[,ntg.cols]))
  ntg.mean <- mean(ntg.data)
  
  osp.names <- grep('osp', colnames(tmp.data), value = TRUE)
  osp.cols <- which(colnames(tmp.data) %in% osp.names)
  osp.data <- as.numeric(as.matrix(tmp.data[,osp.cols]))
  osp.mean <- mean(osp.data)
  
  scl.names <- grep('scl', colnames(tmp.data), value = TRUE)
  scl.cols <- which(colnames(tmp.data) %in% scl.names)
  scl.data <- as.numeric(as.matrix(tmp.data[,scl.cols]))
  scl.mean <- mean(scl.data)
  
  som.names <- grep('som', colnames(tmp.data), value = TRUE)
  som.cols <- which(colnames(tmp.data) %in% som.names)
  som.data <- as.numeric(as.matrix(tmp.data[,som.cols]))
  som.mean <- mean(som.data)
  
  stf.names <- grep('stf', colnames(tmp.data), value = TRUE)
  stf.cols <- which(colnames(tmp.data) %in% stf.names)
  stf.data <- as.numeric(as.matrix(tmp.data[,stf.cols]))
  stf.mean <- mean(stf.data)
  
  wto.names <- grep('wto', colnames(tmp.data), value = TRUE)
  wto.cols <- which(colnames(tmp.data) %in% wto.names)
  wto.data <- as.numeric(as.matrix(tmp.data[,wto.cols]))
  wto.mean <- mean(wto.data)
  
  cch.names <- grep('cch', colnames(tmp.data), value = TRUE)
  cch.cols <- which(colnames(tmp.data) %in% cch.names)
  cch.data <- as.numeric(as.matrix(tmp.data[,cch.cols]))
  cch.mean <- mean(cch.data)
  
  cfr.names <- grep('cfr', colnames(tmp.data), value = TRUE)
  cfr.cols <- which(colnames(tmp.data) %in% cfr.names)
  cfr.data <- as.numeric(as.matrix(tmp.data[,cfr.cols]))
  cfr.mean <- mean(cfr.data)
  
  cnr.names <- grep('cnr', colnames(tmp.data), value = TRUE)
  cnr.cols <- which(colnames(tmp.data) %in% cnr.names)
  cnr.data <- as.numeric(as.matrix(tmp.data[,cnr.cols]))
  cnr.mean <- mean(cnr.data)
  
  fnp.names <- grep('fnp', colnames(tmp.data), value = TRUE)
  fnp.cols <- which(colnames(tmp.data) %in% fnp.names)
  fnp.data <- as.numeric(as.matrix(tmp.data[,fnp.cols]))
  fnp.mean <- mean(fnp.data)
  
  gom.names <- grep('gom', colnames(tmp.data), value = TRUE)
  gom.cols <- which(colnames(tmp.data) %in% gom.names)
  gom.data <- as.numeric(as.matrix(tmp.data[,gom.cols]))
  gom.mean <- mean(gom.data)
  
  lhy.names <- grep('lhy', colnames(tmp.data), value = TRUE)
  lhy.cols <- which(colnames(tmp.data) %in% lhy.names)
  lhy.data <- as.numeric(as.matrix(tmp.data[,lhy.cols]))
  lhy.mean <- mean(lhy.data)
  
  mcn.names <- grep('mcn', colnames(tmp.data), value = TRUE)
  mcn.cols <- which(colnames(tmp.data) %in% mcn.names)
  mcn.data <- as.numeric(as.matrix(tmp.data[,mcn.cols]))
  mcn.mean <- mean(mcn.data)
  
  mtg.names <- grep('mtg', colnames(tmp.data), value = TRUE)
  mtg.cols <- which(colnames(tmp.data) %in% mtg.names)
  mtg.data <- as.numeric(as.matrix(tmp.data[,mtg.cols]))
  mtg.mean <- mean(mtg.data)
  
  nir.names <- grep('nir', colnames(tmp.data), value = TRUE)
  nir.cols <- which(colnames(tmp.data) %in% nir.names)
  nir.data <- as.numeric(as.matrix(tmp.data[,nir.cols]))
  nir.mean <- mean(nir.data)
  
  oac.names <- grep('oac', colnames(tmp.data), value = TRUE)
  oac.cols <- which(colnames(tmp.data) %in% oac.names)
  oac.data <- as.numeric(as.matrix(tmp.data[,oac.cols]))
  oac.mean <- mean(oac.data)
  
  pas.names <- grep('pas', colnames(tmp.data), value = TRUE)
  pas.cols <- which(colnames(tmp.data) %in% pas.names)
  pas.data <- as.numeric(as.matrix(tmp.data[,pas.cols]))
  pas.mean <- mean(pas.data)
  
  sgg.names <- grep('sgg', colnames(tmp.data), value = TRUE)
  sgg.cols <- which(colnames(tmp.data) %in% sgg.names)
  sgg.data <- as.numeric(as.matrix(tmp.data[,sgg.cols]))
  sgg.mean <- mean(sgg.data)
  
  soy.names <- grep('soy', colnames(tmp.data), value = TRUE)
  soy.cols <- which(colnames(tmp.data) %in% soy.names)
  soy.data <- as.numeric(as.matrix(tmp.data[,soy.cols]))
  soy.mean <- mean(soy.data)
  
  swm.names <- grep('swm', colnames(tmp.data), value = TRUE)
  swm.cols <- which(colnames(tmp.data) %in% swm.names)
  swm.data <- as.numeric(as.matrix(tmp.data[,swm.cols]))
  swm.mean <- mean(swm.data)
  
  cci.names <- grep('cci', colnames(tmp.data), value = TRUE)
  cci.cols <- which(colnames(tmp.data) %in% cci.names)
  cci.data <- as.numeric(as.matrix(tmp.data[,cci.cols]))
  cci.mean <- mean(cci.data)
  
  cir.names <- grep('cir', colnames(tmp.data), value = TRUE)
  cir.cols <- which(colnames(tmp.data) %in% cir.names)
  cir.data <- as.numeric(as.matrix(tmp.data[,cir.cols]))
  cir.mean <- mean(cir.data)
  
  ctg.names <- grep('ctg', colnames(tmp.data), value = TRUE)
  ctg.cols <- which(colnames(tmp.data) %in% ctg.names)
  ctg.data <- as.numeric(as.matrix(tmp.data[,ctg.cols]))
  ctg.mean <- mean(ctg.data)
  
  for.names <- grep('for', colnames(tmp.data), value = TRUE)
  for.cols <- which(colnames(tmp.data) %in% for.names)
  for.data <- as.numeric(as.matrix(tmp.data[,for.cols]))
  for.mean <- mean(for.data)
  
  gwm.names <- grep('gwm', colnames(tmp.data), value = TRUE)
  gwm.cols <- which(colnames(tmp.data) %in% gwm.names)
  gwm.data <- as.numeric(as.matrix(tmp.data[,gwm.cols]))
  gwm.mean <- mean(gwm.data)
  
  mch.names <- grep('mch', colnames(tmp.data), value = TRUE)
  mch.cols <- which(colnames(tmp.data) %in% mch.names)
  mch.data <- as.numeric(as.matrix(tmp.data[,mch.cols]))
  mch.mean <- mean(mch.data)
  
  mir.names <- grep('mir', colnames(tmp.data), value = TRUE)
  mir.cols <- which(colnames(tmp.data) %in% mir.names)
  mir.data <- as.numeric(as.matrix(tmp.data[,mir.cols]))
  mir.mean <- mean(mir.data)
  
  nch.names <- grep('nch', colnames(tmp.data), value = TRUE)
  nch.cols <- which(colnames(tmp.data) %in% nch.names)
  nch.data <- as.numeric(as.matrix(tmp.data[,nch.cols]))
  nch.mean <- mean(nch.data)
  
  nnr.names <- grep('nnr', colnames(tmp.data), value = TRUE)
  nnr.cols <- which(colnames(tmp.data) %in% nnr.names)
  nnr.data <- as.numeric(as.matrix(tmp.data[,nnr.cols]))
  nnr.mean <- mean(nnr.data)
  
  ohy.names <- grep('ohy', colnames(tmp.data), value = TRUE)
  ohy.cols <- which(colnames(tmp.data) %in% ohy.names)
  ohy.data <- as.numeric(as.matrix(tmp.data[,ohy.cols]))
  ohy.mean <- mean(ohy.data)
  
  sch.names <- grep('sch', colnames(tmp.data), value = TRUE)
  sch.cols <- which(colnames(tmp.data) %in% sch.names)
  sch.data <- as.numeric(as.matrix(tmp.data[,sch.cols]))
  sch.mean <- mean(sch.data)
  
  sho.names <- grep('sho', colnames(tmp.data), value = TRUE)
  sho.cols <- which(colnames(tmp.data) %in% sho.names)
  sho.data <- as.numeric(as.matrix(tmp.data[,sho.cols]))
  sho.mean <- mean(sho.data)
  
  stb.names <- grep('stb', colnames(tmp.data), value = TRUE)
  stb.cols <- which(colnames(tmp.data) %in% stb.names)
  stb.data <- as.numeric(as.matrix(tmp.data[,stb.cols]))
  stb.mean <- mean(stb.data)
  
  wfp.names <- grep('wfp', colnames(tmp.data), value = TRUE)
  wfp.cols <- which(colnames(tmp.data) %in% wfp.names)
  wfp.data <- as.numeric(as.matrix(tmp.data[,wfp.cols]))
  wfp.mean <- mean(wfp.data)
  
  tmp.tab <- matrix(c(aop.mean, cch.mean, cci.mean, ccn.mean, cfr.mean, cir.mean, cmo.mean, cnr.mean,
                      ctg.mean, dbl.mean, fnp.mean, for.mean, fsp.mean, gom.mean, gwm.mean, hfr.mean,
                      lhy.mean, mch.mean, mci.mean, mcn.mean, mir.mean, mnr.mean, mtg.mean, nch.mean,
                      nci.mean, nir.mean, nnr.mean, ntg.mean, oac.mean, ohy.mean, osp.mean, pas.mean, 
                      sch.mean, scl.mean, sgg.mean, sho.mean, som.mean, soy.mean, stb.mean, stf.mean, 
                      swm.mean, wfp.mean, wto.mean), nrow = 43, ncol = 1)
  colnames(tmp.tab) = c('Mean Unit Flow (cfs/sq. mi)')
  rownames(tmp.tab) = c('aop', 'cch', 'cci', 'ccn', 'cfr', 'cir', 'cmo', 'cnr',
                        'ctg', 'dbl', 'fnp', 'for', 'fsp', 'gom', 'gwm', 'hfr',
                        'lhy', 'mch', 'mci', 'mcn', 'mir', 'mnr', 'mtg', 'nch',
                        'nci', 'nir', 'nnr', 'ntg', 'oac', 'ohy', 'osp', 'pas',
                        'sch', 'scl', 'sgg', 'sho', 'som', 'soy', 'stb', 'stf',
                        'swm', 'wfp', 'wto')
  
  tmp.tab <- signif(tmp.tab, digits = 3)
  tmp.tab <- kable(format(tmp.tab, digits = 3, drop0trailing = TRUE))
  return(tmp.tab)
}
