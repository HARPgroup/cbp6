library(knitr)

tab.zero.day.ratios.by.lrseg.land.use = function(tmp.data) {
  aop.names <- grep('aop', colnames(tmp.data), value = TRUE)
  aop.cols <- which(colnames(tmp.data) %in% aop.names)
  aop.data <- as.numeric(as.matrix(tmp.data[,aop.cols]))
  aop.ratio <- length(which(aop.data == 0))/length(aop.data)
  
  ccn.names <- grep('ccn', colnames(tmp.data), value = TRUE)
  ccn.cols <- which(colnames(tmp.data) %in% ccn.names)
  ccn.data <- as.numeric(as.matrix(tmp.data[,ccn.cols]))
  ccn.ratio <- length(which(ccn.data == 0))/length(ccn.data)
  
  cmo.names <- grep('cmo', colnames(tmp.data), value = TRUE)
  cmo.cols <- which(colnames(tmp.data) %in% cmo.names)
  cmo.data <- as.numeric(as.matrix(tmp.data[,cmo.cols]))
  cmo.ratio <- length(which(cmo.data == 0))/length(cmo.data)
  
  dbl.names <- grep('dbl', colnames(tmp.data), value = TRUE)
  dbl.cols <- which(colnames(tmp.data) %in% dbl.names)
  dbl.data <- as.numeric(as.matrix(tmp.data[,dbl.cols]))
  dbl.ratio <- length(which(dbl.data == 0))/length(dbl.data)
  
  fsp.names <- grep('fsp', colnames(tmp.data), value = TRUE)
  fsp.cols <- which(colnames(tmp.data) %in% fsp.names)
  fsp.data <- as.numeric(as.matrix(tmp.data[,fsp.cols]))
  fsp.ratio <- length(which(fsp.data == 0))/length(fsp.data)
  
  hfr.names <- grep('hfr', colnames(tmp.data), value = TRUE)
  hfr.cols <- which(colnames(tmp.data) %in% hfr.names)
  hfr.data <- as.numeric(as.matrix(tmp.data[,hfr.cols]))
  hfr.ratio <- length(which(hfr.data == 0))/length(hfr.data)
  
  mci.names <- grep('mci', colnames(tmp.data), value = TRUE)
  mci.cols <- which(colnames(tmp.data) %in% mci.names)
  mci.data <- as.numeric(as.matrix(tmp.data[,mci.cols]))
  mci.ratio <- length(which(mci.data == 0))/length(mci.data)
  
  mnr.names <- grep('mnr', colnames(tmp.data), value = TRUE)
  mnr.cols <- which(colnames(tmp.data) %in% mnr.names)
  mnr.data <- as.numeric(as.matrix(tmp.data[,mnr.cols]))
  mnr.ratio <- length(which(mnr.data == 0))/length(mnr.data)
  
  nci.names <- grep('nci', colnames(tmp.data), value = TRUE)
  nci.cols <- which(colnames(tmp.data) %in% nci.names)
  nci.data <- as.numeric(as.matrix(tmp.data[,nci.cols]))
  nci.ratio <- length(which(nci.data == 0))/length(nci.data)
  
  ntg.names <- grep('ntg', colnames(tmp.data), value = TRUE)
  ntg.cols <- which(colnames(tmp.data) %in% ntg.names)
  ntg.data <- as.numeric(as.matrix(tmp.data[,ntg.cols]))
  ntg.ratio <- length(which(ntg.data == 0))/length(ntg.data)
  
  osp.names <- grep('osp', colnames(tmp.data), value = TRUE)
  osp.cols <- which(colnames(tmp.data) %in% osp.names)
  osp.data <- as.numeric(as.matrix(tmp.data[,osp.cols]))
  osp.ratio <- length(which(osp.data == 0))/length(osp.data)
  
  scl.names <- grep('scl', colnames(tmp.data), value = TRUE)
  scl.cols <- which(colnames(tmp.data) %in% scl.names)
  scl.data <- as.numeric(as.matrix(tmp.data[,scl.cols]))
  scl.ratio <- length(which(scl.data == 0))/length(scl.data)
  
  som.names <- grep('som', colnames(tmp.data), value = TRUE)
  som.cols <- which(colnames(tmp.data) %in% som.names)
  som.data <- as.numeric(as.matrix(tmp.data[,som.cols]))
  som.ratio <- length(which(som.data == 0))/length(som.data)
  
  stf.names <- grep('stf', colnames(tmp.data), value = TRUE)
  stf.cols <- which(colnames(tmp.data) %in% stf.names)
  stf.data <- as.numeric(as.matrix(tmp.data[,stf.cols]))
  stf.ratio <- length(which(stf.data == 0))/length(stf.data)
  
  wto.names <- grep('wto', colnames(tmp.data), value = TRUE)
  wto.cols <- which(colnames(tmp.data) %in% wto.names)
  wto.data <- as.numeric(as.matrix(tmp.data[,wto.cols]))
  wto.ratio <- length(which(wto.data == 0))/length(wto.data)
  
  cch.names <- grep('cch', colnames(tmp.data), value = TRUE)
  cch.cols <- which(colnames(tmp.data) %in% cch.names)
  cch.data <- as.numeric(as.matrix(tmp.data[,cch.cols]))
  cch.ratio <- length(which(cch.data == 0))/length(cch.data)
  
  cfr.names <- grep('cfr', colnames(tmp.data), value = TRUE)
  cfr.cols <- which(colnames(tmp.data) %in% cfr.names)
  cfr.data <- as.numeric(as.matrix(tmp.data[,cfr.cols]))
  cfr.ratio <- length(which(cfr.data == 0))/length(cfr.data)
  
  cnr.names <- grep('cnr', colnames(tmp.data), value = TRUE)
  cnr.cols <- which(colnames(tmp.data) %in% cnr.names)
  cnr.data <- as.numeric(as.matrix(tmp.data[,cnr.cols]))
  cnr.ratio <- length(which(cnr.data == 0))/length(cnr.data)
  
  fnp.names <- grep('fnp', colnames(tmp.data), value = TRUE)
  fnp.cols <- which(colnames(tmp.data) %in% fnp.names)
  fnp.data <- as.numeric(as.matrix(tmp.data[,fnp.cols]))
  fnp.ratio <- length(which(fnp.data == 0))/length(fnp.data)
  
  gom.names <- grep('gom', colnames(tmp.data), value = TRUE)
  gom.cols <- which(colnames(tmp.data) %in% gom.names)
  gom.data <- as.numeric(as.matrix(tmp.data[,gom.cols]))
  gom.ratio <- length(which(gom.data == 0))/length(gom.data)
  
  lhy.names <- grep('lhy', colnames(tmp.data), value = TRUE)
  lhy.cols <- which(colnames(tmp.data) %in% lhy.names)
  lhy.data <- as.numeric(as.matrix(tmp.data[,lhy.cols]))
  lhy.ratio <- length(which(lhy.data == 0))/length(lhy.data)
  
  mcn.names <- grep('mcn', colnames(tmp.data), value = TRUE)
  mcn.cols <- which(colnames(tmp.data) %in% mcn.names)
  mcn.data <- as.numeric(as.matrix(tmp.data[,mcn.cols]))
  mcn.ratio <- length(which(mcn.data == 0))/length(mcn.data)
  
  mtg.names <- grep('mtg', colnames(tmp.data), value = TRUE)
  mtg.cols <- which(colnames(tmp.data) %in% mtg.names)
  mtg.data <- as.numeric(as.matrix(tmp.data[,mtg.cols]))
  mtg.ratio <- length(which(mtg.data == 0))/length(mtg.data)
  
  nir.names <- grep('nir', colnames(tmp.data), value = TRUE)
  nir.cols <- which(colnames(tmp.data) %in% nir.names)
  nir.data <- as.numeric(as.matrix(tmp.data[,nir.cols]))
  nir.ratio <- length(which(nir.data == 0))/length(nir.data)
  
  oac.names <- grep('oac', colnames(tmp.data), value = TRUE)
  oac.cols <- which(colnames(tmp.data) %in% oac.names)
  oac.data <- as.numeric(as.matrix(tmp.data[,oac.cols]))
  oac.ratio <- length(which(oac.data == 0))/length(oac.data)
  
  pas.names <- grep('pas', colnames(tmp.data), value = TRUE)
  pas.cols <- which(colnames(tmp.data) %in% pas.names)
  pas.data <- as.numeric(as.matrix(tmp.data[,pas.cols]))
  pas.ratio <- length(which(pas.data == 0))/length(pas.data)
  
  sgg.names <- grep('sgg', colnames(tmp.data), value = TRUE)
  sgg.cols <- which(colnames(tmp.data) %in% sgg.names)
  sgg.data <- as.numeric(as.matrix(tmp.data[,sgg.cols]))
  sgg.ratio <- length(which(sgg.data == 0))/length(sgg.data)
  
  soy.names <- grep('soy', colnames(tmp.data), value = TRUE)
  soy.cols <- which(colnames(tmp.data) %in% soy.names)
  soy.data <- as.numeric(as.matrix(tmp.data[,soy.cols]))
  soy.ratio <- length(which(soy.data == 0))/length(soy.data)
  
  swm.names <- grep('swm', colnames(tmp.data), value = TRUE)
  swm.cols <- which(colnames(tmp.data) %in% swm.names)
  swm.data <- as.numeric(as.matrix(tmp.data[,swm.cols]))
  swm.ratio <- length(which(swm.data == 0))/length(swm.data)
  
  cci.names <- grep('cci', colnames(tmp.data), value = TRUE)
  cci.cols <- which(colnames(tmp.data) %in% cci.names)
  cci.data <- as.numeric(as.matrix(tmp.data[,cci.cols]))
  cci.ratio <- length(which(cci.data == 0))/length(cci.data)
  
  cir.names <- grep('cir', colnames(tmp.data), value = TRUE)
  cir.cols <- which(colnames(tmp.data) %in% cir.names)
  cir.data <- as.numeric(as.matrix(tmp.data[,cir.cols]))
  cir.ratio <- length(which(cir.data == 0))/length(cir.data)
  
  ctg.names <- grep('ctg', colnames(tmp.data), value = TRUE)
  ctg.cols <- which(colnames(tmp.data) %in% ctg.names)
  ctg.data <- as.numeric(as.matrix(tmp.data[,ctg.cols]))
  ctg.ratio <- length(which(ctg.data == 0))/length(ctg.data)
  
  for.names <- grep('for', colnames(tmp.data), value = TRUE)
  for.cols <- which(colnames(tmp.data) %in% for.names)
  for.data <- as.numeric(as.matrix(tmp.data[,for.cols]))
  for.ratio <- length(which(for.data == 0))/length(for.data)
  
  gwm.names <- grep('gwm', colnames(tmp.data), value = TRUE)
  gwm.cols <- which(colnames(tmp.data) %in% gwm.names)
  gwm.data <- as.numeric(as.matrix(tmp.data[,gwm.cols]))
  gwm.ratio <- length(which(gwm.data == 0))/length(gwm.data)
  
  mch.names <- grep('mch', colnames(tmp.data), value = TRUE)
  mch.cols <- which(colnames(tmp.data) %in% mch.names)
  mch.data <- as.numeric(as.matrix(tmp.data[,mch.cols]))
  mch.ratio <- length(which(mch.data == 0))/length(mch.data)
  
  mir.names <- grep('mir', colnames(tmp.data), value = TRUE)
  mir.cols <- which(colnames(tmp.data) %in% mir.names)
  mir.data <- as.numeric(as.matrix(tmp.data[,mir.cols]))
  mir.ratio <- length(which(mir.data == 0))/length(mir.data)
  
  nch.names <- grep('nch', colnames(tmp.data), value = TRUE)
  nch.cols <- which(colnames(tmp.data) %in% nch.names)
  nch.data <- as.numeric(as.matrix(tmp.data[,nch.cols]))
  nch.ratio <- length(which(nch.data == 0))/length(nch.data)
  
  nnr.names <- grep('nnr', colnames(tmp.data), value = TRUE)
  nnr.cols <- which(colnames(tmp.data) %in% nnr.names)
  nnr.data <- as.numeric(as.matrix(tmp.data[,nnr.cols]))
  nnr.ratio <- length(which(nnr.data == 0))/length(nnr.data)
  
  ohy.names <- grep('ohy', colnames(tmp.data), value = TRUE)
  ohy.cols <- which(colnames(tmp.data) %in% ohy.names)
  ohy.data <- as.numeric(as.matrix(tmp.data[,ohy.cols]))
  ohy.ratio <- length(which(ohy.data == 0))/length(ohy.data)
  
  sch.names <- grep('sch', colnames(tmp.data), value = TRUE)
  sch.cols <- which(colnames(tmp.data) %in% sch.names)
  sch.data <- as.numeric(as.matrix(tmp.data[,sch.cols]))
  sch.ratio <- length(which(sch.data == 0))/length(sch.data)
  
  sho.names <- grep('sho', colnames(tmp.data), value = TRUE)
  sho.cols <- which(colnames(tmp.data) %in% sho.names)
  sho.data <- as.numeric(as.matrix(tmp.data[,sho.cols]))
  sho.ratio <- length(which(sho.data == 0))/length(sho.data)
  
  stb.names <- grep('stb', colnames(tmp.data), value = TRUE)
  stb.cols <- which(colnames(tmp.data) %in% stb.names)
  stb.data <- as.numeric(as.matrix(tmp.data[,stb.cols]))
  stb.ratio <- length(which(stb.data == 0))/length(stb.data)
  
  wfp.names <- grep('wfp', colnames(tmp.data), value = TRUE)
  wfp.cols <- which(colnames(tmp.data) %in% wfp.names)
  wfp.data <- as.numeric(as.matrix(tmp.data[,wfp.cols]))
  wfp.ratio <- length(which(wfp.data == 0))/length(wfp.data)
  
  tmp.tab <- matrix(c(aop.ratio, cch.ratio, cci.ratio, ccn.ratio, cfr.ratio, cir.ratio, cmo.ratio, cnr.ratio,
                      ctg.ratio, dbl.ratio, fnp.ratio, for.ratio, fsp.ratio, gom.ratio, gwm.ratio, hfr.ratio,
                      lhy.ratio, mch.ratio, mci.ratio, mcn.ratio, mir.ratio, mnr.ratio, mtg.ratio, nch.ratio,
                      nci.ratio, nir.ratio, nnr.ratio, ntg.ratio, oac.ratio, ohy.ratio, osp.ratio, pas.ratio, 
                      sch.ratio, scl.ratio, sgg.ratio, sho.ratio, som.ratio, soy.ratio, stb.ratio, stf.ratio, 
                      swm.ratio, wfp.ratio, wto.ratio), nrow = 43, ncol = 1)
  colnames(tmp.tab) = c('Ratio of Days with Zero Flow to Total Days')
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
